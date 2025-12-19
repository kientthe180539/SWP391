package Controller.Booking.Customer;

import DAL.Booking.DAOBooking;
import DAL.Feedback.DAOFeedback;
import DAL.Guest.DAOGuest;
import Model.Booking;
import Model.Feedback;
import Model.Room;
import Model.RoomType;
import Model.User;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "CustomerBookingController", urlPatterns = { "/booking", "/booking_confirm", "/my_booking" })
public class BookingController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        switch (path) {
            case "/booking" -> {
                HttpSession session = request.getSession();
                User currentUser = (User) session.getAttribute("currentUser");

                if (currentUser == null) {
                    String queryString = request.getQueryString();
                    String redirectUrl = "booking";
                    if (queryString != null) {
                        redirectUrl += "?" + queryString;
                    }
                    response.sendRedirect(request.getContextPath() + "/login?redirect="
                            + java.net.URLEncoder.encode(redirectUrl, "UTF-8"));
                    return;
                }

                // Đã đăng nhập -> lấy thông tin phòng
                String roomIdParam = request.getParameter("roomId");
                if (roomIdParam == null || roomIdParam.isBlank()) {
                    response.sendRedirect("rooms");
                    return;
                }

                try {
                    int roomId = Integer.parseInt(roomIdParam);
                    Map.Entry<Room, RoomType> entry = DAOGuest.INSTANCE.getRoomDetailWithType(roomId);
                    if (entry == null) {
                        response.sendRedirect("rooms");
                        return;
                    }
                    request.setAttribute("room", entry.getKey());
                    request.setAttribute("roomType", entry.getValue());
                    request.getRequestDispatcher("Views/Booking/Customer/Booking.jsp").forward(request, response);
                } catch (NumberFormatException e) {
                    response.sendRedirect("rooms");
                }
            }

            case "/booking_confirm" -> {
                HttpSession session = request.getSession();
                User currentUser = (User) session.getAttribute("currentUser");

                if (currentUser == null) {
                    response.sendRedirect(request.getContextPath() + "/login");
                    return;
                }

                // Get latest booking for this customer
                Booking latestBooking = DAOBooking.INSTANCE.getLatestBookingByCustomerId(currentUser.getUserId());

                if (latestBooking != null) {
                    // Get booking with room details
                    Map<String, Object> bookingDetails = DAOBooking.INSTANCE
                            .getBookingWithRoomDetails(latestBooking.getBookingId());
                    request.setAttribute("bookingDetails", bookingDetails);
                    request.setAttribute("booking", latestBooking);
                }

                request.getRequestDispatcher("Views/Booking/Customer/BookingConfirm.jsp").forward(request, response);
            }

            case "/my_booking" -> {
                HttpSession session = request.getSession();
                User currentUser = (User) session.getAttribute("currentUser");

                if (currentUser == null) {
                    response.sendRedirect(request.getContextPath() + "/login");
                    return;
                }

                // Get all bookings for this customer
                List<Booking> bookings = DAOBooking.INSTANCE.getBookingsByCustomerId(currentUser.getUserId());
                request.setAttribute("bookings", bookings);

                request.getRequestDispatcher("Views/Booking/Customer/MyBooking.jsp").forward(request, response);
            }

            default ->
                response.sendError(404);
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

        String action = request.getParameter("action");

