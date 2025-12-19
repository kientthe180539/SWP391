<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Booking Confirmation - Hotel</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/Booking/booking_confirm.css">
            </head>

            <body>
                <!-- HEADER -->
                <%@ include file="../../Components/Header.jsp" %>

                    <main>
                        <div class="breadcrumb">
                            <a href="${pageContext.request.contextPath}/home">Home</a>
                            <span>/</span>
                            <a href="${pageContext.request.contextPath}/rooms">Rooms</a>
                            <span>/</span>
                            <span class="current">Booking Confirmation</span>
                        </div>

                        <c:if test="${booking != null}">
                            <div class="confirmation-card">
                                <!-- STATUS ICON -->
                                <div
                                    class="status-icon ${booking.status == 'PENDING' ? 'pending' : booking.status == 'CONFIRMED' ? 'confirmed' : 'other'}">
                                    <c:choose>
                                        <c:when test="${booking.status == 'PENDING'}">⏳</c:when>
                                        <c:when test="${booking.status == 'CONFIRMED'}">✓</c:when>
                                        <c:otherwise>📋</c:otherwise>
                                    </c:choose>
                                </div>

                                <h1 class="status-title">
                                    <c:choose>
                                        <c:when test="${booking.status == 'PENDING'}">Your Booking Is Pending</c:when>
                                        <c:when test="${booking.status == 'CONFIRMED'}">Booking Confirmed!</c:when>
                                        <c:otherwise>Booking Created</c:otherwise>
                                    </c:choose>
                                </h1>

                                <p class="status-subtitle">
                                    <c:choose>
                                        <c:when test="${booking.status == 'PENDING'}">We will confirm your booking
                                            within 2–4 hours</c:when>
                                        <c:when test="${booking.status == 'CONFIRMED'}">Your reservation has been
                                            confirmed</c:when>
                                        <c:otherwise>Thank you for your booking</c:otherwise>
                                    </c:choose>
                                </p>

                                <span
                                    class="status-badge badge-${booking.status.toString().toLowerCase()}">${booking.status}</span>

                                <!-- BOOKING DETAILS -->
                                <div class="booking-details">
                                    <div class="detail-row">
                                        <span class="detail-label">Booking ID:</span>
                                        <span class="detail-value">#${booking.bookingId}</span>
                                    </div>
                                    <div class="detail-row">
                                        <span class="detail-label">Guest Name:</span>
                                        <span class="detail-value">${sessionScope.currentUser.fullName}</span>
                                    </div>

                                    <c:if test="${bookingDetails != null && bookingDetails.roomDetails != null}">
                                        <div class="detail-row">
                                            <span class="detail-label">Room:</span>
                                            <span class="detail-value">
                                                ${bookingDetails.roomDetails.typeName} (Room
                                                ${bookingDetails.roomDetails.roomNumber}, Floor
                                                ${bookingDetails.roomDetails.floor})
                                            </span>
                                        </div>
                                    </c:if>

                                    <div class="detail-row">
                                        <span class="detail-label">Check-in Date:</span>
                                        <span class="detail-value">${booking.checkinDate}</span>
                                    </div>
                                    <div class="detail-row">
                                        <span class="detail-label">Check-out Date:</span>
                                        <span class="detail-value">${booking.checkoutDate}</span>
                                    </div>
                                    <div class="detail-row">
                                        <span class="detail-label">Number of Guests:</span>
                                        <span class="detail-value">${booking.numGuests}</span>
                                    </div>
                                    <div class="detail-row">
                                        <span class="detail-label">Total Amount:</span>
                                        <span class="detail-value"
                                            style="color: #ff9800; font-size: 18px; font-weight: 600;">
                                            <fmt:formatNumber value="${booking.totalAmount}" type="currency"
                                                currencySymbol="$" />
                                        </span>
                                    </div>
                                    <div class="detail-row">
                                        <span class="detail-label">Booking Date:</span>
                                        <span class="detail-value">${booking.createdAt}</span>
                                    </div>
                                </div>

                                <!-- ACTION BUTTONS -->
                                <div class="action-buttons">
                                    <a href="${pageContext.request.contextPath}/my_booking" class="btn btn-bookings"
                                        role="button">View My Bookings</a>
                                    <a href="${pageContext.request.contextPath}/rooms" class="btn btn-go-back">Browse
                                        More Rooms</a>
                                </div>
                            </div>
                        </c:if>

                        <c:if test="${booking == null}">
                            <div class="confirmation-card">
                                <div class="status-icon other">❌</div>
                                <h1 class="status-title">No Booking Found</h1>
                                <p class="status-subtitle">We couldn't find any recent booking information</p>

                                <div class="action-buttons">
                                    <a href="${pageContext.request.contextPath}/rooms" class="btn btn-bookings">Browse
                                        Rooms</a>
                                    <a href="${pageContext.request.contextPath}/home" class="btn btn-go-back">Go
                                        Home</a>
                                </div>
                            </div>
                        </c:if>
                    </main>

                    <!-- FOOTER -->
                    <%@ include file="../../Components/Footer.jsp" %>
            </body>

            </html>