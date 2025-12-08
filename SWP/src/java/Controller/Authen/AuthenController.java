package Controller.Authen;

import DAL.Authen.DAOAuthen;
import Model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.logging.Logger;
import java.util.logging.Level;

@WebServlet(name = "AuthenController", urlPatterns = {"/login", "/register", "/forgotPassword", "/resetPassword"})
public class AuthenController extends HttpServlet {

    private static final java.util.logging.Logger LOGGER = java.util.logging.Logger.getLogger(AuthenController.class.getName());

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        switch (path) {
            case "/login" ->
                request.getRequestDispatcher("Views/Authen/Login.jsp").forward(request, response);

            case "/register" ->
                request.getRequestDispatcher("Views/Authen/Register.jsp").forward(request, response);

            case "/forgotPassword" ->
                request.getRequestDispatcher("Views/Authen/ForgotPassword.jsp").forward(request, response);

            case "/resetPassword" ->
                request.getRequestDispatcher("Views/Authen/ResetPassword.jsp").forward(request, response);

            default ->
                response.sendError(404);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        String action = request.getParameter("action");
        System.out.println("Path: " + path);
        if (action == null) {
            request.setAttribute("type", "error");
            request.setAttribute("mess", "non-action require!");
            request.getRequestDispatcher("Views/Authen/Login.jsp").forward(request, response);
            return;
        }
        switch (action) {
            case "register" ->
                handleRegister(request, response);

            case "login" ->
                handleLogin(request, response);

            default ->
                response.sendError(400, "Unknown action: " + action);
        }
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String username = request.getParameter("username");
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            phone = phone.replaceAll("\\s+", "");  // remove spaces

            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");

            request.setAttribute("username", username);
            request.setAttribute("fullName", fullName);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            System.out.println("username: " + username);
            if (username == null || username.isBlank() || fullName == null || fullName.isBlank()
                    || email == null || email.isBlank() || phone == null || phone.isBlank()
                    || confirmPassword == null || confirmPassword.isBlank() || password == null || password.isBlank()) {
                request.setAttribute("type", "error");
                request.setAttribute("mess", "All fields can not blank!");
                request.getRequestDispatcher("Views/Authen/Register.jsp").forward(request, response);
                return;
            }

            if (!password.equals(confirmPassword)) {
                request.setAttribute("type", "error");
                request.setAttribute("mess", "Password and Confirm Password does not match, try again!");
                request.getRequestDispatcher("Views/Authen/Register.jsp").forward(request, response);
                return;
            }

            User user = new User();
            user.setUsername(username);
            user.setFullName(fullName);
            user.setEmail(email);
            user.setPhone(phone);
            user.setRoleId(1);
            user.setActive(true);
            user.setPlainPassword(confirmPassword);

            int result = DAOAuthen.INSTANCE.registerCustomer(user);

            if (result > 0) {
                request.setAttribute("type", "success");
                request.setAttribute("mess", "Register successful!");
                request.setAttribute("href", "login");
                request.getRequestDispatcher("Views/Authen/Login.jsp").forward(request, response);
            } else {

                request.setAttribute("type", "error");
                request.setAttribute("mess", "Register fail!");
                request.getRequestDispatcher("Views/Authen/Register.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("type", "error");
            request.setAttribute("mess", e.getMessage());
            request.getRequestDispatcher("Views/Authen/Register.jsp").forward(request, response);
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String identifier = request.getParameter("identifier");
        String password = request.getParameter("password");

        request.setAttribute("identifier", identifier);

        if (identifier == null || identifier.isBlank() || password == null || password.isBlank()) {
            request.setAttribute("type", "error");
            request.setAttribute("mess", "Email/Phone and password not blank!");
            request.getRequestDispatcher("Views/Authen/Login.jsp").forward(request, response);
            return;
        }

        User user = DAOAuthen.INSTANCE.login(identifier, password);

        if (user != null) {
            // Đăng nhập thành công
            request.getSession().setAttribute("currentUser", user);
            request.setAttribute("type", "success");
            request.setAttribute("mess", "Login successful!");
            if (null == user.getRoleId()) {
                request.setAttribute("href", "home");
            } else {
                switch (user.getRoleId()) {
                    case 3 ->
                        request.setAttribute("href", "housekeeping/dashboard");
                    case 4 ->
                        request.setAttribute("href", "owner/dashboard");
                    case 5 ->
                        request.setAttribute("href", "admin/dashboard");
                    case 6 ->
                        request.setAttribute("href", "manager/dashboard");
                    default ->
                        request.setAttribute("href", "home");
                }
            }
        } else {
            request.setAttribute("type", "error");
            request.setAttribute("mess", "Email/Phone or password incorrect!");
        }
        request.getRequestDispatcher("Views/Authen/Login.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
