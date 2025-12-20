<%@ page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Change Password | HMS</title>
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
                <link rel="stylesheet" href="<c:url value='/CSS/housekeeping.css'/>">
                <link rel="stylesheet"
                    href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
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
                                <h5 class="header-title mb-0">Change Password</h5>
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
                            <div class="row justify-content-center">
                                <div class="col-lg-6">
                                    <a href="${pageContext.request.contextPath}/receptionist/profile"
                                        class="btn btn-outline-secondary mb-3">
                                        <i class="bi bi-arrow-left"></i> Back to Profile
                                    </a>

                                    <div class="d-flex justify-content-between align-items-center mb-4">
                                        <div>
                                            <h2 class="mb-1">🔒 Change Password</h2>
                                            <p class="text-muted mb-0">Update your account password.</p>
                                        </div>
                                    </div>

                                    <div class="card">
                                        <div class="card-body">
                                            <!-- Password Requirements -->
                                            <div class="alert alert-info mb-4">
                                                <h6 class="alert-heading"><i class="bi bi-info-circle me-1"></i>Password
                                                    Requirements</h6>
                                                <ul class="mb-0 small">
                                                    <li>Minimum 6 characters</li>
                                                    <li>New password must match confirmation</li>
                                                    <li>Current password must be correct</li>
                                                </ul>
                                            </div>

                                            <!-- Password Form -->
                                            <form method="post"
                                                action="${pageContext.request.contextPath}/receptionist/change-password"
                                                onsubmit="return validatePassword();">
                                                <div class="mb-3">
                                                    <label class="form-label fw-semibold">Current Password *</label>
                                                    <div class="input-group">
                                                        <input type="password" name="oldPassword" id="oldPassword"
                                                            class="form-control" placeholder="Enter current password"
                                                            required>
                                                        <button class="btn btn-outline-secondary" type="button"
                                                            onclick="togglePassword('oldPassword', this)">
                                                            <i class="bi bi-eye"></i>
                                                        </button>
                                                    </div>
                                                </div>

                                                <div class="mb-3">
                                                    <label class="form-label fw-semibold">New Password *</label>
                                                    <div class="input-group">
                                                        <input type="password" name="newPassword" id="newPassword"
                                                            class="form-control"
                                                            placeholder="Enter new password (min 6 characters)"
                                                            minlength="6" required>
                                                        <button class="btn btn-outline-secondary" type="button"
                                                            onclick="togglePassword('newPassword', this)">
                                                            <i class="bi bi-eye"></i>
                                                        </button>
                                                    </div>
                                                </div>

                                                <div class="mb-4">
                                                    <label class="form-label fw-semibold">Confirm New Password *</label>
                                                    <div class="input-group">
                                                        <input type="password" name="confirmPassword"
                                                            id="confirmPassword" class="form-control"
                                                            placeholder="Re-enter new password" required>
                                                        <button class="btn btn-outline-secondary" type="button"
                                                            onclick="togglePassword('confirmPassword', this)">
                                                            <i class="bi bi-eye"></i>
                                                        </button>
                                                    </div>
                                                </div>

                                                <div class="d-flex gap-3 pt-3 border-top">
                                                    <a href="${pageContext.request.contextPath}/receptionist/profile"
                                                        class="btn btn-secondary flex-fill">
                                                        Cancel
                                                    </a>
                                                    <button type="submit" class="btn btn-primary flex-fill">
                                                        <i class="bi bi-lock me-1"></i>Change Password
                                                    </button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
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

                    function togglePassword(inputId, button) {
                        var input = document.getElementById(inputId);
                        var icon = button.querySelector('i');

                        if (input.type === 'password') {
                            input.type = 'text';
                            icon.classList.remove('bi-eye');
                            icon.classList.add('bi-eye-slash');
                        } else {
                            input.type = 'password';
                            icon.classList.remove('bi-eye-slash');
                            icon.classList.add('bi-eye');
                        }
                    }
                </script>
                <%@ include file="../public/notify.jsp" %>
            </body>

            </html>