package Controller.Housekeeping;

import DAL.Amenity.AmenityDAO;
import DAL.Housekeeping.DAOHousekeeping;
import DAL.ReplenishmentRequest.ReplenishmentRequestDAO;
import DAL.RoomInspection.RoomInspectionDAO;
import Model.InspectionDetail;
import Model.Room;
import Model.RoomInspection;
import Model.RoomTypeAmenity;
import Model.User;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "InspectionController", urlPatterns = {
        "/housekeeping/inspection",
        "/housekeeping/inspection-history",
        "/housekeeping/request-replenishment"
})
public class InspectionController extends HttpServlet {

    private RoomInspectionDAO inspectionDAO = new RoomInspectionDAO();
    private AmenityDAO amenityDAO = new AmenityDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        // Allow Receptionist(2), Housekeeping(3), Owner(4), Admin(5)
        int role = currentUser.getRoleId();
        if (role != 2 && role != 3 && role != 4 && role != 5) {
            response.sendError(403, "Access Denied");
            return;
        }

        String path = request.getServletPath();

        switch (path) {
            case "/housekeeping/inspection":
                showInspectionForm(request, response);
                break;
            case "/housekeeping/inspection-history":
                showInspectionHistory(request, response);
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
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if ("submit".equals(action)) {
            handleSubmitInspection(request, response, currentUser);
        } else if ("request-replenishment".equals(action)) {
            handleReplenishmentRequest(request, response, currentUser);
        } else {
            doGet(request, response);
        }
    }

    private void showInspectionForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String roomIdStr = request.getParameter("roomId");
        String bookingIdStr = request.getParameter("bookingId");
        String type = request.getParameter("type"); // CHECKIN, CHECKOUT, ROUTINE

        if (roomIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/housekeeping/dashboard"); // Redirect if no room
            return;
        }

        int roomId = Integer.parseInt(roomIdStr);
        Room room = DAOHousekeeping.INSTANCE.getRoomById(roomId);

        // Auto-resolve bookingId if not provided
        if (bookingIdStr == null || bookingIdStr.isBlank()) {
            Model.Booking booking = null;
            if ("CHECKOUT".equals(type) || "DIRTY".equals(room.getStatus())) {
                // For checkout or dirty rooms, we likely want the LAST booking that just
                // checked out
                booking = DAL.Booking.DAOBooking.INSTANCE.getLastBookingByRoomId(roomId);
            } else if ("CHECKIN".equals(type) || "ROUTINE".equals(type) || "OCCUPIED".equals(room.getStatus())) {
                // For checkin (pre-arrival/post-cleaning) or routine, we might want current
                // booking
                booking = DAL.Booking.DAOBooking.INSTANCE.getCurrentBookingByRoomId(roomId);
            }

            if (booking != null) {
                bookingIdStr = String.valueOf(booking.getBookingId());
            }
        }

        // Get amenities for this room type
        List<RoomTypeAmenity> standardAmenities = amenityDAO.getAmenitiesByRoomType(room.getRoomTypeId());

        // For CHECKOUT type, fetch CHECKIN inspection for comparison
        Model.RoomInspection checkinInspection = null;
        if ("CHECKOUT".equals(type) && bookingIdStr != null && !bookingIdStr.isBlank()) {
            int bookingId = Integer.parseInt(bookingIdStr);
            checkinInspection = inspectionDAO.getInspectionByBookingAndType(bookingId, "CHECKIN");
        }

        request.setAttribute("room", room);
        request.setAttribute("bookingId", bookingIdStr);
        request.setAttribute("type", type);
        request.setAttribute("standardAmenities", standardAmenities);
        request.setAttribute("checkinInspection", checkinInspection);

