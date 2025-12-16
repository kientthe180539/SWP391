<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>Inspection Detail | HMS</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
            <link rel="stylesheet" href="<c:url value='/CSS/housekeeping.css'/>">
            <style>
                .condition-ok {
                    color: #198754;
                    font-weight: 500;
                }

                .condition-damaged {
                    color: #dc3545;
                    font-weight: 500;
                }

                .condition-missing {
                    color: #fd7e14;
                    font-weight: 500;
                }
            </style>
        </head>

        <body>
            <div class="layout-wrapper">
                <jsp:include page="../Shared/Sidebar.jsp" />
                <div class="main-content">
                    <jsp:include page="../Shared/Header.jsp" />

                    <div class="container-fluid p-4">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h2>
                                <a href="<c:url value='/manager/inspections'/>"
                                    class="text-decoration-none text-dark me-2">
                                    <i class="bi bi-arrow-left"></i>
                                </a>
                                <c:choose>
                                    <c:when test="${not empty inspection.roomNumber}">Inspection Detail Room
                                        ${inspection.roomNumber}</c:when>
                                    <c:otherwise>Inspection Detail Room ${inspection.roomId}</c:otherwise>
                                </c:choose>
                            </h2>
                            <div>
                                <span class="badge ${inspection.type == 'CHECKIN' ? 'bg-success' : 
                                                 inspection.type == 'CHECKOUT' ? 'bg-primary' : 
                                                 inspection.type == 'SUPPLY' ? 'bg-warning' : 'bg-secondary'} fs-6">
                                    ${inspection.type}
                                </span>
                            </div>
                        </div>

                        <!-- Inspection Summary Card -->
                        <div class="card shadow-sm mb-4">
                            <div class="card-header bg-light">
                                <h5 class="mb-0">Overview</h5>
                            </div>
                            <div class="card-body">
                                <div class="row g-3">
                                    <div class="col-md-3">
                                        <label class="text-muted small">Room</label>
                                        <div class="fw-bold fs-5">
                                            <c:choose>
                                                <c:when test="${not empty inspection.roomNumber}">Room
                                                    ${inspection.roomNumber}</c:when>
                                                <c:otherwise>Room ${inspection.roomId}</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="text-muted small">Inspector</label>
                                        <div>
                                            <c:choose>
                                                <c:when test="${not empty inspection.inspectorName}">
                                                    ${inspection.inspectorName}</c:when>
                                                <c:otherwise>User #${inspection.inspectorId}</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="text-muted small">Date</label>
                                        <div>${inspection.inspectionDate}</div>
                                    </div>
                                    <c:if test="${not empty inspection.bookingId && inspection.bookingId > 0}">
                                        <div class="col-md-3">
                                            <label class="text-muted small">Booking Ref</label>
                                            <div>
                                                <c:choose>
                                                    <c:when test="${not empty inspection.customerName}">
                                                        ${inspection.customerName} <span
                                                            class="text-muted small">(#${inspection.bookingId})</span>
                                                    </c:when>
                                                    <c:otherwise>#${inspection.bookingId}</c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </c:if>
                                </div>
                                <c:if test="${not empty inspection.note}">
                                    <div class="mt-3 pt-3 border-top">
                                        <label class="text-muted small">General Note</label>
                                        <div class="fst-italic">"${inspection.note}"</div>
                                    </div>
                                </c:if>
                            </div>
                        </div>

                        <!-- Checklist Details -->
                        <div class="card shadow-sm">
                            <div class="card-header bg-white">
                                <h5 class="mb-0">Inspection Checklist</h5>
                            </div>
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th style="width: 30%">Amenity / Item</th>
                                            <th style="width: 15%">Condition</th>
                                            <th style="width: 15%">Qty Found</th>
                                            <th style="width: 40%">Comments</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${inspection.details}" var="d">
                                            <tr>
                                                <td>
                                                    <div class="fw-bold">${d.amenity.name}</div>
                                                    <!-- <div class="small text-muted">$${d.amenity.price}</div> -->
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${d.conditionStatus == 'OK'}">
                                                            <span
                                                                class="badge bg-success-subtle text-success border border-success">
                                                                <i class="bi bi-check-circle me-1"></i>OK
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${d.conditionStatus == 'DAMAGED'}">
                                                            <span
                                                                class="badge bg-danger-subtle text-danger border border-danger">
                                                                <i class="bi bi-exclamation-circle me-1"></i>Damaged
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${d.conditionStatus == 'MISSING'}">
                                                            <span
                                                                class="badge bg-warning-subtle text-warning border border-warning">
                                                                <i class="bi bi-question-circle me-1"></i>Missing
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary">${d.conditionStatus}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <span class="fw-bold">${d.quantityActual}</span>
                                                </td>
                                                <td>
                                                    <c:if test="${not empty d.comment}">
                                                        <i class="bi bi-chat-text me-1 text-muted"></i> ${d.comment}
                                                    </c:if>
                                                    <c:if test="${empty d.comment}">
                                                        <span class="text-muted small">-</span>
                                                    </c:if>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty inspection.details}">
                                            <tr>
                                                <td colspan="4" class="text-center py-4 text-muted">
                                                    No checklist items recorded for this inspection.
                                                </td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                    </div>

                    <jsp:include page="../Shared/Footer.jsp" />
                </div>
            </div>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>