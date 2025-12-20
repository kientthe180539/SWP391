package Model;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Represents a room status period - tracks room status over a date range.
 * Used for tracking BOOKED, MAINTENANCE, OCCUPIED, CLEANING, DIRTY status
 * periods.
 */
public class RoomStatusPeriod {

    public enum Status {
        AVAILABLE,
        BOOKED,
        OCCUPIED,
        DIRTY,
        CLEANING,
        MAINTENANCE
    }

    private Integer periodId;
    private Integer roomId;
    private Status status;
    private LocalDate startDate;
    private LocalDate endDate;
    private Integer bookingId;
    private String note;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Transient fields for display
    private String roomNumber;

    public RoomStatusPeriod() {
    }

    public RoomStatusPeriod(Integer roomId, Status status, LocalDate startDate, LocalDate endDate) {
        this.roomId = roomId;
        this.status = status;
        this.startDate = startDate;
        this.endDate = endDate;
    }

    // Getters and Setters
    public Integer getPeriodId() {
        return periodId;
    }

    public void setPeriodId(Integer periodId) {
        this.periodId = periodId;
    }

    public Integer getRoomId() {
        return roomId;
    }

    public void setRoomId(Integer roomId) {
        this.roomId = roomId;
    }

    public Status getStatus() {
        return status;
    }

    public void setStatus(Status status) {
        this.status = status;
    }

    public void setStatus(String statusStr) {
        if (statusStr != null) {
            this.status = Status.valueOf(statusStr.toUpperCase());
        }
    }

    public LocalDate getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }

    public LocalDate getEndDate() {
        return endDate;
    }

    public void setEndDate(LocalDate endDate) {
        this.endDate = endDate;
    }

    public Integer getBookingId() {
        return bookingId;
    }

    public void setBookingId(Integer bookingId) {
        this.bookingId = bookingId;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
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

    public String getRoomNumber() {
        return roomNumber;
    }

    public void setRoomNumber(String roomNumber) {
        this.roomNumber = roomNumber;
    }

    /**
     * Check if this period overlaps with given date range.
     */
    public boolean overlaps(LocalDate checkIn, LocalDate checkOut) {
        // Overlap: startDate < checkOut AND endDate > checkIn
        return startDate.isBefore(checkOut) && endDate.isAfter(checkIn);
    }

    @Override
    public String toString() {
        return "RoomStatusPeriod{" +
                "periodId=" + periodId +
                ", roomId=" + roomId +
                ", status=" + status +
                ", startDate=" + startDate +
                ", endDate=" + endDate +
                ", bookingId=" + bookingId +
                '}';
    }
}
