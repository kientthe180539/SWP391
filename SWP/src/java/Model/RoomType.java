package Model;

import java.math.BigDecimal;

public class RoomType {

    private Integer roomTypeId;
    private String typeName;
    private String description;
    private BigDecimal basePrice;
    private Integer maxOccupancy;

    public RoomType() {
    }

    public RoomType(Integer roomTypeId,
                    String typeName,
                    String description,
                    BigDecimal basePrice,
                    Integer maxOccupancy) {

        setRoomTypeId(roomTypeId);
        setTypeName(typeName);
        setDescription(description);
        setBasePrice(basePrice);
        setMaxOccupancy(maxOccupancy);
    }

    public Integer getRoomTypeId() {
        return roomTypeId;
    }

    public void setRoomTypeId(Integer roomTypeId) {
        this.roomTypeId = roomTypeId;
    }

    public String getTypeName() {
        return typeName;
    }

    public void setTypeName(String typeName) {
        if (typeName == null || typeName.isBlank()) {
            throw new IllegalArgumentException("Type name cannot be null or blank");
        }
        this.typeName = typeName.trim();
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = (description == null ? null : description.trim());
    }

    public BigDecimal getBasePrice() {
        return basePrice;
    }

    public void setBasePrice(BigDecimal basePrice) {
        if (basePrice == null || basePrice.compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("Base price must be >= 0");
        }
        this.basePrice = basePrice;
    }

    public Integer getMaxOccupancy() {
        return maxOccupancy;
    }

    public void setMaxOccupancy(Integer maxOccupancy) {
        if (maxOccupancy == null || maxOccupancy <= 0) {
            throw new IllegalArgumentException("Max occupancy must be > 0");
        }
        this.maxOccupancy = maxOccupancy;
    }

    @Override
    public String toString() {
        return "RoomType{" +
                "roomTypeId=" + roomTypeId +
                ", typeName='" + typeName + '\'' +
                ", basePrice=" + basePrice +
                ", maxOccupancy=" + maxOccupancy +
                '}';
    }
}
