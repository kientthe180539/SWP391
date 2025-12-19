<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>My Reported Issues | HMS Housekeeping</title>
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
                <link rel="stylesheet" href="<c:url value='/CSS/housekeeping.css'/>">
                <link rel="stylesheet"
                    href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
            </head>

            <body>

                <div class="layout-wrapper">
                    <jsp:include page="../Shared/Sidebar.jsp" />

                    <div class="main-content">
                        <jsp:include page="../Shared/Header.jsp" />

                        <div class="container-fluid py-4 px-4">
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <div>
                                    <h4 class="fw-bold mb-1">My Reported Issues</h4>
                                    <p class="text-muted mb-0">Track status of maintenance and supply issues you
                                        reported
                                    </p>
                                </div>
                                <a href="<c:url value='/housekeeping/issue-report'/>"
                                    class="btn btn-warning text-white">
                                    <i class="bi bi-plus-lg me-2"></i>Report New Issue
                                </a>
                            </div>

                            <div class="card shadow-sm border-0">
                                <div class="card-body p-0">
                                    <div class="table-responsive">
                                        <table class="table table-hover align-middle mb-0">
                                            <thead class="bg-light">
                                                <tr>
                                                    <th class="ps-4">Room</th>
                                                    <th>Type</th>
                                                    <th>Description</th>
                                                    <th>Date Reported</th>
                                                    <th>Status</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:if test="${empty issues}">
                                                    <tr>
                                                        <td colspan="5" class="text-center py-5 text-muted">
                                                            <i class="bi bi-clipboard-check display-6 mb-3 d-block"></i>
                                                            <p>You haven't reported any issues yet.</p>
                                                        </td>
                                                    </tr>
                                                </c:if>
                                                <c:forEach items="${issues}" var="i">
                                                    <tr>
                                                        <td class="ps-4 fw-bold">Room ${i.roomNumber}</td>
                                                        <td>
                                                            <span
                                                                class="badge ${i.issueType == 'EQUIPMENT' ? 'bg-danger' : 'bg-warning'} bg-opacity-10 text-dark border border-opacity-10">
                                                                ${i.issueType}
                                                            </span>
                                                        </td>
                                                        <td style="max-width: 300px;" class="text-truncate"
                                                            title="${i.description}">
                                                            ${i.description}
                                                        </td>
                                                        <td class="text-muted small">
                                                            ${i.createdAt.toLocalDate()} <br>
                                                            ${i.createdAt.toLocalTime().toString().substring(0,5)}
                                                        </td>
                                                        <td>
                                                            <span
                                                                class="badge ${i.status == 'NEW' ? 'bg-info' : (i.status == 'CLOSED' ? 'bg-success' : 'bg-warning')} rounded-pill">
                                                                ${i.status}
                                                            </span>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
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