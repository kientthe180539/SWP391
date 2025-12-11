package DAL;

import Model.Amenity;
import Model.InspectionDetail;
import Model.RoomInspection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RoomInspectionDAO extends DAO {

    public boolean createInspection(RoomInspection ri) {
        String sqlInspection = "{CALL sp_create_room_inspection(?, ?, ?, ?, ?, ?)}";
        String sqlDetail = "{CALL sp_add_inspection_detail(?, ?, ?, ?, ?, ?)}";

        try {
            connection.setAutoCommit(false);

            int inspectionId = -1;
            try (CallableStatement cs = connection.prepareCall(sqlInspection)) {
                if (ri.getBookingId() != null) {
                    cs.setInt(1, ri.getBookingId());
                } else {
                    cs.setNull(1, Types.INTEGER);
                }
                cs.setInt(2, ri.getRoomId());
                cs.setInt(3, ri.getInspectorId());
                cs.setString(4, ri.getType().name());
                cs.setString(5, ri.getNote());
                cs.registerOutParameter(6, Types.INTEGER);

                cs.execute();
                inspectionId = cs.getInt(6);
                ri.setInspectionId(inspectionId);
            }

            if (inspectionId > 0 && ri.getDetails() != null && !ri.getDetails().isEmpty()) {
                try (CallableStatement cs = connection.prepareCall(sqlDetail)) {
                    for (InspectionDetail detail : ri.getDetails()) {
                        cs.setInt(1, inspectionId);
                        cs.setInt(2, detail.getAmenityId());
                        cs.setInt(3, detail.getQuantityActual());
                        cs.setString(4, detail.getConditionStatus().name());
                        cs.setString(5, detail.getComment());
                        cs.registerOutParameter(6, Types.INTEGER);
                        cs.execute();
                    }
                }
            }

            connection.commit();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            try {
                connection.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return false;
    }

    public List<RoomInspection> getInspectionsByRoom(int roomId) {
        List<RoomInspection> list = new ArrayList<>();
        String sql = "SELECT * FROM room_inspections WHERE room_id = ? ORDER BY inspection_date DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapInspection(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<RoomInspection> getRecentInspections(int limit) {
        List<RoomInspection> list = new ArrayList<>();
        String sql = "SELECT * FROM room_inspections ORDER BY inspection_date DESC LIMIT ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapInspection(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public RoomInspection getInspectionById(int id) {
        String sql = "SELECT * FROM room_inspections WHERE inspection_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    RoomInspection ri = mapInspection(rs);
                    ri.setDetails(getInspectionDetails(id));
                    return ri;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<InspectionDetail> getInspectionDetails(int inspectionId) {
        List<InspectionDetail> list = new ArrayList<>();
        String sql = "SELECT d.*, a.name, a.description, a.price " +
                "FROM inspection_details d " +
                "JOIN amenities a ON d.amenity_id = a.amenity_id " +
                "WHERE d.inspection_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, inspectionId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    InspectionDetail d = new InspectionDetail();
                    d.setDetailId(rs.getInt("detail_id"));
                    d.setInspectionId(rs.getInt("inspection_id"));
                    d.setAmenityId(rs.getInt("amenity_id"));
                    d.setQuantityActual(rs.getInt("quantity_actual"));
                    d.setConditionStatus(rs.getString("condition_status"));
                    d.setComment(rs.getString("comment"));

                    Amenity a = new Amenity();
                    a.setAmenityId(rs.getInt("amenity_id"));
                    a.setName(rs.getString("name"));
                    a.setDescription(rs.getString("description"));
                    a.setPrice(rs.getBigDecimal("price"));
                    d.setAmenity(a);

                    list.add(d);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private RoomInspection mapInspection(ResultSet rs) throws SQLException {
        RoomInspection ri = new RoomInspection();
        ri.setInspectionId(rs.getInt("inspection_id"));
        int bookingId = rs.getInt("booking_id");
        if (!rs.wasNull()) {
            ri.setBookingId(bookingId);
        }
        ri.setRoomId(rs.getInt("room_id"));
        ri.setInspectorId(rs.getInt("inspector_id"));
        Timestamp ts = rs.getTimestamp("inspection_date");
        if (ts != null) {
            ri.setInspectionDate(ts.toLocalDateTime());
        }
        ri.setType(rs.getString("type"));
        ri.setNote(rs.getString("note"));
        return ri;
    }

    public RoomInspection getInspectionByBookingAndType(int bookingId, String type) {
        String sql = "SELECT * FROM room_inspections WHERE booking_id = ? AND type = ? ORDER BY inspection_date DESC LIMIT 1";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ps.setString(2, type);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    RoomInspection ri = mapInspection(rs);
                    ri.setDetails(getInspectionDetails(ri.getInspectionId()));
                    return ri;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public RoomInspection getLastInspectionByRoomAndType(int roomId, String type) {
        String sql = "SELECT * FROM room_inspections WHERE room_id = ? AND type = ? ORDER BY inspection_date DESC LIMIT 1";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ps.setString(2, type);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    RoomInspection ri = mapInspection(rs);
                    ri.setDetails(getInspectionDetails(ri.getInspectionId()));
                    return ri;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
