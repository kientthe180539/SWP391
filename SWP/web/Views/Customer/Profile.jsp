<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Hồ Sơ Khách Hàng - Quản Lí Khách Sạn</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/Customer/profile.css">
            </head>

            <body>
                <!-- Header -->
                <%@ include file="../Components/Header.jsp" %>
                    <%@ include file="../public/notify.jsp" %>

                        <!-- Main Content -->
                        <div class="container">
                            <!-- Profile Header -->
                            <div class="profile-header">
                                <!-- Back Button -->
                                <div class="back-home">
                                    <a href="${pageContext.request.contextPath}/home" class="btn btn-secondary">
                                        ← Quay về trang chủ
                                    </a>
                                </div>
                                <div class="profile-avatar">
                                    ${sessionScope.currentUser.fullName.substring(0, 1).toUpperCase()}
                                </div>
                                <div class="profile-info">
                                    <h1>${sessionScope.currentUser.fullName}</h1>
                                    <span class="member-level">⭐ Khách Hàng</span>
                                    <p><strong>Email:</strong> ${sessionScope.currentUser.email != null ?
                                        sessionScope.currentUser.email : 'Chưa cập nhật'}</p>
                                    <p><strong>Số Điện Thoại:</strong> ${sessionScope.currentUser.phone != null ?
                                        sessionScope.currentUser.phone : 'Chưa cập nhật'}</p>
                                    <p><strong>Username:</strong> ${sessionScope.currentUser.username}</p>
                                    <c:if test="${sessionScope.currentUser.createdAt != null}">
                                        <p><strong>Thành Viên Từ:</strong>
                                            ${sessionScope.currentUser.createdAt.toLocalDate()}</p>
                                    </c:if>
                                    <div class="profile-actions">
                                        <button class="btn btn-primary" onclick="openEditModal()">Chỉnh Sửa Thông
                                            Tin</button>
                                        <button class="btn btn-secondary" onclick="openPasswordModal()">Đổi Mật
                                            Khẩu</button>
                                    </div>
                                </div>
                            </div>

                            <!-- Tabs -->
                            <div class="tabs">
                                <button class="tab active" onclick="switchTab(event, 'personal-info')">Thông Tin Cá
                                    Nhân</button>
                                <button class="tab" onclick="switchTab(event, 'booking-history')">Lịch Sử Đặt
                                    Phòng</button>
                            </div>

                            <!-- Personal Information Tab -->
                            <div id="personal-info" class="tab-content active">
                                <div class="info-section">
                                    <div class="section-title">
                                        Thông Tin Cơ Bản
                                    </div>
                                    <div class="info-grid">
                                        <div class="info-item">
                                            <div class="info-label">Username</div>
                                            <div class="info-value">${sessionScope.currentUser.username}</div>
                                        </div>
                                        <div class="info-item">
                                            <div class="info-label">Họ & Tên</div>
                                            <div class="info-value">${sessionScope.currentUser.fullName}</div>
                                        </div>
                                        <div class="info-item">
                                            <div class="info-label">Email</div>
                                            <div class="info-value">
                                                ${sessionScope.currentUser.email != null ?
                                                sessionScope.currentUser.email : 'Chưa cập nhật'}
                                            </div>
                                        </div>
                                        <div class="info-item">
                                            <div class="info-label">Số Điện Thoại</div>
                                            <div class="info-value">
                                                ${sessionScope.currentUser.phone != null ?
                                                sessionScope.currentUser.phone : 'Chưa cập nhật'}
                                            </div>
                                        </div>
                                        <div class="info-item">
                                            <div class="info-label">Trạng Thái Tài Khoản</div>
                                            <div class="info-value">
                                                <c:choose>
                                                    <c:when test="${sessionScope.currentUser.active}">
                                                        <span style="color: green; font-weight: 600;">✓ Đang hoạt
                                                            động</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="color: red; font-weight: 600;">✗ Bị khóa</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Booking History Tab -->
                            <div id="booking-history" class="tab-content">
                                <div class="info-section">
                                    <div class="section-title">Lịch Sử Đặt Phòng</div>
                                    <p style="text-align: center; padding: 40px 20px; color: #64748b; font-size: 16px;">
                                        📅 Xem lịch sử đặt phòng chi tiết tại trang
                                        <a href="${pageContext.request.contextPath}/my_booking"
                                            style="color: #2980b9; font-weight: 600; text-decoration: none;">My
                                            Booking</a>
                                    </p>
                                </div>
                            </div>
                        </div>

                        <!-- Edit Profile Modal -->
                        <div id="editModal" class="modal">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h2>Chỉnh Sửa Thông Tin</h2>
                                    <button class="close-btn" onclick="closeEditModal()">×</button>
                                </div>
                                <form method="post" action="${pageContext.request.contextPath}/customer/profile">
                                    <input type="hidden" name="action" value="update_profile">

                                    <div class="form-group">
                                        <label>Họ & Tên <span style="color: red;">*</span></label>
                                        <input type="text" name="fullName" value="${sessionScope.currentUser.fullName}"
                                            required>
                                    </div>

                                    <div class="form-group">
                                        <label>Email <span style="color: red;">*</span></label>
                                        <input type="email" name="email" value="${sessionScope.currentUser.email}">
                                    </div>

                                    <div class="form-group">
                                        <label>Số Điện Thoại <span style="color: red;">*</span></label>
                                        <input type="tel" name="phone" value="${sessionScope.currentUser.phone}"
                                            placeholder="0912345678">
                                    </div>

                                    <div class="modal-actions">
                                        <button type="button" class="btn btn-secondary"
                                            onclick="closeEditModal()">Hủy</button>
                                        <button type="submit" class="btn btn-primary">Lưu Thay Đổi</button>
                                    </div>
                                </form>
                            </div>
                        </div>

                        <!-- Change Password Modal -->
                        <div id="passwordModal" class="modal">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h2>Đổi Mật Khẩu</h2>
                                    <button class="close-btn" onclick="closePasswordModal()">×</button>
                                </div>
                                <form method="post" action="${pageContext.request.contextPath}/customer/profile">
                                    <input type="hidden" name="action" value="change_password">

                                    <div class="form-group">
                                        <label>Mật Khẩu Hiện Tại <span style="color: red;">*</span></label>
                                        <input type="password" name="currentPassword" required minlength="6">
                                    </div>

                                    <div class="form-group">
                                        <label>Mật Khẩu Mới <span style="color: red;">*</span></label>
                                        <input type="password" name="newPassword" id="newPassword" required
                                            minlength="6">
                                    </div>

                                    <div class="form-group">
                                        <label>Xác Nhận Mật Khẩu Mới <span style="color: red;">*</span></label>
                                        <input type="password" name="confirmPassword" id="confirmPassword" required
                                            minlength="6">
                                    </div>

                                    <div class="modal-actions">
                                        <button type="button" class="btn btn-secondary"
                                            onclick="closePasswordModal()">Hủy</button>
                                        <button type="submit" class="btn btn-primary">Đổi Mật Khẩu</button>
                                    </div>
                                </form>
                            </div>
                        </div>

                        <!-- Footer -->
                        <%@ include file="../Components/Footer.jsp" %>

                            <script>
                                // Tab functionality
                                function switchTab(event, tabName) {
                                    const tabs = document.querySelectorAll('.tab');
                                    const contents = document.querySelectorAll('.tab-content');

                                    tabs.forEach(tab => tab.classList.remove('active'));
                                    contents.forEach(content => content.classList.remove('active'));

                                    event.target.classList.add('active');
                                    document.getElementById(tabName).classList.add('active');
                                }

                                // Edit Profile Modal
                                function openEditModal() {
                                    document.getElementById('editModal').classList.add('show');
                                }

                                function closeEditModal() {
                                    document.getElementById('editModal').classList.remove('show');
                                }

                                // Change Password Modal
                                function openPasswordModal() {
                                    document.getElementById('passwordModal').classList.add('show');
                                }

                                function closePasswordModal() {
                                    document.getElementById('passwordModal').classList.remove('show');
                                }

                                // Close modal when clicking outside
                                window.onclick = function (event) {
                                    const editModal = document.getElementById('editModal');
                                    const passwordModal = document.getElementById('passwordModal');

                                    if (event.target == editModal) {
                                        closeEditModal();
                                    }
                                    if (event.target == passwordModal) {
                                        closePasswordModal();
                                    }
                                }

                                // Validate password confirmation
                                document.querySelector('#passwordModal form').addEventListener('submit', function (e) {
                                    const newPass = document.getElementById('newPassword').value;
                                    const confirmPass = document.getElementById('confirmPassword').value;

                                    if (newPass !== confirmPass) {
                                        e.preventDefault();
                                        alert('Mật khẩu mới và xác nhận mật khẩu không khớp!');
                                    }
                                });
                            </script>
            </body>

            </html>