        if (action == null) {
            // Default action: create booking
            handleCreateBooking(request, response, currentUser);
        } else {
            switch (action) {
                case "cancel" ->
                    handleCancelBooking(request, response, currentUser);
                case "feedback" ->
                    handleFeedbackSubmission(request, response, currentUser);
                default -> {
                    response.sendError(400, "Unknown action");
                }
            }
        }
    }

    private void handleCreateBooking(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        try {
            // Get form parameters
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            String checkinDateStr = request.getParameter("checkinDate");
            String checkoutDateStr = request.getParameter("checkoutDate");
            int numGuests = Integer.parseInt(request.getParameter("numGuests"));

            // Parse dates
            java.time.LocalDate checkinDate = java.time.LocalDate.parse(checkinDateStr);
            java.time.LocalDate checkoutDate = java.time.LocalDate.parse(checkoutDateStr);

            // Validate dates
            if (!checkoutDate.isAfter(checkinDate)) {
                request.setAttribute("type", "error");
                request.setAttribute("mess", "Check-out date must be after check-in date!");
                request.getRequestDispatcher("Views/Booking/Customer/Booking.jsp").forward(request, response);
                return;
            }

            // Check availability
            boolean isAvailable = DAOBooking.INSTANCE.isRoomAvailable(roomId, checkinDate, checkoutDate);
            if (!isAvailable) {
                request.setAttribute("type", "error");
                request.setAttribute("mess", "Room is not available for the selected dates!");

                // Re-fetch room info to render page correctly
                Map.Entry<Room, RoomType> entry = DAOGuest.INSTANCE.getRoomDetailWithType(roomId);
                if (entry != null) {
                    request.setAttribute("room", entry.getKey());
                    request.setAttribute("roomType", entry.getValue());
                }

                request.getRequestDispatcher("Views/Booking/Customer/Booking.jsp").forward(request, response);
                return;
            }

            // Get room details to calculate total amount
            Map.Entry<Room, RoomType> entry = DAOGuest.INSTANCE.getRoomDetailWithType(roomId);
            if (entry == null) {
                response.sendRedirect("rooms");
                return;
            }

            RoomType roomType = entry.getValue();
            long nights = java.time.temporal.ChronoUnit.DAYS.between(checkinDate, checkoutDate);
            java.math.BigDecimal totalAmount = roomType.getBasePrice().multiply(java.math.BigDecimal.valueOf(nights));

            // Create booking object
            Booking booking = new Booking();
            booking.setCustomerId(currentUser.getUserId());
            booking.setRoomId(roomId);
            booking.setCheckinDate(checkinDate);
            booking.setCheckoutDate(checkoutDate);
            booking.setNumGuests(numGuests);
            booking.setStatus(Booking.Status.PENDING);
            booking.setTotalAmount(totalAmount);
            booking.setCreatedBy(currentUser.getUserId());

            // Save to database
            boolean success = DAOBooking.INSTANCE.createBooking(booking);

            if (success) {
                // Redirect to confirmation page
                response.sendRedirect(request.getContextPath() + "/booking_confirm");
            } else {
                request.setAttribute("type", "error");
                request.setAttribute("mess", "Failed to create booking. Please try again.");
                request.getRequestDispatcher("Views/Booking/Customer/Booking.jsp").forward(request, response);
            }

        } catch (NumberFormatException | java.time.DateTimeException e) {
            request.setAttribute("type", "error");
            request.setAttribute("mess", "Invalid data. Please try again.");
            request.getRequestDispatcher("Views/Booking/Customer/Booking.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("type", "error");
            request.setAttribute("mess", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("Views/Booking/Customer/Booking.jsp").forward(request, response);
        }
    }

    private void handleCancelBooking(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        try {
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));

            // Verify this booking belongs to current user
            Booking booking = DAOBooking.INSTANCE.getBookingById(bookingId);
            if (booking == null || !booking.getCustomerId().equals(currentUser.getUserId())) {
                request.setAttribute("type", "error");
                request.setAttribute("mess", "Invalid booking!");
                request.getRequestDispatcher("Views/Booking/Customer/MyBooking.jsp").forward(request, response);
                return;
            }

            // Cancel the booking
            boolean success = DAOBooking.INSTANCE.cancelBooking(bookingId);

            if (success) {
                request.setAttribute("type", "success");
                request.setAttribute("mess", "Booking cancelled successfully!");
            } else {
                request.setAttribute("type", "error");
                request.setAttribute("mess", "Cannot cancel this booking. Only pending bookings can be cancelled.");
            }

            request.getRequestDispatcher("Views/Booking/Customer/MyBooking.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("type", "error");
            request.setAttribute("mess", "Error cancelling booking: " + e.getMessage());
            request.getRequestDispatcher("Views/Booking/Customer/MyBooking.jsp").forward(request, response);
        }
    }

    private void handleFeedbackSubmission(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        try {
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");

            // Verify this booking belongs to current user
            Booking booking = DAOBooking.INSTANCE.getBookingById(bookingId);
            if (booking == null || !booking.getCustomerId().equals(currentUser.getUserId())) {
                request.setAttribute("type", "error");
                request.setAttribute("mess", "Invalid booking!");
                request.getRequestDispatcher("Views/Booking/Customer/MyBooking.jsp").forward(request, response);
                return;
            }

            // Create new feedback
            Feedback feedback = new Feedback();
            feedback.setBookingId(bookingId);
            feedback.setCustomerId(currentUser.getUserId());
            feedback.setRating(rating);
            feedback.setComment(comment);
            boolean success = DAOFeedback.INSTANCE.createFeedback(feedback);

            if (success) {
                request.setAttribute("type", "success");
                request.setAttribute("mess", "Feedback submitted successfully!");
            } else {
                request.setAttribute("type", "error");
                request.setAttribute("mess", "Failed to submit feedback.");
            }

            request.getRequestDispatcher("Views/Booking/Customer/MyBooking.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("type", "error");
            request.setAttribute("mess", "Error submitting feedback: " + e.getMessage());
            request.getRequestDispatcher("Views/Booking/Customer/MyBooking.jsp").forward(request, response);
        }
    }

}
