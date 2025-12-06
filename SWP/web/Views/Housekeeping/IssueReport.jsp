<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Report Issue | HMS Housekeeping</title>
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
                            <div class="col-md-8 col-lg-5">
                                <div class="card shadow-lg border-0">
                                    <div class="card-header bg-warning text-white py-3">
                                        <h5 class="mb-0"><i class="bi bi-exclamation-triangle-fill me-2"></i>Report
                                            Issue</h5>
                                    </div>
                                    <div class="card-body p-4">
                                        <form action="<c:url value='/housekeeping/issue-report'/>" method="post">
                                            <input type="hidden" name="action" value="createIssue" />

                                            <div class="mb-3">
                                                <label class="form-label">Room</label>
                                                <select name="roomId" class="form-select" required>
                                                    <option value="" disabled selected>-- Select Room --</option>
                                                    <c:forEach items="${rooms}" var="r">
                                                        <option value="${r.roomId}" ${room !=null &&
                                                            room.roomId==r.roomId ? 'selected' : (param.roomId==r.roomId
                                                            ? 'selected' : '' )}>
                                                            Room ${r.roomNumber}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>

                                            <div class="mb-3">
                                                <label class="form-label">Issue Type</label>
                                                <div class="d-grid gap-2 d-md-flex">
                                                    <input type="radio" class="btn-check" name="issueType" id="type1"
                                                        value="SUPPLY" required>
                                                    <label class="btn btn-outline-secondary flex-fill" for="type1">
                                                        <i class="bi bi-box-seam d-block mb-1 fs-5"></i> Supply
                                                    </label>

                                                    <input type="radio" class="btn-check" name="issueType" id="type2"
                                                        value="EQUIPMENT">
                                                    <label class="btn btn-outline-secondary flex-fill" for="type2">
                                                        <i class="bi bi-tv d-block mb-1 fs-5"></i> Equipment
                                                    </label>

                                                    <input type="radio" class="btn-check" name="issueType" id="type3"
                                                        value="OTHER">
                                                    <label class="btn btn-outline-secondary flex-fill" for="type3">
                                                        <i class="bi bi-three-dots d-block mb-1 fs-5"></i> Other
                                                    </label>
                                                </div>
                                            </div>

                                            <div class="mb-4">
                                                <label class="form-label">Description</label>
                                                <textarea name="description" class="form-control" rows="4"
                                                    placeholder="Describe the issue in detail..." required></textarea>
                                            </div>

                                            <div class="d-flex justify-content-between align-items-center">
                                                <a href="<c:url value='/housekeeping/dashboard'/>"
                                                    class="text-decoration-none text-muted">Cancel</a>
                                                <button type="submit" class="btn btn-warning text-white px-4">
                                                    Submit Report
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