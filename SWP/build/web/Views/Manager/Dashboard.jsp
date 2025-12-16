<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>Manager Dashboard | HMS</title>
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
                        <h2 class="mb-4">Manager Dashboard</h2>

                        <div class="row g-4">
                            <div class="col-md-4">
                                <div class="card text-bg-warning text-white h-100">
                                    <div class="card-body">
                                        <h5 class="card-title"><i class="bi bi-exclamation-triangle me-2"></i>Open
                                            Issues</h5>
                                        <h2 class="display-4">${openIssuesCount}</h2>
                                        <a href="<c:url value='/manager/issues'/>"
                                            class="btn btn-light btn-sm mt-2">View Issues</a>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="card text-bg-info text-white h-100">
                                    <div class="card-body">
                                        <h5 class="card-title"><i class="bi bi-bucket me-2"></i>Dirty Rooms</h5>
                                        <h2 class="display-4">${dirtyRoomsCount}</h2>
                                        <a href="<c:url value='/manager/create-task'/>"
                                            class="btn btn-light btn-sm mt-2">Assign Cleaning</a>
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