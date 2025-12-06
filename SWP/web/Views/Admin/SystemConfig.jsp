<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>System Configuration | HMS Admin</title>
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
                        <h2 class="mb-4">System Configuration</h2>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="card mb-4">
                                    <div class="card-header bg-white">
                                        <h5 class="mb-0">General Settings</h5>
                                    </div>
                                    <div class="card-body">
                                        <form>
                                            <div class="mb-3">
                                                <label class="form-label">System Name</label>
                                                <input type="text" class="form-control" value="Hotel Management System">
                                            </div>
                                            <div class="mb-3">
                                                <label class="form-label">Default Language</label>
                                                <select class="form-select">
                                                    <option selected>English</option>
                                                    <option>Vietnamese</option>
                                                </select>
                                            </div>
                                            <div class="mb-3">
                                                <label class="form-label">Timezone</label>
                                                <select class="form-select">
                                                    <option selected>GMT+7 (Bangkok, Hanoi, Jakarta)</option>
                                                </select>
                                            </div>
                                            <button type="submit" class="btn btn-primary">Save Changes</button>
                                        </form>
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <div class="card mb-4">
                                    <div class="card-header bg-white">
                                        <h5 class="mb-0">Notifications & Email</h5>
                                    </div>
                                    <div class="card-body">
                                        <form>
                                            <div class="form-check form-switch mb-3">
                                                <input class="form-check-input" type="checkbox" checked>
                                                <label class="form-check-label">Enable Email Notifications</label>
                                            </div>
                                            <div class="form-check form-switch mb-3">
                                                <input class="form-check-input" type="checkbox">
                                                <label class="form-check-label">Enable SMS Notifications</label>
                                            </div>
                                            <div class="mb-3">
                                                <label class="form-label">SMTP Server</label>
                                                <input type="text" class="form-control" value="smtp.gmail.com">
                                            </div>
                                            <button type="submit" class="btn btn-primary">Save Changes</button>
                                        </form>
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