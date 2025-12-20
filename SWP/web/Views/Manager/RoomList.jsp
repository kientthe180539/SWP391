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
                            <div class="card-header bg-white py-3">
                                <form action="<c:url value='/manager/rooms'/>" method="get">
                                    <div class="row g-3">
                                        <div class="col-md-3">
                                            <div class="input-group input-group-sm">
                                                <span class="input-group-text bg-light border-end-0"><i
                                                        class="bi bi-search"></i></span>
                                                <input type="text" name="search" class="form-control border-start-0"
                                                    placeholder="Search room number..." value="${search}">
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <select name="status" class="form-select form-select-sm">
                                                <option value="">All Status</option>
                                                <option value="AVAILABLE" ${status=='AVAILABLE' ? 'selected' : '' }>
                                                    Available</option>
                                                <option value="BOOKED" ${status=='BOOKED' ? 'selected' : '' }>Booked
                                                </option>
                                                <option value="OCCUPIED" ${status=='OCCUPIED' ? 'selected' : '' }>
                                                    Occupied</option>
                                                <option value="DIRTY" ${status=='DIRTY' ? 'selected' : '' }>Dirty
                                                </option>
                                                <option value="CLEANING" ${status=='CLEANING' ? 'selected' : '' }>
                                                    Cleaning</option>
                                                <option value="MAINTENANCE" ${status=='MAINTENANCE' ? 'selected' : '' }>
                                                    Maintenance</option>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <select name="floor" class="form-select form-select-sm">
                                                <option value="">All Floors</option>
                                                <c:forEach begin="1" end="10" var="f">
                                                    <option value="${f}" ${floor==f ? 'selected' : '' }>Floor ${f}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <select name="sortBy" class="form-select form-select-sm">
                                                <option value="room_number" ${sortBy=='room_number' ? 'selected' : '' }>
                                                    Sort by Room</option>
                                                <option value="floor" ${sortBy=='floor' ? 'selected' : '' }>Sort by
                                                    Floor</option>
                                                <option value="status" ${sortBy=='status' ? 'selected' : '' }>Sort by
                                                    Status</option>
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
                                            <c:if test="${empty rooms}">
                                                <tr>
                                                    <td colspan="5" class="text-center py-5 text-muted">
                                                        <i class="bi bi-door-open fs-1 d-block mb-2"></i>
                                                        No rooms found.
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            <div class="card-footer bg-white py-3">
                                <nav class="d-flex justify-content-between align-items-center">
                                    <small class="text-muted">Showing ${rooms.size()} of ${totalRooms} rooms</small>
                                    <c:if test="${totalPages > 1}">
                                        <ul class="pagination pagination-sm mb-0">
                                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                <a class="page-link"
                                                    href="?page=${currentPage - 1}&search=${search}&status=${status}&floor=${floor}&sortBy=${sortBy}">Previous</a>
                                            </li>
                                            <c:forEach begin="1" end="${totalPages}" var="p">
                                                <li class="page-item ${currentPage == p ? 'active' : ''}">
                                                    <a class="page-link"
                                                        href="?page=${p}&search=${search}&status=${status}&floor=${floor}&sortBy=${sortBy}">${p}</a>
                                                </li>
                                            </c:forEach>
                                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                                <a class="page-link"
                                                    href="?page=${currentPage + 1}&search=${search}&status=${status}&floor=${floor}&sortBy=${sortBy}">Next</a>
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