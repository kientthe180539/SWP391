<%@ page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>My Profile | HMS</title>
                    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                        rel="stylesheet">
                    <link rel="stylesheet"
                        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
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
                                    <h5 class="header-title mb-0">My Profile</h5>
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
                                    <div class="col-lg-8">
                                        <div class="d-flex justify-content-between align-items-center mb-4">
                                            <div>
                                                <h2 class="mb-1">👤 My Profile</h2>
                                                <p class="text-muted mb-0">Manage your personal information.</p>
                                            </div>
                                        </div>

                                        <div class="card">
                                            <div class="card-body">
                                                <!-- Profile Header -->
                                                <div class="text-center pb-4 mb-4 border-bottom">
                                                    <div class="d-inline-flex align-items-center justify-content-center rounded-circle bg-primary text-white mb-3"
                                                        style="width: 100px; height: 100px; font-size: 40px; font-weight: bold;">
                                                        ${fn:substring(profile.fullName, 0, 1)}
                                                    </div>
                                                    <h3 class="mb-2">${profile.fullName}</h3>
                                                    <span class="badge bg-primary bg-opacity-10 text-primary px-3 py-2">
                                                        ${profile.roleName}
                                                    </span>
                                                </div>

                                                <!-- Profile Form -->
                                                <form method="post"
                                                    action="${pageContext.request.contextPath}/receptionist/profile">
                                                    <div class="row g-3">
                                                        <div class="col-md-12">
                                                            <label class="form-label fw-semibold">Full Name *</label>
                                                            <input type="text" name="fullName" class="form-control"
                                                                value="${profile.fullName}" required>
                                                        </div>
                                                        <div class="col-md-6">
                                                            <label class="form-label fw-semibold">Email Address
                                                                *</label>
                                                            <input type="email" name="email" class="form-control"
                                                                value="${profile.email}" required>
                                                        </div>
                                                        <div class="col-md-6">
                                                            <label class="form-label fw-semibold">Phone Number *</label>
                                                            <input type="tel" name="phone" class="form-control"
                                                                value="${profile.phone}" required>
                                                        </div>
                                                        <div class="col-md-6">
                                                            <label class="form-label fw-semibold">Role</label>
                                                            <input type="text" class="form-control bg-light"
                                                                value="${profile.roleName}" disabled>
                                                        </div>
                                                        <div class="col-md-6">
                                                            <label class="form-label fw-semibold">Account
                                                                Created</label>
                                                            <input type="text" class="form-control bg-light"
                                                                value="<fmt:formatDate value='${profile.createdAt}' pattern='yyyy-MM-dd HH:mm'/>"
                                                                disabled>
                                                        </div>
                                                    </div>

                                                    <div class="d-flex gap-3 mt-4 pt-3 border-top">
                                                        <button type="submit" class="btn btn-primary flex-fill">
                                                            <i class="bi bi-save me-1"></i>Save Changes
                                                        </button>
                                                        <a href="${pageContext.request.contextPath}/receptionist/change-password"
                                                            class="btn btn-outline-warning flex-fill">
                                                            <i class="bi bi-lock me-1"></i>Change Password
                                                        </a>
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
                    </script>
                    <%@ include file="../public/notify.jsp" %>
                </body>

                </html>