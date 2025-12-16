<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>Reservation List | HMS Owner</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
            <link rel="stylesheet" href="<c:url value='/CSS/housekeeping.css'/>">
        </head>

        <body>
            <div class="layout-wrapper">
                <jsp:include page="../Shared/OwnerSidebar.jsp" />
                <div class="main-content">
                    <jsp:include page="../Shared/Header.jsp" />

                    <div class="container-fluid p-4">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h2 class="mb-0">Reservation List</h2>
                        </div>

                        <!-- Search and Filter Row -->
                        <div class="row g-3 mb-4">
                            <div class="col-md-6">
                                <form method="GET" class="d-flex">
                                    <input type="hidden" name="status" value="${statusFilter}">
                                    <input type="text" class="form-control" name="search"
                                        placeholder="Search by ID, customer name, email, or room..."
                                        value="${searchQuery}">
                                    <button type="submit" class="btn btn-primary ms-2">
                                        <i class="bi bi-search"></i> Search
                                    </button>
                                    <c:if test="${not empty searchQuery}">
                                        <a href="?status=${statusFilter}" class="btn btn-secondary ms-2">
                                            <i class="bi bi-x-circle"></i>
                                        </a>
                                    </c:if>
                                </form>
                            </div>
                            <div class="col-md-6">
                                <div class="btn-group w-100">
                                    <a href="?status=ALL&search=${searchQuery}"
                                        class="btn btn-sm ${statusFilter == 'ALL' ? 'btn-primary' : 'btn-outline-primary'}">All</a>
                                    <a href="?status=PENDING&search=${searchQuery}"
                                        class="btn btn-sm ${statusFilter == 'PENDING' ? 'btn-warning' : 'btn-outline-warning'}">Pending</a>
                                    <a href="?status=CONFIRMED&search=${searchQuery}"
                                        class="btn btn-sm ${statusFilter == 'CONFIRMED' ? 'btn-info' : 'btn-outline-info'}">Confirmed</a>
                                    <a href="?status=CHECKED_IN&search=${searchQuery}"
                                        class="btn btn-sm ${statusFilter == 'CHECKED_IN' ? 'btn-success' : 'btn-outline-success'}">Checked
                                        In</a>
                                    <a href="?status=CHECKED_OUT&search=${searchQuery}"
                                        class="btn btn-sm ${statusFilter == 'CHECKED_OUT' ? 'btn-secondary' : 'btn-outline-secondary'}">Checked
                                        Out</a>
                                </div>
                            </div>
                        </div>

                        <div class="card shadow-sm">
                            <div class="card-body p-0">
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle mb-0">
                                        <thead class="table-light">
                                            <tr>
                                                <th>Booking ID</th>
                                                <th>Customer</th>
                                                <th>Room</th>
                                                <th>Check-in</th>
                                                <th>Check-out</th>
                                                <th>Guests</th>
                                                <th>Status</th>
                                                <th>Amount</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${bookings}" var="booking">
                                                <tr>
                                                    <td><strong>#${booking.bookingId}</strong></td>
                                                    <td>
                                                        <div>${booking.customer.fullName}</div>
                                                        <div class="small text-muted">${booking.customer.email}</div>
                                                    </td>
                                                    <td>
                                                        <strong>Room ${booking.room.roomNumber}</strong>
                                                        <div class="small text-muted">${booking.room.roomType.typeName}
                                                        </div>
                                                    </td>
                                                    <td>${booking.checkinDate}</td>
                                                    <td>${booking.checkoutDate}</td>
                                                    <td><span class="badge bg-info">${booking.numGuests}</span></td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${booking.status == 'PENDING'}">
                                                                <span class="badge bg-warning">Pending</span>
                                                            </c:when>
                                                            <c:when test="${booking.status == 'CONFIRMED'}">
                                                                <span class="badge bg-info">Confirmed</span>
                                                            </c:when>
                                                            <c:when test="${booking.status == 'CHECKED_IN'}">
                                                                <span class="badge bg-success">Checked In</span>
                                                            </c:when>
                                                            <c:when test="${booking.status == 'CHECKED_OUT'}">
                                                                <span class="badge bg-secondary">Checked Out</span>
                                                            </c:when>
                                                            <c:when test="${booking.status == 'CANCELLED'}">
                                                                <span class="badge bg-danger">Cancelled</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-dark">${booking.status}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="fw-bold">${booking.totalAmount} VND</td>
                                                </tr>
                                            </c:forEach>

                                            <c:if test="${empty bookings}">
                                                <tr>
                                                    <td colspan="8" class="text-center text-muted py-4">
                                                        No bookings found
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <!-- Pagination Info -->
                            <div class="card-footer bg-white">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div class="text-muted">
                                        Showing ${(currentPage - 1) * 10 + 1} to ${(currentPage - 1) * 10 +
                                        bookings.size()} of ${totalBookings} bookings
                                    </div>
                                    <c:if test="${totalPages > 1}">
                                        <nav>
                                            <ul class="pagination mb-0">
                                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                    <a class="page-link"
                                                        href="?status=${statusFilter}&search=${searchQuery}&page=${currentPage - 1}">
                                                        <i class="bi bi-chevron-left"></i>
                                                    </a>
                                                </li>
                                                <c:forEach begin="1" end="${totalPages}" var="i">
                                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                        <a class="page-link"
                                                            href="?status=${statusFilter}&search=${searchQuery}&page=${i}">${i}</a>
                                                    </li>
                                                </c:forEach>
                                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                                    <a class="page-link"
                                                        href="?status=${statusFilter}&search=${searchQuery}&page=${currentPage + 1}">
                                                        <i class="bi bi-chevron-right"></i>
                                                    </a>
                                                </li>
                                            </ul>
                                        </nav>
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