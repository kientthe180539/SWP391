<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Update Room Status | HMS Housekeeping</title>
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                rel="stylesheet">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
            <link rel="stylesheet" href="<c:url value='/CSS/housekeeping.css'/>">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
        </head>

        <body>

            <div class="layout-wrapper">
                <jsp:include page="../Shared/Sidebar.jsp" />

                <div class="main-content">
                    <jsp:include page="../Shared/Header.jsp" />

                    <div class="container-fluid py-4 px-4">
                        <div class="row justify-content-center">
                            <div class="col-md-6 col-lg-4">
                                <div class="card shadow-lg">
                                    <div class="card-body text-center p-5">
                                        <div class="mb-4 text-primary">
                                            <i class="bi bi-arrow-repeat fs-1"></i>
                                        </div>
                                        <h4 class="mb-1">Update Room Status</h4>
                                        <p class="text-muted mb-4">Room #${room.roomNumber}</p>

                                        <form action="<c:url value='/housekeeping/room-update'/>" method="post">
                                            <input type="hidden" name="action" value="updateRoomStatus" />
                                            <input type="hidden" name="roomId" value="${room.roomId}" />

                                            <div class="mb-4 text-start">
                                                <label class="form-label">New Status</label>
                                                <select name="status" class="form-select form-select-lg">
                                                    <option value="DIRTY" ${room.status=='DIRTY' ? 'selected' : '' }>
                                                        Dirty</option>
                                                    <option value="CLEANING" ${room.status=='CLEANING' ? 'selected' : ''
                                                        }>Cleaning</option>
                                                    <option value="AVAILABLE" ${room.status=='AVAILABLE' ? 'selected'
                                                        : '' }>Available (Clean)</option>
                                                    <option value="MAINTENANCE" ${room.status=='MAINTENANCE'
                                                        ? 'selected' : '' }>Maintenance</option>
                                                </select>
                                            </div>

                                            <div class="d-grid">
                                                <button type="submit" class="btn btn-primary btn-lg">
                                                    Update Status
                                                </button>
                                            </div>

                                            <div class="mt-3">
                                                <a href="<c:url value='/housekeeping/dashboard'/>"
                                                    class="text-decoration-none text-muted small">Cancel</a>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <jsp:include page="../Shared/Footer.jsp" />
                </div>
            </div>

            <jsp:include page="../public/notify.jsp" />
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>