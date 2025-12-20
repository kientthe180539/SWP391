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

                        <div class="card shadow-sm">
                            <div class="card-header bg-white py-3">
                                <form action="<c:url value='/admin/employees'/>" method="get">
                                    <div class="row g-3">
                                        <div class="col-md-3">
                                            <div class="input-group input-group-sm">
                                                <span class="input-group-text bg-light border-end-0"><i
                                                        class="bi bi-search"></i></span>
                                                <input type="text" name="search" class="form-control border-start-0"
                                                    placeholder="Search by name, email..." value="${search}">
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <select name="roleId" class="form-select form-select-sm">
                                                <option value="">All Roles</option>
                                                <option value="2" ${roleId=='2' ? 'selected' : '' }>Receptionist
                                                </option>
                                                <option value="3" ${roleId=='3' ? 'selected' : '' }>Housekeeping
                                                </option>
                                                <option value="6" ${roleId=='6' ? 'selected' : '' }>Manager</option>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <select name="status" class="form-select form-select-sm">
                                                <option value="">All Status</option>
                                                <option value="true" ${status=='true' ? 'selected' : '' }>Active
                                                </option>
                                                <option value="false" ${status=='false' ? 'selected' : '' }>Inactive
                                                </option>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <select name="sortBy" class="form-select form-select-sm">
                                                <option value="user_id" ${sortBy=='user_id' ? 'selected' : '' }>Sort by
                                                    ID</option>
                                                <option value="full_name" ${sortBy=='full_name' ? 'selected' : '' }>Sort
                                                    by Name</option>
                                                <option value="role_id" ${sortBy=='role_id' ? 'selected' : '' }>Sort by
                                                    Role</option>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <button type="submit" class="btn btn-sm btn-primary w-100">Filter</button>
                                        </div>
                                    </div>
                                </form>
                            </div>
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
                                                    <td colspan="7" class="text-center py-5 text-muted">
                                                        <i class="bi bi-people fs-1 d-block mb-2"></i>
                                                        No employees found
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            <div class="card-footer bg-white py-3">
                                <nav class="d-flex justify-content-between align-items-center">
                                    <small class="text-muted">Showing ${users.size()} of ${totalUsers} employees</small>
                                    <c:if test="${totalPages > 1}">
                                        <ul class="pagination pagination-sm mb-0">
                                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                <a class="page-link"
                                                    href="?page=${currentPage - 1}&search=${search}&roleId=${roleId}&status=${status}&sortBy=${sortBy}">Previous</a>
                                            </li>
                                            <c:forEach begin="1" end="${totalPages}" var="p">
                                                <li class="page-item ${currentPage == p ? 'active' : ''}">
                                                    <a class="page-link"
                                                        href="?page=${p}&search=${search}&roleId=${roleId}&status=${status}&sortBy=${sortBy}">${p}</a>
                                                </li>
                                            </c:forEach>
                                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                                <a class="page-link"
                                                    href="?page=${currentPage + 1}&search=${search}&roleId=${roleId}&status=${status}&sortBy=${sortBy}">Next</a>
                                            </li>
                                        </ul>
                                    </c:if>
                                </nav>
                            </div>
                        </div>
                    </div>

                    <jsp:include page="../Shared/Footer.jsp" />
                </div>
            </div>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>