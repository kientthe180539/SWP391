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
                        <div class="card shadow-sm">
                            <div class="card-header bg-white py-3">
                                <h5 class="mb-0"><i class="bi bi-tools me-2"></i>Reported Issues</h5>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle">
                                        <thead class="table-light">
                                            <tr>
                                                <th>ID</th>
                                                <th>Room</th>
                                                <th>Type</th>
                                                <th>Description</th>
                                                <th>Status</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${issues}" var="i">
                                                <tr>
                                                    <td>#${i.issueId}</td>
                                                    <td>${i.roomNumber}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${i.issueType == 'CONFIRMATION'}">
                                                                <span
                                                                    class="badge text-bg-info text-white">CONFIRMATION</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                ${i.issueType}
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>${i.description}</td>
                                                    <td>
                                                        <span
                                                            class="badge rounded-pill 
                                                    ${i.status == 'NEW' ? 'text-bg-danger' : 
                                                      i.status == 'RESOLVED' ? 'text-bg-success' : 'text-bg-secondary'}">
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
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <!-- Pagination Info -->
                            <div class="card-footer bg-white">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div class="text-muted">
                                        Showing ${(currentPage - 1) * pageSize + 1} to ${(currentPage - 1) * pageSize +
                                        issues.size()} of ${totalIssues} issues
                                    </div>
                                    <c:if test="${totalPages > 1}">
                                        <nav>
                                            <ul class="pagination mb-0">
                                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                    <a class="page-link" href="?page=${currentPage - 1}">
                                                        <i class="bi bi-chevron-left"></i>
                                                    </a>
                                                </li>

                                                <c:forEach begin="1" end="${totalPages}" var="i">
                                                    <c:if
                                                        test="${i == 1 || i == totalPages || (i >= currentPage - 2 && i <= currentPage + 2)}">
                                                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                            <a class="page-link" href="?page=${i}">${i}</a>
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
                                                    <a class="page-link" href="?page=${currentPage + 1}">
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