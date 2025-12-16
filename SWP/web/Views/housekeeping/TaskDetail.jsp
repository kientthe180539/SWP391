<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Task Detail | HMS Housekeeping</title>
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
                                <div class="card shadow-lg">
                                    <div class="card-header bg-white py-3 border-bottom">
                                        <div class="d-flex align-items-center">
                                            <a href="<c:url value='/housekeeping/tasks'/>"
                                                class="btn btn-light btn-sm me-3 rounded-circle">
                                                <i class="bi bi-arrow-left"></i>
                                            </a>
                                            <h5 class="mb-0">Task Details #${task.taskId}</h5>
                                        </div>
                                    </div>
                                    <div class="card-body">
                                        <!-- Room Info -->
                                        <div class="d-flex align-items-center mb-4 p-3 bg-light rounded-3">
                                            <div class="bg-white p-3 rounded-circle shadow-sm me-3 text-primary">
                                                <i class="bi bi-door-open fs-3"></i>
                                            </div>
                                            <div>
                                                <h6 class="mb-1 text-muted text-uppercase small fw-bold">Room</h6>
                                                <h4 class="mb-0 text-primary fw-bold">
                                                    ${room.roomNumber}
                                                    <span class="fs-6 text-muted fw-normal">(Floor ${room.floor})</span>
                                                </h4>
                                            </div>
                                            <div class="ms-auto text-end">
                                                <span class="badge bg-secondary">${room.status}</span>
                                            </div>
                                        </div>

                                        <form action="<c:url value='/housekeeping/task-update'/>" method="post">
                                            <input type="hidden" name="action" value="updateTask" />
                                            <input type="hidden" name="taskId" value="${task.taskId}" />

                                            <div class="row g-3 mb-4">
                                                <div class="col-6">
                                                    <label class="form-label text-muted small text-uppercase">Task
                                                        Type</label>
                                                    <p class="fw-bold mb-0"><i
                                                            class="bi bi-tag me-2"></i>${task.taskType}</p>
                                                </div>
                                                <div class="col-6">
                                                    <label
                                                        class="form-label text-muted small text-uppercase">Date</label>
                                                    <p class="fw-bold mb-0"><i
                                                            class="bi bi-calendar-event me-2"></i>${task.taskDate}</p>
                                                </div>
                                            </div>

                                            <c:if
                                                test="${task.taskType == 'INSPECTION' || task.taskType == 'CHECKIN' || task.taskType == 'CHECKOUT'}">
                                                <div class="mb-4">
                                                    <div class="d-grid">
                                                        <a href="<c:url value='/housekeeping/inspection'><c:param name='roomId' value='${room.roomId}'/><c:param name='type' value='${task.taskType == "
                                                            INSPECTION" ? "ROUTINE" : task.taskType}' /></c:url>"
                                                        class="btn btn-outline-primary">
                                                        <i class="bi bi-clipboard-check me-2"></i>Perform Inspection
                                                        </a>
                                                    </div>
                                                </div>
                                            </c:if>

                                            <div class="mb-4">
                                                <label class="form-label">Update Status</label>
                                                <select name="status" class="form-select form-select-lg">
                                                    <option value="NEW" ${task.status=='NEW' ? 'selected' : '' }>New
                                                    </option>
                                                    <option value="IN_PROGRESS" ${task.status=='IN_PROGRESS'
                                                        ? 'selected' : '' }>In Progress</option>
                                                    <option value="DONE" ${task.status=='DONE' ? 'selected' : '' }>Done
                                                    </option>
                                                </select>
                                            </div>

                                            <div class="mb-4">
                                                <label class="form-label">Notes</label>
                                                <textarea name="note" class="form-control" rows="4"
                                                    placeholder="Add any notes about the task...">${task.note}</textarea>
                                            </div>

                                            <div class="d-grid gap-2">
                                                <button type="submit" class="btn btn-primary btn-lg">
                                                    Save Changes
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