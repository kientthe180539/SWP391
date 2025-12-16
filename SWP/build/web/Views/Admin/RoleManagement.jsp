<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Role Management | HMS Admin</title>
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
                        <h2 class="mb-4">Role & Permission Management</h2>

                        <div class="card">
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-bordered align-middle">
                                        <thead class="bg-light">
                                            <tr>
                                                <th>Role ID</th>
                                                <th>Role Name</th>
                                                <th>Description</th>
                                                <th>Permissions</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>1</td>
                                                <td><span class="badge bg-secondary">GUEST</span></td>
                                                <td>Standard user/customer</td>
                                                <td>View Rooms, Book Rooms</td>
                                                <td><button class="btn btn-sm btn-outline-secondary">Edit</button></td>
                                            </tr>
                                            <tr>
                                                <td>2</td>
                                                <td><span class="badge bg-info">RECEPTIONIST</span></td>
                                                <td>Front desk staff</td>
                                                <td>Manage Bookings, Check-in/out</td>
                                                <td><button class="btn btn-sm btn-outline-secondary">Edit</button></td>
                                            </tr>
                                            <tr>
                                                <td>3</td>
                                                <td><span class="badge bg-warning text-dark">HOUSEKEEPING</span></td>
                                                <td>Cleaning staff</td>
                                                <td>View Tasks, Update Room Status</td>
                                                <td><button class="btn btn-sm btn-outline-secondary">Edit</button></td>
                                            </tr>
                                            <tr>
                                                <td>4</td>
                                                <td><span class="badge bg-primary">OWNER</span></td>
                                                <td>Hotel Owner</td>
                                                <td>Full Access, Reports, Staff Mgmt</td>
                                                <td><button class="btn btn-sm btn-outline-secondary">Edit</button></td>
                                            </tr>
                                            <tr>
                                                <td>5</td>
                                                <td><span class="badge bg-dark">ADMIN</span></td>
                                                <td>System Administrator</td>
                                                <td>System Config, User Mgmt, Logs</td>
                                                <td><button class="btn btn-sm btn-outline-secondary">Edit</button></td>
                                            </tr>
                                        </tbody>
                                    </table>
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