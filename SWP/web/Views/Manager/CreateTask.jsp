<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>Create Task | HMS Manager</title>
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
                        <div class="card shadow-sm" style="max-width: 600px; margin: 0 auto;">
                            <div class="card-header bg-primary text-white">
                                <h5 class="mb-0">Create Housekeeping Task</h5>
                            </div>
                            <div class="card-body">
                                <c:if test="${not empty mess}">
                                    <div
                                        class="alert alert-${type == 'success' ? 'success' : 'danger'} alert-dismissible fade show">
                                        ${mess}
                                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                    </div>
                                </c:if>

                                <form action="create-task" method="post">
                                    <div class="mb-3">
                                        <label class="form-label">Room</label>
                                        <select name="roomId" class="form-select" required>
                                            <option value="" disabled selected>-- Select Room --</option>
                                            <c:forEach items="${rooms}" var="r">
                                                <option value="${r.roomId}">Room ${r.roomNumber} (${r.status})</option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label">Assign To</label>
                                        <select name="assignedTo" class="form-select" required>
                                            <option value="" disabled selected>-- Select Staff --</option>
                                            <c:forEach items="${staffList}" var="s">
                                                <option value="${s.userId}">${s.fullName}</option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label">Task Date</label>
                                        <input type="date" name="taskDate" class="form-control" required>
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label">Task Type</label>
                                        <select name="taskType" class="form-select">
                                            <option value="CLEANING">Cleaning</option>
                                            <option value="INSPECTION">Inspection</option>
                                        </select>
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label">Note</label>
                                        <textarea name="note" class="form-control" rows="3"></textarea>
                                    </div>

                                    <div class="d-grid">
                                        <button type="submit" class="btn btn-primary">Create Task</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <jsp:include page="../Shared/Footer.jsp" />
                </div>
            </div>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>