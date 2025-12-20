<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>My Reported Issues | HMS Housekeeping</title>
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
                <link rel="stylesheet" href="<c:url value='/CSS/housekeeping.css'/>">
                <link rel="stylesheet"
                    href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
            </head>

            <body>

                <div class="layout-wrapper">
                    <jsp:include page="../Shared/Sidebar.jsp" />

                    <div class="main-content">
                        <jsp:include page="../Shared/Header.jsp" />

                        <div class="container-fluid py-4 px-4">
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <div>
                                    <h4 class="fw-bold mb-1">My Reported Issues</h4>
                                    <p class="text-muted mb-0">Track status of maintenance and supply issues you
                                        reported
                                    </p>
                                </div>
                                <a href="<c:url value='/housekeeping/issue-report'/>"
                                    class="btn btn-warning text-white">
                                    <i class="bi bi-plus-lg me-2"></i>Report New Issue
                                </a>
                            </div>

                            <div class="card shadow-sm border-0">
                                <div class="card-header bg-white py-3">
                                    <form action="<c:url value='/housekeeping/my-issues'/>" method="get">
                                        <div class="row g-3">
                                            <div class="col-md-3">
                                                <div class="input-group input-group-sm">
                                                    <span class="input-group-text bg-light border-end-0"><i
                                                            class="bi bi-search"></i></span>
                                                    <input type="text" name="search" class="form-control border-start-0"
                                                        placeholder="Search issue..." value="${search}">
                                                </div>
                                            </div>
                                            <div class="col-md-2">
                                                <select name="type" class="form-select form-select-sm">
                                                    <option value="">All Types</option>
                                                    <option value="SUPPLY" ${type=='SUPPLY' ? 'selected' : '' }>Supply
                                                    </option>
                                                    <option value="EQUIPMENT" ${type=='EQUIPMENT' ? 'selected' : '' }>
                                                        Equipment</option>
                                                </select>
                                            </div>
                                            <div class="col-md-2">
                                                <select name="status" class="form-select form-select-sm">
                                                    <option value="">All Status</option>
                                                    <option value="NEW" ${status=='NEW' ? 'selected' : '' }>New</option>
                                                    <option value="IN_PROGRESS" ${status=='IN_PROGRESS' ? 'selected'
                                                        : '' }>
                                                        In Progress</option>
                                                    <option value="RESOLVED" ${status=='RESOLVED' ? 'selected' : '' }>
                                                        Resolved</option>
                                                    <option value="CLOSED" ${status=='CLOSED' ? 'selected' : '' }>Closed
                                                    </option>
                                                </select>
                                            </div>
                                            <div class="col-md-3">
                                                <select name="sortBy" class="form-select form-select-sm">
                                                    <option value="created_at" ${sortBy=='created_at' ? 'selected' : ''
                                                        }>
                                                        Sort by Date</option>
                                                    <option value="status" ${sortBy=='status' ? 'selected' : '' }>Sort
                                                        by
                                                        Status</option>
                                                    <option value="roomId" ${sortBy=='roomId' ? 'selected' : '' }>Sort
                                                        by
                                                        Room</option>
                                                </select>
                                            </div>
                                            <div class="col-md-2">
                                                <button type="submit"
                                                    class="btn btn-sm btn-primary w-100">Filter</button>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                                <div class="card-body p-0">
                                    <div class="table-responsive">
                                        <table class="table table-hover align-middle mb-0">
                                            <thead class="bg-light">
                                                <tr>
                                                    <th class="ps-4">Room</th>
                                                    <th>Type</th>
                                                    <th>Description</th>
                                                    <th>Date Reported</th>
                                                    <th>Status</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:if test="${empty issues}">
                                                    <tr>
                                                        <td colspan="5" class="text-center py-5 text-muted">
                                                            <i class="bi bi-clipboard-check display-6 mb-3 d-block"></i>
                                                            <p>You haven't reported any issues yet.</p>
                                                        </td>
                                                    </tr>
                                                </c:if>
                                                <c:forEach items="${issues}" var="i">
                                                    <tr>
                                                        <td class="ps-4 fw-bold">Room ${i.roomNumber}</td>
                                                        <td>
                                                            <span
                                                                class="badge ${i.issueType == 'EQUIPMENT' ? 'bg-danger' : 'bg-warning'} bg-opacity-10 text-dark border border-opacity-10">
                                                                ${i.issueType}
                                                            </span>
                                                        </td>
                                                        <td style="max-width: 300px;" class="text-truncate"
                                                            title="${i.description}">
                                                            ${i.description}
                                                        </td>
                                                        <td class="text-muted small">
                                                            ${i.createdAt.toLocalDate()} <br>
                                                            ${i.createdAt.toLocalTime().toString().substring(0,5)}
                                                        </td>
                                                        <td>
                                                            <span
                                                                class="badge ${i.status == 'NEW' ? 'bg-info' : (i.status == 'CLOSED' ? 'bg-success' : 'bg-warning')} rounded-pill">
                                                                ${i.status}
                                                            </span>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                                <div class="card-footer bg-white py-3">
                                    <nav class="d-flex justify-content-between align-items-center">
                                        <small class="text-muted">Showing ${issues.size()} of ${totalIssues}
                                            issues</small>
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

                <jsp:include page="../public/notify.jsp" />
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>