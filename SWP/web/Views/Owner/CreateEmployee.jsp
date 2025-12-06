<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Add Employee | HMS Owner</title>
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
                                    <div class="card-header bg-primary text-white py-3">
                                        <h5 class="mb-0"><i class="bi bi-person-plus-fill me-2"></i>Add New Employee
                                        </h5>
                                    </div>
                                    <div class="card-body p-4">
                                        <c:if test="${not empty error}">
                                            <div class="alert alert-danger">${error}</div>
                                        </c:if>

                                        <form action="<c:url value='/owner/employees'/>" method="post">
                                            <input type="hidden" name="action" value="createEmployee" />

                                            <div class="row mb-3">
                                                <div class="col-md-6">
                                                    <label class="form-label">Username</label>
                                                    <input type="text" name="username" class="form-control" required>
                                                </div>
                                                <div class="col-md-6">
                                                    <label class="form-label">Password</label>
                                                    <input type="password" name="password" class="form-control" required
                                                        minlength="6">
                                                </div>
                                            </div>

                                            <div class="mb-3">
                                                <label class="form-label">Full Name</label>
                                                <input type="text" name="fullName" class="form-control" required>
                                            </div>

                                            <div class="row mb-3">
                                                <div class="col-md-6">
                                                    <label class="form-label">Email</label>
                                                    <input type="email" name="email" class="form-control" required>
                                                </div>
                                                <div class="col-md-6">
                                                    <label class="form-label">Phone</label>
                                                    <input type="tel" name="phone" class="form-control" required>
                                                </div>
                                            </div>

                                            <div class="mb-4">
                                                <label class="form-label">Role</label>
                                                <select name="roleId" class="form-select" required>
                                                    <option value="" disabled selected>-- Select Role --</option>
                                                    <option value="2">Receptionist</option>
                                                    <option value="3">Housekeeping</option>
                                                </select>
                                            </div>

                                            <div class="d-flex justify-content-between align-items-center">
                                                <a href="<c:url value='/owner/employees'/>"
                                                    class="text-decoration-none text-muted">Cancel</a>
                                                <button type="submit" class="btn btn-primary px-4">
                                                    Create Employee
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
        </body>

        </html>