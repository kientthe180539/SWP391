package DAL.Booking;

import DAL.DAO;
import DAL.Room.DAORoomStatus;
import Model.Booking;
import Model.Booking.Status;
import Model.Room;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class DAOBooking extends DAO {

    public static final DAOBooking INSTANCE = new DAOBooking();

    private DAOBooking() {
    }

    // ======================================================
    // Create Booking
    // Note: Database triggers automatically handle:
    // - Creating room_status_periods entry (trg_booking_insert)
    // - Updating rooms.status (trg_booking_insert doesn't do this, but
    // trg_booking_status_update will when CONFIRMED)
    // ======================================================
    public boolean createBooking(Booking booking) {
        String insertSql = "INSERT INTO bookings (customer_id, room_id, checkin_date, checkout_date, num_guests, status, total_amount, created_by, created_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW())";

        try (PreparedStatement ps = connection.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, booking.getCustomerId());
            ps.setInt(2, booking.getRoomId());
            ps.setDate(3, Date.valueOf(booking.getCheckinDate()));
            ps.setDate(4, Date.valueOf(booking.getCheckoutDate()));
            ps.setInt(5, booking.getNumGuests());
            ps.setString(6, booking.getStatus().name());
            ps.setBigDecimal(7, booking.getTotalAmount());
            if (booking.getCreatedBy() != null) {
                ps.setInt(8, booking.getCreatedBy());
            } else {
                ps.setNull(8, Types.INTEGER);
            }

            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        booking.setBookingId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ======================================================
    // Get Booking by ID
    // ======================================================
    public Booking getBookingById(int bookingId) {
        String sql = "SELECT * FROM bookings WHERE booking_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapBooking(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ======================================================
    // List Bookings
    // ======================================================
    // ======================================================
    // List Bookings (Advanced)
    // ======================================================
    public List<Booking> getBookings(String search, String status, String sortBy, String sortOrder, int page,
            int pageSize) {
        List<Booking> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT b.*, c.full_name as customer_name, c.email as customer_email, "
                        + "r.room_number, rt.type_name, r.room_type_id "
                        + "FROM bookings b "
                        + "JOIN users c ON b.customer_id = c.user_id "
                        + "JOIN rooms r ON b.room_id = r.room_id "
                        + "JOIN room_types rt ON r.room_type_id = rt.room_type_id "
                        + "WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        if (status != null && !status.isBlank() && !"ALL".equals(status)) {
            sql.append("AND b.status = ? ");
            params.add(status);
        }

        if (search != null && !search.isBlank()) {
            sql.append(
                    "AND (CAST(b.booking_id AS CHAR) LIKE ? OR c.full_name LIKE ? OR c.email LIKE ? OR r.room_number LIKE ?) ");
            String searchPattern = "%" + search + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }

        // Sorting
        sql.append("ORDER BY ");
        if (sortBy != null) {
            String field = switch (sortBy) {
                case "booking_id" -> "b.booking_id";
                case "checkin_date" -> "b.checkin_date";
                case "status" -> "b.status";
                case "customer" -> "c.full_name";
                case "room" -> "r.room_number";
                case "total_amount" -> "b.total_amount";
                case "created_at" -> "b.created_at";
                default -> "b.created_at";
            };
            sql.append(field);

            if (sortOrder != null && !sortOrder.isBlank()) {
                sql.append(" ").append(sortOrder).append(" ");
            } else {
                // Default directions if no explicit order provided
                switch (sortBy) {
                    case "booking_id", "total_amount", "created_at" -> sql.append(" DESC ");
                    default -> sql.append(" ASC ");
                }
            }
        } else {
            sql.append("b.created_at DESC ");
        }

        // Pagination
        sql.append("LIMIT ? OFFSET ? ");
        params.add(pageSize);
        params.add((page - 1) * pageSize);

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapBookingWithDetails(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Booking> getAllBookings() {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, c.full_name as customer_name, c.email as customer_email, "
                + "r.room_number, rt.type_name, r.room_type_id "
                + "FROM bookings b "
                + "JOIN users c ON b.customer_id = c.user_id "
                + "JOIN rooms r ON b.room_id = r.room_id "
                + "JOIN room_types rt ON r.room_type_id = rt.room_type_id "
                + "ORDER BY b.created_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapBookingWithDetails(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ======================================================
    // Check Availability
    // ======================================================
    public Room getRoomById(int roomId) {
        Room room = null; // Khởi tạo là null, nếu không tìm thấy sẽ trả về null thay vì object rỗng
        String sql = "SELECT * FROM hotel_manager_db.rooms WHERE room_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) { // Dùng if vì chỉ có 1 record duy nhất theo ID
                room = new Room();
                room.setRoomId(rs.getInt("room_id"));
                room.setRoomNumber(rs.getString("room_number"));
                room.setRoomTypeId(rs.getInt("room_type_id"));
                room.setFloor(rs.getInt("floor"));

                // Xử lý Enum Status: Lấy String từ DB và chuyển sang Enum
                String statusStr = rs.getString("status");
                if (statusStr != null) {
                    room.setStatus(Room.Status.valueOf(statusStr.toUpperCase()));
                }

                room.setImageUrl(rs.getString("image_url"));
                room.setDescription(rs.getString("description"));
                room.setActive(rs.getBoolean("is_active"));

                // Nếu bạn có join bảng hoặc cần set room_type_name từ query
                // room.setRoomTypeName(rs.getString("room_type_name"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (IllegalArgumentException e) {
            System.err.println("Lỗi chuyển đổi Enum: " + e.getMessage());
        }

        return room;
    }

    public boolean isRoomAvailable(int roomId, LocalDate checkIn, LocalDate checkOut) {
        System.out.println("DEBUG: Checking availability for Room " + roomId + " from " + checkIn + " to " + checkOut);

        Room room = getRoomById(roomId);
        if (room == null) {
            return false;
        }

        // Use the new room_status_periods table to check for blocking overlaps
        // This checks for BOOKED, MAINTENANCE, OCCUPIED periods that overlap with the
        // requested dates
        boolean hasBlockingOverlap = DAORoomStatus.INSTANCE.hasBlockingStatusOverlap(roomId, checkIn, checkOut);

        if (hasBlockingOverlap) {
            System.out.println("DEBUG: Found blocking status period overlap.");
            return false;
        }

        // Also check bookings table for any active bookings that overlap
        // (for backward compatibility and edge cases)
        String sql = "SELECT COUNT(*) FROM bookings "
                + "WHERE room_id = ? "
                + "AND status NOT IN ('CANCELLED', 'CHECKED_OUT', 'NO_SHOW') "
                + "AND DATE(checkin_date) < DATE(?) "
                + "AND DATE(checkout_date) > DATE(?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ps.setDate(2, Date.valueOf(checkOut));
            ps.setDate(3, Date.valueOf(checkIn));

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int count = rs.getInt(1);
                    System.out.println("DEBUG: Found " + count + " overlapping bookings in bookings table.");
                    return count == 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ======================================================
    // Get Bookings by Status
    // ======================================================
    public List<Booking> getBookingsByStatus(Status status) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, c.full_name as customer_name, c.email as customer_email, "
                + "r.room_number, rt.type_name, r.room_type_id "
                + "FROM bookings b "
                + "JOIN users c ON b.customer_id = c.user_id "
                + "JOIN rooms r ON b.room_id = r.room_id "
                + "JOIN room_types rt ON r.room_type_id = rt.room_type_id "
                + "WHERE b.status = ? ORDER BY b.created_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status.name());
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapBookingWithDetails(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Booking getLastBookingByRoomId(int roomId) {
        String sql = "SELECT * FROM bookings WHERE room_id = ? AND status = 'CHECKED_OUT' ORDER BY checkout_date DESC LIMIT 1";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapBooking(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Booking getCurrentBookingByRoomId(int roomId) {
        String sql = "SELECT * FROM bookings WHERE room_id = ? AND status = 'CHECKED_IN'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapBooking(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ======================================================
    // Update Status (General)
    // ======================================================
    public boolean updateBookingStatus(int bookingId, Status newStatus) {
        String sql = "UPDATE bookings SET status = ?, updated_at = NOW() WHERE booking_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, newStatus.name());
            ps.setInt(2, bookingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ======================================================
    // Check-In Transaction
    // Booking: CHECKED_IN -> Room: OCCUPIED (handled by trigger)
    // ======================================================
    public boolean checkIn(int bookingId) {
        String updateBookingSql = "UPDATE bookings SET status = 'CHECKED_IN', updated_at = NOW() WHERE booking_id = ?";
        // Trigger trg_booking_status_update will automatically:
        // - Update rooms.status to OCCUPIED
        // - Update room_status_periods.status to OCCUPIED

        try (PreparedStatement ps = connection.prepareStatement(updateBookingSql)) {
            ps.setInt(1, bookingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ======================================================
    // Check-Out Transaction
    // Booking: CHECKED_OUT -> Room: DIRTY (handled by trigger)
    // ======================================================
    public boolean checkOut(int bookingId) {
        String updateBookingSql = "UPDATE bookings SET status = 'CHECKED_OUT', updated_at = NOW() WHERE booking_id = ?";
        // Trigger trg_booking_status_update will automatically:
        // - Update rooms.status to DIRTY
        // - Update room_status_periods.end_date to today

        try (PreparedStatement ps = connection.prepareStatement(updateBookingSql)) {
            ps.setInt(1, bookingId);
            boolean success = ps.executeUpdate() > 0;
            if (success) {
                // Auto-assign CHECKOUT Cleaning task
                DAL.Housekeeping.DAOHousekeeping.INSTANCE.autoAssignTask(bookingId,
                        Model.HousekeepingTask.TaskType.CLEANING, "CHECKOUT",
                        LocalDate.now());
            }
            return success;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ======================================================
    // Customer Booking Methods
    // ======================================================
    // Get all bookings for a specific customer (newest first)
    public List<Booking> getBookingsByCustomerId(int customerId) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, c.full_name as customer_name, c.email as customer_email, "
                + "r.room_number, rt.type_name, r.room_type_id "
                + "FROM bookings b "
                + "JOIN users c ON b.customer_id = c.user_id "
                + "JOIN rooms r ON b.room_id = r.room_id "
                + "JOIN room_types rt ON r.room_type_id = rt.room_type_id "
                + "WHERE b.customer_id = ? ORDER BY b.created_at DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapBookingWithDetails(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Get latest booking by customer ID
    public Booking getLatestBookingByCustomerId(int customerId) {
        String sql = "SELECT * FROM bookings WHERE customer_id = ? ORDER BY created_at DESC LIMIT 1";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapBooking(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Get active booking (CHECKED_IN) for a customer with full details
    public Booking getActiveBookingByCustomerId(int customerId) {
        String sql = "SELECT b.*, c.full_name as customer_name, c.email as customer_email, "
                + "r.room_number, rt.type_name, rt.room_type_id "
                + "FROM bookings b "
                + "JOIN users c ON b.customer_id = c.user_id "
                + "JOIN rooms r ON b.room_id = r.room_id "
                + "JOIN room_types rt ON r.room_type_id = rt.room_type_id "
                + "WHERE b.customer_id = ? AND b.status = 'CHECKED_IN' "
                + "LIMIT 1";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapBookingWithDetails(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Cancel booking (only if status is PENDING or CONFIRMED)
    public boolean cancelBooking(int bookingId) {
        String checkSql = "SELECT status FROM bookings WHERE booking_id = ?";
        String updateSql = "UPDATE bookings SET status = 'CANCELLED', updated_at = NOW() WHERE booking_id = ?";

        try {
            // Check current status
            try (PreparedStatement ps = connection.prepareStatement(checkSql)) {
                ps.setInt(1, bookingId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        String currentStatus = rs.getString("status");
                        // Can only cancel PENDING or CONFIRMED bookings
                        if (!"PENDING".equals(currentStatus) && !"CONFIRMED".equals(currentStatus)) {
                            return false;
                        }
                    } else {
                        return false; // Booking not found
                    }
                }
            }

            // Update to cancelled
            try (PreparedStatement ps = connection.prepareStatement(updateSql)) {
                ps.setInt(1, bookingId);
                return ps.executeUpdate() > 0;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Get booking with room details (JOIN query)
    public java.util.Map<String, Object> getBookingWithRoomDetails(int bookingId) {
        String sql = "SELECT b.*, r.room_number, r.floor, r.status as room_status, "
                + "rt.type_name, rt.base_price, rt.max_occupancy, rt.description "
                + "FROM bookings b "
                + "JOIN rooms r ON b.room_id = r.room_id "
                + "JOIN room_types rt ON r.room_type_id = rt.room_type_id "
                + "WHERE b.booking_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    java.util.Map<String, Object> result = new java.util.HashMap<>();
                    result.put("booking", mapBooking(rs));

                    // Room details
                    java.util.Map<String, Object> roomDetails = new java.util.HashMap<>();
                    roomDetails.put("roomNumber", rs.getString("room_number"));
                    roomDetails.put("floor", rs.getInt("floor"));
                    roomDetails.put("roomStatus", rs.getString("room_status"));
                    roomDetails.put("typeName", rs.getString("type_name"));
                    roomDetails.put("basePrice", rs.getBigDecimal("base_price"));
                    roomDetails.put("capacity", rs.getInt("max_occupancy"));
                    roomDetails.put("description", rs.getString("description"));

                    result.put("roomDetails", roomDetails);
                    return result;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private Booking mapBooking(ResultSet rs) throws SQLException {
        Booking b = new Booking();
        b.setBookingId(rs.getInt("booking_id"));
        b.setCustomerId(rs.getInt("customer_id"));
        b.setRoomId(rs.getInt("room_id"));
        b.setCheckinDate(rs.getDate("checkin_date").toLocalDate());
        b.setCheckoutDate(rs.getDate("checkout_date").toLocalDate());
        b.setNumGuests(rs.getInt("num_guests"));

        try {
            b.setStatus(Status.valueOf(rs.getString("status")));
        } catch (Exception e) {
            b.setStatus(Status.PENDING);
        }

        b.setTotalAmount(rs.getBigDecimal("total_amount"));
        b.setCreatedBy(rs.getInt("created_by"));

        Timestamp cAt = rs.getTimestamp("created_at");
        if (cAt != null) {
            b.setCreatedAt(cAt.toLocalDateTime());
        }

        Timestamp uAt = rs.getTimestamp("updated_at");
        if (uAt != null) {
            b.setUpdatedAt(uAt.toLocalDateTime());
        }

        return b;
    }

    private Booking mapBookingWithDetails(ResultSet rs) throws SQLException {
        Booking b = mapBooking(rs);

        // Map customer details
        Model.User customer = new Model.User();
        customer.setUserId(b.getCustomerId());
        customer.setFullName(rs.getString("customer_name"));
        customer.setEmail(rs.getString("customer_email"));
        b.setCustomer(customer);

        // Map room details
        Room room = new Room();
        room.setRoomId(b.getRoomId());
        room.setRoomNumber(rs.getString("room_number"));

        Model.RoomType roomType = new Model.RoomType();
        roomType.setTypeName(rs.getString("type_name"));
        room.setRoomType(roomType);
        room.setRoomTypeId(rs.getInt("room_type_id"));
        b.setRoom(room);

        return b;
    }
    // ======================================================
    // Search & Filter Bookings (Owner)
    // ======================================================

    public List<Booking> searchBookings(String statusStr, String searchQuery, int page, int pageSize) {
        List<Booking> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT b.*, c.full_name as customer_name, c.email as customer_email, "
                        + "r.room_number, rt.type_name, r.room_type_id "
                        + "FROM bookings b "
                        + "JOIN users c ON b.customer_id = c.user_id "
                        + "JOIN rooms r ON b.room_id = r.room_id "
                        + "JOIN room_types rt ON r.room_type_id = rt.room_type_id "
                        + "WHERE 1=1");

        if (statusStr != null && !statusStr.isBlank() && !"ALL".equalsIgnoreCase(statusStr)) {
            sql.append(" AND b.status = ?");
        }

        if (searchQuery != null && !searchQuery.isBlank()) {
            sql.append(
                    " AND ( CAST(b.booking_id AS CHAR) LIKE ? OR c.full_name LIKE ? OR c.email LIKE ? OR r.room_number LIKE ? )");
        }

        sql.append(" ORDER BY b.created_at DESC");

        if (page > 0 && pageSize > 0) {
            sql.append(" LIMIT ? OFFSET ?");
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int idx = 1;

            if (statusStr != null && !statusStr.isBlank() && !"ALL".equalsIgnoreCase(statusStr)) {
                ps.setString(idx++, statusStr);
            }

            if (searchQuery != null && !searchQuery.isBlank()) {
                String kw = "%" + searchQuery + "%";
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
            }

            if (page > 0 && pageSize > 0) {
                ps.setInt(idx++, pageSize);
                ps.setInt(idx++, (page - 1) * pageSize);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapBookingWithDetails(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countBookings(String statusStr, String searchQuery) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM bookings b "
                        + "JOIN users c ON b.customer_id = c.user_id "
                        + "JOIN rooms r ON b.room_id = r.room_id "
                        + "WHERE 1=1");

        if (statusStr != null && !statusStr.isBlank() && !"ALL".equalsIgnoreCase(statusStr)) {
            sql.append(" AND b.status = ?");
        }

        if (searchQuery != null && !searchQuery.isBlank()) {
            sql.append(
                    " AND ( CAST(b.booking_id AS CHAR) LIKE ? OR c.full_name LIKE ? OR c.email LIKE ? OR r.room_number LIKE ? )");
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int idx = 1;

            if (statusStr != null && !statusStr.isBlank() && !"ALL".equalsIgnoreCase(statusStr)) {
                ps.setString(idx++, statusStr);
            }

            if (searchQuery != null && !searchQuery.isBlank()) {
                String kw = "%" + searchQuery + "%";
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
