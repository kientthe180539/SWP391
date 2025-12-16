package Controller.Receptionist;

import DAL.Receptionist.DAOReceptionist;
import Model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Controller for Change Password
 */
@WebServlet(name = "ChangePasswordController", urlPatterns = { "/receptionist/change-password" })
public class ChangePasswordController extends HttpServlet {

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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!ensureReceptionist(request, response)) {
            return;
        }

        request.getRequestDispatcher("/Views/Receptionist/ChangePassword.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!ensureReceptionist(request, response)) {
            return;
        }

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        int userId = currentUser.getUserId();

        // Get form data
        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validate input
        if (oldPassword == null || oldPassword.isEmpty() ||
                newPassword == null || newPassword.isEmpty() ||
                confirmPassword == null || confirmPassword.isEmpty()) {
            request.setAttribute("type", "error");
            request.setAttribute("mess", "All fields are required");
            request.getRequestDispatcher("/Views/Receptionist/ChangePassword.jsp").forward(request, response);
            return;
        }

        // Check if new password matches confirm password
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("type", "error");
            request.setAttribute("mess", "New password and confirm password do not match");
            request.getRequestDispatcher("/Views/Receptionist/ChangePassword.jsp").forward(request, response);
            return;
        }

        // Check password strength (minimum 6 characters)
        if (newPassword.length() < 6) {
            request.setAttribute("type", "error");
            request.setAttribute("mess", "New password must be at least 6 characters long");
            request.getRequestDispatcher("/Views/Receptionist/ChangePassword.jsp").forward(request, response);
            return;
        }

        // Change password
        boolean success = daoReceptionist.changePassword(userId, oldPassword, newPassword);

        if (success) {
            request.setAttribute("type", "success");
            request.setAttribute("mess", "Password changed successfully!");
            request.setAttribute("href", "receptionist/profile");
            request.getRequestDispatcher("/Views/notify.jsp").forward(request, response);
        } else {
            request.setAttribute("type", "error");
            request.setAttribute("mess", "Failed to change password. Please check your current password.");
            request.getRequestDispatcher("/Views/Receptionist/ChangePassword.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Change Password Controller";
    }
}
