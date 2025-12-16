<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Duyệt Đặt Phòng - Lễ Tân</title>
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

                    <main>
                        <div class="container">
                            <div class="page-title">
                                📋 Duyệt Đặt Phòng
                                <a href="${pageContext.request.contextPath}/receptionist/dashboard" class="back-link">←
                                    Dashboard</a>
                            </div>

                            <c:if test="${not empty type}">
                                <div class="alert alert-${type}">
                                    ${mess}
                                </div>
                            </c:if>

                            <c:choose>
                                <c:when test="${empty pendingBookings}">
                                    <div class="empty-state">
                                        <h3>✅ Không có đặt phòng cần duyệt</h3>
                                        <p style="color: #999; margin-top: 10px;">Tất cả các đặt phòng đã được xử lý.
                                        </p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <p style="margin-bottom: 20px; color: #777; font-size: 15px;">
                                        <strong style="color: #1e3c72;">${fn:length(pendingBookings)}</strong> đặt phòng
                                        đang chờ duyệt
                                    </p>
                                    <div class="reservations-grid">
                                        <c:forEach var="booking" items="${pendingBookings}">
                                            <div class="reservation-card">
                                                <div class="reservation-header">
                                                    <span class="reservation-id">BK-${booking.bookingId}</span>
                                                    <span class="reservation-status">CHỜ XÁC NHẬN</span>
                                                </div>
                                                <div class="reservation-body">
                                                    <div class="guest-info">
                                                        <div class="guest-name">${booking.customerName}</div>
                                                        <div class="guest-contact">
                                                            <span>📧 ${booking.customerEmail}</span>
                                                            <span>📱 ${booking.customerPhone}</span>
                                                        </div>
                                                    </div>

                                                    <table class="info-table">
                                                        <tr>
                                                            <td>Check-in:</td>
                                                            <td>${booking.checkinDate}</td>
                                                        </tr>
                                                        <tr>
                                                            <td>Check-out:</td>
                                                            <td>${booking.checkoutDate}</td>
                                                        </tr>
                                                        <tr>
                                                            <td>Số Khách:</td>
                                                            <td>${booking.numGuests} người</td>
                                                        </tr>
                                                    </table>

                                                    <div class="room-details">
                                                        <div class="room-name">Phòng ${booking.roomNumber} -
                                                            ${booking.typeName}</div>
                                                        <div style="color: #777; font-size: 14px;">Tầng ${booking.floor}
                                                        </div>
                                                    </div>

                                                    <table class="info-table" style="border-bottom: none;">
                                                        <tr>
                                                            <td style="font-weight: 700; color: #e67e22;">Tổng Tiền:
                                                            </td>
                                                            <td style="font-weight: 700; font-size: 18px;"
                                                                class="price-large">
                                                                <fmt:formatNumber value="${booking.totalAmount}"
                                                                    pattern="#,###" /> đ
                                                            </td>
                                                        </tr>
                                                    </table>

                                                    <div class="action-buttons">
                                                        <button class="btn btn-approve"
                                                            onclick="approveBooking(${booking.bookingId})">✓
                                                            Duyệt</button>
                                                        <button class="btn btn-reject"
                                                            onclick="showRejectModal(${booking.bookingId})">✗ Từ
                                                            Chối</button>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </main>

                    <footer>
                        <p>&copy; 2025 Khách Sạn Royal. Hệ Thống Quản Lí Khách Sạn</p>
                    </footer>

                    <!-- Reject Modal -->
                    <div id="rejectModal" class="modal">
                        <div class="modal-content">
                            <div class="modal-header">Từ chối đặt phòng</div>
                            <div class="modal-body">
                                <label for="rejectReason">Lý do từ chối:</label>
                                <textarea id="rejectReason" rows="4"
                                    placeholder="Nhập lý do từ chối (vd: Phòng đã đầy, thông tin không hợp lệ...)"></textarea>
                            </div>
                            <div class="modal-buttons">
                                <button class="btn btn-reject" onclick="submitReject()">Xác nhận từ chối</button>
                                <button class="btn btn-cancel" onclick="closeModal()">Hủy</button>
                            </div>
                        </div>
                    </div>

                    <script>
                        let currentBookingId = null;

                        function approveBooking(bookingId) {
                            if (confirm('Xác nhận duyệt đặt phòng BK-' + bookingId + '?')) {
                                const form = document.createElement('form');
                                form.method = 'POST';
                                form.action = '${pageContext.request.contextPath}/reservation_approval';

                                const actionInput = document.createElement('input');
                                actionInput.type = 'hidden';
                                actionInput.name = 'action';
                                actionInput.value = 'approve';

                                const bookingIdInput = document.createElement('input');
                                bookingIdInput.type = 'hidden';
                                bookingIdInput.name = 'bookingId';
                                bookingIdInput.value = bookingId;

                                form.appendChild(actionInput);
                                form.appendChild(bookingIdInput);
                                document.body.appendChild(form);
                                form.submit();
                            }
                        }

                        function showRejectModal(bookingId) {
                            currentBookingId = bookingId;
                            document.getElementById('rejectModal').style.display = 'block';
                            document.getElementById('rejectReason').value = '';
                            document.getElementById('rejectReason').focus();
                        }

                        function closeModal() {
                            document.getElementById('rejectModal').style.display = 'none';
                            currentBookingId = null;
                        }

                        function submitReject() {
                            const reason = document.getElementById('rejectReason').value.trim();
                            if (!reason) {
                                alert('Vui lòng nhập lý do từ chối!');
                                return;
                            }

                            const form = document.createElement('form');
                            form.method = 'POST';
                            form.action = '${pageContext.request.contextPath}/reservation_approval';

                            const actionInput = document.createElement('input');
                            actionInput.type = 'hidden';
                            actionInput.name = 'action';
                            actionInput.value = 'reject';

                            const bookingIdInput = document.createElement('input');
                            bookingIdInput.type = 'hidden';
                            bookingIdInput.name = 'bookingId';
                            bookingIdInput.value = currentBookingId;

                            const reasonInput = document.createElement('input');
                            reasonInput.type = 'hidden';
                            reasonInput.name = 'reason';
                            reasonInput.value = reason;

                            form.appendChild(actionInput);
                            form.appendChild(bookingIdInput);
                            form.appendChild(reasonInput);
                            document.body.appendChild(form);
                            form.submit();
                        }

                        // Close modal when clicking outside
                        window.onclick = function (event) {
                            const modal = document.getElementById('rejectModal');
                            if (event.target === modal) {
                                closeModal();
                            }
                        };

                        // Close modal with Escape key
                        document.addEventListener('keydown', function (event) {
                            if (event.key === 'Escape') {
                                closeModal();
                            }
                        });
                    </script>
                </body>

                </html>