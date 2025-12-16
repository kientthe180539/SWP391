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
                        <!-- Dashboard Content -->
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <div>
                                <h2 class="mb-1">Dashboard</h2>
                                <p class="text-muted mb-0">Overview of today's activities.</p>
                            </div>

                        </div>

                        <!-- KPI Cards -->
                        <div class="row g-4 mb-4">
                            <div class="col-md-4">
                                <div class="card h-100 border-start border-4 border-danger">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between align-items-start">
                                            <div>
                                                <p class="text-muted small text-uppercase fw-bold mb-1">Rooms Dirty</p>
                                                <h3 class="mb-0">${roomsNeedCleaning.size()}</h3>
                                            </div>
                                            <div class="p-2 bg-danger bg-opacity-10 rounded-circle text-danger">
                                                <i class="bi bi-bucket-fill fs-4"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="card h-100 border-start border-4 border-primary">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between align-items-start">
                                            <div>
                                                <p class="text-muted small text-uppercase fw-bold mb-1">My Tasks</p>
                                                <h3 class="mb-0">${todayTasks.size()}</h3>
                                            </div>
                                            <div class="p-2 bg-primary bg-opacity-10 rounded-circle text-primary">
                                                <i class="bi bi-check2-square fs-4"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="card h-100 border-start border-4 border-success">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between align-items-start">
                                            <div>
                                                <p class="text-muted small text-uppercase fw-bold mb-1">Shift</p>
                                                <h3 class="mb-0">
                                                    <c:choose>
                                                        <c:when test="${not empty todayAssignments}">
                                                            ${todayAssignments[0].shiftType}
                                                        </c:when>
                                                        <c:otherwise>Off</c:otherwise>
                                                    </c:choose>
                                                </h3>
                                            </div>
                                            <div class="p-2 bg-success bg-opacity-10 rounded-circle text-success">
                                                <i class="bi bi-clock-history fs-4"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row g-4">
                            <!-- Rooms Needing Attention -->
                            <div class="col-lg-8">
                                <div class="card h-100">
                                    <div class="card-header">
                                        <span><i class="bi bi-house-exclamation me-2"></i>Rooms Needing Attention</span>
                                    </div>
                                    <div class="card-body p-0">
                                        <div class="table-responsive">
                                            <table class="table table-hover align-middle mb-0">
                                                <thead class="bg-light">
                                                    <tr>
                                                        <th>Room</th>
                                                        <th>Floor</th>
                                                        <th>Status</th>
                                                        <th class="text-end">Action</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:if test="${empty roomsNeedCleaning}">
                                                        <tr>
                                                            <td colspan="4" class="text-center py-4 text-muted">
                                                                <i class="bi bi-stars fs-1 d-block mb-2"></i>
                                                                All rooms are clean!
                                                            </td>
                                                        </tr>
                                                    </c:if>
                                                    <c:forEach items="${roomsNeedCleaning}" var="r">
                                                        <tr>
                                                            <td class="fw-bold text-primary">#${r.roomNumber}</td>
                                                            <td>${r.floor}</td>
                                                            <td>
                                                                <span
                                                                    class="badge ${r.status == 'DIRTY' ? 'bg-status-dirty' : (r.status == 'CLEANING' ? 'bg-status-cleaning' : 'bg-secondary')}">
                                                                    ${r.status}
                                                                </span>
                                                            </td>
                                                            <td class="text-end">
                                                                <a href="<c:url value='/housekeeping/room-update'><c:param name='roomId' value='${r.roomId}'/></c:url>"
                                                                    class="btn btn-sm btn-outline-secondary">
                                                                    Update
                                                                </a>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Today's Tasks -->
                            <div class="col-lg-4">
                                <div class="card h-100">
                                    <div class="card-header">
                                        <span><i class="bi bi-list-check me-2"></i>My Tasks</span>
                                    </div>
                                    <div class="card-body p-0">
                                        <div class="list-group list-group-flush">
                                            <c:if test="${empty todayTasks}">
                                                <div class="text-center py-4 text-muted">
                                                    <i class="bi bi-cup-hot fs-1 d-block mb-2"></i>
                                                    No tasks assigned.
                                                </div>
                                            </c:if>
                                            <c:forEach items="${todayTasks}" var="t">
                                                <a href="<c:url value='/housekeeping/task-detail'><c:param name='id' value='${t.taskId}'/></c:url>"
                                                    class="list-group-item list-group-item-action p-3">
                                                    <div
                                                        class="d-flex w-100 justify-content-between align-items-center mb-1">
                                                        <h6 class="mb-0 text-primary">Room ${t.roomId}</h6>
                                                        <small class="text-muted">${t.taskType}</small>
                                                    </div>
                                                    <p class="mb-1 text-truncate text-muted small">${t.note}</p>
                                                    <div class="mt-2">
                                                        <span
                                                            class="badge ${t.status == 'NEW' ? 'bg-info' : (t.status == 'DONE' ? 'bg-success' : 'bg-warning')}">
                                                            ${t.status}
                                                        </span>
                                                    </div>
                                                </a>
                                            </c:forEach>
                                        </div>
                                    </div>
                                    <div class="card-footer bg-white text-center border-top-0 py-3">
                                        <a href="<c:url value='/housekeeping/tasks'/>"
                                            class="text-decoration-none fw-bold small">View All <i
                                                class="bi bi-arrow-right"></i></a>
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