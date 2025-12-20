<%@ page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Reservation List | HMS</title>
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
                                    <h5 class="header-title mb-0">Reservation List</h5>
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
                                        <h2 class="mb-1">📋 Reservation List</h2>
                                        <p class="text-muted mb-0">Manage all hotel reservations.</p>
                                    </div>
                                </div>

                                <!-- Filters Card -->
                                <div class="card mb-4">
                                    <div class="card-header bg-white py-3">
                                        <h5 class="mb-0"><i class="bi bi-funnel me-2"></i>Filters</h5>
                                    </div>
                                    <div class="card-body">
                                        <form method="GET"
                                            action="${pageContext.request.contextPath}/receptionist/reservations">
                                            <div class="row g-3">
                                                <div class="col-md-2">
                                                    <label class="form-label">Status</label>
                                                    <select name="status" class="form-select">
                                                        <option value="ALL" ${status=='ALL' ? 'selected' : '' }>All
                                                            Status</option>
                                                        <option value="PENDING" ${status=='PENDING' ? 'selected' : '' }>
                                                            Pending</option>
                                                        <option value="CONFIRMED" ${status=='CONFIRMED' ? 'selected'
                                                            : '' }>Confirmed</option>
                                                        <option value="CHECKED_IN" ${status=='CHECKED_IN' ? 'selected'
                                                            : '' }>Checked In</option>
                                                        <option value="CHECKED_OUT" ${status=='CHECKED_OUT' ? 'selected'
                                                            : '' }>Checked Out</option>
                                                        <option value="CANCELLED" ${status=='CANCELLED' ? 'selected'
                                                            : '' }>Cancelled</option>
                                                    </select>
                                                </div>
                                                <div class="col-md-2">
                                                    <label class="form-label">Sort By</label>
                                                    <select name="sortBy" class="form-select">
                                                        <option value="booking_date" ${sortBy=='booking_date'
                                                            ? 'selected' : '' }>Date</option>
                                                        <option value="total_amount" ${sortBy=='total_amount'
                                                            ? 'selected' : '' }>Amount</option>
                                                        <option value="customer_name" ${sortBy=='customer_name'
                                                            ? 'selected' : '' }>Name</option>
                                                    </select>
                                                </div>
                                                <div class="col-md-3">
                                                    <label class="form-label">Search</label>
                                                    <input type="text" name="search" value="${search}"
                                                        class="form-control" placeholder="Name, email, phone...">
                                                </div>
                                                <div class="col-md-2">
                                                    <label class="form-label">From Date</label>
                                                    <input type="date" name="dateFrom" value="${dateFrom}"
                                                        class="form-control">
                                                </div>
                                                <div class="col-md-2">
                                                    <label class="form-label">To Date</label>
                                                    <input type="date" name="dateTo" value="${dateTo}"
                                                        class="form-control">
                                                </div>
                                                <div class="col-md-1 d-flex align-items-end">
                                                    <button type="submit" class="btn btn-primary w-100">
                                                        <i class="bi bi-search"></i>
                                                    </button>
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                </div>

                                <!-- Reservations Table -->
                                <div class="card">
                                    <div
                                        class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                                        <h5 class="mb-0"><i class="bi bi-list-ul me-2"></i>Reservations</h5>
                                        <span class="text-muted">
                                            Total: <strong>${totalBookings}</strong> | Page
                                            <strong>${currentPage}</strong>/<strong>${totalPages}</strong>
                                        </span>
                                    </div>
                                    <div class="card-body p-0">
                                        <div class="table-responsive">
                                            <table class="table table-hover mb-0">
                                                <thead>
                                                    <tr>
                                                        <th>ID</th>
                                                        <th>Customer</th>
                                                        <th>Room</th>
                                                        <th>Check-in</th>
                                                        <th>Check-out</th>
                                                        <th>Guests</th>
                                                        <th>Total</th>
                                                        <th>Status</th>
                                                        <th>Actions</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="booking" items="${bookings}">
                                                        <tr>
                                                            <td><strong>BK-${booking.bookingId}</strong></td>
                                                            <td>
                                                                <div class="fw-semibold">${booking.customerName}</div>
                                                                <small
                                                                    class="text-muted">${booking.customerPhone}</small>
                                                            </td>
                                                            <td>${booking.roomNumber} <small
                                                                    class="text-muted">(${booking.typeName})</small>
                                                            </td>
                                                            <td>${booking.checkinDate}</td>
                                                            <td>${booking.checkoutDate}</td>
                                                            <td>${booking.numGuests}</td>
                                                            <td class="text-success fw-semibold">
                                                                <fmt:formatNumber value="${booking.totalAmount}"
                                                                    pattern="#,###" /> đ
                                                            </td>
                                                            <td>
                                                                <span
                                                                    class="badge bg-${booking.status == 'CONFIRMED' ? 'success' : (booking.status == 'CHECKED_IN' ? 'primary' : (booking.status == 'CANCELLED' ? 'danger' : (booking.status == 'PENDING' ? 'warning' : 'secondary')))}">
                                                                    ${booking.status}
                                                                </span>
                                                            </td>
                                                            <td>
                                                                <a href="${pageContext.request.contextPath}/receptionist/reservation-detail?id=${booking.bookingId}"
                                                                    class="btn btn-sm btn-outline-primary">
                                                                    <i class="bi bi-eye"></i> View
                                                                </a>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>

                                    <!-- Pagination -->
                                    <c:if test="${totalPages > 1}">
                                        <div class="card-footer bg-white">
                                            <nav aria-label="Page navigation">
                                                <ul class="pagination justify-content-center mb-0">
                                                    <c:if test="${currentPage > 1}">
                                                        <li class="page-item">
                                                            <a class="page-link"
                                                                href="?page=${currentPage - 1}&status=${status}&search=${search}&dateFrom=${dateFrom}&dateTo=${dateTo}&sortBy=${sortBy}">
                                                                <i class="bi bi-chevron-left"></i> Previous
                                                            </a>
                                                        </li>
                                                    </c:if>

                                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                                        <c:if
                                                            test="${i <= 3 || i > totalPages - 3 || (i >= currentPage - 1 && i <= currentPage + 1)}">
                                                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                                                <a class="page-link"
                                                                    href="?page=${i}&status=${status}&search=${search}&dateFrom=${dateFrom}&dateTo=${dateTo}&sortBy=${sortBy}">${i}</a>
                                                            </li>
                                                        </c:if>
                                                        <c:if test="${i == 3 && currentPage > 5}">
                                                            <li class="page-item disabled"><span
                                                                    class="page-link">...</span></li>
                                                        </c:if>
                                                        <c:if
                                                            test="${i == currentPage + 2 && currentPage < totalPages - 4}">
                                                            <li class="page-item disabled"><span
                                                                    class="page-link">...</span></li>
                                                        </c:if>
                                                    </c:forEach>

                                                    <c:if test="${currentPage < totalPages}">
                                                        <li class="page-item">
                                                            <a class="page-link"
                                                                href="?page=${currentPage + 1}&status=${status}&search=${search}&dateFrom=${dateFrom}&dateTo=${dateTo}&sortBy=${sortBy}">
                                                                Next <i class="bi bi-chevron-right"></i>
                                                            </a>
                                                        </li>
                                                    </c:if>
                                                </ul>
                                            </nav>
                                        </div>
                                    </c:if>
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
                    <%@ include file="../public/notify.jsp" %>
                </body>

                </html>