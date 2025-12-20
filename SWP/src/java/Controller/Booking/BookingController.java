package Controller.Booking;

import DAL.Booking.DAOBooking;
import Model.Booking;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "BookingController", urlPatterns = { "/booking/list", "/booking/checkin", "/booking/checkout" })
public class BookingController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if (path.equals("/booking/list")) {
            String pageStr = request.getParameter("page");
            String search = request.getParameter("search");
            String status = request.getParameter("status");
            String sortBy = request.getParameter("sortBy");

            int page = 1;
            int pageSize = 10;
            try {
                if (pageStr != null && !pageStr.isBlank()) {
                    page = Integer.parseInt(pageStr);
                    if (page < 1)
                        page = 1;
                }
            } catch (NumberFormatException e) {
                page = 1;
            }

            List<Booking> bookings = DAOBooking.INSTANCE.getBookings(search, status, sortBy, null, page, pageSize);
            int totalBookings = DAOBooking.INSTANCE.countBookings(search, status);
            int totalPages = (int) Math.ceil((double) totalBookings / pageSize);

            request.setAttribute("bookings", bookings);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalBookings", totalBookings);

            request.setAttribute("search", search);
            request.setAttribute("status", status);
            request.setAttribute("sortBy", sortBy);

            request.getRequestDispatcher("/Views/Booking/BookingList.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String idStr = request.getParameter("bookingId");

        if (idStr == null || action == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        int bookingId = Integer.parseInt(idStr);
        boolean success = false;
        String message = "";

        switch (action) {
            case "checkIn" -> {
                success = DAOBooking.INSTANCE.checkIn(bookingId);
                message = success ? "Check-in successful!" : "Check-in failed!";
            }
            case "checkOut" -> {
                success = DAOBooking.INSTANCE.checkOut(bookingId);
                message = success ? "Check-out successful!" : "Check-out failed!";
            }
        }

        if (success) {
            request.getSession().setAttribute("notification", message);
            request.getSession().setAttribute("notificationType", "success");
        } else {
            request.getSession().setAttribute("notification", message);
            request.getSession().setAttribute("notificationType", "error");
        }

        response.sendRedirect(request.getContextPath() + "/booking/list");
    }
}
