package Model;

import java.time.LocalDateTime;

public class Feedback {

    private Integer feedbackId;
    private Integer bookingId;
    private Integer customerId;
    private Integer rating; // 1–5
    private String comment;
    private LocalDateTime createdAt;

    public Feedback() {
    }

    public Feedback(Integer feedbackId,
            Integer bookingId,
            Integer customerId,
            Integer rating,
            String comment,
            LocalDateTime createdAt) {

        setFeedbackId(feedbackId);
        setBookingId(bookingId);
        setCustomerId(customerId);
        setRating(rating);
        setComment(comment);
        setCreatedAt(createdAt);
    }

    public Integer getFeedbackId() {
        return feedbackId;
    }

    public void setFeedbackId(Integer feedbackId) {
        this.feedbackId = feedbackId;
    }

    public Integer getBookingId() {
        return bookingId;
    }

    public void setBookingId(Integer bookingId) {
        if (bookingId == null) {
            throw new IllegalArgumentException("Booking id cannot be null");
        }
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

    public Integer getRating() {
        return rating;
    }

    public void setRating(Integer rating) {
        if (rating == null || rating < 1 || rating > 5) {
            throw new IllegalArgumentException("Rating must be between 1 and 5");
        }
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = (comment == null ? null : comment.trim());
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    // Transient field for display
    private String customerName;

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }
}