        request.getRequestDispatcher("/Views/Housekeeping/InspectionForm.jsp").forward(request, response);
    }

    private void showInspectionHistory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String roomIdStr = request.getParameter("roomId");
        if (roomIdStr != null && !roomIdStr.isBlank()) {
            int roomId = Integer.parseInt(roomIdStr);
            List<RoomInspection> history = inspectionDAO.getInspectionsByRoom(roomId);
            request.setAttribute("history", history);
            request.setAttribute("roomId", roomId);
        } else {
            // If no roomId, show recent inspections (general list)
            List<RoomInspection> history = inspectionDAO.getRecentInspections(50);
            request.setAttribute("history", history);
        }
        request.getRequestDispatcher("/Views/Housekeeping/InspectionHistory.jsp").forward(request, response);
    }

    private void handleSubmitInspection(HttpServletRequest request, HttpServletResponse response, User inspector)
            throws ServletException, IOException {
        int roomId = Integer.parseInt(request.getParameter("roomId"));
        String bookingIdStr = request.getParameter("bookingId");
        String typeStr = request.getParameter("type");
        String note = request.getParameter("note");
        String cleanlinessNote = request.getParameter("cleanlinessNote");

        if (cleanlinessNote != null && !cleanlinessNote.isBlank()) {
            if (note == null)
                note = "";
            note = "[Cleanliness/Condition]: " + cleanlinessNote + "\n" + note;
        }

        RoomInspection ri = new RoomInspection();
        ri.setRoomId(roomId);
        if (bookingIdStr != null && !bookingIdStr.isBlank()) {
            ri.setBookingId(Integer.parseInt(bookingIdStr));
        }
        ri.setInspectorId(inspector.getUserId());
        ri.setInspectionDate(LocalDateTime.now());
        ri.setType(typeStr);
        ri.setNote(note);

        // Parse details
        List<InspectionDetail> details = new ArrayList<>();
        String[] amenityIds = request.getParameterValues("amenityId");
        boolean hasDamages = false;

        if (amenityIds != null) {
            for (String amenityIdStr : amenityIds) {
                int amenityId = Integer.parseInt(amenityIdStr);
                int quantity = Integer.parseInt(request.getParameter("quantity_" + amenityId));
                String status = request.getParameter("status_" + amenityId);
                String comment = request.getParameter("comment_" + amenityId);

                InspectionDetail detail = new InspectionDetail();
                detail.setAmenityId(amenityId);
                detail.setQuantityActual(quantity);
                detail.setConditionStatus(status);
                detail.setComment(comment);

                details.add(detail);

                if ("DAMAGED".equals(status) || "MISSING".equals(status)) {
                    hasDamages = true;
                }
            }
        }
        ri.setDetails(details);

        boolean success = inspectionDAO.createInspection(ri);

        if (success) {
            // Logic for CHECKOUT: Create issues for damages
            if ("CHECKOUT".equals(typeStr) && hasDamages) {
                for (InspectionDetail d : details) {
                    if ("DAMAGED".equals(d.getConditionStatus()) || "MISSING".equals(d.getConditionStatus())) {
                        Model.IssueReport issue = new Model.IssueReport();
                        issue.setRoomId(roomId);
                        issue.setBookingId(ri.getBookingId());
                        issue.setReportedBy(inspector.getUserId());
                        // Use EQUIPMENT for damaged items
                        issue.setIssueType(
                                "DAMAGED".equals(d.getConditionStatus()) ? Model.IssueReport.IssueType.EQUIPMENT
                                        : Model.IssueReport.IssueType.OTHER);
                        issue.setDescription("Item " + d.getConditionStatus() + ": " + d.getComment());
                        issue.setStatus(Model.IssueReport.IssueStatus.NEW);

                        DAL.Manager.DAOManager.INSTANCE.createIssue(issue);
                    }
                }
            }

            // Logic for CHECKIN: If all good, make room AVAILABLE
            if ("CHECKIN".equals(typeStr) && !hasDamages) {
                DAOHousekeeping.INSTANCE.updateRoomStatus(roomId, Model.Room.Status.AVAILABLE);
            }

            response.sendRedirect("inspection-history?roomId=" + roomId + "&msg=success");
        } else {
            response.sendRedirect("inspection?roomId=" + roomId + "&error=failed");
        }
    }

    private void handleReplenishmentRequest(HttpServletRequest request, HttpServletResponse response, User requester)
            throws ServletException, IOException {
        String inspectionIdStr = request.getParameter("inspectionId");
        String amenityIdStr = request.getParameter("amenityId");
        String quantityStr = request.getParameter("quantity");
        String reason = request.getParameter("reason");

        try {
            int inspectionId = Integer.parseInt(inspectionIdStr);
            int amenityId = Integer.parseInt(amenityIdStr);
            int quantity = Integer.parseInt(quantityStr);

            Model.ReplenishmentRequest replenishmentRequest = new Model.ReplenishmentRequest();
            replenishmentRequest.setInspectionId(inspectionId);
            replenishmentRequest.setAmenityId(amenityId);
            replenishmentRequest.setQuantityRequested(quantity);
            replenishmentRequest.setReason(reason);
            replenishmentRequest.setRequestedBy(requester.getUserId());
            replenishmentRequest.setStatus(Model.ReplenishmentRequest.Status.PENDING);

            ReplenishmentRequestDAO replenishmentDAO = new ReplenishmentRequestDAO();
            boolean success = replenishmentDAO.createRequest(replenishmentRequest);

            if (success) {
                response.getWriter().write("{\"success\": true, \"message\": \"Replenishment request submitted\"}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"Failed to submit request\"}");
            }
            response.setContentType("application/json");

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(500);
            response.getWriter().write("{\"success\": false, \"message\": \"Error: " + e.getMessage() + "\"}");
            response.setContentType("application/json");
        }
    }
}
