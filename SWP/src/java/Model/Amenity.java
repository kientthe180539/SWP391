package Model;

import java.math.BigDecimal;

public class Amenity {

    private Integer amenityId;
    private String name;
    private String description;
    private BigDecimal price;
    private Boolean isActive;

    public Amenity() {
    }

    public Amenity(Integer amenityId, String name, String description, BigDecimal price, Boolean isActive) {
        this.amenityId = amenityId;
        this.name = name;
        this.description = description;
        this.price = price;
        this.isActive = isActive;
    }

    public Integer getAmenityId() {
        return amenityId;
    }

    public void setAmenityId(Integer amenityId) {
        this.amenityId = amenityId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        if (name == null || name.isBlank()) {
            throw new IllegalArgumentException("Name cannot be null or blank");
        }
        this.name = name.trim();
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        if (price != null && price.compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("Price cannot be negative");
        }
        this.price = price;
    }

    public Boolean getActive() {
        return isActive;
    }

    public void setActive(Boolean active) {
        isActive = (active == null) ? Boolean.TRUE : active;
    }

    @Override
    public String toString() {
        return "Amenity{" + "amenityId=" + amenityId + ", name=" + name + ", price=" + price + '}';
    }
}
