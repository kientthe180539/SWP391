<%@ page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Direct Booking | HMS</title>
                    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                        rel="stylesheet">
                    <link rel="stylesheet"
                        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
                    <link rel="stylesheet" href="<c:url value='/CSS/housekeeping.css'/>">
                    <link rel="stylesheet"
                        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
                    <style>
                        .room-select-card {
                            cursor: pointer;
                            transition: all 0.3s;
                            border: 2px solid transparent;
                        }

                        .room-select-card:hover {
                            transform: translateY(-3px);
                            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
                        }

                        .room-select-card.selected {
                            border-color: var(--bs-primary);
                            background-color: rgba(13, 110, 253, 0.05);
                        }

                        .room-select-card input[type="radio"] {
                            display: none;
                        }
                    </style>
                </head>

                <body>
                    <div class="layout-wrapper">
                        <jsp:include page="../Shared/Sidebar.jsp" />

                        <div class="main-content">
                            <header class="top-header">
                                <div class="d-flex align-items-center">
                                    <button class="btn btn-link text-dark d-md-none me-2" id="sidebarToggle">
                                        <i class="bi bi-list fs-4"></i>
                                    </button>
                                    <h5 class="header-title mb-0">Direct Booking</h5>
                                </div>
                                <div class="user-profile">
                                    <div class="text-end d-none d-sm-block">
                                        <div class="fw-bold text-dark">${sessionScope.currentUser.fullName}</div>
                                        <div class="small text-muted">Receptionist</div>
                                    </div>
                                    <div class="user-avatar">
                                        ${fn:substring(sessionScope.currentUser.fullName, 0, 1)}
                                    </div>
                                </div>
                            </header>

                            <div class="container-fluid py-4 px-4">
                                <div class="d-flex justify-content-between align-items-center mb-4">
                                    <div>
                                        <h2 class="mb-1">📝 Direct Booking (Walk-in)</h2>
                                        <p class="text-muted mb-0">Create a new booking for walk-in customers.</p>
                                    </div>
                                </div>

                                <!-- Date Selection -->
                                <div class="card mb-4">
                                    <div class="card-header bg-white py-3">
                                        <h5 class="mb-0"><i class="bi bi-calendar3 me-2"></i>Select Dates</h5>
                                    </div>
                                    <div class="card-body">
                                        <form method="get"
                                            action="${pageContext.request.contextPath}/receptionist/direct-booking">
                                            <div class="row g-3 align-items-end">
                                                <div class="col-md-4">
                                                    <label class="form-label">Check-in Date</label>
                                                    <input type="date" name="checkinDate" class="form-control"
                                                        value="${checkinDate}" id="checkinInput" required>
                                                </div>
                                                <div class="col-md-4">
                                                    <label class="form-label">Check-out Date</label>
                                                    <input type="date" name="checkoutDate" class="form-control"
                                                        value="${checkoutDate}" id="checkoutInput" required>
                                                </div>
                                                <div class="col-md-4">
                                                    <button type="submit" class="btn btn-primary w-100">
                                                        <i class="bi bi-search me-1"></i>Find Available Rooms
                                                    </button>
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                </div>

                                <!-- Booking Form -->
                                <form method="post"
                                    action="${pageContext.request.contextPath}/receptionist/direct-booking"
                                    id="bookingForm">
                                    <input type="hidden" name="checkinDate" value="${checkinDate}">
                                    <input type="hidden" name="checkoutDate" value="${checkoutDate}">

                                    <div class="row">
                                        <!-- Available Rooms -->
                                        <div class="col-lg-8">
                                            <div class="card mb-4">
                                                <div
                                                    class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                                                    <h5 class="mb-0"><i class="bi bi-door-open me-2"></i>Available Rooms
                                                    </h5>
                                                    <span class="badge bg-success">${fn:length(availableRooms)}
                                                        rooms</span>
                                                </div>
                                                <div class="card-body">
                                                    <c:choose>
                                                        <c:when test="${empty availableRooms}">
                                                            <div class="text-center py-5 text-muted">
                                                                <i class="bi bi-building fs-1"></i>
                                                                <p class="mt-2">No rooms available for the selected
                                                                    dates</p>
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="row g-3">
                                                                <c:forEach var="room" items="${availableRooms}"
                                                                    varStatus="status">
                                                                    <div class="col-md-6">
                                                                        <label
                                                                            class="card room-select-card h-100 ${status.first ? 'selected' : ''}">
                                                                            <input type="radio" name="roomId"
                                                                                value="${room.roomId}" ${status.first
                                                                                ? 'checked' : '' } required
                                                                                data-price="${room.basePrice}"
                                                                                data-max="${room.maxOccupancy}">
                                                                            <div class="card-body">
                                                                                <div
                                                                                    class="d-flex justify-content-between align-items-start mb-2">
                                                                                    <div>
                                                                                        <h5 class="mb-0">Room
                                                                                            ${room.roomNumber}</h5>
                                                                                        <small class="text-muted">Floor
                                                                                            ${room.floor}</small>
                                                                                    </div>
                                                                                    <span
                                                                                        class="badge bg-success">Available</span>
                                                                                </div>
                                                                                <div class="mb-2">
                                                                                    <span
                                                                                        class="fw-semibold">${room.typeName}</span>
                                                                                </div>
                                                                                <div
                                                                                    class="d-flex justify-content-between small text-muted">
                                                                                    <span><i
                                                                                            class="bi bi-people me-1"></i>Max:
                                                                                        ${room.maxOccupancy}</span>
                                                                                    <span class="text-success fw-bold">
                                                                                        <fmt:formatNumber
                                                                                            value="${room.basePrice}"
                                                                                            pattern="#,###" /> VND/night
                                                                                    </span>
                                                                                </div>
                                                                            </div>
                                                                        </label>
                                                                    </div>
                                                                </c:forEach>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Customer Info & Summary -->
                                        <div class="col-lg-4">
                                            <!-- Customer Information -->
                                            <div class="card mb-4">
                                                <div class="card-header bg-white py-3">
                                                    <h5 class="mb-0"><i class="bi bi-person me-2"></i>Customer
                                                        Information</h5>
                                                </div>
                                                <div class="card-body">
                                                    <div class="mb-3">
                                                        <label class="form-label">Full Name *</label>
                                                        <input type="text" name="customerName" class="form-control"
                                                            placeholder="Enter customer name" required>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label">Email *</label>
                                                        <input type="email" name="customerEmail" class="form-control"
                                                            placeholder="Enter email address" required>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label">Phone *</label>
                                                        <input type="tel" name="customerPhone" class="form-control"
                                                            placeholder="Enter phone number" required>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label">Number of Guests *</label>
                                                        <input type="number" name="numGuests" id="numGuests"
                                                            class="form-control" min="1" max="10" value="1" required>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Booking Summary -->
                                            <div class="card mb-4 border-primary">
                                                <div class="card-header bg-primary text-white py-3">
                                                    <h5 class="mb-0"><i class="bi bi-receipt me-2"></i>Booking Summary
                                                    </h5>
                                                </div>
                                                <div class="card-body">
                                                    <div class="d-flex justify-content-between mb-2">
                                                        <span class="text-muted">Check-in:</span>
                                                        <strong>${checkinDate}</strong>
                                                    </div>
                                                    <div class="d-flex justify-content-between mb-2">
                                                        <span class="text-muted">Check-out:</span>
                                                        <strong>${checkoutDate}</strong>
                                                    </div>
                                                    <div class="d-flex justify-content-between mb-3">
                                                        <span class="text-muted">Nights:</span>
                                                        <strong id="nightsDisplay">-</strong>
                                                    </div>
                                                    <hr>
                                                    <div class="d-flex justify-content-between mb-3">
                                                        <span class="text-muted">Price/Night:</span>
                                                        <strong id="priceDisplay">-</strong>
                                                    </div>
                                                    <div
                                                        class="d-flex justify-content-between bg-success bg-opacity-10 p-3 rounded">
                                                        <span class="fw-bold">Total:</span>
                                                        <span class="fw-bold text-success fs-5"
                                                            id="totalDisplay">-</span>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Submit Button -->
                                            <button type="submit" class="btn btn-success w-100 py-3" ${empty
                                                availableRooms ? 'disabled' : '' }>
                                                <i class="bi bi-check-circle me-2"></i>Create Booking
                                            </button>
                                        </div>
                                    </div>
                                </form>
                            </div>

                            <footer class="main-footer">
                                <p class="mb-0">&copy; 2025 Hotel Management System. All rights reserved.</p>
                            </footer>
                        </div>
                    </div>

                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
                    <script>
                        document.getElementById('sidebarToggle')?.addEventListener('click', function () {
                            document.querySelector('.sidebar').classList.toggle('show');
                        });

                        // Room selection highlight
                        document.querySelectorAll('.room-select-card input[type="radio"]').forEach(radio => {
                            radio.addEventListener('change', function () {
                                document.querySelectorAll('.room-select-card').forEach(card => {
                                    card.classList.remove('selected');
                                });
                                this.closest('.room-select-card').classList.add('selected');
                                updateSummary();
                            });
                        });

                        // Calculate nights and total
                        function updateSummary() {
                            const checkin = new Date('${checkinDate}');
                            const checkout = new Date('${checkoutDate}');
                            const nights = Math.ceil((checkout - checkin) / (1000 * 60 * 60 * 24));

                            document.getElementById('nightsDisplay').textContent = nights + ' night' + (nights > 1 ? 's' : '');

                            const selectedRoom = document.querySelector('input[name="roomId"]:checked');
                            if (selectedRoom) {
                                const price = parseFloat(selectedRoom.dataset.price);
                                const total = price * nights;
                                document.getElementById('priceDisplay').textContent = price.toLocaleString('vi-VN') + ' VND';
                                document.getElementById('totalDisplay').textContent = total.toLocaleString('vi-VN') + ' VND';

                                // Update max guests
                                document.getElementById('numGuests').max = selectedRoom.dataset.max;
                            }
                        }

                        // Set minimum date for check-in
                        const today = new Date().toISOString().split('T')[0];
                        document.getElementById('checkinInput').min = today;

                        document.getElementById('checkinInput').addEventListener('change', function () {
                            const checkin = new Date(this.value);
                            checkin.setDate(checkin.getDate() + 1);
                            document.getElementById('checkoutInput').min = checkin.toISOString().split('T')[0];
                        });

                        // Initial calculation
                        updateSummary();
                    </script>
                    <%@ include file="../public/notify.jsp" %>
                </body>

                </html>