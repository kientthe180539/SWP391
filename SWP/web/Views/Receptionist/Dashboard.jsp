<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Receptionist Dashboard - Hotel Management</title>
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/receptionist.css">
                </head>

                <body>
                    <header>
                        <!-- Changed logo from Vietnamese to English -->
                        <div class="logo">🏨 Hotel Management</div>
                        <div class="header-right">
                            <div class="nav-links">
                                <a href="${pageContext.request.contextPath}/receptionist/dashboard"
                                    class="active">Dashboard</a>
                                <a href="${pageContext.request.contextPath}/receptionist/reservations">Reservations</a>
                                <a href="${pageContext.request.contextPath}/receptionist/checkinout">Check-in/out</a>
                                <a href="${pageContext.request.contextPath}/receptionist/room-status">Rooms</a>
                                <a href="${pageContext.request.contextPath}/receptionist/schedule">My Shift</a>
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
                        <!-- Changed title from Vietnamese to English -->
                        <h1 class="page-title">📊 Receptionist Dashboard</h1>

                        <!-- Statistics Cards -->
                        <div class="stats-grid">
                            <div class="stat-card confirmed">
                                <h3>Confirmed</h3>
                                <div class="number">${stats.confirmed}</div>
                                <p>Ready to check-in</p>
                            </div> 
                            <div class="stat-card checkedin">
                                <h3>Checked In</h3>
                                <div class="number">${stats.checkedIn}</div>
                                <p>Current guests</p>
                            </div>
                            <div class="stat-card arrivals">
                                <h3>Today's Arrivals</h3>
                                <div class="number">${stats.todayArrivals}</div>
                                <p>Expected check-ins</p>
                            </div>
                        </div>

                        <!-- Quick Actions -->
                        <div class="actions-section">
                            <h2>⚡ Quick Actions</h2>
                            <div
                                style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 15px;">
                                <!-- Removed Approvals link -->

                                <a href="${pageContext.request.contextPath}/receptionist/reservations"
                                    class="btn btn-primary"
                                    style="background: linear-gradient(135deg, #28a745 0%, #20c997 100%);">
                                    📋 Reservation List
                                </a>
                                <a href="${pageContext.request.contextPath}/receptionist/checkinout"
                                    class="btn btn-primary"
                                    style="background: linear-gradient(135deg, #dc3545 0%, #e85d6d 100%);">
                                    🔑 Check-in/Check-out
                                </a>
                                <a href="${pageContext.request.contextPath}/receptionist/direct-booking"
                                    class="btn btn-primary"
                                    style="background: linear-gradient(135deg, #fd7e14 0%, #fd9843 100%);">
                                    ➕ Direct Booking
                                </a>
                            </div>
                        </div>

                        <!-- Today's Arrivals -->
                        <c:if test="${not empty todayArrivals}">
                            <div class="section">
                                <h2>🛎️ Today's Arrivals</h2>
                                <table>
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
                                                <td><strong>BK-${arrival.bookingId}</strong></td>
                                                <td>
                                                    <strong>${arrival.customerName}</strong><br>
                                                    <small style="color: #777;">${arrival.customerPhone}</small>
                                                </td>
                                                <td>${arrival.roomNumber} <small>(${arrival.typeName})</small></td>
                                                <td>${arrival.numGuests} guests</td>
                                                <td>
                                                    <span class="badge badge-${fn:toLowerCase(arrival.status)}">
                                                        ${arrival.status}
                                                    </span>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:if>

                        <!-- Recent Bookings -->
                        <c:if test="${not empty recentBookings}">
                            <div class="section">
                                <h2>📝 Recent Bookings</h2>
                                <table>
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
                                                <td><strong>BK-${booking.bookingId}</strong></td>
                                                <td>${booking.customerName}</td>
                                                <td>${booking.roomNumber}</td>
                                                <td>
                                                    <span class="badge badge-${fn:toLowerCase(booking.status)}">
                                                        ${booking.status}
                                                    </span>
                                                </td>
                                                <td><small>${fn:replace(fn:substring(booking.createdAt, 0, 16), 'T', '
                                                        ')}</small></td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:if>
                    </div>

                    <footer>
                        <!-- Updated footer text to English -->
                        <p>&copy; 2025 Hotel Management System. All rights reserved.</p>
                    </footer>
                </body>

                </html>