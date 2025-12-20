package Controller.Receptionist;

import DAL.Receptionist.DAOReceptionist;
import Model.User;
import Model.StaffAssignment;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ReceptionistController", urlPatterns = {
        "/receptionist/dashboard",
        "/receptionist/reservations",
        "/receptionist/schedule"
})
public class ReceptionistController extends HttpServlet {

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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!ensureReceptionist(request, response)) {
            return;
        }

        String path = request.getServletPath();
        switch (path) {
            case "/receptionist/dashboard" ->
                showDashboard(request, response);
            case "/receptionist/reservations" ->
                showReservationList(request, response);
            case "/receptionist/schedule" ->
                showSchedule(request, response);
            default ->
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    // ======================================================
    // Dashboard
    // ======================================================
    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get statistics
        Map<String, Integer> stats = DAOReceptionist.INSTANCE.getDashboardStats();
        request.setAttribute("stats", stats);

        // Get today's arrivals
        List<Map<String, Object>> todayArrivals = DAOReceptionist.INSTANCE.getTodayArrivals();
        request.setAttribute("todayArrivals", todayArrivals);

        // Get recent bookings (latest 10)
        List<Map<String, Object>> recentBookings = DAOReceptionist.INSTANCE.getRecentBookings(10);
        request.setAttribute("recentBookings", recentBookings);

        request.getRequestDispatcher("/Views/Receptionist/Dashboard.jsp")
                .forward(request, response);
    }

    // ======================================================
    // Reservation List with Filters
    // ======================================================
    private void showReservationList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String statusFilter = request.getParameter("status");
        String search = request.getParameter("search");
        String dateFromStr = request.getParameter("dateFrom");
        String dateToStr = request.getParameter("dateTo");
        String sortBy = request.getParameter("sortBy");
        String sortOrder = request.getParameter("sortOrder");
        String pageStr = request.getParameter("page");

        // Parse dates
        LocalDate dateFrom = null;
        LocalDate dateTo = null;
        try {
            if (dateFromStr != null && !dateFromStr.isBlank()) {
                dateFrom = LocalDate.parse(dateFromStr);
            }
            if (dateToStr != null && !dateToStr.isBlank()) {
                dateTo = LocalDate.parse(dateToStr);
            }
        } catch (DateTimeParseException e) {
            // Invalid date format - ignore
        }

        // Parse page number
        int page = 1;
        int pageSize = 15;
        try {
            if (pageStr != null) {
                page = Integer.parseInt(pageStr);
            }
        } catch (NumberFormatException e) {
            // Invalid page - default to 1
        }

        // Get bookings with filters
        List<Map<String, Object>> bookings = DAOReceptionist.INSTANCE.getAllBookingsWithFilters(
                statusFilter, search, dateFrom, dateTo, sortBy, sortOrder, page, pageSize);

        // Get total count for pagination
        int totalBookings = DAOReceptionist.INSTANCE.countBookings(statusFilter, search, dateFrom, dateTo);
        int totalPages = (int) Math.ceil((double) totalBookings / pageSize);

        // Set attributes
        request.setAttribute("bookings", bookings);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalBookings", totalBookings);

        // Preserve filter parameters
        request.setAttribute("status", statusFilter);
        request.setAttribute("search", search);
        request.setAttribute("dateFrom", dateFromStr);
        request.setAttribute("dateTo", dateToStr);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("sortOrder", sortOrder);

        request.getRequestDispatcher("/Views/Receptionist/ReservationList.jsp")
                .forward(request, response);
    }

    private void showSchedule(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Permanent Schedule View
        List<StaffAssignment> assignments = DAL.Owner.DAOOwner.INSTANCE.getAllCurrentAssignments();

        request.setAttribute("assignments", assignments);
        request.setAttribute("date", LocalDate.now());
        request.getRequestDispatcher("/Views/Shared/ViewSchedule.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Receptionist module controller";
    }
}
