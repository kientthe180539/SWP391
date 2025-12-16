<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>Manager Dashboard | HMS</title>
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
                        <h2 class="mb-4">Manager Dashboard</h2>

                        <div class="row g-4">
                            <div class="col-md-4">
                                <div class="card text-bg-warning text-white h-100">
                                    <div class="card-body">
                                        <h5 class="card-title"><i class="bi bi-exclamation-triangle me-2"></i>Open
                                            Issues</h5>
                                        <h2 class="display-4">${openIssuesCount}</h2>
                                        <a href="<c:url value='/manager/issues'/>"
                                            class="btn btn-light btn-sm mt-2">View Issues</a>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="card text-bg-info text-white h-100">
                                    <div class="card-body">
                                        <h5 class="card-title"><i class="bi bi-bucket me-2"></i>Dirty Rooms</h5>
                                        <h2 class="display-4">${dirtyRoomsCount}</h2>
                                        <a href="<c:url value='/manager/create-task'/>"
                                            class="btn btn-light btn-sm mt-2">Assign Cleaning</a>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="card text-bg-danger text-white h-100">
                                    <div class="card-body">
                                        <h5 class="card-title"><i class="bi bi-box-seam me-2"></i>Pending Requests</h5>
                                        <h2 class="display-4">${pendingReplenishmentCount}</h2>
                                        <a href="<c:url value='/manager/replenishment-requests'/>"
                                            class="btn btn-light btn-sm mt-2">View Requests</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="container-fluid px-4">
                        <div class="row g-4">
                            <!-- Recent Inspections -->
                            <div class="col-md-6">
                                <div class="card shadow-sm h-100">
                                    <div class="card-header bg-white py-3">
                                        <h5 class="mb-0">Recent Inspections</h5>
                                    </div>
                                    <div class="card-body p-0">
                                        <div class="table-responsive">
                                            <table class="table table-hover mb-0">
                                                <thead class="table-light">
                                                    <tr>
                                                        <th>Room</th>
                                                        <th>Type</th>
                                                        <th>Date</th>
                                                        <th>Inspector</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach items="${recentInspections}" var="i">
                                                        <tr>
                                                            <td>
                                                                <a href="<c:url value='/housekeeping/inspection-history'><c:param name='roomId' value='${i.roomId}'/></c:url>"
                                                                    class="text-decoration-none fw-bold">
                                                                    Room ${i.roomId}
                                                                </a>
                                                            </td>
                                                            <td><span class="badge bg-secondary">${i.type}</span></td>
                                                            <td>${i.inspectionDate}</td>
                                                            <td>#${i.inspectorId}</td>
                                                        </tr>
                                                    </c:forEach>
                                                    <c:if test="${empty recentInspections}">
                                                        <tr>
                                                            <td colspan="4" class="text-center text-muted py-3">No
                                                                recent inspections</td>
                                                        </tr>
                                                    </c:if>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Recent Issues -->
                            <div class="col-md-6">
                                <div class="card shadow-sm h-100">
                                    <div class="card-header bg-white py-3">
                                        <h5 class="mb-0">Recent Issues</h5>
                                    </div>
                                    <div class="card-body p-0">
                                        <div class="table-responsive">
                                            <table class="table table-hover mb-0">
                                                <thead class="table-light">
                                                    <tr>
                                                        <th>Room</th>
                                                        <th>Type</th>
                                                        <th>Status</th>
                                                        <th>Action</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach items="${recentIssues}" var="issue">
                                                        <tr>
                                                            <td>Room ${issue.roomId}</td>
                                                            <td>${issue.issueType}</td>
                                                            <td>
                                                                <span
                                                                    class="badge ${issue.status == 'NEW' ? 'bg-danger' : 'bg-success'}">
                                                                    ${issue.status}
                                                                </span>
                                                            </td>
                                                            <td>
                                                                <a href="<c:url value='/manager/issues'/>"
                                                                    class="btn btn-sm btn-outline-primary">View</a>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                    <c:if test="${empty recentIssues}">
                                                        <tr>
                                                            <td colspan="4" class="text-center text-muted py-3">No
                                                                recent issues</td>
                                                        </tr>
                                                    </c:if>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
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