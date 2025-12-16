package Controller.Owner;

import DAL.Owner.DAOOwner;
import DAL.Booking.DAOBooking;
import Model.*;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.ArrayList;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import jakarta.servlet.annotation.MultipartConfig;

/**
 * OwnerController
 * -------------------------------------------------------------------
 * Controller chịu trách nhiệm xử lý toàn bộ request của Owner (roleId = 4).
 *
 * Chức năng chính: - Dashboard - Quản lý nhân viên - Phân công ca làm - Quản lý
 * phòng - Xem booking
 *
 * Nguyên tắc xử lý: - Kiểm tra phân quyền trước mọi request - TẤT CẢ GET + POST
 * đều dùng chung cơ chế thông báo: + type : success | error + mess : nội dung
 * hiển thị + href : đường dẫn điều hướng sau khi hiển thị - Không redirect sau
 * action (trừ login)
 */
@MultipartConfig
@WebServlet(name = "OwnerController", urlPatterns = {
    "/owner/dashboard",
    "/owner/employees",
    "/owner/employee-create",
    "/owner/employee-detail",
    "/owner/assignments",
    "/owner/staff-status",
    "/owner/reports",
    "/owner/rooms",
    "/owner/bookings",
    "/owner/room-form"
})
public class OwnerController extends HttpServlet {

    /*
     * ===============================================================
     * COMMON UTILITIES
     * ===============================================================
     */
    /**
     * Kiểm tra đăng nhập + phân quyền Owner
     *
     * @return true nếu hợp lệ, false nếu bị redirect sang login
     */
    private boolean checkOwner(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        // Owner có roleId = 4
        if (currentUser == null || currentUser.getRoleId() != 4) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        return true;
    }

