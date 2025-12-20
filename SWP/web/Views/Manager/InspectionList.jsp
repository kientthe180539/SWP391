<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>Inspection History | HMS</title>
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
                        <h2 class="mb-4">Recent Inspections</h2>

                        <c:if test="${param.msg == 'success'}">
                            <c:set var="type" value="success" scope="request" />
                            <c:set var="mess" value="Inspection has been submitted successfully!" scope="request" />
                        </c:if>
                        <jsp:include page="../public/notify.jsp" />

                        <div class="card shadow-sm mb-4">
                            <div class="card-body py-3">
                                <form method="GET" class="row g-3">
                                    <div class="col-md-4">
                                        <div class="input-group input-group-sm">
                                            <span class="input-group-text bg-light border-end-0"><i
                                                    class="bi bi-search"></i></span>
                                            <input type="text" class="form-control border-start-0" name="search"
                                                placeholder="Search by ID, room, inspector, or note..."
                                                value="${searchQuery}">
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <select name="type" class="form-select form-select-sm">
                                            <option value="ALL">All Inspection Types</option>
                                            <option value="CHECKIN" ${typeFilter=='CHECKIN' ? 'selected' : '' }>
                                                Check-in</option>
                                            <option value="CHECKOUT" ${typeFilter=='CHECKOUT' ? 'selected' : '' }>
                                                Check-out</option>
                                            <option value="ROUTINE" ${typeFilter=='ROUTINE' ? 'selected' : '' }>
                                                Routine</option>
                                            <option value="SUPPLY" ${typeFilter=='SUPPLY' ? 'selected' : '' }>Supply
                                            </option>
                                        </select>
                                    </div>
                                    <div class="col-md-3">
                                        <select name="sortBy" class="form-select form-select-sm">
                                            <option value="inspection_date" ${sortBy=='inspection_date' ? 'selected'
                                                : '' }>Sort by Date</option>
                                            <option value="room_id" ${sortBy=='room_id' ? 'selected' : '' }>Sort by
                                                Room</option>
                                            <option value="inspector_id" ${sortBy=='inspector_id' ? 'selected' : '' }>
                                                Sort by Inspector</option>
                                        </select>
                                    </div>
                                    <div class="col-md-2">
                                        <button type="submit" class="btn btn-sm btn-primary w-100">Filter</button>
                                    </div>
                                </form>
                            </div>
                        </div>

                        <div class="card shadow-sm">
                            <div class="card-body p-0">
                                <div class="table-responsive">
                                    <table class="table table-hover mb-0 align-middle">
                                        <thead class="table-light">
                                            <tr>
                                                <th>ID</th>
                                                <th>Room</th>
                                                <th>Type</th>
                                                <th>Date</th>
                                                <th>Inspector</th>
                                                <th>Note</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${inspections}" var="i">
                                                <tr>
                                                    <td>#${i.inspectionId}</td>
                                                    <td class="fw-bold">
                                                        <c:choose>
                                                            <c:when test="${not empty i.roomNumber}">Room
                                                                ${i.roomNumber}</c:when>
                                                            <c:otherwise>Room ${i.roomId}</c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <span
                                                            class="badge ${i.type == 'CHECKIN' ? 'bg-success' : 
                                                                   i.type == 'CHECKOUT' ? 'bg-primary' : 
                                                                   i.type == 'ROUTINE' ? 'bg-info' :
                                                                   i.type == 'SUPPLY' ? 'bg-warning' : 'bg-secondary'}">
                                                            ${i.type}
                                                        </span>
                                                    </td>
                                                    <td>${i.inspectionDate}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty i.inspectorName}">
                                                                ${i.inspectorName}</c:when>
                                                            <c:otherwise>User #${i.inspectorId}</c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="text-truncate" style="max-width: 200px;">${i.note}</td>
                                                    <td>
                                                        <a href="<c:url value='/manager/inspection-detail'><c:param name='id' value='${i.inspectionId}'/></c:url>"
                                                            class="btn btn-sm btn-outline-primary">
                                                            View Details
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <!-- Pagination Info -->
                            <div class="card-footer bg-white">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div class="text-muted">
                                        Showing ${(currentPage - 1) * pageSize + 1} to ${(currentPage - 1) * pageSize +
                                        inspections.size()} of ${totalInspections} inspections
                                    </div>
                                    <c:if test="${totalPages > 1}">
                                        <ul class="pagination pagination-sm mb-0">
                                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                <a class="page-link"
                                                    href="?page=${currentPage - 1}&search=${searchQuery}&type=${typeFilter}&sortBy=${sortBy}">Previous</a>
                                            </li>
                                            <c:forEach begin="1" end="${totalPages}" var="p">
                                                <li class="page-item ${currentPage == p ? 'active' : ''}">
                                                    <a class="page-link"
                                                        href="?page=${p}&search=${searchQuery}&type=${typeFilter}&sortBy=${sortBy}">${p}</a>
                                                </li>
                                            </c:forEach>
                                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                                <a class="page-link"
                                                    href="?page=${currentPage + 1}&search=${searchQuery}&type=${typeFilter}&sortBy=${sortBy}">Next</a>
                                            </li>
                                        </ul>
                                    </c:if>
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