package Controller.Housekeeping;

import DAL.Housekeeping.DAOHousekeeping;
import Model.HousekeepingTask;
import Model.Room;
import Model.StaffAssignment;
import Model.User;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;

import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


@WebServlet(
        name = "HousekeepingController",
        urlPatterns = {
            "/housekeeping/dashboard",
            "/housekeeping/tasks",
            "/housekeeping/task-detail",
            "/housekeeping/task-update",
            "/housekeeping/issue-report",
            "/housekeeping/room-update",
            "/housekeeping/create-task",
            "/housekeeping/rooms"
        }
)
public class HousekeepingController extends HttpServlet {

    // Cần khớp với role_id = HOUSEKEEPING trong bảng roles (theo script insert trước là 3)
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
        List<HousekeepingTask> todayTasks
                = DAOHousekeeping.INSTANCE.getTasksForStaffOnDate(staffId, today);

        // Phân ca làm việc hôm nay
        List<StaffAssignment> todayAssignments
                = DAOHousekeeping.INSTANCE.getAssignmentsForStaffOnDate(staffId, today);

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
        
        LocalDate dateFrom = null;
        LocalDate dateTo = null;
        try {
            if (dateFromStr != null && !dateFromStr.isBlank()) dateFrom = LocalDate.parse(dateFromStr);
            if (dateToStr != null && !dateToStr.isBlank()) dateTo = LocalDate.parse(dateToStr);
        } catch (DateTimeParseException e) {}
        
        int page = 1;
        int pageSize = 10;
        try {
            if (pageStr != null) page = Integer.parseInt(pageStr);
        } catch (NumberFormatException e) {}
        
        List<HousekeepingTask> tasks = DAOHousekeeping.INSTANCE.getTasks(
                staffId, dateFrom, dateTo, statusStr, search, sortBy, sortOrder, page, pageSize);
        int totalTasks = DAOHousekeeping.INSTANCE.countTasks(staffId, dateFrom, dateTo, statusStr, search);
        int totalPages = (int) Math.ceil((double) totalTasks / pageSize);

        request.setAttribute("tasks", tasks);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalTasks", totalTasks);
        
        // Preserve filter params
        request.setAttribute("dateFrom", dateFromStr);
        request.setAttribute("dateTo", dateToStr);
        request.setAttribute("status", statusStr);
        request.setAttribute("search", search);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("sortOrder", sortOrder);

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
            if (pageStr != null) page = Integer.parseInt(pageStr);
        } catch (NumberFormatException e) {}
        
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

   

    
    @Override
    public String getServletInfo() {
        return "Housekeeping module controller";
    }

    private void handleUpdateTask(HttpServletRequest request, HttpServletResponse response) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    private void handleCreateIssueReport(HttpServletRequest request, HttpServletResponse response) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    private void handleUpdateRoomStatus(HttpServletRequest request, HttpServletResponse response) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    private void showIssueReportForm(HttpServletRequest request, HttpServletResponse response) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    private void showRoomUpdateForm(HttpServletRequest request, HttpServletResponse response) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

}
