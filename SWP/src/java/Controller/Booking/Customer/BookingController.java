package Controller.Booking.Customer;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "BookingController", urlPatterns = {"/booking", "/booking_confirm", "/my_booking"})
public class BookingController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        switch (path) {
            case "/booking" ->
                request.getRequestDispatcher("Views/Booking/Customer/Booking.jsp").forward(request, response);

            case "/booking_confirm" ->
                request.getRequestDispatcher("Views/Booking/Customer/BookingConfirm.jsp").forward(request, response);

            case "/my_booking" ->
                request.getRequestDispatcher("Views/Booking/Customer/MyBooking.jsp").forward(request, response);

            default ->
                response.sendError(404);
        }

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

}
