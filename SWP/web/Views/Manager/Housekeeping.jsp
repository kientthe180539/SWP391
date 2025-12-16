<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>Housekeeping Management | HMS</title>
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
                                <h2 class="mb-1">Housekeeping Management</h2>
                                <p class="text-muted mb-0">Overview of housekeeping tasks, supplies, and inspections.
                                </p>
                            </div>
                            <a href="<c:url value='/manager/create-task'/>" class="btn btn-primary">
                                <i class="bi bi-plus-lg"></i> Assign Task
                            </a>
                        </div>

                        <div class="row g-4">
                            <!-- Quick Stats -->
                            <div class="col-md-4">
                                <div class="card shadow-sm border-0 h-100">
                                    <div class="card-body">
                                        <div class="d-flex align-items-center mb-3">
                                            <div
                                                class="icon-box bg-warning bg-opacity-10 text-warning rounded-circle p-3 me-3">
                                                <i class="bi bi-bucket fs-4"></i>
                                            </div>
                                            <div>
                                                <h6 class="card-subtitle text-muted">Dirty Rooms</h6>
                                                <h3 class="card-title mb-0">${roomsNeedCleaning.size()}</h3>
                                            </div>
                                        </div>
                                        <a href="<c:url value='/manager/rooms?status=DIRTY'/>"
                                            class="btn btn-sm btn-outline-warning w-100">View Dirty Rooms</a>
                                    </div>
                                </div>
                            </div>

                            <!-- Navigation Cards -->
                            <div class="col-md-4">
                                <div class="card shadow-sm border-0 h-100">
                                    <div class="card-body">
                                        <h5 class="card-title"><i class="bi bi-clipboard-check me-2"></i>Inspections
                                        </h5>
                                        <p class="text-muted small">Manage room inspections and verify cleaning quality.
                                        </p>
                                        <div class="d-grid gap-2">
                                            <a href="<c:url value='/manager/inspections'/>"
                                                class="btn btn-outline-primary">View Inspections</a>
                                            <a href="<c:url value='/manager/create-inspection'/>"
                                                class="btn btn-outline-secondary">Create Inspection</a>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-4">
                                <div class="card shadow-sm border-0 h-100">
                                    <div class="card-body">
                                        <h5 class="card-title"><i class="bi bi-box-seam me-2"></i>Supplies</h5>
                                        <p class="text-muted small">Manage replenishment requests and inventory.</p>
                                        <div class="d-grid gap-2">
                                            <a href="<c:url value='/manager/replenishment-requests'/>"
                                                class="btn btn-outline-primary">Replenishment Requests</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Recent Activity or List could go here -->
                        <div class="card shadow-sm mt-4">
                            <div class="card-header bg-white py-3">
                                <h5 class="mb-0">Rooms Needing Attention</h5>
                            </div>
                            <div class="card-body p-0">
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle mb-0">
                                        <thead class="table-light">
                                            <tr>
                                                <th>Room</th>
                                                <th>Status</th>
                                                <th>Floor</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${roomsNeedCleaning}" var="r" end="5">
                                                <tr>
                                                    <td><strong>${r.roomNumber}</strong></td>
                                                    <td><span class="badge bg-danger">${r.status}</span></td>
                                                    <td>${r.floor}</td>
                                                    <td>
                                                        <a href="<c:url value='/manager/create-task?roomId=${r.roomId}'/>"
                                                            class="btn btn-sm btn-primary">Assign Cleaning</a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${empty roomsNeedCleaning}">
                                                <tr>
                                                    <td colspan="4" class="text-center text-muted py-4">All rooms are
                                                        clean!</td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            <c:if test="${not empty roomsNeedCleaning}">
                                <div class="card-footer bg-white text-center">
                                    <a href="<c:url value='/manager/rooms?status=DIRTY'/>"
                                        class="text-decoration-none">View All</a>
                                </div>
                            </c:if>
                        </div>

                    </div>

                    <jsp:include page="../Shared/Footer.jsp" />
                </div>
            </div>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>