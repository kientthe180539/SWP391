package Controller.Authen;

import DAL.Authen.DAOAuthen;
import Model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AuthenController", urlPatterns = {"/login", "/register", "/forgotPassword", "/resetPassword",
    "/logout"})
public class AuthenController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        switch (path) {
            case "/login" -> {
                String redirect = request.getParameter("redirect");
                if (redirect != null) {
                    request.setAttribute("redirect", redirect);
                }
                request.getRequestDispatcher("Views/Authen/Login.jsp").forward(request, response);
            }

            case "/register" ->
                request.getRequestDispatcher("Views/Authen/Register.jsp").forward(request, response);

            case "/forgotPassword" ->
                request.getRequestDispatcher("Views/Authen/ForgotPassword.jsp").forward(request, response);

            case "/resetPassword" ->
                request.getRequestDispatcher("Views/Authen/ResetPassword.jsp").forward(request, response);

            case "/logout" -> {
                // Invalidate session and redirect to home
                request.getSession().invalidate();
                response.sendRedirect(request.getContextPath() + "/home");
            }

            default ->
                response.sendError(404);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

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
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");

            request.setAttribute("username", username);
            request.setAttribute("fullName", fullName);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);

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
                request.getRequestDispatcher("Views/Authen/Register.jsp").forward(request, response);
            } else {
                request.setAttribute("type", "error");
                request.setAttribute("mess", "Register fail!");
                request.getRequestDispatcher("Views/Authen/Register.jsp").forward(request, response);
            }
        } catch (Exception e) {
            System.err.println("--------------------------------- error register ----------------------------------");
            System.err.println(e.getMessage());
            System.err.println("-----------------------------------------------------------------------------------");
            request.setAttribute("type", "error");
            request.setAttribute("mess", e.getMessage());
            request.getRequestDispatcher("Views/Authen/Register.jsp").forward(request, response);
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String identifier = request.getParameter("identifier");
            String password = request.getParameter("password");
            String redirect = request.getParameter("redirect");

            request.setAttribute("identifier", identifier);

            if (identifier == null || identifier.isBlank() || password == null || password.isBlank()) {
                request.setAttribute("type", "error");
                request.setAttribute("mess", "Email/Phone and password not blank!");
                if (redirect != null) {
                    request.setAttribute("redirect", redirect);
                }
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
                        case 2 ->
                            request.setAttribute("href", "receptionist/dashboard");
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

                if (redirect != null && !redirect.isBlank()) {
                    request.setAttribute("href", redirect);
                }
            } else {
                request.setAttribute("type", "error");
                request.setAttribute("mess", "Email/Phone or password incorrect!");
                if (redirect != null) {
                    request.setAttribute("redirect", redirect);
                }
            }
        } catch (Exception e) {
            System.err.println("--------------------------------- error login ----------------------------------");
            System.err.println(e.getMessage());
            System.err.println("-----------------------------------------------------------------------------------");
            request.setAttribute("type", "error");
            request.setAttribute("mess", e.getMessage());
        }
        request.getRequestDispatcher("Views/Authen/Login.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
