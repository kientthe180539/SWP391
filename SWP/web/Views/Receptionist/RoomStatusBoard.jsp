<%@ page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Room Status Board | HMS</title>
                    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                        rel="stylesheet">
                    <link rel="stylesheet"
                        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
                    <link rel="stylesheet" href="<c:url value='/CSS/housekeeping.css'/>">
                    <link rel="stylesheet"
                        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
                    <style>
                        .room-grid {
                            display: grid;
                            grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
                            gap: 1rem;
                        }

                        .room-card {
                            transition: all 0.3s ease;
                            cursor: pointer;
                            border-left: 4px solid transparent;
                        }

                        .room-card:hover {
                            transform: translateY(-5px);
                            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
                        }

                        .room-card.available {
                            border-left-color: #198754;
                        }

                        .room-card.occupied {
                            border-left-color: #dc3545;
                        }

                        .room-card.cleaning {
                            border-left-color: #ffc107;
                        }

                        .room-card.maintenance {
                            border-left-color: #0dcaf0;
                        }

                        .room-card.out_of_service {
                            border-left-color: #6c757d;
                        }

                        .room-number {
                            font-size: 1.5rem;
                            font-weight: 700;
                            color: var(--primary-color);
                        }

                        .occupant-info {
                            background: #f8f9fa;
                            border-radius: 8px;
                            padding: 0.75rem;
                            margin-top: 0.75rem;
                            font-size: 0.85rem;
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
                                    <h5 class="header-title mb-0">Room Status Board</h5>
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
                                        <h2 class="mb-1">🏨 Room Status Board</h2>
                                        <p class="text-muted mb-0">View and manage room statuses.</p>
                                    </div>
                                </div>

                                <!-- Statistics Cards -->
                                <div class="row g-3 mb-4">
                                    <div class="col-md col-6">
                                        <div class="card h-100 border-start border-4 border-secondary">
                                            <div class="card-body text-center">
                                                <div class="text-muted small text-uppercase fw-bold">Total</div>
                                                <div class="fs-2 fw-bold text-secondary">${stats.total}</div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md col-6">
                                        <div class="card h-100 border-start border-4 border-success">
                                            <div class="card-body text-center">
                                                <div class="text-muted small text-uppercase fw-bold">🟢 Available</div>
                                                <div class="fs-2 fw-bold text-success">${stats.available}</div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md col-6">
                                        <div class="card h-100 border-start border-4 border-danger">
                                            <div class="card-body text-center">
                                                <div class="text-muted small text-uppercase fw-bold">🔴 Occupied</div>
                                                <div class="fs-2 fw-bold text-danger">${stats.occupied}</div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md col-6">
                                        <div class="card h-100 border-start border-4 border-warning">
                                            <div class="card-body text-center">
                                                <div class="text-muted small text-uppercase fw-bold">🟡 Cleaning</div>
                                                <div class="fs-2 fw-bold text-warning">${stats.cleaning}</div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md col-6">
                                        <div class="card h-100 border-start border-4 border-info">
                                            <div class="card-body text-center">
                                                <div class="text-muted small text-uppercase fw-bold">🔵 Maintenance
                                                </div>
                                                <div class="fs-2 fw-bold text-info">${stats.maintenance}</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Filters -->
                                <div class="card mb-4">
                                    <div class="card-header bg-white py-3">
                                        <h5 class="mb-0"><i class="bi bi-funnel me-2"></i>Filters</h5>
                                    </div>
                                    <div class="card-body">
                                        <form method="get"
                                            action="${pageContext.request.contextPath}/receptionist/room-status">
                                            <div class="row g-3">
                                                <div class="col-md-4">
                                                    <label class="form-label">Floor</label>
                                                    <select name="floor" class="form-select"
                                                        onchange="this.form.submit()">
                                                        <option value="">All Floors</option>
                                                        <option value="1" ${selectedFloor=='1' ? 'selected' : '' }>Floor
                                                            1</option>
                                                        <option value="2" ${selectedFloor=='2' ? 'selected' : '' }>Floor
                                                            2</option>
                                                        <option value="3" ${selectedFloor=='3' ? 'selected' : '' }>Floor
                                                            3</option>
                                                        <option value="4" ${selectedFloor=='4' ? 'selected' : '' }>Floor
                                                            4</option>
                                                        <option value="5" ${selectedFloor=='5' ? 'selected' : '' }>Floor
                                                            5</option>
                                                    </select>
                                                </div>
                                                <div class="col-md-4">
                                                    <label class="form-label">Status</label>
                                                    <select name="status" class="form-select"
                                                        onchange="this.form.submit()">
                                                        <option value="ALL">All Status</option>
                                                        <option value="AVAILABLE" ${selectedStatus=='AVAILABLE'
                                                            ? 'selected' : '' }>Available</option>
                                                        <option value="OCCUPIED" ${selectedStatus=='OCCUPIED'
                                                            ? 'selected' : '' }>Occupied</option>
                                                        <option value="CLEANING" ${selectedStatus=='CLEANING'
                                                            ? 'selected' : '' }>Cleaning</option>
                                                        <option value="MAINTENANCE" ${selectedStatus=='MAINTENANCE'
                                                            ? 'selected' : '' }>Maintenance</option>
                                                        <option value="OUT_OF_SERVICE"
                                                            ${selectedStatus=='OUT_OF_SERVICE' ? 'selected' : '' }>Out
                                                            of Service</option>
                                                    </select>
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                </div>

                                <!-- Room Grid -->
                                <div class="room-grid">
                                    <c:forEach var="room" items="${rooms}">
                                        <div class="card room-card ${fn:toLowerCase(room.status)}"
                                            onclick="window.location.href='${pageContext.request.contextPath}/receptionist/room-detail?id=${room.roomId}'">
                                            <div class="card-body">
                                                <div class="d-flex justify-content-between align-items-center mb-2">
                                                    <span class="room-number">${room.roomNumber}</span>
                                                    <span
                                                        class="badge bg-${room.status == 'AVAILABLE' ? 'success' : (room.status == 'OCCUPIED' ? 'danger' : (room.status == 'CLEANING' ? 'warning text-dark' : (room.status == 'MAINTENANCE' ? 'info' : 'secondary')))}">
                                                        ${room.status}
                                                    </span>
                                                </div>
                                                <div class="fw-semibold mb-2">${room.typeName}</div>
                                                <div class="small text-muted">
                                                    <div><i class="bi bi-building me-1"></i>Floor ${room.floor}</div>
                                                    <div><i class="bi bi-people me-1"></i>Max: ${room.maxOccupancy}
                                                        guests</div>
                                                    <div><i class="bi bi-cash me-1"></i>
                                                        <fmt:formatNumber value="${room.basePrice}" pattern="#,###" />
                                                        VND/night
                                                    </div>
                                                </div>

                                                <c:if test="${not empty room.occupantName}">
                                                    <div class="occupant-info">
                                                        <div class="fw-semibold"><i
                                                                class="bi bi-person-fill me-1"></i>${room.occupantName}
                                                        </div>
                                                        <small>${room.checkinDate} → ${room.checkoutDate}</small>
                                                    </div>
                                                </c:if>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>

                                <c:if test="${empty rooms}">
                                    <div class="text-center py-5 text-muted">
                                        <i class="bi bi-building fs-1"></i>
                                        <h4 class="mt-3">No rooms found</h4>
                                        <p>Try adjusting your filters</p>
                                    </div>
                                </c:if>
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
                </body>

                </html>