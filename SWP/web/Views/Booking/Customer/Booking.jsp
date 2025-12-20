<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Booking Confirmation - Hotel Management</title>
                <link rel="stylesheet" href="CSS/Booking/booking.css">
            </head>

            <body>
                <!-- HEADER -->
                <%@ include file="../../Components/Header.jsp" %>

                    <!-- MAIN CONTENT -->
                    <div class="main-content">
                        <div class="breadcrumb">
                            <a href="home">Home</a>
                            <span>/</span>
                            <a href="rooms">Room List</a>
                            <span>/</span>
                            <a href="room-detail">Room Details</a>
                            <span>/</span>
                            <span class="current">Booking Confirmation</span>
                        </div>
                        <h1 class="page-title">Booking Confirmation</h1>

                        <div class="container-flex">
                            <!-- FORM SECTION -->
                            <div class="form-section">
                                <form id="bookingForm" action="booking" method="POST">
                                    <!-- CUSTOMER INFORMATION -->
                                    <h2>Customer Information</h2>

                                    <div class="form-row">
                                        <div class="form-group">
                                            <label for="fullName">Full Name <span style="color: red;">*</span></label>
                                            <input type="text" id="fullName" name="fullName"
                                                value="${currentUser.fullName}" readonly required>
                                        </div>
                                    </div>

                                    <div class="form-row">
                                        <div class="form-group">
                                            <label for="email">Email <span style="color: red;">*</span></label>
                                            <input type="email" id="email" name="email" value="${currentUser.email}"
                                                readonly required>
                                        </div>
                                        <div class="form-group">
                                            <label for="phone">Phone <span style="color: red;">*</span></label>
                                            <input type="tel" id="phone" name="phone" value="${currentUser.phone}"
                                                readonly required>
                                        </div>
                                    </div>

                                    <!-- BOOKING DETAILS -->
                                    <h2 style="margin-top: 30px;">Booking Details</h2>
                                    <input type="hidden" name="roomId" value="${param.roomId}">

                                    <div class="form-row">
                                        <div class="form-group">
                                            <label for="checkinDate">Check-in Date <span
                                                    style="color: red;">*</span></label>
                                            <input type="date" id="checkinDate" name="checkinDate"
                                                value="${checkinDate}" required>
                                        </div>
                                        <div class="form-group">
                                            <label for="checkoutDate">Check-out Date <span
                                                    style="color: red;">*</span></label>
                                            <input type="date" id="checkoutDate" name="checkoutDate"
                                                value="${checkoutDate}" required>
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label for="numGuests">Number of Guests <span
                                                style="color: red;">*</span></label>
                                        <input type="number" id="numGuests" name="numGuests" min="1"
                                            max="${roomType.maxOccupancy}" placeholder="Max: ${roomType.maxOccupancy}"
                                            value="${numGuests}" required>
                                    </div>

                                    <!-- PAYMENT METHOD -->
                                    <h2 style="margin-top: 30px;">Payment Method</h2>

                                    <label class="payment-option">
                                        <input type="radio" name="payment" value="pay_at_hotel" checked>
                                        🏨 Pay at the counter upon check-out
                                    </label>

                                    <!-- AGREEMENT CHECKBOX -->
                                    <div class="form-group" style="margin-top: 20px;">
                                        <label style="display: flex; align-items: center; cursor: pointer;">
                                            <input type="checkbox" id="agree" name="agree" required
                                                style="width: auto; margin-right: 10px;">
                                            <span>I agree to the hotel's terms and conditions</span>
                                        </label>
                                    </div>

                                    <!-- BUTTONS -->
                                    <div class="button-group">
                                        <button type="button" class="btn-back" onclick="history.back()">← Go
                                            Back</button>
                                        <button type="submit" class="btn-confirm">✓ Confirm Booking</button>
                                    </div>
                                </form>
                            </div>

                            <!-- SUMMARY SECTION -->
                            <div class="summary-section">
                                <div class="summary-title">📋 Booking Summary</div>

                                <div class="room-info">
                                    <div class="room-name">${roomType.typeName}</div>
                                    <div class="room-info-item">
                                        <span>Room Number:</span>
                                        <strong>${room.roomNumber}</strong>
                                    </div>
                                    <div class="room-info-item">
                                        <span>Room Type:</span>
                                        <strong>${roomType.typeName}</strong>
                                    </div>
                                    <div class="room-info-item">
                                        <span>Capacity:</span>
                                        <strong>${roomType.maxOccupancy} Guests</strong>
                                    </div>
                                </div>

                                <div class="room-info">
                                    <div style="font-weight: bold; color: #1a5f7a; margin-bottom: 10px;">📅 Schedule
                                    </div>
                                    <div class="room-info-item">
                                        <span>Check-in:</span>
                                        <strong id="displayCheckin">-</strong>
                                    </div>
                                    <div class="room-info-item">
                                        <span>Check-out:</span>
                                        <strong id="displayCheckout">-</strong>
                                    </div>
                                    <div class="room-info-item">
                                        <span>Nights:</span>
                                        <strong id="displayNights">-</strong>
                                    </div>
                                </div>

                                <div class="price-summary">
                                    <div class="price-item">
                                        <span>Price/Night:</span>
                                        <span>
                                            <fmt:formatNumber value="${roomType.basePrice}" type="number"
                                                groupingUsed="true" maxFractionDigits="0" /> VND
                                        </span>
                                    </div>
                                    <div class="price-item total-price"
                                        style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 15px; border-radius: 10px; margin-top: 10px;">
                                        <span style="font-size: 18px; color: white;">💰 Total:</span>
                                        <span id="displayTotal"
                                            style="font-size: 24px; font-weight: 700; color: white;">Select dates</span>
                                    </div>
                                </div>

                                <div
                                    style="background-color: #e8f5e9; padding: 12px; border-radius: 5px; font-size: 13px; color: #2e7d32; margin-top: 15px;">
                                    <strong>💳 Payment:</strong> After booking, you can pay online via Luxe Wallet with
                                    instant confirmation!
                                </div>

                                <div
                                    style="background-color: #f0f8ff; padding: 12px; border-radius: 5px; font-size: 13px; color: #1a5f7a; margin-top: 10px;">
                                    <strong>⏰ Note:</strong> Select your check-in and check-out dates to see the total
                                    price.
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- FOOTER -->
                    <%@ include file="../../Components/Footer.jsp" %>
                        <%@ include file="../../public/notify.jsp" %>

                            <script>
                                // Set minimum date to today for check-in
                                const today = new Date().toISOString().split('T')[0];
                                document.getElementById('checkinDate').setAttribute('min', today);

                                const bookingBasePrice = ${ roomType.basePrice };

                                // Update check-out minimum when check-in changes
                                document.getElementById('checkinDate').addEventListener('change', function () {
                                    const checkinDate = new Date(this.value);
                                    checkinDate.setDate(checkinDate.getDate() + 1);
                                    const minCheckout = checkinDate.toISOString().split('T')[0];
                                    document.getElementById('checkoutDate').setAttribute('min', minCheckout);
                                    updateSummary();
                                });

                                document.getElementById('checkoutDate').addEventListener('change', updateSummary);

                                function updateSummary() {
                                    const checkinInput = document.getElementById('checkinDate').value;
                                    const checkoutInput = document.getElementById('checkoutDate').value;

                                    if (checkinInput && checkoutInput) {
                                        const checkin = new Date(checkinInput);
                                        const checkout = new Date(checkoutInput);
                                        const nights = Math.ceil((checkout - checkin) / (1000 * 60 * 60 * 24));

                                        if (nights > 0) {
                                            document.getElementById('displayCheckin').textContent = checkin.toLocaleDateString('vi-VN');
                                            document.getElementById('displayCheckout').textContent = checkout.toLocaleDateString('vi-VN');
                                            document.getElementById('displayNights').textContent = nights + ' Night' + (nights > 1 ? 's' : '');

                                            const total = bookingBasePrice * nights;
                                            document.getElementById('displayTotal').textContent = total.toLocaleString('vi-VN') + ' VND';
                                        }
                                    }
                                }

                                // Run on load in case of retained values
                                updateSummary();
                            </script>

            </body>

            </html>