package Controller.Payment;

import DAL.Booking.DAOBooking;
import DAL.Payment.DAOPayment;
import DAL.Wallet.DAOWallet;
import Model.Booking;
import Model.Payment;
import Model.Payment.PaymentMethod;
import Model.Payment.PaymentStatus;
import Model.User;
import Model.Wallet;
import Utils.SendEmail;

import java.io.IOException;
import java.text.NumberFormat;
import java.util.Locale;
import java.util.Map;
import java.util.UUID;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "PaymentController", urlPatterns = { "/payment", "/payment/process", "/payment/callback" })
public class PaymentController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String path = request.getServletPath();

        switch (path) {
            case "/payment" -> showPaymentPage(request, response, currentUser);
            case "/payment/callback" -> handlePaymentCallback(request, response);
            default -> response.sendError(404);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String path = request.getServletPath();

        switch (path) {
            case "/payment/process" -> processPayment(request, response, currentUser);
            default -> response.sendError(404);
        }
    }

    private void showPaymentPage(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {

        String bookingIdStr = request.getParameter("bookingId");

        if (bookingIdStr == null || bookingIdStr.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/my_booking");
            return;
        }

        try {
            int bookingId = Integer.parseInt(bookingIdStr);

            // Get booking details
            Booking booking = DAOBooking.INSTANCE.getBookingById(bookingId);

            if (booking == null) {
                request.setAttribute("error", "Booking not found!");
                response.sendRedirect(request.getContextPath() + "/my_booking");
                return;
            }

            // Verify booking belongs to current user
            if (!booking.getCustomerId().equals(currentUser.getUserId())) {
                request.setAttribute("error", "Unauthorized access!");
                response.sendRedirect(request.getContextPath() + "/my_booking");
                return;
            }

            // Check if already paid
            Payment existingPayment = DAOPayment.INSTANCE.getPaymentByBookingId(bookingId);
            if (existingPayment != null && existingPayment.isCompleted()) {
                request.setAttribute("info", "This booking has already been paid.");
                response.sendRedirect(request.getContextPath() + "/booking_confirm");
                return;
            }

            // Get booking with room details
            Map<String, Object> bookingDetails = DAOBooking.INSTANCE.getBookingWithRoomDetails(bookingId);

            // Get user's wallet for wallet payment option
            Wallet wallet = DAOWallet.INSTANCE.getOrCreateWallet(currentUser.getUserId());

            request.setAttribute("booking", booking);
            request.setAttribute("bookingDetails", bookingDetails);
            request.setAttribute("existingPayment", existingPayment);
            request.setAttribute("paymentMethods", PaymentMethod.values());
            request.setAttribute("wallet", wallet);

            request.getRequestDispatcher("/Views/Payment/Payment.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/my_booking");
        }
    }

    private void processPayment(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {

        try {
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            String paymentMethodStr = request.getParameter("paymentMethod");

            // Get booking
            Booking booking = DAOBooking.INSTANCE.getBookingById(bookingId);

            if (booking == null || !booking.getCustomerId().equals(currentUser.getUserId())) {
                request.setAttribute("error", "Invalid booking!");
                response.sendRedirect(request.getContextPath() + "/my_booking");
                return;
            }

            // Check if booking is PENDING
            if (booking.getStatus() != Booking.Status.PENDING) {
                request.setAttribute("error", "This booking cannot be paid. Status: " + booking.getStatus());
                response.sendRedirect(request.getContextPath() + "/my_booking");
                return;
            }

            // Check for existing pending payment
            Payment existingPayment = DAOPayment.INSTANCE.getPaymentByBookingId(bookingId);

            Payment payment;
            if (existingPayment != null && existingPayment.isPending()) {
                payment = existingPayment;
            } else {
                // Create new payment record
                payment = new Payment();
                payment.setBookingId(bookingId);
                payment.setAmount(booking.getTotalAmount());
                payment.setPaymentMethod(paymentMethodStr);
                payment.setPaymentStatus(PaymentStatus.PENDING);

                if (!DAOPayment.INSTANCE.createPayment(payment)) {
                    request.setAttribute("error", "Failed to create payment record!");
                    request.getRequestDispatcher("/Views/Payment/Payment.jsp").forward(request, response);
                    return;
                }
            }

            // Handle WALLET payment specially
            if ("WALLET".equals(paymentMethodStr)) {
                Wallet wallet = DAOWallet.INSTANCE.getWalletByUserId(currentUser.getUserId());

                if (wallet == null || !wallet.hasSufficientBalance(booking.getTotalAmount())) {
                    request.setAttribute("error",
                            "Insufficient wallet balance! Please top up or choose another payment method.");
                    request.setAttribute("booking", booking);
                    request.setAttribute("bookingDetails", DAOBooking.INSTANCE.getBookingWithRoomDetails(bookingId));
                    request.setAttribute("paymentMethods", PaymentMethod.values());
                    request.setAttribute("wallet", wallet);
                    request.getRequestDispatcher("/Views/Payment/Payment.jsp").forward(request, response);
                    return;
                }

                // Process wallet payment
                String transactionId = "WALLET_" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
                String description = "Room booking payment #" + bookingId;

                boolean walletSuccess = DAOWallet.INSTANCE.processPayment(
                        currentUser.getUserId(),
                        booking.getTotalAmount(),
                        bookingId,
                        description);

                if (walletSuccess) {
                    // Complete the payment record
                    DAOPayment.INSTANCE.completePayment(payment.getPaymentId(), transactionId);

                    // Auto-assign CHECKIN inspection (1 day before check-in)
                    DAL.Housekeeping.DAOHousekeeping.INSTANCE.autoAssignTask(bookingId,
                            Model.HousekeepingTask.TaskType.INSPECTION, "CHECKIN",
                            booking.getCheckinDate().minusDays(1));

                    // Send confirmation email
                    sendBookingConfirmationEmail(currentUser, booking, transactionId, "Luxe Wallet");

                    HttpSession session = request.getSession();
                    session.setAttribute("paymentSuccess", true);
                    session.setAttribute("transactionId", transactionId);
                    session.setAttribute("paymentMethod", "Luxe Wallet");
                    response.sendRedirect(request.getContextPath() + "/booking_confirm");
                    return;
                } else {
                    request.setAttribute("error", "Wallet payment failed. Please try again.");
                    request.setAttribute("booking", booking);
                    request.setAttribute("bookingDetails", DAOBooking.INSTANCE.getBookingWithRoomDetails(bookingId));
                    request.setAttribute("paymentMethods", PaymentMethod.values());
                    request.setAttribute("wallet", DAOWallet.INSTANCE.getWalletByUserId(currentUser.getUserId()));
                    request.getRequestDispatcher("/Views/Payment/Payment.jsp").forward(request, response);
                    return;
                }
            }

            // Simulate payment processing for other methods
            // In real implementation, redirect to payment gateway (MOMO, VNPay, etc.)
            String transactionId = "TXN_" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();

            // Simulate successful payment
            boolean paymentSuccess = DAOPayment.INSTANCE.completePayment(payment.getPaymentId(), transactionId);

            if (paymentSuccess) {
                // Payment successful - trigger will update booking to CONFIRMED

                // Auto-assign CHECKIN inspection (1 day before check-in)
                DAL.Housekeeping.DAOHousekeeping.INSTANCE.autoAssignTask(bookingId,
                        Model.HousekeepingTask.TaskType.INSPECTION, "CHECKIN",
                        booking.getCheckinDate().minusDays(1));

                // Send confirmation email
                sendBookingConfirmationEmail(currentUser, booking, transactionId, paymentMethodStr);

                HttpSession session = request.getSession();
                session.setAttribute("paymentSuccess", true);
                session.setAttribute("transactionId", transactionId);
                response.sendRedirect(request.getContextPath() + "/booking_confirm");
            } else {
                request.setAttribute("error", "Payment processing failed. Please try again.");
                request.setAttribute("booking", booking);
                request.setAttribute("bookingDetails", DAOBooking.INSTANCE.getBookingWithRoomDetails(bookingId));
                request.setAttribute("paymentMethods", PaymentMethod.values());
                request.setAttribute("wallet", DAOWallet.INSTANCE.getWalletByUserId(currentUser.getUserId()));
                request.getRequestDispatcher("/Views/Payment/Payment.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/my_booking");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/Views/Payment/Payment.jsp").forward(request, response);
        }
    }

    private void handlePaymentCallback(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Handle callback from payment gateway (MOMO, VNPay, etc.)
        // This would be implemented when integrating with real payment gateways

        String transactionId = request.getParameter("transactionId");
        String status = request.getParameter("status");
        String bookingIdStr = request.getParameter("bookingId");

        if (transactionId != null && status != null && bookingIdStr != null) {
            try {
                int bookingId = Integer.parseInt(bookingIdStr);
                Payment payment = DAOPayment.INSTANCE.getPaymentByBookingId(bookingId);

                if (payment != null && payment.isPending()) {
                    if ("success".equalsIgnoreCase(status)) {
                        DAOPayment.INSTANCE.completePayment(payment.getPaymentId(), transactionId);

                        // Fetch booking to get check-in date
                        Booking b = DAOBooking.INSTANCE.getBookingById(bookingId);
                        if (b != null) {
                            DAL.Housekeeping.DAOHousekeeping.INSTANCE.autoAssignTask(bookingId,
                                    Model.HousekeepingTask.TaskType.INSPECTION, "CHECKIN",
                                    b.getCheckinDate().minusDays(1));
                        }
                    } else {
                        DAOPayment.INSTANCE.updatePaymentStatus(payment.getPaymentId(), PaymentStatus.FAILED,
                                transactionId);
                    }
                }

                response.sendRedirect(request.getContextPath() + "/booking_confirm");
                return;
            } catch (NumberFormatException e) {
                // Invalid booking ID
            }
        }

        response.sendRedirect(request.getContextPath() + "/my_booking");
    }

    /**
     * Send booking confirmation email to customer
     */
    private void sendBookingConfirmationEmail(User customer, Booking booking, String transactionId,
            String paymentMethod) {
        try {
            // Validate customer email
            if (customer == null || customer.getEmail() == null || customer.getEmail().isBlank()) {
                System.err.println("Cannot send email: Customer or email is null/empty");
                return;
            }

            String customerEmail = customer.getEmail();
            System.out.println("Preparing to send booking confirmation email to: " + customerEmail);

            // Get booking details for email
            Map<String, Object> bookingDetails = DAOBooking.INSTANCE.getBookingWithRoomDetails(booking.getBookingId());
            @SuppressWarnings("unchecked")
            Map<String, Object> roomDetails = bookingDetails != null
                    ? (Map<String, Object>) bookingDetails.get("roomDetails")
                    : null;

            // Format currency
            NumberFormat currencyFormat = NumberFormat.getInstance(new Locale("vi", "VN"));
            String formattedAmount = currencyFormat.format(booking.getTotalAmount()) + " VND";

            // Calculate nights
            long nights = java.time.temporal.ChronoUnit.DAYS.between(booking.getCheckinDate(),
                    booking.getCheckoutDate());

            // Build email content
            String emailContent = buildBookingConfirmationEmail(
                    customer.getFullName(),
                    booking.getBookingId(),
                    transactionId,
                    roomDetails != null ? (String) roomDetails.get("roomNumber") : "N/A",
                    roomDetails != null ? (String) roomDetails.get("typeName") : "N/A",
                    booking.getCheckinDate().toString(),
                    booking.getCheckoutDate().toString(),
                    nights,
                    booking.getNumGuests(),
                    formattedAmount,
                    paymentMethod);

            String subject = "🏨 Xác nhận đặt phòng #" + booking.getBookingId() + " - Hotel Manager";

            // Send email asynchronously to not block the response
            final String finalEmail = customerEmail;
            new Thread(() -> {
                try {
                    System.out.println("Sending email to: " + finalEmail);
                    SendEmail.sendMail(finalEmail, subject, emailContent);
                    System.out.println("Email sent successfully to: " + finalEmail);
                } catch (Exception e) {
                    System.err.println("Error sending email to " + finalEmail + ": " + e.getMessage());
                    e.printStackTrace();
                }
            }).start();

            System.out.println("Booking confirmation email queued for: " + customerEmail);

        } catch (Exception e) {
            // Log error but don't fail the payment
            System.err.println("Failed to prepare booking confirmation email: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Build HTML email template for booking confirmation
     */
    private String buildBookingConfirmationEmail(String customerName, int bookingId, String transactionId,
            String roomNumber, String roomType, String checkinDate, String checkoutDate,
            long nights, int guests, String totalAmount, String paymentMethod) {

        StringBuilder sb = new StringBuilder();
        sb.append("<!DOCTYPE html>");
        sb.append("<html><head>");
        sb.append("<meta charset='UTF-8'>");
        sb.append("<meta name='viewport' content='width=device-width, initial-scale=1.0'>");
        sb.append("</head>");
        sb.append(
                "<body style='margin: 0; padding: 0; font-family: Segoe UI, Tahoma, Geneva, Verdana, sans-serif; background-color: #f5f5f5;'>");

        // Main table
        sb.append(
                "<table width='100%' cellpadding='0' cellspacing='0' style='background-color: #f5f5f5; padding: 40px 20px;'>");
        sb.append("<tr><td align='center'>");
        sb.append(
                "<table width='600' cellpadding='0' cellspacing='0' style='background-color: #ffffff; border-radius: 16px; overflow: hidden; box-shadow: 0 4px 20px rgba(0,0,0,0.1);'>");

        // Header
        sb.append(
                "<tr><td style='background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 40px 30px; text-align: center;'>");
        sb.append("<h1 style='color: #ffffff; margin: 0; font-size: 28px;'>🏨 Hotel Manager</h1>");
        sb.append(
                "<p style='color: rgba(255,255,255,0.9); margin: 10px 0 0 0; font-size: 16px;'>Booking Confirmation</p>");
        sb.append("</td></tr>");

        // Success Icon
        sb.append("<tr><td style='padding: 30px 30px 0 30px; text-align: center;'>");
        sb.append(
                "<div style='width: 80px; height: 80px; background: #d4edda; border-radius: 50%; display: inline-block; line-height: 80px; margin-bottom: 20px;'>");
        sb.append("<span style='font-size: 40px;'>✓</span></div>");
        sb.append("<h2 style='color: #28a745; margin: 0; font-size: 24px;'>Payment Successful!</h2>");
        sb.append("</td></tr>");

        // Greeting
        sb.append("<tr><td style='padding: 20px 30px;'>");
        sb.append("<p style='color: #333; font-size: 16px; line-height: 1.6; margin: 0;'>");
        sb.append("Dear <strong>").append(customerName).append("</strong>,<br><br>");
        sb.append("Thank you for booking with Hotel Manager! Here are your booking details:");
        sb.append("</p></td></tr>");

        // Booking Details Table
        sb.append("<tr><td style='padding: 0 30px 30px 30px;'>");
        sb.append(
                "<table width='100%' cellpadding='0' cellspacing='0' style='background: #f8f9fa; border-radius: 12px;'>");
        sb.append("<tr><td style='padding: 20px;'>");
        sb.append("<table width='100%' cellpadding='8' cellspacing='0'>");

        // Details rows
        sb.append("<tr><td style='color: #666; font-size: 14px; border-bottom: 1px solid #e9ecef;'>Booking ID</td>");
        sb.append(
                "<td style='color: #333; font-size: 14px; font-weight: bold; text-align: right; border-bottom: 1px solid #e9ecef;'>#")
                .append(bookingId).append("</td></tr>");

        sb.append(
                "<tr><td style='color: #666; font-size: 14px; border-bottom: 1px solid #e9ecef;'>Transaction ID</td>");
        sb.append(
                "<td style='color: #333; font-size: 14px; font-weight: bold; text-align: right; border-bottom: 1px solid #e9ecef;'>")
                .append(transactionId).append("</td></tr>");

        sb.append("<tr><td style='color: #666; font-size: 14px; border-bottom: 1px solid #e9ecef;'>Room</td>");
        sb.append(
                "<td style='color: #333; font-size: 14px; font-weight: bold; text-align: right; border-bottom: 1px solid #e9ecef;'>")
                .append(roomNumber).append(" - ").append(roomType).append("</td></tr>");

        sb.append(
                "<tr><td style='color: #666; font-size: 14px; border-bottom: 1px solid #e9ecef;'>Check-in Date</td>");
        sb.append("<td style='color: #333; font-size: 14px; text-align: right; border-bottom: 1px solid #e9ecef;'>📅 ")
                .append(checkinDate).append("</td></tr>");

        sb.append(
                "<tr><td style='color: #666; font-size: 14px; border-bottom: 1px solid #e9ecef;'>Check-out Date</td>");
        sb.append("<td style='color: #333; font-size: 14px; text-align: right; border-bottom: 1px solid #e9ecef;'>📅 ")
                .append(checkoutDate).append("</td></tr>");

        sb.append("<tr><td style='color: #666; font-size: 14px; border-bottom: 1px solid #e9ecef;'>Duration</td>");
        sb.append("<td style='color: #333; font-size: 14px; text-align: right; border-bottom: 1px solid #e9ecef;'>🌙 ")
                .append(nights).append(" night(s)</td></tr>");

        sb.append("<tr><td style='color: #666; font-size: 14px; border-bottom: 1px solid #e9ecef;'>Guests</td>");
        sb.append("<td style='color: #333; font-size: 14px; text-align: right; border-bottom: 1px solid #e9ecef;'>👥 ")
                .append(guests).append(" guest(s)</td></tr>");

        sb.append(
                "<tr><td style='color: #666; font-size: 14px; border-bottom: 1px solid #e9ecef;'>Payment Method</td>");
        sb.append("<td style='color: #333; font-size: 14px; text-align: right; border-bottom: 1px solid #e9ecef;'>💳 ")
                .append(paymentMethod).append("</td></tr>");

        sb.append(
                "<tr><td style='color: #333; font-size: 16px; font-weight: bold; padding-top: 15px;'>Total Amount</td>");
        sb.append(
                "<td style='color: #28a745; font-size: 18px; font-weight: bold; text-align: right; padding-top: 15px;'>")
                .append(totalAmount).append("</td></tr>");

        sb.append("</table></td></tr></table></td></tr>");

        sb.append("<tr><td style='padding: 0 30px 30px 30px;'>");
        sb.append(
                "<div style='background: #fff3cd; border-left: 4px solid #ffc107; padding: 15px; border-radius: 8px;'>");
        sb.append("<p style='color: #856404; font-size: 14px; margin: 0; line-height: 1.6;'>");
        sb.append("<strong>📝 Important Notes:</strong><br>");
        sb.append("• Please arrive before 2:00 PM on check-in day<br>");
        sb.append("• Bring your valid ID for check-in<br>");
        sb.append("• Contact our hotline for assistance: <strong>1900-xxxx</strong>");
        sb.append("</p></div></td></tr>");

        // Footer
        sb.append(
                "<tr><td style='background: #f8f9fa; padding: 25px 30px; text-align: center; border-top: 1px solid #e9ecef;'>");
        sb.append(
                "<p style='color: #666; font-size: 14px; margin: 0 0 10px 0;'>Thank you for choosing Hotel Manager!</p>");
        sb.append("<p style='color: #999; font-size: 12px; margin: 0;'>© 2024 Hotel Manager. All rights reserved.</p>");
        sb.append("</td></tr>");

        sb.append("</table></td></tr></table>");
        sb.append("</body></html>");

        return sb.toString();
    }
}
