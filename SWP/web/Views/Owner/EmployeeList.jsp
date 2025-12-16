<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Employee List | HMS Owner</title>
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
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <div>
                                <h2 class="mb-1">Employees</h2>
                                <p class="text-muted mb-0">Manage your staff members.</p>
                            </div>
                            <a href="<c:url value='/owner/employee-create'/>" class="btn btn-primary">
                                <i class="bi bi-person-plus me-1"></i> Add Employee
                            </a>
                        </div>

                        <div class="card shadow-sm">
                            <div class="card-header bg-white py-3">
                                <form action="<c:url value='/owner/employees'/>" method="get">
                                    <div class="row g-3">
                                        <div class="col-md-3">
                                            <div class="input-group input-group-sm">
                                                <span class="input-group-text bg-light border-end-0"><i
                                                        class="bi bi-search"></i></span>
                                                <input type="text" name="search" class="form-control border-start-0"
                                                    placeholder="Search name, email..." value="${search}">
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <select name="roleId" class="form-select form-select-sm">
                                                <option value="">All Roles</option>
                                                <option value="6" ${roleId=='6' ? 'selected' : '' }>Manager
                                                </option>
                                                <option value="2" ${roleId=='2' ? 'selected' : '' }>Receptionist
                                                </option>
                                                <option value="3" ${roleId=='3' ? 'selected' : '' }>Housekeeping
                                                </option>
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
                                                <option value="fullName" ${sortBy=='fullName' ? 'selected' : '' }>Sort
                                                    by Name</option>
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
                                                <th>Name</th>
                                                <th>Role</th>
                                                <th>Contact</th>
                                                <th>Status</th>
                                                <th class="text-end pe-4">Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:if test="${empty employees}">
                                                <tr>
                                                    <td colspan="6" class="text-center py-5 text-muted">
                                                        <i class="bi bi-people fs-1 d-block mb-2"></i>
                                                        No employees found matching your criteria.
                                                    </td>
                                                </tr>
                                            </c:if>
                                            <c:forEach items="${employees}" var="e">
                                                <tr>
                                                    <td class="ps-4 text-muted">#${e.userId}</td>
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <div class="bg-light rounded-circle d-flex align-items-center justify-content-center me-3"
                                                                style="width: 40px; height: 40px;">
                                                                <span
                                                                    class="fw-bold text-primary">${e.username.substring(0,1).toUpperCase()}</span>
                                                            </div>
                                                            <div>
                                                                <div class="fw-bold">${e.fullName}</div>
                                                                <div class="small text-muted">@${e.username}</div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <span class="badge bg-light text-dark border">
                                                            ${e.roleId == 6 ? 'Manager' : (e.roleId == 2 ?
                                                            'Receptionist' : (e.roleId == 3 ?
                                                            'Housekeeping' : 'Other'))}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <div class="small"><i class="bi bi-envelope me-1"></i>
                                                            ${e.email}</div>
                                                        <div class="small"><i class="bi bi-phone me-1"></i> ${e.phone}
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <span class="badge ${e.active ? 'bg-success' : 'bg-danger'}">
                                                            ${e.active ? 'Active' : 'Inactive'}
                                                        </span>
                                                    </td>
                                                    <td class="text-end pe-4">
                                                        <a href="<c:url value='/owner/employee-detail'><c:param name='id' value='${e.userId}'/></c:url>"
                                                            class="btn btn-sm btn-outline-secondary me-1">
                                                            Edit
                                                        </a>
                                                        <form action="<c:url value='/owner/employees'/>" method="post"
                                                            class="d-inline" id="toggleForm_${e.userId}">
                                                            <input type="hidden" name="action" value="toggleStatus">
                                                            <input type="hidden" name="userId" value="${e.userId}">
                                                            <input type="hidden" name="currentStatus"
                                                                value="${e.active}">
                                                            <button type="button"
                                                                class="btn btn-sm ${e.active ? 'btn-outline-danger' : 'btn-outline-success'}"
                                                                onclick="confirmToggle('${e.userId}', ${e.active}, '${e.fullName}')">
                                                                ${e.active ? 'Lock' : 'Unlock'}
                                                            </button>
                                                        </form>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            <div class="card-footer bg-white py-3">
                                <nav class="d-flex justify-content-between align-items-center">
                                    <small class="text-muted">Showing ${employees.size()} of ${totalEmployees}
                                        employees</small>
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

            <!-- Scripts -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
            <script>
                // Check if there's a notification from session
                <%
                    String notification = (String) session.getAttribute("notification");
                if (notification != null && !notification.isEmpty()) {
                    String[] parts = notification.split("\\|");
                        String type = parts[0];
                        String msg = parts.length > 1 ? parts[1] : "";
                %>
                        Swal.fire({
                            icon: '<%= type %>',
                            title: '<%= type.substring(0, 1).toUpperCase() + type.substring(1) %>',
                            text: '<%= msg %>',
                            timer: 3000,
                            showConfirmButton: false
                        });
                <%
                        session.removeAttribute("notification");
                }
                %>

                    function confirmToggle(userId, isActive, name) {
                        const action = isActive ? 'lock' : 'unlock';
                        const title = isActive ? 'Lock Account?' : 'Unlock Account?';
                        const text = "Are you sure you want to " + action + " employee " + name + "?";
                        const confirmBtnText = isActive ? 'Yes, lock it!' : 'Yes, unlock it!';
                        const confirmBtnColor = isActive ? '#d33' : '#3085d6';

                        Swal.fire({
                            title: title,
                            text: text,
                            icon: 'warning',
                            showCancelButton: true,
                            confirmButtonColor: confirmBtnColor,
                            cancelButtonColor: '#6c757d',
                            confirmButtonText: confirmBtnText
                        }).then((result) => {
                            if (result.isConfirmed) {
                                document.getElementById('toggleForm_' + userId).submit();
                            }
                        });
                    }
            </script>
        </body>

        </html>