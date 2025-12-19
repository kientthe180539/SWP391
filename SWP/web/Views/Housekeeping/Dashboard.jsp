<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Housekeeping Dashboard | HMS</title>
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                rel="stylesheet">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
            <link rel="stylesheet" href="<c:url value='/CSS/housekeeping.css'/>">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
        </head>

        <body>

            <div class="layout-wrapper">
                <!-- Sidebar -->
                <jsp:include page="../Shared/Sidebar.jsp" />

                <!-- Main Content -->
                <div class="main-content">
                    <!-- Header -->
                    <jsp:include page="../Shared/Header.jsp" />

                    <div class="container-fluid py-4 px-4">
                        <!-- Welcome Section -->
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <div>
                                <h4 class="fw-bold mb-1">Hello, ${sessionScope.currentUser.fullName} 👋</h4>
                                <p class="text-muted mb-0">
                                    <i class="bi bi-calendar3 me-1"></i> Today's Shift:
                                    <span class="fw-medium text-primary">
                                        <c:choose>
                                            <c:when test="${not empty todayAssignments}">
                                                ${todayAssignments[0].shiftType}
                                            </c:when>
                                            <c:otherwise>Not Assigned</c:otherwise>
                                        </c:choose>
                                    </span>
                                </p>
                            </div>
                            <div class="d-flex gap-2">
                                <span class="text-muted"><i class="bi bi-clock"></i> ${today}</span>
                            </div>
                        </div>

                        <!-- KPI Stats Row -->
                        <div class="row g-4 mb-4">
                            <!-- Active Tasks -->
                            <div class="col-md-4">
                                <div class="card h-100 border-0 shadow-sm">
                                    <div class="card-body">
                                        <div class="d-flex align-items-center mb-2">
                                            <div
                                                class="flex-shrink-0 rounded-circle bg-primary bg-opacity-10 p-3 text-primary">
                                                <i class="bi bi-list-task fs-4"></i>
                                            </div>
                                            <div class="ms-3">
                                                <h6 class="text-muted text-uppercase small fw-bold mb-1">Active Tasks
                                                </h6>
                                                <h2 class="mb-0 fw-bold">${pendingCount}</h2>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <!-- Completed Tasks -->
                            <div class="col-md-4">
                                <div class="card h-100 border-0 shadow-sm">
                                    <div class="card-body">
                                        <div class="d-flex align-items-center mb-2">
                                            <div
                                                class="flex-shrink-0 rounded-circle bg-success bg-opacity-10 p-3 text-success">
                                                <i class="bi bi-check-circle-fill fs-4"></i>
                                            </div>
                                            <div class="ms-3">
                                                <h6 class="text-muted text-uppercase small fw-bold mb-1">Completed</h6>
                                                <h2 class="mb-0 fw-bold">${completedCount}</h2>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <!-- Pending Requests -->
                            <div class="col-md-4">
                                <div class="card h-100 border-0 shadow-sm">
                                    <div class="card-body">
                                        <div class="d-flex align-items-center mb-2">
                                            <div
                                                class="flex-shrink-0 rounded-circle bg-warning bg-opacity-10 p-3 text-warning">
                                                <i class="bi bi-box-seam-fill fs-4"></i>
                                            </div>
                                            <div class="ms-3">
                                                <h6 class="text-muted text-uppercase small fw-bold mb-1">Pending
                                                    Requests</h6>
                                                <h2 class="mb-0 fw-bold">${requestCount}</h2>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row g-4">
                            <!-- Left Column: My Tasks -->
                            <div class="col-lg-8">
                                <div class="card h-100 border-0 shadow-sm">
                                    <div
                                        class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                                        <h6 class="mb-0 fw-bold"><i class="bi bi-list-check me-2 text-primary"></i>My
                                            Assigned Tasks</h6>
                                        <a href="<c:url value='/housekeeping/tasks'/>"
                                            class="btn btn-sm btn-light rounded-pill px-3">View All</a>
                                    </div>
                                    <div class="card-body p-0">
                                        <div class="list-group list-group-flush">
                                            <c:if test="${empty todayTasks}">
                                                <div class="text-center py-5 text-muted">
                                                    <i class="bi bi-cup-hot display-6 mb-3 d-block text-secondary"></i>
                                                    <p>You have no tasks assigned for today yet.</p>
                                                </div>
                                            </c:if>
                                            <c:forEach items="${todayTasks}" var="t" end="4">
                                                <div
                                                    class="list-group-item p-3 border-start border-4 ${t.status == 'DONE' ? 'border-success' : (t.status == 'NEW' ? 'border-info' : 'border-warning')}">
                                                    <div class="d-flex justify-content-between align-items-center">
                                                        <div>
                                                            <div class="d-flex align-items-center mb-1">
                                                                <h6 class="mb-0 me-2 text-dark">Room
                                                                    ${hkp.getRoomById(t.roomId).getRoomNumber()}</h6>
                                                                <span
                                                                    class="badge ${t.taskType == 'CLEANING' ? 'bg-secondary' : 'bg-primary'} bg-opacity-75 rounded-pill px-2"
                                                                    style="font-size: 0.7rem;">${t.taskType}</span>
                                                            </div>
                                                            <p class="mb-1 text-muted small">${t.note}</p>
                                                        </div>
                                                        <div class="d-flex flex-column align-items-end gap-2">
                                                            <span
                                                                class="badge ${t.status == 'NEW' ? 'bg-info' : (t.status == 'DONE' ? 'bg-success' : 'bg-warning')} rounded-pill text-white">
                                                                ${t.status}
                                                            </span>
                                                            <a href="<c:url value='/housekeeping/task-detail'><c:param name='id' value='${t.taskId}'/></c:url>"
                                                                class="btn btn-sm btn-outline-primary py-0 px-2"
                                                                style="font-size: 0.8rem;">
                                                                View
                                                            </a>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Right Column: Quick Actions & Requests -->
                            <div class="col-lg-4">
                                <!-- Quick Actions -->
                                <div class="card border-0 shadow-sm mb-4">
                                    <div class="card-header bg-white py-3">
                                        <h6 class="mb-0 fw-bold"><i
                                                class="bi bi-lightning-charge me-2 text-warning"></i>Quick Actions</h6>
                                    </div>
                                    <div class="card-body">
                                        <div class="d-grid gap-2">
                                            <a href="<c:url value='/housekeeping/create-replenishment'/>"
                                                class="btn btn-outline-primary d-flex align-items-center justify-content-between p-3">
                                                <span>Request Supplies</span>
                                                <i class="bi bi-arrow-right"></i>
                                            </a>
                                            <a href="<c:url value='/housekeeping/issue-report'/>"
                                                class="btn btn-outline-danger d-flex align-items-center justify-content-between p-3">
                                                <span>Report Issue</span>
                                                <i class="bi bi-exclamation-triangle"></i>
                                            </a>
                                            <a href="<c:url value='/housekeeping/schedule'/>"
                                                class="btn btn-outline-secondary d-flex align-items-center justify-content-between p-3">
                                                <span>My Schedule</span>
                                                <i class="bi bi-calendar-event"></i>
                                            </a>
                                        </div>
                                    </div>
                                </div>

                                <!-- Recent Supply Requests -->
                                <div class="card border-0 shadow-sm">
                                    <div
                                        class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                                        <h6 class="mb-0 fw-bold"><i
                                                class="bi bi-clock-history me-2 text-info"></i>Recent Requests</h6>
                                        <a href="<c:url value='/housekeeping/supplies'/>"
                                            class="text-decoration-none small">View All</a>
                                    </div>
                                    <div class="card-body p-0">
                                        <ul class="list-group list-group-flush">
                                            <c:if test="${empty myRequests}">
                                                <li class="list-group-item text-center text-muted small py-3">No recent
                                                    requests.</li>
                                            </c:if>
                                            <c:forEach items="${myRequests}" var="req" end="4">
                                                <li class="list-group-item px-3 py-2">
                                                    <div class="d-flex justify-content-between align-items-center">
                                                        <div class="text-truncate me-2">
                                                            <div class="fw-medium small">${req.amenity.name}</div>
                                                            <div class="text-muted" style="font-size: 0.75rem;">Qty:
                                                                ${req.quantityRequested}</div>
                                                        </div>
                                                        <span
                                                            class="badge ${req.status == 'PENDING' ? 'bg-warning' : (req.status == 'APPROVED' ? 'bg-success' : 'bg-danger')} rounded-pill"
                                                            style="font-size: 0.7rem;">
                                                            ${req.status}
                                                        </span>
                                                    </div>
                                                </li>
                                            </c:forEach>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Footer -->
                    <jsp:include page="../Shared/Footer.jsp" />
                </div>
            </div>

            <jsp:include page="../public/notify.jsp" />

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
            <script>
                // Toggle Sidebar on Mobile
                const sidebarToggle = document.getElementById('sidebarToggle');
                const sidebar = document.querySelector('.sidebar');

                if (sidebarToggle) {
                    sidebarToggle.addEventListener('click', () => {
                        sidebar.classList.toggle('show');
                    });
                }
            </script>
        </body>

        </html>