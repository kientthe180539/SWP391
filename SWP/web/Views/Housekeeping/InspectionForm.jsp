<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Room Inspection | HMS</title>
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
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <div>
                                <h2 class="mb-1">Room Inspection</h2>
                                <p class="text-muted mb-0">Checklist for Room #${room.roomNumber} (${type})</p>
                            </div>
                        </div>


                        <c:if test="${not empty param.error}">
                            <c:set var="type" value="error" scope="request" />
                            <c:set var="mess" value="Inspection submission failed. Please try again." scope="request" />
                        </c:if>
                        <jsp:include page="../public/notify.jsp" />

                        <form action="inspection" method="post" id="inspectionForm"
                            onsubmit="return confirm('Are you sure you want to submit this inspection?');">
                            <input type="hidden" name="action" value="submit">
                            <input type="hidden" name="roomId" value="${room.roomId}">
                            <input type="hidden" name="bookingId" value="${bookingId}">
                            <input type="hidden" name="type" value="${type}">
                            <input type="hidden" name="taskId" value="${param.taskId}">

                            <div class="row g-4">
                                <div class="col-lg-8">
                                    <!-- Checkout Comparison Alert -->
                                    <c:if test="${type == 'CHECKOUT' && checkinInspection != null}">
                                        <div class="alert alert-info border-0 shadow-sm mb-4">
                                            <div class="d-flex">
                                                <i class="bi bi-info-circle me-2 mt-1 fs-5"></i>
                                                <div>
                                                    <strong>CHECKOUT Inspection</strong><br>
                                                    Comparing items with Check-in Inspection
                                                    #${checkinInspection.inspectionId}.
                                                    Mark items that don't match the check-in state.
                                                </div>
                                            </div>
                                        </div>
                                    </c:if>

                                    <!-- Cleanliness & Condition Section -->
                                    <div class="card border-0 shadow-sm mb-4">
                                        <div class="card-header bg-white py-3">
                                            <h5 class="mb-0">Cleanliness & Condition</h5>
                                        </div>
                                        <div class="card-body">
                                            <div class="alert alert-light border mb-3">
                                                <div class="d-flex">
                                                    <i class="bi bi-info-circle text-primary me-2 mt-1"></i>
                                                    <div>
                                                        <strong>Instructions:</strong> Check the room for cleanliness
                                                        and general condition.
                                                        If there are any issues (e.g., stains, odors, broken fixtures
                                                        not listed below),
                                                        please describe them in detail.
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="mb-3">
                                                <label class="form-label fw-bold">Cleanliness Issues / General
                                                    Condition</label>
                                                <textarea class="form-control" name="cleanlinessNote" rows="3"
                                                    placeholder="Describe any cleanliness issues or general condition problems here..."></textarea>
                                                <div class="form-text">Leave empty if the room is clean and in good
                                                    condition.</div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="card border-0 shadow-sm mb-4">
                                        <div class="card-header bg-white py-3">
                                            <h5 class="mb-0">Amenity Checklist</h5>
                                        </div>
                                        <div class="card-body p-0">
                                            <div class="table-responsive">
                                                <table class="table table-hover align-middle mb-0">
                                                    <thead class="bg-light">
                                                        <tr>
                                                            <th class="ps-4">Amenity</th>
                                                            <th style="width: 80px;">Standard Qty</th>
                                                            <c:if
                                                                test="${type == 'CHECKOUT' && checkinInspection != null}">
                                                                <th style="width: 100px;">At Check-in</th>
                                                            </c:if>
                                                            <th style="width: 100px;" class="text-center">Verified</th>
                                                            <th style="width: 150px;">Status</th>
                                                            <th>Comment</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach items="${standardAmenities}" var="rta">
                                                            <c:set var="checkinDetail" value="${null}" />
                                                            <c:if
                                                                test="${type == 'CHECKOUT' && checkinInspection != null}">
                                                                <c:forEach items="${checkinInspection.details}"
                                                                    var="detail">
                                                                    <c:if test="${detail.amenityId == rta.amenityId}">
                                                                        <c:set var="checkinDetail" value="${detail}" />
                                                                    </c:if>
                                                                </c:forEach>
                                                            </c:if>

                                                            <tr data-amenity-id="${rta.amenityId}">
                                                                <td class="ps-4">
                                                                    <input type="hidden" name="amenityId"
                                                                        value="${rta.amenityId}">
                                                                    <!-- Store quantity as hidden field -->
                                                                    <input type="hidden"
                                                                        name="quantity_${rta.amenityId}"
                                                                        value="${checkinDetail != null ? checkinDetail.quantityActual : rta.defaultQuantity}">
                                                                    <span class="fw-bold">${rta.amenity.name}</span>
                                                                </td>
                                                                <td>
                                                                    <span
                                                                        class="badge bg-secondary">${rta.defaultQuantity}</span>
                                                                </td>
                                                                <c:if
                                                                    test="${type == 'CHECKOUT' && checkinDetail != null}">
                                                                    <td>
                                                                        <span
                                                                            class="badge bg-info">${checkinDetail.quantityActual}</span>
                                                                        <div class="small text-muted">
                                                                            ${checkinDetail.conditionStatus}</div>
                                                                    </td>
                                                                </c:if>
                                                                <td class="text-center">
                                                                    <div
                                                                        class="form-check d-flex justify-content-center">
                                                                        <input type="checkbox"
                                                                            class="form-check-input amenity-verified"
                                                                            name="verified_${rta.amenityId}"
                                                                            value="true"
                                                                            style="width: 24px; height: 24px; cursor: pointer;"
                                                                            checked>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <select class="form-select amenity-status"
                                                                        name="status_${rta.amenityId}">
                                                                        <option value="OK" selected>OK</option>
                                                                        <option value="DAMAGED">Damaged</option>
                                                                        <option value="MISSING">Missing</option>
                                                                        <option value="USED">Used</option>
                                                                    </select>
                                                                </td>
                                                                <td>
                                                                    <input type="text" class="form-control"
                                                                        name="comment_${rta.amenityId}"
                                                                        placeholder="Optional note...">
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="card border-0 shadow-sm">
                                        <div class="card-body">
                                            <label class="form-label fw-bold">General Note</label>
                                            <textarea class="form-control" name="note" rows="3"
                                                placeholder="Overall condition of the room..."></textarea>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-lg-4">
                                    <div class="card border-0 shadow-sm mb-4">
                                        <div class="card-header bg-white py-3">
                                            <h5 class="mb-0">Inspection Info</h5>
                                        </div>
                                        <div class="card-body">
                                            <div class="mb-3">
                                                <label class="small text-muted text-uppercase fw-bold">Room</label>
                                                <div class="fs-5 fw-bold">#${room.roomNumber}</div>
                                                <div>${room.roomType.typeName}</div>
                                            </div>
                                            <div class="mb-3">
                                                <label class="small text-muted text-uppercase fw-bold">Type</label>
                                                <div><span class="badge bg-primary">${type}</span></div>
                                            </div>
                                            <c:if test="${not empty bookingId}">
                                                <div class="mb-3">
                                                    <label class="small text-muted text-uppercase fw-bold">Booking
                                                        ID</label>
                                                    <div class="fw-bold">#${bookingId}</div>
                                                </div>
                                            </c:if>
                                            <div class="d-grid">
                                                <button type="submit" class="btn btn-primary btn-lg">Submit
                                                    Inspection</button>
                                                <a href="<c:url value='/housekeeping/tasks'/>"
                                                    class="btn btn-light mt-2">Back to Tasks</a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                    <jsp:include page="../Shared/Footer.jsp" />
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
            <script>
                // Auto-uncheck verification when status is not OK
                document.querySelectorAll('.amenity-status').forEach(select => {
                    select.addEventListener('change', function () {
                        const row = this.closest('tr');
                        const checkbox = row.querySelector('.amenity-verified');
                        if (this.value !== 'OK') {
                            checkbox.checked = false;
                        }
                    });
                });

                function confirmSubmit(event, title, text) {
                    event.preventDefault();
                    const form = event.target;

                    Swal.fire({
                        title: title,
                        text: text,
                        icon: 'warning',
                        showCancelButton: true,
                        confirmButtonColor: '#3085d6',
                        cancelButtonColor: '#d33',
                        confirmButtonText: 'Yes, proceed!'
                    }).then((result) => {
                        if (result.isConfirmed) {
                            form.submit();
                        }
                    });
                    return false;
                }
            </script>
        </body>

        </html>