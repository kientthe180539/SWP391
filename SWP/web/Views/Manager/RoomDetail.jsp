<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>Room ${room.roomNumber} Detail | HMS</title>
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
                            <div>
                                <h4 class="mb-1 text-primary">Room ${room.roomNumber} Details</h4>
                                <nav aria-label="breadcrumb">
                                    <ol class="breadcrumb mb-0">
                                        <li class="breadcrumb-item"><a href="<c:url value='/manager/rooms'/>">Rooms</a>
                                        </li>
                                        <li class="breadcrumb-item active">Detail</li>
                                    </ol>
                                </nav>
                            </div>
                            <div class="d-flex gap-2">
                                <a href="<c:url value='/manager/create-task?roomId=${room.roomId}'/>"
                                    class="btn btn-primary">
                                    <i class="bi bi-bucket"></i> Assign Cleaning
                                </a>
                                <a href="<c:url value='/housekeeping/inspection-history?roomId=${room.roomId}'/>"
                                    class="btn btn-outline-info">
                                    <i class="bi bi-clock-history"></i> History
                                </a>
                            </div>
                        </div>

                        <div class="row g-4">
                            <!-- Room Info Card -->
                            <div class="col-md-4">
                                <div class="card shadow-sm h-100">
                                    <div class="card-header bg-white">
                                        <h5 class="mb-0">Information</h5>
                                    </div>
                                    <div class="card-body">
                                        <ul class="list-group list-group-flush">
                                            <li class="list-group-item d-flex justify-content-between">
                                                <span class="text-muted">Status</span>
                                                <span
                                                    class="badge ${room.status == 'AVAILABLE' ? 'bg-success' : room.status == 'DIRTY' ? 'bg-danger' : 'bg-warning'}">
                                                    ${room.status}
                                                </span>
                                            </li>
                                            <li class="list-group-item d-flex justify-content-between">
                                                <span class="text-muted">Type</span>
                                                <span class="fw-medium">
                                                    <c:choose>
                                                        <c:when test="${not empty room.roomTypeName}">
                                                            ${room.roomTypeName}
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-danger">Desc: ${room.description} (ID:
                                                                ${room.roomTypeId})</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </li>
                                            <c:if test="${not empty room.roomType}">
                                                <li class="list-group-item d-flex justify-content-between">
                                                    <span class="text-muted">Max Occupancy</span>
                                                    <span class="fw-medium">${room.roomType.maxOccupancy} Persons</span>
                                                </li>
                                                <li class="list-group-item d-flex justify-content-between">
                                                    <span class="text-muted">Base Price</span>
                                                    <span class="fw-medium">$${room.roomType.basePrice}</span>
                                                </li>
                                                <c:if test="${not empty room.roomType.description}">
                                                    <li class="list-group-item">
                                                        <small class="text-muted d-block mb-1">Type Description</small>
                                                        <span class="text-dark">${room.roomType.description}</span>
                                                    </li>
                                                </c:if>
                                            </c:if>
                                            <li class="list-group-item d-flex justify-content-between">
                                                <span class="text-muted">Floor</span>
                                                <span class="fw-medium">${room.floor}</span>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </div>

                            <!-- Room Amenities / Items Management -->
                            <div class="col-md-8">
                                <div class="card shadow-sm h-100">
                                    <div class="card-header bg-white d-flex justify-content-between align-items-center">
                                        <h5 class="mb-0">Room Amenities & Equipment (Standard)</h5>
                                    </div>
                                    <div class="card-body p-0">
                                        <div class="table-responsive">
                                            <table class="table table-hover align-middle mb-0">
                                                <thead class="table-light">
                                                    <tr>
                                                        <th>Item Name</th>
                                                        <th>Standard Qty</th>
                                                        <th>Description</th>
                                                        <th>Price</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach items="${amenities}" var="a">
                                                        <tr>
                                                            <td>
                                                                <div class="fw-bold">${a.amenity.name}</div>
                                                            </td>
                                                            <td>
                                                                <span class="badge bg-light text-dark border">
                                                                    ${a.defaultQuantity}
                                                                </span>
                                                            </td>
                                                            <td class="small text-muted">${a.amenity.description}</td>
                                                            <td class="small">$${a.amenity.price}</td>
                                                        </tr>
                                                    </c:forEach>
                                                    <c:if test="${empty amenities}">
                                                        <tr>
                                                            <td colspan="4" class="text-center text-muted py-4">
                                                                No amenities configured for this room type.
                                                            </td>
                                                        </tr>
                                                    </c:if>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                    <div class="card-footer bg-white text-muted small">
                                        <i class="bi bi-info-circle me-1"></i>
                                        Showing standard amenities for <strong>Room ${room.roomNumber}</strong> (Type:
                                        ${room.roomTypeName}).
                                        <br>
                                        <span class="text-danger">* Read-only based on Room Type configuration.</span>
                                    </div>
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