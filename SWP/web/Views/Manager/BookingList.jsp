<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>Bookings Management | HMS</title>
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
                            <h2 class="mb-0">Bookings Management</h2>
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

                        <c:if test="${not empty param.success}">
                            <c:set var="type" value="success" scope="request" />
                            <c:set var="mess" value="Inspection task assigned successfully!" scope="request" />
                        </c:if>
                        <c:if test="${not empty param.error}">
                            <c:set var="type" value="error" scope="request" />
                            <c:set var="mess" value="Failed to assign inspection task. Please try again."
                                scope="request" />
                        </c:if>
                        <jsp:include page="../public/notify.jsp" />

                        <div class="card shadow-sm">
                            <div class="card-body p-0">
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle mb-0">
                                        <thead class="table-light">
                                            <tr>
                                                <th>
                                                    <a href="?status=${statusFilter}&search=${searchQuery}&sortBy=booking_id&sortOrder=${sortBy == 'booking_id' && sortOrder == 'ASC' ? 'DESC' : 'ASC'}"
                                                        class="text-decoration-none text-dark">
                                                        Booking ID
                                                        <c:if test="${sortBy == 'booking_id'}">
                                                            <i
                                                                class="bi bi-${sortOrder == 'ASC' ? 'sort-up' : 'sort-down'}"></i>
                                                        </c:if>
                                                    </a>
                                                </th>
                                                <th>
                                                    <a href="?status=${statusFilter}&search=${searchQuery}&sortBy=customer&sortOrder=${sortBy == 'customer' && sortOrder == 'ASC' ? 'DESC' : 'ASC'}"
                                                        class="text-decoration-none text-dark">
                                                        Customer
                                                        <c:if test="${sortBy == 'customer'}">
                                                            <i
                                                                class="bi bi-${sortOrder == 'ASC' ? 'sort-up' : 'sort-down'}"></i>
                                                        </c:if>
                                                    </a>
                                                </th>
                                                <th>
                                                    <a href="?status=${statusFilter}&search=${searchQuery}&sortBy=room&sortOrder=${sortBy == 'room' && sortOrder == 'ASC' ? 'DESC' : 'ASC'}"
                                                        class="text-decoration-none text-dark">
                                                        Room
                                                        <c:if test="${sortBy == 'room'}">
                                                            <i
                                                                class="bi bi-${sortOrder == 'ASC' ? 'sort-up' : 'sort-down'}"></i>
                                                        </c:if>
                                                    </a>
                                                </th>
                                                <th>
                                                    <a href="?status=${statusFilter}&search=${searchQuery}&sortBy=checkin_date&sortOrder=${sortBy == 'checkin_date' && sortOrder == 'ASC' ? 'DESC' : 'ASC'}"
                                                        class="text-decoration-none text-dark">
                                                        Check-in
                                                        <c:if test="${sortBy == 'checkin_date'}">
                                                            <i
                                                                class="bi bi-${sortOrder == 'ASC' ? 'sort-up' : 'sort-down'}"></i>
                                                        </c:if>
                                                    </a>
                                                </th>
                                                <th>
                                                    <a href="?status=${statusFilter}&search=${searchQuery}&sortBy=checkout_date&sortOrder=${sortBy == 'checkout_date' && sortOrder == 'ASC' ? 'DESC' : 'ASC'}"
                                                        class="text-decoration-none text-dark">
                                                        Check-out
                                                        <c:if test="${sortBy == 'checkout_date'}">
                                                            <i
                                                                class="bi bi-${sortOrder == 'ASC' ? 'sort-up' : 'sort-down'}"></i>
                                                        </c:if>
                                                    </a>
                                                </th>
                                                <th>Guests</th>
                                                <th>
                                                    <a href="?status=${statusFilter}&search=${searchQuery}&sortBy=status&sortOrder=${sortBy == 'status' && sortOrder == 'ASC' ? 'DESC' : 'ASC'}"
                                                        class="text-decoration-none text-dark">
                                                        Status
                                                        <c:if test="${sortBy == 'status'}">
                                                            <i
                                                                class="bi bi-${sortOrder == 'ASC' ? 'sort-up' : 'sort-down'}"></i>
                                                        </c:if>
                                                    </a>
                                                </th>
                                                <th>
                                                    <a href="?status=${statusFilter}&search=${searchQuery}&sortBy=total_amount&sortOrder=${sortBy == 'total_amount' && sortOrder == 'ASC' ? 'DESC' : 'ASC'}"
                                                        class="text-decoration-none text-dark">
                                                        Amount
                                                        <c:if test="${sortBy == 'total_amount'}">
                                                            <i
                                                                class="bi bi-${sortOrder == 'ASC' ? 'sort-up' : 'sort-down'}"></i>
                                                        </c:if>
                                                    </a>
                                                </th>
                                                <th>Actions</th>
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
                                                    <td>
                                                        <%-- Only show Assign Check-in for CONFIRMED bookings without
                                                            check-in task --%>
                                                            <c:if
                                                                test="${booking.status == 'CONFIRMED' && !hasCheckinTask[booking.bookingId]}">
                                                                <button class="btn btn-sm btn-primary"
                                                                    data-bs-toggle="modal"
                                                                    data-bs-target="#assignModal${booking.bookingId}">
                                                                    <i class="bi bi-person-check"></i> Assign Check-in
                                                                </button>
                                                            </c:if>

                                                            <%-- Show "Preparing..." status if check-in task assigned
                                                                but not checked in yet --%>
                                                                <c:if
                                                                    test="${booking.status == 'CONFIRMED' && hasCheckinTask[booking.bookingId]}">
                                                                    <span class="text-info small">
                                                                        <i class="bi bi-hourglass-split"></i> Preparing
                                                                        room...
                                                                    </span>
                                                                </c:if>

                                                                <%-- Only show Assign Check-out when guest is CHECKED_IN
                                                                    and no checkout task assigned --%>
                                                                    <c:if
                                                                        test="${booking.status == 'CHECKED_IN' && !hasCheckoutTask[booking.bookingId]}">
                                                                        <button class="btn btn-sm btn-warning"
                                                                            data-bs-toggle="modal"
                                                                            data-bs-target="#assignCheckoutModal${booking.bookingId}">
                                                                            <i class="bi bi-box-arrow-right"></i> Assign
                                                                            Check-out
                                                                        </button>
                                                                    </c:if>

                                                                    <%-- Show "Processing checkout..." if checkout task
                                                                        assigned --%>
                                                                        <c:if
                                                                            test="${booking.status == 'CHECKED_IN' && hasCheckoutTask[booking.bookingId]}">
                                                                            <span class="text-warning small">
                                                                                <i class="bi bi-hourglass-split"></i>
                                                                                Processing checkout...
                                                                            </span>
                                                                        </c:if>

                                                                        <%-- Show status for other booking states --%>
                                                                            <c:if test="${booking.status == 'PENDING'}">
                                                                                <span class="text-muted small">Awaiting
                                                                                    confirmation</span>
                                                                            </c:if>
                                                                            <c:if
                                                                                test="${booking.status == 'CHECKED_OUT'}">
                                                                                <span class="text-success small"><i
                                                                                        class="bi bi-check-circle"></i>
                                                                                    Completed</span>
                                                                            </c:if>
                                                    </td>
                                                </tr>
                                            </c:forEach>

                                            <c:if test="${empty bookings}">
                                                <tr>
                                                    <td colspan="9" class="text-center text-muted py-4">
                                                        No bookings found
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <!-- Pagination Info - Always show -->
                            <div class="card-footer bg-white">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div class="text-muted">
                                        Showing ${(currentPage - 1) * pageSize + 1} to ${(currentPage - 1) * pageSize +
                                        bookings.size()} of ${totalBookings} bookings
                                    </div>
                                    <c:if test="${totalPages > 1}">
                                        <nav>
                                            <ul class="pagination mb-0">
                                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                    <a class="page-link"
                                                        href="?status=${statusFilter}&search=${searchQuery}&sortBy=${sortBy}&sortOrder=${sortOrder}&page=${currentPage - 1}">
                                                        <i class="bi bi-chevron-left"></i>
                                                    </a>
                                                </li>

                                                <c:forEach begin="1" end="${totalPages}" var="i">
                                                    <c:if
                                                        test="${i == 1 || i == totalPages || (i >= currentPage - 2 && i <= currentPage + 2)}">
                                                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                            <a class="page-link"
                                                                href="?status=${statusFilter}&search=${searchQuery}&sortBy=${sortBy}&sortOrder=${sortOrder}&page=${i}">${i}</a>
                                                        </li>
                                                    </c:if>
                                                    <c:if test="${i == 2 && currentPage > 4}">
                                                        <li class="page-item disabled"><span
                                                                class="page-link">...</span></li>
                                                    </c:if>
                                                    <c:if test="${i == totalPages - 1 && currentPage < totalPages - 3}">
                                                        <li class="page-item disabled"><span
                                                                class="page-link">...</span></li>
                                                    </c:if>
                                                </c:forEach>

                                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                                    <a class="page-link"
                                                        href="?status=${statusFilter}&search=${searchQuery}&sortBy=${sortBy}&sortOrder=${sortOrder}&page=${currentPage + 1}">
                                                        <i class="bi bi-chevron-right"></i>
                                                    </a>
                                                </li>
                                            </ul>
                                        </nav>
                                    </c:if>
                                </div>
                            </div>
                        </div>

                        <!-- All Modals - Outside table to avoid nesting issues -->
                        <c:forEach items="${bookings}" var="booking">
                            <!-- Checkin Modal -->
                            <div class="modal fade" id="assignModal${booking.bookingId}" tabindex="-1">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h5 class="modal-title">Assign Check-in Inspection</h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                        </div>
                                        <form method="POST">
                                            <div class="modal-body">
                                                <input type="hidden" name="bookingId" value="${booking.bookingId}">
                                                <input type="hidden" name="inspectionType" value="CHECKIN">

                                                <div class="mb-3">
                                                    <label class="form-label fw-bold">Booking Details</label>
                                                    <div class="alert alert-light">
                                                        <div><strong>Booking:</strong> #${booking.bookingId}</div>
                                                        <div><strong>Customer:</strong> ${booking.customer.fullName}
                                                        </div>
                                                        <div><strong>Room:</strong> ${booking.room.roomNumber}</div>
                                                        <div><strong>Check-in Date:</strong> ${booking.checkinDate}
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="mb-3">
                                                    <label class="form-label fw-bold">Assign to Housekeeping
                                                        Staff</label>
                                                    <select name="assignedTo" class="form-select" required>
                                                        <option value="">Select Staff</option>
                                                        <c:forEach items="${staffList}" var="staff">
                                                            <option value="${staff.userId}">${staff.fullName}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary"
                                                    data-bs-dismiss="modal">Cancel</button>
                                                <button type="submit" class="btn btn-primary">Assign Task</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>

                            <!-- Checkout Modal -->
                            <div class="modal fade" id="assignCheckoutModal${booking.bookingId}" tabindex="-1">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h5 class="modal-title">Assign Check-out Inspection</h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                        </div>
                                        <form method="POST">
                                            <div class="modal-body">
                                                <input type="hidden" name="bookingId" value="${booking.bookingId}">
                                                <input type="hidden" name="inspectionType" value="CHECKOUT">

                                                <div class="mb-3">
                                                    <label class="form-label fw-bold">Booking Details</label>
                                                    <div class="alert alert-light">
                                                        <div><strong>Booking:</strong> #${booking.bookingId}</div>
                                                        <div><strong>Customer:</strong> ${booking.customer.fullName}
                                                        </div>
                                                        <div><strong>Room:</strong> ${booking.room.roomNumber}</div>
                                                        <div><strong>Check-out Date:</strong> ${booking.checkoutDate}
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="mb-3">
                                                    <label class="form-label fw-bold">Assign to Housekeeping
                                                        Staff</label>
                                                    <select name="assignedTo" class="form-select" required>
                                                        <option value="">Select Staff</option>
                                                        <c:forEach items="${staffList}" var="staff">
                                                            <option value="${staff.userId}">${staff.fullName}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary"
                                                    data-bs-dismiss="modal">Cancel</button>
                                                <button type="submit" class="btn btn-warning">Assign Task</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <jsp:include page="../Shared/Footer.jsp" />
                </div>
            </div>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>