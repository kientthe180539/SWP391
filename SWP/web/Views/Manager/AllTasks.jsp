<%@page contentType="text/html" pageEncoding="UTF-8" import="Model.*,java.util.List,java.time.LocalDate" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>
                <c:choose>
                    <c:when test="${not empty selectedStaffName}">Tasks - ${selectedStaffName}</c:when>
                    <c:otherwise>All Tasks Overview</c:otherwise>
                </c:choose> | HMS Manager
            </title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                rel="stylesheet">
            <link rel="stylesheet" href="<c:url value='/CSS/housekeeping.css'/>">
            <style>
                /* Page Header */
                .page-header {
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    border-radius: 16px;
                    padding: 2rem;
                    color: white;
                    margin-bottom: 1.5rem;
                    position: relative;
                    overflow: hidden;
                }

                .page-header::before {
                    content: '';
                    position: absolute;
                    top: -50%;
                    right: -20%;
                    width: 400px;
                    height: 400px;
                    background: rgba(255, 255, 255, 0.1);
                    border-radius: 50%;
                }

                .page-header h2 {
                    color: white;
                    font-weight: 700;
                    margin: 0;
                    position: relative;
                    z-index: 1;
                }

                .page-header .subtitle {
                    color: rgba(255, 255, 255, 0.8);
                    font-size: 0.95rem;
                    margin-top: 0.5rem;
                }

                .btn-create {
                    background: rgba(255, 255, 255, 0.2);
                    border: 2px solid rgba(255, 255, 255, 0.3);
                    color: white;
                    padding: 0.6rem 1.5rem;
                    border-radius: 10px;
                    font-weight: 600;
                    transition: all 0.3s ease;
                    backdrop-filter: blur(10px);
                }

                .btn-create:hover {
                    background: white;
                    color: #667eea;
                    border-color: white;
                    transform: translateY(-2px);
                }

                /* Filter Card */
                .filter-card {
                    background: white;
                    border: none;
                    border-radius: 16px;
                    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
                    padding: 1.5rem;
                    margin-bottom: 1.5rem;
                }

                .filter-card .form-label {
                    font-weight: 600;
                    color: #374151;
                    font-size: 0.85rem;
                    text-transform: uppercase;
                    letter-spacing: 0.5px;
                    margin-bottom: 0.5rem;
                }

                .filter-card .form-control,
                .filter-card .form-select {
                    border: 2px solid #e5e7eb;
                    border-radius: 10px;
                    padding: 0.7rem 1rem;
                    transition: all 0.3s ease;
                }

                .filter-card .form-control:focus,
                .filter-card .form-select:focus {
                    border-color: #667eea;
                    box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
                }

                .btn-filter {
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    border: none;
                    padding: 0.7rem 2rem;
                    border-radius: 10px;
                    font-weight: 600;
                    color: white;
                    transition: all 0.3s ease;
                }

                .btn-filter:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 8px 20px rgba(102, 126, 234, 0.4);
                    color: white;
                }

                .btn-reset {
                    background: #f3f4f6;
                    border: none;
                    padding: 0.7rem 1.5rem;
                    border-radius: 10px;
                    font-weight: 500;
                    color: #6b7280;
                    transition: all 0.3s ease;
                }

                .btn-reset:hover {
                    background: #e5e7eb;
                    color: #374151;
                }

                /* Table Card */
                .table-card {
                    background: white;
                    border: none;
                    border-radius: 16px;
                    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
                    overflow: hidden;
                }

                .table-card .table {
                    margin: 0;
                }

                .table-card thead {
                    background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
                }

                .table-card thead th {
                    border: none;
                    padding: 1rem 1.25rem;
                    font-weight: 700;
                    color: #374151;
                    text-transform: uppercase;
                    font-size: 0.75rem;
                    letter-spacing: 0.5px;
                }

                .table-card tbody tr {
                    transition: all 0.3s ease;
                    border-bottom: 1px solid #f1f5f9;
                }

                .table-card tbody tr:hover {
                    background: linear-gradient(135deg, #faf5ff 0%, #f5f3ff 100%);
                    transform: scale(1.005);
                }

                .table-card tbody td {
                    padding: 1rem 1.25rem;
                    vertical-align: middle;
                    border: none;
                }

                /* Task ID */
                .task-id {
                    font-weight: 700;
                    color: #667eea;
                    font-size: 0.9rem;
                }

                /* Room Badge */
                .room-badge {
                    display: inline-flex;
                    align-items: center;
                    gap: 0.5rem;
                    background: linear-gradient(135deg, #dbeafe 0%, #e0e7ff 100%);
                    color: #3730a3;
                    padding: 0.5rem 1rem;
                    border-radius: 8px;
                    font-weight: 600;
                    font-size: 0.9rem;
                }

                .room-badge i {
                    font-size: 1rem;
                }

                /* Task Type Badge */
                .type-badge {
                    padding: 0.5rem 1rem;
                    border-radius: 8px;
                    font-weight: 600;
                    font-size: 0.8rem;
                    text-transform: uppercase;
                    letter-spacing: 0.5px;
                }

                .type-cleaning {
                    background: linear-gradient(135deg, #dbeafe 0%, #bfdbfe 100%);
                    color: #1e40af;
                }

                .type-inspection {
                    background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
                    color: #92400e;
                }

                .type-checkin {
                    background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%);
                    color: #065f46;
                }

                .type-checkout {
                    background: linear-gradient(135deg, #fce7f3 0%, #fbcfe8 100%);
                    color: #9d174d;
                }

                /* Staff Info */
                .staff-info {
                    display: flex;
                    align-items: center;
                    gap: 0.75rem;
                }

                .staff-avatar {
                    width: 36px;
                    height: 36px;
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    color: white;
                    border-radius: 10px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-weight: 700;
                    font-size: 0.85rem;
                }

                .staff-name {
                    font-weight: 500;
                    color: #374151;
                }

                /* Date */
                .task-date {
                    display: flex;
                    align-items: center;
                    gap: 0.5rem;
                    color: #6b7280;
                    font-weight: 500;
                }

                .task-date i {
                    color: #9ca3af;
                }

                /* Note */
                .task-note {
                    max-width: 180px;
                    color: #6b7280;
                    font-size: 0.9rem;
                    overflow: hidden;
                    text-overflow: ellipsis;
                    white-space: nowrap;
                }

                /* Status Badge */
                .status-badge {
                    padding: 0.5rem 1rem;
                    border-radius: 50px;
                    font-weight: 600;
                    font-size: 0.8rem;
                    display: inline-flex;
                    align-items: center;
                    gap: 0.4rem;
                }

                .status-new {
                    background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
                    color: #92400e;
                }

                .status-in-progress {
                    background: linear-gradient(135deg, #dbeafe 0%, #93c5fd 100%);
                    color: #1e40af;
                }

                .status-done {
                    background: linear-gradient(135deg, #d1fae5 0%, #6ee7b7 100%);
                    color: #065f46;
                }

                .status-badge i {
                    font-size: 0.7rem;
                }

                /* Empty State */
                .empty-state {
                    text-align: center;
                    padding: 4rem 2rem;
                }

                .empty-state-icon {
                    width: 100px;
                    height: 100px;
                    background: linear-gradient(135deg, #f3f4f6 0%, #e5e7eb 100%);
                    border-radius: 50%;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    margin: 0 auto 1.5rem;
                }

                .empty-state-icon i {
                    font-size: 2.5rem;
                    color: #9ca3af;
                }

                .empty-state h5 {
                    color: #374151;
                    font-weight: 600;
                    margin-bottom: 0.5rem;
                }

                .empty-state p {
                    color: #9ca3af;
                    margin: 0;
                }

                /* Pagination */
                .pagination-wrapper {
                    padding: 1.5rem;
                    background: #f8fafc;
                    border-top: 1px solid #e5e7eb;
                }

                .pagination .page-link {
                    border: none;
                    padding: 0.6rem 1rem;
                    margin: 0 0.2rem;
                    border-radius: 8px;
                    color: #667eea;
                    font-weight: 500;
                    transition: all 0.3s ease;
                }

                .pagination .page-link:hover {
                    background: #e0e7ff;
                    color: #667eea;
                }

                .pagination .page-item.active .page-link {
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    color: white;
                }

                .pagination .page-item.disabled .page-link {
                    color: #9ca3af;
                    background: transparent;
                }

                /* Stats Summary */
                .stats-summary {
                    display: flex;
                    gap: 1rem;
                    margin-top: 1rem;
                }

                .stat-item {
                    display: flex;
                    align-items: center;
                    gap: 0.5rem;
                    padding: 0.5rem 1rem;
                    background: rgba(255, 255, 255, 0.2);
                    border-radius: 8px;
                    font-size: 0.9rem;
                }

                .stat-item i {
                    font-size: 1.1rem;
                }

                /* Animations */
                @keyframes fadeInUp {
                    from {
                        opacity: 0;
                        transform: translateY(20px);
                    }

                    to {
                        opacity: 1;
                        transform: translateY(0);
                    }
                }

                .page-header,
                .filter-card,
                .table-card {
                    animation: fadeInUp 0.5s ease forwards;
                }

                .filter-card {
                    animation-delay: 0.1s;
                }

                .table-card {
                    animation-delay: 0.2s;
                }
            </style>
        </head>

        <body>
            <div class="layout-wrapper">
                <jsp:include page="../Shared/Sidebar.jsp" />
                <div class="main-content">
                    <jsp:include page="../Shared/Header.jsp" />

                    <div class="container-fluid p-4">
                        <!-- Page Header -->
                        <div class="page-header">
                            <div class="d-flex justify-content-between align-items-start">
                                <div>
                                    <h2>
                                        <c:choose>
                                            <c:when test="${not empty selectedStaffName}">
                                                <i class="bi bi-person-badge me-2"></i>${selectedStaffName}'s Tasks
                                            </c:when>
                                            <c:otherwise>
                                                <i class="bi bi-clipboard-check me-2"></i>All Tasks Overview
                                            </c:otherwise>
                                        </c:choose>
                                    </h2>
                                    <p class="subtitle mb-0">
                                        <c:choose>
                                            <c:when test="${not empty selectedStaffName}">
                                                View and manage all tasks assigned to this staff member
                                            </c:when>
                                            <c:otherwise>
                                                Monitor and manage all housekeeping tasks across your property
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                    <div class="stats-summary">
                                        <div class="stat-item">
                                            <i class="bi bi-list-task"></i>
                                            <span><strong>${totalTasks}</strong> Total Tasks</span>
                                        </div>
                                    </div>
                                </div>
                                <c:if test="${empty selectedStaffName}">
                                    <a href="<c:url value='/manager/create-task'/>" class="btn btn-create">
                                        <i class="bi bi-plus-lg me-2"></i>Create Task
                                    </a>
                                </c:if>
                            </div>
                        </div>

                        <!-- Filters -->
                        <div class="filter-card">
                            <form action="<c:url value='/manager/all-tasks'/>" method="get">
                                <div class="row g-3 align-items-end">
                                    <div class="col-md-3">
                                        <label class="form-label"><i class="bi bi-search me-1"></i>Search</label>
                                        <input type="text" name="search" class="form-control"
                                            placeholder="Search by note or room..." value="${search}">
                                    </div>
                                    <c:choose>
                                        <c:when test="${staffId > 0}">
                                            <input type="hidden" name="staffId" value="${staffId}">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="col-md-2">
                                                <label class="form-label"><i class="bi bi-person me-1"></i>Staff</label>
                                                <select name="staffId" class="form-select">
                                                    <option value="0">All Staff</option>
                                                    <c:forEach items="${staffList}" var="s">
                                                        <option value="${s.userId}" ${staffId eq s.userId ? 'selected'
                                                            : '' }>
                                                            ${s.fullName}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="col-md-2">
                                        <label class="form-label"><i class="bi bi-flag me-1"></i>Status</label>
                                        <select name="status" class="form-select">
                                            <option value="">All Statuses</option>
                                            <option value="NEW" ${status eq 'NEW' ? 'selected' : '' }>New</option>
                                            <option value="IN_PROGRESS" ${status eq 'IN_PROGRESS' ? 'selected' : '' }>In
                                                Progress</option>
                                            <option value="DONE" ${status eq 'DONE' ? 'selected' : '' }>Done</option>
                                        </select>
                                    </div>
                                    <div class="col-md-2">
                                        <label class="form-label"><i class="bi bi-tag me-1"></i>Type</label>
                                        <select name="type" class="form-select">
                                            <option value="">All Types</option>
                                            <option value="CLEANING" ${type eq 'CLEANING' ? 'selected' : '' }>Cleaning
                                            </option>
                                            <option value="INSPECTION_ALL" ${type eq 'INSPECTION_ALL' ? 'selected' : ''
                                                }>All Inspections</option>
                                            <option value="CHECKIN" ${type eq 'CHECKIN' ? 'selected' : '' }>Check-in
                                            </option>
                                            <option value="CHECKOUT" ${type eq 'CHECKOUT' ? 'selected' : '' }>Check-out
                                            </option>
                                        </select>
                                    </div>
                                    <div class="col-md-2">
                                        <label class="form-label"><i class="bi bi-calendar me-1"></i>From</label>
                                        <input type="date" name="dateFrom" class="form-control" value="${dateFrom}">
                                    </div>
                                    <div class="col-md-2">
                                        <label class="form-label"><i class="bi bi-calendar me-1"></i>To</label>
                                        <input type="date" name="dateTo" class="form-control" value="${dateTo}">
                                    </div>
                                    <div class="col-md-auto">
                                        <div class="d-flex gap-2">
                                            <button type="submit" class="btn btn-filter">
                                                <i class="bi bi-funnel me-1"></i>Apply
                                            </button>
                                            <a href="<c:url value='/manager/all-tasks'/>${staffId > 0 ? '?staffId='.concat(staffId) : ''}"
                                                class="btn btn-reset">
                                                <i class="bi bi-x-circle me-1"></i>Reset
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>

                        <!-- Tasks Table -->
                        <div class="card table-card">
                            <div class="card-body p-0">
                                <div class="table-responsive">
                                    <table class="table table-hover mb-0">
                                        <thead>
                                            <tr>
                                                <th>ID</th>
                                                <th>Room</th>
                                                <th>Type</th>
                                                <c:if test="${staffId == 0 || staffId == null}">
                                                    <th>Assigned To</th>
                                                </c:if>
                                                <th>Date</th>
                                                <th>Note</th>
                                                <th>Status</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${tasks}" var="t">
                                                <tr>
                                                    <td><span class="task-id">#${t.taskId}</span></td>
                                                    <td>
                                                        <span class="room-badge">
                                                            <i class="bi bi-door-open"></i>
                                                            ${t.roomNumber}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <span
                                                            class="type-badge 
                                                    ${t.taskType.name() eq 'CLEANING' ? 'type-cleaning' : 
                                                      t.taskType.name() eq 'CHECKIN' ? 'type-checkin' : 
                                                      t.taskType.name() eq 'CHECKOUT' ? 'type-checkout' : 'type-inspection'}">
                                                            <c:choose>
                                                                <c:when test="${t.taskType.name() eq 'CLEANING'}">
                                                                    <i class="bi bi-droplet-fill me-1"></i>
                                                                </c:when>
                                                                <c:when test="${t.taskType.name() eq 'CHECKIN'}">
                                                                    <i class="bi bi-box-arrow-in-right me-1"></i>
                                                                </c:when>
                                                                <c:when test="${t.taskType.name() eq 'CHECKOUT'}">
                                                                    <i class="bi bi-box-arrow-right me-1"></i>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <i class="bi bi-clipboard-check me-1"></i>
                                                                </c:otherwise>
                                                            </c:choose>
                                                            ${t.taskType}
                                                        </span>
                                                    </td>
                                                    <c:if test="${staffId == 0 || staffId == null}">
                                                        <td>
                                                            <div class="staff-info">
                                                                <div class="staff-avatar">
                                                                    ${t.assignedToName.substring(0, 1).toUpperCase()}
                                                                </div>
                                                                <span class="staff-name">${t.assignedToName}</span>
                                                            </div>
                                                        </td>
                                                    </c:if>
                                                    <td>
                                                        <div class="task-date">
                                                            <i class="bi bi-calendar3"></i>
                                                            ${t.taskDate}
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <span class="task-note" title="${t.note}">
                                                            ${t.note}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <span
                                                            class="status-badge 
                                                    ${t.status.name() eq 'DONE' ? 'status-done' : 
                                                      t.status.name() eq 'IN_PROGRESS' ? 'status-in-progress' : 'status-new'}">
                                                            <c:choose>
                                                                <c:when test="${t.status.name() eq 'DONE'}">
                                                                    <i class="bi bi-check-circle-fill"></i>
                                                                </c:when>
                                                                <c:when test="${t.status.name() eq 'IN_PROGRESS'}">
                                                                    <i class="bi bi-arrow-repeat"></i>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <i class="bi bi-circle"></i>
                                                                </c:otherwise>
                                                            </c:choose>
                                                            ${t.status}
                                                        </span>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${empty tasks}">
                                                <tr>
                                                    <td colspan="${staffId > 0 ? 6 : 7}">
                                                        <div class="empty-state">
                                                            <div class="empty-state-icon">
                                                                <i class="bi bi-clipboard-x"></i>
                                                            </div>
                                                            <h5>No Tasks Found</h5>
                                                            <p>There are no tasks matching your current filters.</p>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <!-- Pagination -->
                            <c:if test="${totalPages > 1}">
                                <div class="pagination-wrapper">
                                    <nav aria-label="Page navigation">
                                        <ul class="pagination justify-content-center mb-0">
                                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                <a class="page-link"
                                                    href="?page=${currentPage - 1}&staffId=${staffId}&status=${status}&type=${type}&search=${search}&dateFrom=${dateFrom}&dateTo=${dateTo}">
                                                    <i class="bi bi-chevron-left"></i> Previous
                                                </a>
                                            </li>

                                            <c:forEach begin="1" end="${totalPages}" var="i">
                                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                    <a class="page-link"
                                                        href="?page=${i}&staffId=${staffId}&status=${status}&type=${type}&search=${search}&dateFrom=${dateFrom}&dateTo=${dateTo}">${i}</a>
                                                </li>
                                            </c:forEach>

                                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                                <a class="page-link"
                                                    href="?page=${currentPage + 1}&staffId=${staffId}&status=${status}&type=${type}&search=${search}&dateFrom=${dateFrom}&dateTo=${dateTo}">
                                                    Next <i class="bi bi-chevron-right"></i>
                                                </a>
                                            </li>
                                        </ul>
                                    </nav>
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