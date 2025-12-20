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
                                <h2 class="mb-1">
                                    <c:choose>
                                        <c:when test="${param.type == 'CLEANING'}">Cleaning Tasks</c:when>
                                        <c:when test="${param.type == 'INSPECTION'}">Inspection Tasks</c:when>
                                        <c:when test="${param.status == 'DONE'}">Task History</c:when>
                                        <c:otherwise>My Tasks</c:otherwise>
                                    </c:choose>
                                </h2>
                                <p class="text-muted mb-0">
                                    <c:choose>
                                        <c:when test="${param.type == 'CLEANING'}">Manage your daily cleaning
                                            assignments.</c:when>
                                        <c:when test="${param.type == 'INSPECTION'}">Perform room inspections and
                                            checks.</c:when>
                                        <c:otherwise>Manage all your assignments.</c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                        </div>

                        <div class="card shadow-sm">
                            <div class="card-header bg-white py-3">
                                <form action="<c:url value='/housekeeping/tasks'/>" method="get">
                                    <input type="hidden" name="type" value="${param.type}">
                                    <div class="row g-3">
                                        <div class="col-md-3">
                                            <div class="input-group input-group-sm ">
                                                <span class="input-group-text bg-light border-end-0"><i
                                                        class="bi bi-search"></i></span>
                                                <input type="text" name="search" class="form-control border-start-0 p-2"
                                                    placeholder="Search note, room..." value="${search}">
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <select name="status" class="form-select form-select-sm">
                                                <option value="">All Status</option>
                                                <option value="NEW" ${status=='NEW' ? 'selected' : '' }>New</option>
                                                <option value="IN_PROGRESS" ${status=='IN_PROGRESS' ? 'selected' : '' }>
                                                    In Progress</option>
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
                                        <div class="col-md-1 g-2 mt-3">
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
                                                        <span class="fw-bold">
                                                            ${hkp.getRoomById(t.roomId).getRoomNumber()}</span>
                                                    </td>
                                                    <td>${t.taskDate}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${t.taskType == 'CHECKIN'}">
                                                                <span class="badge bg-success">Check-in</span>
                                                            </c:when>
                                                            <c:when test="${t.taskType == 'CHECKOUT'}">
                                                                <span class="badge bg-primary">Check-out</span>
                                                            </c:when>
                                                            <c:when test="${t.taskType == 'INSPECTION'}">
                                                                <span class="badge bg-info text-dark">Inspection</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-secondary">Cleaning</span>
                                                            </c:otherwise>
                                                        </c:choose>
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
                                                        <c:choose>
                                                            <c:when test="${t.taskType == 'CLEANING'}">
                                                                <a href="<c:url value='/housekeeping/task-detail'><c:param name='id' value='${t.taskId}'/></c:url>"
                                                                    class="btn btn-sm btn-outline-primary">
                                                                    Details
                                                                </a>
                                                            </c:when>
                                                            <c:when
                                                                test="${t.status == 'DONE' && (t.taskType == 'INSPECTION' || t.taskType == 'CHECKIN' || t.taskType == 'CHECKOUT')}">
                                                                <a href="<c:url value='/housekeeping/inspection-history'><c:param name='roomId' value='${t.roomId}'/><c:param name='source' value='tasks'/></c:url>"
                                                                    class="btn btn-outline-secondary btn-sm">
                                                                    <i class="bi bi-clock-history me-1"></i>View History
                                                                </a>
                                                            </c:when>
                                                            <c:when
                                                                test="${t.taskType == 'INSPECTION' || t.taskType == 'CHECKIN' || t.taskType == 'CHECKOUT'}">
                                                                <a href="<c:url value='/housekeeping/inspection'><c:param name='roomId' value='${t.roomId}'/><c:param name='type' value='${t.taskType}' /><c:param name='taskId' value='${t.taskId}' /></c:url>"
                                                                    class="btn btn-sm btn-outline-primary">
                                                                    <i class="bi bi-clipboard-check me-1"></i>Inspect
                                                                </a>
                                                            </c:when>
                                                        </c:choose>
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
                                                href="?page=${currentPage - 1}&search=${search}&status=${status}&dateFrom=${dateFrom}&dateTo=${dateTo}&sortBy=${sortBy}&type=${param.type}">Previous</a>
                                        </li>
                                        <c:forEach begin="1" end="${totalPages}" var="p">
                                            <c:if
                                                test="${p == 1 || p == totalPages || (p >= currentPage - 2 && p <= currentPage + 2)}">
                                                <li class="page-item ${currentPage == p ? 'active' : ''}">
                                                    <a class="page-link"
                                                        href="?page=${p}&search=${search}&status=${status}&dateFrom=${dateFrom}&dateTo=${dateTo}&sortBy=${sortBy}&type=${param.type}">${p}</a>
                                                </li>
                                            </c:if>
                                            <c:if test="${p == 2 && currentPage > 4}">
                                                <li class="page-item disabled"><span class="page-link">...</span></li>
                                            </c:if>
                                            <c:if test="${p == totalPages - 1 && currentPage < totalPages - 3}">
                                                <li class="page-item disabled"><span class="page-link">...</span></li>
                                            </c:if>
                                        </c:forEach>
                                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                            <a class="page-link"
                                                href="?page=${currentPage + 1}&search=${search}&status=${status}&dateFrom=${dateFrom}&dateTo=${dateTo}&sortBy=${sortBy}&type=${param.type}">Next</a>
                                        </li>
                                    </ul>
                                </nav>
                            </div>
                        </div>
                    </div>

                    <jsp:include page="../Shared/Footer.jsp" />
                </div>
            </div>

            <c:if test="${param.msg == 'success'}">
                <c:set var="type" value="success" scope="request" />
                <c:set var="mess" value="Operation completed successfully." scope="request" />
            </c:if>
            <c:if test="${param.msg == 'failed'}">
                <c:set var="type" value="error" scope="request" />
                <c:set var="mess" value="Operation failed." scope="request" />
            </c:if>
            <jsp:include page="../public/notify.jsp" />

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>