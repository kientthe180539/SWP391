<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Room Details - Hotel Manager</title>
            <link rel="stylesheet" href="CSS/Authen/login.css" />
            <link rel="stylesheet" href="CSS/Pages/room-detail.css" />
        </head>

        <body>
            <%@ include file="./../Components/Header.jsp" %>

                <div class="room-detail-container">
                    <div class="breadcrumb">
                        <a href="home">Home</a>
                        <span>/</span>
                        <a href="rooms">Room List</a>
                        <span>/</span>
                        <span class="current">${roomType.typeName} - ${room.roomNumber}</span>
                    </div>

                    <div class="detail-content">
                        <!-- Image Gallery -->
                        <div class="image-gallery">
                            <div class="main-image">
                                <img id="mainImage" src="<c:out value='${room.imageUrl != null ? room.imageUrl : "
                                    /placeholder.svg?height=500&width=800"}' />" alt="Phòng">
                            </div>
                            <div class="thumbnail-gallery">
                                <!-- Có thể add nhiều hình nếu room.imageUrl là danh sách -->
                                <img src="<c:out value='${room.imageUrl != null ? room.imageUrl : "
                                    /placeholder.svg?height=100&width=100"}' />" alt="Hình 1" class="thumbnail active"
                                onclick="changeImage(this)">
                            </div>
                        </div>

                        <!-- Room Info Section -->
                        <div class="info-section">
                            <div class="room-header">
                                <div class="rating">
                                    <span class="stars">⭐⭐⭐⭐⭐</span>
                                    <span class="rating-text">(125 reviews)</span>
                                </div>
                            </div>

                            <!-- Price & Booking -->
                            <div class="price-booking">
                                <div class="price-info">
                                    <h1>${roomType.typeName} - ${room.roomNumber}</h1>
                                </div>

                                <!-- Room Details -->
                                <div class="details-grid">
                                    <div class="detail-item">
                                        <span class="price-label">Price per night</span>
                                        <span class="price">
                                            <fmt:formatNumber value="${roomType.basePrice}" type="number"
                                                groupingUsed="true" maxFractionDigits="0" />₫
                                        </span>
                                        <span class="per-night">/Night</span>
                                    </div>
                                    <a href="booking?roomId=${room.roomId}" class="btn btn-primary btn-lg">🛏️ Book
                                        Now</a>
                                </div>
                            </div>

                            <!-- Description -->
                            <div class="description">
                                <h3>Room Description</h3>
                                <p>
                                    <c:out
                                        value='${room.description != null ? room.description : roomType.description}' />
                                </p>
                            </div>

                            <!-- Amenities -->
                            <div class="amenities-section">
                                <h3>Room Amenities</h3>
                                <div class="amenities-list">
                                    <!-- Tùy chỉnh thêm theo cơ sở dữ liệu hoặc cứng tạm thời -->
                                    <div class="amenity-item">
                                        <span class="amenity-icon">🛏️</span>
                                        <span class="detail-label">Room type</span>
                                        <span class="detail-value">${roomType.typeName}</span>
                                    </div>
                                    <div class="detail-item">
                                        <span class="detail-label">Occupancy</span>
                                        <span class="detail-value">${roomType.maxOccupancy} People</span>
                                    </div>
                                    <div class="detail-item">
                                        <span class="detail-label">Floor</span>
                                        <span class="detail-value">${room.floor}</span>
                                    </div>
                                    <div class="detail-item">
                                        <span class="detail-label">Status</span>
                                        <span class="detail-value">
                                            <c:out value='${room.status}' />
                                        </span>
                                    </div>
                                    <div class="amenity-item">
                                        <span class="amenity-icon">🌡️</span>
                                        <span class="amenity-name">Air Conditioning</span>
                                    </div>
                                    <div class="amenity-item">
                                        <span class="amenity-icon">📺</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Feedback Section -->
                        <div class="feedback-section" style="margin-top: 30px;">
                            <h3>Guest Reviews</h3>
                            <c:choose>
                                <c:when test="${not empty feedbacks}">
                                    <div class="feedback-list">
                                        <c:forEach var="fb" items="${feedbacks}">
                                            <div class="feedback-item"
                                                style="border-bottom: 1px solid #eee; padding: 15px 0;">
                                                <div class="fb-header"
                                                    style="display: flex; justify-content: space-between; margin-bottom: 5px;">
                                                    <strong>${fb.customerName}</strong>
                                                    <span class="stars" style="color: #f1c40f;">
                                                        <c:forEach begin="1" end="${fb.rating}">★</c:forEach>
                                                        <c:forEach begin="${fb.rating + 1}" end="5">☆</c:forEach>
                                                    </span>
                                                </div>
                                                <div class="fb-date"
                                                    style="font-size: 0.85em; color: #777; margin-bottom: 10px;">
                                                    ${fb.createdAt}
                                                </div>
                                                <div class="fb-comment">
                                                    ${fb.comment}
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>

                                    <!-- Pagination -->
                                    <div class="pagination" style="margin-top: 20px; display: flex; gap: 5px;">
                                        <c:if test="${feedbackPage > 1}">
                                            <a href="room-detail?id=${room.roomId}&page=${feedbackPage - 1}"
                                                class="btn btn-sm btn-outline-secondary">&laquo; Prev</a>
                                        </c:if>

                                        <c:forEach begin="1" end="${totalFeedbackPage}" var="i">
                                            <a href="room-detail?id=${room.roomId}&page=${i}"
                                                class="btn btn-sm ${i == feedbackPage ? 'btn-primary' : 'btn-outline-secondary'}">
                                                ${i}
                                            </a>
                                        </c:forEach>

                                        <c:if test="${feedbackPage < totalFeedbackPage}">
                                            <a href="room-detail?id=${room.roomId}&page=${feedbackPage + 1}"
                                                class="btn btn-sm btn-outline-secondary">Next &raquo;</a>
                                        </c:if>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <p>No reviews yet for this room.</p>
                                </c:otherwise>
                            </c:choose>
                        </div>

                    </div>
                </div>
                </div>
                </div>

                <%@ include file="./../Components/Footer.jsp" %>
                    <%@ include file="./../public/notify.jsp" %>

                        <script>
                            function changeImage(thumbnail) {
                                const mainImage = document.getElementById('mainImage');
                                mainImage.src = thumbnail.src;
                                document.querySelectorAll('.thumbnail').forEach(t => t.classList.remove('active'));
                                thumbnail.classList.add('active');
                            }
                        </script>
        </body>

        </html>