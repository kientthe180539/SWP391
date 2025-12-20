package Controller.Customer;

import DAL.Authen.DAOAuthen;
import Model.User;
import Model.Booking;
import Model.RoomInspection;
import Utils.SendEmail;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "CustomerController", urlPatterns = {"/customer/profile", "/customer/amenities"})
public class CustomerController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        switch (path) {
            case "/customer/profile" -> {
                // Kiểm tra đăng nhập
                HttpSession session = request.getSession();
                User currentUser = (User) session.getAttribute("currentUser");

                if (currentUser == null) {
                    response.sendRedirect(request.getContextPath() + "/login");
                    return;
                }

                // User đã đăng nhập, forward đến trang profile
                request.getRequestDispatcher("/Views/Customer/Profile.jsp").forward(request, response);
            }

            case "/customer/amenities" -> {
                HttpSession session = request.getSession();
                User currentUser = (User) session.getAttribute("currentUser");

                if (currentUser == null) {
                    response.sendRedirect(request.getContextPath() + "/login");
                    return;
                }

                // Get active booking (CHECKED_IN)
                DAL.Booking.DAOBooking daoBooking = DAL.Booking.DAOBooking.INSTANCE;
                Booking booking = daoBooking.getActiveBookingByCustomerId(currentUser.getUserId());

                if (booking != null) {
                    // Get inspection details for this booking (CHECKIN type)
                    DAL.RoomInspectionDAO daoInspection = new DAL.RoomInspectionDAO();
                    RoomInspection inspection = daoInspection
                            .getInspectionByBookingAndType(booking.getBookingId(), "CHECKIN");

                    if (inspection != null) {
                        request.setAttribute("inspection", inspection);
                        request.setAttribute("amenityList", inspection.getDetails());
                    } else {
                        // Fallback: Get default amenities for the room type
                        DAL.AmenityDAO daoAmenity = new DAL.AmenityDAO();
                        if (booking.getRoom() != null) {
                            java.util.List<Model.RoomTypeAmenity> defaultAmenities = daoAmenity
                                    .getAmenitiesByRoomType(booking.getRoom().getRoomTypeId());

                            java.util.List<Model.InspectionDetail> details = new java.util.ArrayList<>();
                            for (Model.RoomTypeAmenity rta : defaultAmenities) {
                                Model.InspectionDetail detail = new Model.InspectionDetail();
                                detail.setAmenity(rta.getAmenity());
                                detail.setQuantityActual(rta.getDefaultQuantity());
                                detail.setConditionStatus("OK");
                                details.add(detail);
                            }
                            request.setAttribute("amenityList", details);
                            request.setAttribute("isDefaultList", true);
                        }
                    }
                    request.setAttribute("booking", booking);
                }

                request.getRequestDispatcher("/Views/Customer/AmenityList.jsp").forward(request, response);
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
            request.setAttribute("type", "error");
            request.setAttribute("mess", "Invalid action!");
            request.getRequestDispatcher("/Views/Customer/Profile.jsp").forward(request, response);
            return;
        }

