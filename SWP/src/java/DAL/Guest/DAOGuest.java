package DAL.Guest;

import DAL.DAO;
import Model.Room;
import Model.RoomType;
import java.math.BigDecimal;
import java.sql.*;
import java.util.AbstractMap;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class DAOGuest extends DAO {

    public static DAOGuest INSTANCE = new DAOGuest();

    private DAOGuest() {
    }

    /**
     * Lấy danh sách phòng có trạng thái AVAILABLE và filter theo roomTypeId,
     * minPrice, maxPrice Có phân trang
     */
    /**
     * Lấy danh sách phòng có trạng thái AVAILABLE và filter theo roomTypeId,
     * minPrice, maxPrice, checkIn, checkOut Có phân trang
     */
    public List<Map.Entry<Room, RoomType>> getAvailableRooms(
            Integer roomTypeId,
            BigDecimal minPrice,
            BigDecimal maxPrice,
            java.time.LocalDate checkIn,
            java.time.LocalDate checkOut,
            int page,
            int pageSize) {
        List<Map.Entry<Room, RoomType>> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;

        // Base query: Active rooms not in MAINTENANCE
        String sql = """
                    SELECT r.*,
                           rt.room_type_id AS rt_id, rt.type_name, rt.description AS rt_desc,
                           rt.base_price, rt.max_occupancy
                    FROM rooms r
                    JOIN room_types rt ON r.room_type_id = rt.room_type_id
                    WHERE r.is_active = 1 AND r.status != 'MAINTENANCE' AND r.status != 'DIRTY'
                """;

        List<Object> params = new ArrayList<>();

        if (roomTypeId != null) {
            sql += " AND rt.room_type_id = ? ";
            params.add(roomTypeId);
        }

        if (minPrice != null) {
            sql += " AND rt.base_price >= ? ";
            params.add(minPrice);
        }

        if (maxPrice != null) {
            sql += " AND rt.base_price <= ? ";
            params.add(maxPrice);
        }

        // Date range filter: Exclude rooms with overlapping bookings
        if (checkIn != null && checkOut != null) {
            sql += """
                    AND NOT EXISTS (
                        SELECT 1 FROM bookings b
                        WHERE b.room_id = r.room_id
                        AND b.status IN ('PENDING', 'CONFIRMED', 'CHECKED_IN')
                        AND b.checkin_date < ? AND b.checkout_date > ?
                    )
                    """;
            params.add(checkOut); // Note: Logic overlap is (StartA < EndB) and (EndA > StartB)
            params.add(checkIn);
        } else {
            // Fallback: If no dates selected, show currently available rooms
            sql += " AND r.status = 'AVAILABLE' ";
        }

        sql += " ORDER BY r.room_number LIMIT ? OFFSET ?";
        params.add(pageSize);
        params.add(offset);

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Room room = new Room();
                room.setRoomId(rs.getInt("room_id"));
                room.setRoomNumber(rs.getString("room_number"));
                room.setRoomTypeId(rs.getInt("room_type_id"));
                room.setFloor(rs.getInt("floor"));
                room.setStatus(Room.Status.valueOf(rs.getString("status")));
                room.setImageUrl(rs.getString("image_url"));
                room.setDescription(rs.getString("description"));
                room.setActive(rs.getBoolean("is_active"));

                RoomType type = new RoomType();
                type.setRoomTypeId(rs.getInt("rt_id"));
                type.setTypeName(rs.getString("type_name"));
                type.setDescription(rs.getString("rt_desc"));
                type.setBasePrice(rs.getBigDecimal("base_price"));
                type.setMaxOccupancy(rs.getInt("max_occupancy"));

                list.add(new AbstractMap.SimpleEntry<>(room, type));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    /**
     * Đếm tổng số phòng AVAILABLE để phân trang
     */
    public int countAvailableRooms(Integer roomTypeId, java.time.LocalDate checkIn, java.time.LocalDate checkOut) {
        String sql = """
                    SELECT COUNT(*)
                    FROM rooms r
                    JOIN room_types rt ON r.room_type_id = rt.room_type_id
                    WHERE r.is_active = 1 AND r.status != 'MAINTENANCE'
                """;

        List<Object> params = new ArrayList<>();

        if (roomTypeId != null) {
            sql += " AND rt.room_type_id = ?";
            params.add(roomTypeId);
        }

        if (checkIn != null && checkOut != null) {
            sql += """
                    AND NOT EXISTS (
                        SELECT 1 FROM bookings b
                        WHERE b.room_id = r.room_id
                        AND b.status IN ('PENDING', 'CONFIRMED', 'CHECKED_IN')
                        AND b.checkin_date < ? AND b.checkout_date > ?
                    )
                    """;
            params.add(checkOut);
            params.add(checkIn);
        } else {
            sql += " AND r.status = 'AVAILABLE' ";
        }

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Lấy danh sách tất cả room types (để show filter)
     */
    public List<RoomType> getAllRoomTypes() {
        List<RoomType> list = new ArrayList<>();
        String sql = "SELECT * FROM room_types ORDER BY type_name";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                RoomType type = new RoomType();
                type.setRoomTypeId(rs.getInt("room_type_id"));
                type.setTypeName(rs.getString("type_name"));
                type.setDescription(rs.getString("description"));
                type.setBasePrice(rs.getBigDecimal("base_price"));
                type.setMaxOccupancy(rs.getInt("max_occupancy"));
                list.add(type);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * ROOM DETAIL (by room_id)
     */
    public Room getRoomDetail(int roomId) {
        String sql = """
                SELECT r.*, rt.type_name, rt.description AS type_description,
                       rt.base_price, rt.max_occupancy
                FROM rooms r
                JOIN room_types rt ON r.room_type_id = rt.room_type_id
                WHERE r.room_id = ?
                """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, roomId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Room room = mapRoom(rs);
                RoomType type = new RoomType();
                type.setRoomTypeId(rs.getInt("room_type_id"));
                type.setTypeName(rs.getString("type_name"));
                type.setDescription(rs.getString("type_description"));
                type.setBasePrice(rs.getBigDecimal("base_price"));
                type.setMaxOccupancy(rs.getInt("max_occupancy"));

                // Return as pair
                return room; // hoặc Map.Entry<Room, RoomType> nếu muốn return cùng type
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public Map.Entry<Room, RoomType> getRoomDetailWithType(int roomId) {
        String sql = """
                SELECT r.*, rt.room_type_id AS rt_id, rt.type_name, rt.description AS rt_desc,
                       rt.base_price, rt.max_occupancy
                FROM rooms r
                JOIN room_types rt ON r.room_type_id = rt.room_type_id
                WHERE r.room_id = ?
                """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Room room = new Room();
                room.setRoomId(rs.getInt("room_id"));
                room.setRoomNumber(rs.getString("room_number"));
                room.setRoomTypeId(rs.getInt("room_type_id"));
                room.setFloor(rs.getInt("floor"));
                room.setStatus(Room.Status.valueOf(rs.getString("status")));
                room.setImageUrl(rs.getString("image_url"));
                room.setDescription(rs.getString("description"));
                room.setActive(rs.getBoolean("is_active"));

                RoomType type = new RoomType();
                type.setRoomTypeId(rs.getInt("rt_id"));
                type.setTypeName(rs.getString("type_name"));
                type.setDescription(rs.getString("rt_desc"));
                type.setBasePrice(rs.getBigDecimal("base_price"));
                type.setMaxOccupancy(rs.getInt("max_occupancy"));

                return new AbstractMap.SimpleEntry<>(room, type);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * MAP RESULTSET → ROOM OBJECT
     */
    private Room mapRoom(ResultSet rs) throws SQLException {
        Room room = new Room();

        room.setRoomId(rs.getInt("room_id"));
        room.setRoomNumber(rs.getString("room_number"));
        room.setRoomTypeId(rs.getInt("room_type_id"));
        room.setFloor(rs.getInt("floor"));

        // Chuyển status string sang enum
        String statusStr = rs.getString("status");
        if (statusStr != null && !statusStr.isBlank()) {
            try {
                room.setStatus(Room.Status.valueOf(statusStr.toUpperCase()));
            } catch (IllegalArgumentException e) {
                room.setStatus(Room.Status.AVAILABLE); // default nếu không hợp lệ
            }
        }

        room.setImageUrl(rs.getString("image_url"));
        room.setDescription(rs.getString("description"));
        room.setActive(rs.getBoolean("is_active"));

        return room;
    }
}