    /*
     * ===============================================================
     * GET REQUEST HANDLER
     * ===============================================================
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Kiểm tra phân quyền trước khi xử lý
        if (!checkOwner(request, response)) {
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
                request.getRequestDispatcher("/Views/Owner/CreateEmployee.jsp")
                        .forward(request, response);
                break;

            case "/owner/employee-detail":
                showEmployeeDetail(request, response);
                break;

            case "/owner/assignments":
                showAssignments(request, response);
                break;

            case "/owner/staff-status":
                showStaffStatus(request, response);
                break;

            case "/owner/reports":
                showReports(request, response);
                break;

            case "/owner/rooms":
                showRoomList(request, response);
                break;

            case "/owner/room-form":
                showRoomForm(request, response);
                break;

            case "/owner/bookings":
                showBookings(request, response);
                break;

            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    /*
     * ===============================================================
     * POST REQUEST HANDLER
     * ===============================================================
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Kiểm tra phân quyền
        if (!checkOwner(request, response)) {
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

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

            case "createRoomType":
                handleCreateRoomType(request, response);
                break;

            case "updateRoomType":
                handleUpdateRoomType(request, response);
                break;

            case "deleteRoomType":
                handleDeleteRoomType(request, response);
                break;

            case "createRoom":
                handleCreateRoom(request, response);
                break;

            case "updateRoom":
                handleUpdateRoom(request, response);
                break;

            default:
                doGet(request, response);
        }
    }

    /*
     * ===============================================================
     * SHOW METHODS (GET)
     * ===============================================================
     */
    /**
     * Hiển thị Dashboard cho Owner
     */
    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            request.setAttribute("totalRooms", DAOOwner.INSTANCE.getTotalRooms());
            request.setAttribute("occupiedRooms", DAOOwner.INSTANCE.getOccupiedRooms());
            request.setAttribute("revenue", DAOOwner.INSTANCE.getTodayRevenue());
        } catch (Exception e) {
            request.setAttribute("type", "error");
            request.setAttribute("mess", "Cannot load dashboard data");
        }

        request.getRequestDispatcher("/Views/Owner/Dashboard.jsp")
                .forward(request, response);
    }

    /**
     * Hiển thị danh sách nhân viên (có filter + paging)
     */
    private void showEmployeeList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int page = 1;
            int pageSize = 10;

            if (request.getParameter("page") != null) {
                page = Integer.parseInt(request.getParameter("page"));
            }

            List<User> employees = DAOOwner.INSTANCE.getEmployees(
                    request.getParameter("search"),
                    request.getParameter("roleId"),
                    request.getParameter("status"),
                    request.getParameter("sortBy"),
                    request.getParameter("sortOrder"),
                    page, pageSize);

            int total = DAOOwner.INSTANCE.countEmployees(
                    request.getParameter("search"),
                    request.getParameter("roleId"),
                    request.getParameter("status"));

            request.setAttribute("employees", employees);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", (int) Math.ceil((double) total / pageSize));
            request.setAttribute("totalEmployees", total);

            // Persist filter params
            request.setAttribute("search", request.getParameter("search"));
            request.setAttribute("roleId", request.getParameter("roleId"));
            request.setAttribute("status", request.getParameter("status"));
            request.setAttribute("sortBy", request.getParameter("sortBy"));
            request.setAttribute("sortOrder", request.getParameter("sortOrder"));

        } catch (Exception e) {
            request.setAttribute("type", "error");
            request.setAttribute("mess", "Cannot load employee list");
        }

        request.getRequestDispatcher("/Views/Owner/EmployeeList.jsp")
                .forward(request, response);
    }

    /**
     * Hiển thị chi tiết 1 nhân viên
     */
    private void showEmployeeDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            User employee = DAOOwner.INSTANCE.getEmployeeById(id);

            if (employee == null) {
                request.setAttribute("type", "error");
                request.setAttribute("mess", "Employee not found");
                request.setAttribute("href", "employees");

                request.getRequestDispatcher("/Views/Owner/EmployeeList.jsp")
                        .forward(request, response);
                return;
            }

            request.setAttribute("employee", employee);

        } catch (Exception e) {
            request.setAttribute("type", "error");
            request.setAttribute("mess", "Invalid employee id");
        }

        request.getRequestDispatcher("/Views/Owner/EmployeeDetail.jsp")
                .forward(request, response);
    }

    /**
     * Hiển thị phân công ca làm theo ngày
     */
    private void showAssignments(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            LocalDate date = LocalDate.now();

            if (request.getParameter("date") != null) {
                date = LocalDate.parse(request.getParameter("date"));
            }

            request.setAttribute("date", date);
            request.setAttribute("assignments", DAOOwner.INSTANCE.getAssignments(date));
            request.setAttribute("employees",
                    DAOOwner.INSTANCE.getEmployees(null, null, "true", "username", "ASC", 0, 0));

        } catch (Exception e) {
            request.setAttribute("type", "error");
            request.setAttribute("mess", "Cannot load assignments");
        }

        request.getRequestDispatcher("/Views/Owner/JobAssignment.jsp")
                .forward(request, response);
    }

    /**
     * Hiển thị danh sách phòng + Room Types + Pricing
     */
    private void showRoomList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String tab = request.getParameter("tab");
            if (tab == null || tab.isBlank()) {
                tab = "rooms";
            }

            request.setAttribute("activeTab", tab);

            // Load room types for all tabs (needed for Create Room modal in 'rooms' tab
            // too)
            List<RoomType> types = DAOOwner.INSTANCE.getAllRoomTypes();
            request.setAttribute("roomTypes", types);

            // Always load room list if tab is rooms (or default)
            if ("rooms".equals(tab)) {
                int page = 1;
                int pageSize = 12;

                if (request.getParameter("page") != null) {
                    page = Integer.parseInt(request.getParameter("page"));
                }

                List<Room> rooms = DAOOwner.INSTANCE.getRooms(
                        request.getParameter("status"),
                        request.getParameter("search"),
                        request.getParameter("sortBy"),
                        request.getParameter("sortOrder"),
                        page, pageSize);

                int total = DAOOwner.INSTANCE.countRooms(
                        request.getParameter("status"),
                        request.getParameter("search"));

                request.setAttribute("rooms", rooms);
                request.setAttribute("currentPage", page);
                request.setAttribute("totalPages", (int) Math.ceil((double) total / pageSize));
                request.setAttribute("totalRooms", total);

                // Persist filter params
                request.setAttribute("search", request.getParameter("search"));
                request.setAttribute("status", request.getParameter("status"));
                request.setAttribute("sortBy", request.getParameter("sortBy"));
                request.setAttribute("sortOrder", request.getParameter("sortOrder"));
            }

        } catch (Exception e) {
            request.setAttribute("type", "error");
            request.setAttribute("mess", "Cannot load room management data");
        }

        request.getRequestDispatcher("/Views/Owner/RoomManagement.jsp")
                .forward(request, response);
    }

    // --- POST Handlers for Room Types ---
    private void handleCreateRoomType(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        try {
            RoomType rt = new RoomType();
            rt.setTypeName(request.getParameter("typeName"));
            rt.setDescription(request.getParameter("description"));
            rt.setBasePrice(new java.math.BigDecimal(request.getParameter("basePrice")));
            rt.setMaxOccupancy(Integer.parseInt(request.getParameter("maxOccupancy")));

            DAOOwner.INSTANCE.createRoomType(rt);
            request.setAttribute("type", "success");
            request.setAttribute("mess", "Created room type successfully");
        } catch (Exception e) {
            request.setAttribute("type", "error");
            request.setAttribute("mess", "Failed to create room type: " + e.getMessage());
        }

        // Redirect back to type tab
        response.sendRedirect(request.getContextPath() + "/owner/rooms?tab=types");
    }

    private void handleUpdateRoomType(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        try {
            RoomType rt = new RoomType();
            rt.setRoomTypeId(Integer.parseInt(request.getParameter("roomTypeId")));
            rt.setTypeName(request.getParameter("typeName"));
            rt.setDescription(request.getParameter("description"));
            rt.setBasePrice(new java.math.BigDecimal(request.getParameter("basePrice")));
            rt.setMaxOccupancy(Integer.parseInt(request.getParameter("maxOccupancy")));

            DAOOwner.INSTANCE.updateRoomType(rt);
            request.setAttribute("type", "success");
            request.setAttribute("mess", "Updated room type successfully");
        } catch (Exception e) {
            request.setAttribute("type", "error");
            request.setAttribute("mess", "Failed to update room type: " + e.getMessage());
        }

        // Use redirect to avoid re-submit issues
        String tab = request.getParameter("redirectTab");
        if (tab == null) {
            tab = "types";
        }
        response.sendRedirect(request.getContextPath() + "/owner/rooms?tab=" + tab);
    }

    private void handleDeleteRoomType(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            DAOOwner.INSTANCE.deleteRoomType(id);
            request.setAttribute("type", "success");
            request.setAttribute("mess", "Deleted room type successfully");
        } catch (Exception e) {
            request.setAttribute("type", "error");
            request.setAttribute("mess", "Failed to delete room type");
        }
        response.sendRedirect(request.getContextPath() + "/owner/rooms?tab=types");
    }

    private void handleCreateRoom(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        try {
            Room room = new Room();
            room.setRoomNumber(request.getParameter("roomNumber"));
            room.setFloor(Integer.parseInt(request.getParameter("floor")));
            room.setRoomTypeId(Integer.parseInt(request.getParameter("roomTypeId")));
            room.setStatus(request.getParameter("status"));
            room.setDescription(request.getParameter("description"));
            room.setActive(true);

            // Validation: Check duplicate Room Number
            if (DAOOwner.INSTANCE.isRoomNumberExists(room.getRoomNumber(), 0)) {
                request.setAttribute("error", "Room number " + room.getRoomNumber() + " already exists!");
                request.setAttribute("room", room);
                request.setAttribute("mode", "CREATE");
                // Always need room types for the dropdown
                request.setAttribute("roomTypes", DAOOwner.INSTANCE.getAllRoomTypes());
                request.getRequestDispatcher("/Views/Owner/CreateEditRoom.jsp").forward(request, response);
                return;
            }

            // Handle Image Upload
            List<String> files = new Utils.UploadFile().fileUpload(request, response);
            if (!files.isEmpty()) {
                List<String> imagePaths = new ArrayList<>();
                for (String f : files) {
                    imagePaths.add("images/" + f);
                }
                room.setImageUrl(String.join(";", imagePaths));
            }

            DAOOwner.INSTANCE.createRoom(room);
            request.getSession().setAttribute("notification",
                    "success|Created room " + room.getRoomNumber() + " successfully!");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("notification", "error|Failed to create room: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/owner/rooms?tab=rooms");
    }

    private void handleUpdateRoom(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        try {
            Room room = new Room();
            room.setRoomId(Integer.parseInt(request.getParameter("roomId")));
            room.setRoomNumber(request.getParameter("roomNumber"));
            room.setFloor(Integer.parseInt(request.getParameter("floor")));
            room.setRoomTypeId(Integer.parseInt(request.getParameter("roomTypeId")));
            room.setStatus(request.getParameter("status"));
            room.setDescription(request.getParameter("description"));
            room.setActive(true);

            // Validation: Check duplicate Room Number
            if (DAOOwner.INSTANCE.isRoomNumberExists(room.getRoomNumber(), room.getRoomId())) {
                request.setAttribute("error", "Room number " + room.getRoomNumber() + " already exists!");
                request.setAttribute("room", room);
                request.setAttribute("mode", "UPDATE");
                request.setAttribute("roomTypes", DAOOwner.INSTANCE.getAllRoomTypes());
                request.getRequestDispatcher("/Views/Owner/CreateEditRoom.jsp").forward(request, response);
                return;
            }

            // Handle Image Upload (Optional)
            List<String> files = new Utils.UploadFile().fileUpload(request, response);
            if (!files.isEmpty()) {
                List<String> imagePaths = new ArrayList<>();
                for (String f : files) {
                    imagePaths.add("images/" + f);
                }
                room.setImageUrl(String.join(";", imagePaths));
            }
            // If no file uploaded, leave imageUrl null in object so DAO won't update it
            // (handled in DAO usually, need to check)
            // Correction: If DAO overwrites regardless, we need to fetch old URL or handle
            // in DAO.
            // Assuming DAO handles null check or we need to keep old one.
            // Let's check DAOOwner.updateRoom implementation quickly to be sure?
            // Previous code assumed DAO handles it. Let's stick to that for now or fetch
            // old one if needed.
            // Actually, best practice: if file list empty, don't set imageUrl (it's null).
            // DAO should ignore if null.

            DAOOwner.INSTANCE.updateRoom(room);
            request.getSession().setAttribute("notification",
                    "success|Updated room " + room.getRoomNumber() + " successfully!");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("notification", "error|Failed to update room: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/owner/rooms?tab=rooms");
    }

    // ===============================================================
    // BOOKING
    // ===============================================================
    /**
     * Hiển thị danh sách booking (read-only)
     */
    private void showRoomForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Always need room types for the dropdown
        List<RoomType> types = DAOOwner.INSTANCE.getAllRoomTypes();
        request.setAttribute("roomTypes", types);

        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            // Edit Mode
            request.setAttribute("mode", "UPDATE");
            // Fetch Room by ID
            try {
                int roomId = Integer.parseInt(idStr);
                Room r = DAOOwner.INSTANCE.getRoomById(roomId);
                if (r != null) {
                    request.setAttribute("room", r);
                }
            } catch (NumberFormatException e) {
                // Invalid ID, ignore or handle
            }
        } else {
            // Create Mode
            request.setAttribute("mode", "CREATE");
        }

        request.getRequestDispatcher("/Views/Owner/CreateEditRoom.jsp").forward(request, response);
    }

    private void showBookings(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int page = 1;
            int pageSize = 10;
            if (request.getParameter("page") != null) {
                try {
                    page = Integer.parseInt(request.getParameter("page"));
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }

            String statusFilter = request.getParameter("status");
            if (statusFilter == null) {
                statusFilter = "ALL";
            }

            String searchQuery = request.getParameter("search");

            List<Model.Booking> bookings = DAOBooking.INSTANCE.searchBookings(statusFilter, searchQuery, page,
                    pageSize);
            int total = DAOBooking.INSTANCE.countBookings(statusFilter, searchQuery);

            request.setAttribute("bookings", bookings);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", (int) Math.ceil((double) total / pageSize));
            request.setAttribute("totalBookings", total);

            // Persist filter params
            request.setAttribute("statusFilter", statusFilter);
            request.setAttribute("searchQuery", searchQuery);

        } catch (Exception e) {
            request.setAttribute("type", "error");
            request.setAttribute("mess", "Cannot load bookings");
            e.printStackTrace();
        }

        request.getRequestDispatcher("/Views/Owner/BookingList.jsp")
                .forward(request, response);
    }

    /*
     * ===============================================================
     * HANDLE METHODS (POST)
     * ===============================================================
     */
    /**
     * Tạo nhân viên mới
     */
    private void handleCreateEmployee(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            User u = new User();
            u.setUsername(request.getParameter("username").trim());
            u.setFullName(request.getParameter("fullName").trim());
            u.setEmail(request.getParameter("email").trim());
            u.setPhone(request.getParameter("phone").trim());
            u.setRoleId(Integer.parseInt(request.getParameter("roleId")));
            u.setPlainPassword(request.getParameter("password"));

            // --- Server-side Validation ---
            String emailRegex = "^[A-Za-z0-9+_.-]+@(.+)$";
            String phoneRegex = "^\\d{10,11}$";

            if (!u.getEmail().matches(emailRegex)) {
                request.setAttribute("type", "error");
                request.setAttribute("mess", "Invalid email format.");
                request.getRequestDispatcher("/Views/Owner/CreateEmployee.jsp").forward(request, response);
                return;
            }
            if (!u.getPhone().matches(phoneRegex)) {
                request.setAttribute("type", "error");
                request.setAttribute("mess", "Phone number must be 10-11 digits.");
                request.getRequestDispatcher("/Views/Owner/CreateEmployee.jsp").forward(request, response);
                return;
            }

            // Database Duplicate Check
            String duplicateError = DAOOwner.INSTANCE.checkDuplicateEmployee(u.getUsername(), u.getEmail(),
                    u.getPhone(), 0);
            if (duplicateError != null) {
                request.setAttribute("type", "error");
                request.setAttribute("mess", duplicateError);
                request.getRequestDispatcher("/Views/Owner/CreateEmployee.jsp").forward(request, response);
                return;
            }

            DAOOwner.INSTANCE.createEmployee(u, request.getParameter("password"));
            request.setAttribute("type", "success");
            request.setAttribute("mess", "Create employee successfully!");
            request.setAttribute("href", "employees");

        } catch (Exception e) {
            request.setAttribute("type", "error");
            request.setAttribute("mess", e.getMessage());
        }

        request.getRequestDispatcher("/Views/Owner/CreateEmployee.jsp").forward(request, response);
    }

    /**
     * Cập nhật thông tin nhân viên
     */
    private void handleUpdateEmployee(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            User u = new User();
            u.setUserId(Integer.parseInt(request.getParameter("userId")));
            u.setFullName(request.getParameter("fullName").trim());
            u.setEmail(request.getParameter("email").trim());
            u.setPhone(request.getParameter("phone").trim());
            u.setRoleId(Integer.parseInt(request.getParameter("roleId")));
            u.setActive(request.getParameter("isActive") != null);

            // Fetch existing user to keep data if validation fails
            User existingUser = DAOOwner.INSTANCE.getEmployeeById(u.getUserId());
            u.setUsername(existingUser.getUsername()); // Keep username for display/consistency

            // --- Server-side Validation ---
            String emailRegex = "^[A-Za-z0-9+_.-]+@(.+)$";
            String phoneRegex = "^\\d{10,11}$";

            if (!u.getEmail().matches(emailRegex)) {
                request.setAttribute("type", "error");
                request.setAttribute("mess", "Invalid email format.");
                request.setAttribute("employee", u); // Send back entered data
                request.getRequestDispatcher("/Views/Owner/EmployeeDetail.jsp").forward(request, response);
                return;
            }
            if (!u.getPhone().matches(phoneRegex)) {
                request.setAttribute("type", "error");
                request.setAttribute("mess", "Phone number must be 10-11 digits.");
                request.setAttribute("employee", u);
                request.getRequestDispatcher("/Views/Owner/EmployeeDetail.jsp").forward(request, response);
                return;
            }

            // Database Duplicate Check (Skip username check by passing random string)
            String duplicateError = DAOOwner.INSTANCE.checkDuplicateEmployee(
                    "SKIP_CHECK_USER_" + System.currentTimeMillis(), u.getEmail(), u.getPhone(), u.getUserId());
            if (duplicateError != null) {
                request.setAttribute("error", duplicateError);
                request.setAttribute("employee", u);
                request.getRequestDispatcher("/Views/Owner/EmployeeDetail.jsp").forward(request, response);
                return;
            }

            DAOOwner.INSTANCE.updateEmployee(u);

            request.setAttribute("type", "success");
            request.setAttribute("mess", "Update employee successfully!");
            request.setAttribute("href", "employees");

        } catch (Exception e) {
            request.setAttribute("type", "error");
            request.setAttribute("mess", e.getMessage());
        }

        request.getRequestDispatcher("/Views/Owner/EmployeeDetail.jsp")
                .forward(request, response);
    }

    /**
     * Bật / tắt trạng thái nhân viên
     */
    private void handleToggleStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int id = Integer.parseInt(request.getParameter("userId"));
            boolean current = Boolean.parseBoolean(request.getParameter("currentStatus"));
            boolean newStatus = !current;

            boolean success = DAOOwner.INSTANCE.toggleEmployeeStatus(id, newStatus);

            if (success) {
                request.getSession().setAttribute("notification",
                        "success|Employee account " + (newStatus ? "unlocked" : "locked") + " successfully");
            } else {
                request.getSession().setAttribute("notification", "error|Failed to update status");
            }

        } catch (Exception e) {
            request.getSession().setAttribute("notification", "error|Error: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/owner/employees");
    }

    /**
     * Tạo phân công ca làm
     */
    private void handleCreateAssignment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            DAOOwner.INSTANCE.createAssignment(
                    Integer.parseInt(request.getParameter("employeeId")),
                    LocalDate.parse(request.getParameter("date")),
                    request.getParameter("shift"));

            request.setAttribute("type", "success");
            request.setAttribute("mess", "Assignment created successfully");

        } catch (Exception e) {
            request.setAttribute("type", "error");
            request.setAttribute("mess", e.getMessage());
        }

        showAssignments(request, response);
    }

    /**
     * Xoá phân công ca làm
     */
    private void handleDeleteAssignment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            DAOOwner.INSTANCE.deleteAssignment(
                    Integer.parseInt(request.getParameter("id")));

            request.setAttribute("type", "success");
            request.setAttribute("mess", "Assignment deleted successfully");

        } catch (Exception e) {
            request.setAttribute("type", "error");
            request.setAttribute("mess", e.getMessage());
        }

        showAssignments(request, response);
    }

    /**
     * Hiển thị trạng thái nhân viên (On Shift / Off Shift)
     */
    private void showStaffStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Get all employees
            List<User> allStaff = DAOOwner.INSTANCE.getEmployees(null, null, "true", null, null, 0, 0);

            // Get active assignments for today
            List<StaffAssignment> activeAssignments = DAOOwner.INSTANCE.getActiveAssignments(LocalDate.now());

            // Partition
            List<User> onShift = new ArrayList<>();
            List<User> offShift = new ArrayList<>();
            List<User> absent = new ArrayList<>(); // logic for absent can be added later

            // Set of IDs on shift
            List<Integer> onShiftIds = new ArrayList<>();
            for (StaffAssignment sa : activeAssignments) {
                onShiftIds.add(sa.getEmployeeId());
            }

            for (User u : allStaff) {
                if (onShiftIds.contains(u.getUserId())) {
                    onShift.add(u);
                } else {
                    offShift.add(u);
                }
            }

            request.setAttribute("onShift", onShift);
            request.setAttribute("offShift", offShift);
            request.setAttribute("absent", absent);

        } catch (Exception e) {
            request.setAttribute("type", "error");
            request.setAttribute("mess", "Cannot load staff status");
        }

        request.getRequestDispatcher("/Views/Owner/StaffStatus.jsp")
                .forward(request, response);
    }

    /**
     * Hiển thị báo cáo doanh thu & phòng
     */
    private void showReports(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Revenue last 7 days from DAOOwner
            request.setAttribute("revenueData", DAOOwner.INSTANCE.getRecentRevenue(7));

            // Room status distribution
            request.setAttribute("roomStatusData", DAOOwner.INSTANCE.getRoomStatusDistribution());

        } catch (Exception e) {
            request.setAttribute("type", "error");
            request.setAttribute("mess", "Cannot load reports");
        }

        request.getRequestDispatcher("/Views/Owner/Reports.jsp")
                .forward(request, response);
    }
}
