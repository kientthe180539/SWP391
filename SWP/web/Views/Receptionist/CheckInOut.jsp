<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Check-in / Check-out - Receptionist</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/receptionist.css">
    </head>

    <body>
        <header>
            <div class="logo">🏨 Hotel Management</div>
            <div class="header-right">
                <div class="nav-links">
                    <a href="${pageContext.request.contextPath}/receptionist/dashboard">Dashboard</a>
                    <a href="${pageContext.request.contextPath}/reservation_approval">Approvals</a>
                    <a href="${pageContext.request.contextPath}/receptionist/reservations">Reservations</a>
                    <a href="${pageContext.request.contextPath}/receptionist/checkinout"
                       class="active">Check-in/out</a>
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
            <h1 class="page-title">🔑 Check-in / Check-out Management</h1>

            <!-- Success/Error Messages -->
            <c:if test="${not empty sessionScope.success}">
                <div class="alert alert-success">
                    ✓ ${sessionScope.success}
                </div>
                <c:remove var="success" scope="session" />
            </c:if>

            <c:if test="${not empty sessionScope.error}">
                <div class="alert alert-error">
                    ✗ ${sessionScope.error}
                </div>
                <c:remove var="error" scope="session" />
            </c:if>

            <!-- Ready for Check-in Section -->
            <div class="section">
                <h2>✅ Ready for Check-in (${fn:length(readyForCheckIn)})</h2>
                <c:choose>
                    <c:when test="${empty readyForCheckIn}">
                        <div class="empty-state">
                            <p>No bookings ready for check-in at the moment</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div style="overflow-x: auto;">
                            <table>
                                <thead>
                                    <tr>
                                        <th>Booking ID</th>
                                        <th>Customer</th>
                                        <th>Room</th>
                                        <th>Check-in Date</th>
                                        <th>Check-out Date</th>
                                        <th>Guests</th>
                                        <th>Total Amount</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="booking" items="${readyForCheckIn}">
                                        <tr>
                                            <td><strong>#${booking.bookingId}</strong></td>
                                            <td>
                                                <strong>${booking.customerName}</strong><br>
                                                <small style="color: #777;">${booking.customerPhone}</small>
                                            </td>
                                            <td>
                                                <strong>Room ${booking.roomNumber}</strong><br>
                                                <small style="color: #777;">${booking.typeName}</small>
                                            </td>
                                            <td>${booking.checkinDate}</td>
                                            <td>${booking.checkoutDate}</td>
                                            <td>${booking.numGuests} guests</td>
                                            <td class="price">
                                                <fmt:formatNumber value="${booking.totalAmount}"
                                                                  pattern="#,###" /> VND
                                            </td>
                                            <td>
                                                <button class="btn btn-primary"
                                                        style="padding: 8px 16px; font-size: 13px;"
                                                        onclick="confirmCheckIn(${booking.bookingId}, '${booking.customerName}', '${booking.roomNumber}')">
                                                    Check In
                                                </button>

                                                <button class="btn btn-danger"
                                                        style="margin-left: 6px"
                                                        onclick="confirmNoShow(${booking.bookingId}, '${booking.customerName}')">
                                                    No Show
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                        <div id="checkin-pagination" class="pagination"></div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Currently Checked In Section -->
            <div class="section">
                <h2>🏨 Currently Checked In (${fn:length(checkedIn)})</h2>
                <c:choose>
                    <c:when test="${empty checkedIn}">
                        <div class="empty-state">
                            <p>No guests currently checked in</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div style="overflow-x: auto;">
                            <table id="checked-in-table">
                                <thead>
                                    <tr>
                                        <th>Booking ID</th>
                                        <th>Customer</th>
                                        <th>Room</th>
                                        <th>Check-in Date</th>
                                        <th>Check-out Date</th>
                                        <th>Guests</th>
                                        <th>Total Amount</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="booking" items="${checkedIn}">
                                        <tr>
                                            <td><strong>#${booking.bookingId}</strong></td>
                                            <td>
                                                <strong>${booking.customerName}</strong><br>
                                                <small style="color: #777;">${booking.customerPhone}</small>
                                            </td>
                                            <td>
                                                <strong>Room ${booking.roomNumber}</strong><br>
                                                <small style="color: #777;">${booking.typeName}</small>
                                            </td>
                                            <td>${booking.checkinDate}</td>
                                            <td>${booking.checkoutDate}</td>
                                            <td>${booking.numGuests} guests</td>
                                            <td class="price">
                                                <fmt:formatNumber value="${booking.totalAmount}"
                                                                  pattern="#,###" /> VND
                                            </td>
                                            <td>
                                                <button class="btn btn-approve"
                                                        style="padding: 8px 16px; font-size: 13px;"
                                                        onclick="confirmCheckOut(${booking.bookingId}, '${booking.customerName}', '${booking.roomNumber}')">
                                                    Check Out
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                        <div id="checkout-pagination" class="pagination"></div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- No Show Confirmation Modal -->
        <div id="noShowModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">Confirm No Show</div>
                <div class="modal-body">
                    <p id="noShowMessage"></p>
                </div>
                <form method="post"
                      action="${pageContext.request.contextPath}/receptionist/checkinout">
                    <input type="hidden" name="action" value="noshow">
                    <input type="hidden" name="bookingId" id="noShowBookingId">
                    <div class="modal-buttons">
                        <button type="button" class="btn btn-cancel"
                                onclick="closeModal('noShowModal')">Cancel</button>
                        <button type="submit" class="btn btn-danger">Confirm</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Check-in Confirmation Modal -->
        <div id="checkInModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">Confirm Check-in</div>
                <div class="modal-body">
                    <p id="checkInMessage"></p>
                </div>
                <form id="checkInForm" method="post"
                      action="${pageContext.request.contextPath}/receptionist/checkinout">
                    <input type="hidden" name="action" value="checkin">
                    <input type="hidden" name="bookingId" id="checkInBookingId">
                    <div class="modal-buttons">
                        <button type="button" class="btn btn-cancel"
                                onclick="closeModal('checkInModal')">Cancel</button>
                        <button type="submit" class="btn btn-primary">Confirm</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Check-out Confirmation Modal -->
        <div id="checkOutModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">Confirm Check-out</div>
                <div class="modal-body">
                    <p id="checkOutMessage"></p>
                </div>
                <form id="checkOutForm" method="post"
                      action="${pageContext.request.contextPath}/receptionist/checkinout">
                    <input type="hidden" name="action" value="checkout">
                    <input type="hidden" name="bookingId" id="checkOutBookingId">
                    <div class="modal-buttons">
                        <button type="button" class="btn btn-cancel"
                                onclick="closeModal('checkOutModal')">Cancel</button>
                        <button type="submit" class="btn btn-approve">Confirm</button>
                    </div>
                </form>
            </div>
        </div>

        <footer>
            <p>&copy; 2025 Hotel Management System. All rights reserved.</p>
        </footer>
        <%@ include file="../public/notify.jsp" %>

        <script>
            function confirmCheckIn(bookingId, customerName, roomNumber) {
                document.getElementById('checkInBookingId').value = bookingId;
                document.getElementById('checkInMessage').innerHTML =
                        'Check in <strong>' + customerName + '</strong> to <strong>Room ' + roomNumber + '</strong>?';
                document.getElementById('checkInModal').style.display = 'block';
            }

            function confirmCheckOut(bookingId, customerName, roomNumber) {
                document.getElementById('checkOutBookingId').value = bookingId;
                document.getElementById('checkOutMessage').innerHTML =
                        'Check out <strong>' + customerName + '</strong> from <strong>Room ' + roomNumber + '</strong>?';
                document.getElementById('checkOutModal').style.display = 'block';
            }

            function confirmNoShow(bookingId, customerName) {
                document.getElementById("noShowBookingId").value = bookingId;
                document.getElementById("noShowMessage").innerText =
                        "Mark booking #" + bookingId + " (" + customerName + ") as NO SHOW?";
                document.getElementById("noShowModal").style.display = "flex";
            }

            function closeModal(modalId) {
                document.getElementById(modalId).style.display = 'none';
            }

            // Close modal when clicking outside
            window.onclick = function (event) {
                if (event.target.classList.contains('modal')) {
                    event.target.style.display = 'none';
                }
            }
        </script>
        <script src="${pageContext.request.contextPath}/js/pagination.js"></script>
        <script>
            // Initialize pagination when DOM loaded
            document.addEventListener('DOMContentLoaded', function () {
                // Paginate ready for check-in table
                const readyTable = document.querySelector('.section table');
                if (readyTable) {
                    const rows = readyTable.querySelectorAll('tbody tr');
                    if (rows.length > 10) {
                        paginateTable('.section table', 10, 'checkin-pagination');
                    }
                }

                // Paginate checked-in table
                const checkedInTable = document.getElementById('checked-in-table');
                if (checkedInTable) {
                    const rows = checkedInTable.querySelectorAll('tbody tr');
                    if (rows.length > 10) {
                        paginateTable('#checked-in-table', 10, 'checkout-pagination');
                    }
                }
            });
        </script>
    </body>

</html>
