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

@WebServlet(name = "ManagerController", urlPatterns = {"/manager/dashboard", "/manager/create-task", "/manager/issues"})
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
            default -> response.sendError(404);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        
        switch (path) {
            case "/manager/create-task" -> handleCreateTask(request, response);
            case "/manager/issues" -> handleUpdateIssue(request, response);
            default -> response.sendError(404);
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Reuse Housekeeping DAO for room stats for now
        List<Room> dirtyRooms = DAOHousekeeping.INSTANCE.getRoomsNeedingCleaning();
        int openIssues = DAOManager.INSTANCE.getOpenIssuesCount();
        
        request.setAttribute("dirtyRoomsCount", dirtyRooms.size());
        request.setAttribute("openIssuesCount", openIssues);
        
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
                    currentUser.getUserId()
            );

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
        List<IssueReport> issues = DAOManager.INSTANCE.getAllIssues();
        request.setAttribute("issues", issues);
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
}
