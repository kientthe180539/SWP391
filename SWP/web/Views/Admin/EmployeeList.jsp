<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>Employee List | HMS Admin</title>
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
                            <h2 class="mb-0">Employee List</h2>
                            <a href="<c:url value='/admin/create-employee'/>" class="btn btn-primary">
                                <i class="bi bi-plus-lg"></i> Add Employee
                            </a>
                        </div>

                        <!-- Search and Filter Row -->
                        <div class="row g-3 mb-4">
                            <div class="col-md-6">
                                <form method="GET" class="d-flex">
                                    <input type="text" class="form-control" name="search"
                                        placeholder="Search by name, email, or phone..." value="${search}">
                                    <button type="submit" class="btn btn-outline-primary ms-2">
                                        <i class="bi bi-search"></i>
                                    </button>
                                </form>
                            </div>
                        </div>

                        <div class="card shadow-sm">
                            <div class="card-body p-0">
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle mb-0">
                                        <thead class="table-light">
                                            <tr>
                                                <th>ID</th>
                                                <th>Name</th>
                                                <th>Role</th>
                                                <th>Email</th>
                                                <th>Phone</th>
                                                <th>Status</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${users}" var="user">
                                                <tr>
                                                    <td>#${user.userId}</td>
                                                    <td>
                                                        <div class="fw-bold">${user.fullName}</div>
                                                        <div class="small text-muted">@${user.username}</div>
                                                    </td>
                                                    <td>
                                                        <span class="badge bg-info text-dark">
                                                            <c:choose>
                                                                <c:when test="${user.roleId == 2}">Receptionist</c:when>
                                                                <c:when test="${user.roleId == 3}">Housekeeping</c:when>
                                                                <c:when test="${user.roleId == 6}">Manager</c:when>
                                                                <c:otherwise>Role ${user.roleId}</c:otherwise>
                                                            </c:choose>
                                                        </span>
                                                    </td>
                                                    <td>${user.email}</td>
                                                    <td>${user.phone}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${user.active}">
                                                                <span class="badge bg-success">Active</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-danger">Inactive</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <a href="<c:url value='/admin/user-detail?id=${user.userId}'/>"
                                                            class="btn btn-sm btn-outline-secondary">
                                                            <i class="bi bi-pencil"></i> Edit
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${empty users}">
                                                <tr>
                                                    <td colspan="7" class="text-center py-4 text-muted">No employees
                                                        found</td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
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