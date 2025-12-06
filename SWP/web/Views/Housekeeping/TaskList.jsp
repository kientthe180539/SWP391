<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Task List | HMS Housekeeping</title>
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                rel="stylesheet">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
            <link rel="stylesheet" href="<c:url value='/CSS/housekeeping.css'/>">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
        </head>

        <body>

            <div class="layout-wrapper">
                <jsp:include page="../Shared/Sidebar.jsp" />

                <div class="main-content">
                    <jsp:include page="../Shared/Header.jsp" />

                    <div class="container-fluid py-4 px-4">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <div>
                                <h2 class="mb-1">My Tasks</h2>
                                <p class="text-muted mb-0">Manage your cleaning assignments.</p>
                            </div>
                        </div>

                        <div class="card shadow-sm">
                            <div class="card-header bg-white py-3">
                                <form action="<c:url value='/housekeeping/tasks'/>" method="get">
                                    <div class="row g-3">
                                        <div class="col-md-3">
                                            <div class="input-group input-group-sm">
                                                <span class="input-group-text bg-light border-end-0"><i
                                                        class="bi bi-search"></i></span>
                                                <input type="text" name="search" class="form-control border-start-0"
                                                    placeholder="Search note, room..." value="${search}">
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <select name="status" class="form-select form-select-sm">
                                                <option value="">All Status</option>
                                                <option value="NEW" ${status=='NEW' ? 'selected' : '' }>New</option>
                                                <option value="IN_PROGRESS" ${status=='IN_PROGRESS' ? 'selected' : '' }>
                                                    In Progress</option>
                                                <option value="DONE" ${status=='DONE' ? 'selected' : '' }>Done</option>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <input type="date" name="dateFrom" class="form-control form-control-sm"
                                                value="${dateFrom}" placeholder="From Date">
                                        </div>
                                        <div class="col-md-2">
                                            <input type="date" name="dateTo" class="form-control form-control-sm"
                                                value="${dateTo}" placeholder="To Date">
                                        </div>
                                        <div class="col-md-2">
                                            <select name="sortBy" class="form-select form-select-sm">
                                                <option value="task_date" ${sortBy=='task_date' ? 'selected' : '' }>Sort
                                                    by Date</option>
                                                <option value="roomId" ${sortBy=='roomId' ? 'selected' : '' }>Sort by
                                                    Room</option>
                                                <option value="status" ${sortBy=='status' ? 'selected' : '' }>Sort by
                                                    Status</option>
                                            </select>
                                        </div>
                                        <div class="col-md-1">
                                            <button type="submit" class="btn btn-sm btn-primary w-100">Filter</button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                            <div class="card-body p-0">
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle mb-0">
                                        <thead class="bg-light">
                                            <tr>
                                                <th class="ps-4">#</th>
                                                <th>Room</th>
                                                <th>Date</th>
                                                <th>Type</th>
                                                <th>Status</th>
                                                <th>Note</th>
                                                <th class="text-end pe-4">Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:if test="${empty tasks}">
                                                <tr>
                                                    <td colspan="7" class="text-center py-5 text-muted">
                                                        <i class="bi bi-inbox fs-1 d-block mb-2"></i>
                                                        No tasks found matching your criteria.
                                                    </td>
                                                </tr>
                                            </c:if>
                                            <c:forEach items="${tasks}" var="t" varStatus="st">
                                                <tr>
                                                    <td class="ps-4 text-muted">${(currentPage - 1) * 10 + st.index + 1}
                                                    </td>
                                                    <td>
                                                        <span class="fw-bold text-primary">#${t.roomId}</span>
                                                    </td>
                                                    <td>${t.taskDate}</td>
                                                    <td><span
                                                            class="badge bg-light text-dark border">${t.taskType}</span>
                                                    </td>
                                                    <td>
                                                        <span
                                                            class="badge ${t.status == 'NEW' ? 'bg-info' : (t.status == 'DONE' ? 'bg-success' : 'bg-warning')}">
                                                            ${t.status}
                                                        </span>
                                                    </td>
                                                    <td class="text-muted small text-truncate"
                                                        style="max-width: 200px;">${t.note}</td>
                                                    <td class="text-end pe-4">
                                                        <a href="<c:url value='/housekeeping/task-detail'><c:param name='id' value='${t.taskId}'/></c:url>"
                                                            class="btn btn-sm btn-outline-primary">
                                                            Details
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            <div class="card-footer bg-white py-3">
                                <nav class="d-flex justify-content-between align-items-center">
                                    <small class="text-muted">Showing ${tasks.size()} of ${totalTasks} tasks</small>
                                    <ul class="pagination pagination-sm mb-0">
                                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                            <a class="page-link"
                                                href="?page=${currentPage - 1}&search=${search}&status=${status}&dateFrom=${dateFrom}&dateTo=${dateTo}&sortBy=${sortBy}">Previous</a>
                                        </li>
                                        <c:forEach begin="1" end="${totalPages}" var="p">
                                            <li class="page-item ${currentPage == p ? 'active' : ''}">
                                                <a class="page-link"
                                                    href="?page=${p}&search=${search}&status=${status}&dateFrom=${dateFrom}&dateTo=${dateTo}&sortBy=${sortBy}">${p}</a>
                                            </li>
                                        </c:forEach>
                                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                            <a class="page-link"
                                                href="?page=${currentPage + 1}&search=${search}&status=${status}&dateFrom=${dateFrom}&dateTo=${dateTo}&sortBy=${sortBy}">Next</a>
                                        </li>
                                    </ul>
                                </nav>
                            </div>
                        </div>
                    </div>

                    <jsp:include page="../Shared/Footer.jsp" />
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>