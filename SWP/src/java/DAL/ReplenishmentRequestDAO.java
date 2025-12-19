package DAL;

import Model.Amenity;
import Model.ReplenishmentRequest;
import Model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReplenishmentRequestDAO extends DAO {

    public boolean createRequest(ReplenishmentRequest request) {
        String sql = "{CALL sp_create_replenishment_request(?, ?, ?, ?, ?, ?)}";

        try (CallableStatement cs = connection.prepareCall(sql)) {
            cs.setInt(1, request.getInspectionId());
            cs.setInt(2, request.getAmenityId());
            cs.setInt(3, request.getQuantityRequested());
            cs.setString(4, request.getReason());
            cs.setInt(5, request.getRequestedBy());
            cs.registerOutParameter(6, Types.INTEGER);

            cs.execute();
            int requestId = cs.getInt(6);
            request.setRequestId(requestId);
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<ReplenishmentRequest> getAllRequests() {
        List<ReplenishmentRequest> list = new ArrayList<>();
        String sql = "SELECT r.*, a.name AS amenity_name, a.description AS amenity_desc, "
                + "u1.full_name AS requester_name, u2.full_name AS approver_name "
                + "FROM replenishment_requests r "
                + "JOIN amenities a ON r.amenity_id = a.amenity_id "
                + "JOIN users u1 ON r.requested_by = u1.user_id "
                + "LEFT JOIN users u2 ON r.approved_by = u2.user_id "
                + "ORDER BY r.created_at DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRequestWithDetails(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<ReplenishmentRequest> getRequestsByStatus(ReplenishmentRequest.Status status) {
        List<ReplenishmentRequest> list = new ArrayList<>();
        String sql = "SELECT r.*, a.name AS amenity_name, a.description AS amenity_desc, "
                + "u1.full_name AS requester_name, u2.full_name AS approver_name "
                + "FROM replenishment_requests r "
                + "JOIN amenities a ON r.amenity_id = a.amenity_id "
                + "JOIN users u1 ON r.requested_by = u1.user_id "
                + "LEFT JOIN users u2 ON r.approved_by = u2.user_id "
                + "WHERE r.status = ? "
                + "ORDER BY r.created_at DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status.name());
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRequestWithDetails(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<ReplenishmentRequest> getRequestsByInspection(int inspectionId) {
        List<ReplenishmentRequest> list = new ArrayList<>();
        String sql = "SELECT r.*, a.name AS amenity_name, a.description AS amenity_desc, "
                + "u1.full_name AS requester_name, u2.full_name AS approver_name "
                + "FROM replenishment_requests r "
                + "JOIN amenities a ON r.amenity_id = a.amenity_id "
                + "JOIN users u1 ON r.requested_by = u1.user_id "
                + "LEFT JOIN users u2 ON r.approved_by = u2.user_id "
                + "WHERE r.inspection_id = ? "
                + "ORDER BY r.created_at DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, inspectionId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRequestWithDetails(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<ReplenishmentRequest> getRequestsByRequester(int userId) {
        List<ReplenishmentRequest> list = new ArrayList<>();
        String sql = "SELECT r.*, a.name AS amenity_name, a.description AS amenity_desc, "
                + "u1.full_name AS requester_name, u2.full_name AS approver_name "
                + "FROM replenishment_requests r "
                + "JOIN amenities a ON r.amenity_id = a.amenity_id "
                + "JOIN users u1 ON r.requested_by = u1.user_id "
                + "LEFT JOIN users u2 ON r.approved_by = u2.user_id "
                + "WHERE r.requested_by = ? "
                + "ORDER BY r.created_at DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRequestWithDetails(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateRequestStatus(int requestId, ReplenishmentRequest.Status status, int approvedBy) {
        String sql = "{CALL sp_update_replenishment_status(?, ?, ?)}";

        try (CallableStatement cs = connection.prepareCall(sql)) {
            cs.setInt(1, requestId);
            cs.setString(2, status.name());
            cs.setInt(3, approvedBy);
            cs.execute();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int getPendingRequestCount() {
        String sql = "SELECT COUNT(*) FROM replenishment_requests WHERE status = 'PENDING'";

        try (PreparedStatement ps = connection.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private ReplenishmentRequest mapRequest(ResultSet rs) throws SQLException {
        ReplenishmentRequest req = new ReplenishmentRequest();
        req.setRequestId(rs.getInt("request_id"));
        req.setInspectionId(rs.getInt("inspection_id"));
        req.setAmenityId(rs.getInt("amenity_id"));
        req.setQuantityRequested(rs.getInt("quantity_requested"));
        req.setReason(rs.getString("reason"));
        req.setStatus(rs.getString("status"));
        req.setRequestedBy(rs.getInt("requested_by"));

        int approvedBy = rs.getInt("approved_by");
        if (!rs.wasNull()) {
            req.setApprovedBy(approvedBy);
        }

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            req.setCreatedAt(createdAt.toLocalDateTime());
        }

        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            req.setUpdatedAt(updatedAt.toLocalDateTime());
        }

        return req;
    }

    private ReplenishmentRequest mapRequestWithDetails(ResultSet rs) throws SQLException {
        ReplenishmentRequest req = mapRequest(rs);

        // Add amenity details
        Amenity amenity = new Amenity();
        amenity.setAmenityId(rs.getInt("amenity_id"));
        amenity.setName(rs.getString("amenity_name"));
        amenity.setDescription(rs.getString("amenity_desc"));
        req.setAmenity(amenity);

        // Add requester details
        User requester = new User();
        requester.setUserId(rs.getInt("requested_by"));
        requester.setFullName(rs.getString("requester_name"));
        req.setRequester(requester);

        // Add approver details if exists
        String approverName = rs.getString("approver_name");
        if (approverName != null) {
            User approver = new User();
            approver.setUserId(rs.getInt("approved_by"));
            approver.setFullName(approverName);
            req.setApprover(approver);
        }

        return req;
    }
}
