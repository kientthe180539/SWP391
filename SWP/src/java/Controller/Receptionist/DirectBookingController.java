package Controller.Receptionist;

import DAL.Booking.DAOBooking;
import DAL.Owner.DAOOwner;
import DAL.Receptionist.DAOReceptionist;
import Model.Room;
import Model.RoomType;
import Model.User;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "DirectBookingController", urlPatterns = {
        "/receptionist/direct-booking"
})
public class DirectBookingController extends HttpServlet {

    private static final int ROLE_RECEPTIONIST = 2;

    private boolean ensureReceptionist(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        User currentUser = (User) request.getSession().getAttribute("currentUser");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
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

        // Get check-in/check-out dates from request or use defaults
        String checkinStr = request.getParameter("checkinDate");
        String checkoutStr = request.getParameter("checkoutDate");

        LocalDate checkinDate = LocalDate.now();
        LocalDate checkoutDate = LocalDate.now().plusDays(1);

        if (checkinStr != null && !checkinStr.isEmpty()) {
            checkinDate = LocalDate.parse(checkinStr);
        }
        if (checkoutStr != null && !checkoutStr.isEmpty()) {
            checkoutDate = LocalDate.parse(checkoutStr);
        }

        // Get available rooms for the date range
        List<Map<String, Object>> availableRooms = DAOReceptionist.INSTANCE
                .getAvailableRoomsForDateRange(checkinDate, checkoutDate);
        request.setAttribute("availableRooms", availableRooms);
        request.setAttribute("checkinDate", checkinDate.toString());
        request.setAttribute("checkoutDate", checkoutDate.toString());

        // Get all room types for filter (using DAOOwner which has this method)
        List<RoomType> roomTypes = DAOOwner.INSTANCE.getAllRoomTypes();
        request.setAttribute("roomTypes", roomTypes);

        request.getRequestDispatcher("/Views/Receptionist/DirectBooking.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!ensureReceptionist(request, response)) {
            return;
        }

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        try {
            // Get form data
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            String customerName = request.getParameter("customerName");
            String customerEmail = request.getParameter("customerEmail");
            String customerPhone = request.getParameter("customerPhone");
            String checkinDateStr = request.getParameter("checkinDate");
            String checkoutDateStr = request.getParameter("checkoutDate");
            int numGuests = Integer.parseInt(request.getParameter("numGuests"));

            // Get room and room type info from available rooms data
            LocalDate checkinDate = LocalDate.parse(checkinDateStr);
            LocalDate checkoutDate = LocalDate.parse(checkoutDateStr);

            // Get price from available rooms
            List<Map<String, Object>> rooms = DAOReceptionist.INSTANCE
                    .getAvailableRoomsForDateRange(checkinDate, checkoutDate);

            BigDecimal basePrice = BigDecimal.ZERO;
            for (Map<String, Object> room : rooms) {
                if ((Integer) room.get("roomId") == roomId) {
                    basePrice = (BigDecimal) room.get("basePrice");
                    break;
                }
            }

            long nights = ChronoUnit.DAYS.between(checkinDate, checkoutDate);
            BigDecimal totalAmount = basePrice.multiply(BigDecimal.valueOf(nights));

            // Create or get customer
            int customerId = DAOReceptionist.INSTANCE.createOrGetCustomer(customerName, customerEmail, customerPhone);

            if (customerId == -1) {
                session.setAttribute("notification", "Failed to create customer. Please try again.");
                session.setAttribute("notificationType", "error");
                response.sendRedirect(request.getContextPath() + "/receptionist/direct-booking");
                return;
            }

            // Create booking directly as CONFIRMED (walk-in customer)
            int bookingId = DAOReceptionist.INSTANCE.createDirectBooking(
                    customerId, roomId, checkinDate, checkoutDate,
                    numGuests, totalAmount, currentUser.getUserId());

            if (bookingId > 0) {
                session.setAttribute("notification",
                        "Booking #" + bookingId + " created successfully for " + customerName);
                session.setAttribute("notificationType", "success");
            } else {
                session.setAttribute("notification", "Failed to create booking. Please try again.");
                session.setAttribute("notificationType", "error");
            }

        } catch (Exception e) {
            session.setAttribute("notification", "Error: " + e.getMessage());
            session.setAttribute("notificationType", "error");
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/receptionist/direct-booking");
    }
}
