package Controller.Receptionist;

import DAL.Receptionist.DAOReceptionist;
import Model.User;
import java.io.IOException;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Controller for Profile Management (View and Edit)
 */
@WebServlet(name = "ProfileController", urlPatterns = { "/receptionist/profile" })
public class ProfileController extends HttpServlet {

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

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        int userId = currentUser.getUserId();

        // Get user profile
        Map<String, Object> profile = daoReceptionist.getUserProfile(userId);
        if (profile == null) {
            request.setAttribute("type", "error");
            request.setAttribute("mess", "Failed to load profile");
            request.getRequestDispatcher("/Views/notify.jsp").forward(request, response);
            return;
        }

        request.setAttribute("profile", profile);
        request.getRequestDispatcher("/Views/Receptionist/Profile.jsp").forward(request, response);
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
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        // Validate input
        if (fullName == null || fullName.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                phone == null || phone.trim().isEmpty()) {
            request.setAttribute("type", "error");
            request.setAttribute("mess", "All fields are required");
            request.getRequestDispatcher("/Views/Receptionist/Profile.jsp").forward(request, response);
            return;
        }

        // Update profile
        boolean success = daoReceptionist.updateProfile(userId, fullName.trim(), email.trim(), phone.trim());

        if (success) {
            // Update session currentUser object
            currentUser.setFullName(fullName.trim());
            currentUser.setEmail(email.trim());
            currentUser.setPhone(phone.trim());
            session.setAttribute("currentUser", currentUser);

            request.setAttribute("type", "success");
            request.setAttribute("mess", "Profile updated successfully!");
        } else {
            request.setAttribute("type", "error");
            request.setAttribute("mess", "Failed to update profile");
        }

        // Reload profile data and display
        Map<String, Object> profile = daoReceptionist.getUserProfile(userId);
        request.setAttribute("profile", profile);
        request.getRequestDispatcher("/Views/Receptionist/Profile.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Profile Management Controller";
    }
}
