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
                            <div class="d-flex gap-2">
                                <a href="<c:url value='/manager/all-tasks'/>" class="btn btn-outline-primary">
                                    <i class="bi bi-list-check me-2"></i>View All Tasks
                                </a>
                                <form action="<c:url value='/manager/staff'/>" method="get" class="d-flex gap-2">
                                    <input type="date" name="date" class="form-control" value="${date}">
                                    <button type="submit" class="btn btn-secondary">Filter</button>
                                </form>
                            </div>
                        </div>

                        <div class="card shadow-sm">
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
                                                        <span
                                                            class="badge ${a.shiftType == 'MORNING' ? 'bg-info' : 
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
                                                    <td colspan="4" class="text-center py-4 text-muted">
                                                        No assignments found for this date.
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