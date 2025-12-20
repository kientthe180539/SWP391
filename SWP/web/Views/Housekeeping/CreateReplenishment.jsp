<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>New Replenishment Request | HMS</title>
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
                        <div class="row justify-content-center">
                            <div class="col-md-8 col-lg-6">
                                <div class="card shadow-sm">
                                    <div class="card-header bg-white py-3">
                                        <h4 class="mb-0">New Replenishment Request</h4>
                                    </div>
                                    <div class="card-body p-4">
                                        <jsp:include page="../public/notify.jsp" />

                                        <form action="<c:url value='/housekeeping/create-replenishment'/>"
                                            method="POST">
                                            <input type="hidden" name="action" value="createRequest">

                                            <div class="mb-3">
                                                <label for="roomId" class="form-label">Room</label>
                                                <select class="form-select" id="roomId" name="roomId" required>
                                                    <option value="" disabled ${empty preRoomId ? 'selected' : '' }>
                                                        Select Room</option>
                                                    <c:forEach items="${rooms}" var="r">
                                                        <option value="${r.roomId}" ${r.roomId==preRoomId ? 'selected'
                                                            : '' }>Room ${r.roomNumber}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>

                                            <div class="mb-3">
                                                <label for="amenityId" class="form-label">Amenity</label>
                                                <select class="form-select" id="amenityId" name="amenityId" required>
                                                    <option value="" disabled ${empty preAmenityId ? 'selected' : '' }>
                                                        Select Amenity</option>
                                                    <c:forEach items="${amenities}" var="a">
                                                        <option value="${a.amenityId}" ${a.amenityId==preAmenityId
                                                            ? 'selected' : '' }>${a.name} (Price: ${a.price})
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>

                                            <div class="mb-3">
                                                <label for="quantity" class="form-label">Quantity Requested</label>
                                                <input type="number" class="form-control" id="quantity" name="quantity"
                                                    min="1" value="1" required>
                                            </div>

                                            <div class="mb-3">
                                                <label for="reason" class="form-label">Reason</label>
                                                <textarea class="form-control" id="reason" name="reason" rows="3"
                                                    placeholder="e.g. Out of stock, Damaged, Guest request..."
                                                    required></textarea>
                                            </div>

                                            <div class="d-flex justify-content-between">
                                                <a href="<c:url value='/housekeeping/supplies'/>"
                                                    class="btn btn-outline-secondary">Cancel</a>
                                                <button type="submit" class="btn btn-primary">Submit Request</button>
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
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
            <script>
                document.addEventListener('DOMContentLoaded', function () {
                    const roomSelect = document.getElementById('roomId');
                    const amenitySelect = document.getElementById('amenityId');
                    const quantityInput = document.getElementById('quantity');
                    const quantityLabel = document.querySelector('label[for="quantity"]');

                    // If room is already selected (e.g. from previous error), load amenities?
                    // For now, let's rely on change event.

                    roomSelect.addEventListener('change', function () {
                        const roomId = this.value;
                        if (!roomId) return;

                        // Check if we are checking out URL params? No, we use AJAX path.
                        fetch('<c:url value="/housekeeping/get-room-amenities"/>?roomId=' + roomId)
                            .then(response => response.text())
                            .then(html => {
                                amenitySelect.innerHTML = html;
                                // Reset quantity details
                                quantityInput.removeAttribute('max');
                                quantityLabel.textContent = 'Quantity Requested';
                            })
                            .catch(err => console.error('Error loading amenities:', err));
                    });

                    amenitySelect.addEventListener('change', function () {
                        const selectedOption = this.options[this.selectedIndex];
                        const maxQty = selectedOption.getAttribute('data-max');

                        if (maxQty) {
                            quantityInput.max = maxQty;
                            quantityLabel.textContent = `Quantity Requested (Max: ${maxQty})`;
                            // Clamp value if needed?
                            if (parseInt(quantityInput.value) > parseInt(maxQty)) {
                                quantityInput.value = maxQty;
                            }
                        } else {
                            quantityInput.removeAttribute('max');
                            quantityLabel.textContent = 'Quantity Requested';
                        }
                    });

                    quantityInput.addEventListener('input', function () {
                        const max = parseInt(this.max);
                        if (!isNaN(max) && parseInt(this.value) > max) {
                            this.value = max;
                        }
                    });
                });
            </script>
        </body>

        </html>