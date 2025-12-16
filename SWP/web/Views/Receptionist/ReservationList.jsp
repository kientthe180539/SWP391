<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Reservation List - Receptionist</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/receptionist.css">
    </head>

    <body>
        <header>
            <div class="logo">🏨 Hotel Management</div>
            <div class="header-right">
                <div class="nav-links">
                    <a href="${pageContext.request.contextPath}/receptionist/dashboard" class="active">Dashboard</a>
                    <a href="${pageContext.request.contextPath}/reservation_approval">Approvals</a>
                    <a href="${pageContext.request.contextPath}/receptionist/reservations">Reservations</a>
                    <a href="${pageContext.request.contextPath}/receptionist/checkinout">Check-in/out</a>
                    <a href="${pageContext.request.contextPath}/receptionist/room-status">Rooms</a>
                    <a href="${pageContext.request.contextPath}/receptionist/profile">Profile</a>
                    <a href="${pageContext.request.contextPath}/logout">Logout</a>
                </div>
                <div class="staff-profile">
                    <span>${sessionScope.currentUser.fullName}</span>
                    <div class="staff-avatar">${fn:substring(sessionScope.currentUser.fullName, 0, 2)}</div>
                </div>
            </div>
        </header>

        <div class="container">
            <h1 class="page-title">📋 Reservation List</h1>

            <!-- Filters -->
            <div class="filter-section">
                <form method="GET" action="${pageContext.request.contextPath}/receptionist/reservations">
                    <div class="filter-grid">
                        <select name="status">
                            <option value="ALL" ${status=='ALL' ? 'selected' : '' }>All Status</option>
                            <option value="PENDING" ${status=='PENDING' ? 'selected' : '' }>Pending</option>
                            <option value="CONFIRMED" ${status=='CONFIRMED' ? 'selected' : '' }>Confirmed</option>
                            <option value="CHECKED_IN" ${status=='CHECKED_IN' ? 'selected' : '' }>Checked In</option>
                            <option value="CHECKED_OUT" ${status=='CHECKED_OUT' ? 'selected' : '' }>Checked Out</option>
                            <option value="CANCELLED" ${status=='CANCELLED' ? 'selected' : '' }>Cancelled</option>
                        </select>
                        <input type="text" name="search" value="${search}"
                               placeholder="Search by name, email, phone...">
                        <input type="date" name="dateFrom" value="${dateFrom}" placeholder="From date">
                        <input type="date" name="dateTo" value="${dateTo}" placeholder="To date">
                    </div>
                    <button type="submit" class="btn btn-primary">🔍 Search</button>
                </form>
            </div>

            <!-- Table -->
            <div class="table-section">
                <p style="margin-bottom: 20px; color: #777; font-size: 15px;">
                    Total: <strong style="color: #1e3c72;">${totalBookings}</strong> bookings |
                    Page <strong style="color: #1e3c72;">${currentPage}</strong>/<strong style="color: #1e3c72;">${totalPages}</strong>
                </p>
                <div style="overflow-x: auto;">
                    <table>
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
                                <th>Details</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="booking" items="${bookings}">
                                <tr>
                                    <td><strong>BK-${booking.bookingId}</strong></td>
                                    <td>
                                        <strong>${booking.customerName}</strong><br>
                                        <small style="color: #777;">${booking.customerPhone}</small>
                                    </td>
                                    <td>${booking.roomNumber} <small>(${booking.typeName})</small></td>
                                    <td>${booking.checkinDate}</td>
                                    <td>${booking.checkoutDate}</td>
                                    <td>${booking.numGuests}</td>
                                    <td class="price">
                                        <fmt:formatNumber value="${booking.totalAmount}" pattern="#,###" />
                                        đ
                                    </td>
                                    <td><span
                                            class="badge badge-${fn:toLowerCase(booking.status)}">${booking.status}</span>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/receptionist/reservation-detail?id=${booking.bookingId}"
                                           style="color: #2a5298; text-decoration: none; font-weight: 600;">View →</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <div class="pagination">
                        <c:if test="${currentPage > 1}">
                            <a
                                href="?page=${currentPage - 1}&status=${status}&search=${search}&dateFrom=${dateFrom}&dateTo=${dateTo}">«
                                Previous</a>
                            </c:if>

                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <c:if
                                test="${i <= 3 || i > totalPages - 3 || (i >= currentPage - 1 && i <= currentPage + 1)}">
                                <a href="?page=${i}&status=${status}&search=${search}&dateFrom=${dateFrom}&dateTo=${dateTo}"
                                   class="${i == currentPage ? 'active' : ''}">${i}</a>
                            </c:if>
                            <c:if test="${i == 3 && currentPage > 5}">
                                <span>...</span>
                            </c:if>
                            <c:if test="${i == currentPage + 2 && currentPage < totalPages - 4}">
                                <span>...</span>
                            </c:if>
                        </c:forEach>

                        <c:if test="${currentPage < totalPages}">
                            <a
                                href="?page=${currentPage + 1}&status=${status}&search=${search}&dateFrom=${dateFrom}&dateTo=${dateTo}">Next »</a>
                        </c:if>
                    </div>
                </c:if>
            </div>
        </div>

        <footer>
            <p>&copy; 2025 Hotel Management System. All rights reserved.</p>
        </footer>
    </body>

</html>
