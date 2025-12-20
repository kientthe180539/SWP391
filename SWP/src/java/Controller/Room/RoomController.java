package Controller.Room;

import DAL.Guest.DAOGuest;
import Model.RoomType;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import Model.Room;

@WebServlet(name = "RoomController", urlPatterns = { "/rooms", "/room-detail" })
public class RoomController extends HttpServlet {

    private static final int PAGE_SIZE = 6;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        switch (path) {
            case "/rooms" ->
                loadRoomList(request, response);

            case "/room-detail" ->
                loadRoomDetail(request, response);

            default ->
                response.sendError(404);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

    private void loadRoomList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String roomTypeParam = request.getParameter("roomType");
        Integer roomTypeId = null;
        if (roomTypeParam != null && !roomTypeParam.isBlank()) {
            try {
                roomTypeId = Integer.parseInt(roomTypeParam);
            } catch (NumberFormatException e) {
                roomTypeId = null;
            }
        }

        BigDecimal minPrice = null;
        BigDecimal maxPrice = null;
        try {
            String minPriceParam = request.getParameter("minPrice");
            if (minPriceParam != null && !minPriceParam.isBlank()) {
                minPrice = new BigDecimal(minPriceParam);
            }

            String maxPriceParam = request.getParameter("maxPrice");
            if (maxPriceParam != null && !maxPriceParam.isBlank()) {
                maxPrice = new BigDecimal(maxPriceParam);
            }
        } catch (NumberFormatException e) {
        }

        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isBlank()) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
            }
        }

        java.time.LocalDate checkIn = null;
        java.time.LocalDate checkOut = null;
        try {
            String checkInParam = request.getParameter("checkIn");
            String checkOutParam = request.getParameter("checkOut");
            if (checkInParam != null && !checkInParam.isBlank()) {
                checkIn = java.time.LocalDate.parse(checkInParam);
            }
            if (checkOutParam != null && !checkOutParam.isBlank()) {
                checkOut = java.time.LocalDate.parse(checkOutParam);
            }
        } catch (Exception e) {
            // Invalid date format, ignore
        }

        List<Map.Entry<Room, RoomType>> rooms = DAOGuest.INSTANCE.getAvailableRooms(
                roomTypeId, minPrice, maxPrice, checkIn, checkOut, page, PAGE_SIZE);

        int totalCount = DAOGuest.INSTANCE.countAvailableRooms(roomTypeId, checkIn, checkOut);
        int totalPage = (int) Math.ceil((double) totalCount / PAGE_SIZE);

        List<RoomType> roomTypes = DAOGuest.INSTANCE.getAllRoomTypes();

        request.setAttribute("rooms", rooms);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPage", totalPage);
        request.setAttribute("selectedType", roomTypeId);
        request.setAttribute("minPrice", minPrice);
        request.setAttribute("maxPrice", maxPrice);
        request.setAttribute("checkIn", checkIn);
        request.setAttribute("checkOut", checkOut);
        request.setAttribute("roomTypes", roomTypes);

        request.getRequestDispatcher("Views/Room/RoomList.jsp").forward(request, response);
    }

    private void loadRoomDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isBlank()) {
            request.setAttribute("type", "error");
            request.setAttribute("mess", "Cannot find room you need!");
            request.getRequestDispatcher("Views/Room/RoomList.jsp").forward(request, response);
            return;
        }

        try {
            int roomId = Integer.parseInt(idParam);
            Map.Entry<Room, RoomType> entry = DAOGuest.INSTANCE.getRoomDetailWithType(roomId);

            if (entry == null) {
                request.setAttribute("type", "error");
                request.setAttribute("mess", "Room not found or unavailable!");
                request.getRequestDispatcher("Views/Room/RoomDetail.jsp").forward(request, response);
                return;
            }

            request.setAttribute("room", entry.getKey());
            request.setAttribute("roomType", entry.getValue());

            // Fetch feedback
            int feedbackPage = 1;
            try {
                String p = request.getParameter("page");
                if (p != null)
                    feedbackPage = Integer.parseInt(p);
            } catch (NumberFormatException e) {
            }

            int feedbackPageSize = 5;
            List<Model.Feedback> feedbacks = DAL.Feedback.DAOFeedback.INSTANCE.getFeedbacksByRoomId(roomId,
                    feedbackPage, feedbackPageSize);
            int totalFeedbacks = DAL.Feedback.DAOFeedback.INSTANCE.countFeedbacksByRoomId(roomId);
            int totalFeedbackPage = (int) Math.ceil((double) totalFeedbacks / feedbackPageSize);

            request.setAttribute("feedbacks", feedbacks);
            request.setAttribute("feedbackPage", feedbackPage);
            request.setAttribute("totalFeedbackPage", totalFeedbackPage);

            request.getRequestDispatcher("Views/Room/RoomDetail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("rooms");
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
