package DAL.Receptionist;

import DAL.DAO;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DAOReceptionist extends DAO {

    public static final DAOReceptionist INSTANCE = new DAOReceptionist();

    private DAOReceptionist() {
    }

    // ======================================================
    // Get Pending Bookings
    // ======================================================
    public List<Map<String, Object>> getPendingBookings() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT b.booking_id, b.customer_id, b.room_id, b.checkin_date, b.checkout_date, "
                + "b.num_guests, b.status, b.total_amount, b.created_at, "
                + "u.full_name as customer_name, u.email as customer_email, u.phone as customer_phone, "
                + "r.room_number, r.floor, rt.type_name, rt.base_price "
                + "FROM bookings b "
                + "JOIN users u ON b.customer_id = u.user_id "
                + "JOIN rooms r ON b.room_id = r.room_id "
                + "JOIN room_types rt ON r.room_type_id = rt.room_type_id "
                + "WHERE b.status = 'PENDING' "
                + "ORDER BY b.created_at ASC";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> booking = new HashMap<>();
                booking.put("bookingId", rs.getInt("booking_id"));
                booking.put("customerId", rs.getInt("customer_id"));
                booking.put("customerName", rs.getString("customer_name"));
                booking.put("customerEmail", rs.getString("customer_email"));
                booking.put("customerPhone", rs.getString("customer_phone"));
                booking.put("roomId", rs.getInt("room_id"));
                booking.put("roomNumber", rs.getString("room_number"));
                booking.put("floor", rs.getInt("floor"));
                booking.put("typeName", rs.getString("type_name"));
                booking.put("basePrice", rs.getBigDecimal("base_price"));
                booking.put("checkinDate", rs.getDate("checkin_date").toLocalDate());
                booking.put("checkoutDate", rs.getDate("checkout_date").toLocalDate());
                booking.put("numGuests", rs.getInt("num_guests"));
                booking.put("status", rs.getString("status"));
                booking.put("totalAmount", rs.getBigDecimal("total_amount"));
                booking.put("createdAt", rs.getTimestamp("created_at").toLocalDateTime());

                list.add(booking);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ======================================================
    // Get Booking with Full Details
    // ======================================================
    public Map<String, Object> getBookingWithDetails(int bookingId) {
        String sql = "SELECT b.*, "
                + "u.full_name as customer_name, u.email as customer_email, u.phone as customer_phone, "
                + "r.room_number, r.floor, r.status as room_status, "
                + "rt.type_name, rt.base_price, rt.max_occupancy, rt.description as room_description "
                + "FROM bookings b "
                + "JOIN users u ON b.customer_id = u.user_id "
                + "JOIN rooms r ON b.room_id = r.room_id "
                + "JOIN room_types rt ON r.room_type_id = rt.room_type_id "
                + "WHERE b.booking_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> result = new HashMap<>();

                    // Booking info
                    result.put("bookingId", rs.getInt("booking_id"));
                    result.put("customerId", rs.getInt("customer_id"));
                    result.put("roomId", rs.getInt("room_id"));
                    result.put("checkinDate", rs.getDate("checkin_date").toLocalDate());
                    result.put("checkoutDate", rs.getDate("checkout_date").toLocalDate());
                    result.put("numGuests", rs.getInt("num_guests"));
                    result.put("status", rs.getString("status"));
                    result.put("totalAmount", rs.getBigDecimal("total_amount"));
                    result.put("createdAt", rs.getTimestamp("created_at").toLocalDateTime());
                    Timestamp updatedAt = rs.getTimestamp("updated_at");
                    if (updatedAt != null) {
                        result.put("updatedAt", updatedAt.toLocalDateTime());
                    }

                    // Customer info
                    result.put("customerName", rs.getString("customer_name"));
                    result.put("customerEmail", rs.getString("customer_email"));
                    result.put("customerPhone", rs.getString("customer_phone"));

                    // Room info
                    result.put("roomNumber", rs.getString("room_number"));
                    result.put("floor", rs.getInt("floor"));
                    result.put("roomStatus", rs.getString("room_status"));
                    result.put("typeName", rs.getString("type_name"));
                    result.put("basePrice", rs.getBigDecimal("base_price"));
                    result.put("maxOccupancy", rs.getInt("max_occupancy"));
                    result.put("roomDescription", rs.getString("room_description"));

                    return result;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ======================================================
    // Approve Booking
    // ======================================================
    public boolean approveBooking(int bookingId, int receptionistId) {
        String sql = "UPDATE bookings SET status = 'CONFIRMED', updated_at = NOW() WHERE booking_id = ? AND status = 'PENDING'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ======================================================
    // Reject Booking
    // Note: Currently no rejection_reason column in database
    // If needed, you can add it later
    // ======================================================
    public boolean rejectBooking(int bookingId, int receptionistId, String reason) {
        String sql = "UPDATE bookings SET status = 'CANCELLED', updated_at = NOW() WHERE booking_id = ? AND status = 'PENDING'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ======================================================
    // Get All Bookings with Filters
    // ======================================================
    public List<Map<String, Object>> getAllBookingsWithFilters(
            String status, String search, LocalDate dateFrom, LocalDate dateTo,
            String sortBy, String sortOrder, int page, int pageSize) {

        List<Map<String, Object>> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT b.booking_id, b.customer_id, b.room_id, b.checkin_date, b.checkout_date, ");
        sql.append("b.num_guests, b.status, b.total_amount, b.created_at, ");
        sql.append("u.full_name as customer_name, u.email as customer_email, u.phone as customer_phone, ");
        sql.append("r.room_number, rt.type_name ");
        sql.append("FROM bookings b ");
        sql.append("JOIN users u ON b.customer_id = u.user_id ");
        sql.append("JOIN rooms r ON b.room_id = r.room_id ");
        sql.append("JOIN room_types rt ON r.room_type_id = rt.room_type_id ");
        sql.append("WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        // Filter by status
        if (status != null && !status.isBlank() && !"ALL".equalsIgnoreCase(status)) {
            sql.append("AND b.status = ? ");
            params.add(status);
        }

        // Search filter
        if (search != null && !search.isBlank()) {
            sql.append(
                    "AND (u.full_name LIKE ? OR u.email LIKE ? OR u.phone LIKE ? OR CAST(b.booking_id AS CHAR) LIKE ?) ");
            String searchPattern = "%" + search + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }

        // Date range filter
        if (dateFrom != null) {
            sql.append("AND b.checkin_date >= ? ");
            params.add(Date.valueOf(dateFrom));
        }
        if (dateTo != null) {
            sql.append("AND b.checkin_date <= ? ");
            params.add(Date.valueOf(dateTo));
        }

        // Sorting
        if (sortBy != null && !sortBy.isBlank()) {
            sql.append("ORDER BY ");
            switch (sortBy) {
                case "bookingId" ->
                    sql.append("b.booking_id");
                case "customerName" ->
                    sql.append("u.full_name");
                case "roomNumber" ->
                    sql.append("r.room_number");
                case "checkinDate" ->
                    sql.append("b.checkin_date");
                case "status" ->
                    sql.append("b.status");
                default ->
                    sql.append("b.created_at");
            }
            sql.append(" ").append("DESC".equalsIgnoreCase(sortOrder) ? "DESC" : "ASC");
        } else {
            sql.append("ORDER BY b.created_at DESC");
        }

        // Pagination
        sql.append(" LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> booking = new HashMap<>();
                    booking.put("bookingId", rs.getInt("booking_id"));
                    booking.put("customerId", rs.getInt("customer_id"));
                    booking.put("customerName", rs.getString("customer_name"));
                    booking.put("customerEmail", rs.getString("customer_email"));
                    booking.put("customerPhone", rs.getString("customer_phone"));
                    booking.put("roomId", rs.getInt("room_id"));
                    booking.put("roomNumber", rs.getString("room_number"));
                    booking.put("typeName", rs.getString("type_name"));
                    booking.put("checkinDate", rs.getDate("checkin_date").toLocalDate());
                    booking.put("checkoutDate", rs.getDate("checkout_date").toLocalDate());
                    booking.put("numGuests", rs.getInt("num_guests"));
                    booking.put("status", rs.getString("status"));
                    booking.put("totalAmount", rs.getBigDecimal("total_amount"));
                    booking.put("createdAt", rs.getTimestamp("created_at").toLocalDateTime());

                    list.add(booking);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ======================================================
    // Count Bookings (for pagination)
    // ======================================================
    public int countBookings(String status, String search, LocalDate dateFrom, LocalDate dateTo) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM bookings b ");
        sql.append("JOIN users u ON b.customer_id = u.user_id ");
        sql.append("WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        if (status != null && !status.isBlank() && !"ALL".equalsIgnoreCase(status)) {
            sql.append("AND b.status = ? ");
            params.add(status);
        }

        if (search != null && !search.isBlank()) {
            sql.append(
                    "AND (u.full_name LIKE ? OR u.email LIKE ? OR u.phone LIKE ? OR CAST(b.booking_id AS CHAR) LIKE ?) ");
            String searchPattern = "%" + search + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }

        if (dateFrom != null) {
            sql.append("AND b.checkin_date >= ? ");
            params.add(Date.valueOf(dateFrom));
        }
        if (dateTo != null) {
            sql.append("AND b.checkin_date <= ? ");
            params.add(Date.valueOf(dateTo));
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
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

    // ======================================================
    // Get Dashboard Statistics
    // ======================================================
    public Map<String, Integer> getDashboardStats() {
        Map<String, Integer> stats = new HashMap<>();
        String sql = "SELECT "
                + "SUM(CASE WHEN status = 'PENDING' THEN 1 ELSE 0 END) as pending_count, "
                + "SUM(CASE WHEN status = 'CONFIRMED' THEN 1 ELSE 0 END) as confirmed_count, "
                + "SUM(CASE WHEN status = 'CHECKED_IN' THEN 1 ELSE 0 END) as checkedin_count, "
                + "SUM(CASE WHEN checkin_date = CURDATE() AND (status = 'CONFIRMED' OR status = 'PENDING') THEN 1 ELSE 0 END) as today_arrivals "
                + "FROM bookings";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                stats.put("pending", rs.getInt("pending_count"));
                stats.put("confirmed", rs.getInt("confirmed_count"));
                stats.put("checkedIn", rs.getInt("checkedin_count"));
                stats.put("todayArrivals", rs.getInt("today_arrivals"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }

    // ======================================================
    // Get Today's Arrivals
    // ======================================================
    public List<Map<String, Object>> getTodayArrivals() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT b.booking_id, b.checkin_date, b.num_guests, b.status, "
                + "u.full_name as customer_name, u.phone as customer_phone, "
                + "r.room_number, rt.type_name "
                + "FROM bookings b "
                + "JOIN users u ON b.customer_id = u.user_id "
                + "JOIN rooms r ON b.room_id = r.room_id "
                + "JOIN room_types rt ON r.room_type_id = rt.room_type_id "
                + "WHERE b.checkin_date = CURDATE() "
                + "AND (b.status = 'CONFIRMED' OR b.status = 'PENDING') "
                + "ORDER BY r.room_number";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> arrival = new HashMap<>();
                arrival.put("bookingId", rs.getInt("booking_id"));
                arrival.put("customerName", rs.getString("customer_name"));
                arrival.put("customerPhone", rs.getString("customer_phone"));
                arrival.put("roomNumber", rs.getString("room_number"));
                arrival.put("typeName", rs.getString("type_name"));
                arrival.put("numGuests", rs.getInt("num_guests"));
                arrival.put("status", rs.getString("status"));
                arrival.put("checkinDate", rs.getDate("checkin_date").toLocalDate());

                list.add(arrival);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ======================================================
    // Get Recent Bookings
    // ======================================================
    public List<Map<String, Object>> getRecentBookings(int limit) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT b.booking_id, b.status, b.created_at, "
                + "u.full_name as customer_name, r.room_number "
                + "FROM bookings b "
                + "JOIN users u ON b.customer_id = u.user_id "
                + "JOIN rooms r ON b.room_id = r.room_id "
                + "ORDER BY b.created_at DESC LIMIT ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> booking = new HashMap<>();
                    booking.put("bookingId", rs.getInt("booking_id"));
                    booking.put("customerName", rs.getString("customer_name"));
                    booking.put("roomNumber", rs.getString("room_number"));
                    booking.put("status", rs.getString("status"));
                    booking.put("createdAt", rs.getTimestamp("created_at").toLocalDateTime());

                    list.add(booking);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ======================================================
    // No_Show Booking
    // ======================================================
    public boolean markNoShow(int bookingId, int receptionistId) {
        String sql = """
        UPDATE bookings
        SET status = 'NO_SHOW',
            updated_at = NOW()
        WHERE booking_id = ?
          AND status = 'CONFIRMED'
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ======================================================
    // Check-In Booking
    // ======================================================
    public boolean checkInBooking(int bookingId, int receptionistId) {
        String checkBookingSql = "SELECT status, checkin_date, room_id FROM bookings WHERE booking_id = ?";
        String updateBookingSql = "UPDATE bookings SET status = 'CHECKED_IN', updated_at = NOW() WHERE booking_id = ?";
        String updateRoomSql = "UPDATE rooms SET status = 'OCCUPIED' WHERE room_id = ?";

        try {
            connection.setAutoCommit(false);

            // 1. Validate booking status and check-in date
            int roomId = -1;
            try (PreparedStatement ps = connection.prepareStatement(checkBookingSql)) {
                ps.setInt(1, bookingId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        String status = rs.getString("status");
                        LocalDate checkinDate = rs.getDate("checkin_date").toLocalDate();
                        LocalDate today = LocalDate.now();

                        // Only CONFIRMED bookings can be checked in
                        if (!"CONFIRMED".equals(status)) {
                            connection.rollback();
                            return false;
                        }

                        // Check-in date must be today or in the past
                        if (checkinDate.isAfter(today)) {
                            connection.rollback();
                            return false;
                        }

                        roomId = rs.getInt("room_id");
                    } else {
                        connection.rollback();
                        return false;
                    }
                }
            }

            // 2. Update booking status
            try (PreparedStatement ps = connection.prepareStatement(updateBookingSql)) {
                ps.setInt(1, bookingId);
                ps.executeUpdate();
            }

            // 3. Update room status to OCCUPIED
            try (PreparedStatement ps = connection.prepareStatement(updateRoomSql)) {
                ps.setInt(1, roomId);
                ps.executeUpdate();
            }

            connection.commit();
            return true;

        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return false;
    }

    // ======================================================
    // Check-Out Booking
    // ======================================================
    public boolean checkOutBooking(int bookingId, int receptionistId) {
        String checkBookingSql = "SELECT status, room_id FROM bookings WHERE booking_id = ?";
        String updateBookingSql = "UPDATE bookings SET status = 'COMPLETED', updated_at = NOW() WHERE booking_id = ?";
        String updateRoomSql = "UPDATE rooms SET status = 'AVAILABLE' WHERE room_id = ?";

        try {
            connection.setAutoCommit(false);

            // 1. Validate booking status
            int roomId = -1;
            try (PreparedStatement ps = connection.prepareStatement(checkBookingSql)) {
                ps.setInt(1, bookingId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        String status = rs.getString("status");

                        // Only CHECKED_IN bookings can be checked out
                        if (!"CHECKED_IN".equals(status)) {
                            connection.rollback();
                            return false;
                        }

                        roomId = rs.getInt("room_id");
                    } else {
                        connection.rollback();
                        return false;
                    }
                }
            }

            // 2. Update booking status
            try (PreparedStatement ps = connection.prepareStatement(updateBookingSql)) {
                ps.setInt(1, bookingId);
                ps.executeUpdate();
            }

            // 3. Update room status to AVAILABLE
            try (PreparedStatement ps = connection.prepareStatement(updateRoomSql)) {
                ps.setInt(1, roomId);
                ps.executeUpdate();
            }

            connection.commit();
            return true;

        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return false;
    }

    // ======================================================
    // Get Confirmed Bookings Ready for Check-In
    // ======================================================
    public List<Map<String, Object>> getConfirmedBookingsReadyForCheckIn() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT b.booking_id, b.customer_id, b.room_id, b.checkin_date, b.checkout_date, "
                + "b.num_guests, b.status, b.total_amount, b.created_at, "
                + "u.full_name as customer_name, u.email as customer_email, u.phone as customer_phone, "
                + "r.room_number, r.floor, rt.type_name, rt.base_price "
                + "FROM bookings b "
                + "JOIN users u ON b.customer_id = u.user_id "
                + "JOIN rooms r ON b.room_id = r.room_id "
                + "JOIN room_types rt ON r.room_type_id = rt.room_type_id "
                + "WHERE b.status = 'CONFIRMED' "
                + "AND b.checkin_date <= CURDATE() "
                + "ORDER BY b.checkin_date ASC, r.room_number ASC";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> booking = new HashMap<>();
                booking.put("bookingId", rs.getInt("booking_id"));
                booking.put("customerId", rs.getInt("customer_id"));
                booking.put("customerName", rs.getString("customer_name"));
                booking.put("customerEmail", rs.getString("customer_email"));
                booking.put("customerPhone", rs.getString("customer_phone"));
                booking.put("roomId", rs.getInt("room_id"));
                booking.put("roomNumber", rs.getString("room_number"));
                booking.put("floor", rs.getInt("floor"));
                booking.put("typeName", rs.getString("type_name"));
                booking.put("basePrice", rs.getBigDecimal("base_price"));
                booking.put("checkinDate", rs.getDate("checkin_date").toLocalDate());
                booking.put("checkoutDate", rs.getDate("checkout_date").toLocalDate());
                booking.put("numGuests", rs.getInt("num_guests"));
                booking.put("status", rs.getString("status"));
                booking.put("totalAmount", rs.getBigDecimal("total_amount"));
                booking.put("createdAt", rs.getTimestamp("created_at").toLocalDateTime());

                list.add(booking);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ======================================================
    // Get Checked-In Bookings (for checkout)
    // ======================================================
    public List<Map<String, Object>> getCheckedInBookings() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT b.booking_id, b.customer_id, b.room_id, b.checkin_date, b.checkout_date, "
                + "b.num_guests, b.status, b.total_amount, b.created_at, "
                + "u.full_name as customer_name, u.email as customer_email, u.phone as customer_phone, "
                + "r.room_number, r.floor, rt.type_name, rt.base_price "
                + "FROM bookings b "
                + "JOIN users u ON b.customer_id = u.user_id "
                + "JOIN rooms r ON b.room_id = r.room_id "
                + "JOIN room_types rt ON r.room_type_id = rt.room_type_id "
                + "WHERE b.status = 'CHECKED_IN' "
                + "ORDER BY b.checkout_date ASC, r.room_number ASC";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> booking = new HashMap<>();
                booking.put("bookingId", rs.getInt("booking_id"));
                booking.put("customerId", rs.getInt("customer_id"));
                booking.put("customerName", rs.getString("customer_name"));
                booking.put("customerEmail", rs.getString("customer_email"));
                booking.put("customerPhone", rs.getString("customer_phone"));
                booking.put("roomId", rs.getInt("room_id"));
                booking.put("roomNumber", rs.getString("room_number"));
                booking.put("floor", rs.getInt("floor"));
                booking.put("typeName", rs.getString("type_name"));
                booking.put("basePrice", rs.getBigDecimal("base_price"));
                booking.put("checkinDate", rs.getDate("checkin_date").toLocalDate());
                booking.put("checkoutDate", rs.getDate("checkout_date").toLocalDate());
                booking.put("numGuests", rs.getInt("num_guests"));
                booking.put("status", rs.getString("status"));
                booking.put("totalAmount", rs.getBigDecimal("total_amount"));
                booking.put("createdAt", rs.getTimestamp("created_at").toLocalDateTime());

                list.add(booking);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ======================================================
    // Get Available Rooms for Date Range
    // ======================================================
    public List<Map<String, Object>> getAvailableRoomsForDateRange(LocalDate checkIn, LocalDate checkOut) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT r.room_id, r.room_number, r.floor, r.status as room_status, "
                + "rt.room_type_id, rt.type_name, rt.base_price, rt.max_occupancy, rt.description "
                + "FROM rooms r "
                + "JOIN room_types rt ON r.room_type_id = rt.room_type_id "
                + "WHERE r.status = 'AVAILABLE' "
                + "AND r.room_id NOT IN ("
                + "    SELECT b.room_id FROM bookings b "
                + "    WHERE b.status IN ('CONFIRMED', 'CHECKED_IN', 'PENDING') "
                + "    AND NOT (b.checkout_date <= ? OR b.checkin_date >= ?)"
                + ") "
                + "ORDER BY rt.type_name, r.floor, r.room_number";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setDate(1, Date.valueOf(checkIn));
            ps.setDate(2, Date.valueOf(checkOut));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> room = new HashMap<>();
                    room.put("roomId", rs.getInt("room_id"));
                    room.put("roomNumber", rs.getString("room_number"));
                    room.put("floor", rs.getInt("floor"));
                    room.put("roomStatus", rs.getString("room_status"));
                    room.put("roomTypeId", rs.getInt("room_type_id"));
                    room.put("typeName", rs.getString("type_name"));
                    room.put("basePrice", rs.getBigDecimal("base_price"));
                    room.put("maxOccupancy", rs.getInt("max_occupancy"));
                    room.put("description", rs.getString("description"));

                    list.add(room);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ======================================================
    // Create Direct Booking (Walk-in)
    // ======================================================
    public int createDirectBooking(int customerId, int roomId, LocalDate checkIn, LocalDate checkOut,
            int numGuests, java.math.BigDecimal totalAmount, int receptionistId) {
        String sql = "INSERT INTO bookings (customer_id, room_id, checkin_date, checkout_date, "
                + "num_guests, total_amount, status, created_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, 'CONFIRMED', NOW())";

        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, customerId);
            ps.setInt(2, roomId);
            ps.setDate(3, Date.valueOf(checkIn));
            ps.setDate(4, Date.valueOf(checkOut));
            ps.setInt(5, numGuests);
            ps.setBigDecimal(6, totalAmount);

            int affectedRows = ps.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    // ======================================================
    // Create or Get Customer for Walk-in
    // ======================================================
    public int createOrGetCustomer(String fullName, String email, String phone) {
        // First, try to find existing customer by email
        String findSql = "SELECT user_id FROM users WHERE email = ? AND role = 'CUSTOMER'";
        try (PreparedStatement ps = connection.prepareStatement(findSql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("user_id");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // If not found, create new customer
        String insertSql = "INSERT INTO users (full_name, email, phone, role, created_at) "
                + "VALUES (?, ?, ?, 'CUSTOMER', NOW())";
        try (PreparedStatement ps = connection.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, fullName);
            ps.setString(2, email);
            ps.setString(3, phone);

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    // ======================================================
    // Room Status Board Methods
    // ======================================================
    /**
     * Get all rooms with their current status and occupant information
     */
    public List<Map<String, Object>> getAllRoomsWithStatus() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT r.room_id, r.room_number, r.floor, r.status as room_status, "
                + "rt.room_type_id, rt.type_name, rt.max_occupancy, rt.base_price, "
                + "b.booking_id, b.checkin_date, b.checkout_date, "
                + "u.full_name as occupant_name "
                + "FROM rooms r "
                + "JOIN room_types rt ON r.room_type_id = rt.room_type_id "
                + "LEFT JOIN bookings b ON r.room_id = b.room_id "
                + "  AND b.status = 'CHECKED_IN' "
                + "LEFT JOIN users u ON b.customer_id = u.user_id "
                + "ORDER BY r.floor ASC, r.room_number ASC";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> room = new HashMap<>();
                room.put("roomId", rs.getInt("room_id"));
                room.put("roomNumber", rs.getString("room_number"));
                room.put("floor", rs.getInt("floor"));
                room.put("status", rs.getString("room_status"));
                room.put("roomTypeId", rs.getInt("room_type_id"));
                room.put("typeName", rs.getString("type_name"));
                room.put("maxOccupancy", rs.getInt("max_occupancy"));
                room.put("basePrice", rs.getBigDecimal("base_price"));

                // Occupant info (if checked in)
                if (rs.getObject("booking_id") != null) {
                    room.put("bookingId", rs.getInt("booking_id"));
                    room.put("occupantName", rs.getString("occupant_name"));
                    room.put("checkinDate", rs.getDate("checkin_date").toLocalDate());
                    room.put("checkoutDate", rs.getDate("checkout_date").toLocalDate());
                }

                list.add(room);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Get summary statistics of room statuses
     */
    public Map<String, Integer> getRoomStatusSummary() {
        Map<String, Integer> stats = new HashMap<>();
        String sql = "SELECT "
                + "SUM(CASE WHEN status = 'AVAILABLE' THEN 1 ELSE 0 END) as available_count, "
                + "SUM(CASE WHEN status = 'OCCUPIED' THEN 1 ELSE 0 END) as occupied_count, "
                + "SUM(CASE WHEN status = 'CLEANING' THEN 1 ELSE 0 END) as cleaning_count, "
                + "SUM(CASE WHEN status = 'MAINTENANCE' THEN 1 ELSE 0 END) as maintenance_count, "
                + "SUM(CASE WHEN status = 'OUT_OF_SERVICE' THEN 1 ELSE 0 END) as out_of_service_count, "
                + "COUNT(*) as total_count "
                + "FROM rooms";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                stats.put("available", rs.getInt("available_count"));
                stats.put("occupied", rs.getInt("occupied_count"));
                stats.put("cleaning", rs.getInt("cleaning_count"));
                stats.put("maintenance", rs.getInt("maintenance_count"));
                stats.put("outOfService", rs.getInt("out_of_service_count"));
                stats.put("total", rs.getInt("total_count"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }

    /**
     * Get rooms filtered by floor
     */
    public List<Map<String, Object>> getRoomsByFloor(int floor) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT r.room_id, r.room_number, r.floor, r.status as room_status, "
                + "rt.type_name, rt.max_occupancy, rt.base_price, "
                + "b.booking_id, u.full_name as occupant_name "
                + "FROM rooms r "
                + "JOIN room_types rt ON r.room_type_id = rt.room_type_id "
                + "LEFT JOIN bookings b ON r.room_id = b.room_id AND b.status = 'CHECKED_IN' "
                + "LEFT JOIN users u ON b.customer_id = u.user_id "
                + "WHERE r.floor = ? "
                + "ORDER BY r.room_number ASC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, floor);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> room = new HashMap<>();
                room.put("roomId", rs.getInt("room_id"));
                room.put("roomNumber", rs.getString("room_number"));
                room.put("floor", rs.getInt("floor"));
                room.put("status", rs.getString("room_status"));
                room.put("typeName", rs.getString("type_name"));
                room.put("maxOccupancy", rs.getInt("max_occupancy"));
                room.put("basePrice", rs.getBigDecimal("base_price"));

                if (rs.getObject("booking_id") != null) {
                    room.put("occupantName", rs.getString("occupant_name"));
                }

                list.add(room);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ======================================================
    // Room Detail Methods
    // ======================================================
    /**
     * Get detailed information about a specific room
     */
    public Map<String, Object> getRoomDetailById(int roomId) {
        String sql = "SELECT r.room_id, r.room_number, r.floor, r.status, "
                + "rt.room_type_id, rt.type_name, rt.description, rt.max_occupancy, rt.base_price, "
                + "b.booking_id, b.checkin_date, b.checkout_date, b.num_guests, "
                + "u.user_id as customer_id, u.full_name as customer_name, u.phone as customer_phone "
                + "FROM rooms r "
                + "JOIN room_types rt ON r.room_type_id = rt.room_type_id "
                + "LEFT JOIN bookings b ON r.room_id = b.room_id AND b.status = 'CHECKED_IN' "
                + "LEFT JOIN users u ON b.customer_id = u.user_id "
                + "WHERE r.room_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Map<String, Object> room = new HashMap<>();
                room.put("roomId", rs.getInt("room_id"));
                room.put("roomNumber", rs.getString("room_number"));
                room.put("floor", rs.getInt("floor"));
                room.put("status", rs.getString("status"));
                room.put("roomTypeId", rs.getInt("room_type_id"));
                room.put("typeName", rs.getString("type_name"));
                room.put("description", rs.getString("description"));
                room.put("maxOccupancy", rs.getInt("max_occupancy"));
                room.put("basePrice", rs.getBigDecimal("base_price"));

                // Current occupant info
                if (rs.getObject("booking_id") != null) {
                    room.put("bookingId", rs.getInt("booking_id"));
                    room.put("customerId", rs.getInt("customer_id"));
                    room.put("customerName", rs.getString("customer_name"));
                    room.put("customerPhone", rs.getString("customer_phone"));
                    room.put("checkinDate", rs.getDate("checkin_date").toLocalDate());
                    room.put("checkoutDate", rs.getDate("checkout_date").toLocalDate());
                    room.put("numGuests", rs.getInt("num_guests"));
                }

                return room;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Get booking history for a specific room
     */
    public List<Map<String, Object>> getRoomBookingHistory(int roomId, int limit) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT b.booking_id, b.checkin_date, b.checkout_date, b.num_guests, "
                + "b.status, b.total_amount, b.created_at, "
                + "u.full_name as customer_name, u.phone as customer_phone "
                + "FROM bookings b "
                + "JOIN users u ON b.customer_id = u.user_id "
                + "WHERE b.room_id = ? "
                + "ORDER BY b.checkin_date DESC "
                + "LIMIT ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ps.setInt(2, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> booking = new HashMap<>();
                booking.put("bookingId", rs.getInt("booking_id"));
                booking.put("checkinDate", rs.getDate("checkin_date").toLocalDate());
                booking.put("checkoutDate", rs.getDate("checkout_date").toLocalDate());
                booking.put("numGuests", rs.getInt("num_guests"));
                booking.put("status", rs.getString("status"));
                booking.put("totalAmount", rs.getBigDecimal("total_amount"));
                booking.put("createdAt", rs.getTimestamp("created_at"));
                booking.put("customerName", rs.getString("customer_name"));
                booking.put("customerPhone", rs.getString("customer_phone"));
                list.add(booking);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Update room status
     */
    public boolean updateRoomStatus(int roomId, String status) {
        String sql = "UPDATE rooms SET status = ? WHERE room_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, roomId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ======================================================
    // Reservation Detail Methods
    // ======================================================
    /**
     * Get comprehensive booking details by ID
     */
    public Map<String, Object> getBookingDetailById(int bookingId) {
        String sql = "SELECT b.booking_id, b.customer_id, b.room_id, b.checkin_date, b.checkout_date, "
                + "b.num_guests, b.status, b.total_amount, b.created_at, b.updated_at, "
                + "u.full_name as customer_name, u.email as customer_email, u.phone as customer_phone, "
                + "r.room_number, r.floor, r.status as room_status, "
                + "rt.room_type_id, rt.type_name, rt.description, rt.max_occupancy, rt.base_price "
                + "FROM bookings b "
                + "JOIN users u ON b.customer_id = u.user_id "
                + "JOIN rooms r ON b.room_id = r.room_id "
                + "JOIN room_types rt ON r.room_type_id = rt.room_type_id "
                + "WHERE b.booking_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Map<String, Object> booking = new HashMap<>();
                // Booking info
                booking.put("bookingId", rs.getInt("booking_id"));
                booking.put("checkinDate", rs.getDate("checkin_date").toLocalDate());
                booking.put("checkoutDate", rs.getDate("checkout_date").toLocalDate());
                booking.put("numGuests", rs.getInt("num_guests"));
                booking.put("status", rs.getString("status"));
                booking.put("totalAmount", rs.getBigDecimal("total_amount"));
                booking.put("createdAt", rs.getTimestamp("created_at"));
                booking.put("updatedAt", rs.getTimestamp("updated_at"));

                // Customer info
                booking.put("customerId", rs.getInt("customer_id"));
                booking.put("customerName", rs.getString("customer_name"));
                booking.put("customerEmail", rs.getString("customer_email"));
                booking.put("customerPhone", rs.getString("customer_phone"));

                // Room info
                booking.put("roomId", rs.getInt("room_id"));
                booking.put("roomNumber", rs.getString("room_number"));
                booking.put("floor", rs.getInt("floor"));
                booking.put("roomStatus", rs.getString("room_status"));
                booking.put("roomTypeId", rs.getInt("room_type_id"));
                booking.put("typeName", rs.getString("type_name"));
                booking.put("description", rs.getString("description"));
                booking.put("maxOccupancy", rs.getInt("max_occupancy"));
                booking.put("basePrice", rs.getBigDecimal("base_price"));

                return booking;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ======================================================
    // Profile Management Methods
    // ======================================================
    /**
     * Get user profile by user ID (for both view and edit)
     */
    public Map<String, Object> getUserProfile(int userId) {
        String sql = "SELECT u.user_id, u.full_name, u.email, u.phone, u.role_id, "
                + "r.role_name, u.created_at "
                + "FROM users u "
                + "LEFT JOIN roles r ON u.role_id = r.role_id "
                + "WHERE u.user_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Map<String, Object> profile = new HashMap<>();
                profile.put("userId", rs.getInt("user_id"));
                profile.put("fullName", rs.getString("full_name"));
                profile.put("email", rs.getString("email"));
                profile.put("phone", rs.getString("phone"));
                profile.put("roleId", rs.getInt("role_id"));
                profile.put("roleName", rs.getString("role_name"));
                profile.put("createdAt", rs.getTimestamp("created_at"));
                return profile;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Update user profile information (full name, email, phone)
     */
    public boolean updateProfile(int userId, String fullName, String email, String phone) {
        String sql = "UPDATE users SET full_name = ?, email = ?, phone = ? WHERE user_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, fullName);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setInt(4, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Change user password (with old password verification)
     */
    public boolean changePassword(int userId, String oldPassword, String newPassword) {
        // First verify old password
        String checkSql = "SELECT password FROM users WHERE user_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(checkSql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String currentPassword = rs.getString("password");
                // Verify old password matches (assuming passwords are hashed)
                if (!currentPassword.equals(oldPassword)) {
                    return false; // Old password doesn't match
                }

                // Update to new password
                String updateSql = "UPDATE users SET password = ? WHERE user_id = ?";
                try (PreparedStatement updatePs = connection.prepareStatement(updateSql)) {
                    updatePs.setString(1, newPassword);
                    updatePs.setInt(2, userId);
                    return updatePs.executeUpdate() > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
