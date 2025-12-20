<%@ page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Room Availability Calendar | HMS</title>
                    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                        rel="stylesheet">
                    <link rel="stylesheet"
                        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
                    <link rel="stylesheet" href="<c:url value='/CSS/housekeeping.css'/>">
                    <link rel="stylesheet"
                        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
                    <style>
                        .calendar-container {
                            background: white;
                            border-radius: 12px;
                            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                        }

                        .calendar-header {
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                            padding: 1rem 1.5rem;
                            border-bottom: 1px solid #e5e7eb;
                        }

                        .calendar-nav {
                            display: flex;
                            gap: 0.5rem;
                        }

                        .calendar-nav button {
                            border: none;
                            background: #f3f4f6;
                            width: 40px;
                            height: 40px;
                            border-radius: 8px;
                            cursor: pointer;
                            transition: all 0.2s;
                        }

                        .calendar-nav button:hover {
                            background: #e5e7eb;
                        }

                        .calendar-grid {
                            display: grid;
                            grid-template-columns: repeat(7, 1fr);
                        }

                        .calendar-day-header {
                            padding: 0.75rem;
                            text-align: center;
                            font-weight: 600;
                            color: #6b7280;
                            background: #f9fafb;
                            border-bottom: 1px solid #e5e7eb;
                        }

                        .calendar-day {
                            min-height: 90px;
                            padding: 0.5rem;
                            border: 1px solid #e5e7eb;
                            cursor: pointer;
                            transition: all 0.2s;
                            position: relative;
                        }

                        .calendar-day:hover {
                            background: #f9fafb;
                        }

                        .calendar-day.today {
                            background: #eff6ff;
                        }

                        .calendar-day .day-number {
                            font-weight: 600;
                            font-size: 14px;
                            color: #374151;
                        }

                        .calendar-day.today .day-number {
                            background: #3b82f6;
                            color: white;
                            width: 28px;
                            height: 28px;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            border-radius: 50%;
                        }

                        .calendar-day .availability-badge {
                            position: absolute;
                            bottom: 8px;
                            left: 8px;
                            right: 8px;
                            padding: 4px 8px;
                            border-radius: 6px;
                            font-size: 12px;
                            font-weight: 500;
                            text-align: center;
                        }

                        .calendar-day.status-available .availability-badge {
                            background: #dcfce7;
                            color: #166534;
                        }

                        .calendar-day.status-partial .availability-badge {
                            background: #fef3c7;
                            color: #92400e;
                        }

                        .calendar-day.status-full .availability-badge {
                            background: #fee2e2;
                            color: #991b1b;
                        }

                        .calendar-day.other-month {
                            background: #f9fafb;
                            opacity: 0.5;
                        }

                        .legend {
                            display: flex;
                            gap: 1.5rem;
                            padding: 1rem 1.5rem;
                            border-top: 1px solid #e5e7eb;
                        }

                        .legend-item {
                            display: flex;
                            align-items: center;
                            gap: 0.5rem;
                            font-size: 14px;
                        }

                        .legend-color {
                            width: 16px;
                            height: 16px;
                            border-radius: 4px;
                        }

                        .legend-color.available {
                            background: #dcfce7;
                        }

                        .legend-color.partial {
                            background: #fef3c7;
                        }

                        .legend-color.full {
                            background: #fee2e2;
                        }

                        .booking-list {
                            max-height: 400px;
                            overflow-y: auto;
                        }

                        .booking-item {
                            padding: 1rem;
                            border-bottom: 1px solid #e5e7eb;
                            transition: background 0.2s;
                        }

                        .booking-item:hover {
                            background: #f9fafb;
                        }

                        .booking-item:last-child {
                            border-bottom: none;
                        }

                        #loadingOverlay {
                            display: none;
                            position: absolute;
                            top: 0;
                            left: 0;
                            right: 0;
                            bottom: 0;
                            background: rgba(255, 255, 255, 0.8);
                            z-index: 10;
                            align-items: center;
                            justify-content: center;
                        }

                        #loadingOverlay.show {
                            display: flex;
                        }
                    </style>
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
                                    <h5 class="header-title mb-0">Room Availability</h5>
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
                                        <h2 class="mb-1">📅 Room Availability Calendar</h2>
                                        <p class="text-muted mb-0">Check room availability by type and date range.</p>
                                    </div>
                                </div>

                                <!-- Room Type Filter -->
                                <div class="card mb-4">
                                    <div class="card-body">
                                        <div class="row g-3 align-items-end">
                                            <div class="col-md-6">
                                                <label class="form-label fw-semibold">Select Room Type</label>
                                                <select id="roomTypeSelect" class="form-select form-select-lg">
                                                    <c:forEach var="type" items="${roomTypes}">
                                                        <option value="${type.roomTypeId}"
                                                            data-price="${type.basePrice}"
                                                            ${type.roomTypeId==selectedTypeId ? 'selected' : '' }>
                                                            ${type.typeName} -
                                                            <fmt:formatNumber value="${type.basePrice}"
                                                                pattern="#,###" /> VND/night
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="alert alert-info mb-0 d-flex align-items-center">
                                                    <i class="bi bi-info-circle me-2 fs-5"></i>
                                                    <div>
                                                        <strong id="roomCountDisplay">${roomCount}</strong> rooms of
                                                        this type
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <!-- Calendar -->
                                    <div class="col-lg-8 mb-4">
                                        <div class="calendar-container position-relative">
                                            <div id="loadingOverlay">
                                                <div class="spinner-border text-primary" role="status">
                                                    <span class="visually-hidden">Loading...</span>
                                                </div>
                                            </div>

                                            <div class="calendar-header">
                                                <h4 class="mb-0" id="calendarTitle">December 2024</h4>
                                                <div class="calendar-nav">
                                                    <button id="prevMonth" title="Previous Month">
                                                        <i class="bi bi-chevron-left"></i>
                                                    </button>
                                                    <button id="todayBtn" class="px-3"
                                                        style="width: auto;">Today</button>
                                                    <button id="nextMonth" title="Next Month">
                                                        <i class="bi bi-chevron-right"></i>
                                                    </button>
                                                </div>
                                            </div>

                                            <div class="calendar-grid">
                                                <div class="calendar-day-header">Sun</div>
                                                <div class="calendar-day-header">Mon</div>
                                                <div class="calendar-day-header">Tue</div>
                                                <div class="calendar-day-header">Wed</div>
                                                <div class="calendar-day-header">Thu</div>
                                                <div class="calendar-day-header">Fri</div>
                                                <div class="calendar-day-header">Sat</div>
                                            </div>

                                            <div class="calendar-grid" id="calendarDays">
                                                <!-- Calendar days will be rendered here -->
                                            </div>

                                            <div class="legend">
                                                <div class="legend-item">
                                                    <div class="legend-color available"></div>
                                                    <span>All Available</span>
                                                </div>
                                                <div class="legend-item">
                                                    <div class="legend-color partial"></div>
                                                    <span>Partially Booked</span>
                                                </div>
                                                <div class="legend-item">
                                                    <div class="legend-color full"></div>
                                                    <span>Fully Booked</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Bookings List -->
                                    <div class="col-lg-4">
                                        <div class="card">
                                            <div class="card-header bg-white py-3">
                                                <h5 class="mb-0"><i class="bi bi-calendar-event me-2"></i>Bookings This
                                                    Month</h5>
                                            </div>
                                            <div class="card-body p-0 booking-list" id="bookingsList">
                                                <!-- Bookings will be rendered here -->
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <footer class="main-footer">
                                <p class="mb-0">&copy; 2025 Hotel Management System. All rights reserved.</p>
                            </footer>
                        </div>
                    </div>

                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
                    <script>
                        // Calendar state
                        let currentYear = ${ year };
                        let currentMonth = ${ month };
                        let selectedRoomTypeId = ${ selectedTypeId };
                        const contextPath = '${pageContext.request.contextPath}';

                        const monthNames = ['January', 'February', 'March', 'April', 'May', 'June',
                            'July', 'August', 'September', 'October', 'November', 'December'];

                        // Initialize
                        document.addEventListener('DOMContentLoaded', function () {
                            loadCalendarData();

                            // Event listeners
                            document.getElementById('sidebarToggle')?.addEventListener('click', function () {
                                document.querySelector('.sidebar').classList.toggle('show');
                            });

                            document.getElementById('roomTypeSelect').addEventListener('change', function () {
                                selectedRoomTypeId = parseInt(this.value);
                                loadCalendarData();
                            });

                            document.getElementById('prevMonth').addEventListener('click', function () {
                                currentMonth--;
                                if (currentMonth < 1) {
                                    currentMonth = 12;
                                    currentYear--;
                                }
                                loadCalendarData();
                            });

                            document.getElementById('nextMonth').addEventListener('click', function () {
                                currentMonth++;
                                if (currentMonth > 12) {
                                    currentMonth = 1;
                                    currentYear++;
                                }
                                loadCalendarData();
                            });

                            document.getElementById('todayBtn').addEventListener('click', function () {
                                const today = new Date();
                                currentYear = today.getFullYear();
                                currentMonth = today.getMonth() + 1;
                                loadCalendarData();
                            });
                        });

                        function loadCalendarData() {
                            document.getElementById('loadingOverlay').classList.add('show');

                            fetch(contextPath + '/receptionist/availability/data?roomTypeId=' + selectedRoomTypeId +
                                '&year=' + currentYear + '&month=' + currentMonth)
                                .then(response => response.json())
                                .then(data => {
                                    renderCalendar(data);
                                    renderBookings(data.bookings);
                                    document.getElementById('roomCountDisplay').textContent = data.totalRooms;
                                    document.getElementById('loadingOverlay').classList.remove('show');
                                })
                                .catch(error => {
                                    console.error('Error loading calendar data:', error);
                                    document.getElementById('loadingOverlay').classList.remove('show');
                                });
                        }

                        function renderCalendar(data) {
                            document.getElementById('calendarTitle').textContent =
                                monthNames[currentMonth - 1] + ' ' + currentYear;

                            const calendarDays = document.getElementById('calendarDays');
                            calendarDays.innerHTML = '';

                            // Get first day of month (0 = Sunday)
                            const firstDay = new Date(currentYear, currentMonth - 1, 1).getDay();
                            const daysInMonth = new Date(currentYear, currentMonth, 0).getDate();
                            const today = new Date();
                            const todayStr = today.toISOString().split('T')[0];

                            // Create calendar data map
                            const dayDataMap = {};
                            data.calendarData.forEach(d => {
                                dayDataMap[d.day] = d;
                            });

                            // Add empty cells for days before first day of month
                            for (let i = 0; i < firstDay; i++) {
                                const emptyCell = document.createElement('div');
                                emptyCell.className = 'calendar-day other-month';
                                calendarDays.appendChild(emptyCell);
                            }

                            // Add days
                            for (let day = 1; day <= daysInMonth; day++) {
                                const dayData = dayDataMap[day] || { available: 0, total: 0, status: 'available' };
                                const dateStr = currentYear + '-' + String(currentMonth).padStart(2, '0') + '-' + String(day).padStart(2, '0');
                                const isToday = dateStr === todayStr;

                                const dayCell = document.createElement('div');
                                dayCell.className = 'calendar-day status-' + dayData.status + (isToday ? ' today' : '');
                                dayCell.innerHTML =
                                    '<div class="day-number">' + day + '</div>' +
                                    '<div class="availability-badge">' + dayData.available + '/' + dayData.total + ' available</div>';

                                dayCell.addEventListener('click', function () {
                                    // Could open a modal with day details
                                    console.log('Clicked:', dateStr, dayData);
                                });

                                calendarDays.appendChild(dayCell);
                            }
                        }

                        function renderBookings(bookings) {
                            const bookingsList = document.getElementById('bookingsList');

                            if (!bookings || bookings.length === 0) {
                                bookingsList.innerHTML =
                                    '<div class="text-center py-5 text-muted">' +
                                    '<i class="bi bi-calendar-x fs-1"></i>' +
                                    '<p class="mt-2">No bookings for this month</p>' +
                                    '</div>';
                                return;
                            }

                            let html = '';
                            bookings.forEach(booking => {
                                const statusClass = booking.status === 'CHECKED_IN' ? 'primary' :
                                    (booking.status === 'CONFIRMED' ? 'success' : 'warning');
                                html +=
                                    '<div class="booking-item">' +
                                    '<div class="d-flex justify-content-between align-items-start">' +
                                    '<div>' +
                                    '<strong>Room ' + booking.roomNumber + '</strong>' +
                                    '<div class="small text-muted">' + booking.customerName + '</div>' +
                                    '</div>' +
                                    '<span class="badge bg-' + statusClass + '">' + booking.status + '</span>' +
                                    '</div>' +
                                    '<div class="small text-muted mt-2">' +
                                    '<i class="bi bi-calendar me-1"></i>' + booking.checkinDate + ' → ' + booking.checkoutDate +
                                    '</div>' +
                                    '</div>';
                            });

                            bookingsList.innerHTML = html;
                        }
                    </script>
                </body>

                </html>