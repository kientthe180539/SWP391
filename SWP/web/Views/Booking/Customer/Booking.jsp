<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Booking Confirmation - Sao Mai Hotel</title>
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
                    <form id="bookingForm">
                        <!-- CUSTOMER INFORMATION -->
                        <h2>Customer Information</h2>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="firstName">First Name <span style="color: red;">*</span></label>
                                <input type="text" id="firstName" name="firstName" placeholder="Enter your first name" required>
                            </div>
                            <div class="form-group">
                                <label for="lastName">Last Name <span style="color: red;">*</span></label>
                                <input type="text" id="lastName" name="lastName" placeholder="Enter your last name" required>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="email">Email <span style="color: red;">*</span></label>
                                <input type="email" id="email" name="email" placeholder="example@email.com" required>
                            </div>
                            <div class="form-group">
                                <label for="phone">Phone <span style="color: red;">*</span></label>
                                <input type="tel" id="phone" name="phone" placeholder="0123456789" required>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="country">Country</label>
                            <input type="text" id="country" name="country" placeholder="Enter your country">
                        </div>

                        <!-- PAYMENT METHOD -->
                        <h2 style="margin-top: 30px;">Payment Method</h2>

                        <label class="payment-option">
                            <input type="radio" name="payment" value="pay_at_hotel" checked>
                            🏨 Pay at the counter upon check-out
                        </label>

                        <!-- ADDITIONAL NOTES -->
                        <h2 style="margin-top: 30px;">Additional Notes</h2>
                        <div class="form-group">
                            <label for="notes">Special Requests</label>
                            <textarea id="notes" name="notes" placeholder="Enter any requests or additional notes..." rows="4"></textarea>
                        </div>

                        <!-- AGREEMENT CHECKBOX -->
                        <div class="form-group" style="margin-top: 20px;">
                            <label style="display: flex; align-items: center; cursor: pointer;">
                                <input type="checkbox" id="agree" name="agree" required style="width: auto; margin-right: 10px;">
                                <span>I agree to the hotel's terms and conditions</span>
                            </label>
                        </div>

                        <!-- BUTTONS -->
                        <div class="button-group">
                            <button type="button" class="btn-back" onclick="history.back()">← Go Back</button>
                            <button type="submit" class="btn-confirm">✓ Confirm Booking</button>
                        </div>
                    </form>
                </div>

                <!-- SUMMARY SECTION -->
                <div class="summary-section">
                    <div class="summary-title">📋 Booking Summary</div>

                    <div class="room-info">
                        <div class="room-name">Premium Suite Room</div>
                        <div class="room-info-item">
                            <span>Room Code:</span>
                            <strong>#PR-305</strong>
                        </div>
                        <div class="room-info-item">
                            <span>Room Type:</span>
                            <strong>Suite</strong>
                        </div>
                        <div class="room-info-item">
                            <span>Capacity:</span>
                            <strong>2 Guests</strong>
                        </div>
                    </div>

                    <div class="room-info">
                        <div style="font-weight: bold; color: #1a5f7a; margin-bottom: 10px;">📅 Schedule</div>
                        <div class="room-info-item">
                            <span>Check-in:</span>
                            <strong>15/03/2025</strong>
                        </div>
                        <div class="room-info-item">
                            <span>Check-out:</span>
                            <strong>17/03/2025</strong>
                        </div>
                        <div class="room-info-item">
                            <span>Nights:</span>
                            <strong>2 Nights</strong>
                        </div>
                    </div>

                    <div class="price-summary">
                        <div class="price-item">
                            <span>Price/Night:</span>
                            <span>2,500,000 VND</span>
                        </div>
                        <div class="price-item">
                            <span>2 Nights:</span>
                            <span>5,000,000 VND</span>
                        </div>
                        <div class="price-item">
                            <span>Service Fee (10%):</span>
                            <span>500,000 VND</span>
                        </div>
                        <div class="price-item">
                            <span>VAT Tax (8%):</span>
                            <span>440,000 VND</span>
                        </div>
                        <div class="price-item total">
                            <span>Total:</span>
                            <span>5,940,000 VND</span>
                        </div>
                    </div>

                    <div style="background-color: #f0f8ff; padding: 12px; border-radius: 5px; font-size: 13px; color: #1a5f7a;">
                        <strong>⚠️ Note:</strong> This price does not include additional services. Please review your details before confirming.
                    </div>
                </div>
            </div>
        </div>

        <!-- FOOTER -->
        <%@ include file="../../Components/Footer.jsp" %>

        <script>
            document.getElementById('bookingForm').addEventListener('submit', function (e) {
                e.preventDefault();
                alert('✓ Booking successful! We will send a confirmation to your email.');
            });
        </script>

    </body>
</html>
