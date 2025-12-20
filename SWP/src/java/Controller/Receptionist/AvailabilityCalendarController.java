package Controller.Receptionist;

import DAL.Owner.DAOOwner;
import DAL.Receptionist.DAOReceptionist;
import Model.RoomType;
import Model.User;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.time.YearMonth;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AvailabilityCalendarController", urlPatterns = {
        "/receptionist/availability",
        "/receptionist/availability/data"
})
public class AvailabilityCalendarController extends HttpServlet {

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

        String path = request.getServletPath();

        if ("/receptionist/availability/data".equals(path)) {
            getCalendarData(request, response);
        } else {
            showCalendarPage(request, response);
        }
    }

    private void showCalendarPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<RoomType> roomTypes = DAOOwner.INSTANCE.getAllRoomTypes();
        request.setAttribute("roomTypes", roomTypes);

        int selectedTypeId = 0;
        String typeIdParam = request.getParameter("roomTypeId");
        if (typeIdParam != null && !typeIdParam.isEmpty()) {
            selectedTypeId = Integer.parseInt(typeIdParam);
        } else if (!roomTypes.isEmpty()) {
            selectedTypeId = roomTypes.get(0).getRoomTypeId();
        }
        request.setAttribute("selectedTypeId", selectedTypeId);

        int year = LocalDate.now().getYear();
        int month = LocalDate.now().getMonthValue();

        String yearParam = request.getParameter("year");
        String monthParam = request.getParameter("month");
        if (yearParam != null && !yearParam.isEmpty()) {
            year = Integer.parseInt(yearParam);
        }
        if (monthParam != null && !monthParam.isEmpty()) {
            month = Integer.parseInt(monthParam);
        }

        request.setAttribute("year", year);
        request.setAttribute("month", month);

        if (selectedTypeId > 0) {
            int roomCount = DAOReceptionist.INSTANCE.getRoomCountByType(selectedTypeId);
            request.setAttribute("roomCount", roomCount);
        }

        request.getRequestDispatcher("/Views/Receptionist/AvailabilityCalendar.jsp")
                .forward(request, response);
    }

    private void getCalendarData(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            int roomTypeId = Integer.parseInt(request.getParameter("roomTypeId"));
            int year = Integer.parseInt(request.getParameter("year"));
            int month = Integer.parseInt(request.getParameter("month"));

            YearMonth yearMonth = YearMonth.of(year, month);
            LocalDate startDate = yearMonth.atDay(1);
            LocalDate endDate = yearMonth.atEndOfMonth();

            int totalRooms = DAOReceptionist.INSTANCE.getRoomCountByType(roomTypeId);
            List<Map<String, Object>> bookings = DAOReceptionist.INSTANCE
                    .getBookingsByRoomType(roomTypeId, startDate, endDate);

            // Build JSON manually
            StringBuilder json = new StringBuilder();
            json.append("{");
            json.append("\"totalRooms\":").append(totalRooms).append(",");
            json.append("\"year\":").append(year).append(",");
            json.append("\"month\":").append(month).append(",");

            // Calendar data
            json.append("\"calendarData\":[");
            for (int day = 1; day <= yearMonth.lengthOfMonth(); day++) {
                LocalDate date = yearMonth.atDay(day);
                int availableRooms = DAOReceptionist.INSTANCE.getAvailableRoomCountForDate(roomTypeId, date);
                int booked = totalRooms - availableRooms;

                String status;
                if (availableRooms == 0) {
                    status = "full";
                } else if (availableRooms < totalRooms) {
                    status = "partial";
                } else {
                    status = "available";
                }

                if (day > 1)
                    json.append(",");
                json.append("{");
                json.append("\"date\":\"").append(date.toString()).append("\",");
                json.append("\"day\":").append(day).append(",");
                json.append("\"available\":").append(availableRooms).append(",");
                json.append("\"total\":").append(totalRooms).append(",");
                json.append("\"booked\":").append(booked).append(",");
                json.append("\"status\":\"").append(status).append("\"");
                json.append("}");
            }
            json.append("],");

            // Bookings
            json.append("\"bookings\":[");
            for (int i = 0; i < bookings.size(); i++) {
                Map<String, Object> b = bookings.get(i);
                if (i > 0)
                    json.append(",");
                json.append("{");
                json.append("\"bookingId\":").append(b.get("bookingId")).append(",");
                json.append("\"roomId\":").append(b.get("roomId")).append(",");
                json.append("\"roomNumber\":\"").append(escapeJson(String.valueOf(b.get("roomNumber")))).append("\",");
                json.append("\"checkinDate\":\"").append(b.get("checkinDate")).append("\",");
                json.append("\"checkoutDate\":\"").append(b.get("checkoutDate")).append("\",");
                json.append("\"status\":\"").append(b.get("status")).append("\",");
                json.append("\"customerName\":\"").append(escapeJson(String.valueOf(b.get("customerName"))))
                        .append("\"");
                json.append("}");
            }
            json.append("]");

            json.append("}");

            out.write(json.toString());

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("{\"error\": \"" + escapeJson(e.getMessage()) + "\"}");
        }
    }

    private String escapeJson(String text) {
        if (text == null)
            return "";
        return text.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}
