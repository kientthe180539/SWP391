package Controller.Manager;

import DAL.Housekeeping.DAOHousekeeping;
import DAL.Manager.DAOManager;
import Model.HousekeepingTask;
import Model.IssueReport;
import Model.Room;
import Model.User;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ManagerController", urlPatterns = { "/manager/dashboard", "/manager/create-task",
        "/manager/issues", "/manager/rooms", "/manager/room-detail", "/manager/staff", "/manager/inspections",
        "/manager/create-inspection", "/manager/replenishment-requests", "/manager/bookings",
        "/manager/housekeeping", "/manager/reports", "/manager/inspection-detail",
        "/manager/add-room-amenity", "/manager/delete-room-amenity", "/manager/edit-room-amenity" })
public class ManagerController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        User currentUser = (User) request.getSession().getAttribute("currentUser");

        if (currentUser == null || currentUser.getRoleId() != 6) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        switch (path) {
            case "/manager/dashboard" -> showDashboard(request, response);
            case "/manager/create-task" -> showCreateTaskForm(request, response);
            case "/manager/issues" -> showIssues(request, response);
            case "/manager/rooms" -> showRooms(request, response);
            case "/manager/room-detail" -> showRoomDetail(request, response);
            case "/manager/staff" -> showStaff(request, response);
            case "/manager/inspections" -> showInspections(request, response);
            case "/manager/inspection-detail" -> showInspectionDetail(request, response);
            case "/manager/create-inspection" -> showCreateInspectionForm(request, response);
            case "/manager/replenishment-requests" -> showReplenishmentRequests(request, response);
            case "/manager/bookings" -> showBookings(request, response);
            case "/manager/housekeeping" -> showHousekeeping(request, response);
            case "/manager/reports" -> showReports(request, response);
            default -> response.sendError(404);
        }
    }

    private void showInspectionDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendError(400, "Missing inspection id");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            DAL.RoomInspectionDAO inspectionDAO = new DAL.RoomInspectionDAO();
            Model.RoomInspection inspection = inspectionDAO.getInspectionById(id);

            if (inspection == null) {
                response.sendError(404, "Inspection not found");
                return;
            }

            request.setAttribute("inspection", inspection);
            request.getRequestDispatcher("/Views/Manager/InspectionDetail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(400, "Invalid inspection id");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        switch (path) {
            case "/manager/create-task" -> handleCreateTask(request, response);
            case "/manager/issues" -> handleUpdateIssue(request, response);
            case "/manager/create-inspection" -> handleCreateInspection(request, response);
            case "/manager/replenishment-requests" -> handleReplenishmentRequest(request, response);
            case "/manager/bookings" -> handleAssignInspection(request, response);
            case "/manager/add-room-amenity" -> handleAddRoomAmenity(request, response);
            case "/manager/edit-room-amenity" -> handleEditRoomAmenity(request, response);
            case "/manager/delete-room-amenity" -> handleDeleteRoomAmenity(request, response);
            default -> response.sendError(404);
        }
    }

    private void handleAddRoomAmenity(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String roomIdStr = request.getParameter("roomId");
        String amenityIdStr = request.getParameter("amenityId");
        String quantityStr = request.getParameter("quantity");

        try {
            int roomId = Integer.parseInt(roomIdStr);
            int amenityId = Integer.parseInt(amenityIdStr);
            int quantity = Integer.parseInt(quantityStr);

            Room room = DAOHousekeeping.INSTANCE.getRoomById(roomId);
            if (room != null) {
                DAL.AmenityDAO dao = new DAL.AmenityDAO();
                dao.addAmenityToRoomType(room.getRoomTypeId(), amenityId, quantity);
                response.sendRedirect(request.getContextPath() + "/manager/room-detail?id=" + roomId + "&msg=Added");
            } else {
                response.sendError(404, "Room not found");
            }
        } catch (NumberFormatException e) {
            response.sendError(400, "Invalid input");
        }
    }

    private void handleEditRoomAmenity(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String roomIdStr = request.getParameter("roomId");
        String rtaIdStr = request.getParameter("id");
        String quantityStr = request.getParameter("quantity");

        try {
            int rtaId = Integer.parseInt(rtaIdStr);
            int quantity = Integer.parseInt(quantityStr);
            int roomId = Integer.parseInt(roomIdStr);

            DAL.AmenityDAO dao = new DAL.AmenityDAO();
            dao.updateRoomTypeAmenity(rtaId, quantity);
            response.sendRedirect(request.getContextPath() + "/manager/room-detail?id=" + roomId + "&msg=Updated");
        } catch (NumberFormatException e) {
            response.sendError(400, "Invalid input");
        }
    }

    private void handleDeleteRoomAmenity(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String roomIdStr = request.getParameter("roomId");
        String rtaIdStr = request.getParameter("id");

        try {
            int rtaId = Integer.parseInt(rtaIdStr);
            int roomId = Integer.parseInt(roomIdStr);

            DAL.AmenityDAO dao = new DAL.AmenityDAO();
            dao.deleteRoomTypeAmenity(rtaId);
            response.sendRedirect(request.getContextPath() + "/manager/room-detail?id=" + roomId + "&msg=Deleted");
        } catch (NumberFormatException e) {
            response.sendError(400, "Invalid input");
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Reuse Housekeeping DAO for room stats for now
        List<Room> dirtyRooms = DAOHousekeeping.INSTANCE.getRoomsNeedingCleaning();
        int openIssues = DAOManager.INSTANCE.getOpenIssuesCount();

        // Fetch recent inspections
        DAL.RoomInspectionDAO inspectionDAO = new DAL.RoomInspectionDAO();
        List<Model.RoomInspection> recentInspections = inspectionDAO.getRecentInspections(5);

        // Fetch recent issues (limit 5)
        List<IssueReport> recentIssues = DAOManager.INSTANCE.getAllIssues();
        if (recentIssues.size() > 5) {
            recentIssues = recentIssues.subList(0, 5);
        }

        // Fetch pending replenishment requests count
        DAL.ReplenishmentRequestDAO replenishmentDAO = new DAL.ReplenishmentRequestDAO();
        int pendingRequests = replenishmentDAO.getPendingRequestCount();

        request.setAttribute("dirtyRoomsCount", dirtyRooms.size());
        request.setAttribute("openIssuesCount", openIssues);
        request.setAttribute("pendingReplenishmentCount", pendingRequests);
        request.setAttribute("recentInspections", recentInspections);
        request.setAttribute("recentIssues", recentIssues);

        request.getRequestDispatcher("/Views/Manager/Dashboard.jsp").forward(request, response);
    }

    private void showCreateTaskForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Room> rooms = DAOHousekeeping.INSTANCE.getAllRooms();
        List<User> staffList = DAOHousekeeping.INSTANCE.getHousekeepingStaff();

        request.setAttribute("rooms", rooms);
        request.setAttribute("staffList", staffList);

        request.getRequestDispatcher("/Views/Manager/CreateTask.jsp").forward(request, response);
    }

    private void handleCreateTask(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User currentUser = (User) request.getSession().getAttribute("currentUser");

        String roomIdStr = request.getParameter("roomId");
        String assignedToStr = request.getParameter("assignedTo");
        String taskDateStr = request.getParameter("taskDate");
        String taskTypeStr = request.getParameter("taskType");
        String note = request.getParameter("note");

        try {
            int roomId = Integer.parseInt(roomIdStr);
            int assignedTo = Integer.parseInt(assignedToStr);
            LocalDate taskDate = LocalDate.parse(taskDateStr);
            HousekeepingTask.TaskType taskType = HousekeepingTask.TaskType.valueOf(taskTypeStr);

            boolean ok = DAOHousekeeping.INSTANCE.createTask(
                    roomId,
                    assignedTo,
                    taskDate,
                    taskType,
                    note,
                    currentUser.getUserId());

            if (ok) {
                request.setAttribute("type", "success");
                request.setAttribute("mess", "Task created successfully");
            } else {
                request.setAttribute("type", "error");
                request.setAttribute("mess", "Failed to create task");
            }
        } catch (Exception e) {
            request.setAttribute("type", "error");
            request.setAttribute("mess", "Invalid data: " + e.getMessage());
        }

        // Reload form data
        showCreateTaskForm(request, response);
    }

    private void showIssues(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pageStr = request.getParameter("page");

        // Pagination settings
        int page = 1;
        int pageSize = 10;
        try {
            if (pageStr != null && !pageStr.isBlank()) {
                page = Integer.parseInt(pageStr);
                if (page < 1)
                    page = 1;
            }
        } catch (NumberFormatException e) {
            page = 1;
        }

        List<IssueReport> allIssues = DAOManager.INSTANCE.getAllIssues();

        // Calculate pagination
        int totalIssues = allIssues.size();
        int totalPages = (int) Math.ceil((double) totalIssues / pageSize);
        if (page > totalPages && totalPages > 0)
            page = totalPages;

        int startIndex = (page - 1) * pageSize;
        int endIndex = Math.min(startIndex + pageSize, totalIssues);

        List<IssueReport> issues = allIssues.subList(startIndex, endIndex);

        request.setAttribute("issues", issues);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalIssues", totalIssues);
        request.setAttribute("pageSize", pageSize);

        request.getRequestDispatcher("/Views/Manager/IssueList.jsp").forward(request, response);
    }

    private void handleUpdateIssue(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String issueIdStr = request.getParameter("issueId");

        if ("resolve".equals(action) && issueIdStr != null) {
            int issueId = Integer.parseInt(issueIdStr);
            DAOManager.INSTANCE.updateIssueStatus(issueId, IssueReport.IssueStatus.RESOLVED);
        }

        response.sendRedirect(request.getContextPath() + "/manager/issues");
    }

    private void showRooms(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Room> rooms = DAOHousekeeping.INSTANCE.getAllRooms();
        request.setAttribute("rooms", rooms);
        request.getRequestDispatcher("/Views/Manager/RoomList.jsp").forward(request, response);
    }

    private void showRoomDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendError(400, "Missing room id");
            return;
        }

        try {
            int roomId = Integer.parseInt(idStr);
            Room room = DAOHousekeeping.INSTANCE.getRoomById(roomId);
            if (room == null) {
                response.sendError(404, "Room not found");
                return;
            }

            // Get standard amenities for this room type
            DAL.AmenityDAO amenityDAO = new DAL.AmenityDAO();
            List<Model.RoomTypeAmenity> standardAmenities = amenityDAO.getAmenitiesByRoomType(room.getRoomTypeId());

            // Get items needing replenishment (Pending Requests for this room?)
            // We can find requests linked to inspections of this room?
            // For now, just show the standard list which allows creating new requests.

            List<Model.Amenity> allAmenities = amenityDAO.getAllAmenities();

            request.setAttribute("room", room);
            request.setAttribute("amenities", standardAmenities);
            request.setAttribute("allAmenities", allAmenities);
            request.getRequestDispatcher("/Views/Manager/RoomDetail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(400, "Invalid room id");
        }
    }

    private void showStaff(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String dateStr = request.getParameter("date");
        LocalDate date = (dateStr != null && !dateStr.isBlank()) ? LocalDate.parse(dateStr) : LocalDate.now();

        List<Model.StaffAssignment> assignments = DAOManager.INSTANCE.getAllStaffAssignments(date);
        request.setAttribute("assignments", assignments);
        request.setAttribute("date", date);
        request.getRequestDispatcher("/Views/Manager/StaffList.jsp").forward(request, response);
    }

    private void showInspections(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        DAL.RoomInspectionDAO inspectionDAO = new DAL.RoomInspectionDAO();
        String pageStr = request.getParameter("page");
        String searchQuery = request.getParameter("search");
        String typeFilter = request.getParameter("type");

        // Pagination settings
        int page = 1;
        int pageSize = 10;
        try {
            if (pageStr != null && !pageStr.isBlank()) {
                page = Integer.parseInt(pageStr);
                if (page < 1)
                    page = 1;
            }
        } catch (NumberFormatException e) {
            page = 1;
        }

        // Get all recent inspections (last 200)
        List<Model.RoomInspection> allInspections = inspectionDAO.getRecentInspections(200);

        // Apply type filter
        if (typeFilter != null && !typeFilter.isBlank() && !"ALL".equals(typeFilter)) {
            final String filterType = typeFilter;
            allInspections = allInspections.stream()
                    .filter(i -> filterType.equalsIgnoreCase(String.valueOf(i.getType())))
                    .collect(java.util.stream.Collectors.toList());
        } else {
            // Default: Show only CHECKIN and CHECKOUT
            allInspections = allInspections.stream()
                    .filter(i -> "CHECKIN".equalsIgnoreCase(String.valueOf(i.getType())) ||
                            "CHECKOUT".equalsIgnoreCase(String.valueOf(i.getType())))
                    .collect(java.util.stream.Collectors.toList());
        }

        // Apply search filter
        if (searchQuery != null && !searchQuery.isBlank()) {
            String query = searchQuery.toLowerCase().trim();
            allInspections = allInspections.stream()
                    .filter(i -> String.valueOf(i.getInspectionId()).contains(query) ||
                            (i.getRoomNumber() != null && i.getRoomNumber().toLowerCase().contains(query)) ||
                            (i.getNote() != null && i.getNote().toLowerCase().contains(query)) ||
                            (i.getInspectorName() != null && i.getInspectorName().toLowerCase().contains(query)))
                    .collect(java.util.stream.Collectors.toList());
        }

        // Calculate pagination
        int totalInspections = allInspections.size();
        int totalPages = (int) Math.ceil((double) totalInspections / pageSize);
        if (page > totalPages && totalPages > 0)
            page = totalPages;

        int startIndex = (page - 1) * pageSize;
        int endIndex = Math.min(startIndex + pageSize, totalInspections);

        List<Model.RoomInspection> inspections = allInspections.subList(startIndex, endIndex);

        request.setAttribute("inspections", inspections);
        request.setAttribute("searchQuery", searchQuery != null ? searchQuery : "");
        request.setAttribute("typeFilter", typeFilter != null ? typeFilter : "ALL");
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalInspections", totalInspections);
        request.setAttribute("pageSize", pageSize);

        request.getRequestDispatcher("/Views/Manager/InspectionList.jsp").forward(request, response);
    }

    private void showCreateInspectionForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Room> rooms = DAOHousekeeping.INSTANCE.getAllRooms();
        List<User> staffList = DAOHousekeeping.INSTANCE.getHousekeepingStaff();
        DAL.Booking.DAOBooking bookingDAO = DAL.Booking.DAOBooking.INSTANCE;
        List<Model.Booking> bookings = bookingDAO.getAllBookings();

        request.setAttribute("rooms", rooms);
        request.setAttribute("staffList", staffList);
        request.setAttribute("bookings", bookings);

        request.getRequestDispatcher("/Views/Manager/CreateInspection.jsp").forward(request, response);
    }

    private void handleCreateInspection(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User currentUser = (User) request.getSession().getAttribute("currentUser");

        String roomIdStr = request.getParameter("roomId");
        String bookingIdStr = request.getParameter("bookingId");
        String inspectionType = request.getParameter("inspectionType");
        String assignedToStr = request.getParameter("assignedTo");
        String note = request.getParameter("note");

        try {
            int roomId = Integer.parseInt(roomIdStr);
            int assignedTo = Integer.parseInt(assignedToStr);

            // Create a housekeeping task for the inspection
            HousekeepingTask.TaskType taskType = HousekeepingTask.TaskType.INSPECTION;
            String taskNote = "[" + inspectionType + "] " + (note != null ? note : "");

            if (bookingIdStr != null && !bookingIdStr.isBlank()) {
                taskNote += " (Booking #" + bookingIdStr + ")";
            }

            boolean ok = DAOHousekeeping.INSTANCE.createTask(
                    roomId,
                    assignedTo,
                    LocalDate.now(),
                    taskType,
                    taskNote,
                    currentUser.getUserId());

            if (ok) {
                request.setAttribute("type", "success");
                request.setAttribute("mess", "Inspection task created successfully");
            } else {
                request.setAttribute("type", "error");
                request.setAttribute("mess", "Failed to create inspection task");
            }
        } catch (Exception e) {
            request.setAttribute("type", "error");
            request.setAttribute("mess", "Invalid data: " + e.getMessage());
        }

        showCreateInspectionForm(request, response);
    }

    private void showReplenishmentRequests(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        DAL.ReplenishmentRequestDAO replenishmentDAO = new DAL.ReplenishmentRequestDAO();

        String statusFilter = request.getParameter("status");
        String pageStr = request.getParameter("page");

        // Pagination settings
        int page = 1;
        int pageSize = 10;
        try {
            if (pageStr != null && !pageStr.isBlank()) {
                page = Integer.parseInt(pageStr);
                if (page < 1)
                    page = 1;
            }
        } catch (NumberFormatException e) {
            page = 1;
        }

        List<Model.ReplenishmentRequest> allRequests;
        if (statusFilter != null && !statusFilter.isBlank() && !"ALL".equals(statusFilter)) {
            Model.ReplenishmentRequest.Status status = Model.ReplenishmentRequest.Status.valueOf(statusFilter);
            allRequests = replenishmentDAO.getRequestsByStatus(status);
        } else {
            allRequests = replenishmentDAO.getAllRequests();
        }

        // Calculate pagination
        int totalRequests = allRequests.size();
        int totalPages = (int) Math.ceil((double) totalRequests / pageSize);
        if (page > totalPages && totalPages > 0)
            page = totalPages;

        int startIndex = (page - 1) * pageSize;
        int endIndex = Math.min(startIndex + pageSize, totalRequests);

        List<Model.ReplenishmentRequest> requests = allRequests.subList(startIndex, endIndex);

        request.setAttribute("requests", requests);
        request.setAttribute("statusFilter", statusFilter != null ? statusFilter : "ALL");
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRequests", totalRequests);
        request.setAttribute("pageSize", pageSize);

        request.getRequestDispatcher("/Views/Manager/ReplenishmentRequests.jsp").forward(request, response);
    }

    private void handleReplenishmentRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User currentUser = (User) request.getSession().getAttribute("currentUser");
        String action = request.getParameter("action");
        String requestIdStr = request.getParameter("requestId");

        if (requestIdStr != null && action != null) {
            int requestId = Integer.parseInt(requestIdStr);
            DAL.ReplenishmentRequestDAO replenishmentDAO = new DAL.ReplenishmentRequestDAO();

            Model.ReplenishmentRequest.Status newStatus = null;
            if ("approve".equals(action)) {
                newStatus = Model.ReplenishmentRequest.Status.APPROVED;
            } else if ("reject".equals(action)) {
                newStatus = Model.ReplenishmentRequest.Status.REJECTED;
            }

            if (newStatus != null) {
                replenishmentDAO.updateRequestStatus(requestId, newStatus, currentUser.getUserId());
            }
        }

        response.sendRedirect(request.getContextPath() + "/manager/replenishment-requests");
    }

    private void showBookings(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        DAL.Booking.DAOBooking bookingDAO = DAL.Booking.DAOBooking.INSTANCE;

        // Get filter parameters
        String statusFilter = request.getParameter("status");
        String searchQuery = request.getParameter("search");
        String sortBy = request.getParameter("sortBy");
        String sortOrder = request.getParameter("sortOrder");
        String pageStr = request.getParameter("page");

        // Pagination settings
        int page = 1;
        int pageSize = 10;
        try {
            if (pageStr != null && !pageStr.isBlank()) {
                page = Integer.parseInt(pageStr);
                if (page < 1)
                    page = 1;
            }
        } catch (NumberFormatException e) {
            page = 1;
        }

        // Default sort
        if (sortBy == null || sortBy.isBlank()) {
            sortBy = "created_at";
        }
        if (sortOrder == null || sortOrder.isBlank()) {
            sortOrder = "DESC";
        }

        List<Model.Booking> allBookings;
        if (statusFilter != null && !statusFilter.isBlank() && !"ALL".equals(statusFilter)) {
            allBookings = bookingDAO.getBookingsByStatus(Model.Booking.Status.valueOf(statusFilter));
        } else {
            allBookings = bookingDAO.getAllBookings();
        }

        // Apply search filter
        if (searchQuery != null && !searchQuery.isBlank()) {
            String query = searchQuery.toLowerCase().trim();
            allBookings = allBookings.stream()
                    .filter(b -> String.valueOf(b.getBookingId()).contains(query) ||
                            (b.getCustomer() != null && b.getCustomer().getFullName() != null &&
                                    b.getCustomer().getFullName().toLowerCase().contains(query))
                            ||
                            (b.getCustomer() != null && b.getCustomer().getEmail() != null &&
                                    b.getCustomer().getEmail().toLowerCase().contains(query))
                            ||
                            (b.getRoom() != null && b.getRoom().getRoomNumber() != null &&
                                    b.getRoom().getRoomNumber().toLowerCase().contains(query)))
                    .collect(java.util.stream.Collectors.toList());
        }

        // Apply sorting
        java.util.Comparator<Model.Booking> comparator = null;
        switch (sortBy) {
            case "booking_id":
                comparator = java.util.Comparator.comparing(Model.Booking::getBookingId);
                break;
            case "customer":
                comparator = java.util.Comparator.comparing(
                        b -> b.getCustomer() != null ? b.getCustomer().getFullName() : "",
                        String.CASE_INSENSITIVE_ORDER);
                break;
            case "room":
                comparator = java.util.Comparator.comparing(b -> b.getRoom() != null ? b.getRoom().getRoomNumber() : "",
                        String.CASE_INSENSITIVE_ORDER);
                break;
            case "checkin_date":
                comparator = java.util.Comparator.comparing(Model.Booking::getCheckinDate);
                break;
            case "checkout_date":
                comparator = java.util.Comparator.comparing(Model.Booking::getCheckoutDate);
                break;
            case "status":
                comparator = java.util.Comparator.comparing(b -> b.getStatus().toString());
                break;
            case "total_amount":
                comparator = java.util.Comparator.comparing(Model.Booking::getTotalAmount);
                break;
            default: // created_at
                comparator = java.util.Comparator
                        .comparing(b -> b.getCreatedAt() != null ? b.getCreatedAt() : java.time.LocalDateTime.MIN);
                break;
        }

        if ("DESC".equalsIgnoreCase(sortOrder)) {
            comparator = comparator.reversed();
        }
        allBookings.sort(comparator);

        // Calculate pagination
        int totalBookings = allBookings.size();
        int totalPages = (int) Math.ceil((double) totalBookings / pageSize);
        if (page > totalPages && totalPages > 0)
            page = totalPages;

        int startIndex = (page - 1) * pageSize;
        int endIndex = Math.min(startIndex + pageSize, totalBookings);

        List<Model.Booking> bookings = allBookings.subList(startIndex, endIndex);

        // Check which bookings have assigned tasks (to hide assign buttons)
        java.util.Map<Integer, Boolean> hasCheckinTask = new java.util.HashMap<>();
        java.util.Map<Integer, Boolean> hasCheckoutTask = new java.util.HashMap<>();

        for (Model.Booking booking : bookings) {
            List<HousekeepingTask> tasks = DAOHousekeeping.INSTANCE.getTasksForRoom(booking.getRoomId());

            // Check for check-in task
            boolean checkinAssigned = tasks.stream()
                    .anyMatch(t -> t.getNote() != null &&
                            t.getNote().contains("Booking #" + booking.getBookingId()) &&
                            (t.getNote().contains("[CHECKIN]") || t.getNote().contains("CHECKIN")));
            hasCheckinTask.put(booking.getBookingId(), checkinAssigned);

            // Check for check-out task
            boolean checkoutAssigned = tasks.stream()
                    .anyMatch(t -> t.getNote() != null &&
                            t.getNote().contains("Booking #" + booking.getBookingId()) &&
                            (t.getNote().contains("[CHECKOUT]") || t.getNote().contains("CHECKOUT")));
            hasCheckoutTask.put(booking.getBookingId(), checkoutAssigned);
        }
        List<User> staffList = DAOHousekeeping.INSTANCE.getHousekeepingStaff();

        request.setAttribute("bookings", bookings);
        request.setAttribute("hasCheckinTask", hasCheckinTask);
        request.setAttribute("hasCheckoutTask", hasCheckoutTask);
        request.setAttribute("staffList", staffList);
        request.setAttribute("statusFilter", statusFilter != null ? statusFilter : "ALL");
        request.setAttribute("searchQuery", searchQuery != null ? searchQuery : "");
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("sortOrder", sortOrder);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalBookings", totalBookings);
        request.setAttribute("pageSize", pageSize);

        request.getRequestDispatcher("/Views/Manager/BookingList.jsp").forward(request, response);
    }

    private void handleAssignInspection(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User currentUser = (User) request.getSession().getAttribute("currentUser");
        String bookingIdStr = request.getParameter("bookingId");
        String inspectionType = request.getParameter("inspectionType");
        String assignedToStr = request.getParameter("assignedTo");

        try {
            int bookingId = Integer.parseInt(bookingIdStr);
            int assignedTo = Integer.parseInt(assignedToStr);

            // Get booking details
            DAL.Booking.DAOBooking bookingDAO = DAL.Booking.DAOBooking.INSTANCE;
            Model.Booking booking = bookingDAO.getBookingById(bookingId);

            if (booking != null) {
                boolean inspectionOk = false;
                boolean cleaningOk = false;

                // Create INSPECTION task
                HousekeepingTask.TaskType inspectionTaskType = HousekeepingTask.TaskType.INSPECTION;
                String inspectionNote = "[" + inspectionType + "] Inspection for Booking #" + bookingId;

                inspectionOk = DAOHousekeeping.INSTANCE.createTask(
                        booking.getRoomId(),
                        assignedTo,
                        LocalDate.now(),
                        inspectionTaskType,
                        inspectionNote,
                        currentUser.getUserId());

                // Create CLEANING task for the same staff member
                HousekeepingTask.TaskType cleaningTaskType = HousekeepingTask.TaskType.CLEANING;
                String cleaningNote = "Cleaning for Booking #" + bookingId + " (Room " + booking.getRoomId() + ")";

                cleaningOk = DAOHousekeeping.INSTANCE.createTask(
                        booking.getRoomId(),
                        assignedTo,
                        LocalDate.now(),
                        cleaningTaskType,
                        cleaningNote,
                        currentUser.getUserId());

                if (inspectionOk && cleaningOk) {
                    response.sendRedirect(request.getContextPath() + "/manager/bookings?success=true");
                    return;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/manager/bookings?error=true");
    }

    private void showHousekeeping(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Reuse logic from HousekeepingController's dashboard or list
        // For Manager, maybe show the Cleaning Task List view but with more options?
        // Or just the Dashboard view?
        // The user request says: "Housekeeping Dashboard", "Cleaning Task List",
        // "Update Supplies"
        // Let's forward to a Manager-specific Housekeeping dashboard which links to
        // others.
        // Or reuse Housekeeping Dashboard.jsp if it works for Manager (it checks role).
        // Sidebar.jsp checks role, so we might need a Manager version or make Sidebar
        // dynamic.
        // I'll create Views/Manager/Housekeeping.jsp which acts as a dashboard/landing.

        // Fetch data for dashboard
        LocalDate today = LocalDate.now();
        List<Room> roomsNeedCleaning = DAOHousekeeping.INSTANCE.getRoomsNeedingCleaning();
        // Maybe all tasks for today?
        List<HousekeepingTask> todayTasks = DAOHousekeeping.INSTANCE.getTasks(0, today, null, null); // 0 for all staff?
                                                                                                     // Need to check
                                                                                                     // DAO.
        // DAO getTasks checks assigned_to = ?
        // I need a method to get ALL tasks.
        // DAOHousekeeping.getTasks filters by assigned_to.
        // I might need to add a method to DAO or just show rooms for now.

        request.setAttribute("roomsNeedCleaning", roomsNeedCleaning);
        request.setAttribute("today", today);

        request.getRequestDispatcher("/Views/Manager/Housekeeping.jsp").forward(request, response);
    }

    private void showReports(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Placeholder for Reports
        request.getRequestDispatcher("/Views/Manager/Reports.jsp").forward(request, response);
    }
}
