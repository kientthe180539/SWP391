<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>User Accounts | HMS Admin</title>
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
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <div>
                                <h2 class="mb-1">User Accounts</h2>
                                <p class="text-muted mb-0">Manage all system users.</p>
                            </div>
                        </div>

                        <div class="card shadow-sm">
                            <div class="card-header bg-white py-3">
                                <form action="<c:url value='/admin/users'/>" method="get">
                                    <div class="row g-3">
                                        <div class="col-md-3">
                                            <div class="input-group input-group-sm">
                                                <span class="input-group-text bg-light border-end-0"><i
                                                        class="bi bi-search"></i></span>
                                                <input type="text" name="search" class="form-control border-start-0"
                                                    placeholder="Search user..." value="${search}">
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <select name="roleId" class="form-select form-select-sm">
                                                <option value="">All Roles</option>
                                                <option value="1" ${roleId=='1' ? 'selected' : '' }>Guest</option>
                                                <option value="2" ${roleId=='2' ? 'selected' : '' }>Receptionist
                                                </option>
                                                <option value="3" ${roleId=='3' ? 'selected' : '' }>Housekeeping
                                                </option>
                                                <option value="4" ${roleId=='4' ? 'selected' : '' }>Owner</option>
                                                <option value="5" ${roleId=='5' ? 'selected' : '' }>Admin</option>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <select name="status" class="form-select form-select-sm">
                                                <option value="">All Status</option>
                                                <option value="true" ${status=='true' ? 'selected' : '' }>Active
                                                </option>
                                                <option value="false" ${status=='false' ? 'selected' : '' }>Locked
                                                </option>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <select name="sortBy" class="form-select form-select-sm">
                                                <option value="user_id" ${sortBy=='user_id' ? 'selected' : '' }>Sort by
                                                    ID</option>
                                                <option value="username" ${sortBy=='username' ? 'selected' : '' }>Sort
                                                    by Username</option>
                                                <option value="roleId" ${sortBy=='roleId' ? 'selected' : '' }>Sort by
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
                                        <thead class="bg-light">
                                            <tr>
                                                <th class="ps-4">ID</th>
                                                <th>Username</th>
                                                <th>Full Name</th>
                                                <th>Role</th>
                                                <th>Status</th>
                                                <th class="text-end pe-4">Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:if test="${empty users}">
                                                <tr>
                                                    <td colspan="6" class="text-center py-5 text-muted">
                                                        <i class="bi bi-people fs-1 d-block mb-2"></i>
                                                        No users found matching your criteria.
                                                    </td>
                                                </tr>
                                            </c:if>
                                            <c:forEach items="${users}" var="u">
                                                <tr>
                                                    <td class="ps-4 text-muted">#${u.userId}</td>
                                                    <td class="fw-bold text-primary">${u.username}</td>
                                                    <td>${u.fullName}</td>
                                                    <td>
                                                        <span class="badge bg-light text-dark border">
                                                            ${u.roleId == 1 ? 'Guest' : (u.roleId == 2 ? 'Receptionist'
                                                            : (u.roleId == 3 ? 'Housekeeping' : (u.roleId == 4 ? 'Owner'
                                                            : 'Admin')))}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <span class="badge ${u.active ? 'bg-success' : 'bg-danger'}">
                                                            ${u.active ? 'Active' : 'Locked'}
                                                        </span>
                                                    </td>
                                                    <td class="text-end pe-4">
                                                        <a href="<c:url value='/admin/user-detail'><c:param name='id' value='${u.userId}'/></c:url>"
                                                            class="btn btn-sm btn-outline-primary">
                                                            Manage
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            <div class="card-footer bg-white py-3">
                                <nav class="d-flex justify-content-between align-items-center">
                                    <small class="text-muted">Showing ${users.size()} of ${totalUsers} users</small>
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