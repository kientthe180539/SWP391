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
 * Controller for Room Status Board
 */
@WebServlet(name = "RoomStatusController", urlPatterns = { "/receptionist/room-status" })
public class RoomStatusController extends HttpServlet {

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

        // Get filter parameters
        String floorParam = request.getParameter("floor");
        String statusFilter = request.getParameter("status");

        List<Map<String, Object>> rooms;

        // Apply filters
        if (floorParam != null && !floorParam.isEmpty()) {
            try {
                int floor = Integer.parseInt(floorParam);
                rooms = daoReceptionist.getRoomsByFloor(floor);
            } catch (NumberFormatException e) {
                rooms = daoReceptionist.getAllRoomsWithStatus();
            }
        } else {
            rooms = daoReceptionist.getAllRoomsWithStatus();
        }

        // Filter by status if provided
        if (statusFilter != null && !statusFilter.isEmpty() && !"ALL".equals(statusFilter)) {
            rooms.removeIf(room -> !statusFilter.equals(room.get("status")));
        }

        // Get summary statistics
        Map<String, Integer> stats = daoReceptionist.getRoomStatusSummary();

        // Set attributes
        request.setAttribute("rooms", rooms);
        request.setAttribute("stats", stats);
        request.setAttribute("selectedFloor", floorParam);
        request.setAttribute("selectedStatus", statusFilter);

        // Forward to JSP
        request.getRequestDispatcher("/Views/Receptionist/RoomStatusBoard.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Room Status Board Controller";
    }
}
