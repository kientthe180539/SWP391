<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Dashboard Lễ Tân - Quản Lí Khách Sạn</title>
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/receptionist.css">
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
                        <h1 class="page-title">📊 Dashboard Lễ Tân</h1>

                        <!-- Statistics Cards -->
                        <div class="stats-grid">
                            <div class="stat-card pending">
                                <h3>Chờ Duyệt</h3>
                                <div class="number">${stats.pending}</div>
                                <p>Đặt phòng cần xử lý</p>
                            </div>
                            <div class="stat-card confirmed">
                                <h3>Đã Xác Nhận</h3>
                                <div class="number">${stats.confirmed}</div>
                                <p>Sẵn sàng check-in</p>
                            </div>
                            <div class="stat-card checkedin">
                                <h3>Đang Ở</h3>
                                <div class="number">${stats.checkedIn}</div>
                                <p>Khách hiện tại</p>
                            </div>
                            <div class="stat-card arrivals">
                                <h3>Đến Hôm Nay</h3>
                                <div class="number">${stats.todayArrivals}</div>
                                <p>Khách check-in</p>
                            </div>
                        </div>

                        <!-- Quick Actions -->
                        <div class="actions-section">
                            <h2>⚡ Thao Tác Nhanh</h2>
                            <div
                                style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 15px;">
                                <a href="${pageContext.request.contextPath}/reservation_approval"
                                    class="btn btn-primary">
                                    ✓ Duyệt Đặt Phòng
                                </a>
                                <a href="${pageContext.request.contextPath}/receptionist/reservations"
                                    class="btn btn-primary"
                                    style="background: linear-gradient(135deg, #28a745 0%, #20c997 100%);">
                                    📋 Danh Sách Đặt Phòng
                                </a>
                                <a href="${pageContext.request.contextPath}/receptionist/checkinout"
                                    class="btn btn-primary"
                                    style="background: linear-gradient(135deg, #dc3545 0%, #e85d6d 100%);">
                                    🔑 Check-in/Check-out
                                </a>
                                <a href="${pageContext.request.contextPath}/receptionist/direct-booking"
                                    class="btn btn-primary"
                                    style="background: linear-gradient(135deg, #fd7e14 0%, #fd9843 100%);">
                                    ➕ Đặt Phòng Trực Tiếp
                                </a>
                            </div>
                        </div>

                        <!-- Today's Arrivals -->
                        <c:if test="${not empty todayArrivals}">
                            <div class="section">
                                <h2>🛎️ Khách Đến Hôm Nay</h2>
                                <table>
                                    <thead>
                                        <tr>
                                            <th>Mã Booking</th>
                                            <th>Khách Hàng</th>
                                            <th>Phòng</th>
                                            <th>Số Khách</th>
                                            <th>Trạng Thái</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="arrival" items="${todayArrivals}">
                                            <tr>
                                                <td><strong>BK-${arrival.bookingId}</strong></td>
                                                <td>
                                                    <strong>${arrival.customerName}</strong><br>
                                                    <small style="color: #777;">${arrival.customerPhone}</small>
                                                </td>
                                                <td>${arrival.roomNumber} <small>(${arrival.typeName})</small></td>
                                                <td>${arrival.numGuests} người</td>
                                                <td>
                                                    <span class="badge badge-${fn:toLowerCase(arrival.status)}">
                                                        ${arrival.status}
                                                    </span>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:if>

                        <!-- Recent Bookings -->
                        <c:if test="${not empty recentBookings}">
                            <div class="section">
                                <h2>📝 Đặt Phòng Gần Đây</h2>
                                <table>
                                    <thead>
                                        <tr>
                                            <th>Mã Booking</th>
                                            <th>Khách Hàng</th>
                                            <th>Phòng</th>
                                            <th>Trạng Thái</th>
                                            <th>Thời Gian</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="booking" items="${recentBookings}">
                                            <tr>
                                                <td><strong>BK-${booking.bookingId}</strong></td>
                                                <td>${booking.customerName}</td>
                                                <td>${booking.roomNumber}</td>
                                                <td>
                                                    <span class="badge badge-${fn:toLowerCase(booking.status)}">
                                                        ${booking.status}
                                                    </span>
                                                </td>
                                                <td><small>${fn:replace(fn:substring(booking.createdAt, 0, 16), 'T', ' ')}</small></td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:if>
                    </div>

                    <footer>
                        <p>&copy; 2025 Khách Sạn Royal. Hệ Thống Quản Lí Khách Sạn</p>
                    </footer>
                </body>

                </html>