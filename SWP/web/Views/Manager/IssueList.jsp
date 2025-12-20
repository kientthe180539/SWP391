<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>Issue Management | HMS Manager</title>
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
                            <h2>Issue Management</h2>
                        </div>

                        <div class="card shadow-sm">
                            <div class="card-header bg-white py-3">
                                <form action="<c:url value='/manager/issues'/>" method="get">
                                    <div class="row g-3">
                                        <div class="col-md-3">
                                            <div class="input-group input-group-sm">
                                                <span class="input-group-text bg-light border-end-0"><i
                                                        class="bi bi-search"></i></span>
                                                <input type="text" name="search" class="form-control border-start-0"
                                                    placeholder="Search description/room..." value="${search}">
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <select name="type" class="form-select form-select-sm">
                                                <option value="">All Types</option>
                                                <option value="SUPPLY" ${type=='SUPPLY' ? 'selected' : '' }>Supply
                                                </option>
                                                <option value="EQUIPMENT" ${type=='EQUIPMENT' ? 'selected' : '' }>
                                                    Equipment</option>
                                                <option value="OTHER" ${type=='OTHER' ? 'selected' : '' }>Other</option>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <select name="status" class="form-select form-select-sm">
                                                <option value="">All Status</option>
                                                <option value="NEW" ${status=='NEW' ? 'selected' : '' }>New</option>
                                                <option value="IN_PROGRESS" ${status=='IN_PROGRESS' ? 'selected' : '' }>
                                                    In Progress</option>
                                                <option value="RESOLVED" ${status=='RESOLVED' ? 'selected' : '' }>
                                                    Resolved</option>
                                                <option value="CLOSED" ${status=='CLOSED' ? 'selected' : '' }>Closed
                                                </option>
                                            </select>
                                        </div>
                                        <div class="col-md-3">
                                            <select name="sortBy" class="form-select form-select-sm">
                                                <option value="created_at" ${sortBy=='created_at' ? 'selected' : '' }>
                                                    Sort by Date</option>
                                                <option value="room_id" ${sortBy=='room_id' ? 'selected' : '' }>Sort by
                                                    Room</option>
                                                <option value="priority" ${sortBy=='priority' ? 'selected' : '' }>Sort
                                                    by Priority</option>
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
                                                <th>Room</th>
                                                <th>Type</th>
                                                <th>Description</th>
                                                <th>Date</th>
                                                <th>Status</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${issues}" var="i">
                                                <tr>
                                                    <td>#${i.issueId}</td>
                                                    <td class="fw-bold">
                                                        <c:choose>
                                                            <c:when test="${not empty i.roomNumber}">
                                                                Room ${i.roomNumber}
                                                            </c:when>
                                                            <c:otherwise>Room ${i.roomId}</c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${i.issueType == 'CONFIRMATION'}">
                                                                <span
                                                                    class="badge text-bg-info text-white">CONFIRMATION</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span
                                                                    class="badge bg-light text-dark border">${i.issueType}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="text-truncate" style="max-width: 250px;"
                                                        title="${i.description}">${i.description}</td>
                                                    <td>${i.createdAt}</td>
                                                    <td>
                                                        <span
                                                            class="badge rounded-pill 
                                                    ${i.status == 'NEW' ? 'text-bg-danger' : 
                                                      i.status == 'RESOLVED' ? 'text-bg-success' : 
                                                      i.status == 'IN_PROGRESS' ? 'text-bg-warning' : 'text-bg-secondary'}">
                                                            ${i.status}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <c:if test="${i.status != 'RESOLVED' && i.status != 'CLOSED'}">
                                                            <form action="issues" method="post" class="d-inline">
                                                                <input type="hidden" name="action" value="resolve">
                                                                <input type="hidden" name="issueId"
                                                                    value="${i.issueId}">
                                                                <button type="submit" class="btn btn-sm btn-success">
                                                                    <i class="bi bi-check-lg me-1"></i>Resolve
                                                                </button>
                                                            </form>
                                                        </c:if>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${empty issues}">
                                                <tr>
                                                    <td colspan="7" class="text-center py-5 text-muted">
                                                        <i class="bi bi-check2-circle fs-1 d-block mb-2"></i>
                                                        No issues found.
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <!-- Pagination -->
                            <div class="card-footer bg-white py-3">
                                <nav class="d-flex justify-content-between align-items-center">
                                    <small class="text-muted">Showing ${issues.size()} of ${totalIssues} issues</small>
                                    <c:if test="${totalPages > 1}">
                                        <ul class="pagination pagination-sm mb-0">
                                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                <a class="page-link"
                                                    href="?page=${currentPage - 1}&search=${search}&status=${status}&type=${type}&sortBy=${sortBy}">Previous</a>
                                            </li>
                                            <c:forEach begin="1" end="${totalPages}" var="p">
                                                <li class="page-item ${currentPage == p ? 'active' : ''}">
                                                    <a class="page-link"
                                                        href="?page=${p}&search=${search}&status=${status}&type=${type}&sortBy=${sortBy}">${p}</a>
                                                </li>
                                            </c:forEach>
                                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                                <a class="page-link"
                                                    href="?page=${currentPage + 1}&search=${search}&status=${status}&type=${type}&sortBy=${sortBy}">Next</a>
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