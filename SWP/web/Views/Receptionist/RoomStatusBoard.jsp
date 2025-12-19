<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!DOCTYPE html>
                <html>

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Room Status Board - Receptionist</title>
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/receptionist.css">
                    <style>
                        .room-grid {
                            display: grid;
                            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
                            gap: 15px;
                            margin-top: 20px;
                        }

                        .room-card {
                            background: white;
                            border-radius: 12px;
                            padding: 15px;
                            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                            transition: all 0.3s ease;
                            cursor: pointer;
                            border: 3px solid transparent;
                        }

                        .room-card:hover {
                            transform: translateY(-5px);
                            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
                        }

                        .room-card.available {
                            border-color: #28a745;
                        }

                        .room-card.occupied {
                            border-color: #dc3545;
                        }

                        .room-card.cleaning {
                            border-color: #ffc107;
                        }

                        .room-card.maintenance {
                            border-color: #17a2b8;
                        }

                        .room-card.out_of_service {
                            border-color: #6c757d;
                        }

                        .room-header {
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                            margin-bottom: 12px;
                        }

                        .room-number {
                            font-size: 24px;
                            font-weight: bold;
                            color: #1e3c72;
                        }

                        .room-status-badge {
                            padding: 4px 10px;
                            border-radius: 12px;
                            font-size: 11px;
                            font-weight: 600;
                            text-transform: uppercase;
                        }

                        .room-status-badge.available {
                            background: #28a745;
                            color: white;
                        }

                        .room-status-badge.occupied {
                            background: #dc3545;
                            color: white;
                        }

                        .room-status-badge.cleaning {
                            background: #ffc107;
                            color: #333;
                        }

                        .room-status-badge.maintenance {
                            background: #17a2b8;
                            color: white;
                        }

                        .room-status-badge.out_of_service {
                            background: #6c757d;
                            color: white;
                        }

                        .room-info {
                            font-size: 13px;
                            color: #666;
                            margin-bottom: 8px;
                        }

                        .room-type {
                            font-weight: 600;
                            color: #1e3c72;
                            margin-bottom: 5px;
                        }

                        .occupant-info {
                            background: #f8f9fa;
                            padding: 8px;
                            border-radius: 6px;
                            margin-top: 10px;
                            font-size: 12px;
                        }

                        .stats-summary {
                            display: grid;
                            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
                            gap: 15px;
                            margin-bottom: 20px;
                        }

                        .stat-card {
                            background: white;
                            border-radius: 10px;
                            padding: 15px;
                            text-align: center;
                            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
                        }

                        .stat-number {
                            font-size: 32px;
                            font-weight: bold;
                            margin: 10px 0;
                        }

                        .stat-label {
                            font-size: 13px;
                            color: #666;
                            text-transform: uppercase;
                        }

                        .stat-card.total .stat-number {
                            color: #1e3c72;
                        }

                        .stat-card.available .stat-number {
                            color: #28a745;
                        }

                        .stat-card.occupied .stat-number {
                            color: #dc3545;
                        }

                        .stat-card.cleaning .stat-number {
                            color: #ffc107;
                        }

                        .stat-card.maintenance .stat-number {
                            color: #17a2b8;
                        }

                        .filter-section {
                            background: white;
                            padding: 20px;
                            border-radius: 12px;
                            margin-bottom: 20px;
                            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
                        }

                        .filter-grid {
                            display: grid;
                            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                            gap: 15px;
                        }

                        select {
                            width: 100%;
                            padding: 10px;
                            border: 2px solid #e0e0e0;
                            border-radius: 8px;
                            font-size: 14px;
                        }
                    </style>
                </head>

                <body>
                    <header>
                        <div class="logo">🏨 Hotel Management</div>
                        <div class="header-right">
                            <div class="nav-links">
                                <a href="${pageContext.request.contextPath}/receptionist/dashboard">Dashboard</a>
                                <a href="${pageContext.request.contextPath}/reservation_approval">Approvals</a>
                                <a href="${pageContext.request.contextPath}/receptionist/reservations">Reservations</a>
                                <a href="${pageContext.request.contextPath}/receptionist/checkinout">Check-in/out</a>
                                <a href="${pageContext.request.contextPath}/receptionist/room-status"
                                    class="active">Rooms</a>
                                <a href="${pageContext.request.contextPath}/logout">Logout</a>
                            </div>
                            <div class="staff-profile">
                                <span>${sessionScope.currentUser.fullName}</span>
                                <div class="staff-avatar">${fn:substring(sessionScope.currentUser.fullName, 0, 2)}</div>
                            </div>
                        </div>
                    </header>

                    <div class="container">
                        <h1 class="page-title">🏨 Room Status Board</h1>

                        <!-- Statistics Summary -->
                        <div class="stats-summary">
                            <div class="stat-card total">
                                <div class="stat-label">Total Rooms</div>
                                <div class="stat-number">${stats.total}</div>
                            </div>
                            <div class="stat-card available">
                                <div class="stat-label">🟢 Available</div>
                                <div class="stat-number">${stats.available}</div>
                            </div>
                            <div class="stat-card occupied">
                                <div class="stat-label">🔴 Occupied</div>
                                <div class="stat-number">${stats.occupied}</div>
                            </div>
                            <div class="stat-card cleaning">
                                <div class="stat-label">🟡 Cleaning</div>
                                <div class="stat-number">${stats.cleaning}</div>
                            </div>
                            <div class="stat-card maintenance">
                                <div class="stat-label">🔵 Maintenance</div>
                                <div class="stat-number">${stats.maintenance}</div>
                            </div>
                        </div>

                        <!-- Filters -->
                        <div class="filter-section">
                            <h3 style="margin-bottom: 15px;">🔍 Filters</h3>
                            <form method="get" action="${pageContext.request.contextPath}/receptionist/room-status">
                                <div class="filter-grid">
                                    <div>
                                        <label>Floor</label>
                                        <select name="floor" onchange="this.form.submit()">
                                            <option value="">All Floors</option>
                                            <option value="1" ${selectedFloor=='1' ? 'selected' : '' }>Floor 1</option>
                                            <option value="2" ${selectedFloor=='2' ? 'selected' : '' }>Floor 2</option>
                                            <option value="3" ${selectedFloor=='3' ? 'selected' : '' }>Floor 3</option>
                                            <option value="4" ${selectedFloor=='4' ? 'selected' : '' }>Floor 4</option>
                                            <option value="5" ${selectedFloor=='5' ? 'selected' : '' }>Floor 5</option>
                                        </select>
                                    </div>
                                    <div>
                                        <label>Status</label>
                                        <select name="status" onchange="this.form.submit()">
                                            <option value="ALL">All Status</option>
                                            <option value="AVAILABLE" ${selectedStatus=='AVAILABLE' ? 'selected' : '' }>
                                                Available</option>
                                            <option value="OCCUPIED" ${selectedStatus=='OCCUPIED' ? 'selected' : '' }>
                                                Occupied</option>
                                            <option value="CLEANING" ${selectedStatus=='CLEANING' ? 'selected' : '' }>
                                                Cleaning</option>
                                            <option value="MAINTENANCE" ${selectedStatus=='MAINTENANCE' ? 'selected'
                                                : '' }>Maintenance</option>
                                            <option value="OUT_OF_SERVICE" ${selectedStatus=='OUT_OF_SERVICE'
                                                ? 'selected' : '' }>Out of Service</option>
                                        </select>
                                    </div>
                                </div>
                            </form>
                        </div>

                        <!-- Room Grid -->
                        <div class="room-grid">
                            <c:forEach var="room" items="${rooms}">
                                <div class="room-card ${fn:toLowerCase(room.status)}"
                                    onclick="window.location.href='${pageContext.request.contextPath}/receptionist/room-detail?id=${room.roomId}'">
                                    <div class="room-header">
                                        <div class="room-number">${room.roomNumber}</div>
                                        <span class="room-status-badge ${fn:toLowerCase(room.status)}">
                                            ${room.status}
                                        </span>
                                    </div>
                                    <div class="room-type">${room.typeName}</div>
                                    <div class="room-info">
                                        <div>🏢 Floor ${room.floor}</div>
                                        <div>👥 Max: ${room.maxOccupancy} guests</div>
                                        <div>💰
                                            <fmt:formatNumber value="${room.basePrice}" pattern="#,###" /> VND/night
                                        </div>
                                    </div>

                                    <c:if test="${not empty room.occupantName}">
                                        <div class="occupant-info">
                                            <strong>👤 ${room.occupantName}</strong><br>
                                            <small>
                                                ${room.checkinDate} → ${room.checkoutDate}
                                            </small>
                                        </div>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </div>

                        <c:if test="${empty rooms}">
                            <div class="empty-state" style="margin-top: 40px;">
                                <h3>No rooms found</h3>
                                <p>Try adjusting your filters</p>
                            </div>
                        </c:if>
                    </div>

                    <footer>
                        <p>&copy; 2025 Hotel Management System. All rights reserved.</p>
                    </footer>
                </body>

                </html>
