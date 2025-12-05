package DAL.Booking;

import DAL.DAO;
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
    // ======================================================
    public boolean createBooking(Booking booking) {
        String sql = "INSERT INTO bookings (customer_id, room_id, checkin_date, checkout_date, num_guests, status, total_amount, created_by, created_at) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW())";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
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

            return ps.executeUpdate() > 0;

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
    public List<Booking> getAllBookings() {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT * FROM bookings ORDER BY created_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapBooking(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
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
    // Booking: CHECKED_IN -> Room: OCCUPIED
    // ======================================================
    public boolean checkIn(int bookingId) {
        String getBookingSql = "SELECT room_id FROM bookings WHERE booking_id = ?";
        String updateBookingSql = "UPDATE bookings SET status = 'CHECKED_IN', updated_at = NOW() WHERE booking_id = ?";
        String updateRoomSql = "UPDATE rooms SET status = 'OCCUPIED' WHERE room_id = ?";

        try {
            connection.setAutoCommit(false);

            int roomId = -1;
            try (PreparedStatement ps = connection.prepareStatement(getBookingSql)) {
                ps.setInt(1, bookingId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        roomId = rs.getInt("room_id");
                    } else {
                        connection.rollback();
                        return false;
                    }
                }
            }

            try (PreparedStatement ps = connection.prepareStatement(updateBookingSql)) {
                ps.setInt(1, bookingId);
                ps.executeUpdate();
            }

            try (PreparedStatement ps = connection.prepareStatement(updateRoomSql)) {
                ps.setInt(1, roomId);
                ps.executeUpdate();
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

    // ======================================================
    // Check-Out Transaction
    // Booking: CHECKED_OUT -> Room: DIRTY
    // Optional: Create Cleaning Task? (Not implemented here to keep it simple, can be done in Controller)
    // ======================================================
    public boolean checkOut(int bookingId) {
        String getBookingSql = "SELECT room_id FROM bookings WHERE booking_id = ?";
        String updateBookingSql = "UPDATE bookings SET status = 'CHECKED_OUT', updated_at = NOW() WHERE booking_id = ?";
        String updateRoomSql = "UPDATE rooms SET status = 'DIRTY' WHERE room_id = ?";

        try {
            connection.setAutoCommit(false);

            int roomId = -1;
            try (PreparedStatement ps = connection.prepareStatement(getBookingSql)) {
                ps.setInt(1, bookingId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        roomId = rs.getInt("room_id");
                    } else {
                        connection.rollback();
                        return false;
                    }
                }
            }

            try (PreparedStatement ps = connection.prepareStatement(updateBookingSql)) {
                ps.setInt(1, bookingId);
                ps.executeUpdate();
            }

            try (PreparedStatement ps = connection.prepareStatement(updateRoomSql)) {
                ps.setInt(1, roomId);
                ps.executeUpdate();
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
        if (cAt != null) b.setCreatedAt(cAt.toLocalDateTime());
        
        Timestamp uAt = rs.getTimestamp("updated_at");
        if (uAt != null) b.setUpdatedAt(uAt.toLocalDateTime());
        
        return b;
    }
}
