<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>Create Inspection | HMS</title>
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
                        <h2 class="mb-4">Create Inspection Task</h2>

                        <c:if test="${not empty mess}">
                            <div
                                class="alert alert-${type == 'success' ? 'success' : 'danger'} alert-dismissible fade show">
                                ${mess}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <div class="card shadow-sm">
                            <div class="card-body">
                                <form method="POST" action="<c:url value='/manager/create-inspection'/>">
                                    <div class="row g-3">
                                        <div class="col-md-6">
                                            <label class="form-label">Room <span class="text-danger">*</span></label>
                                            <select name="roomId" class="form-select" required>
                                                <option value="">Select Room</option>
                                                <c:forEach items="${rooms}" var="room">
                                                    <option value="${room.roomId}">
                                                        Room ${room.roomNumber} - ${room.status}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <div class="col-md-6">
                                            <label class="form-label">Inspection Type <span
                                                    class="text-danger">*</span></label>
                                            <select name="inspectionType" class="form-select" required>
                                                <option value="">Select Type</option>
                                                <option value="CHECKIN">Pre-Check-in Inspection</option>
                                                <option value="CHECKOUT">Post-Checkout Inspection</option>
                                                <option value="ROUTINE">Routine Inspection</option>
                                            </select>
                                        </div>

                                        <div class="col-md-6">
                                            <label class="form-label">Assign to <span
                                                    class="text-danger">*</span></label>
                                            <select name="assignedTo" class="form-select" required>
                                                <option value="">Select Staff</option>
                                                <c:forEach items="${staffList}" var="staff">
                                                    <option value="${staff.userId}">
                                                        ${staff.fullName}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <div class="col-md-6">
                                            <label class="form-label">Related Booking (Optional)</label>
                                            <select name="bookingId" class="form-select">
                                                <option value="">No specific booking</option>
                                                <c:forEach items="${bookings}" var="booking">
                                                    <option value="${booking.bookingId}">
                                                        Booking #${booking.bookingId} - Room ${booking.roomId}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <div class="col-12">
                                            <label class="form-label">Note</label>
                                            <textarea name="note" class="form-control" rows="3"
                                                placeholder="Add inspection instructions or notes..."></textarea>
                                        </div>

                                        <div class="col-12">
                                            <button type="submit" class="btn btn-primary">
                                                <i class="bi bi-check-circle me-2"></i>Create Inspection Task
                                            </button>
                                            <a href="<c:url value='/manager/dashboard'/>" class="btn btn-secondary">
                                                Cancel
                                            </a>
                                        </div>
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