package Model;

public class InspectionDetail {

    public enum ConditionStatus {
        OK,
        DAMAGED,
        MISSING,
        USED
    }

    private Integer detailId;
    private Integer inspectionId;
    private Integer amenityId;
    private Integer quantityActual;
    private ConditionStatus conditionStatus;
    private String comment;

    // Optional: Amenity info
    private Amenity amenity;

    public InspectionDetail() {
    }

    public InspectionDetail(Integer detailId, Integer inspectionId, Integer amenityId, Integer quantityActual,
            ConditionStatus conditionStatus, String comment) {
        this.detailId = detailId;
        this.inspectionId = inspectionId;
        this.amenityId = amenityId;
        this.quantityActual = quantityActual;
        this.conditionStatus = conditionStatus;
        this.comment = comment;
    }

    public Integer getDetailId() {
        return detailId;
    }

    public void setDetailId(Integer detailId) {
        this.detailId = detailId;
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

    public Integer getQuantityActual() {
        return quantityActual;
    }

    public void setQuantityActual(Integer quantityActual) {
        this.quantityActual = quantityActual;
    }

    public ConditionStatus getConditionStatus() {
        return conditionStatus;
    }

    public void setConditionStatus(ConditionStatus conditionStatus) {
        this.conditionStatus = conditionStatus;
    }

    public void setConditionStatus(String statusStr) {
        if (statusStr != null) {
            this.conditionStatus = ConditionStatus.valueOf(statusStr);
        }
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Amenity getAmenity() {
        return amenity;
    }

    public void setAmenity(Amenity amenity) {
        this.amenity = amenity;
    }
}
