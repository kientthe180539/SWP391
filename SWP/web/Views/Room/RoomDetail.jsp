<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
                        <img id="mainImage" src="<c:out value='${room.imageUrl != null ? room.imageUrl : "/placeholder.svg?height=500&width=800"}'/>" alt="Phòng">
                    </div>
                    <div class="thumbnail-gallery">
                        <!-- Có thể add nhiều hình nếu room.imageUrl là danh sách -->
                        <img src="<c:out value='${room.imageUrl != null ? room.imageUrl : "/placeholder.svg?height=100&width=100"}'/>" alt="Hình 1" class="thumbnail active" onclick="changeImage(this)">
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
                                <span class="price"><c:out value='${roomType.basePrice}'/>₫</span>
                                <span class="per-night">/Night</span>
                            </div>
                            <c:choose>
                                <c:when test="${room.status == 'AVAILABLE'}">
                                    <a href="booking?roomId=${room.roomId}" class="btn btn-primary btn-lg">Book room</a>
                                </c:when>
                                <c:otherwise>
                                    <span class="btn btn-secondary btn-lg disabled">Room not available</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Description -->
                    <div class="description">
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
                                <span class="detail-value"><c:out value='${room.status}'/></span>
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
            </div>
        </div>
    </div>

    <%@ include file="./../Components/Footer.jsp" %>
    <%@ include file="./../public/notify.jsp" %>

    <script>
        function changeImage(thumbnail) {
            const mainImage = document.getElementById('mainImage');
            mainImage.src = thumbnail.src;

            <h3>Mô Tả Phòng</h3>
        <p><c:out value='${room.description != null ? room.description : roomType.description}'/></p>
                    document.querySelectorAll('.thumbnail').forEach(t => t.classList.remove('active'));
            thumbnail.classList.add('active');
        }
    </script>
</body>
</html>
