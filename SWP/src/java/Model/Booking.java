package Model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

public class Booking {

    public enum Status {
        PENDING,
        CONFIRMED,
        CANCELLED,
        CHECKED_IN,
        CHECKED_OUT,
        NO_SHOW
    }

    private Integer bookingId;
    private Integer customerId;
    private Integer roomId;
    private LocalDate checkinDate;
    private LocalDate checkoutDate;
    private Integer numGuests;
    private Status status;
    private BigDecimal totalAmount;
    private Integer createdBy;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Optional: for displaying related data
    private User customer;
    private Room room;

    public Booking() {
    }

    public Booking(Integer bookingId,
            Integer customerId,
            Integer roomId,
            LocalDate checkinDate,
            LocalDate checkoutDate,
            Integer numGuests,
            Status status,
            BigDecimal totalAmount,
            Integer createdBy,
            LocalDateTime createdAt,
            LocalDateTime updatedAt) {

        setBookingId(bookingId);
        setCustomerId(customerId);
        setRoomId(roomId);
        setCheckinDate(checkinDate);
        setCheckoutDate(checkoutDate);
        setNumGuests(numGuests);
        setStatus(status != null ? status : Status.PENDING);
        setTotalAmount(totalAmount);
        setCreatedBy(createdBy);
        setCreatedAt(createdAt);
        setUpdatedAt(updatedAt);

        validateDates();
    }

    private void validateDates() {
        if (checkinDate == null || checkoutDate == null) {
            throw new IllegalArgumentException("Checkin and checkout date cannot be null");
        }
        if (!checkoutDate.isAfter(checkinDate)) {
            throw new IllegalArgumentException("Checkout date must be after checkin date");
        }
    }

    public Integer getBookingId() {
        return bookingId;
    }

    public void setBookingId(Integer bookingId) {
        this.bookingId = bookingId;
    }

    public Integer getCustomerId() {
        return customerId;
    }

    public void setCustomerId(Integer customerId) {
        if (customerId == null) {
            throw new IllegalArgumentException("Customer id cannot be null");
        }
        this.customerId = customerId;
    }

    public Integer getRoomId() {
        return roomId;
    }

    public void setRoomId(Integer roomId) {
        if (roomId == null) {
            throw new IllegalArgumentException("Room id cannot be null");
        }
        this.roomId = roomId;
    }

    public LocalDate getCheckinDate() {
        return checkinDate;
    }

    public void setCheckinDate(LocalDate checkinDate) {
        this.checkinDate = checkinDate;
    }

    public LocalDate getCheckoutDate() {
        return checkoutDate;
    }

    public void setCheckoutDate(LocalDate checkoutDate) {
        this.checkoutDate = checkoutDate;
    }

    public Integer getNumGuests() {
        return numGuests;
    }

    public void setNumGuests(Integer numGuests) {
        if (numGuests == null || numGuests <= 0) {
            throw new IllegalArgumentException("Number of guests must be > 0");
        }
        this.numGuests = numGuests;
    }

    public Status getStatus() {
        return status;
    }

    public void setStatus(Status status) {
        if (status == null) {
            throw new IllegalArgumentException("Booking status cannot be null");
        }
        this.status = status;
    }

    public void setStatus(String statusStr) {
        if (statusStr == null) {
            throw new IllegalArgumentException("Booking status string cannot be null");
        }
        this.status = Status.valueOf(statusStr);
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        if (totalAmount == null || totalAmount.compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("Total amount must be >= 0");
        }
        this.totalAmount = totalAmount;
    }

    public Integer getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(Integer createdBy) {
        // Có thể null nếu hệ thống tự tạo
        this.createdBy = createdBy;
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

    public User getCustomer() {
        return customer;
    }

    public void setCustomer(User customer) {
        this.customer = customer;
    }

    public Room getRoom() {
        return room;
    }

    public void setRoom(Room room) {
        this.room = room;
    }

    @Override
    public String toString() {
        return "Booking{" +
                "bookingId=" + bookingId +
                ", customerId=" + customerId +
                ", roomId=" + roomId +
                ", checkinDate=" + checkinDate +
                ", checkoutDate=" + checkoutDate +
                ", numGuests=" + numGuests +
                ", status=" + status +
                ", totalAmount=" + totalAmount +
                '}';
    }
}
