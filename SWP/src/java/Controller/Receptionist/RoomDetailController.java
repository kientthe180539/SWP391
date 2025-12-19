package Controller.Receptionist;

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
 * Controller for Room Detail and Update
 */
@WebServlet(name = "RoomDetailController", urlPatterns = { "/receptionist/room-detail" })
public class RoomDetailController extends HttpServlet {

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

        String roomIdParam = request.getParameter("id");
        if (roomIdParam == null || roomIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/receptionist/room-status");
            return;
        }

        try {
            int roomId = Integer.parseInt(roomIdParam);

            // Get room details
            Map<String, Object> room = daoReceptionist.getRoomDetailById(roomId);
            if (room == null) {
                request.setAttribute("type", "error");
                request.setAttribute("mess", "Room not found");
                request.getRequestDispatcher("/Views/notify.jsp").forward(request, response);
                return;
            }

            // Get booking history (last 10 bookings)
            List<Map<String, Object>> history = daoReceptionist.getRoomBookingHistory(roomId, 10);

            request.setAttribute("room", room);
            request.setAttribute("history", history);
            request.getRequestDispatcher("/Views/Receptionist/RoomDetail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/receptionist/room-status");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!ensureReceptionist(request, response)) {
            return;
        }

        String action = request.getParameter("action");
        String roomIdParam = request.getParameter("roomId");

        if (roomIdParam == null || roomIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/receptionist/room-status");
            return;
        }

        try {
            int roomId = Integer.parseInt(roomIdParam);

            if ("updateStatus".equals(action)) {
                String newStatus = request.getParameter("status");
                if (newStatus != null && !newStatus.isEmpty()) {
                    boolean success = daoReceptionist.updateRoomStatus(roomId, newStatus);
                    if (success) {
                        request.setAttribute("type", "success");
                        request.setAttribute("mess", "Room status updated successfully!");
                    } else {
                        request.setAttribute("type", "error");
                        request.setAttribute("mess", "Failed to update room status");
                    }
                }
            }

            // Redirect back to room detail
            response.sendRedirect(request.getContextPath() + "/receptionist/room-detail?id=" + roomId);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/receptionist/room-status");
        }
    }

    @Override
    public String getServletInfo() {
        return "Room Detail Controller";
    }
}
