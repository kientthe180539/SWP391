package Controller.Booking;

import DAL.Booking.DAOBooking;
import Model.Booking;
import Model.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "BookingController", urlPatterns = {"/booking/list", "/booking/checkin", "/booking/checkout"})
public class BookingController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        
        if (path.equals("/booking/list")) {
            List<Booking> bookings = DAOBooking.INSTANCE.getAllBookings();
            request.setAttribute("bookings", bookings);
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
