package DAL.Wallet;

import DAL.DAO;
import Model.Wallet;
import Model.WalletTransaction;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DAOWallet extends DAO {

    public static final DAOWallet INSTANCE = new DAOWallet();

    private DAOWallet() {
    }

    // ======================================================
    // Get Wallet by User ID
    // ======================================================
    public Wallet getWalletByUserId(int userId) {
        String sql = "SELECT w.*, u.username, u.full_name FROM wallets w " +
                "JOIN users u ON w.user_id = u.user_id " +
                "WHERE w.user_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToWallet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ======================================================
    // Create Wallet for User
    // ======================================================
    public boolean createWallet(int userId) {
        String sql = "INSERT INTO wallets (user_id, balance) VALUES (?, 0.00)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            // May fail if wallet already exists (unique constraint)
            e.printStackTrace();
        }
        return false;
    }

    // ======================================================
    // Get or Create Wallet
    // ======================================================
    public Wallet getOrCreateWallet(int userId) {
        Wallet wallet = getWalletByUserId(userId);
        if (wallet == null) {
            createWallet(userId);
            wallet = getWalletByUserId(userId);
        }
        return wallet;
    }

    // ======================================================
    // Deposit Money into Wallet
    // ======================================================
    public boolean deposit(int userId, BigDecimal amount, String description) {
        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            return false;
        }

        Wallet wallet = getOrCreateWallet(userId);
        if (wallet == null) {
            return false;
        }

        try {
            connection.setAutoCommit(false);

            // Update wallet balance
            String updateSql = "UPDATE wallets SET balance = balance + ?, updated_at = NOW() WHERE wallet_id = ?";
            try (PreparedStatement ps = connection.prepareStatement(updateSql)) {
                ps.setBigDecimal(1, amount);
                ps.setInt(2, wallet.getWalletId());
                ps.executeUpdate();
            }

            // Calculate new balance
            BigDecimal newBalance = wallet.getBalance().add(amount);

            // Record transaction
            String txnSql = "INSERT INTO wallet_transactions (wallet_id, amount, transaction_type, description, balance_after) "
                    +
                    "VALUES (?, ?, 'DEPOSIT', ?, ?)";
            try (PreparedStatement ps = connection.prepareStatement(txnSql)) {
                ps.setInt(1, wallet.getWalletId());
                ps.setBigDecimal(2, amount);
                ps.setString(3, description);
                ps.setBigDecimal(4, newBalance);
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
    // Process Payment from Wallet
    // ======================================================
    public boolean processPayment(int userId, BigDecimal amount, int bookingId, String description) {
        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            return false;
        }

        Wallet wallet = getWalletByUserId(userId);
        if (wallet == null || !wallet.hasSufficientBalance(amount)) {
            return false;
        }

        try {
            connection.setAutoCommit(false);

            // Update wallet balance
            String updateSql = "UPDATE wallets SET balance = balance - ?, updated_at = NOW() WHERE wallet_id = ? AND balance >= ?";
            try (PreparedStatement ps = connection.prepareStatement(updateSql)) {
                ps.setBigDecimal(1, amount);
                ps.setInt(2, wallet.getWalletId());
                ps.setBigDecimal(3, amount);
                int rows = ps.executeUpdate();
                if (rows == 0) {
                    connection.rollback();
                    return false; // Insufficient balance
                }
            }

            // Calculate new balance
            BigDecimal newBalance = wallet.getBalance().subtract(amount);

            // Record transaction
            String txnSql = "INSERT INTO wallet_transactions (wallet_id, amount, transaction_type, description, reference_id, balance_after) "
                    +
                    "VALUES (?, ?, 'PAYMENT', ?, ?, ?)";
            try (PreparedStatement ps = connection.prepareStatement(txnSql)) {
                ps.setInt(1, wallet.getWalletId());
                ps.setBigDecimal(2, amount);
                ps.setString(3, description);
                ps.setInt(4, bookingId);
                ps.setBigDecimal(5, newBalance);
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
    // Process Refund to Wallet
    // ======================================================
    public boolean processRefund(int userId, BigDecimal amount, int bookingId, String description) {
        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            return false;
        }

        Wallet wallet = getOrCreateWallet(userId);
        if (wallet == null) {
            return false;
        }

        try {
            connection.setAutoCommit(false);

            // Update wallet balance
            String updateSql = "UPDATE wallets SET balance = balance + ?, updated_at = NOW() WHERE wallet_id = ?";
            try (PreparedStatement ps = connection.prepareStatement(updateSql)) {
                ps.setBigDecimal(1, amount);
                ps.setInt(2, wallet.getWalletId());
                ps.executeUpdate();
            }

            // Calculate new balance
            BigDecimal newBalance = wallet.getBalance().add(amount);

            // Record transaction
            String txnSql = "INSERT INTO wallet_transactions (wallet_id, amount, transaction_type, description, reference_id, balance_after) "
                    +
                    "VALUES (?, ?, 'REFUND', ?, ?, ?)";
            try (PreparedStatement ps = connection.prepareStatement(txnSql)) {
                ps.setInt(1, wallet.getWalletId());
                ps.setBigDecimal(2, amount);
                ps.setString(3, description);
                ps.setInt(4, bookingId);
                ps.setBigDecimal(5, newBalance);
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
    // Get Transaction History
    // ======================================================
    public List<WalletTransaction> getTransactionHistory(int walletId) {
        List<WalletTransaction> transactions = new ArrayList<>();
        String sql = "SELECT * FROM wallet_transactions WHERE wallet_id = ? ORDER BY created_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, walletId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    transactions.add(mapResultSetToTransaction(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return transactions;
    }

    // ======================================================
    // Get Recent Transactions (limited)
    // ======================================================
    public List<WalletTransaction> getRecentTransactions(int walletId, int limit) {
        List<WalletTransaction> transactions = new ArrayList<>();
        String sql = "SELECT * FROM wallet_transactions WHERE wallet_id = ? ORDER BY created_at DESC LIMIT ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, walletId);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    transactions.add(mapResultSetToTransaction(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return transactions;
    }

    // ======================================================
    // Helper: Map ResultSet to Wallet
    // ======================================================
    private Wallet mapResultSetToWallet(ResultSet rs) throws SQLException {
        Wallet wallet = new Wallet();
        wallet.setWalletId(rs.getInt("wallet_id"));
        wallet.setUserId(rs.getInt("user_id"));
        wallet.setBalance(rs.getBigDecimal("balance"));

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            wallet.setCreatedAt(createdAt.toLocalDateTime());
        }
        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            wallet.setUpdatedAt(updatedAt.toLocalDateTime());
        }

        // Optional user info
        try {
            wallet.setUserName(rs.getString("username"));
            wallet.setUserFullName(rs.getString("full_name"));
        } catch (SQLException e) {
            // Columns may not exist in all queries
        }

        return wallet;
    }

    // ======================================================
    // Helper: Map ResultSet to WalletTransaction
    // ======================================================
    private WalletTransaction mapResultSetToTransaction(ResultSet rs) throws SQLException {
        WalletTransaction txn = new WalletTransaction();
        txn.setTransactionId(rs.getInt("transaction_id"));
        txn.setWalletId(rs.getInt("wallet_id"));
        txn.setAmount(rs.getBigDecimal("amount"));
        txn.setTransactionType(rs.getString("transaction_type"));
        txn.setDescription(rs.getString("description"));

        int refId = rs.getInt("reference_id");
        if (!rs.wasNull()) {
            txn.setReferenceId(refId);
        }

        txn.setBalanceAfter(rs.getBigDecimal("balance_after"));

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            txn.setCreatedAt(createdAt.toLocalDateTime());
        }

        return txn;
    }
}
