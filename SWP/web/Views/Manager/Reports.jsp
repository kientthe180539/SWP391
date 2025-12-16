<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>Reports | HMS</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
            <link rel="stylesheet" href="<c:url value='/CSS/housekeeping.css'/>">
        </head>

        <body>
            <div class="layout-wrapper">
                <jsp:include page="../Shared/Sidebar.jsp" />
                <div class="main-content">
                    <jsp:include page="../Shared/Header.jsp" />

                    <div class="container-fluid p-4">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <div>
                                <h2 class="mb-1">Reports & Analytics</h2>
                                <p class="text-muted mb-0">View system performance, revenue, and occupancy reports.</p>
                            </div>
                            <button class="btn btn-outline-primary" onclick="window.print()">
                                <i class="bi bi-printer"></i> Print
                            </button>
                        </div>

                        <div class="alert alert-info">
                            <i class="bi bi-info-circle me-2"></i>
                            This module is currently under development. Detailed reports will be available soon.
                        </div>

                        <div class="row g-4">
                            <div class="col-md-6">
                                <div class="card shadow-sm h-100">
                                    <div class="card-body text-center py-5">
                                        <i class="bi bi-graph-up-arrow fs-1 text-primary mb-3"></i>
                                        <h5>Revenue Report</h5>
                                        <p class="text-muted">Monthly and yearly revenue analysis.</p>
                                        <button class="btn btn-sm btn-primary disabled">View Report</button>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="card shadow-sm h-100">
                                    <div class="card-body text-center py-5">
                                        <i class="bi bi-pie-chart fs-1 text-success mb-3"></i>
                                        <h5>Occupancy Report</h5>
                                        <p class="text-muted">Room occupancy rates and trends.</p>
                                        <button class="btn btn-sm btn-success disabled">View Report</button>
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