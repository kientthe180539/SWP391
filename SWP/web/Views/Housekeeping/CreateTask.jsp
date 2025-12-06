<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Create Task | HMS Housekeeping</title>
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
                            <div class="col-md-8 col-lg-6">
                                <div class="card shadow-lg border-0">
                                    <div class="card-header bg-primary text-white py-3">
                                        <h5 class="mb-0"><i class="bi bi-plus-circle me-2"></i>Create New Task</h5>
                                    </div>
                                    <div class="card-body p-4">
                                        <form action="<c:url value='/housekeeping/create-task'/>" method="post">
                                            <input type="hidden" name="action" value="createTask" />

                                            <div class="mb-3">
                                                <label class="form-label">Room</label>
                                                <select name="roomId" class="form-select" required>
                                                    <option value="" disabled selected>-- Select Room --</option>
                                                    <c:forEach items="${rooms}" var="r">
                                                        <option value="${r.roomId}">
                                                            Room ${r.roomNumber} (Floor ${r.floor}) - ${r.status}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>

                                            <div class="mb-3">
                                                <label class="form-label">Assign To (User ID)</label>
                                                <input type="number" name="assignedTo" class="form-control" required
                                                    placeholder="Enter Staff ID (e.g. 7)">
                                                <div class="form-text">Enter the ID of the staff member.</div>
                                            </div>

                                            <div class="row mb-3">
                                                <div class="col-md-6">
                                                    <label class="form-label">Date</label>
                                                    <input type="date" name="taskDate" class="form-control" required>
                                                </div>
                                                <div class="col-md-6">
                                                    <label class="form-label">Task Type</label>
                                                    <select name="taskType" class="form-select">
                                                        <option value="CLEANING">Cleaning</option>
                                                        <option value="INSPECTION">Inspection</option>
                                                    </select>
                                                </div>
                                            </div>

                                            <div class="mb-4">
                                                <label class="form-label">Notes</label>
                                                <textarea name="note" class="form-control" rows="3"
                                                    placeholder="Additional instructions..."></textarea>
                                            </div>

                                            <div class="d-flex justify-content-between align-items-center">
                                                <a href="<c:url value='/housekeeping/dashboard'/>"
                                                    class="text-decoration-none text-muted">Cancel</a>
                                                <button type="submit" class="btn btn-primary px-4">
                                                    Create Task
                                                </button>
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