<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>My Bookings - Hotel Name</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/Booking/my_booking.css">
    </head>

    <body>
        <%@ include file="../../Components/Header.jsp" %>

        <main>
            <div class="back-home">
                <a href="${pageContext.request.contextPath}/home" class="btn-back-home">← Back to Home</a>
            </div>

            <h1 class="page-title">My Bookings</h1>

            <div class="filter-section">
                <input type="text" id="searchInput"
                       placeholder="🔍 Search by booking ID, room name, guest name..."
                       oninput="filterBookings()" class="search-input" />

                <select id="statusFilter" onchange="filterBookings()">
                    <option value="all">All Statuses</option>
                    <option value="PENDING">⏳ Pending</option>
                    <option value="CONFIRMED">✓ Confirmed</option>
                    <option value="CHECKED_IN">📍 Checked In</option>
                    <option value="CHECKED_OUT">✓ Checked Out</option>
                    <option value="CANCELLED">✗ Cancelled</option>
                </select>
                <select id="dateFilter" onchange="filterBookings()">
                    <option value="all">All Time</option>
                    <option value="upcoming">Upcoming</option>
                    <option value="past">Past</option>
                </select>
            </div>

            <div class="bookings-container" id="bookingsContainer">
                <!-- Dynamic Booking Cards from Database -->
                <% pageContext.setAttribute("now", java.time.LocalDate.now()); %>
                <c:forEach items="${bookings}" var="booking">
                    <c:set var="statusClass"
                           value="${booking.status.toString().toLowerCase().replace('_', '-')}" />
                    <c:set var="isUpcoming" value="${booking.checkinDate.isAfter(now)}" />

                    <div class="booking-card" data-status="${booking.status}"
                         data-date="${isUpcoming ? 'upcoming' : 'past'}"
                         data-booking-id="${booking.bookingId}">
                        <div class="booking-card-header">
                            <div>
                                <div class="booking-id">Booking ID: #${booking.bookingId}</div>
                                <div style="font-size: 12px; margin-top: 5px;">Booked on:
                                    ${booking.createdAt}</div>
                            </div>
                            <span class="booking-status status-${statusClass}">${booking.status}</span>
                        </div>
                        <div class="booking-card-body">
                            <div class="booking-info">
                                <div class="info-box">
                                    <div class="info-box-label">Room</div>
                                    <div class="info-box-value">Room #${booking.roomId}</div>
                                </div>
                                <div class="info-box">
                                    <div class="info-box-label">Check-in</div>
                                    <div class="info-box-value">${booking.checkinDate}</div>
                                </div>
                                <div class="info-box">
                                    <div class="info-box-label">Check-out</div>
                                    <div class="info-box-value">${booking.checkoutDate}</div>
                                </div>
                                <div class="info-box">
                                    <div class="info-box-label">Duration</div>
                                    <div class="info-box-value">
                                        ${java.time.temporal.ChronoUnit.DAYS.between(booking.checkinDate,
                                          booking.checkoutDate)} nights
                                    </div>
                                </div>
                            </div>
                            <div class="booking-details">
                                <div class="detail-item">
                                    <div class="detail-label">Guest Name</div>
                                    <div class="detail-value">${sessionScope.currentUser.fullName}</div>
                                </div>
                                <div class="detail-item">
                                    <div class="detail-label">Guests</div>
                                    <div class="detail-value">${booking.numGuests} people</div>
                                </div>
                                <div class="detail-item">
                                    <div class="detail-label">Total Price</div>
                                    <div class="detail-value">$
                                        <fmt:formatNumber value="${booking.totalAmount}"
                                                          pattern="#,##0.00" />
                                    </div>
                                </div>
                                <div class="detail-item">
                                    <div class="detail-label">Payment</div>
                                    <div class="detail-value">
                                        <c:choose>
                                            <c:when test="${booking.status == 'PENDING'}">Unpaid
                                            </c:when>
                                            <c:otherwise>Paid</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="booking-card-footer">
                            <button class="btn btn-primary" onclick="viewDetails(this)"
                                    data-id="${booking.bookingId}" data-status="${booking.status}"
                                    data-name="${sessionScope.currentUser.fullName}"
                                    data-room="Room #${booking.roomId}"
                                    data-checkin="${booking.checkinDate}"
                                    data-checkout="${booking.checkoutDate}"
                                    data-guests="${booking.numGuests} people"
                                    data-price="$<fmt:formatNumber value='${booking.totalAmount}' pattern='#,##0.00' />"
                                    data-note="None">
                                Details
                            </button>

                            <!-- Cancel button for PENDING -->
                            <c:if test="${booking.status == 'PENDING'}">
                                <button class="btn btn-danger"
                                        onclick="openCancelModal(${booking.bookingId})">
                                    Cancel Booking
                                </button>
                            </c:if>

                            <!-- Review/Feedback button for CONFIRMED, CHECKED_IN, CHECKED_OUT -->
                            <c:if
                                test="${booking.status == 'CONFIRMED' || booking.status == 'CHECKED_IN' || booking.status == 'CHECKED_OUT'}">
                                <button class="btn btn-secondary" onclick="openReviewModal(this)"
                                        data-id="${booking.bookingId}" data-room="Room #${booking.roomId}">
                                    Leave Review
                                </button>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <!-- Empty State -->
            <c:if test="${bookings == null || bookings.isEmpty()}">
                <div class="empty-state"
                     style="display: block; text-align: center; padding: 60px 20px; background: white; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); margin: 40px auto;">
                    <div class="empty-state-icon" style="font-size: 80px; margin-bottom: 20px;">📭</div>
                    <div class="empty-state-text"
                         style="font-size: 24px; color: #666; margin-bottom: 10px;">
                        No Bookings Yet
                    </div>
                    <div style="font-size: 14px; color: #999; margin-bottom: 30px;">
                        You haven't made any reservations.
                    </div>
                    <a href="${pageContext.request.contextPath}/rooms" class="btn btn-primary">Browse
                        Rooms</a>
                </div>
            </c:if>

            <div class="empty-state" id="emptyState"
                 style="display: none; text-align: center; padding: 60px 20px">
                <div class="empty-state-icon" style="font-size: 60px">📭</div>
                <div class="empty-state-text" style="font-size: 20px; margin: 15px 0">
                    No matching bookings found
                </div>
                <div style="font-size:14px; color: #999">
                    Please try again with a different keyword or filter.
                </div>
            </div>

            <div class="pagination" id="pagination"></div>

            <!-- Booking Detail Modal -->
            <div id="bookingDetailModal" class="modal">
                <div class="modal-content large">
                    <div class="modal-header">
                        <h2>Booking Details</h2>
                        <button class="close-btn" onclick="closeBookingDetail()">×</button>
                    </div>

                    <div class="detail-grid">
                        <div class="detail-box">
                            <span class="label">Booking ID</span>
                            <span class="value" id="modalBookingId"></span>
                        </div>
                        <div class="detail-box">
                            <span class="label">Status</span>
                            <span class="value booking-status" id="modalStatus"></span>
                        </div>
                        <div class="detail-box">
                            <span class="label">Guest Name</span>
                            <span class="value" id="modalCustomer"></span>
                        </div>
                        <div class="detail-box">
                            <span class="label">Room</span>
                            <span class="value" id="modalRoom"></span>
                        </div>
                        <div class="detail-box">
                            <span class="label">Check-in</span>
                            <span class="value" id="modalCheckIn"></span>
                        </div>
                        <div class="detail-box">
                            <span class="label">Check-out</span>
                            <span class="value" id="modalCheckOut"></span>
                        </div>
                        <div class="detail-box">
                            <span class="label">Guests</span>
                            <span class="value" id="modalGuests"></span>
                        </div>
                        <div class="detail-box">
                            <span class="label">Total Price</span>
                            <span class="value price" id="modalPrice"></span>
                        </div>
                        <div class="detail-box full">
                            <span class="label">Note</span>
                            <span class="value" id="modalNote"></span>
                        </div>
                    </div>

                    <div class="modal-footer">
                        <button class="btn btn-secondary" onclick="closeBookingDetail()">Close</button>
                    </div>
                </div>
            </div>

            <!-- Cancel Modal -->
            <div id="cancelModal" class="modal">
                <div class="modal-content">
                    <div class="modal-header">
                        <h2>Cancel Booking</h2>
                        <button class="close-btn" onclick="closeCancelModal()">×</button>
                    </div>

                    <p>Are you sure you want to cancel this booking? This action cannot be undone.</p>

                    <form id="cancelForm" method="post"
                          action="${pageContext.request.contextPath}/my_booking">
                        <input type="hidden" name="action" value="cancel">
                        <input type="hidden" name="bookingId" id="cancelBookingId">

                        <div class="form-group">
                            <label>Cancellation Reason (Optional)</label>
                            <textarea id="cancelReason" rows="3"
                                      placeholder="Enter cancellation reason (optional)"></textarea>
                        </div>

                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary"
                                    onclick="closeCancelModal()">Back</button>
                            <button type="submit" class="btn btn-danger">Confirm Cancellation</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Review/Feedback Modal -->
            <div id="reviewModal" class="modal">
                <div class="modal-content">
                    <div class="modal-header">
                        <h2>Submit Feedback</h2>
                        <button class="close-btn" onclick="closeReviewModal()">×</button>
                    </div>

                    <div class="review-context">
                        <p>Booking ID: <strong id="reviewBookingIdDisplay"></strong></p>
                        <p>Room: <span id="reviewRoomName"></span></p>
                    </div>

                    <form method="post" action="${pageContext.request.contextPath}/my_booking">
                        <input type="hidden" name="action" value="feedback">
                        <input type="hidden" name="bookingId" id="reviewBookingId">
                        <input type="hidden" name="rating" id="reviewRating" value="0">

                        <div class="form-group" style="text-align: center; margin: 20px 0;">
                            <label style="margin-bottom: 10px; display: block; font-weight: 600;">Your
                                Rating <span style="color: red;">*</span></label>
                            <div class="star-rating">
                                <span class="star" onclick="setRating(1)" data-value="1">★</span>
                                <span class="star" onclick="setRating(2)" data-value="2">★</span>
                                <span class="star" onclick="setRating(3)" data-value="3">★</span>
                                <span class="star" onclick="setRating(4)" data-value="4">★</span>
                                <span class="star" onclick="setRating(5)" data-value="5">★</span>
                            </div>
                            <div id="ratingText" style="font-size: 14px; color: #666; margin-top: 5px;">Tap
                                a star to rate</div>
                        </div>

                        <div class="form-group">
                            <label>Your Feedback</label>
                            <textarea name="comment" id="reviewComment" rows="4" class="form-control"
                                      placeholder="Share your experience with us..."></textarea>
                        </div>

                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary"
                                    onclick="closeReviewModal()">Cancel</button>
                            <button type="submit" class="btn btn-primary">Submit Feedback</button>
                        </div>
                    </form>
                </div>
            </div>
        </main>

        <%@ include file="../../Components/Footer.jsp" %>
        <%@ include file="../../public/notify.jsp" %>

        <script>
            // Pagination config
            const ITEMS_PER_PAGE = 6;
            let currentPage = 1;
            let currentActionId = null;

            // Filter & pagination
            function getFilteredBookings() {
                const statusFilter = document.getElementById('statusFilter').value;
                const dateFilter = document.getElementById('dateFilter').value;
                const searchKeyword = document.getElementById('searchInput').value.toLowerCase().trim();

                return Array.from(document.querySelectorAll('.booking-card')).filter(card => {
                    if (statusFilter !== 'all' && card.dataset.status !== statusFilter)
                        return false;
                    if (dateFilter !== 'all' && card.dataset.date !== dateFilter)
                        return false;
                    if (searchKeyword) {
                        const cardText = card.innerText.toLowerCase();
                        if (!cardText.includes(searchKeyword))
                            return false;
                    }
                    return true;
                });
            }

            function showPage(page) {
                const bookings = getFilteredBookings();
                const start = (page - 1) * ITEMS_PER_PAGE;
                const end = start + ITEMS_PER_PAGE;
                const emptyState = document.getElementById('emptyState');
                const pagination = document.getElementById('pagination');

                document.querySelectorAll('.booking-card').forEach(card => card.style.display = 'none');

                if (bookings.length === 0) {
                    emptyState.style.display = 'block';
                    pagination.style.display = 'none';
                    return;
                }

                emptyState.style.display = 'none';
                pagination.style.display = 'flex';

                bookings.forEach((card, index) => {
                    if (index >= start && index < end) {
                        card.style.display = 'block';
                    }
                });
            }

            function renderPagination() {
                const bookings = getFilteredBookings();
                const totalPages = Math.ceil(bookings.length / ITEMS_PER_PAGE);
                const pagination = document.getElementById('pagination');
                pagination.innerHTML = '';

                if (totalPages <= 1)
                    return;

                const prevBtn = document.createElement('button');
                prevBtn.innerHTML = '«';
                prevBtn.className = 'page-btn' + (currentPage === 1 ? ' disabled' : '');
                prevBtn.onclick = () => changePage(currentPage - 1);
                pagination.appendChild(prevBtn);

                for (let i = 1; i <= totalPages; i++) {
                    const btn = document.createElement('button');
                    btn.textContent = i;
                    btn.className = 'page-btn' + (i === currentPage ? ' active' : '');
                    btn.onclick = () => changePage(i);
                    pagination.appendChild(btn);
                }

                const nextBtn = document.createElement('button');
                nextBtn.innerHTML = '»';
                nextBtn.className = 'page-btn' + (currentPage === totalPages ? ' disabled' : '');
                nextBtn.onclick = () => changePage(currentPage + 1);
                pagination.appendChild(nextBtn);
            }

            function changePage(page) {
                const bookings = getFilteredBookings();
                const totalPages = Math.ceil(bookings.length / ITEMS_PER_PAGE);
                if (page < 1 || page > totalPages)
                    return;
                currentPage = page;
                showPage(currentPage);
                renderPagination();
            }

            function filterBookings() {
                currentPage = 1;
                showPage(currentPage);
                renderPagination();
            }

            document.addEventListener('DOMContentLoaded', () => {
                filterBookings();
            });

            // View details modal
            function viewDetails(button) {
                const data = button.dataset;
                document.getElementById('modalBookingId').innerText = '#' + data.id;
                document.getElementById('modalCustomer').innerText = data.name;
                document.getElementById('modalRoom').innerText = data.room;
                document.getElementById('modalCheckIn').innerText = data.checkin;
                document.getElementById('modalCheckOut').innerText = data.checkout;
                document.getElementById('modalGuests').innerText = data.guests;
                document.getElementById('modalPrice').innerText = data.price;
                document.getElementById('modalNote').innerText = data.note || "None";

                const statusSpan = document.getElementById('modalStatus');
                statusSpan.className = 'value booking-status status-' + data.status.toLowerCase().replace('_', '-');
                statusSpan.innerText = data.status;

                currentActionId = data.id;
                document.getElementById('bookingDetailModal').classList.add('show');
            }

            function closeBookingDetail() {
                document.getElementById('bookingDetailModal').classList.remove('show');
            }

            // Cancel modal
            function openCancelModal(bookingId) {
                if (bookingId) {
                    currentActionId = bookingId;
                }
                closeBookingDetail();
                document.getElementById('cancelBookingId').value = currentActionId;
                document.getElementById('cancelModal').classList.add('show');
            }

            function closeCancelModal() {
                document.getElementById('cancelModal').classList.remove('show');
                document.getElementById('cancelReason').value = '';
            }

            // Review modal
            function openReviewModal(button) {
                const bookingId = button.dataset.id;
                const roomName = button.dataset.room;

                document.getElementById('reviewBookingId').value = bookingId;
                document.getElementById('reviewBookingIdDisplay').innerText = '#' + bookingId;
                document.getElementById('reviewRoomName').innerText = roomName;
                document.getElementById('reviewComment').value = '';
                setRating(0);
                document.getElementById('ratingText').innerText = "Tap a star to rate";
                document.getElementById('reviewModal').classList.add('show');
            }

            function closeReviewModal() {
                document.getElementById('reviewModal').classList.remove('show');
            }

            // Rating stars
            function setRating(rating) {
                document.getElementById('reviewRating').value = rating;
                const stars = document.querySelectorAll('.star-rating .star');
                const ratingTexts = ["Tap a star to rate", "Poor", "Fair", "Good", "Very Good", "Excellent"];

                stars.forEach(star => {
                    const starValue = parseInt(star.dataset.value);
                    if (starValue <= rating) {
                        star.classList.add('selected');
                    } else {
                        star.classList.remove('selected');
                    }
                });

                document.getElementById('ratingText').innerText = ratingTexts[rating] || "";
            }

            // Close modals on outside click
            window.onclick = function (event) {
                const cancelModal = document.getElementById('cancelModal');
                const reviewModal = document.getElementById('reviewModal');
                const detailModal = document.getElementById('bookingDetailModal');
                if (event.target == cancelModal)
                    closeCancelModal();
                if (event.target == reviewModal)
                    closeReviewModal();
                if (event.target == detailModal)
                    closeBookingDetail();
            }
        </script>
    </body>

</html>