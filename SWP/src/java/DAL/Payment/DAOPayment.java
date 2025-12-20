package DAL.Payment;

import DAL.DAO;
import Model.Payment;
import Model.Payment.PaymentStatus;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DAOPayment extends DAO {

    public static final DAOPayment INSTANCE = new DAOPayment();

    private DAOPayment() {
    }

    // ======================================================
    // Create Payment
    // ======================================================
    public boolean createPayment(Payment payment) {
        String sql = "INSERT INTO payments (booking_id, amount, payment_method, payment_status, transaction_id) "
                + "VALUES (?, ?, ?, ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, payment.getBookingId());
            ps.setBigDecimal(2, payment.getAmount());
            ps.setString(3, payment.getPaymentMethod().name());
            ps.setString(4, payment.getPaymentStatus().name());
            ps.setString(5, payment.getTransactionId());

            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        payment.setPaymentId(rs.getInt(1));
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
    // Get Payment by ID
    // ======================================================
    public Payment getPaymentById(int paymentId) {
        String sql = "SELECT * FROM payments WHERE payment_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, paymentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToPayment(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ======================================================
    // Get Payment by Booking ID
    // ======================================================
    public Payment getPaymentByBookingId(int bookingId) {
        String sql = "SELECT * FROM payments WHERE booking_id = ? ORDER BY created_at DESC LIMIT 1";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToPayment(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ======================================================
    // Get All Payments for a Booking
    // ======================================================
    public List<Payment> getPaymentsByBookingId(int bookingId) {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT * FROM payments WHERE booking_id = ? ORDER BY created_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    payments.add(mapResultSetToPayment(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return payments;
    }

    // ======================================================
    // Update Payment Status
    // This will trigger trg_payment_completed to update booking status
    // ======================================================
    public boolean updatePaymentStatus(int paymentId, PaymentStatus status, String transactionId) {
        String sql = "UPDATE payments SET payment_status = ?, transaction_id = ?, updated_at = NOW() WHERE payment_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status.name());
            ps.setString(2, transactionId);
            ps.setInt(3, paymentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ======================================================
    // Complete Payment (simulated)
    // ======================================================
    public boolean completePayment(int paymentId, String transactionId) {
        return updatePaymentStatus(paymentId, PaymentStatus.COMPLETED, transactionId);
    }

    // ======================================================
    // Process Refund
    // This will trigger trg_payment_completed to cancel booking
    // ======================================================
    public boolean processRefund(int bookingId, String reason) {
        String sql = "UPDATE payments SET payment_status = 'REFUNDED', refund_amount = amount, "
                + "refund_reason = ?, updated_at = NOW() WHERE booking_id = ? AND payment_status = 'COMPLETED'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, reason);
            ps.setInt(2, bookingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ======================================================
    // Check if Booking has Completed Payment
    // ======================================================
    public boolean hasCompletedPayment(int bookingId) {
        String sql = "SELECT COUNT(*) FROM payments WHERE booking_id = ? AND payment_status = 'COMPLETED'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ======================================================
    // Get Pending Payments
    // ======================================================
    public List<Payment> getPendingPayments() {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT p.*, b.total_amount as booking_amount FROM payments p "
                + "JOIN bookings b ON p.booking_id = b.booking_id "
                + "WHERE p.payment_status = 'PENDING' ORDER BY p.created_at ASC";
        try (PreparedStatement ps = connection.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                payments.add(mapResultSetToPayment(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return payments;
    }

    // ======================================================
    // Helper: Map ResultSet to Payment
    // ======================================================
    private Payment mapResultSetToPayment(ResultSet rs) throws SQLException {
        Payment payment = new Payment();
        payment.setPaymentId(rs.getInt("payment_id"));
        payment.setBookingId(rs.getInt("booking_id"));
        payment.setAmount(rs.getBigDecimal("amount"));
        payment.setPaymentMethod(rs.getString("payment_method"));
        payment.setPaymentStatus(rs.getString("payment_status"));
        payment.setTransactionId(rs.getString("transaction_id"));

        BigDecimal refundAmount = rs.getBigDecimal("refund_amount");
        if (refundAmount != null) {
            payment.setRefundAmount(refundAmount);
        }
        payment.setRefundReason(rs.getString("refund_reason"));

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            payment.setCreatedAt(createdAt.toLocalDateTime());
        }
        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            payment.setUpdatedAt(updatedAt.toLocalDateTime());
        }
        return payment;
    }
}
