<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Room List | HMS Housekeeping</title>
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
                                <h2 class="mb-1">Room Status</h2>
                                <p class="text-muted mb-0">Overview of all rooms and their cleaning status.</p>
                            </div>
                        </div>

                        <div class="card shadow-sm">
                            <div class="card-header bg-white py-3">
                                <form action="<c:url value='/housekeeping/rooms'/>" method="get">
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
                            </div>
                            <div class="card-body p-4">
                                <div class="row g-4">
                                    <c:if test="${empty rooms}">
                                        <div class="col-12 text-center py-5 text-muted">
                                            <i class="bi bi-door-closed fs-1 d-block mb-2"></i>
                                            No rooms found matching your criteria.
                                        </div>
                                    </c:if>
                                    <c:forEach items="${rooms}" var="r">
                                        <div class="col-md-4 col-lg-3">
                                            <div class="card h-100 border-0 shadow-sm room-card">
                                                <div class="card-body text-center">
                                                    <h5 class="card-title fw-bold mb-1">Room ${r.roomNumber}</h5>
                                                    <p class="text-muted small mb-3">Floor ${r.floor}</p>

                                                    <span class="badge rounded-pill mb-3 px-3 py-2
                                                ${r.status == 'AVAILABLE' ? 'bg-success' : 
                                                  (r.status == 'DIRTY' ? 'bg-danger' : 
                                                  (r.status == 'CLEANING' ? 'bg-warning' : 'bg-secondary'))}">
                                                        ${r.status}
                                                    </span>

                                                    <div class="d-grid gap-2">
                                                        <a href="<c:url value='/housekeeping/inspection'><c:param name='roomId' value='${r.roomId}'/><c:param name='type' value='ROUTINE'/></c:url>"
                                                            class="btn btn-sm btn-outline-primary">
                                                            Inspect
                                                        </a>
                                                        <a href="<c:url value='/housekeeping/room-update'><c:param name='roomId' value='${r.roomId}'/></c:url>"
                                                            class="btn btn-sm btn-outline-secondary">
                                                            Update Status
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
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