package Model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class WalletTransaction {

    public enum TransactionType {
        DEPOSIT("Deposit"),
        PAYMENT("Payment"),
        REFUND("Refund");

        private final String displayName;

        TransactionType(String displayName) {
            this.displayName = displayName;
        }

        public String getDisplayName() {
            return displayName;
        }
    }

    private Integer transactionId;
    private Integer walletId;
    private BigDecimal amount;
    private TransactionType transactionType;
    private String description;
    private Integer referenceId; // booking_id or payment_id
    private BigDecimal balanceAfter;
    private LocalDateTime createdAt;

    public WalletTransaction() {
    }

    public WalletTransaction(Integer walletId, BigDecimal amount, TransactionType type, String description) {
        this.walletId = walletId;
        this.amount = amount;
        this.transactionType = type;
        this.description = description;
    }

    // Getters and Setters
    public Integer getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(Integer transactionId) {
        this.transactionId = transactionId;
    }

    public Integer getWalletId() {
        return walletId;
    }

    public void setWalletId(Integer walletId) {
        this.walletId = walletId;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public TransactionType getTransactionType() {
        return transactionType;
    }

    public void setTransactionType(TransactionType transactionType) {
        this.transactionType = transactionType;
    }

    public void setTransactionType(String transactionType) {
        if (transactionType != null) {
            this.transactionType = TransactionType.valueOf(transactionType.toUpperCase());
        }
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getReferenceId() {
        return referenceId;
    }

    public void setReferenceId(Integer referenceId) {
        this.referenceId = referenceId;
    }

    public BigDecimal getBalanceAfter() {
        return balanceAfter;
    }

    public void setBalanceAfter(BigDecimal balanceAfter) {
        this.balanceAfter = balanceAfter;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    // Helper methods
    public boolean isDeposit() {
        return transactionType == TransactionType.DEPOSIT;
    }

    public boolean isPayment() {
        return transactionType == TransactionType.PAYMENT;
    }

    public boolean isRefund() {
        return transactionType == TransactionType.REFUND;
    }

    public String getTypeDisplayName() {
        return transactionType != null ? transactionType.getDisplayName() : "";
    }

    @Override
    public String toString() {
        return "WalletTransaction{" +
                "transactionId=" + transactionId +
                ", walletId=" + walletId +
                ", amount=" + amount +
                ", transactionType=" + transactionType +
                ", description='" + description + '\'' +
                '}';
    }
}
