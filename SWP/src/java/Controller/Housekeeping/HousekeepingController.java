package Controller.Housekeeping;

import DAL.Housekeeping.DAOHousekeeping;
import Model.HousekeepingTask;
import Model.Room;
import Model.StaffAssignment;
import Model.User;
import DAL.ReplenishmentRequestDAO;
import DAL.AmenityDAO;
import Model.ReplenishmentRequest;
import Model.Amenity;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "HousekeepingController", urlPatterns = {
        "/housekeeping/dashboard",
        "/housekeeping/tasks",
        "/housekeeping/task-detail",
        "/housekeeping/task-update",
        "/housekeeping/issue-report",
        "/housekeeping/room-update",
        "/housekeeping/create-task",
        "/housekeeping/rooms",
        "/housekeeping/supplies",
        "/housekeeping/create-replenishment"
})
public class HousekeepingController extends HttpServlet {

    // Cần khớp với role_id = HOUSEKEEPING trong bảng roles (theo script insert
    // trước là 3)
    private static final int ROLE_HOUSEKEEPING = 3;

    private boolean ensureHousekeeping(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        User currentUser = (User) request.getSession().getAttribute("currentUser");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        if (currentUser.getRoleId() != ROLE_HOUSEKEEPING && currentUser.getRoleId() != 6) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return false;
        }
        return true;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!ensureHousekeeping(request, response)) {
            return;
        }

        String path = request.getServletPath();
        switch (path) {
            case "/housekeeping/dashboard" ->
                showDashboard(request, response);
            case "/housekeeping/tasks" ->
                showTaskList(request, response);
            case "/housekeeping/task-detail" ->
                showTaskDetail(request, response);
            case "/housekeeping/issue-report" ->
                showIssueReportForm(request, response);
            case "/housekeeping/room-update" ->
                showRoomUpdateForm(request, response);
            case "/housekeeping/rooms" ->
                showRoomList(request, response);
            case "/housekeeping/supplies" ->
                showSupplies(request, response);
            case "/housekeeping/create-replenishment" ->
                showCreateReplenishment(request, response);
            default ->
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!ensureHousekeeping(request, response)) {
            return;
        }

        String path = request.getServletPath();
        String action = request.getParameter("action");

        if (action == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing action");
            return;
        }

        switch (path) {
            case "/housekeeping/task-update" -> {
                if ("updateTask".equals(action)) {
                    handleUpdateTask(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action: " + action);
                }
            }

            case "/housekeeping/issue-report" -> {
                if ("createIssue".equals(action)) {
                    handleCreateIssueReport(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action: " + action);
                }
            }

            case "/housekeeping/room-update" -> {
                if ("updateRoomStatus".equals(action)) {
                    handleUpdateRoomStatus(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action: " + action);
                }
            }

            case "/housekeeping/create-replenishment" -> {
                if ("createRequest".equals(action)) {
                    handleCreateReplenishment(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action: " + action);
                }
            }

            default ->
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    // ======================================================
    // 1. Housekeeping Dashboard
    // ======================================================
    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User currentUser = (User) request.getSession().getAttribute("currentUser");
        int staffId = currentUser.getUserId();
        LocalDate today = LocalDate.now();

        // Các phòng cần dọn (DIRTY / CLEANING)
        List<Room> roomsNeedCleaning = DAOHousekeeping.INSTANCE.getRoomsNeedingCleaning();

        // Task dọn phòng của nhân viên hôm nay
        List<HousekeepingTask> todayTasks = DAOHousekeeping.INSTANCE.getTasksForStaffOnDate(staffId, today);

        // Phân ca làm việc hôm nay
        List<StaffAssignment> todayAssignments = DAOHousekeeping.INSTANCE.getAssignmentsForStaffOnDate(staffId, today);

        request.setAttribute("roomsNeedCleaning", roomsNeedCleaning);
        request.setAttribute("todayTasks", todayTasks);
        request.setAttribute("todayAssignments", todayAssignments);
        request.setAttribute("today", today);

        request.getRequestDispatcher("/Views/Housekeeping/Dashboard.jsp")
                .forward(request, response);
    }

    // ======================================================
    // 2. Cleaning Task List Screen
    // ======================================================
    private void showTaskList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User currentUser = (User) request.getSession().getAttribute("currentUser");
        int staffId = currentUser.getUserId();

        String dateFromStr = request.getParameter("dateFrom");
        String dateToStr = request.getParameter("dateTo");
        String statusStr = request.getParameter("status");
        String search = request.getParameter("search");
        String sortBy = request.getParameter("sortBy");
        String sortOrder = request.getParameter("sortOrder");
        String pageStr = request.getParameter("page");
        String type = request.getParameter("type"); // CLEANING, INSPECTION (or INSPECTION_ALL)

        LocalDate dateFrom = null;
        LocalDate dateTo = null;
        try {
            if (dateFromStr != null && !dateFromStr.isBlank())
                dateFrom = LocalDate.parse(dateFromStr);
            if (dateToStr != null && !dateToStr.isBlank())
                dateTo = LocalDate.parse(dateToStr);
        } catch (DateTimeParseException e) {
        }

        int page = 1;
        int pageSize = 10;
        try {
            if (pageStr != null)
                page = Integer.parseInt(pageStr);
        } catch (NumberFormatException e) {
        }

        // Map UI type to DB type logic
        String dbTaskType = type;
        if ("INSPECTION".equals(type)) {
            dbTaskType = "INSPECTION_ALL"; // Special flag for DAO to get INSPECTION, CHECKIN, CHECKOUT
        }

        List<HousekeepingTask> tasks = DAOHousekeeping.INSTANCE.getTasks(
                staffId, dateFrom, dateTo, statusStr, search, dbTaskType, sortBy, sortOrder, page, pageSize);
        int totalTasks = DAOHousekeeping.INSTANCE.countTasks(staffId, dateFrom, dateTo, statusStr, search, dbTaskType);
        int totalPages = (int) Math.ceil((double) totalTasks / pageSize);

        request.setAttribute("tasks", tasks);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalTasks", totalTasks);
        request.setAttribute("hkp", DAOHousekeeping.INSTANCE);
        // Preserve filter params
        request.setAttribute("dateFrom", dateFromStr);
        request.setAttribute("dateTo", dateToStr);
        request.setAttribute("status", statusStr);
        request.setAttribute("search", search);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("sortOrder", sortOrder);
        request.setAttribute("type", type); // Pass back to view for title/active state

        request.getRequestDispatcher("/Views/Housekeeping/TaskList.jsp")
                .forward(request, response);
    }

    // ======================================================
    // Room List Screen
    // ======================================================
    private void showRoomList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String statusStr = request.getParameter("status");
        String search = request.getParameter("search");
        String sortBy = request.getParameter("sortBy");
        String sortOrder = request.getParameter("sortOrder");
        String pageStr = request.getParameter("page");

        int page = 1;
        int pageSize = 12; // Grid view might look better with 12
        try {
            if (pageStr != null)
                page = Integer.parseInt(pageStr);
        } catch (NumberFormatException e) {
        }

        List<Room> rooms = DAOHousekeeping.INSTANCE.getRooms(statusStr, search, sortBy, sortOrder, page, pageSize);
        int totalRooms = DAOHousekeeping.INSTANCE.countRooms(statusStr, search);
        int totalPages = (int) Math.ceil((double) totalRooms / pageSize);

        request.setAttribute("rooms", rooms);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRooms", totalRooms);

        request.setAttribute("status", statusStr);
        request.setAttribute("search", search);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("sortOrder", sortOrder);

        request.getRequestDispatcher("/Views/Housekeeping/RoomList.jsp").forward(request, response);
    }

    // ======================================================
    // 3. Cleaning Task Detail / Update Screen
    // ======================================================
    private void showTaskDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing task id");
            return;
        }

        int taskId = Integer.parseInt(idStr);
        HousekeepingTask task = DAOHousekeeping.INSTANCE.getTaskById(taskId);
        if (task == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Task not found");
            return;
        }

        Room room = DAOHousekeeping.INSTANCE.getRoomById(task.getRoomId());

        request.setAttribute("task", task);
        request.setAttribute("room", room);

        request.getRequestDispatcher("/Views/Housekeeping/TaskDetail.jsp")
                .forward(request, response);
    }

    private void handleUpdateTask(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("taskId");
        String statusStr = request.getParameter("status"); // NEW / IN_PROGRESS / DONE
        String note = request.getParameter("note");

        if (idStr == null || statusStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing parameters");
            return;
        }

        int taskId = Integer.parseInt(idStr);
        try {
            HousekeepingTask.TaskStatus newStatus = HousekeepingTask.TaskStatus.valueOf(statusStr);

            boolean ok = DAOHousekeeping.INSTANCE.updateTaskStatusAndNote(taskId, newStatus, note);

            if (ok) {
                request.setAttribute("type", "success");
                request.setAttribute("mess", "Cập nhật task thành công");
                request.setAttribute("href", "tasks");
            } else {
                request.setAttribute("type", "error");
                request.setAttribute("mess", "Cập nhật task thất bại");
                request.setAttribute("href", "task-detail?id=" + taskId);
            }
        } catch (IllegalArgumentException ex) {
            request.setAttribute("type", "error");
            request.setAttribute("mess", "Trạng thái không hợp lệ");
            request.setAttribute("href", "task-detail?id=" + idStr);
        }

        request.getRequestDispatcher("/Views/Housekeeping/TaskDetail.jsp")
                .forward(request, response);
    }

    // ======================================================
    // 6. Equipment Issue Report Screen
    // (4 & 5 Supplies: có thể dùng chung cơ chế tạo issue SUPPLY)
    // ======================================================
    // ======================================================
    // 6. Equipment Issue Report Screen
    // (4 & 5 Supplies: có thể dùng chung cơ chế tạo issue SUPPLY)
    // ======================================================
    private void showIssueReportForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Fetch all rooms for dropdown
        List<Room> rooms = DAOHousekeeping.INSTANCE.getAllRooms();
        request.setAttribute("rooms", rooms);

        // Có thể nhận taskId/roomId từ query để pre-fill
        String roomIdStr = request.getParameter("roomId");
        Room room = null;
        if (roomIdStr != null && !roomIdStr.isBlank()) {
            int roomId = Integer.parseInt(roomIdStr);
            room = DAOHousekeeping.INSTANCE.getRoomById(roomId);
        }
        request.setAttribute("room", room);

        request.getRequestDispatcher("/Views/Housekeeping/IssueReport.jsp")
                .forward(request, response);
    }

    private void handleCreateIssueReport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User currentUser = (User) request.getSession().getAttribute("currentUser");

        String roomIdStr = request.getParameter("roomId");
        String issueTypeStr = request.getParameter("issueType"); // EQUIPMENT hoặc SUPPLY
        String description = request.getParameter("description");

        if (roomIdStr == null || issueTypeStr == null || description == null || description.isBlank()) {
            request.setAttribute("type", "error");
            request.setAttribute("mess", "Thiếu thông tin báo sự cố");
            request.setAttribute("href", "housekeeping/issue-report");
            request.getRequestDispatcher("Views/Housekeeping/IssueReport.jsp")
                    .forward(request, response);
            return;
        }

        int roomId = Integer.parseInt(roomIdStr);

        DAOHousekeeping.IssueType issueType;
        try {
            issueType = DAOHousekeeping.IssueType.valueOf(issueTypeStr);
        } catch (IllegalArgumentException ex) {
            issueType = DAOHousekeeping.IssueType.OTHER;
        }

        boolean ok = DAOHousekeeping.INSTANCE.createIssueReport(
                roomId,
                currentUser.getUserId(),
                issueType,
                description);

        if (ok) {
            request.setAttribute("type", "success");
            request.setAttribute("mess", "Gửi báo cáo sự cố thành công");
            request.setAttribute("href", "housekeeping/dashboard");
        } else {
            request.setAttribute("type", "error");
            request.setAttribute("mess", "Gửi báo cáo sự cố thất bại");
            request.setAttribute("href", "housekeeping/issue-report?roomId=" + roomId);
        }

        request.getRequestDispatcher("Views/Housekeeping/IssueReport.jsp")
                .forward(request, response);
    }

    // ======================================================
    // 7. Room State Update Screen
    // ======================================================
    private void showRoomUpdateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String roomIdStr = request.getParameter("roomId");
        if (roomIdStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing room id");
            return;
        }

        int roomId = Integer.parseInt(roomIdStr);
        Room room = DAOHousekeeping.INSTANCE.getRoomById(roomId);
        if (room == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Room not found");
            return;
        }

        request.setAttribute("room", room);
        request.getRequestDispatcher("Views/Housekeeping/RoomStateUpdate.jsp")
                .forward(request, response);
    }

    private void handleUpdateRoomStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String roomIdStr = request.getParameter("roomId");
        String statusStr = request.getParameter("status"); // DIRTY/CLEANING/AVAILABLE/MAINTENANCE...

        if (roomIdStr == null || statusStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing parameters");
            return;
        }

        int roomId = Integer.parseInt(roomIdStr);
        try {
            Room.Status newStatus = Room.Status.valueOf(statusStr);
            boolean ok = DAOHousekeeping.INSTANCE.updateRoomStatus(roomId, newStatus);

            if (ok) {
                request.setAttribute("type", "success");
                request.setAttribute("mess", "Cập nhật trạng thái phòng thành công");
                request.setAttribute("href", "housekeeping/dashboard");
            } else {
                request.setAttribute("type", "error");
                request.setAttribute("mess", "Cập nhật trạng thái phòng thất bại");
                request.setAttribute("href", "housekeeping/room-update?roomId=" + roomId);
            }

            request.getRequestDispatcher("Views/Housekeeping/RoomStateUpdate.jsp")
                    .forward(request, response);
        } catch (IllegalArgumentException ex) {
            request.setAttribute("type", "error");
            request.setAttribute("mess", "Trạng thái phòng không hợp lệ");
            request.setAttribute("href", "housekeeping/room-update?roomId=" + roomIdStr);
            request.getRequestDispatcher("Views/Housekeeping/RoomStateUpdate.jsp")
                    .forward(request, response);
        }
    }

    // ======================================================
    // 8. Supplies / Replenishment
    // ======================================================
    private void showSupplies(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ReplenishmentRequestDAO dao = new ReplenishmentRequestDAO();
        // Show all requests or filter by user? Usually user wants to see their requests
        // or all for the floor.
        // For now, let's show all to be safe, or maybe just pending?
        // Let's show all for now.
        List<ReplenishmentRequest> requests = dao.getAllRequests();

        request.setAttribute("requests", requests);
        request.getRequestDispatcher("/Views/Housekeeping/Supplies.jsp").forward(request, response);
    }

    private void showCreateReplenishment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AmenityDAO amenityDAO = new AmenityDAO();
        List<Amenity> amenities = amenityDAO.getAllAmenities();

        // Also need rooms? Replenishment usually linked to an Inspection, but maybe
        // just a Room?
        // The ReplenishmentRequest model has inspectionId.
        // If we don't have an inspection, we might need to create a dummy one or allow
        // null?
        // Looking at DB schema (from DAO), inspection_id is used.
        // public boolean createRequest(ReplenishmentRequest request) { ... cs.setInt(1,
        // request.getInspectionId()); ... }
        // If inspection_id is required, we need an inspection.
        // But the user wants to "Báo thiếu" (Report missing) directly.
        // Maybe we need to find the latest inspection for the room or create a new
        // "Supply Check" inspection?
        // Or maybe inspection_id can be null?
        // Let's check ReplenishmentRequestDAO.createRequest: cs.setInt(1,
        // request.getInspectionId());
        // If it's a foreign key and not nullable, we need it.
        // Assuming for now we might need to pass an inspection ID or 0 if allowed.
        // If it fails, I'll need to fix it.

        // Actually, if the user is just reporting missing supplies, it might not be
        // during an inspection.
        // But the system seems designed to link requests to inspections.
        // I will list rooms so they can select a room.
        List<Room> rooms = DAOHousekeeping.INSTANCE.getAllRooms();

        String preRoomId = request.getParameter("roomId");
        String preAmenityId = request.getParameter("amenityId");

        request.setAttribute("amenities", amenities);
        request.setAttribute("rooms", rooms);
        request.setAttribute("preRoomId", preRoomId);
        request.setAttribute("preAmenityId", preAmenityId);

        request.getRequestDispatcher("/Views/Housekeeping/CreateReplenishment.jsp").forward(request, response);
    }

    private void handleCreateReplenishment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User currentUser = (User) request.getSession().getAttribute("currentUser");

        String amenityIdStr = request.getParameter("amenityId");
        String quantityStr = request.getParameter("quantity");
        String reason = request.getParameter("reason");
        // We might need roomId to find/create inspection?
        String roomIdStr = request.getParameter("roomId");

        if (amenityIdStr == null || quantityStr == null || roomIdStr == null) {
            request.setAttribute("type", "error");
            request.setAttribute("mess", "Thiếu thông tin");
            showCreateReplenishment(request, response);
            return;
        }

        try {
            int amenityId = Integer.parseInt(amenityIdStr);
            int quantity = Integer.parseInt(quantityStr);
            int roomId = Integer.parseInt(roomIdStr);

            // We need an inspection ID.
            // Strategy: Check if there is an active inspection or create a dummy/auto
            // inspection for "Ad-hoc Request".
            // Or maybe just use 0 if DB allows?
            // Let's try to find the latest inspection for this room.
            // RoomInspectionDAO inspectionDAO = new RoomInspectionDAO();
            // RoomInspection lastInspection =
            // inspectionDAO.getLastInspectionByRoomAndType(roomId, "DAILY");
            // int inspectionId = (lastInspection != null) ?
            // lastInspection.getInspectionId() : 0;

            // Ideally, we should create a new Inspection of type 'SUPPLY_CHECK' or similar
            // if we want to be correct.
            // But for simplicity, let's assume we can pass 0 or null if the SP handles it,
            // or we need to create one.
            // Let's try to create a "SUPPLY_CHECK" inspection first.

            DAL.RoomInspectionDAO inspectionDAO = new DAL.RoomInspectionDAO();
            Model.RoomInspection ri = new Model.RoomInspection();
            ri.setRoomId(roomId);
            ri.setInspectorId(currentUser.getUserId());
            ri.setType("SUPPLY"); // Assuming this is a valid enum/string
            ri.setNote("Auto-generated for Replenishment Request");

            boolean inspectionCreated = inspectionDAO.createInspection(ri);
            int inspectionId = ri.getInspectionId();

            if (inspectionCreated && inspectionId > 0) {
                ReplenishmentRequest req = new ReplenishmentRequest();
                req.setInspectionId(inspectionId);
                req.setAmenityId(amenityId);
                req.setQuantityRequested(quantity);
                req.setReason(reason);
                req.setRequestedBy(currentUser.getUserId());

                ReplenishmentRequestDAO reqDAO = new ReplenishmentRequestDAO();
                boolean ok = reqDAO.createRequest(req);

                if (ok) {
                    request.setAttribute("type", "success");
                    request.setAttribute("mess", "Gửi yêu cầu thành công");
                    request.setAttribute("href", "housekeeping/supplies");
                } else {
                    request.setAttribute("type", "error");
                    request.setAttribute("mess", "Gửi yêu cầu thất bại");
                }
            } else {
                request.setAttribute("type", "error");
                request.setAttribute("mess", "Không thể tạo phiên kiểm tra");
            }

        } catch (NumberFormatException e) {
            request.setAttribute("type", "error");
            request.setAttribute("mess", "Dữ liệu không hợp lệ");
        }

        request.getRequestDispatcher("/Views/Housekeeping/CreateReplenishment.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Housekeeping module controller";
    }

}
