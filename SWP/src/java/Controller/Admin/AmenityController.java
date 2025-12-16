package Controller.Admin;

import DAL.AmenityDAO;
import Model.Amenity;
import Model.User;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "AmenityController", urlPatterns = {
        "/admin/amenities",
        "/admin/amenity-detail"
})
public class AmenityController extends HttpServlet {

    private AmenityDAO amenityDAO = new AmenityDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || currentUser.getRoleId() != 5) { // Admin only
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String path = request.getServletPath();

        switch (path) {
            case "/admin/amenities":
                showAmenityList(request, response);
                break;
            case "/admin/amenity-detail":
                showAmenityDetail(request, response);
                break;
            default:
                response.sendError(404);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || currentUser.getRoleId() != 5) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null)
            action = "";

        switch (action) {
            case "create":
                handleCreate(request, response);
                break;
            case "update":
                handleUpdate(request, response);
                break;
            case "delete":
                handleDelete(request, response);
                break;
            default:
                doGet(request, response);
        }
    }

    private void showAmenityList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Amenity> list = amenityDAO.getAllAmenities();
        request.setAttribute("amenities", list);
        request.getRequestDispatcher("/Views/Admin/AmenityList.jsp").forward(request, response);
    }

    private void showAmenityDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isBlank()) {
            try {
                int id = Integer.parseInt(idStr);
                Amenity a = amenityDAO.getAmenityById(id);
                request.setAttribute("amenity", a);
            } catch (NumberFormatException e) {
                // ignore
            }
        }
        request.getRequestDispatcher("/Views/Admin/AmenityDetail.jsp").forward(request, response);
    }

    private void handleCreate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");

        Amenity a = new Amenity();
        a.setName(name);
        a.setDescription(description);
        try {
            a.setPrice(new BigDecimal(priceStr));
        } catch (Exception e) {
            a.setPrice(BigDecimal.ZERO);
        }
        a.setActive(true);

        amenityDAO.createAmenity(a);
        response.sendRedirect("amenities?msg=created");
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("amenityId"));
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        boolean isActive = request.getParameter("isActive") != null;

        Amenity a = new Amenity();
        a.setAmenityId(id);
        a.setName(name);
        a.setDescription(description);
        try {
            a.setPrice(new BigDecimal(priceStr));
        } catch (Exception e) {
            a.setPrice(BigDecimal.ZERO);
        }
        a.setActive(isActive);

        amenityDAO.updateAmenity(a);
        response.sendRedirect("amenities?msg=updated");
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("amenityId"));
        amenityDAO.deleteAmenity(id);
        response.sendRedirect("amenities?msg=deleted");
    }
}
