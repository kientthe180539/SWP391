<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>Staff Management | HMS</title>
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
                            <h2>Staff Management</h2>
                            <a href="<c:url value='/manager/all-tasks'/>" class="btn btn-outline-primary">
                                <i class="bi bi-list-check me-2"></i>View All Tasks
                            </a>
                        </div>

                        <div class="card shadow-sm">
                            <div class="card-header bg-white py-3">
                                <form action="<c:url value='/manager/staff'/>" method="get">
                                    <div class="row g-3">
                                        <div class="col-md-3">
                                            <div class="input-group input-group-sm">
                                                <span class="input-group-text bg-light border-end-0"><i
                                                        class="bi bi-search"></i></span>
                                                <input type="text" name="search" class="form-control border-start-0"
                                                    placeholder="Search by name..." value="${search}">
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <input type="date" name="date" class="form-control form-control-sm"
                                                value="${date}">
                                        </div>
                                        <div class="col-md-2">
                                            <select name="shiftType" class="form-select form-select-sm">
                                                <option value="">All Shifts</option>
                                                <option value="MORNING" ${shiftType=='MORNING' ? 'selected' : '' }>
                                                    Morning</option>
                                                <option value="AFTERNOON" ${shiftType=='AFTERNOON' ? 'selected' : '' }>
                                                    Afternoon</option>
                                                <option value="NIGHT" ${shiftType=='NIGHT' ? 'selected' : '' }>Night
                                                </option>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <select name="sortBy" class="form-select form-select-sm">
                                                <option value="employee_name" ${sortBy=='employee_name' ? 'selected'
                                                    : '' }>Sort by Name</option>
                                                <option value="shift_type" ${sortBy=='shift_type' ? 'selected' : '' }>
                                                    Sort by Shift</option>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <button type="submit" class="btn btn-sm btn-primary w-100">Filter</button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                            <div class="card-body p-0">
                                <div class="table-responsive">
                                    <table class="table table-hover mb-0 align-middle">
                                        <thead class="table-light">
                                            <tr>
                                                <th>Employee</th>
                                                <th>Shift</th>
                                                <th>Status</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${assignments}" var="a">
                                                <tr>
                                                    <td class="fw-bold">
                                                        <i class="bi bi-person-circle me-2 text-secondary"></i>
                                                        ${a.employeeName}
                                                    </td>
                                                    <td>
                                                        <span class="badge ${a.shiftType == 'MORNING' ? 'bg-info' : 
                                                               a.shiftType == 'AFTERNOON' ? 'bg-warning' : 'bg-dark'}">
                                                            ${a.shiftType}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <span
                                                            class="badge ${a.accountActive ? 'bg-success' : 'bg-danger'}">
                                                            ${a.accountActive ? 'Active' : 'Inactive'}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <a href="<c:url value='/manager/all-tasks?staffId=${a.employeeId}'/>"
                                                            class="btn btn-sm btn-outline-primary">
                                                            <i class="bi bi-calendar3 me-1"></i>Schedule
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${empty assignments}">
                                                <tr>
                                                    <td colspan="4" class="text-center py-5 text-muted">
                                                        <i class="bi bi-people fs-1 d-block mb-2"></i>
                                                        No assignments found for this date.
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            <div class="card-footer bg-white py-3">
                                <nav class="d-flex justify-content-between align-items-center">
                                    <small class="text-muted">Showing ${assignments.size()} of ${totalAssignments}
                                        staff</small>
                                    <c:if test="${totalPages > 1}">
                                        <ul class="pagination pagination-sm mb-0">
                                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                <a class="page-link"
                                                    href="?page=${currentPage - 1}&search=${search}&date=${date}&shiftType=${shiftType}&sortBy=${sortBy}">Previous</a>
                                            </li>
                                            <c:forEach begin="1" end="${totalPages}" var="p">
                                                <li class="page-item ${currentPage == p ? 'active' : ''}">
                                                    <a class="page-link"
                                                        href="?page=${p}&search=${search}&date=${date}&shiftType=${shiftType}&sortBy=${sortBy}">${p}</a>
                                                </li>
                                            </c:forEach>
                                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                                <a class="page-link"
                                                    href="?page=${currentPage + 1}&search=${search}&date=${date}&shiftType=${shiftType}&sortBy=${sortBy}">Next</a>
                                            </li>
                                        </ul>
                                    </c:if>
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