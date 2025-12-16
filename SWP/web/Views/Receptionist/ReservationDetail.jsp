<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!DOCTYPE html>
                <html>

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Reservation Detail - #${booking.bookingId}</title>
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

                        .action-buttons {
                            display: flex;
                            gap: 10px;
                            margin-top: 20px;
                            flex-wrap: wrap;
                        }
                    </style>
                </head>

                <body>
                    <header>
                        <div class="logo">🏨 Khách Sạn Royal - Quản Lí</div>
                        <div class="header-right">
                            <div class="nav-links">
                                <a href="${pageContext.request.contextPath}/receptionist/dashboard"
                                    class="active">Dashboard</a>
                                <a href="${pageContext.request.contextPath}/reservation_approval">Duyệt Phòng</a>
                                <a href="${pageContext.request.contextPath}/receptionist/reservations">Danh Sách</a>
                                <a href="${pageContext.request.contextPath}/receptionist/checkinout">Check-in/out</a>
                                <a href="${pageContext.request.contextPath}/receptionist/direct-booking">Walk-in</a>
                                <a href="${pageContext.request.contextPath}/receptionist/room-status">Phòng</a>
                                <a href="${pageContext.request.contextPath}/receptionist/profile">Profile</a>
                                <a href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
                            </div>
                            <div class="staff-profile">
                                <span>${sessionScope.currentUser.fullName}</span>
                                <div class="staff-avatar">${fn:substring(sessionScope.currentUser.fullName, 0, 2)}</div>
                            </div>
                        </div>
                    </header>

                    <div class="container">
                        <a href="${pageContext.request.contextPath}/receptionist/reservations" class="back-button">←
                            Back to Reservations</a>

                        <h1 class="page-title">📋 Reservation #${booking.bookingId}</h1>

                        <div class="detail-grid">
                            <!-- Booking Information -->
                            <div class="detail-card">
                                <h3>📅 Booking Information</h3>
                                <div class="info-row">
                                    <span class="info-label">Booking ID</span>
                                    <span class="info-value"><strong>#${booking.bookingId}</strong></span>
                                </div>
                                <div class="info-row">
                                    <span class="info-label">Status</span>
                                    <span class="info-value">
                                        <span
                                            class="badge badge-${fn:toLowerCase(booking.status)}">${booking.status}</span>
                                    </span>
                                </div>
                                <div class="info-row">
                                    <span class="info-label">Check-in Date</span>
                                    <span class="info-value"><strong>${booking.checkinDate}</strong></span>
                                </div>
                                <div class="info-row">
                                    <span class="info-label">Check-out Date</span>
                                    <span class="info-value"><strong>${booking.checkoutDate}</strong></span>
                                </div>
                                <div class="info-row">
                                    <span class="info-label">Number of Guests</span>
                                    <span class="info-value">${booking.numGuests}</span>
                                </div>
                                <div class="info-row">
                                    <span class="info-label">Created At</span>
                                    <span class="info-value">
                                        <fmt:formatDate value="${booking.createdAt}" pattern="yyyy-MM-dd HH:mm" />
                                    </span>
                                </div>
                                <c:if test="${not empty booking.updatedAt}">
                                    <div class="info-row">
                                        <span class="info-label">Last Updated</span>
                                        <span class="info-value">
                                            <fmt:formatDate value="${booking.updatedAt}" pattern="yyyy-MM-dd HH:mm" />
                                        </span>
                                    </div>
                                </c:if>
                            </div>

                            <!-- Customer Information -->
                            <div class="detail-card">
                                <h3>👤 Customer Information</h3>
                                <div class="info-row">
                                    <span class="info-label">Full Name</span>
                                    <span class="info-value"><strong>${booking.customerName}</strong></span>
                                </div>
                                <div class="info-row">
                                    <span class="info-label">Email</span>
                                    <span class="info-value">${booking.customerEmail}</span>
                                </div>
                                <div class="info-row">
                                    <span class="info-label">Phone</span>
                                    <span class="info-value">${booking.customerPhone}</span>
                                </div>
                            </div>

                            <!-- Room Information -->
                            <div class="detail-card">
                                <h3>🏨 Room Information</h3>
                                <div class="info-row">
                                    <span class="info-label">Room Number</span>
                                    <span class="info-value">
                                        <a href="${pageContext.request.contextPath}/receptionist/room-detail?id=${booking.roomId}"
                                            style="color: #1e3c72; font-weight: bold;">
                                            ${booking.roomNumber}
                                        </a>
                                    </span>
                                </div>
                                <div class="info-row">
                                    <span class="info-label">Floor</span>
                                    <span class="info-value">Floor ${booking.floor}</span>
                                </div>
                                <div class="info-row">
                                    <span class="info-label">Room Type</span>
                                    <span class="info-value">${booking.typeName}</span>
                                </div>
                                <div class="info-row">
                                    <span class="info-label">Max Occupancy</span>
                                    <span class="info-value">${booking.maxOccupancy} guests</span>
                                </div>
                                <div class="info-row">
                                    <span class="info-label">Room Status</span>
                                    <span class="info-value">
                                        <span
                                            class="badge badge-${fn:toLowerCase(booking.roomStatus)}">${booking.roomStatus}</span>
                                    </span>
                                </div>
                                <div class="info-row">
                                    <span class="info-label">Base Price</span>
                                    <span class="info-value price">
                                        <fmt:formatNumber value="${booking.basePrice}" pattern="#,###" /> đ/night
                                    </span>
                                </div>
                            </div>

                            <!-- Payment Information -->
                            <div class="detail-card">
                                <h3>💰 Payment Information</h3>
                                <div class="info-row">
                                    <span class="info-label">Total Amount</span>
                                    <span class="info-value price price-large">
                                        <fmt:formatNumber value="${booking.totalAmount}" pattern="#,###" /> đ
                                    </span>
                                </div>
                            </div>
                        </div>

                        <!-- Room Description -->
                        <c:if test="${not empty booking.description}">
                            <div class="section" style="margin-top: 20px;">
                                <h2>📝 Room Description</h2>
                                <p style="line-height: 1.6; color: #666;">${booking.description}</p>
                            </div>
                        </c:if>

                        <!-- Action Buttons -->
                        <div class="section" style="margin-top: 20px;">
                            <h2>⚡ Quick Actions</h2>
                            <div class="action-buttons">
                                <c:if test="${booking.status == 'CONFIRMED'}">
                                    <a href="${pageContext.request.contextPath}/receptionist/checkinout"
                                        class="btn btn-primary">
                                        🔑 Go to Check-in/Check-out
                                    </a>
                                </c:if>
                                <c:if test="${booking.status == 'CHECKED_IN'}">
                                    <a href="${pageContext.request.contextPath}/receptionist/checkinout"
                                        class="btn btn-approve">
                                        ✓ Go to Check-out
                                    </a>
                                </c:if>
                                <a href="${pageContext.request.contextPath}/receptionist/room-detail?id=${booking.roomId}"
                                    class="btn btn-primary">
                                    🚪 View Room Details
                                </a>
                            </div>
                        </div>
                    </div>

                    <footer>
                        <p>&copy; 2025 Khách Sạn Royal. Hệ Thống Quản Lí Khách Sạn</p>
                    </footer>
                </body>

                </html>