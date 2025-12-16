package Model;

public class RoomTypeAmenity {

    private Integer id;
    private Integer roomTypeId;
    private Integer amenityId;
    private Integer defaultQuantity;

    // Optional: Full Amenity object for easier display
    private Amenity amenity;

    public RoomTypeAmenity() {
    }

    public RoomTypeAmenity(Integer id, Integer roomTypeId, Integer amenityId, Integer defaultQuantity) {
        this.id = id;
        this.roomTypeId = roomTypeId;
        this.amenityId = amenityId;
        this.defaultQuantity = defaultQuantity;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getRoomTypeId() {
        return roomTypeId;
    }

    public void setRoomTypeId(Integer roomTypeId) {
        this.roomTypeId = roomTypeId;
    }

    public Integer getAmenityId() {
        return amenityId;
    }

    public void setAmenityId(Integer amenityId) {
        this.amenityId = amenityId;
    }

    public Integer getDefaultQuantity() {
        return defaultQuantity;
    }

    public void setDefaultQuantity(Integer defaultQuantity) {
        if (defaultQuantity != null && defaultQuantity < 0) {
            throw new IllegalArgumentException("Quantity cannot be negative");
        }
        this.defaultQuantity = defaultQuantity;
    }

    public Amenity getAmenity() {
        return amenity;
    }

    public void setAmenity(Amenity amenity) {
        this.amenity = amenity;
    }
}
