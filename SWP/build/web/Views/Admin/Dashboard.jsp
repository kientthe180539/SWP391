<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Admin Dashboard | HMS</title>
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                rel="stylesheet">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
            <link rel="stylesheet" href="<c:url value='/CSS/housekeeping.css'/>">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
        </head>

        <body>

            <div class="layout-wrapper">
                <jsp:include page="../Shared/AdminSidebar.jsp" />

                <div class="main-content">
                    <jsp:include page="../Shared/Header.jsp" />

                    <div class="container-fluid py-4 px-4">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <div>
                                <h2 class="mb-1">Admin Dashboard</h2>
                                <p class="text-muted mb-0">System overview and health check.</p>
                            </div>
                        </div>

                        <!-- KPI Cards -->
                        <div class="row g-4 mb-4">
                            <div class="col-md-4">
                                <div class="card h-100 border-start border-4 border-primary">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between align-items-start">
                                            <div>
                                                <p class="text-muted small text-uppercase fw-bold mb-1">Total Accounts
                                                </p>
                                                <h3 class="mb-0">${totalAccounts}</h3>
                                            </div>
                                            <div class="p-2 bg-primary bg-opacity-10 rounded-circle text-primary">
                                                <i class="bi bi-people-fill fs-4"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="card h-100 border-start border-4 border-danger">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between align-items-start">
                                            <div>
                                                <p class="text-muted small text-uppercase fw-bold mb-1">System Warnings
                                                </p>
                                                <h3 class="mb-0">0</h3>
                                                <small class="text-success">All systems operational</small>
                                            </div>
                                            <div class="p-2 bg-danger bg-opacity-10 rounded-circle text-danger">
                                                <i class="bi bi-exclamation-triangle-fill fs-4"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="card h-100 border-start border-4 border-info">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between align-items-start">
                                            <div>
                                                <p class="text-muted small text-uppercase fw-bold mb-1">Active Sessions
                                                </p>
                                                <h3 class="mb-0">5</h3>
                                            </div>
                                            <div class="p-2 bg-info bg-opacity-10 rounded-circle text-info">
                                                <i class="bi bi-activity fs-4"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- System Status -->
                        <div class="row g-4">
                            <div class="col-lg-8">
                                <div class="card h-100">
                                    <div class="card-header bg-white py-3">
                                        <h5 class="mb-0">Recent System Logs</h5>
                                    </div>
                                    <div class="card-body p-0">
                                        <div class="table-responsive">
                                            <table class="table table-hover mb-0">
                                                <thead class="bg-light">
                                                    <tr>
                                                        <th>Time</th>
                                                        <th>Level</th>
                                                        <th>Message</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <tr>
                                                        <td>10:00 AM</td>
                                                        <td><span class="badge bg-info">INFO</span></td>
                                                        <td>System backup completed successfully.</td>
                                                    </tr>
                                                    <tr>
                                                        <td>09:45 AM</td>
                                                        <td><span class="badge bg-warning">WARN</span></td>
                                                        <td>High memory usage detected.</td>
                                                    </tr>
                                                    <tr>
                                                        <td>09:00 AM</td>
                                                        <td><span class="badge bg-info">INFO</span></td>
                                                        <td>User admin logged in.</td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-4">
                                <div class="card h-100">
                                    <div class="card-header bg-white py-3">
                                        <h5 class="mb-0">Server Status</h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="mb-3">
                                            <div class="d-flex justify-content-between mb-1">
                                                <span>CPU Usage</span>
                                                <span class="fw-bold">25%</span>
                                            </div>
                                            <div class="progress" style="height: 8px;">
                                                <div class="progress-bar bg-success" role="progressbar"
                                                    style="width: 25%"></div>
                                            </div>
                                        </div>
                                        <div class="mb-3">
                                            <div class="d-flex justify-content-between mb-1">
                                                <span>Memory Usage</span>
                                                <span class="fw-bold">60%</span>
                                            </div>
                                            <div class="progress" style="height: 8px;">
                                                <div class="progress-bar bg-warning" role="progressbar"
                                                    style="width: 60%"></div>
                                            </div>
                                        </div>
                                        <div class="mb-3">
                                            <div class="d-flex justify-content-between mb-1">
                                                <span>Disk Space</span>
                                                <span class="fw-bold">45%</span>
                                            </div>
                                            <div class="progress" style="height: 8px;">
                                                <div class="progress-bar bg-info" role="progressbar" style="width: 45%">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <jsp:include page="../Shared/Footer.jsp" />
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>