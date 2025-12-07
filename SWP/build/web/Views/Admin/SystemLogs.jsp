<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>System Logs | HMS Admin</title>
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
                        <h2 class="mb-4">System Logs & Notifications</h2>

                        <div class="card">
                            <div class="card-header bg-white">
                                <div class="d-flex justify-content-between align-items-center">
                                    <h5 class="mb-0">Error Logs</h5>
                                    <button class="btn btn-sm btn-outline-secondary">Clear Logs</button>
                                </div>
                            </div>
                            <div class="card-body p-0">
                                <div class="table-responsive">
                                    <table class="table table-striped mb-0">
                                        <thead>
                                            <tr>
                                                <th>Timestamp</th>
                                                <th>Level</th>
                                                <th>Source</th>
                                                <th>Message</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>2023-10-27 10:30:00</td>
                                                <td><span class="badge bg-danger">ERROR</span></td>
                                                <td>PaymentGateway</td>
                                                <td>Connection timeout to payment provider.</td>
                                            </tr>
                                            <tr>
                                                <td>2023-10-27 10:15:00</td>
                                                <td><span class="badge bg-warning">WARN</span></td>
                                                <td>Database</td>
                                                <td>Slow query detected on table 'bookings'.</td>
                                            </tr>
                                            <tr>
                                                <td>2023-10-27 09:00:00</td>
                                                <td><span class="badge bg-info">INFO</span></td>
                                                <td>AuthService</td>
                                                <td>User 'admin' logged in from IP 192.168.1.1.</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            <div class="card-footer bg-white">
                                <nav>
                                    <ul class="pagination justify-content-center mb-0">
                                        <li class="page-item disabled"><a class="page-link" href="#">Previous</a></li>
                                        <li class="page-item active"><a class="page-link" href="#">1</a></li>
                                        <li class="page-item"><a class="page-link" href="#">2</a></li>
                                        <li class="page-item"><a class="page-link" href="#">3</a></li>
                                        <li class="page-item"><a class="page-link" href="#">Next</a></li>
                                    </ul>
                                </nav>
                            </div>
                        </div>
                    </div>

                    <jsp:include page="../Shared/Footer.jsp" />
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>