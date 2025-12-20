package Controller.HomePage;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author
 */
public class HomePageController extends HttpServlet {

        @Override
        protected void doGet(HttpServletRequest request, HttpServletResponse response)
                        throws ServletException, IOException {
                java.util.List<Model.RoomType> roomTypes = DAL.Guest.DAOGuest.INSTANCE.getAllRoomTypes();
                request.setAttribute("roomTypes", roomTypes);
                request.getRequestDispatcher("Views/HomePage/HomePage.jsp").forward(request, response);
        }

        @Override
        protected void doPost(HttpServletRequest request, HttpServletResponse response)
                        throws ServletException, IOException {

        }

}
