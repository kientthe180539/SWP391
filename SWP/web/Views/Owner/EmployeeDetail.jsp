<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Employee Details | HMS Owner</title>
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                rel="stylesheet">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
            <link rel="stylesheet" href="<c:url value='/CSS/housekeeping.css'/>">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
        </head>

        <body>

            <div class="layout-wrapper">
                <jsp:include page="../Shared/OwnerSidebar.jsp" />

                <div class="main-content">
                    <jsp:include page="../Shared/Header.jsp" />

                    <div class="container-fluid py-4 px-4">
                        <div class="row justify-content-center">
                            <div class="col-md-8 col-lg-6">
                                <div class="card shadow-lg border-0">
                                    <div class="card-header bg-white py-3 border-bottom">
                                        <div class="d-flex align-items-center">
                                            <a href="<c:url value='/owner/employees'/>"
                                                class="btn btn-light btn-sm me-3 rounded-circle">
                                                <i class="bi bi-arrow-left"></i>
                                            </a>
                                            <h5 class="mb-0">Edit Employee: ${employee.username}</h5>
                                        </div>
                                    </div>
                                    <div class="card-body p-4">
                                        <form action="<c:url value='/owner/employees'/>" method="post">
                                            <input type="hidden" name="action" value="updateEmployee" />
                                            <input type="hidden" name="userId" value="${employee.userId}" />

                                            <div class="mb-3">
                                                <label class="form-label">Full Name</label>
                                                <input type="text" name="fullName" class="form-control"
                                                    value="${employee.fullName}" required>
                                            </div>

                                            <div class="row mb-3">
                                                <div class="col-md-6">
                                                    <label class="form-label">Email</label>
                                                    <input type="email" name="email" class="form-control"
                                                        value="${employee.email}" required>
                                                </div>
                                                <div class="col-md-6">
                                                    <label class="form-label">Phone</label>
                                                    <input type="tel" name="phone" class="form-control"
                                                        value="${employee.phone}" required>
                                                </div>
                                            </div>

                                            <div class="mb-3">
                                                <label class="form-label">Role</label>
                                                <select name="roleId" class="form-select" required>
                                                    <option value="6" ${employee.roleId==6 ? 'selected' : '' }>
                                                        Manager</option>
                                                    <option value="2" ${employee.roleId==2 ? 'selected' : '' }>
                                                        Receptionist</option>
                                                    <option value="3" ${employee.roleId==3 ? 'selected' : '' }>
                                                        Housekeeping</option>
                                                </select>
                                            </div>

                                            <div class="mb-4">
                                                <div class="form-check form-switch">
                                                    <input class="form-check-input" type="checkbox" id="isActive"
                                                        name="isActive" value="true" ${employee.active ? 'checked' : ''
                                                        }>
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
                            </div>
                        </div>
                    </div>

                    <jsp:include page="../Shared/Footer.jsp" />
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
            <%@ include file="../public/notify.jsp" %>
        </body>

        </html>