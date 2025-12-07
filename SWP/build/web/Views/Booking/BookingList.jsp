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
                            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                                <h5 class="mb-0"><i class="bi bi-calendar-check me-2"></i>Booking Management</h5>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle">
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
                        </div>
                    </div>

                    <jsp:include page="../Shared/Footer.jsp" />
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>