        switch (action) {
            case "update_profile" ->
                handleUpdateProfile(request, response, currentUser, session);
            case "change_password" ->
                handleChangePassword(request, response, currentUser, session);
            case "report_issue" ->
                handleReportIssue(request, response, currentUser, session);
            case "confirm_amenities" ->
                handleConfirmAmenities(request, response, currentUser, session);
            default -> {
                request.setAttribute("type", "error");
                request.setAttribute("mess", "Unknown action!");
                request.getRequestDispatcher("/Views/Customer/Profile.jsp").forward(request, response);
            }
        }
    }

    private void handleReportIssue(HttpServletRequest request, HttpServletResponse response,
            User currentUser, HttpSession session)
            throws ServletException, IOException {
        try {
            String issueTypeStr = request.getParameter("issueType");
            String description = request.getParameter("description");
            String bookingIdStr = request.getParameter("bookingId");
            String roomIdStr = request.getParameter("roomId");

            // Validate
            if (description == null || description.isBlank()) {
                request.setAttribute("type", "error");
                request.setAttribute("mess", "Please provide a description of the issue.");
                request.getRequestDispatcher("/Views/Customer/AmenityList.jsp").forward(request, response);
                return;
            }

            Model.IssueReport report = new Model.IssueReport();
            report.setReportedBy(currentUser.getUserId());
            report.setDescription(description.trim());
            report.setIssueType(issueTypeStr);
            report.setStatus(Model.IssueReport.IssueStatus.NEW);

            if (bookingIdStr != null && !bookingIdStr.isEmpty()) {
                report.setBookingId(Integer.parseInt(bookingIdStr));
            }

            if (roomIdStr != null && !roomIdStr.isEmpty()) {
                report.setRoomId(Integer.parseInt(roomIdStr));
            } else {
                // Try to get room from active booking if not provided
                DAL.Booking.DAOBooking daoBooking = DAL.Booking.DAOBooking.INSTANCE;
                Booking booking = daoBooking.getActiveBookingByCustomerId(currentUser.getUserId());
                if (booking != null) {
                    report.setRoomId(booking.getRoomId());
                    report.setBookingId(booking.getBookingId());
                } else {
                    throw new IllegalArgumentException("No active room found to report issue for.");
                }
            }

            boolean success = DAL.IssueReportDAO.INSTANCE.createIssueReport(report);

            if (success) {
                request.setAttribute("type", "success");
                request.setAttribute("mess", "Issue reported successfully! We will attend to it shortly.");
            } else {
                request.setAttribute("type", "error");
                request.setAttribute("mess", "Failed to submit report. Please try again.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("type", "error");
            request.setAttribute("mess", "Error: " + e.getMessage());
        }

        // Reload amenities page
        doGet(request, response);
    }

    private void handleUpdateProfile(HttpServletRequest request, HttpServletResponse response,
            User currentUser, HttpSession session)
            throws ServletException, IOException {
        try {
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");

            // Validate
            if (fullName == null || fullName.isBlank()) {
                request.setAttribute("type", "error");
                request.setAttribute("mess", "Full name can not blank!");
                request.getRequestDispatcher("/Views/Customer/Profile.jsp").forward(request, response);
                return;
            }

            // Update user object
            currentUser.setFullName(fullName.trim());

            // Email và Phone có thể null
            if (email != null && !email.isBlank()) {
                currentUser.setEmail(email.trim());
            } else {
                currentUser.setEmail(null);
            }

            if (phone != null && !phone.isBlank()) {
                currentUser.setPhone(phone.trim());
            } else {
                currentUser.setPhone(null);
            }

            // Update in database
            boolean success = DAOAuthen.INSTANCE.updateUserProfile(currentUser);

            if (success) {
                // Update session
                session.setAttribute("currentUser", currentUser);

                request.setAttribute("type", "success");
                request.setAttribute("mess", "Update information success!");
            } else {
                request.setAttribute("type", "error");
                request.setAttribute("mess", "Update information fail!");
            }

        } catch (IllegalArgumentException e) {
            request.setAttribute("type", "error");
            request.setAttribute("mess", "Data error: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("type", "error");
            request.setAttribute("mess", "Some error happen: " + e.getMessage());
        }

        request.getRequestDispatcher("/Views/Customer/Profile.jsp").forward(request, response);
    }

    private void handleChangePassword(HttpServletRequest request, HttpServletResponse response,
            User currentUser, HttpSession session)
            throws ServletException, IOException {
        try {
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            // Validate
            if (currentPassword == null || currentPassword.isBlank()
                    || newPassword == null || newPassword.isBlank()
                    || confirmPassword == null || confirmPassword.isBlank()) {
                request.setAttribute("type", "error");
                request.setAttribute("mess", "Please enter information!");
                request.getRequestDispatcher("/Views/Customer/Profile.jsp").forward(request, response);
                return;
            }

            // Check if new password matches confirm password
            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("type", "error");
                request.setAttribute("mess", "New password and current password does not match!");
                request.getRequestDispatcher("/Views/Customer/Profile.jsp").forward(request, response);
                return;
            }

            // Check password length
            if (newPassword.length() < 6) {
                request.setAttribute("type", "error");
                request.setAttribute("mess", "New password have at least 6 characters!");
                request.getRequestDispatcher("/Views/Customer/Profile.jsp").forward(request, response);
                return;
            }

            // Verify current password
            if (!currentUser.checkPasswordRaw(currentPassword)) {
                request.setAttribute("type", "error");
                request.setAttribute("mess", "Current password incorrect!");
                request.getRequestDispatcher("/Views/Customer/Profile.jsp").forward(request, response);
                return;
            }

            // Update password
            currentUser.setPlainPassword(newPassword);
            boolean success = DAOAuthen.INSTANCE.updateUserPassword(currentUser);

            if (success) {
                // Update session
                session.setAttribute("currentUser", currentUser);
                SendEmail.sendMail(currentUser.getEmail(), "Change password", "Your password had been changed successfully");

                request.setAttribute("type", "success");
                request.setAttribute("mess", "Change password success!");
            } else {
                request.setAttribute("type", "error");
                request.setAttribute("mess", "Change password fail!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("type", "error");
            request.setAttribute("mess", "Some error happen: " + e.getMessage());
        }

        request.getRequestDispatcher("/Views/Customer/Profile.jsp").forward(request, response);
    }

    private void handleConfirmAmenities(HttpServletRequest request, HttpServletResponse response,
            User currentUser, HttpSession session)
            throws ServletException, IOException {
        try {
            String bookingIdStr = request.getParameter("bookingId");
            String roomIdStr = request.getParameter("roomId");

            // Collect amenity statuses
            java.util.List<String> missingItems = new java.util.ArrayList<>();
            java.util.Enumeration<String> parameterNames = request.getParameterNames();
            while (parameterNames.hasMoreElements()) {
                String paramName = parameterNames.nextElement();
                if (paramName.startsWith("status_")) {
                    String amenityId = paramName.substring(7); // "status_".length()
                    String status = request.getParameter(paramName);
                    if ("MISSING".equals(status)) {
                        String name = request.getParameter("name_" + amenityId);
                        if (name == null || name.isEmpty()) {
                            name = "Amenity ID " + amenityId;
                        }
                        missingItems.add(name);
                    }
                }
            }

            Model.IssueReport report = new Model.IssueReport();
            report.setReportedBy(currentUser.getUserId());

            if (missingItems.isEmpty()) {
                report.setDescription("Customer confirmed all amenities are sufficient.");
                report.setIssueType(Model.IssueReport.IssueType.CONFIRMATION);
            } else {
                report.setDescription("Customer reported missing/issues with: " + String.join(", ", missingItems));
                report.setIssueType(Model.IssueReport.IssueType.CONFIRMATION);
            }

            report.setStatus(Model.IssueReport.IssueStatus.NEW);

            if (bookingIdStr != null && !bookingIdStr.isEmpty()) {
                report.setBookingId(Integer.parseInt(bookingIdStr));
            }

            if (roomIdStr != null && !roomIdStr.isEmpty()) {
                report.setRoomId(Integer.parseInt(roomIdStr));
            } else {
                // Try to get room from active booking if not provided
                DAL.Booking.DAOBooking daoBooking = DAL.Booking.DAOBooking.INSTANCE;
                Booking booking = daoBooking.getActiveBookingByCustomerId(currentUser.getUserId());
                if (booking != null) {
                    report.setRoomId(booking.getRoomId());
                    report.setBookingId(booking.getBookingId());
                } else {
                    throw new IllegalArgumentException("No active room found to confirm amenities for.");
                }
            }

            boolean success = DAL.IssueReportDAO.INSTANCE.createIssueReport(report);

            if (success) {
                request.setAttribute("type", "success");
                request.setAttribute("mess", "Thank you for your inspection report!");
            } else {
                request.setAttribute("type", "error");
                request.setAttribute("mess", "Failed to submit report. Please try again.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("type", "error");
            request.setAttribute("mess", "Error: " + e.getMessage());
        }

        // Reload amenities page
        doGet(request, response);
    }
}
