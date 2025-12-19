package Controller.Admin;

import DAL.Admin.DAOAdmin;
import Model.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "AdminController", urlPatterns = {
        "/admin/dashboard",
        "/admin/users",
        "/admin/user-detail",
        "/admin/roles",
        "/admin/config",
        "/admin/logs",
        "/admin/employees",
        "/admin/create-employee"
})
public class AdminController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Authorization check (Role ID 5 = Admin)
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || currentUser.getRoleId() != 5) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String path = request.getServletPath();

        switch (path) {
            case "/admin/dashboard":
                showDashboard(request, response);
                break;
            case "/admin/users":
                showUserList(request, response);
                break;
            case "/admin/user-detail":
                showUserDetail(request, response);
                break;
            case "/admin/roles":
                request.getRequestDispatcher("/Views/Admin/RoleManagement.jsp").forward(request, response);
                break;
            case "/admin/config":
                request.getRequestDispatcher("/Views/Admin/SystemConfig.jsp").forward(request, response);
                break;
            case "/admin/logs":
                request.getRequestDispatcher("/Views/Admin/SystemLogs.jsp").forward(request, response);
                break;
            case "/admin/employees":
                showEmployeeList(request, response);
                break;
            case "/admin/create-employee":
                request.getRequestDispatcher("/Views/Admin/CreateEmployee.jsp").forward(request, response);
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
        if (currentUser == null || currentUser.getRoleId() != 5) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null)
            action = "";

        switch (action) {
            case "updateUser":
                handleUpdateUser(request, response);
                break;
            case "toggleStatus":
                handleToggleStatus(request, response);
                break;
            case "resetPassword":
                handleResetPassword(request, response);
                break;
            case "createEmployee":
                handleCreateEmployee(request, response);
                break;
            default:
                doGet(request, response);
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int totalAccounts = DAOAdmin.INSTANCE.getTotalAccounts();
        int activeUsers = DAOAdmin.INSTANCE.getActiveUserCount();
        java.util.Map<String, Integer> usersByRole = DAOAdmin.INSTANCE.getUsersCountByRole();
        java.util.Map<String, Integer> roomStatus = DAOAdmin.INSTANCE.getRoomStatusCounts();

        request.setAttribute("totalAccounts", totalAccounts);
        request.setAttribute("activeUsers", activeUsers);
        request.setAttribute("usersByRole", usersByRole);
        request.setAttribute("roomStatus", roomStatus);

        request.getRequestDispatcher("/Views/Admin/Dashboard.jsp").forward(request, response);
    }

    private void showUserList(HttpServletRequest request, HttpServletResponse response)
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

        List<User> users = DAOAdmin.INSTANCE.getUsers(search, roleId, status, sortBy, sortOrder, page, pageSize);
        int totalUsers = DAOAdmin.INSTANCE.countUsers(search, roleId, status);
        int totalPages = (int) Math.ceil((double) totalUsers / pageSize);

        request.setAttribute("users", users);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalUsers", totalUsers);

        request.setAttribute("search", search);
        request.setAttribute("roleId", roleId);
        request.setAttribute("status", status);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("sortOrder", sortOrder);

        request.getRequestDispatcher("/Views/Admin/UserList.jsp").forward(request, response);
    }

    private void showUserDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            User user = DAOAdmin.INSTANCE.getUserById(id);
            if (user == null) {
                response.sendRedirect("users");
                return;
            }
            request.setAttribute("user", user);
            request.getRequestDispatcher("/Views/Admin/UserDetail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect("users");
        }
    }

    private void handleUpdateUser(HttpServletRequest request, HttpServletResponse response)
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

        boolean success = DAOAdmin.INSTANCE.updateUser(u);
        if (success) {
            response.sendRedirect("users?msg=updated");
        } else {
            response.sendRedirect("user-detail?id=" + id + "&error=failed");
        }
    }

    private void handleToggleStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("userId"));
        boolean currentStatus = Boolean.parseBoolean(request.getParameter("currentStatus"));

        boolean success = DAOAdmin.INSTANCE.toggleUserStatus(id, !currentStatus);
        response.sendRedirect("users");
    }

    private void handleResetPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("userId"));
        String newPassword = request.getParameter("newPassword");

        boolean success = DAOAdmin.INSTANCE.resetPassword(id, newPassword);
        if (success) {
            response.sendRedirect("user-detail?id=" + id + "&msg=pwd_reset");
        } else {
            response.sendRedirect("user-detail?id=" + id + "&error=pwd_failed");
        }
    }

    private void showEmployeeList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String search = request.getParameter("search");
        String roleId = request.getParameter("roleId");
        String status = request.getParameter("status");
        String pageStr = request.getParameter("page");

        int page = 1;
        try {
            if (pageStr != null)
                page = Integer.parseInt(pageStr);
        } catch (Exception e) {
        }

        List<User> users = DAOAdmin.INSTANCE.getUsers(search, roleId, status, "user_id", "ASC", page, 10);
        if (roleId == null) {
            users = users.stream().filter(u -> u.getRoleId() == 2 || u.getRoleId() == 3 || u.getRoleId() == 6)
                    .collect(java.util.stream.Collectors.toList());
        }

        request.setAttribute("users", users);
        request.getRequestDispatcher("/Views/Admin/EmployeeList.jsp").forward(request, response);
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
        u.setPlainPassword(password);

        boolean success = DAL.Owner.DAOOwner.INSTANCE.createEmployee(u, password);

        if (success) {
            response.sendRedirect("employees?msg=created");
        } else {
            request.setAttribute("error", "Failed to create employee");
            request.getRequestDispatcher("/Views/Admin/CreateEmployee.jsp").forward(request, response);
        }
    }
}
