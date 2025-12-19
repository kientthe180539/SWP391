package Controller.Booking.Receptionist;

import DAL.Receptionist.DAOReceptionist;
import Model.User;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author xuxum
 */
@WebServlet(name = "ReservationApprovalController", urlPatterns = { "/reservation_approval" })
public class ReservationApprovalController extends HttpServlet {

    private static final int ROLE_RECEPTIONIST = 2;

    private boolean ensureReceptionist(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        User currentUser = (User) request.getSession().getAttribute("currentUser");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        // Allow receptionist and admin/manager
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

        // Load pending bookings from database
        List<Map<String, Object>> pendingBookings = DAOReceptionist.INSTANCE.getPendingBookings();
        request.setAttribute("pendingBookings", pendingBookings);

        request.getRequestDispatcher("Views/Booking/Receptionist/Reservation_Approval.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!ensureReceptionist(request, response)) {
            return;
        }

        String action = request.getParameter("action");
        String bookingIdStr = request.getParameter("bookingId");

        if (action == null || bookingIdStr == null) {
            request.setAttribute("type", "error");
            request.setAttribute("mess", "Thiếu thông tin yêu cầu!");
            doGet(request, response);
            return;
        }

        try {
            int bookingId = Integer.parseInt(bookingIdStr);
            User currentUser = (User) request.getSession().getAttribute("currentUser");
            int receptionistId = currentUser.getUserId();

            switch (action) {
                case "approve" -> {
                    boolean success = DAOReceptionist.INSTANCE.approveBooking(bookingId, receptionistId);
                    if (success) {
                        request.setAttribute("type", "success");
                        request.setAttribute("mess", "Đã duyệt đặt phòng thành công!");
                    } else {
                        request.setAttribute("type", "error");
                        request.setAttribute("mess", "Không thể duyệt đặt phòng. Vui lòng thử lại!");
                    }
                }
                case "reject" -> {
                    String reason = request.getParameter("reason");
                    if (reason == null || reason.isBlank()) {
                        reason = "Không có lý do";
                    }
                    boolean success = DAOReceptionist.INSTANCE.rejectBooking(bookingId, receptionistId, reason);
                    if (success) {
                        request.setAttribute("type", "success");
                        request.setAttribute("mess", "Đã từ chối đặt phòng!");
                    } else {
                        request.setAttribute("type", "error");
                        request.setAttribute("mess", "Không thể từ chối đặt phòng. Vui lòng thử lại!");
                    }
                }
                default -> {
                    request.setAttribute("type", "error");
                    request.setAttribute("mess", "Hành động không hợp lệ!");
                }
            }
        } catch (NumberFormatException e) {
            request.setAttribute("type", "error");
            request.setAttribute("mess", "ID đặt phòng không hợp lệ!");
        }

        // Reload the page with updated data
        doGet(request, response);
    }

}
