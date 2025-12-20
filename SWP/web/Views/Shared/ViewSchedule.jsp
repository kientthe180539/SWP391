<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Work Schedule | HMS</title>

                    <!-- Fonts & Icons -->
                    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                        rel="stylesheet">
                    <link rel="stylesheet"
                        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
                    <link rel="stylesheet"
                        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

                    <!-- Custom CSS -->
                    <link rel="stylesheet" href="<c:url value='/CSS/housekeeping.css'/>">

                    <style>
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
                    </style>
                </head>

                <body>
                    <div class="layout-wrapper">
                        <jsp:include page="Sidebar.jsp" />

                        <div class="main-content">
                            <header class="top-header">
                                <div class="d-flex align-items-center">
                                    <button class="btn btn-link text-dark d-md-none me-2" id="sidebarToggle">
                                        <i class="bi bi-list fs-4"></i>
                                    </button>
                                    <h5 class="header-title mb-0">Work Schedule</h5>
                                </div>
                                <div class="user-profile">
                                    <div class="text-end d-none d-sm-block">
                                        <div class="fw-bold text-dark">${sessionScope.currentUser.fullName}</div>
                                        <div class="small text-muted">
                                            <c:choose>
                                                <c:when test="${sessionScope.currentUser.roleId == 2}">Receptionist
                                                </c:when>
                                                <c:when test="${sessionScope.currentUser.roleId == 3}">Housekeeping
                                                </c:when>
                                                <c:when test="${sessionScope.currentUser.roleId == 6}">Manager</c:when>
                                                <c:otherwise>Staff</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    <div class="user-avatar">
                                        ${fn:substring(sessionScope.currentUser.fullName, 0, 1)}
                                    </div>
                                </div>
                            </header>

                            <div class="container-fluid py-4 px-4">
                                <div class="d-flex justify-content-between align-items-center mb-4">
                                    <div>
                                        <h2 class="mb-1">📅 My Work Schedule</h2>
                                        <p class="text-muted mb-0">View your assigned shifts and schedules.</p>
                                    </div>
                                </div>

                                <jsp:include page="ScheduleContent.jsp" />
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