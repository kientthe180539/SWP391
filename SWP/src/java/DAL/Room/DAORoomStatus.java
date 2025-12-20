package DAL.Room;

import DAL.DAO;
import Model.RoomStatusPeriod;
import Model.RoomStatusPeriod.Status;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO for room_status_periods table.
 * Handles time-based room status tracking.
 */
public class DAORoomStatus extends DAO {

    public static final DAORoomStatus INSTANCE = new DAORoomStatus();

    private DAORoomStatus() {
    }

    // ======================================================
    // Create Status Period
    // ======================================================
    public int createStatusPeriod(int roomId, Status status, LocalDate startDate, LocalDate endDate,
            Integer bookingId, String note) {
        String sql = "INSERT INTO room_status_periods (room_id, status, start_date, end_date, booking_id, note) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, roomId);
            ps.setString(2, status.name());
            ps.setDate(3, Date.valueOf(startDate));
            ps.setDate(4, Date.valueOf(endDate));
            if (bookingId != null) {
                ps.setInt(5, bookingId);
            } else {
                ps.setNull(5, Types.INTEGER);
            }
            ps.setString(6, note);

            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    // ======================================================
    // Check for Overlapping Status Periods
    // ======================================================
    /**
     * Check if room has any blocking status (BOOKED, MAINTENANCE, OCCUPIED)
     * that overlaps with the given date range.
     */
    public boolean hasBlockingStatusOverlap(int roomId, LocalDate checkIn, LocalDate checkOut) {
        String sql = "SELECT COUNT(*) FROM room_status_periods "
                + "WHERE room_id = ? "
                + "AND status IN ('BOOKED', 'MAINTENANCE', 'OCCUPIED') "
                + "AND start_date < ? AND end_date > ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ps.setDate(2, Date.valueOf(checkOut)); // start_date < checkOut
            ps.setDate(3, Date.valueOf(checkIn)); // end_date > checkIn

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return true; // Default to blocked on error
    }

    /**
     * Check if room has any blocking status that overlaps, excluding a specific
     * booking.
     * Useful for checking when modifying an existing booking.
     */
    public boolean hasBlockingStatusOverlapExcluding(int roomId, LocalDate checkIn, LocalDate checkOut,
            int excludeBookingId) {
        String sql = "SELECT COUNT(*) FROM room_status_periods "
                + "WHERE room_id = ? "
                + "AND status IN ('BOOKED', 'MAINTENANCE', 'OCCUPIED') "
                + "AND start_date < ? AND end_date > ? "
                + "AND (booking_id IS NULL OR booking_id != ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ps.setDate(2, Date.valueOf(checkOut));
            ps.setDate(3, Date.valueOf(checkIn));
            ps.setInt(4, excludeBookingId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return true;
    }

    // ======================================================
    // Get Status Periods
    // ======================================================
    public List<RoomStatusPeriod> getStatusPeriodsByRoom(int roomId) {
        List<RoomStatusPeriod> list = new ArrayList<>();
        String sql = "SELECT * FROM room_status_periods WHERE room_id = ? ORDER BY start_date DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapPeriod(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<RoomStatusPeriod> getStatusPeriodsInRange(int roomId, LocalDate startDate, LocalDate endDate) {
        List<RoomStatusPeriod> list = new ArrayList<>();
        String sql = "SELECT * FROM room_status_periods "
                + "WHERE room_id = ? "
                + "AND start_date < ? AND end_date > ? "
                + "ORDER BY start_date";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ps.setDate(2, Date.valueOf(endDate));
            ps.setDate(3, Date.valueOf(startDate));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapPeriod(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public RoomStatusPeriod getStatusPeriodByBooking(int bookingId) {
        String sql = "SELECT * FROM room_status_periods WHERE booking_id = ? ORDER BY created_at DESC LIMIT 1";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapPeriod(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ======================================================
    // Update Status Period
    // ======================================================
    public boolean updateStatusPeriodStatus(int periodId, Status newStatus) {
        String sql = "UPDATE room_status_periods SET status = ?, updated_at = NOW() WHERE period_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, newStatus.name());
            ps.setInt(2, periodId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateStatusPeriodByBooking(int bookingId, Status newStatus) {
        String sql = "UPDATE room_status_periods SET status = ?, updated_at = NOW() WHERE booking_id = ?";

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
    // Delete Status Period
    // ======================================================
    public boolean deleteStatusPeriod(int periodId) {
        String sql = "DELETE FROM room_status_periods WHERE period_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, periodId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteStatusPeriodByBooking(int bookingId) {
        String sql = "DELETE FROM room_status_periods WHERE booking_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ======================================================
    // Mapping
    // ======================================================
    private RoomStatusPeriod mapPeriod(ResultSet rs) throws SQLException {
        RoomStatusPeriod period = new RoomStatusPeriod();
        period.setPeriodId(rs.getInt("period_id"));
        period.setRoomId(rs.getInt("room_id"));
        period.setStatus(rs.getString("status"));
        period.setStartDate(rs.getDate("start_date").toLocalDate());
        period.setEndDate(rs.getDate("end_date").toLocalDate());

        int bookingId = rs.getInt("booking_id");
        if (!rs.wasNull()) {
            period.setBookingId(bookingId);
        }

        period.setNote(rs.getString("note"));

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            period.setCreatedAt(createdAt.toLocalDateTime());
        }

        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            period.setUpdatedAt(updatedAt.toLocalDateTime());
        }

        return period;
    }
}
