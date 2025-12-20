<%@ page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <!-- ==================== META ==================== -->
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">

                    <!-- ==================== TITLE ==================== -->
                    <title>Receptionist Dashboard | HMS</title>

                    <!-- ==================== GOOGLE FONT ==================== -->
                    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                        rel="stylesheet">

                    <!-- ==================== BOOTSTRAP CSS ==================== -->
                    <link rel="stylesheet"
                        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">

                    <!-- ==================== CUSTOM CSS ==================== -->
                    <link rel="stylesheet" href="<c:url value='/CSS/housekeeping.css'/>">

                    <!-- ==================== BOOTSTRAP ICONS ==================== -->
                    <link rel="stylesheet"
                        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
                </head>

                <body>

                    <!-- ==================== MAIN LAYOUT WRAPPER ==================== -->
                    <div class="layout-wrapper">

                        <!-- ==================== SIDEBAR ==================== -->
                        <jsp:include page="../Shared/Sidebar.jsp" />

                        <!-- ==================== MAIN CONTENT ==================== -->
                        <div class="main-content">

                            <!-- ==================== HEADER ==================== -->
                            <header class="top-header">
                                <div class="d-flex align-items-center">
                                    <button class="btn btn-link text-dark d-md-none me-2" id="sidebarToggle">
                                        <i class="bi bi-list fs-4"></i>
                                    </button>
                                    <h5 class="header-title mb-0">Receptionist Dashboard</h5>
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

                            <!-- ==================== PAGE CONTENT ==================== -->
                            <div class="container-fluid py-4 px-4">

                                <!-- ===== PAGE TITLE ===== -->
                                <div class="d-flex justify-content-between align-items-center mb-4">
                                    <div>
                                        <h2 class="mb-1">📊 Receptionist Dashboard</h2>
                                        <p class="text-muted mb-0">Overview of today's operations.</p>
                                    </div>
                                </div>

                                <!-- ==================== KPI CARDS ==================== -->
                                <div class="row g-4 mb-4">

                                    <!-- ===== CONFIRMED BOOKINGS ===== -->
                                    <div class="col-md-4">
                                        <div class="card h-100 border-start border-4 border-success">
                                            <div class="card-body">
                                                <div class="d-flex justify-content-between align-items-start">
                                                    <div>
                                                        <p class="text-muted small text-uppercase fw-bold mb-1">
                                                            Confirmed
                                                        </p>
                                                        <h3 class="mb-0">${stats.confirmed}</h3>
                                                        <small class="text-muted">Ready to check-in</small>
                                                    </div>
                                                    <div
                                                        class="p-2 bg-success bg-opacity-10 rounded-circle text-success">
                                                        <i class="bi bi-check-circle fs-4"></i>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- ===== CHECKED IN ===== -->
                                    <div class="col-md-4">
                                        <div class="card h-100 border-start border-4 border-primary">
                                            <div class="card-body">
                                                <div class="d-flex justify-content-between align-items-start">
                                                    <div>
                                                        <p class="text-muted small text-uppercase fw-bold mb-1">
                                                            Checked In
                                                        </p>
                                                        <h3 class="mb-0">${stats.checkedIn}</h3>
                                                        <small class="text-muted">Current guests</small>
                                                    </div>
                                                    <div
                                                        class="p-2 bg-primary bg-opacity-10 rounded-circle text-primary">
                                                        <i class="bi bi-person-check fs-4"></i>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- ===== TODAY'S ARRIVALS ===== -->
                                    <div class="col-md-4">
                                        <div class="card h-100 border-start border-4 border-warning">
                                            <div class="card-body">
                                                <div class="d-flex justify-content-between align-items-start">
                                                    <div>
                                                        <p class="text-muted small text-uppercase fw-bold mb-1">
                                                            Today's Arrivals
                                                        </p>
                                                        <h3 class="mb-0">${stats.todayArrivals}</h3>
                                                        <small class="text-muted">Expected check-ins</small>
                                                    </div>
                                                    <div
                                                        class="p-2 bg-warning bg-opacity-10 rounded-circle text-warning">
                                                        <i class="bi bi-calendar-event fs-4"></i>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                </div>

                                <!-- ==================== QUICK ACTIONS ==================== -->
                                <div class="row g-4 mb-4">
                                    <div class="col-12">
                                        <div class="card">
                                            <div class="card-header bg-white py-3">
                                                <h5 class="mb-0"><i class="bi bi-lightning-charge me-2"></i>Quick
                                                    Actions</h5>
                                            </div>
                                            <div class="card-body">
                                                <div class="row g-3">
                                                    <div class="col-md-4">
                                                        <a href="${pageContext.request.contextPath}/receptionist/reservations"
                                                            class="btn btn-success w-100 py-3">
                                                            <i class="bi bi-calendar-check fs-4 d-block mb-2"></i>
                                                            <span class="fw-semibold">Reservation List</span>
                                                        </a>
                                                    </div>
                                                    <div class="col-md-4">
                                                        <a href="${pageContext.request.contextPath}/receptionist/checkinout"
                                                            class="btn btn-danger w-100 py-3">
                                                            <i class="bi bi-key fs-4 d-block mb-2"></i>
                                                            <span class="fw-semibold">Check-in/Check-out</span>
                                                        </a>
                                                    </div>
                                                    <div class="col-md-4">
                                                        <a href="${pageContext.request.contextPath}/receptionist/direct-booking"
                                                            class="btn btn-warning w-100 py-3 text-dark">
                                                            <i class="bi bi-plus-circle fs-4 d-block mb-2"></i>
                                                            <span class="fw-semibold">Direct Booking</span>
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- ==================== TODAY'S ARRIVALS TABLE ==================== -->
                                <c:if test="${not empty todayArrivals}">
                                    <div class="row g-4 mb-4">
                                        <div class="col-12">
                                            <div class="card">
                                                <div class="card-header bg-white py-3">
                                                    <h5 class="mb-0"><i class="bi bi-bell me-2"></i>Today's Arrivals
                                                    </h5>
                                                </div>
                                                <div class="card-body p-0">
                                                    <div class="table-responsive">
                                                        <table class="table table-hover mb-0">
                                                            <thead>
                                                                <tr>
                                                                    <th>Booking ID</th>
                                                                    <th>Customer</th>
                                                                    <th>Room</th>
                                                                    <th>Guests</th>
                                                                    <th>Status</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <c:forEach var="arrival" items="${todayArrivals}">
                                                                    <tr>
                                                                        <td><strong>BK-${arrival.bookingId}</strong>
                                                                        </td>
                                                                        <td>
                                                                            <div class="fw-semibold">
                                                                                ${arrival.customerName}</div>
                                                                            <small
                                                                                class="text-muted">${arrival.customerPhone}</small>
                                                                        </td>
                                                                        <td>${arrival.roomNumber} <small
                                                                                class="text-muted">(${arrival.typeName})</small>
                                                                        </td>
                                                                        <td>${arrival.numGuests} guests</td>
                                                                        <td>
                                                                            <span
                                                                                class="badge bg-${arrival.status == 'CONFIRMED' ? 'success' : (arrival.status == 'CHECKED_IN' ? 'primary' : 'secondary')}">
                                                                                ${arrival.status}
                                                                            </span>
                                                                        </td>
                                                                    </tr>
                                                                </c:forEach>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>

                                <!-- ==================== RECENT BOOKINGS TABLE ==================== -->
                                <c:if test="${not empty recentBookings}">
                                    <div class="row g-4">
                                        <div class="col-12">
                                            <div class="card">
                                                <div class="card-header bg-white py-3">
                                                    <h5 class="mb-0"><i class="bi bi-clock-history me-2"></i>Recent
                                                        Bookings</h5>
                                                </div>
                                                <div class="card-body p-0">
                                                    <div class="table-responsive">
                                                        <table class="table table-hover mb-0">
                                                            <thead>
                                                                <tr>
                                                                    <th>Booking ID</th>
                                                                    <th>Customer</th>
                                                                    <th>Room</th>
                                                                    <th>Status</th>
                                                                    <th>Time</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <c:forEach var="booking" items="${recentBookings}">
                                                                    <tr>
                                                                        <td><strong>BK-${booking.bookingId}</strong>
                                                                        </td>
                                                                        <td>${booking.customerName}</td>
                                                                        <td>${booking.roomNumber}</td>
                                                                        <td>
                                                                            <span
                                                                                class="badge bg-${booking.status == 'CONFIRMED' ? 'success' : (booking.status == 'CHECKED_IN' ? 'primary' : (booking.status == 'CANCELLED' ? 'danger' : 'secondary'))}">
                                                                                ${booking.status}
                                                                            </span>
                                                                        </td>
                                                                        <td><small
                                                                                class="text-muted">${fn:replace(fn:substring(booking.createdAt,
                                                                                0, 16), 'T', ' ')}</small></td>
                                                                    </tr>
                                                                </c:forEach>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>

                            </div>

                            <!-- ==================== FOOTER ==================== -->
                            <footer class="main-footer">
                                <p class="mb-0">&copy; 2025 Hotel Management System. All rights reserved.</p>
                            </footer>

                        </div>
                    </div>

                    <!-- ==================== BOOTSTRAP JS ==================== -->
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

                    <!-- ==================== SIDEBAR TOGGLE ==================== -->
                    <script>
                        document.getElementById('sidebarToggle')?.addEventListener('click', function () {
                            document.querySelector('.sidebar').classList.toggle('show');
                        });
                    </script>

                    <!-- ==================== GLOBAL NOTIFICATION ==================== -->
                    <%@ include file="../public/notify.jsp" %>

                </body>

                </html>