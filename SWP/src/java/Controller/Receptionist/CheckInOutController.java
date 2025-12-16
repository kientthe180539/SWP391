package Controller.Receptionist;

import DAL.Receptionist.DAOReceptionist;
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

/**
 * Controller for Check-in and Check-out operations
 */
@WebServlet(name = "CheckInOutController", urlPatterns = {"/receptionist/checkinout"})
public class CheckInOutController extends HttpServlet {

    private final DAOReceptionist daoReceptionist = DAOReceptionist.INSTANCE;

    private static final int ROLE_RECEPTIONIST = 2;

    private boolean ensureReceptionist(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        User currentUser = (User) request.getSession().getAttribute("currentUser");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        // Allow receptionist (role 2) and admin/manager (role 5,6) to access
        if (currentUser.getRoleId() != ROLE_RECEPTIONIST
                && currentUser.getRoleId() != 5
                && currentUser.getRoleId() != 6) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return false;
        }
        return true;
    }

    /**
     * Handles GET requests - Display check-in/check-out page
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!ensureReceptionist(request, response)) {
            return;
        }

        // Get bookings ready for check-in
        List<Map<String, Object>> readyForCheckIn = daoReceptionist.getConfirmedBookingsReadyForCheckIn();

        // Get bookings currently checked in
        List<Map<String, Object>> checkedIn = daoReceptionist.getCheckedInBookings();

        // Set attributes
        request.setAttribute("readyForCheckIn", readyForCheckIn);
        request.setAttribute("checkedIn", checkedIn);

        // Forward to JSP
        request.getRequestDispatcher("/Views/Receptionist/CheckInOut.jsp").forward(request, response);
    }

    /**
     * Handles POST requests - Process check-in/check-out actions
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!ensureReceptionist(request, response)) {
            return;
        }

        HttpSession session = request.getSession();
        String action = request.getParameter("action");
        String bookingIdStr = request.getParameter("bookingId");

        if (bookingIdStr == null || bookingIdStr.isEmpty()) {
            request.setAttribute("type", "error");
            request.setAttribute("mess", "Booking ID is required");
            request.getRequestDispatcher("/Views/Receptionist/CheckInOut.jsp").forward(request, response);
            return;
        }

        try {
            int bookingId = Integer.parseInt(bookingIdStr);
            User currentUser = (User) session.getAttribute("currentUser");
            int receptionistId = currentUser.getUserId();
            boolean success = false;
            String successMessage = "";
            String errorMessage = "";

            if ("checkin".equals(action)) {
                success = daoReceptionist.checkInBooking(bookingId, receptionistId);
                if (success) {
                    successMessage = "Check-in successful for Booking #" + bookingId;
                } else {
                    errorMessage = "Failed to check-in. Please verify booking status and check-in date.";
                }
            } else if ("checkout".equals(action)) {
                success = daoReceptionist.checkOutBooking(bookingId, receptionistId);
                if (success) {
                    successMessage = "Check-out successful for Booking #" + bookingId;
                } else {
                    errorMessage = "Failed to check-out. Please verify booking is checked-in.";
                }
            } else if ("noshow".equals(action)) {
                success = daoReceptionist.markNoShow(bookingId, receptionistId);
                if (success) {
                    successMessage = "Booking #" + bookingId + " marked as NO SHOW";
                } else {
                    errorMessage = "Failed to mark No Show. Only confirmed bookings can be marked.";
                }
            } else {
                errorMessage = "Invalid action";
            }

            if (success) {
                session.setAttribute("success", successMessage);
            } else {
                session.setAttribute("error", errorMessage);
            }
            
            response.sendRedirect(request.getContextPath() + "/receptionist/checkinout");
        } catch (NumberFormatException e) {
            request.setAttribute("type", "error");
            request.setAttribute("mess", "Invalid booking ID format");
            request.getRequestDispatcher("/Views/Receptionist/CheckInOut.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Check-In/Check-Out Controller";
    }
}
