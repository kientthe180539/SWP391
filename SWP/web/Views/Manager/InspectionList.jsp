<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>Inspection History | HMS</title>
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
                        <h2 class="mb-4">Recent Inspections</h2>

                        <!-- Search and Filter Row -->
                        <div class="row g-3 mb-4">
                            <div class="col-md-6">
                                <form method="GET" class="d-flex">
                                    <input type="hidden" name="type" value="${typeFilter}">
                                    <input type="text" class="form-control" name="search"
                                        placeholder="Search by ID, room, inspector, or note..." value="${searchQuery}">
                                    <button type="submit" class="btn btn-primary ms-2">
                                        <i class="bi bi-search"></i> Search
                                    </button>
                                    <c:if test="${not empty searchQuery}">
                                        <a href="?type=${typeFilter}" class="btn btn-secondary ms-2">
                                            <i class="bi bi-x-circle"></i>
                                        </a>
                                    </c:if>
                                </form>
                            </div>
                            <div class="col-md-6">
                                <div class="btn-group w-100">
                                    <a href="?search=${searchQuery}&type=ALL"
                                        class="btn btn-sm ${typeFilter == 'ALL' ? 'btn-primary' : 'btn-outline-primary'}">All</a>
                                    <a href="?search=${searchQuery}&type=CHECKIN"
                                        class="btn btn-sm ${typeFilter == 'CHECKIN' ? 'btn-success' : 'btn-outline-success'}">Check-in</a>
                                    <a href="?search=${searchQuery}&type=CHECKOUT"
                                        class="btn btn-sm ${typeFilter == 'CHECKOUT' ? 'btn-primary' : 'btn-outline-primary'}">Check-out</a>
                                </div>
                            </div>
                        </div>

                        <div class="card shadow-sm">
                            <div class="card-body p-0">
                                <div class="table-responsive">
                                    <table class="table table-hover mb-0 align-middle">
                                        <thead class="table-light">
                                            <tr>
                                                <th>ID</th>
                                                <th>Room</th>
                                                <th>Type</th>
                                                <th>Date</th>
                                                <th>Inspector</th>
                                                <th>Note</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${inspections}" var="i">
                                                <tr>
                                                    <td>#${i.inspectionId}</td>
                                                    <td class="fw-bold">
                                                        <c:choose>
                                                            <c:when test="${not empty i.roomNumber}">Room
                                                                ${i.roomNumber}</c:when>
                                                            <c:otherwise>Room ${i.roomId}</c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <span
                                                            class="badge ${i.type == 'CHECKIN' ? 'bg-success' : 
                                                                   i.type == 'CHECKOUT' ? 'bg-primary' : 
                                                                   i.type == 'SUPPLY' ? 'bg-warning' : 'bg-secondary'}">
                                                            ${i.type}
                                                        </span>
                                                    </td>
                                                    <td>${i.inspectionDate}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty i.inspectorName}">
                                                                ${i.inspectorName}</c:when>
                                                            <c:otherwise>User #${i.inspectorId}</c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="text-truncate" style="max-width: 200px;">${i.note}</td>
                                                    <td>
                                                        <a href="<c:url value='/manager/inspection-detail'><c:param name='id' value='${i.inspectionId}'/></c:url>"
                                                            class="btn btn-sm btn-outline-primary">
                                                            View Details
                                                        </a>
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
                                        inspections.size()} of ${totalInspections} inspections
                                    </div>
                                    <c:if test="${totalPages > 1}">
                                        <nav>
                                            <ul class="pagination mb-0">
                                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                    <a class="page-link"
                                                        href="?search=${searchQuery}&type=${typeFilter}&page=${currentPage - 1}">
                                                        <i class="bi bi-chevron-left"></i>
                                                    </a>
                                                </li>

                                                <c:forEach begin="1" end="${totalPages}" var="i">
                                                    <c:if
                                                        test="${i == 1 || i == totalPages || (i >= currentPage - 2 && i <= currentPage + 2)}">
                                                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                            <a class="page-link"
                                                                href="?search=${searchQuery}&type=${typeFilter}&page=${i}">${i}</a>
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
                                                        href="?search=${searchQuery}&type=${typeFilter}&page=${currentPage + 1}">
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