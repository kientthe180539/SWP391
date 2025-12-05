<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>User Details | HMS Admin</title>
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                rel="stylesheet">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
            <link rel="stylesheet" href="<c:url value='/CSS/housekeeping.css'/>">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
        </head>

        <body>

            <div class="layout-wrapper">
                <jsp:include page="../Shared/AdminSidebar.jsp" />

                <div class="main-content">
                    <jsp:include page="../Shared/Header.jsp" />

                    <div class="container-fluid py-4 px-4">
                        <div class="row justify-content-center">
                            <div class="col-md-8 col-lg-6">
                                <div class="card shadow-lg border-0 mb-4">
                                    <div class="card-header bg-white py-3 border-bottom">
                                        <div class="d-flex align-items-center">
                                            <a href="<c:url value='/admin/users'/>"
                                                class="btn btn-light btn-sm me-3 rounded-circle">
                                                <i class="bi bi-arrow-left"></i>
                                            </a>
                                            <h5 class="mb-0">Edit User: ${user.username}</h5>
                                        </div>
                                    </div>
                                    <div class="card-body p-4">
                                        <form action="<c:url value='/admin/users'/>" method="post">
                                            <input type="hidden" name="action" value="updateUser" />
                                            <input type="hidden" name="userId" value="${user.userId}" />

                                            <div class="mb-3">
                                                <label class="form-label">Full Name</label>
                                                <input type="text" name="fullName" class="form-control"
                                                    value="${user.fullName}" required>
                                            </div>

                                            <div class="row mb-3">
                                                <div class="col-md-6">
                                                    <label class="form-label">Email</label>
                                                    <input type="email" name="email" class="form-control"
                                                        value="${user.email}" required>
                                                </div>
                                                <div class="col-md-6">
                                                    <label class="form-label">Phone</label>
                                                    <input type="tel" name="phone" class="form-control"
                                                        value="${user.phone}" required>
                                                </div>
                                            </div>

                                            <div class="mb-3">
                                                <label class="form-label">Role</label>
                                                <select name="roleId" class="form-select" required>
                                                    <option value="1" ${user.roleId==1 ? 'selected' : '' }>Guest
                                                    </option>
                                                    <option value="2" ${user.roleId==2 ? 'selected' : '' }>Receptionist
                                                    </option>
                                                    <option value="3" ${user.roleId==3 ? 'selected' : '' }>Housekeeping
                                                    </option>
                                                    <option value="4" ${user.roleId==4 ? 'selected' : '' }>Owner
                                                    </option>
                                                    <option value="5" ${user.roleId==5 ? 'selected' : '' }>Admin
                                                    </option>
                                                </select>
                                            </div>

                                            <div class="mb-4">
                                                <div class="form-check form-switch">
                                                    <input class="form-check-input" type="checkbox" id="isActive"
                                                        name="isActive" value="true" ${user.active ? 'checked' : '' }>
                                                    <label class="form-check-label" for="isActive">Account
                                                        Active</label>
                                                </div>
                                            </div>

                                            <div class="d-grid">
                                                <button type="submit" class="btn btn-primary">
                                                    Save Changes
                                                </button>
                                            </div>
                                        </form>
                                    </div>
                                </div>

                                <!-- Reset Password Card -->
                                <div class="card shadow-sm border-danger">
                                    <div class="card-header bg-danger text-white py-2">
                                        <h6 class="mb-0">Security Actions</h6>
                                    </div>
                                    <div class="card-body p-4">
                                        <form action="<c:url value='/admin/users'/>" method="post">
                                            <input type="hidden" name="action" value="resetPassword" />
                                            <input type="hidden" name="userId" value="${user.userId}" />

                                            <div class="mb-3">
                                                <label class="form-label">New Password</label>
                                                <input type="password" name="newPassword" class="form-control" required
                                                    minlength="6">
                                            </div>
                                            <button type="submit" class="btn btn-outline-danger">Reset Password</button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <jsp:include page="../Shared/Footer.jsp" />
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>