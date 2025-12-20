<%@ page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Reservation #${booking.bookingId} | HMS</title>
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
                                    <h5 class="header-title mb-0">Reservation Detail</h5>
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
                                <a href="${pageContext.request.contextPath}/receptionist/reservations"
                                    class="btn btn-outline-secondary mb-3">
                                    <i class="bi bi-arrow-left"></i> Back to Reservations
                                </a>

                                <div class="d-flex justify-content-between align-items-center mb-4">
                                    <div>
                                        <h2 class="mb-1">📋 Reservation #${booking.bookingId}</h2>
                                        <p class="text-muted mb-0">View booking details and manage reservation.</p>
                                    </div>
                                    <span
                                        class="badge bg-${booking.status == 'CONFIRMED' ? 'success' : (booking.status == 'CHECKED_IN' ? 'primary' : (booking.status == 'CANCELLED' ? 'danger' : 'secondary'))} fs-6 px-3 py-2">
                                        ${booking.status}
                                    </span>
                                </div>

                                <div class="row g-4">
                                    <!-- Booking Information -->
                                    <div class="col-md-6">
                                        <div class="card h-100">
                                            <div class="card-header bg-white py-3">
                                                <h5 class="mb-0"><i class="bi bi-calendar-check me-2"></i>Booking
                                                    Information</h5>
                                            </div>
                                            <div class="card-body">
                                                <div class="row mb-2">
                                                    <div class="col-5 text-muted">Booking ID</div>
                                                    <div class="col-7 fw-semibold">#${booking.bookingId}</div>
                                                </div>
                                                <div class="row mb-2">
                                                    <div class="col-5 text-muted">Check-in Date</div>
                                                    <div class="col-7 fw-semibold">${booking.checkinDate}</div>
                                                </div>
                                                <div class="row mb-2">
                                                    <div class="col-5 text-muted">Check-out Date</div>
                                                    <div class="col-7 fw-semibold">${booking.checkoutDate}</div>
                                                </div>
                                                <div class="row mb-2">
                                                    <div class="col-5 text-muted">Number of Guests</div>
                                                    <div class="col-7">${booking.numGuests}</div>
                                                </div>
                                                <div class="row mb-2">
                                                    <div class="col-5 text-muted">Created At</div>
                                                    <div class="col-7">
                                                        <fmt:formatDate value="${booking.createdAt}"
                                                            pattern="yyyy-MM-dd HH:mm" />
                                                    </div>
                                                </div>
                                                <c:if test="${not empty booking.updatedAt}">
                                                    <div class="row mb-2">
                                                        <div class="col-5 text-muted">Last Updated</div>
                                                        <div class="col-7">
                                                            <fmt:formatDate value="${booking.updatedAt}"
                                                                pattern="yyyy-MM-dd HH:mm" />
                                                        </div>
                                                    </div>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Customer Information -->
                                    <div class="col-md-6">
                                        <div class="card h-100">
                                            <div class="card-header bg-white py-3">
                                                <h5 class="mb-0"><i class="bi bi-person me-2"></i>Customer Information
                                                </h5>
                                            </div>
                                            <div class="card-body">
                                                <div class="row mb-2">
                                                    <div class="col-5 text-muted">Full Name</div>
                                                    <div class="col-7 fw-semibold">${booking.customerName}</div>
                                                </div>
                                                <div class="row mb-2">
                                                    <div class="col-5 text-muted">Email</div>
                                                    <div class="col-7">${booking.customerEmail}</div>
                                                </div>
                                                <div class="row mb-2">
                                                    <div class="col-5 text-muted">Phone</div>
                                                    <div class="col-7">${booking.customerPhone}</div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

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
                                                    <div class="col-7">
                                                        <a href="${pageContext.request.contextPath}/receptionist/room-detail?id=${booking.roomId}"
                                                            class="fw-semibold text-decoration-none">
                                                            ${booking.roomNumber}
                                                        </a>
                                                    </div>
                                                </div>
                                                <div class="row mb-2">
                                                    <div class="col-5 text-muted">Floor</div>
                                                    <div class="col-7">Floor ${booking.floor}</div>
                                                </div>
                                                <div class="row mb-2">
                                                    <div class="col-5 text-muted">Room Type</div>
                                                    <div class="col-7">${booking.typeName}</div>
                                                </div>
                                                <div class="row mb-2">
                                                    <div class="col-5 text-muted">Max Occupancy</div>
                                                    <div class="col-7">${booking.maxOccupancy} guests</div>
                                                </div>
                                                <div class="row mb-2">
                                                    <div class="col-5 text-muted">Room Status</div>
                                                    <div class="col-7">
                                                        <span
                                                            class="badge bg-${booking.roomStatus == 'AVAILABLE' ? 'success' : (booking.roomStatus == 'OCCUPIED' ? 'danger' : 'secondary')}">
                                                            ${booking.roomStatus}
                                                        </span>
                                                    </div>
                                                </div>
                                                <div class="row mb-2">
                                                    <div class="col-5 text-muted">Base Price</div>
                                                    <div class="col-7 text-success fw-semibold">
                                                        <fmt:formatNumber value="${booking.basePrice}"
                                                            pattern="#,###" /> VND/night
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Payment Information -->
                                    <div class="col-md-6">
                                        <div class="card h-100">
                                            <div class="card-header bg-white py-3">
                                                <h5 class="mb-0"><i class="bi bi-cash-stack me-2"></i>Payment
                                                    Information</h5>
                                            </div>
                                            <div class="card-body">
                                                <div class="row mb-2">
                                                    <div class="col-5 text-muted">Total Amount</div>
                                                    <div class="col-7 fs-4 fw-bold text-success">
                                                        <fmt:formatNumber value="${booking.totalAmount}"
                                                            pattern="#,###" /> VND
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Room Description -->
                                <c:if test="${not empty booking.description}">
                                    <div class="card mt-4">
                                        <div class="card-header bg-white py-3">
                                            <h5 class="mb-0"><i class="bi bi-info-circle me-2"></i>Room Description</h5>
                                        </div>
                                        <div class="card-body">
                                            <p class="mb-0">${booking.description}</p>
                                        </div>
                                    </div>
                                </c:if>

                                <!-- Quick Actions -->
                                <div class="card mt-4">
                                    <div class="card-header bg-white py-3">
                                        <h5 class="mb-0"><i class="bi bi-lightning me-2"></i>Quick Actions</h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="d-flex gap-2 flex-wrap">
                                            <c:if test="${booking.status == 'CONFIRMED'}">
                                                <a href="${pageContext.request.contextPath}/receptionist/checkinout"
                                                    class="btn btn-success">
                                                    <i class="bi bi-box-arrow-in-right me-1"></i>Go to Check-in
                                                </a>
                                            </c:if>
                                            <c:if test="${booking.status == 'CHECKED_IN'}">
                                                <a href="${pageContext.request.contextPath}/receptionist/checkinout"
                                                    class="btn btn-warning">
                                                    <i class="bi bi-box-arrow-right me-1"></i>Go to Check-out
                                                </a>
                                            </c:if>
                                            <a href="${pageContext.request.contextPath}/receptionist/room-detail?id=${booking.roomId}"
                                                class="btn btn-primary">
                                                <i class="bi bi-door-open me-1"></i>View Room Details
                                            </a>
                                        </div>
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