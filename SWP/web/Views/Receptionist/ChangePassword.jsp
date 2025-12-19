<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Change Password - Receptionist</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/receptionist.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/receptionist-common.css">
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
                            <a href="${pageContext.request.contextPath}/receptionist/room-status">Rooms</a>
                            <a href="${pageContext.request.contextPath}/receptionist/profile" class="active">Profile</a>
                            <a href="${pageContext.request.contextPath}/logout">Logout</a>
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
                            ← Back to Profile
                        </a>

                        <h1 class="page-title">🔒 Change Password</h1>

                        <!-- Messages -->
                        <jsp:include page="../public/notify.jsp" />

                        <!-- Password Change Card -->
                        <div class="password-card">
                            <div class="password-requirements">
                                <h4>Password Requirements:</h4>
                                <ul>
                                    <li>Minimum 6 characters</li>
                                    <li>New password must match confirmation</li>
                                    <li>Current password must be correct</li>
                                </ul>
                            </div>

                            <form method="post" action="${pageContext.request.contextPath}/receptionist/change-password"
                                onsubmit="return validatePassword();">
                                <div class="form-group">
                                    <label>Current Password *</label>
                                    <input type="password" name="oldPassword" id="oldPassword"
                                        placeholder="Enter current password" required>
                                </div>

                                <div class="form-group">
                                    <label>New Password *</label>
                                    <input type="password" name="newPassword" id="newPassword"
                                        placeholder="Enter new password (minimum 6 characters)" minlength="6" required>
                                </div>

                                <div class="form-group">
                                    <label>Confirm New Password *</label>
                                    <input type="password" name="confirmPassword" id="confirmPassword"
                                        placeholder="Re-enter new password" required>
                                </div>

                                <div class="button-group">
                                    <a href="${pageContext.request.contextPath}/receptionist/profile"
                                        class="btn btn-cancel" style="flex: 1; text-align: center;">
                                        Cancel
                                    </a>
                                    <button type="submit" class="btn btn-primary" style="flex: 1;">
                                        🔒 Change Password
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <footer>
                    <p>&copy; 2025 Hotel Management System. All rights reserved.</p>
                </footer>

                <script>
                    function validatePassword() {
                        var newPassword = document.getElementById('newPassword').value;
                        var confirmPassword = document.getElementById('confirmPassword').value;

                        if (newPassword !== confirmPassword) {
                            alert('New password and confirmation password do not match!');
                            return false;
                        }

                        if (newPassword.length < 6) {
                            alert('Password must be at least 6 characters!');
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