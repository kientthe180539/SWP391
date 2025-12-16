<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!DOCTYPE html>
                <html>

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Room Detail - ${room.roomNumber}</title>
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/receptionist.css">
                    <style>
                        .detail-grid {
                            display: grid;
                            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
                            gap: 20px;
                            margin-top: 20px;
                        }

                        .detail-card {
                            background: white;
                            border-radius: 12px;
                            padding: 20px;
                            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                        }

                        .detail-card h3 {
                            color: #1e3c72;
                            margin-bottom: 15px;
                            font-size: 18px;
                        }

                        .info-row {
                            display: flex;
                            justify-content: space-between;
                            padding: 10px 0;
                            border-bottom: 1px solid #f0f0f0;
                        }

                        .info-row:last-child {
                            border-bottom: none;
                        }

                        .info-label {
                            font-weight: 600;
                            color: #666;
                        }

                        .info-value {
                            color: #333;
                            text-align: right;
                        }

                        .status-update-form {
                            margin-top: 15px;
                            padding: 15px;
                            background: #f8f9fa;
                            border-radius: 8px;
                        }

                        .action-buttons {
                            display: flex;
                            gap: 10px;
                            margin-top: 20px;
                        }

                        .back-button {
                            background: #6c757d;
                            padding: 10px 20px;
                            color: white;
                            text-decoration: none;
                            border-radius: 8px;
                            display: inline-block;
                        }

                        .back-button:hover {
                            background: #5a6268;
                        }
                    </style>
                </head>

                <body>
                    <header>
                        <div class="logo">🏨 Hotel Management</div>
                        <div class="header-right">
                            <div class="nav-links">
                                <a href="${pageContext.request.contextPath}/receptionist/dashboard">Dashboard</a>
                                <a href="${pageContext.request.contextPath}/reservation_approval">Approvals</a>
                                <a href="${pageContext.request.contextPath}/receptionist/reservations">Reservations</a>
                                <a href="${pageContext.request.contextPath}/receptionist/checkinout">Check-in/out</a>
                                <a href="${pageContext.request.contextPath}/receptionist/room-status"
                                    class="active">Rooms</a>
                                <a href="${pageContext.request.contextPath}/logout">Logout</a>
                            </div>
                            <div class="staff-profile">
                                <span>${sessionScope.currentUser.fullName}</span>
                                <div class="staff-avatar">${fn:substring(sessionScope.currentUser.fullName, 0, 2)}</div>
                            </div>
                        </div>
                    </header>

                    <div class="container">
                        <a href="${pageContext.request.contextPath}/receptionist/room-status" class="back-button">← Back
                            to Room Board</a>

                        <h1 class="page-title">🚪 Room ${room.roomNumber} Details</h1>

                        <div class="detail-grid">
                            <!-- Room Information -->
                            <div class="detail-card">
                                <h3>🏨 Room Information</h3>
                                <div class="info-row">
                                    <span class="info-label">Room Number</span>
                                    <span class="info-value"><strong>${room.roomNumber}</strong></span>
                                </div>
                                <div class="info-row">
                                    <span class="info-label">Floor</span>
                                    <span class="info-value">Floor ${room.floor}</span>
                                </div>
                                <div class="info-row">
                                    <span class="info-label">Room Type</span>
                                    <span class="info-value">${room.typeName}</span>
                                </div>
                                <div class="info-row">
                                    <span class="info-label">Max Occupancy</span>
                                    <span class="info-value">${room.maxOccupancy} guests</span>
                                </div>
                                <div class="info-row">
                                    <span class="info-label">Base Price</span>
                                    <span class="info-value price">
                                        <fmt:formatNumber value="${room.basePrice}" pattern="#,###" /> VND/night
                                    </span>
                                </div>
                                <div class="info-row">
                                    <span class="info-label">Current Status</span>
                                    <span class="info-value">
                                        <span class="badge badge-${fn:toLowerCase(room.status)}">${room.status}</span>
                                    </span>
                                </div>
                            </div>

                            <!-- Current Occupant (if checked in) -->
                            <c:if test="${not empty room.bookingId}">
                                <div class="detail-card">
                                    <h3>👤 Current Occupant</h3>
                                    <div class="info-row">
                                        <span class="info-label">Guest Name</span>
                                        <span class="info-value"><strong>${room.customerName}</strong></span>
                                    </div>
                                    <div class="info-row">
                                        <span class="info-label">Phone</span>
                                        <span class="info-value">${room.customerPhone}</span>
                                    </div>
                                    <div class="info-row">
                                        <span class="info-label">Check-in Date</span>
                                        <span class="info-value">${room.checkinDate}</span>
                                    </div>
                                    <div class="info-row">
                                        <span class="info-label">Check-out Date</span>
                                        <span class="info-value">${room.checkoutDate}</span>
                                    </div>
                                    <div class="info-row">
                                        <span class="info-label">Number of Guests</span>
                                        <span class="info-value">${room.numGuests}</span>
                                    </div>
                                    <div style="margin-top: 15px;">
                                        <a href="${pageContext.request.contextPath}/receptionist/reservation-detail?id=${room.bookingId}"
                                            class="btn btn-primary" style="width: 100%; text-align: center;">
                                            View Booking Details
                                        </a>
                                    </div>
                                </div>
                            </c:if>

                            <!-- Room Status Update -->
                            <div class="detail-card">
                                <h3>⚙️ Update Room Status</h3>
                                <form method="post"
                                    action="${pageContext.request.contextPath}/receptionist/room-detail">
                                    <input type="hidden" name="action" value="updateStatus">
                                    <input type="hidden" name="roomId" value="${room.roomId}">

                                    <div style="margin-bottom: 15px;">
                                        <label style="display: block; margin-bottom: 5px; font-weight: 600;">New
                                            Status</label>
                                        <select name="status" required
                                            style="width: 100%; padding: 10px; border: 2px solid #e0e0e0; border-radius: 8px;">
                                            <option value="">-- Select Status --</option>
                                            <option value="AVAILABLE" ${room.status=='AVAILABLE' ? 'selected' : '' }>
                                                Available</option>
                                            <option value="OCCUPIED" ${room.status=='OCCUPIED' ? 'selected' : '' }>
                                                Occupied</option>
                                            <option value="CLEANING" ${room.status=='CLEANING' ? 'selected' : '' }>
                                                Cleaning</option>
                                            <option value="MAINTENANCE" ${room.status=='MAINTENANCE' ? 'selected' : ''
                                                }>Maintenance</option>
                                            <option value="OUT_OF_SERVICE" ${room.status=='OUT_OF_SERVICE' ? 'selected'
                                                : '' }>Out of Service</option>
                                        </select>
                                    </div>

                                    <button type="submit" class="btn btn-primary" style="width: 100%;">
                                        Update Status
                                    </button>
                                </form>
                            </div>
                        </div>

                        <!-- Room Description -->
                        <c:if test="${not empty room.description}">
                            <div class="section" style="margin-top: 20px;">
                                <h2>📝 Room Description</h2>
                                <p style="line-height: 1.6; color: #666;">${room.description}</p>
                            </div>
                        </c:if>

                        <!-- Booking History -->
                        <div class="section" style="margin-top: 20px;">
                            <h2>📜 Booking History</h2>
                            <c:choose>
                                <c:when test="${empty history}">
                                    <div class="empty-state">
                                        <p>No booking history available for this room</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div style="overflow-x: auto;">
                                        <table>
                                            <thead>
                                                <tr>
                                                    <th>Booking ID</th>
                                                    <th>Guest</th>
                                                    <th>Check-in</th>
                                                    <th>Check-out</th>
                                                    <th>Guests</th>
                                                    <th>Status</th>
                                                    <th>Total Amount</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="booking" items="${history}">
                                                    <tr onclick="window.location.href='${pageContext.request.contextPath}/receptionist/reservation-detail?id=${booking.bookingId}'"
                                                        style="cursor: pointer;">
                                                        <td><strong>#${booking.bookingId}</strong></td>
                                                        <td>
                                                            <strong>${booking.customerName}</strong><br>
                                                            <small style="color: #777;">${booking.customerPhone}</small>
                                                        </td>
                                                        <td>${booking.checkinDate}</td>
                                                        <td>${booking.checkoutDate}</td>
                                                        <td>${booking.numGuests}</td>
                                                        <td>
                                                            <span class="badge badge-${fn:toLowerCase(booking.status)}">
                                                                ${booking.status}
                                                            </span>
                                                        </td>
                                                        <td class="price">
                                                            <fmt:formatNumber value="${booking.totalAmount}"
                                                                pattern="#,###" /> VND
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <footer>
                        <p>&copy; 2025 Hotel Management System. All rights reserved.</p>
                    </footer>
                </body>

                </html>
