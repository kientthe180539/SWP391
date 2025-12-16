package Model;

import java.time.LocalDateTime;
import java.util.List;

public class RoomInspection {

    public enum Type {
        CHECKIN,
        CHECKOUT,
        ROUTINE
    }

    private Integer inspectionId;
    private Integer bookingId;
    private Integer roomId;
    private Integer inspectorId;
    private LocalDateTime inspectionDate;
    private Type type;
    private String note;

    // Optional: List of details
    private List<InspectionDetail> details;

    public RoomInspection() {
    }

    public RoomInspection(Integer inspectionId, Integer bookingId, Integer roomId, Integer inspectorId,
            LocalDateTime inspectionDate, Type type, String note) {
        this.inspectionId = inspectionId;
        this.bookingId = bookingId;
        this.roomId = roomId;
        this.inspectorId = inspectorId;
        this.inspectionDate = inspectionDate;
        this.type = type;
        this.note = note;
    }

    public Integer getInspectionId() {
        return inspectionId;
    }

    public void setInspectionId(Integer inspectionId) {
        this.inspectionId = inspectionId;
    }

    public Integer getBookingId() {
        return bookingId;
    }

    public void setBookingId(Integer bookingId) {
        this.bookingId = bookingId;
    }

    public Integer getRoomId() {
        return roomId;
    }

    public void setRoomId(Integer roomId) {
        this.roomId = roomId;
    }

    public Integer getInspectorId() {
        return inspectorId;
    }

    public void setInspectorId(Integer inspectorId) {
        this.inspectorId = inspectorId;
    }

    public LocalDateTime getInspectionDate() {
        return inspectionDate;
    }

    public void setInspectionDate(LocalDateTime inspectionDate) {
        this.inspectionDate = inspectionDate;
    }

    public Type getType() {
        return type;
    }

    public void setType(Type type) {
        this.type = type;
    }

    public void setType(String typeStr) {
        if (typeStr != null) {
            this.type = Type.valueOf(typeStr);
        }
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public List<InspectionDetail> getDetails() {
        return details;
    }

    public void setDetails(List<InspectionDetail> details) {
        this.details = details;
    }
}
