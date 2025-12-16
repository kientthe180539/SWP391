<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Booking Confirmation - Hotel</title>
        <link rel="stylesheet" href="CSS/Booking/booking_confirm.css">
    </head>
    <body>
        <!-- HEADER -->
        <%@ include file="../../Components/Header.jsp" %>

        <main>
            <div class="breadcrumb">
                <a href="home">Home</a>
                <span>/</span>
                <a href="rooms">Room List</a>
                <span>/</span>
                <a href="room-detail">Room Details</a>
                <span>/</span>
                <a href="room-detail">Booking Confirmation</a>
                <span>/</span>
                <span class="current">Pending Confirmation</span>
            </div>

            <div class="confirmation-card">
                <!-- PENDING STATUS -->
                <div class="status-icon pending">⏳</div>
                <h1 class="status-title">Your Booking Is Pending</h1>
                <p class="status-subtitle">We will confirm your booking within 2–4 hours</p>
                <span class="status-badge badge-pending">PENDING</span>

                <!-- BOOKING DETAILS -->
                <div class="booking-details">
                    <div class="detail-row">
                        <span class="detail-label">Booking Code:</span>
                        <span class="detail-value">BK-2024-12345</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">Guest Name:</span>
                        <span class="detail-value">Nguyen Van A</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">Room:</span>
                        <span class="detail-value">Premium Double Room (Room 302)</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">Check-in Date:</span>
                        <span class="detail-value">05/01/2025</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">Check-out Date:</span>
                        <span class="detail-value">08/01/2025 (3 Nights)</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">Total Amount:</span>
                        <span class="detail-value" style="color: #ff9800; font-size: 18px;">7,500,000 VND</span>
                    </div>
                </div>

                <!-- ACTION BUTTONS -->
                <div class="action-buttons">
                    <a class="btn btn-resend">Resend Email</a>
                    <a href="my-bookings.jsp" class="btn btn-bookings" role="button">My Bookings</a>
                    <a class="btn btn-go-back" onclick="history.back()">Go Back</a>
                </div>
            </div>
        </main>

        <!-- FOOTER -->
        <%@ include file="../../Components/Footer.jsp" %>
    </body>
</html>
