package Model;

public class Room {

    public enum Status {
        AVAILABLE,
        BOOKED,
        OCCUPIED,
        DIRTY,
        CLEANING,
        MAINTENANCE
    }

    private Integer roomId;
    private String roomNumber;
    private Integer roomTypeId;
    private Integer floor;
    private Status status;
    private String roomTypeName;
    private String imageUrl;
    private String description;
    private Boolean isActive;
    private RoomType roomType;

    public Room() {
    }

    public Room(Integer roomId,
            String roomNumber,
            Integer roomTypeId,
            Integer floor,
            Status status,
            String imageUrl,
            String description,
            Boolean isActive) {

        setRoomId(roomId);
        setRoomNumber(roomNumber);
        setRoomTypeId(roomTypeId);
        setFloor(floor);
        setStatus(status != null ? status : Status.AVAILABLE);
        setImageUrl(imageUrl);
        setDescription(description);
        setActive(isActive != null ? isActive : Boolean.TRUE);
    }

    public Integer getRoomId() {
        return roomId;
    }

    public void setRoomId(Integer roomId) {
        this.roomId = roomId;
    }

    public String getRoomNumber() {
        return roomNumber;
    }

    public void setRoomNumber(String roomNumber) {
        if (roomNumber == null || roomNumber.isBlank()) {
            throw new IllegalArgumentException("Room number cannot be null or blank");
        }
        this.roomNumber = roomNumber.trim();
    }

    public Integer getRoomTypeId() {
        return roomTypeId;
    }

    public void setRoomTypeId(Integer roomTypeId) {
        if (roomTypeId == null) {
            throw new IllegalArgumentException("Room type id cannot be null");
        }
        this.roomTypeId = roomTypeId;
    }

    public Integer getFloor() {
        return floor;
    }

    public void setFloor(Integer floor) {
        // Cho phép null nếu không quản lý tầng
        if (floor != null && floor < 0) {
            throw new IllegalArgumentException("Floor must be >= 0");
        }
        this.floor = floor;
    }

    public Status getStatus() {
        return status;
    }

    public void setStatus(Status status) {
        if (status == null) {
            throw new IllegalArgumentException("Room status cannot be null");
        }
        this.status = status;
    }

    // Hỗ trợ chuyển từ String status DB -> enum
    public void setStatus(String statusStr) {
        if (statusStr == null) {
            throw new IllegalArgumentException("Room status string cannot be null");
        }
        this.status = Status.valueOf(statusStr);
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = (imageUrl == null ? null : imageUrl.trim());
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = (description == null ? null : description.trim());
    }

    public Boolean getActive() {
        return isActive;
    }

    public void setActive(Boolean active) {
        isActive = (active == null) ? Boolean.TRUE : active;
    }

    public RoomType getRoomType() {
        return roomType;
    }

    public void setRoomType(RoomType roomType) {
        this.roomType = roomType;
    }

    public String getRoomTypeName() {
        return roomTypeName;
    }

    public void setRoomTypeName(String roomTypeName) {
        this.roomTypeName = roomTypeName;
    }

    public java.util.List<String> getImageList() {
        if (imageUrl == null || imageUrl.trim().isEmpty()) {
            return new java.util.ArrayList<>();
        }
        return java.util.Arrays.asList(imageUrl.split(";"));
    }

    public String getFirstImage() {
        java.util.List<String> list = getImageList();
        return list.isEmpty() ? null : list.get(0);
    }

    @Override
    public String toString() {
        return "Room{"
                + "roomId=" + roomId
                + ", roomNumber='" + roomNumber + '\''
                + ", roomTypeId=" + roomTypeId
                + ", floor=" + floor
                + ", status=" + status
                + '}';
    }
}
