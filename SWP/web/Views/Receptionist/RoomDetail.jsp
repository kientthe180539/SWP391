<%@ page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Room ${room.roomNumber} | HMS</title>
                    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                        rel="stylesheet">
                    <link rel="stylesheet"
                        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
                    <link rel="stylesheet" href="<c:url value='/CSS/housekeeping.css'/>">
                    <link rel="stylesheet"
                        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
                </head>

                <body>
                    <div class="layout-wrapper">
                        <jsp:include page="../Shared/Sidebar.jsp" />

                        <div class="main-content">
                            <header class="top-header">
                                <div class="d-flex align-items-center">
                                    <button class="btn btn-link text-dark d-md-none me-2" id="sidebarToggle">
                                        <i class="bi bi-list fs-4"></i>
                                    </button>
                                    <h5 class="header-title mb-0">Room Detail</h5>
                                </div>
                                <div class="user-profile">
                                    <div class="text-end d-none d-sm-block">
                                        <div class="fw-bold text-dark">${sessionScope.currentUser.fullName}</div>
                                        <div class="small text-muted">Receptionist</div>
                                    </div>
                                    <div class="user-avatar">
                                        ${fn:substring(sessionScope.currentUser.fullName, 0, 1)}
                                    </div>
                                </div>
                            </header>

                            <div class="container-fluid py-4 px-4">
                                <a href="${pageContext.request.contextPath}/receptionist/room-status"
                                    class="btn btn-outline-secondary mb-3">
                                    <i class="bi bi-arrow-left"></i> Back to Room Board
                                </a>

                                <div class="d-flex justify-content-between align-items-center mb-4">
                                    <div>
                                        <h2 class="mb-1">🚪 Room ${room.roomNumber}</h2>
                                        <p class="text-muted mb-0">View room details and booking history.</p>
                                    </div>
                                    <span
                                        class="badge bg-${room.status == 'AVAILABLE' ? 'success' : (room.status == 'OCCUPIED' ? 'danger' : (room.status == 'CLEANING' ? 'warning text-dark' : (room.status == 'MAINTENANCE' ? 'info' : 'secondary')))} fs-6 px-3 py-2">
                                        ${room.status}
                                    </span>
                                </div>

                                <div class="row g-4">
                                    <!-- Room Information -->
                                    <div class="col-md-6">
                                        <div class="card h-100">
                                            <div class="card-header bg-white py-3">
                                                <h5 class="mb-0"><i class="bi bi-door-open me-2"></i>Room Information
                                                </h5>
                                            </div>
                                            <div class="card-body">
                                                <div class="row mb-2">
                                                    <div class="col-5 text-muted">Room Number</div>
                                                    <div class="col-7 fw-bold fs-5">${room.roomNumber}</div>
                                                </div>
                                                <div class="row mb-2">
                                                    <div class="col-5 text-muted">Floor</div>
                                                    <div class="col-7">Floor ${room.floor}</div>
                                                </div>
                                                <div class="row mb-2">
                                                    <div class="col-5 text-muted">Room Type</div>
                                                    <div class="col-7">${room.typeName}</div>
                                                </div>
                                                <div class="row mb-2">
                                                    <div class="col-5 text-muted">Max Occupancy</div>
                                                    <div class="col-7">${room.maxOccupancy} guests</div>
                                                </div>
                                                <div class="row mb-2">
                                                    <div class="col-5 text-muted">Base Price</div>
                                                    <div class="col-7 text-success fw-semibold">
                                                        <fmt:formatNumber value="${room.basePrice}" pattern="#,###" />
                                                        VND/night
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Current Occupant (if any) -->
                                    <c:if test="${not empty room.bookingId}">
                                        <div class="col-md-6">
                                            <div class="card h-100 border-danger">
                                                <div class="card-header bg-danger text-white py-3">
                                                    <h5 class="mb-0"><i class="bi bi-person-fill me-2"></i>Current
                                                        Occupant</h5>
                                                </div>
                                                <div class="card-body">
                                                    <div class="row mb-2">
                                                        <div class="col-5 text-muted">Guest Name</div>
                                                        <div class="col-7 fw-semibold">${room.customerName}</div>
                                                    </div>
                                                    <div class="row mb-2">
                                                        <div class="col-5 text-muted">Phone</div>
                                                        <div class="col-7">${room.customerPhone}</div>
                                                    </div>
                                                    <div class="row mb-2">
                                                        <div class="col-5 text-muted">Check-in Date</div>
                                                        <div class="col-7">${room.checkinDate}</div>
                                                    </div>
                                                    <div class="row mb-2">
                                                        <div class="col-5 text-muted">Check-out Date</div>
                                                        <div class="col-7">${room.checkoutDate}</div>
                                                    </div>
                                                    <div class="row mb-2">
                                                        <div class="col-5 text-muted">Number of Guests</div>
                                                        <div class="col-7">${room.numGuests}</div>
                                                    </div>
                                                    <div class="mt-3">
                                                        <a href="${pageContext.request.contextPath}/receptionist/reservation-detail?id=${room.bookingId}"
                                                            class="btn btn-outline-danger w-100">
                                                            <i class="bi bi-eye me-1"></i>View Booking Details
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:if>
                                </div>

                                <!-- Room Description -->
                                <c:if test="${not empty room.description}">
                                    <div class="card mt-4">
                                        <div class="card-header bg-white py-3">
                                            <h5 class="mb-0"><i class="bi bi-info-circle me-2"></i>Room Description</h5>
                                        </div>
                                        <div class="card-body">
                                            <p class="mb-0">${room.description}</p>
                                        </div>
                                    </div>
                                </c:if>

                                <!-- Booking History -->
                                <div class="card mt-4">
                                    <div class="card-header bg-white py-3">
                                        <h5 class="mb-0"><i class="bi bi-clock-history me-2"></i>Booking History</h5>
                                    </div>
                                    <div class="card-body p-0">
                                        <c:choose>
                                            <c:when test="${empty history}">
                                                <div class="text-center py-5 text-muted">
                                                    <i class="bi bi-inbox fs-1"></i>
                                                    <p class="mt-2">No booking history available for this room</p>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="table-responsive">
                                                    <table class="table table-hover mb-0">
                                                        <thead>
                                                            <tr>
                                                                <th>Booking ID</th>
                                                                <th>Guest</th>
                                                                <th>Check-in</th>
                                                                <th>Check-out</th>
                                                                <th>Guests</th>
                                                                <th>Status</th>
                                                                <th>Total</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <c:forEach var="booking" items="${history}">
                                                                <tr style="cursor: pointer;"
                                                                    onclick="window.location.href='${pageContext.request.contextPath}/receptionist/reservation-detail?id=${booking.bookingId}'">
                                                                    <td><strong>#${booking.bookingId}</strong></td>
                                                                    <td>
                                                                        <div class="fw-semibold">${booking.customerName}
                                                                        </div>
                                                                        <small
                                                                            class="text-muted">${booking.customerPhone}</small>
                                                                    </td>
                                                                    <td>${booking.checkinDate}</td>
                                                                    <td>${booking.checkoutDate}</td>
                                                                    <td>${booking.numGuests}</td>
                                                                    <td>
                                                                        <span
                                                                            class="badge bg-${booking.status == 'CHECKED_OUT' ? 'secondary' : (booking.status == 'CHECKED_IN' ? 'primary' : (booking.status == 'CANCELLED' ? 'danger' : 'success'))}">
                                                                            ${booking.status}
                                                                        </span>
                                                                    </td>
                                                                    <td class="text-success fw-semibold">
                                                                        <fmt:formatNumber value="${booking.totalAmount}"
                                                                            pattern="#,###" /> VND
                                                                    </td>
                                                                </tr>
                                                            </c:forEach>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>

                            <footer class="main-footer">
                                <p class="mb-0">&copy; 2025 Hotel Management System. All rights reserved.</p>
                            </footer>
                        </div>
                    </div>

                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
                    <script>
                        document.getElementById('sidebarToggle')?.addEventListener('click', function () {
                            document.querySelector('.sidebar').classList.toggle('show');
                        });
                    </script>
                </body>

                </html>