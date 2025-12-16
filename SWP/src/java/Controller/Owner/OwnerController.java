package Controller.Owner;

import DAL.Owner.DAOOwner;
import Model.StaffAssignment;
import Model.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;

@WebServlet(name = "OwnerController", urlPatterns = {
        "/owner/dashboard",
        "/owner/employees",
        "/owner/employee-create",
        "/owner/employee-detail",
        "/owner/assignments",
        "/owner/staff-status",
        "/owner/reports",
        "/owner/rooms",
        "/owner/bookings"
})
public class OwnerController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Authorization check (Role ID 4 = Owner)
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || currentUser.getRoleId() != 4) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String path = request.getServletPath();

        switch (path) {
            case "/owner/dashboard":
                showDashboard(request, response);
                break;
            case "/owner/employees":
                showEmployeeList(request, response);
                break;
            case "/owner/employee-create":
                request.getRequestDispatcher("/Views/Owner/CreateEmployee.jsp").forward(request, response);
                break;
            case "/owner/employee-detail":
                showEmployeeDetail(request, response);
                break;
            case "/owner/assignments":
                showAssignments(request, response);
                break;
            case "/owner/staff-status":
                request.getRequestDispatcher("/Views/Owner/StaffStatus.jsp").forward(request, response);
                break;
            case "/owner/reports":
                request.getRequestDispatcher("/Views/Owner/Reports.jsp").forward(request, response);
                break;
            case "/owner/rooms":
                showRoomList(request, response);
                break;
            case "/owner/bookings":
                showBookings(request, response);
                break;
            default:
                response.sendError(404);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Authorization check
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || currentUser.getRoleId() != 4) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null)
            action = "";

        switch (action) {
            case "createEmployee":
                handleCreateEmployee(request, response);
                break;
            case "updateEmployee":
                handleUpdateEmployee(request, response);
                break;
            case "toggleStatus":
                handleToggleStatus(request, response);
                break;
            case "createAssignment":
                handleCreateAssignment(request, response);
                break;
            case "deleteAssignment":
                handleDeleteAssignment(request, response);
                break;
            default:
                doGet(request, response);
        }
    }

    private void showAssignments(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String dateStr = request.getParameter("date");
        LocalDate date = LocalDate.now();
        if (dateStr != null && !dateStr.isBlank()) {
            try {
                date = LocalDate.parse(dateStr);
            } catch (Exception e) {
            }
        }

        List<StaffAssignment> assignments = DAOOwner.INSTANCE.getAssignments(date);
        List<User> employees = DAOOwner.INSTANCE.getEmployees(null, null, "true", "username", "ASC", 0, 0); // Get all
                                                                                                            // active
                                                                                                            // employees

        request.setAttribute("assignments", assignments);
        request.setAttribute("employees", employees);
        request.setAttribute("date", date);

        request.getRequestDispatcher("/Views/Owner/JobAssignment.jsp").forward(request, response);
    }

    private void handleCreateAssignment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int employeeId = Integer.parseInt(request.getParameter("employeeId"));
        LocalDate date = LocalDate.parse(request.getParameter("date"));
        String shift = request.getParameter("shift");

        boolean success = DAOOwner.INSTANCE.createAssignment(employeeId, date, shift);
        response.sendRedirect("assignments?date=" + date);
    }

    private void handleDeleteAssignment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String dateStr = request.getParameter("date");

        DAOOwner.INSTANCE.deleteAssignment(id);
        response.sendRedirect("assignments?date=" + dateStr);
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Fetch KPIs
        int totalRooms = DAOOwner.INSTANCE.getTotalRooms();
        int occupiedRooms = DAOOwner.INSTANCE.getOccupiedRooms();
        double revenue = DAOOwner.INSTANCE.getTodayRevenue();

        request.setAttribute("totalRooms", totalRooms);
        request.setAttribute("occupiedRooms", occupiedRooms);
        request.setAttribute("revenue", revenue);

        request.getRequestDispatcher("/Views/Owner/Dashboard.jsp").forward(request, response);
    }

    private void showEmployeeList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String search = request.getParameter("search");
        String roleId = request.getParameter("roleId");
        String status = request.getParameter("status");
        String sortBy = request.getParameter("sortBy");
        String sortOrder = request.getParameter("sortOrder");
        String pageStr = request.getParameter("page");

        int page = 1;
        int pageSize = 10;
        try {
            if (pageStr != null)
                page = Integer.parseInt(pageStr);
        } catch (NumberFormatException e) {
        }

        List<User> employees = DAOOwner.INSTANCE.getEmployees(search, roleId, status, sortBy, sortOrder, page,
                pageSize);
        int totalEmployees = DAOOwner.INSTANCE.countEmployees(search, roleId, status);
        int totalPages = (int) Math.ceil((double) totalEmployees / pageSize);

        request.setAttribute("employees", employees);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalEmployees", totalEmployees);

        request.setAttribute("search", search);
        request.setAttribute("roleId", roleId);
        request.setAttribute("status", status);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("sortOrder", sortOrder);

        request.getRequestDispatcher("/Views/Owner/EmployeeList.jsp").forward(request, response);
    }

    private void showRoomList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String search = request.getParameter("search");
        String status = request.getParameter("status");
        String sortBy = request.getParameter("sortBy");
        String sortOrder = request.getParameter("sortOrder");
        String pageStr = request.getParameter("page");

        int page = 1;
        int pageSize = 12;
        try {
            if (pageStr != null)
                page = Integer.parseInt(pageStr);
        } catch (NumberFormatException e) {
        }

        List<Model.Room> rooms = DAOOwner.INSTANCE.getRooms(status, search, sortBy, sortOrder, page, pageSize);
        int totalRooms = DAOOwner.INSTANCE.countRooms(status, search);
        int totalPages = (int) Math.ceil((double) totalRooms / pageSize);

        request.setAttribute("rooms", rooms);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRooms", totalRooms);

        request.setAttribute("search", search);
        request.setAttribute("status", status);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("sortOrder", sortOrder);

        request.getRequestDispatcher("/Views/Owner/RoomManagement.jsp").forward(request, response);
    }

    private void showEmployeeDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            User employee = DAOOwner.INSTANCE.getEmployeeById(id);
            if (employee == null) {
                response.sendRedirect("employees");
                return;
            }
            request.setAttribute("employee", employee);
            request.getRequestDispatcher("/Views/Owner/EmployeeDetail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect("employees");
        }
    }

    private void handleCreateEmployee(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        int roleId = Integer.parseInt(request.getParameter("roleId"));
        String password = request.getParameter("password");

        User u = new User();
        u.setUsername(username);
        u.setFullName(fullName);
        u.setEmail(email);
        u.setPhone(phone);
        u.setRoleId(roleId);
        u.setPlainPassword(password); // Hashes the password

        boolean success = DAOOwner.INSTANCE.createEmployee(u, password);
        if (success) {
            response.sendRedirect("employees?msg=created");
        } else {
            request.setAttribute("error", "Failed to create employee");
            request.getRequestDispatcher("/Views/Owner/CreateEmployee.jsp").forward(request, response);
        }
    }

    private void handleUpdateEmployee(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("userId"));
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        int roleId = Integer.parseInt(request.getParameter("roleId"));
        boolean isActive = request.getParameter("isActive") != null;

        User u = new User();
        u.setUserId(id);
        u.setFullName(fullName);
        u.setEmail(email);
        u.setPhone(phone);
        u.setRoleId(roleId);
        u.setActive(isActive);

        boolean success = DAOOwner.INSTANCE.updateEmployee(u);
        if (success) {
            response.sendRedirect("employees?msg=updated");
        } else {
            response.sendRedirect("employee-detail?id=" + id + "&error=failed");
        }
    }

    private void handleToggleStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("userId"));
        boolean currentStatus = Boolean.parseBoolean(request.getParameter("currentStatus"));

        boolean success = DAOOwner.INSTANCE.toggleEmployeeStatus(id, !currentStatus);
        response.sendRedirect("employees");
    }

    private void showBookings(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Reuse Booking DAO
        DAL.Booking.DAOBooking bookingDAO = DAL.Booking.DAOBooking.INSTANCE;

        String statusFilter = request.getParameter("status");
        String pageStr = request.getParameter("page");

        int page = 1;
        int pageSize = 10;
        try {
            if (pageStr != null)
                page = Integer.parseInt(pageStr);
        } catch (NumberFormatException e) {
        }

        List<Model.Booking> allBookings;
        if (statusFilter != null && !statusFilter.isBlank() && !"ALL".equals(statusFilter)) {
            Model.Booking.Status statusEnum = Model.Booking.Status.valueOf(statusFilter);
            allBookings = bookingDAO.getBookingsByStatus(statusEnum);
        } else {
            allBookings = bookingDAO.getAllBookings();
        }

        // Sorting (default by created_at desc)
        allBookings.sort((b1, b2) -> {
            if (b1.getCreatedAt() == null)
                return 1;
            if (b2.getCreatedAt() == null)
                return -1;
            return b2.getCreatedAt().compareTo(b1.getCreatedAt());
        });

        int totalBookings = allBookings.size();
        int totalPages = (int) Math.ceil((double) totalBookings / pageSize);
        if (page > totalPages && totalPages > 0)
            page = totalPages;

        int startIndex = (page - 1) * pageSize;
        int endIndex = Math.min(startIndex + pageSize, totalBookings);

        List<Model.Booking> bookings = allBookings.subList(startIndex, endIndex);

        request.setAttribute("bookings", bookings);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalBookings", totalBookings);
        request.setAttribute("statusFilter", statusFilter != null ? statusFilter : "ALL");

        // Reuse Manager's BookingList.jsp but maybe hide actions?
        // Or create Views/Owner/BookingList.jsp.
        // Since Owner is read-only for bookings, reusing Manager's might show edit
        // buttons.
        // I should check BookingList.jsp.
        // For now, let's use Manager's and assume it handles role checks or I'll create
        // a copy.
        // Actually, creating a simple read-only view is safer.
        request.getRequestDispatcher("/Views/Owner/BookingList.jsp").forward(request, response);
    }
}
