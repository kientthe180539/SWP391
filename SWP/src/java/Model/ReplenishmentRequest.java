package Model;

import java.time.LocalDateTime;

public class ReplenishmentRequest {

    public enum Status {
        PENDING,
        APPROVED,
        REJECTED,
        COMPLETED
    }

    private Integer requestId;
    private Integer inspectionId;
    private Integer amenityId;
    private Integer quantityRequested;
    private String reason;
    private Status status;
    private Integer requestedBy;
    private Integer approvedBy;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Optional: Amenity info for display
    private Amenity amenity;

    // Optional: User info for display
    private User requester;
    private User approver;

    public ReplenishmentRequest() {
    }

    public ReplenishmentRequest(Integer requestId, Integer inspectionId, Integer amenityId,
            Integer quantityRequested, String reason, Status status, Integer requestedBy,
            Integer approvedBy, LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.requestId = requestId;
        this.inspectionId = inspectionId;
        this.amenityId = amenityId;
        this.quantityRequested = quantityRequested;
        this.reason = reason;
        this.status = status;
        this.requestedBy = requestedBy;
        this.approvedBy = approvedBy;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public Integer getRequestId() {
        return requestId;
    }

    public void setRequestId(Integer requestId) {
        this.requestId = requestId;
    }

    public Integer getInspectionId() {
        return inspectionId;
    }

    public void setInspectionId(Integer inspectionId) {
        this.inspectionId = inspectionId;
    }

    public Integer getAmenityId() {
        return amenityId;
    }

    public void setAmenityId(Integer amenityId) {
        this.amenityId = amenityId;
    }

    public Integer getQuantityRequested() {
        return quantityRequested;
    }

    public void setQuantityRequested(Integer quantityRequested) {
        this.quantityRequested = quantityRequested;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public Status getStatus() {
        return status;
    }

    public void setStatus(Status status) {
        this.status = status;
    }

    public void setStatus(String statusStr) {
        if (statusStr != null) {
            this.status = Status.valueOf(statusStr);
        }
    }

    public Integer getRequestedBy() {
        return requestedBy;
    }

    public void setRequestedBy(Integer requestedBy) {
        this.requestedBy = requestedBy;
    }

    public Integer getApprovedBy() {
        return approvedBy;
    }

    public void setApprovedBy(Integer approvedBy) {
        this.approvedBy = approvedBy;
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

    public Amenity getAmenity() {
        return amenity;
    }

    public void setAmenity(Amenity amenity) {
        this.amenity = amenity;
    }

    public User getRequester() {
        return requester;
    }

    public void setRequester(User requester) {
        this.requester = requester;
    }

    public User getApprover() {
        return approver;
    }

    public void setApprover(User approver) {
        this.approver = approver;
    }
}
