<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>Supplies | HMS Housekeeping</title>
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
                            <div>
                                <h2 class="mb-1">Supplies & Replenishment</h2>
                                <p class="text-muted mb-0">Manage room supplies and request replenishment.</p>
                            </div>
                            <a href="<c:url value='/housekeeping/create-replenishment'/>" class="btn btn-primary">
                                <i class="bi bi-plus-lg"></i> New Request
                            </a>
                        </div>

                        <div class="card shadow-sm">
                            <div class="card-header bg-white py-3">
                                <h5 class="mb-0">Replenishment Requests</h5>
                            </div>
                            <div class="card-body p-0">
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle mb-0">
                                        <thead class="table-light">
                                            <tr>
                                                <th>ID</th>
                                                <th>Amenity</th>
                                                <th>Quantity</th>
                                                <th>Reason</th>
                                                <th>Requested By</th>
                                                <th>Status</th>
                                                <th>Date</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${requests}" var="req">
                                                <tr>
                                                    <td>#${req.requestId}</td>
                                                    <td>
                                                        <strong>${req.amenity.name}</strong>
                                                        <div class="text-muted small">${req.amenity.description}</div>
                                                    </td>
                                                    <td><span class="badge bg-info">${req.quantityRequested}</span></td>
                                                    <td>${req.reason}</td>
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
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${empty requests}">
                                                <tr>
                                                    <td colspan="7" class="text-center text-muted py-4">
                                                        No replenishment requests found.
                                                    </td>
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