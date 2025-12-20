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
        "/manager/reports", "/manager/inspection-detail", "/manager/all-tasks",
        "/manager/add-room-amenity", "/manager/delete-room-amenity", "/manager/edit-room-amenity",
        "/manager/schedule" })
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
            case "/manager/all-tasks" -> showAllTasks(request, response);
            case "/manager/schedule" -> showSchedule(request, response);

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

    private void showSchedule(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Permanent Schedule View
        List<Model.StaffAssignment> assignments = DAL.Owner.DAOOwner.INSTANCE.getAllCurrentAssignments();

        request.setAttribute("assignments", assignments);
        // Date is no longer central, but we can pass today for display if needed
        request.setAttribute("date", LocalDate.now());
        request.getRequestDispatcher("/Views/Shared/ViewSchedule.jsp").forward(request, response);
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
        String search = request.getParameter("search");
        String status = request.getParameter("status");
        String type = request.getParameter("type");
        String sortBy = request.getParameter("sortBy");

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

        List<IssueReport> issues = DAOManager.INSTANCE.getIssues(search, status, type, sortBy, page, pageSize);
        int totalIssues = DAOManager.INSTANCE.countIssues(search, status, type);
        int totalPages = (int) Math.ceil((double) totalIssues / pageSize);

        request.setAttribute("issues", issues);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalIssues", totalIssues);

        request.setAttribute("search", search);
        request.setAttribute("status", status);
        request.setAttribute("type", type);
        request.setAttribute("sortBy", sortBy);

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
        String sortBy = request.getParameter("sortBy");

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

        List<Model.RoomInspection> inspections = inspectionDAO.getInspections(typeFilter, searchQuery, sortBy, page,
                pageSize);
        int totalInspections = inspectionDAO.countInspections(typeFilter, searchQuery);
        int totalPages = (int) Math.ceil((double) totalInspections / pageSize);

        request.setAttribute("inspections", inspections);
        request.setAttribute("searchQuery", searchQuery != null ? searchQuery : "");
        request.setAttribute("typeFilter", typeFilter != null ? typeFilter : "ALL");
        request.setAttribute("sortBy", sortBy != null ? sortBy : "");
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

        String inspectionType = request.getParameter("inspectionType");
        String assignedToStr = request.getParameter("assignedTo");
        String taskDateStr = request.getParameter("taskDate");
        String note = request.getParameter("note");

        try {
            int roomId = Integer.parseInt(roomIdStr);
            int assignedTo = Integer.parseInt(assignedToStr);
            LocalDate taskDate = (taskDateStr != null && !taskDateStr.isBlank())
                    ? LocalDate.parse(taskDateStr)
                    : LocalDate.now();

            // Create a housekeeping task for the inspection
            HousekeepingTask.TaskType taskType = HousekeepingTask.TaskType.INSPECTION;
            String taskNote = "[" + inspectionType + "] " + (note != null ? note : "");

            boolean ok = DAOHousekeeping.INSTANCE.createTask(
                    roomId,
                    assignedTo,
                    taskDate,
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

        showCreateTaskForm(request, response);
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

        // Fetch filtered, sorted, paginated list from DAO
        List<Model.Booking> bookings = bookingDAO.getBookings(searchQuery, statusFilter, sortBy, sortOrder, page,
                pageSize);
        int totalBookings = bookingDAO.countBookings(searchQuery, statusFilter);
        int totalPages = (int) Math.ceil((double) totalBookings / pageSize);

        // Check which bookings have assigned tasks (to hide assign buttons)
        /* Logic continues below... subList replaced by 'bookings' */

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
        String scheduledDateStr = request.getParameter("scheduledDate");

        try {
            int bookingId = Integer.parseInt(bookingIdStr);
            int assignedTo = Integer.parseInt(assignedToStr);

            // Parse scheduled date - default to today if not provided
            LocalDate scheduledDate = LocalDate.now();
            if (scheduledDateStr != null && !scheduledDateStr.isBlank()) {
                scheduledDate = LocalDate.parse(scheduledDateStr);
            }

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
                        scheduledDate,
                        inspectionTaskType,
                        inspectionNote,
                        currentUser.getUserId());

                // Create CLEANING task for the same staff member (same scheduled date)
                HousekeepingTask.TaskType cleaningTaskType = HousekeepingTask.TaskType.CLEANING;
                String cleaningNote = "Cleaning for Booking #" + bookingId + " (Room " + booking.getRoomId() + ")";

                cleaningOk = DAOHousekeeping.INSTANCE.createTask(
                        booking.getRoomId(),
                        assignedTo,
                        scheduledDate,
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

    private void showReports(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        DAOHousekeeping hkDao = DAOHousekeeping.INSTANCE;
        DAOManager mgrDao = DAOManager.INSTANCE;

        // Task Statistics
        // Task Statistics
        int totalTasks = DAOHousekeeping.INSTANCE.countTasks(0, null, null, null, null, null, null);
        int newTasks = DAOHousekeeping.INSTANCE.countTasks(0, null, null, "NEW", null, null, null);
        int inProgressTasks = DAOHousekeeping.INSTANCE.countTasks(0, null, null, "IN_PROGRESS", null, null, null);
        int completedTasks = DAOHousekeeping.INSTANCE.countTasks(0, null, null, "DONE", null, null, null);

        // Task by Type
        int cleaningTasks = DAOHousekeeping.INSTANCE.countTasks(0, null, null, null, null, "CLEANING", null);
        int inspectionTasks = DAOHousekeeping.INSTANCE.countTasks(0, null, null, null, null, "INSPECTION_ALL", null);

        // Map these to request attributes expected by Reports.jsp
        request.setAttribute("countAll", totalTasks);
        request.setAttribute("countNew", newTasks);
        request.setAttribute("countInProgress", inProgressTasks);
        request.setAttribute("countDone", completedTasks);
        request.setAttribute("countCleaning", cleaningTasks);
        request.setAttribute("countInspection", inspectionTasks);

        // Room Statistics
        List<Room> allRooms = hkDao.getAllRooms();
        int totalRooms = allRooms.size();
        int availableRooms = 0;
        int occupiedRooms = 0;
        int dirtyRooms = 0;
        int maintenanceRooms = 0;

        for (Room r : allRooms) {
            switch (r.getStatus()) {
                case AVAILABLE -> availableRooms++;
                case OCCUPIED, BOOKED -> occupiedRooms++;
                case DIRTY, CLEANING -> dirtyRooms++;
                case MAINTENANCE -> maintenanceRooms++;
                default -> {
                }
            }
        }

        // Issue Statistics
        List<IssueReport> allIssues = mgrDao.getAllIssues();
        int totalIssues = allIssues.size();
        int newIssues = 0;
        int resolvedIssues = 0;

        for (IssueReport i : allIssues) {
            if (i.getStatus() == IssueReport.IssueStatus.NEW)
                newIssues++;
            if (i.getStatus() == IssueReport.IssueStatus.RESOLVED)
                resolvedIssues++;
        }

        // Staff Statistics
        List<User> staff = hkDao.getHousekeepingStaff();
        int totalStaff = staff.size();

        // Set attributes
        request.setAttribute("totalTasks", totalTasks); // These attributes are no longer set directly from hkDao calls,
                                                        // but the instruction doesn't remove them.
        request.setAttribute("newTasks", newTasks); // Keeping them as per instruction to only make specified changes.
        request.setAttribute("inProgressTasks", inProgressTasks);
        request.setAttribute("completedTasks", completedTasks);
        request.setAttribute("cleaningTasks", cleaningTasks);
        request.setAttribute("inspectionTasks", inspectionTasks);

        request.setAttribute("totalRooms", totalRooms);
        request.setAttribute("availableRooms", availableRooms);
        request.setAttribute("occupiedRooms", occupiedRooms);
        request.setAttribute("dirtyRooms", dirtyRooms);
        request.setAttribute("maintenanceRooms", maintenanceRooms);

        request.setAttribute("totalIssues", totalIssues);
        request.setAttribute("newIssues", newIssues);
        request.setAttribute("resolvedIssues", resolvedIssues);

        request.setAttribute("totalStaff", totalStaff);

        // Completion rate
        double completionRate = totalTasks > 0 ? (completedTasks * 100.0 / totalTasks) : 0;
        request.setAttribute("completionRate", String.format("%.1f", completionRate));

        // Occupancy rate
        double occupancyRate = totalRooms > 0 ? (occupiedRooms * 100.0 / totalRooms) : 0;
        request.setAttribute("occupancyRate", String.format("%.1f", occupancyRate));

        request.getRequestDispatcher("/Views/Manager/Reports.jsp").forward(request, response);
    }

    private void showAllTasks(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Filter params
        String staffIdStr = request.getParameter("staffId");
        String dateFromStr = request.getParameter("dateFrom");
        String dateToStr = request.getParameter("dateTo");
        String statusStr = request.getParameter("status");
        String taskTypeStr = request.getParameter("type");
        String searchQuery = request.getParameter("search");
        String pageStr = request.getParameter("page");
        String sortBy = request.getParameter("sortBy");
        String sortOrder = request.getParameter("sortOrder");

        // Defaults
        int staffId = 0;
        if (staffIdStr != null && !staffIdStr.isBlank()) {
            try {
                staffId = Integer.parseInt(staffIdStr);
            } catch (Exception e) {
            }
        }

        LocalDate dateFrom = null;
        if (dateFromStr != null && !dateFromStr.isBlank()) {
            try {
                dateFrom = LocalDate.parse(dateFromStr);
            } catch (Exception e) {
            }
        }

        LocalDate dateTo = null;
        if (dateToStr != null && !dateToStr.isBlank()) {
            try {
                dateTo = LocalDate.parse(dateToStr);
            } catch (Exception e) {
            }
        }

        // Pagination
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

        DAOHousekeeping dao = DAOHousekeeping.INSTANCE;

        // Get Tasks
        String search = searchQuery; // Renamed for clarity in the new method call
        String dbTaskType = taskTypeStr; // Renamed for clarity in the new method call
        List<HousekeepingTask> tasks = DAOHousekeeping.INSTANCE.getTasks(
                staffId, dateFrom, dateTo, statusStr, search, dbTaskType, sortBy, sortOrder, page, pageSize, null);
        int totalTasks = DAOHousekeeping.INSTANCE.countTasks(staffId, dateFrom, dateTo, statusStr, search, dbTaskType,
                null); // Pass null instead of creatorRoleIdStr);
        int totalPages = (int) Math.ceil((double) totalTasks / pageSize);

        // Get auxiliary data for filters
        List<User> staffList = dao.getHousekeepingStaff();
        // We might want rooms too if we filter by room, but search covers it.

        request.setAttribute("tasks", tasks);
        request.setAttribute("staffList", staffList);

        String selectedStaffName = "";
        if (staffId > 0) {
            for (User u : staffList) {
                if (u.getUserId() == staffId) {
                    selectedStaffName = u.getFullName();
                    break;
                }
            }
        }
        request.setAttribute("selectedStaffName", selectedStaffName);

        // Set attributes for form retention
        request.setAttribute("staffId", staffId);
        request.setAttribute("dateFrom", dateFrom);
        request.setAttribute("dateTo", dateTo);
        request.setAttribute("status", statusStr);
        request.setAttribute("type", taskTypeStr);
        request.setAttribute("search", searchQuery);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("sortOrder", sortOrder);

        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalTasks", totalTasks);
        request.setAttribute("pageSize", pageSize);

        request.getRequestDispatcher("/Views/Manager/AllTasks.jsp").forward(request, response);
    }
}
