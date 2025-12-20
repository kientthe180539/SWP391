<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Booking List | HMS</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
        </head>

        <body>
            <div class="d-flex">
                <jsp:include page="../Shared/Sidebar.jsp" />
                <div class="flex-grow-1">
                    <jsp:include page="../Shared/Header.jsp" />

                    <div class="container-fluid p-4">
                        <div class="card shadow-sm">
                            <div class="card-header bg-white py-3">
                                <form action="<c:url value='/booking/list'/>" method="get">
                                    <div class="row g-3">
                                        <div class="col-md-4">
                                            <div class="input-group input-group-sm">
                                                <span class="input-group-text bg-light border-end-0"><i
                                                        class="bi bi-search"></i></span>
                                                <input type="text" name="search" class="form-control border-start-0"
                                                    placeholder="Search by ID, Customer ID..." value="${search}">
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <select name="status" class="form-select form-select-sm">
                                                <option value="">All Status</option>
                                                <option value="PENDING" ${status=='PENDING' ? 'selected' : '' }>Pending
                                                </option>
                                                <option value="CONFIRMED" ${status=='CONFIRMED' ? 'selected' : '' }>
                                                    Confirmed</option>
                                                <option value="CHECKED_IN" ${status=='CHECKED_IN' ? 'selected' : '' }>
                                                    Checked In</option>
                                                <option value="CHECKED_OUT" ${status=='CHECKED_OUT' ? 'selected' : '' }>
                                                    Checked Out</option>
                                                <option value="CANCELLED" ${status=='CANCELLED' ? 'selected' : '' }>
                                                    Cancelled</option>
                                            </select>
                                        </div>
                                        <div class="col-md-3">
                                            <select name="sortBy" class="form-select form-select-sm">
                                                <option value="checkin_date" ${sortBy=='checkin_date' ? 'selected' : ''
                                                    }>
                                                    Sort by Check-in</option>
                                                <option value="booking_id" ${sortBy=='booking_id' ? 'selected' : '' }>
                                                    Sort by ID</option>
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
                                    <table class="table table-hover align-middle mb-0">
                                        <thead class="table-light">
                                            <tr>
                                                <th>ID</th>
                                                <th>Room ID</th>
                                                <th>Customer ID</th>
                                                <th>Check-in</th>
                                                <th>Check-out</th>
                                                <th>Status</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:if test="${empty bookings}">
                                                <tr>
                                                    <td colspan="7" class="text-center py-5 text-muted">
                                                        <i class="bi bi-calendar-x fs-1 d-block mb-2"></i>
                                                        No bookings found.
                                                    </td>
                                                </tr>
                                            </c:if>
                                            <c:forEach items="${bookings}" var="b">
                                                <tr>
                                                    <td>#${b.bookingId}</td>
                                                    <td>${b.roomId}</td>
                                                    <td>${b.customerId}</td>
                                                    <td>${b.checkinDate}</td>
                                                    <td>${b.checkoutDate}</td>
                                                    <td>
                                                        <span class="badge rounded-pill 
                                                    ${b.status == 'CONFIRMED' ? 'text-bg-primary' : 
                                                      b.status == 'CHECKED_IN' ? 'text-bg-success' : 
                                                      b.status == 'CHECKED_OUT' ? 'text-bg-secondary' : 
                                                      b.status == 'CANCELLED' ? 'text-bg-danger' : 'text-bg-warning'}">
                                                            ${b.status}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <div class="btn-group btn-group-sm">
                                                            <c:if test="${b.status == 'CONFIRMED'}">
                                                                <form action="<c:url value='/booking/checkin'/>"
                                                                    method="post" class="d-inline">
                                                                    <input type="hidden" name="action" value="checkIn">
                                                                    <input type="hidden" name="bookingId"
                                                                        value="${b.bookingId}">
                                                                    <button type="submit"
                                                                        class="btn btn-outline-success"
                                                                        title="Check In">
                                                                        <i class="bi bi-box-arrow-in-right"></i>
                                                                    </button>
                                                                </form>
                                                            </c:if>
                                                            <c:if test="${b.status == 'CHECKED_IN'}">
                                                                <form action="<c:url value='/booking/checkout'/>"
                                                                    method="post" class="d-inline">
                                                                    <input type="hidden" name="action" value="checkOut">
                                                                    <input type="hidden" name="bookingId"
                                                                        value="${b.bookingId}">
                                                                    <button type="submit"
                                                                        class="btn btn-outline-warning"
                                                                        title="Check Out">
                                                                        <i class="bi bi-box-arrow-right"></i>
                                                                    </button>
                                                                </form>
                                                            </c:if>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            <div class="card-footer bg-white py-3">
                                <nav class="d-flex justify-content-between align-items-center">
                                    <small class="text-muted">Showing ${bookings.size()} of ${totalBookings}
                                        bookings</small>
                                    <c:if test="${totalPages > 1}">
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