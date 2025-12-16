<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>Room Management | HMS</title>
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
                            <h2>Room Management</h2>
                            <a href="<c:url value='/manager/create-task'/>" class="btn btn-primary">
                                <i class="bi bi-plus-lg"></i> Assign Task
                            </a>
                        </div>

                        <div class="card shadow-sm">
                            <div class="card-body p-0">
                                <div class="table-responsive">
                                    <table class="table table-hover mb-0 align-middle">
                                        <thead class="table-light">
                                            <tr>
                                                <th>Room Number</th>
                                                <th>Type</th>
                                                <th>Floor</th>
                                                <th>Status</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${rooms}" var="r">
                                                <tr>
                                                    <td class="fw-bold">${r.roomNumber}</td>
                                                    <td>${r.roomTypeName}</td>
                                                    <td>${r.floor}</td>
                                                    <td>
                                                        <span
                                                            class="badge ${r.status == 'AVAILABLE' ? 'bg-success' : 
                                                                   r.status == 'DIRTY' ? 'bg-danger' : 
                                                                   r.status == 'CLEANING' ? 'bg-warning' : 'bg-secondary'}">
                                                            ${r.status}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <a href="<c:url value='/manager/room-detail'><c:param name='id' value='${r.roomId}'/></c:url>"
                                                            class="btn btn-sm btn-outline-primary" title="View Detail">
                                                            <i class="bi bi-eye"></i>
                                                        </a>
                                                        <a href="<c:url value='/housekeeping/inspection-history'><c:param name='roomId' value='${r.roomId}'/></c:url>"
                                                            class="btn btn-sm btn-outline-info" title="View History">
                                                            <i class="bi bi-clock-history"></i>
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

                    <jsp:include page="../Shared/Footer.jsp" />
                </div>
            </div>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>