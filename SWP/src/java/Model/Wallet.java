package Model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Wallet {

    private Integer walletId;
    private Integer userId;
    private BigDecimal balance;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // User info for display
    private String userName;
    private String userFullName;

    public Wallet() {
        this.balance = BigDecimal.ZERO;
    }

    public Wallet(Integer userId) {
        this.userId = userId;
        this.balance = BigDecimal.ZERO;
    }

    // Getters and Setters
    public Integer getWalletId() {
        return walletId;
    }

    public void setWalletId(Integer walletId) {
        this.walletId = walletId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public BigDecimal getBalance() {
        return balance;
    }

    public void setBalance(BigDecimal balance) {
        this.balance = balance;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getUserFullName() {
        return userFullName;
    }

    public void setUserFullName(String userFullName) {
        this.userFullName = userFullName;
    }

    // Helper methods
    public boolean hasSufficientBalance(BigDecimal amount) {
        return balance != null && balance.compareTo(amount) >= 0;
    }

    public void addBalance(BigDecimal amount) {
        if (balance == null) {
            balance = BigDecimal.ZERO;
        }
        balance = balance.add(amount);
    }

    public void subtractBalance(BigDecimal amount) {
        if (balance == null) {
            balance = BigDecimal.ZERO;
        }
        balance = balance.subtract(amount);
    }

    @Override
    public String toString() {
        return "Wallet{" +
                "walletId=" + walletId +
                ", userId=" + userId +
                ", balance=" + balance +
                '}';
    }
}
