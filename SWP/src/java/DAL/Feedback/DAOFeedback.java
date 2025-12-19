package DAL.Feedback;

import DAL.DAO;
import Model.Feedback;
import java.sql.*;

public class DAOFeedback extends DAO {

    public static final DAOFeedback INSTANCE = new DAOFeedback();

    private DAOFeedback() {
    }

    // Create new feedback
    public boolean createFeedback(Feedback feedback) {
        String sql = "INSERT INTO feedbacks (booking_id, customer_id, rating, comment) VALUES (?, ?, ?, ?)";

        try {
            connection.setAutoCommit(false);
            try (PreparedStatement ps = this.connection.prepareStatement(sql)) {
                ps.setInt(1, feedback.getBookingId());
                ps.setInt(2, feedback.getCustomerId());
                ps.setInt(3, feedback.getRating());
                ps.setString(4, feedback.getComment());

                int rowsAffected = ps.executeUpdate();
                if (rowsAffected > 0) {
                    connection.commit();
                    return true;
                } else {
                    connection.rollback();
                    return false;
                }
            } catch (SQLException e) {
                connection.rollback();
                e.printStackTrace();
                return false;
            } finally {
                connection.setAutoCommit(true);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get feedback by booking ID
    public Feedback getFeedbackByBookingId(int bookingId) {
        String sql = "SELECT * FROM feedbacks WHERE booking_id = ?";

        try (PreparedStatement ps = this.connection.prepareStatement(sql)) {
            ps.setInt(1, bookingId);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapFeedback(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Update existing feedback
    public boolean updateFeedback(Feedback feedback) {
        String sql = "UPDATE feedbacks SET rating = ?, comment = ? WHERE feedback_id = ?";

        try {
            connection.setAutoCommit(false);
            try (PreparedStatement ps = this.connection.prepareStatement(sql)) {
                ps.setInt(1, feedback.getRating());
                ps.setString(2, feedback.getComment());
                ps.setInt(3, feedback.getFeedbackId());

                int rowsAffected = ps.executeUpdate();
                if (rowsAffected > 0) {
                    connection.commit();
                    return true;
                } else {
                    connection.rollback();
                    return false;
                }
            } catch (SQLException e) {
                connection.rollback();
                e.printStackTrace();
                return false;
            } finally {
                connection.setAutoCommit(true);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete feedback
    public boolean deleteFeedback(int feedbackId) {
        String sql = "DELETE FROM feedbacks WHERE feedback_id = ?";

        try {
            connection.setAutoCommit(false);
            try (PreparedStatement ps = this.connection.prepareStatement(sql)) {
                ps.setInt(1, feedbackId);

                int rowsAffected = ps.executeUpdate();
                if (rowsAffected > 0) {
                    connection.commit();
                    return true;
                } else {
                    connection.rollback();
                    return false;
                }
            } catch (SQLException e) {
                connection.rollback();
                e.printStackTrace();
                return false;
            } finally {
                connection.setAutoCommit(true);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get feedbacks by room ID with pagination
    public java.util.List<Feedback> getFeedbacksByRoomId(int roomId, int page, int pageSize) {
        java.util.List<Feedback> list = new java.util.ArrayList<>();
        int offset = (page - 1) * pageSize;
        String sql = """
                SELECT f.*, u.full_name
                FROM feedbacks f
                JOIN bookings b ON f.booking_id = b.booking_id
                JOIN users u ON f.customer_id = u.user_id
                WHERE b.room_id = ?
                ORDER BY f.created_at DESC
                LIMIT ? OFFSET ?
                """;

        try (PreparedStatement ps = this.connection.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ps.setInt(2, pageSize);
            ps.setInt(3, offset);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Feedback fb = mapFeedback(rs);
                try {
                    fb.setCustomerName(rs.getString("full_name"));
                } catch (SQLException e) {
                    // Column might not exist if mapFeedback called from other queries
                }
                list.add(fb);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countFeedbacksByRoomId(int roomId) {
        String sql = """
                SELECT COUNT(*)
                FROM feedbacks f
                JOIN bookings b ON f.booking_id = b.booking_id
                WHERE b.room_id = ?
                """;
        try (PreparedStatement ps = this.connection.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Map ResultSet to Feedback object
    private Feedback mapFeedback(ResultSet rs) throws SQLException {
        Feedback feedback = new Feedback();
        feedback.setFeedbackId(rs.getInt("feedback_id"));
        feedback.setBookingId(rs.getInt("booking_id"));
        feedback.setCustomerId(rs.getInt("customer_id"));
        feedback.setRating(rs.getInt("rating"));
        feedback.setComment(rs.getString("comment"));

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            feedback.setCreatedAt(createdAt.toLocalDateTime());
        }

        return feedback;
    }
}
