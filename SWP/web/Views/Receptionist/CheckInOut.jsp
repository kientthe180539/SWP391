<%@ page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Check-in/out | HMS</title>
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
                                    <h5 class="header-title mb-0">Check-in / Check-out</h5>
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
                                <div class="d-flex justify-content-between align-items-center mb-4">
                                    <div>
                                        <h2 class="mb-1">🔑 Check-in / Check-out Management</h2>
                                        <p class="text-muted mb-0">Manage guest arrivals and departures.</p>
                                    </div>
                                </div>

                                <!-- Ready for Check-in Section -->
                                <div class="card mb-4">
                                    <div
                                        class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                                        <h5 class="mb-0 text-success">
                                            <i class="bi bi-check-circle me-2"></i>Ready for Check-in
                                        </h5>
                                        <span class="badge bg-success">${fn:length(readyForCheckIn)}</span>
                                    </div>
                                    <div class="card-body p-0">
                                        <c:choose>
                                            <c:when test="${empty readyForCheckIn}">
                                                <div class="text-center py-5 text-muted">
                                                    <i class="bi bi-inbox fs-1"></i>
                                                    <p class="mt-2">No bookings ready for check-in at the moment</p>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="table-responsive">
                                                    <table class="table table-hover mb-0">
                                                        <thead>
                                                            <tr>
                                                                <th>Booking ID</th>
                                                                <th>Customer</th>
                                                                <th>Room</th>
                                                                <th>Check-in</th>
                                                                <th>Check-out</th>
                                                                <th>Guests</th>
                                                                <th>Total</th>
                                                                <th>Actions</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <c:forEach var="booking" items="${readyForCheckIn}">
                                                                <tr>
                                                                    <td><strong>#${booking.bookingId}</strong></td>
                                                                    <td>
                                                                        <div class="fw-semibold">${booking.customerName}
                                                                        </div>
                                                                        <small
                                                                            class="text-muted">${booking.customerPhone}</small>
                                                                    </td>
                                                                    <td>
                                                                        <div class="fw-semibold">Room
                                                                            ${booking.roomNumber}</div>
                                                                        <small
                                                                            class="text-muted">${booking.typeName}</small>
                                                                    </td>
                                                                    <td>${booking.checkinDate}</td>
                                                                    <td>${booking.checkoutDate}</td>
                                                                    <td>${booking.numGuests} guests</td>
                                                                    <td class="text-success fw-semibold">
                                                                        <fmt:formatNumber value="${booking.totalAmount}"
                                                                            pattern="#,###" /> VND
                                                                    </td>
                                                                    <td>
                                                                        <button class="btn btn-success btn-sm"
                                                                            onclick="confirmCheckIn(${booking.bookingId}, '${booking.customerName}', '${booking.roomNumber}')">
                                                                            <i class="bi bi-box-arrow-in-right"></i>
                                                                            Check In
                                                                        </button>
                                                                        <button class="btn btn-danger btn-sm ms-1"
                                                                            onclick="confirmNoShow(${booking.bookingId}, '${booking.customerName}')">
                                                                            No Show
                                                                        </button>
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

                                <!-- Currently Checked In Section -->
                                <div class="card">
                                    <div
                                        class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                                        <h5 class="mb-0 text-primary">
                                            <i class="bi bi-building me-2"></i>Currently Checked In
                                        </h5>
                                        <span class="badge bg-primary">${fn:length(checkedIn)}</span>
                                    </div>
                                    <div class="card-body p-0">
                                        <c:choose>
                                            <c:when test="${empty checkedIn}">
                                                <div class="text-center py-5 text-muted">
                                                    <i class="bi bi-building fs-1"></i>
                                                    <p class="mt-2">No guests currently checked in</p>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="table-responsive">
                                                    <table class="table table-hover mb-0" id="checked-in-table">
                                                        <thead>
                                                            <tr>
                                                                <th>Booking ID</th>
                                                                <th>Customer</th>
                                                                <th>Room</th>
                                                                <th>Check-in</th>
                                                                <th>Check-out</th>
                                                                <th>Guests</th>
                                                                <th>Total</th>
                                                                <th>Actions</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <c:forEach var="booking" items="${checkedIn}">
                                                                <tr>
                                                                    <td><strong>#${booking.bookingId}</strong></td>
                                                                    <td>
                                                                        <div class="fw-semibold">${booking.customerName}
                                                                        </div>
                                                                        <small
                                                                            class="text-muted">${booking.customerPhone}</small>
                                                                    </td>
                                                                    <td>
                                                                        <div class="fw-semibold">Room
                                                                            ${booking.roomNumber}</div>
                                                                        <small
                                                                            class="text-muted">${booking.typeName}</small>
                                                                    </td>
                                                                    <td>${booking.checkinDate}</td>
                                                                    <td>${booking.checkoutDate}</td>
                                                                    <td>${booking.numGuests} guests</td>
                                                                    <td class="text-success fw-semibold">
                                                                        <fmt:formatNumber value="${booking.totalAmount}"
                                                                            pattern="#,###" /> VND
                                                                    </td>
                                                                    <td>
                                                                        <button class="btn btn-warning btn-sm"
                                                                            onclick="confirmCheckOut(${booking.bookingId}, '${booking.customerName}', '${booking.roomNumber}')">
                                                                            <i class="bi bi-box-arrow-right"></i> Check
                                                                            Out
                                                                        </button>
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

                    <!-- No Show Modal -->
                    <div class="modal fade" id="noShowModal" tabindex="-1">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header bg-danger text-white">
                                    <h5 class="modal-title">Confirm No Show</h5>
                                    <button type="button" class="btn-close btn-close-white"
                                        data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body">
                                    <p id="noShowMessage"></p>
                                </div>
                                <form method="post" action="${pageContext.request.contextPath}/receptionist/checkinout">
                                    <input type="hidden" name="action" value="noshow">
                                    <input type="hidden" name="bookingId" id="noShowBookingId">
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary"
                                            data-bs-dismiss="modal">Cancel</button>
                                        <button type="submit" class="btn btn-danger">Confirm No Show</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- Check-in Modal -->
                    <div class="modal fade" id="checkInModal" tabindex="-1">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header bg-success text-white">
                                    <h5 class="modal-title">Confirm Check-in</h5>
                                    <button type="button" class="btn-close btn-close-white"
                                        data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body">
                                    <p id="checkInMessage"></p>
                                </div>
                                <form method="post" action="${pageContext.request.contextPath}/receptionist/checkinout">
                                    <input type="hidden" name="action" value="checkin">
                                    <input type="hidden" name="bookingId" id="checkInBookingId">
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary"
                                            data-bs-dismiss="modal">Cancel</button>
                                        <button type="submit" class="btn btn-success">Confirm Check-in</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- Check-out Modal -->
                    <div class="modal fade" id="checkOutModal" tabindex="-1">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header bg-warning text-dark">
                                    <h5 class="modal-title">Confirm Check-out</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body">
                                    <p id="checkOutMessage"></p>
                                </div>
                                <form method="post" action="${pageContext.request.contextPath}/receptionist/checkinout">
                                    <input type="hidden" name="action" value="checkout">
                                    <input type="hidden" name="bookingId" id="checkOutBookingId">
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary"
                                            data-bs-dismiss="modal">Cancel</button>
                                        <button type="submit" class="btn btn-warning">Confirm Check-out</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
                    <script>
                        document.getElementById('sidebarToggle')?.addEventListener('click', function () {
                            document.querySelector('.sidebar').classList.toggle('show');
                        });

                        function confirmCheckIn(bookingId, customerName, roomNumber) {
                            document.getElementById('checkInBookingId').value = bookingId;
                            document.getElementById('checkInMessage').innerHTML =
                                'Check in <strong>' + customerName + '</strong> to <strong>Room ' + roomNumber + '</strong>?';
                            new bootstrap.Modal(document.getElementById('checkInModal')).show();
                        }

                        function confirmCheckOut(bookingId, customerName, roomNumber) {
                            document.getElementById('checkOutBookingId').value = bookingId;
                            document.getElementById('checkOutMessage').innerHTML =
                                'Check out <strong>' + customerName + '</strong> from <strong>Room ' + roomNumber + '</strong>?';
                            new bootstrap.Modal(document.getElementById('checkOutModal')).show();
                        }

                        function confirmNoShow(bookingId, customerName) {
                            document.getElementById('noShowBookingId').value = bookingId;
                            document.getElementById('noShowMessage').innerText =
                                'Mark booking #' + bookingId + ' (' + customerName + ') as NO SHOW?';
                            new bootstrap.Modal(document.getElementById('noShowModal')).show();
                        }
                    </script>
                    <%@ include file="../public/notify.jsp" %>
                </body>

                </html>