<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Inspection History | HMS</title>
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
                                    <h2 class="mb-1">Inspection History</h2>
                                    <c:choose>
                                        <c:when test="${not empty roomId}">
                                            <p class="text-muted mb-0">Past inspections for Room #${roomId}</p>
                                        </c:when>
                                        <c:otherwise>
                                            <p class="text-muted mb-0">Recent inspections across all rooms</p>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <c:if test="${not empty roomId}">
                                    <a href="inspection?roomId=${roomId}&type=ROUTINE" class="btn btn-primary">
                                        <i class="bi bi-plus-lg me-1"></i> New Inspection
                                    </a>
                                </c:if>
                            </div>

                            <c:if test="${not empty param.msg}">
                                <c:set var="type" value="success" scope="request" />
                                <c:set var="mess" value="Inspection submitted successfully!" scope="request" />
                            </c:if>
                            <jsp:include page="../public/notify.jsp" />

                            <div class="card border-0 shadow-sm">
                                <div class="card-body p-0">
                                    <div class="table-responsive">
                                        <table class="table table-hover align-middle mb-0">
                                            <thead class="bg-light">
                                                <tr>
                                                    <th class="ps-4">Date</th>
                                                    <c:if test="${empty roomId}">
                                                        <th>Room</th>
                                                    </c:if>
                                                    <th>Type</th>
                                                    <th>Inspector</th>
                                                    <th>Note</th>
                                                    <th class="text-end pe-4">Details</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:if test="${empty history}">
                                                    <tr>
                                                        <td colspan="${empty roomId ? 6 : 5}"
                                                            class="text-center py-4 text-muted">No
                                                            inspections found.</td>
                                                    </tr>
                                                </c:if>
                                                <c:forEach items="${history}" var="h">
                                                    <tr>
                                                        <td class="ps-4">${h.inspectionDate}</td>
                                                        <c:if test="${empty roomId}">
                                                            <td>
                                                                <a href="inspection-history?roomId=${h.roomId}"
                                                                    class="text-decoration-none fw-bold">
                                                                    Room ${h.roomId}
                                                                </a>
                                                            </td>
                                                        </c:if>
                                                        <td><span class="badge bg-info">${h.type}</span></td>
                                                        <td>${not empty h.inspectorName ? h.inspectorName :
                                                            h.inspectorId}</td>
                                                        <td>${h.note}</td>
                                                        <td class="text-end pe-4">
                                                            <a href="inspection-detail?id=${h.inspectionId}&source=${param.source}"
                                                                class="btn btn-sm btn-outline-primary">View</a>
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
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>