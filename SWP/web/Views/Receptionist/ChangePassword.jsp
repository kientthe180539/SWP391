<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Đổi Mật Khẩu - Lễ Tân</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/receptionist.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/receptionist-common.css">
            </head>

            <body>
                <header>
                    <div class="logo">🏨 Khách Sạn Royal - Quản Lí</div>
                    <div class="header-right">
                        <div class="nav-links">
                            <a href="${pageContext.request.contextPath}/receptionist/dashboard">Dashboard</a>
                            <a href="${pageContext.request.contextPath}/reservation_approval">Duyệt Phòng</a>
                            <a href="${pageContext.request.contextPath}/receptionist/reservations">Danh Sách</a>
                            <a href="${pageContext.request.contextPath}/receptionist/checkinout">Check-in/out</a>
                            <a href="${pageContext.request.contextPath}/receptionist/direct-booking">Walk-in</a>
                            <a href="${pageContext.request.contextPath}/receptionist/room-status">Phòng</a>
                            <a href="${pageContext.request.contextPath}/receptionist/profile" class="active">Profile</a>
                            <a href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
                        </div>
                        <div class="staff-profile">
                            <span>${sessionScope.currentUser.fullName}</span>
                            <div class="staff-avatar">${fn:substring(sessionScope.currentUser.fullName, 0, 2)}</div>
                        </div>
                    </div>
                </header>

                <div class="container">
                    <div class="password-container">
                        <a href="${pageContext.request.contextPath}/receptionist/profile" class="back-link">
                            ← Quay lại Profile
                        </a>

                        <h1 class="page-title">🔒 Đổi Mật Khẩu</h1>

                        <!-- Messages -->
                        <c:if test="${not empty type}">
                            <div class="alert alert-${type}">
                                ${type == 'success' ? '✓' : '✗'} ${mess}
                            </div>
                        </c:if>

                        <!-- Password Change Card -->
                        <div class="password-card">
                            <div class="password-requirements">
                                <h4>Yêu cầu mật khẩu:</h4>
                                <ul>
                                    <li>Tối thiểu 6 ký tự</li>
                                    <li>Mật khẩu mới phải khớp với xác nhận</li>
                                    <li>Mật khẩu hiện tại phải đúng</li>
                                </ul>
                            </div>

                            <form method="post" action="${pageContext.request.contextPath}/receptionist/change-password"
                                onsubmit="return validatePassword();">
                                <div class="form-group">
                                    <label>Mật khẩu hiện tại *</label>
                                    <input type="password" name="oldPassword" id="oldPassword"
                                        placeholder="Nhập mật khẩu hiện tại" required>
                                </div>

                                <div class="form-group">
                                    <label>Mật khẩu mới *</label>
                                    <input type="password" name="newPassword" id="newPassword"
                                        placeholder="Nhập mật khẩu mới (tối thiểu 6 ký tự)" minlength="6" required>
                                </div>

                                <div class="form-group">
                                    <label>Xác nhận mật khẩu mới *</label>
                                    <input type="password" name="confirmPassword" id="confirmPassword"
                                        placeholder="Nhập lại mật khẩu mới" required>
                                </div>

                                <div class="button-group">
                                    <a href="${pageContext.request.contextPath}/receptionist/profile"
                                        class="btn btn-cancel" style="flex: 1; text-align: center;">
                                        Hủy
                                    </a>
                                    <button type="submit" class="btn btn-primary" style="flex: 1;">
                                        🔒 Đổi Mật Khẩu
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <footer>
                    <p>&copy; 2025 Khách Sạn Royal. Hệ Thống Quản Lí Khách Sạn</p>
                </footer>

                <script>
                    function validatePassword() {
                        var newPassword = document.getElementById('newPassword').value;
                        var confirmPassword = document.getElementById('confirmPassword').value;

                        if (newPassword !== confirmPassword) {
                            alert('Mật khẩu mới và xác nhận mật khẩu không khớp!');
                            return false;
                        }

                        if (newPassword.length < 6) {
                            alert('Mật khẩu phải có ít nhất 6 ký tự!');
                            return false;
                        }

                        return true;
                    }

                    // Show password toggle (optional enhancement)
                    document.querySelectorAll('input[type="password"]').forEach(input => {
                        input.addEventListener('dblclick', function () {
                            if (this.type === 'password') {
                                this.type = 'text';
                                setTimeout(() => this.type = 'password', 1000);
                            }
                        });
                    });
                </script>
            </body>

            </html>
