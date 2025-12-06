<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Room Management | HMS Owner</title>
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                rel="stylesheet">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
            <link rel="stylesheet" href="<c:url value='/CSS/housekeeping.css'/>">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
        </head>

        <body>

            <div class="layout-wrapper">
                <jsp:include page="../Shared/OwnerSidebar.jsp" />

                <div class="main-content">
                    <jsp:include page="../Shared/Header.jsp" />

                    <div class="container-fluid py-4 px-4">
                        <h2 class="mb-4">Room Management Oversight</h2>

                        <div class="card shadow-sm">
                            <div class="card-header bg-white">
                                <ul class="nav nav-tabs card-header-tabs">
                                    <li class="nav-item">
                                        <a class="nav-link active" href="#">Room List</a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" href="#">Pricing Policy</a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" href="#">Room Types</a>
                                    </li>
                                </ul>
                            </div>
                            <div class="card-body">
                                <form action="<c:url value='/owner/rooms'/>" method="get" class="mb-4">
                                    <div class="row g-3">
                                        <div class="col-md-4">
                                            <div class="input-group input-group-sm">
                                                <span class="input-group-text bg-light border-end-0"><i
                                                        class="bi bi-search"></i></span>
                                                <input type="text" name="search" class="form-control border-start-0"
                                                    placeholder="Search room number..." value="${search}">
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <select name="status" class="form-select form-select-sm">
                                                <option value="">All Status</option>
                                                <option value="AVAILABLE" ${status=='AVAILABLE' ? 'selected' : '' }>
                                                    Available</option>
                                                <option value="DIRTY" ${status=='DIRTY' ? 'selected' : '' }>Dirty
                                                </option>
                                                <option value="CLEANING" ${status=='CLEANING' ? 'selected' : '' }>
                                                    Cleaning</option>
                                                <option value="MAINTENANCE" ${status=='MAINTENANCE' ? 'selected' : '' }>
                                                    Maintenance</option>
                                            </select>
                                        </div>
                                        <div class="col-md-3">
                                            <select name="sortBy" class="form-select form-select-sm">
                                                <option value="room_number" ${sortBy=='room_number' ? 'selected' : '' }>
                                                    Sort by Room Number</option>
                                                <option value="status" ${sortBy=='status' ? 'selected' : '' }>Sort by
                                                    Status</option>
                                                <option value="floor" ${sortBy=='floor' ? 'selected' : '' }>Sort by
                                                    Floor</option>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <button type="submit" class="btn btn-sm btn-primary w-100">Filter</button>
                                        </div>
                                    </div>
                                </form>

                                <div class="table-responsive">
                                    <table class="table table-bordered table-hover align-middle">
                                        <thead class="bg-light">
                                            <tr>
                                                <th>Room Number</th>
                                                <th>Floor</th>
                                                <th>Type ID</th>
                                                <th>Status</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:if test="${empty rooms}">
                                                <tr>
                                                    <td colspan="5" class="text-center py-5 text-muted">
                                                        <i class="bi bi-door-closed fs-1 d-block mb-2"></i>
                                                        No rooms found matching your criteria.
                                                    </td>
                                                </tr>
                                            </c:if>
                                            <c:forEach items="${rooms}" var="r">
                                                <tr>
                                                    <td class="fw-bold">Room ${r.roomNumber}</td>
                                                    <td>${r.floor}</td>
                                                    <td>${r.roomTypeId}</td>
                                                    <td>
                                                        <span class="badge rounded-pill 
                                                    ${r.status == 'AVAILABLE' ? 'bg-success' : 
                                                      (r.status == 'DIRTY' ? 'bg-danger' : 
                                                      (r.status == 'CLEANING' ? 'bg-warning' : 'bg-secondary'))}">
                                                            ${r.status}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <button class="btn btn-sm btn-outline-secondary">Edit</button>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            <div class="card-footer bg-white py-3">
                                <nav class="d-flex justify-content-between align-items-center">
                                    <small class="text-muted">Showing ${rooms.size()} of ${totalRooms} rooms</small>
                                    <ul class="pagination pagination-sm mb-0">
                                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                            <a class="page-link"
                                                href="?page=${currentPage - 1}&search=${search}&status=${status}&sortBy=${sortBy}">Previous</a>
                                        </li>
                                        <c:forEach begin="1" end="${totalPages}" var="p">
                                            <li class="page-item ${currentPage == p ? 'active' : ''}">
                                                <a class="page-link"
                                                    href="?page=${p}&search=${search}&status=${status}&sortBy=${sortBy}">${p}</a>
                                            </li>
                                        </c:forEach>
                                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                            <a class="page-link"
                                                href="?page=${currentPage + 1}&search=${search}&status=${status}&sortBy=${sortBy}">Next</a>
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