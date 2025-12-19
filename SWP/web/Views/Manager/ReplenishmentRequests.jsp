<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>Replenishment Requests | HMS</title>
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
                            <h2 class="mb-0">Replenishment Requests</h2>
                            <div class="btn-group">
                                <a href="?status=ALL"
                                    class="btn btn-sm ${statusFilter == 'ALL' ? 'btn-primary' : 'btn-outline-primary'}">All</a>
                                <a href="?status=PENDING"
                                    class="btn btn-sm ${statusFilter == 'PENDING' ? 'btn-warning' : 'btn-outline-warning'}">Pending</a>
                                <a href="?status=APPROVED"
                                    class="btn btn-sm ${statusFilter == 'APPROVED' ? 'btn-success' : 'btn-outline-success'}">Approved</a>
                                <a href="?status=REJECTED"
                                    class="btn btn-sm ${statusFilter == 'REJECTED' ? 'btn-danger' : 'btn-outline-danger'}">Rejected</a>
                            </div>
                        </div>

                        <div class="card shadow-sm">
                            <div class="card-body p-0">
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle mb-0">
                                        <thead class="table-light">
                                            <tr>
                                                <th>Request ID</th>
                                                <th>Inspection</th>
                                                <th>Amenity</th>
                                                <th>Quantity</th>
                                                <th>Reason</th>
                                                <th>Requested By</th>
                                                <th>Status</th>
                                                <th>Created</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${requests}" var="req">
                                                <tr>
                                                    <td><strong>#${req.requestId}</strong></td>
                                                    <td>
                                                        <a href="<c:url value='/housekeeping/inspection-history'><c:param name='roomId' value='${req.inspectionId}'/></c:url>"
                                                            class="text-decoration-none">
                                                            Inspection #${req.inspectionId}
                                                        </a>
                                                    </td>
                                                    <td>
                                                        <strong>${req.amenity.name}</strong>
                                                        <div class="text-muted small">${req.amenity.description}</div>
                                                    </td>
                                                    <td><span class="badge bg-info">${req.quantityRequested}</span></td>
                                                    <td>
                                                        <div style="max-width: 200px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;"
                                                            title="${req.reason}">
                                                            ${req.reason}
                                                        </div>
                                                    </td>
                                                    <td>${req.requester.fullName}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${req.status == 'PENDING'}">
                                                                <span class="badge bg-warning">Pending</span>
                                                            </c:when>
                                                            <c:when test="${req.status == 'APPROVED'}">
                                                                <span class="badge bg-success">Approved</span>
                                                            </c:when>
                                                            <c:when test="${req.status == 'REJECTED'}">
                                                                <span class="badge bg-danger">Rejected</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-secondary">${req.status}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="small text-muted">${req.createdAt}</td>
                                                    <td>
                                                        <c:if test="${req.status == 'PENDING'}">
                                                            <form method="POST" class="d-inline">
                                                                <input type="hidden" name="requestId"
                                                                    value="${req.requestId}">
                                                                <button type="submit" name="action" value="approve"
                                                                    class="btn btn-sm btn-success"
                                                                    onclick="return confirm('Approve this request?')">
                                                                    <i class="bi bi-check-circle"></i> Approve
                                                                </button>
                                                                <button type="submit" name="action" value="reject"
                                                                    class="btn btn-sm btn-danger"
                                                                    onclick="return confirm('Reject this request?')">
                                                                    <i class="bi bi-x-circle"></i> Reject
                                                                </button>
                                                            </form>
                                                        </c:if>
                                                        <c:if test="${req.status != 'PENDING'}">
                                                            <span class="text-muted small">
                                                                by ${req.approver.fullName}
                                                            </span>
                                                        </c:if>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${empty requests}">
                                                <tr>
                                                    <td colspan="9" class="text-center text-muted py-4">
                                                        No replenishment requests found
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <!-- Pagination Info -->
                            <div class="card-footer bg-white">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div class="text-muted">
                                        Showing ${(currentPage - 1) * pageSize + 1} to ${(currentPage - 1) * pageSize +
                                        requests.size()} of ${totalRequests} requests
                                    </div>
                                    <c:if test="${totalPages > 1}">
                                        <nav>
                                            <ul class="pagination mb-0">
                                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                    <a class="page-link"
                                                        href="?status=${statusFilter}&page=${currentPage - 1}">
                                                        <i class="bi bi-chevron-left"></i>
                                                    </a>
                                                </li>

                                                <c:forEach begin="1" end="${totalPages}" var="i">
                                                    <c:if
                                                        test="${i == 1 || i == totalPages || (i >= currentPage - 2 && i <= currentPage + 2)}">
                                                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                            <a class="page-link"
                                                                href="?status=${statusFilter}&page=${i}">${i}</a>
                                                        </li>
                                                    </c:if>
                                                    <c:if test="${i == 2 && currentPage > 4}">
                                                        <li class="page-item disabled"><span
                                                                class="page-link">...</span></li>
                                                    </c:if>
                                                    <c:if test="${i == totalPages - 1 && currentPage < totalPages - 3}">
                                                        <li class="page-item disabled"><span
                                                                class="page-link">...</span></li>
                                                    </c:if>
                                                </c:forEach>

                                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                                    <a class="page-link"
                                                        href="?status=${statusFilter}&page=${currentPage + 1}">
                                                        <i class="bi bi-chevron-right"></i>
                                                    </a>
                                                </li>
                                            </ul>
                                        </nav>
                                    </c:if>
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