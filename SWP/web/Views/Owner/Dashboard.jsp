<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<!-- JSTL Core -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- JSTL Formatting -->
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <!-- ==================== META ==================== -->
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <!-- ==================== TITLE ==================== -->
        <title>Owner Dashboard | HMS</title>

        <!-- ==================== GOOGLE FONT ==================== -->
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
              rel="stylesheet">

        <!-- ==================== BOOTSTRAP CSS ==================== -->
        <link rel="stylesheet"
              href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">

        <!-- ==================== CUSTOM CSS ==================== -->
        <link rel="stylesheet" href="<c:url value='/CSS/housekeeping.css'/>">

        <!-- ==================== BOOTSTRAP ICONS ==================== -->
        <link rel="stylesheet"
              href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    </head>

    <body>

        <!-- ==================== MAIN LAYOUT WRAPPER ==================== -->
        <div class="layout-wrapper">

            <!-- ==================== SIDEBAR ==================== -->
            <jsp:include page="../Shared/OwnerSidebar.jsp"/>

            <!-- ==================== MAIN CONTENT ==================== -->
            <div class="main-content">

                <!-- ==================== HEADER ==================== -->
                <jsp:include page="../Shared/Header.jsp"/>

                <!-- ==================== PAGE CONTENT ==================== -->
                <div class="container-fluid py-4 px-4">

                    <!-- ===== PAGE TITLE ===== -->
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div>
                            <h2 class="mb-1">Owner Dashboard</h2>
                            <p class="text-muted mb-0">Overview of hotel performance.</p>
                        </div>

                        <!-- ===== ACTION BUTTONS ===== -->
                        <div class="d-flex gap-2">
                            <button class="btn btn-outline-primary">
                                <i class="bi bi-download me-1"></i>
                                Export Report
                            </button>
                        </div>
                    </div>

                    <!-- ==================== KPI CARDS ==================== -->
                    <div class="row g-4 mb-4">

                        <!-- ===== OCCUPANCY ===== -->
                        <div class="col-md-4">
                            <div class="card h-100 border-start border-4 border-primary">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-start">
                                        <div>
                                            <p class="text-muted small text-uppercase fw-bold mb-1">
                                                Occupancy
                                            </p>

                                            <!-- Occupied / Total Rooms -->
                                            <h3 class="mb-0">
                                                ${occupiedRooms} / ${totalRooms}
                                            </h3>

                                            <!-- Occupancy Percentage -->
                                            <small class="text-success">
                                                <i class="bi bi-graph-up-arrow"></i>
                                                <fmt:formatNumber
                                                    value="${totalRooms > 0 ? (occupiedRooms / totalRooms) * 100 : 0}"
                                                    maxFractionDigits="1"/>%
                                            </small>
                                        </div>

                                        <div class="p-2 bg-primary bg-opacity-10 rounded-circle text-primary">
                                            <i class="bi bi-building fs-4"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- ===== TODAY REVENUE ===== -->
                        <div class="col-md-4">
                            <div class="card h-100 border-start border-4 border-success">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-start">
                                        <div>
                                            <p class="text-muted small text-uppercase fw-bold mb-1">
                                                Today's Revenue
                                            </p>

                                            <!-- Revenue -->
                                            <h3 class="mb-0">
                                                <fmt:formatNumber value="${revenue}"
                                                                  type="currency"
                                                                  currencySymbol="$"/>
                                            </h3>
                                        </div>

                                        <div class="p-2 bg-success bg-opacity-10 rounded-circle text-success">
                                            <i class="bi bi-currency-dollar fs-4"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- ===== ACTIVE STAFF (MOCK) ===== -->
                        <div class="col-md-4">
                            <div class="card h-100 border-start border-4 border-warning">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-start">
                                        <div>
                                            <p class="text-muted small text-uppercase fw-bold mb-1">
                                                Active Staff
                                            </p>

                                            <!-- Mock value -->
                                            <h3 class="mb-0">12</h3>
                                            <small class="text-muted">On shift now</small>
                                        </div>

                                        <div class="p-2 bg-warning bg-opacity-10 rounded-circle text-warning">
                                            <i class="bi bi-people fs-4"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>

                    <!-- ==================== CHART PLACEHOLDERS ==================== -->
                    <div class="row g-4">

                        <!-- ===== REVENUE TREND ===== -->
                        <div class="col-lg-8">
                            <div class="card h-100">
                                <div class="card-header bg-white py-3">
                                    <h5 class="mb-0">Revenue Trend (Last 7 Days)</h5>
                                </div>
                                <div class="card-body d-flex align-items-center justify-content-center"
                                     style="min-height: 300px;">
                                    <p class="text-muted">Chart visualization would go here.</p>
                                </div>
                            </div>
                        </div>

                        <!-- ===== ROOM STATUS ===== -->
                        <div class="col-lg-4">
                            <div class="card h-100">
                                <div class="card-header bg-white py-3">
                                    <h5 class="mb-0">Room Status Distribution</h5>
                                </div>
                                <div class="card-body d-flex align-items-center justify-content-center"
                                     style="min-height: 300px;">
                                    <p class="text-muted">Pie chart would go here.</p>
                                </div>
                            </div>
                        </div>

                    </div>

                </div>

                <!-- ==================== FOOTER ==================== -->
                <jsp:include page="../Shared/Footer.jsp"/>

            </div>
        </div>

        <!-- ==================== BOOTSTRAP JS ==================== -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

        <!-- ==================== GLOBAL NOTIFICATION (CENTRALIZED) ==================== -->
        <%@ include file="../public/notify.jsp" %>

    </body>
</html>
