<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>Create Employee | HMS Admin</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
            <link rel="stylesheet" href="<c:url value='/CSS/housekeeping.css'/>">
        </head>

        <body>
            <div class="layout-wrapper">
                <jsp:include page="../Shared/Sidebar.jsp" />
                <div class="main-content">
                    <jsp:include page="../Shared/Header.jsp" />

                    <div class="container-fluid p-4">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h2 class="mb-0">Create Employee</h2>
                            <a href="<c:url value='/admin/employees'/>" class="btn btn-outline-secondary">
                                <i class="bi bi-arrow-left"></i> Back to List
                            </a>
                        </div>

                        <div class="row justify-content-center">
                            <div class="col-md-8 col-lg-6">
                                <div class="card shadow-sm">
                                    <div class="card-body p-4">
                                        <c:if test="${not empty error}">
                                            <c:set var="type" value="error" scope="request" />
                                            <c:set var="mess" value="${error}" scope="request" />
                                        </c:if>
                                        <jsp:include page="../public/notify.jsp" />

                                        <form action="<c:url value='/admin/create-employee'/>" method="POST">
                                            <input type="hidden" name="action" value="createEmployee">

                                            <div class="mb-3">
                                                <label class="form-label">Username</label>
                                                <input type="text" name="username" class="form-control" required>
                                            </div>

                                            <div class="mb-3">
                                                <label class="form-label">Password</label>
                                                <input type="password" name="password" class="form-control" required>
                                            </div>

                                            <div class="mb-3">
                                                <label class="form-label">Full Name</label>
                                                <input type="text" name="fullName" class="form-control" required>
                                            </div>

                                            <div class="mb-3">
                                                <label class="form-label">Email</label>
                                                <input type="email" name="email" class="form-control" required>
                                            </div>

                                            <div class="mb-3">
                                                <label class="form-label">Phone</label>
                                                <input type="tel" name="phone" class="form-control" required>
                                            </div>

                                            <div class="mb-3">
                                                <label class="form-label">Role</label>
                                                <select name="roleId" class="form-select" required>
                                                    <option value="">Select Role</option>
                                                    <option value="5">Admin</option>
                                                    <option value="4">Owner</option>
                                                    <option value="6">Manager</option>
                                                    <option value="2">Receptionist</option>
                                                    <option value="3">Housekeeping</option>
                                                </select>
                                            </div>

                                            <div class="d-grid gap-2">
                                                <button type="submit" class="btn btn-primary">Create Employee</button>
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
        </body>

        </html>