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

/**
 * Controller for Reservation Detail
 */
@WebServlet(name = "ReservationDetailController", urlPatterns = { "/receptionist/reservation-detail" })
public class ReservationDetailController extends HttpServlet {

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

        String bookingIdParam = request.getParameter("id");
        if (bookingIdParam == null || bookingIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/receptionist/reservations");
            return;
        }

        try {
            int bookingId = Integer.parseInt(bookingIdParam);

            // Get booking details
            Map<String, Object> booking = daoReceptionist.getBookingDetailById(bookingId);
            if (booking == null) {
                request.setAttribute("type", "error");
                request.setAttribute("mess", "Booking not found");
                request.getRequestDispatcher("/Views/notify.jsp").forward(request, response);
                return;
            }

            request.setAttribute("booking", booking);
            request.getRequestDispatcher("/Views/Receptionist/ReservationDetail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/receptionist/reservations");
        }
    }

    @Override
    public String getServletInfo() {
        return "Reservation Detail Controller";
    }
}
