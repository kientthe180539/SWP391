<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Work Schedule | HMS</title>

                <!-- Fonts & Icons -->
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
                <link rel="stylesheet"
                    href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

                <!-- Custom CSS -->
                <link rel="stylesheet" href="<c:url value='/CSS/housekeeping.css'/>">
                <style>
                    body {
                        font-family: 'Inter', sans-serif;
                        background-color: #f8fafc;
                    }

                    .schedule-card {
                        border: none;
                        border-radius: 12px;
                        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                    }

                    .shift-badge {
                        font-weight: 500;
                        padding: 0.5em 0.8em;
                        border-radius: 6px;
                    }

                    .shift-morning {
                        background-color: #e0f2fe;
                        color: #0284c7;
                    }

                    .shift-afternoon {
                        background-color: #fff7ed;
                        color: #ea580c;
                    }

                    .shift-night {
                        background-color: #f1f5f9;
                        color: #475569;
                    }

                    /* Receptionist specific overrides if needed */
                    .reception-header {
                        background: white;
                        padding: 1rem 2rem;
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
                        margin-bottom: 2rem;
                    }

                    .reception-nav a {
                        text-decoration: none;
                        color: #64748b;
                        margin-left: 1.5rem;
                        font-weight: 500;
                        transition: color 0.2s;
                    }

                    .reception-nav a:hover,
                    .reception-nav a.active {
                        color: #3b82f6;
                    }
                </style>
            </head>

            <body>

                <c:choose>
                    <%-- Receptionist Layout (Role 2) --%>
                        <c:when test="${sessionScope.currentUser.roleId == 2}">
                            <header class="reception-header">
                                <div class="d-flex align-items-center gap-2">
                                    <span class="fs-4">🏨</span>
                                    <span class="fw-bold fs-5 text-dark">Hotel Management</span>
                                </div>
                                <div class="reception-nav d-none d-md-flex align-items-center">
                                    <a href="<c:url value='/receptionist/dashboard'/>">Dashboard</a>
                                    <a href="<c:url value='/reservation_approval'/>">Approvals</a>
                                    <a href="<c:url value='/receptionist/reservations'/>">Reservations</a>
                                    <a href="<c:url value='/receptionist/checkinout'/>">Check-in/out</a>
                                    <a href="<c:url value='/receptionist/room-status'/>">Rooms</a>
                                    <a href="<c:url value='/receptionist/schedule'/>" class="active">My Shift</a>
                                    <a href="<c:url value='/receptionist/profile'/>">Profile</a>
                                    <a href="<c:url value='/logout'/>" class="text-danger ms-4">Logout</a>
                                </div>
                            </header>
                            <div class="container py-4">
                                <jsp:include page="ScheduleContent.jsp" />
                            </div>
                        </c:when>

                        <%-- Sidebar Layout (Manager, Housekeeping) --%>
                            <c:otherwise>
                                <div class="layout-wrapper">
                                    <jsp:include page="Sidebar.jsp" />
                                    <div class="main-content">
                                        <%-- Header if exists --%>
                                            <c:if test="${sessionScope.currentUser.roleId == 6}">
                                                <%-- Manager Header --%>
                                                    <header
                                                        class="p-3 bg-white border-bottom mb-4 d-flex justify-content-between align-items-center">
                                                        <h4 class="mb-0 fw-bold">Work Schedule</h4>
                                                        <div class="d-flex align-items-center gap-3">
                                                            <span
                                                                class="text-muted small">${sessionScope.currentUser.fullName}</span>
                                                            <div class="avatar bg-primary text-white rounded-circle d-flex align-items-center justify-content-center"
                                                                style="width: 32px; height: 32px">
                                                                ${sessionScope.currentUser.fullName.charAt(0)}
                                                            </div>
                                                        </div>
                                                    </header>
                                            </c:if>

                                            <c:if test="${sessionScope.currentUser.roleId == 3}">
                                                <%-- Housekeeping Header usually included or simple --%>
                                                    <div class="p-4">
                                                        <jsp:include page="ScheduleContent.jsp" />
                                                    </div>
                                            </c:if>
                                            <c:if test="${sessionScope.currentUser.roleId == 6}">
                                                <div class="px-4">
                                                    <jsp:include page="ScheduleContent.jsp" />
                                                </div>
                                            </c:if>
                                    </div>
                                </div>
                            </c:otherwise>
                </c:choose>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>