package Model;

import java.time.LocalDateTime;

public class IssueReport {

    public enum IssueStatus {
        NEW,
        IN_PROGRESS,
        RESOLVED,
        CLOSED
    }

    public enum IssueType {
        SUPPLY,
        EQUIPMENT,
        OTHER,
        CONFIRMATION
    }

    private Integer issueId;
    private Integer roomId;
    private String roomNumber; // Transient field for display
    private Integer bookingId;
    private Integer reportedBy;
    private IssueType issueType;
    private String description;
    private IssueStatus status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public IssueReport() {
    }

    public IssueReport(Integer issueId,
            Integer roomId,
            Integer bookingId,
            Integer reportedBy,
            IssueType issueType,
            String description,
            IssueStatus status,
            LocalDateTime createdAt,
            LocalDateTime updatedAt) {

        setIssueId(issueId);
        setRoomId(roomId);
        setBookingId(bookingId);
        setReportedBy(reportedBy);
        setIssueType(issueType != null ? issueType : IssueType.OTHER);
        setDescription(description);
        setStatus(status != null ? status : IssueStatus.NEW);
        setCreatedAt(createdAt);
        setUpdatedAt(updatedAt);
    }

    public Integer getIssueId() {
        return issueId;
    }

    public void setIssueId(Integer issueId) {
        this.issueId = issueId;
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

    public String getRoomNumber() {
        return roomNumber;
    }

    public void setRoomNumber(String roomNumber) {
        this.roomNumber = roomNumber;
    }

    public Integer getBookingId() {
        return bookingId;
    }

    public void setBookingId(Integer bookingId) {
        // có thể null
        this.bookingId = bookingId;
    }

    public Integer getReportedBy() {
        return reportedBy;
    }

    public void setReportedBy(Integer reportedBy) {
        if (reportedBy == null) {
            throw new IllegalArgumentException("ReportedBy user id cannot be null");
        }
        this.reportedBy = reportedBy;
    }

    public IssueType getIssueType() {
        return issueType;
    }

    public void setIssueType(IssueType issueType) {
        if (issueType == null) {
            throw new IllegalArgumentException("Issue type cannot be null");
        }
        this.issueType = issueType;
    }

    public void setIssueType(String typeStr) {
        if (typeStr == null) {
            throw new IllegalArgumentException("Issue type string cannot be null");
        }
        this.issueType = IssueType.valueOf(typeStr);
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        if (description == null || description.isBlank()) {
            throw new IllegalArgumentException("Issue description cannot be null or blank");
        }
        this.description = description.trim();
    }

    public IssueStatus getStatus() {
        return status;
    }

    public void setStatus(IssueStatus status) {
        if (status == null) {
            throw new IllegalArgumentException("Issue status cannot be null");
        }
        this.status = status;
    }

    public void setStatus(String statusStr) {
        if (statusStr == null) {
            throw new IllegalArgumentException("Issue status string cannot be null");
        }
        this.status = IssueStatus.valueOf(statusStr);
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
}
