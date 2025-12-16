<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Room Management | HMS Owner</title>
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                rel="stylesheet">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
            <link rel="stylesheet" href="<c:url value='/CSS/housekeeping.css'/>">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
        </head>

        <body>

            <div class="layout-wrapper">
                <jsp:include page="../Shared/OwnerSidebar.jsp" />

                <div class="main-content">
                    <jsp:include page="../Shared/Header.jsp" />

                    <div class="container-fluid py-4 px-4">
                        <h2 class="mb-4">Room Management Oversight</h2>

                        <div class="card shadow-sm">
                            <div class="card-header bg-white">
                                <ul class="nav nav-tabs card-header-tabs">
                                    <li class="nav-item">
                                        <a class="nav-link ${activeTab == 'rooms' ? 'active' : ''}"
                                            href="<c:url value='/owner/rooms?tab=rooms'/>">Room List</a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link ${activeTab == 'pricing' ? 'active' : ''}"
                                            href="<c:url value='/owner/rooms?tab=pricing'/>">Pricing Policy</a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link ${activeTab == 'types' ? 'active' : ''}"
                                            href="<c:url value='/owner/rooms?tab=types'/>">Room Types</a>
                                    </li>
                                </ul>
                            </div>
                            <div class="card-body">

                                <c:choose>
                                    <c:when test="${activeTab == 'rooms'}">
                                        <!-- =================== ROOM LIST TAB =================== -->
                                        <div class="d-flex justify-content-between mb-4">
                                            <form action="<c:url value='/owner/rooms'/>" method="get"
                                                class="d-flex gap-2 flex-grow-1 me-3">
                                                <input type="hidden" name="tab" value="rooms">
                                                <div class="input-group input-group-sm">
                                                    <span class="input-group-text bg-light border-end-0"><i
                                                            class="bi bi-search"></i></span>
                                                    <input type="text" name="search" class="form-control border-start-0"
                                                        placeholder="Search room number..." value="${search}">
                                                </div>
                                                <select name="status" class="form-select form-select-sm"
                                                    style="max-width: 150px;">
                                                    <option value="">All Status</option>
                                                    <option value="AVAILABLE" ${status=='AVAILABLE' ? 'selected' : '' }>
                                                        Available</option>
                                                    <option value="DIRTY" ${status=='DIRTY' ? 'selected' : '' }>Dirty
                                                    </option>
                                                    <option value="CLEANING" ${status=='CLEANING' ? 'selected' : '' }>
                                                        Cleaning</option>
                                                    <option value="MAINTENANCE" ${status=='MAINTENANCE' ? 'selected'
                                                        : '' }>Maintenance</option>
                                                </select>
                                                <select name="sortBy" class="form-select form-select-sm"
                                                    style="max-width: 180px;">
                                                    <option value="room_number" ${sortBy=='room_number' ? 'selected'
                                                        : '' }>Sort by Room Number</option>
                                                    <option value="status" ${sortBy=='status' ? 'selected' : '' }>Sort
                                                        by Status</option>
                                                    <option value="floor" ${sortBy=='floor' ? 'selected' : '' }>Sort by
                                                        Floor</option>
                                                </select>
                                                <button type="submit" class="btn btn-sm btn-primary">Filter</button>
                                            </form>

                                            <a href="<c:url value='/owner/room-form'/>"
                                                class="btn btn-sm btn-success text-nowrap">
                                                <i class="bi bi-plus-lg"></i> Add Room
                                            </a>
                                        </div>

                                        <div class="table-responsive">
                                            <table class="table table-bordered table-hover align-middle">
                                                <thead class="bg-light">
                                                    <tr>
                                                        <th>Image</th>
                                                        <th>Room Number</th>
                                                        <th>Floor</th>
                                                        <th>Type ID</th>
                                                        <th>Status</th>
                                                        <th>Action</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:if test="${empty rooms}">
                                                        <tr>
                                                            <td colspan="6" class="text-center py-5 text-muted">
                                                                <i class="bi bi-door-closed fs-1 d-block mb-2"></i>
                                                                No rooms found matching your criteria.
                                                            </td>
                                                        </tr>
                                                    </c:if>
                                                    <c:forEach items="${rooms}" var="r">
                                                        <tr>
                                                            <td style="width: 80px;">
                                                                <c:if test="${not empty r.firstImage}">
                                                                    <img src="<c:url value='/${r.firstImage}'/>"
                                                                        alt="Room" class="rounded"
                                                                        style="width: 60px; height: 40px; object-fit: cover;">
                                                                </c:if>
                                                                <c:if test="${empty r.firstImage}">
                                                                    <span class="text-muted small">No Img</span>
                                                                </c:if>
                                                            </td>
                                                            <td class="fw-bold">Room ${r.roomNumber}</td>
                                                            <td>${r.floor}</td>
                                                            <td>${r.roomTypeId}</td>
                                                            <td>
                                                                <span
                                                                    class="badge rounded-pill 
                                                            ${r.status == 'AVAILABLE' ? 'bg-success' : 
                                                              (r.status == 'DIRTY' ? 'bg-danger' : 
                                                              (r.status == 'CLEANING' ? 'bg-warning' : 'bg-secondary'))}">
                                                                    ${r.status}
                                                                </span>
                                                            </td>
                                                            <td>
                                                                <!-- Edit Button Trigger -->
                                                                <a href="<c:url value='/owner/room-form?id=${r.roomId}'/>"
                                                                    class="btn btn-sm btn-outline-secondary">
                                                                    <i class="bi bi-pencil"></i> Edit
                                                                </a>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>

                                        <!-- Pagination -->
                                        <nav class="d-flex justify-content-between align-items-center mt-3">
                                            <small class="text-muted">Showing ${rooms.size()} of ${totalRooms}
                                                rooms</small>
                                            <ul class="pagination pagination-sm mb-0">
                                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                    <a class="page-link"
                                                        href="?tab=rooms&page=${currentPage - 1}&search=${search}&status=${status}&sortBy=${sortBy}">Previous</a>
                                                </li>
                                                <c:forEach begin="1" end="${totalPages}" var="p">
                                                    <li class="page-item ${currentPage == p ? 'active' : ''}">
                                                        <a class="page-link"
                                                            href="?tab=rooms&page=${p}&search=${search}&status=${status}&sortBy=${sortBy}">${p}</a>
                                                    </li>
                                                </c:forEach>
                                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                                    <a class="page-link"
                                                        href="?tab=rooms&page=${currentPage + 1}&search=${search}&status=${status}&sortBy=${sortBy}">Next</a>
                                                </li>
                                            </ul>
                                        </nav>
                                    </c:when>

                                    <c:when test="${activeTab == 'pricing'}">
                                        <!-- =================== PRICING POLICY TAB =================== -->
                                        <div class="alert alert-info">
                                            <i class="bi bi-info-circle me-2"></i>
                                            Pricing Policy allows you to set the base price for each room type.
                                        </div>
                                        <table class="table table-striped align-middle">
                                            <thead>
                                                <tr>
                                                    <th>Room Type</th>
                                                    <th>Max Occupancy</th>
                                                    <th>Base Price ($)</th>
                                                    <th>Action</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${roomTypes}" var="rt">
                                                    <form action="<c:url value='/owner/rooms'/>" method="post">
                                                        <input type="hidden" name="action" value="updateRoomType">
                                                        <input type="hidden" name="roomTypeId" value="${rt.roomTypeId}">
                                                        <input type="hidden" name="typeName" value="${rt.typeName}">
                                                        <input type="hidden" name="description"
                                                            value="${rt.description}">
                                                        <input type="hidden" name="maxOccupancy"
                                                            value="${rt.maxOccupancy}">
                                                        <input type="hidden" name="redirectTab" value="pricing">
                                                        <tr>
                                                            <td>${rt.typeName}</td>
                                                            <td>${rt.maxOccupancy}</td>
                                                            <td>
                                                                <input type="number" step="0.01" name="basePrice"
                                                                    class="form-control form-control-sm"
                                                                    value="${rt.basePrice}" style="width: 100px;">
                                                            </td>
                                                            <td>
                                                                <button type="submit"
                                                                    class="btn btn-sm btn-primary">Update Price</button>
                                                            </td>
                                                        </tr>
                                                    </form>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </c:when>

                                    <c:when test="${activeTab == 'types'}">
                                        <!-- =================== ROOM TYPES TAB =================== -->
                                        <div class="d-flex justify-content-between mb-3">
                                            <h5>All Room Types</h5>
                                            <button class="btn btn-sm btn-success" data-bs-toggle="modal"
                                                data-bs-target="#createTypeModal">
                                                <i class="bi bi-plus-lg"></i> Add New Type
                                            </button>
                                        </div>
                                        <table class="table table-bordered align-middle">
                                            <thead class="bg-light">
                                                <tr>
                                                    <th>ID</th>
                                                    <th>Type Name</th>
                                                    <th>Description</th>
                                                    <th>Price</th>
                                                    <th>Occupany</th>
                                                    <th>Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${roomTypes}" var="rt">
                                                    <tr>
                                                        <td>${rt.roomTypeId}</td>
                                                        <td>${rt.typeName}</td>
                                                        <td>${rt.description}</td>
                                                        <td>$${rt.basePrice}</td>
                                                        <td>${rt.maxOccupancy}</td>
                                                        <td>
                                                            <!-- Toggle/Edit could be added here similar to Create -->
                                                            <form action="<c:url value='/owner/rooms'/>" method="post"
                                                                style="display:inline;">
                                                                <input type="hidden" name="action"
                                                                    value="deleteRoomType">
                                                                <input type="hidden" name="id" value="${rt.roomTypeId}">
                                                                <button type="submit"
                                                                    class="btn btn-sm btn-outline-danger"
                                                                    onclick="return confirm('Are you sure?')">
                                                                    <i class="bi bi-trash"></i>
                                                                </button>
                                                            </form>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </c:when>
                                </c:choose>
                            </div>


                        </div>
                    </div>

                    <jsp:include page="../Shared/Footer.jsp" />
                </div>
            </div>


            <!-- Modal for Create Room -->
            <div class="modal fade" id="createRoomModal" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog">
                    <form action="<c:url value='/owner/rooms'/>" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="action" value="createRoom">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">Add New Room</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                    aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <div class="mb-3">
                                    <label class="form-label">Room Number</label>
                                    <input type="text" name="roomNumber" class="form-control" required>
                                </div>
                                <div class="row">
                                    <div class="col-6 mb-3">
                                        <label class="form-label">Floor</label>
                                        <input type="number" name="floor" class="form-control" required>
                                    </div>
                                    <div class="col-6 mb-3">
                                        <label class="form-label">Room Type</label>
                                        <select name="roomTypeId" class="form-select" required>
                                            <c:forEach items="${roomTypes}" var="rt">
                                                <option value="${rt.roomTypeId}">${rt.typeName}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Initial Status</label>
                                    <select name="status" class="form-select">
                                        <option value="AVAILABLE">AVAILABLE</option>
                                        <option value="MAINTENANCE">MAINTENANCE</option>
                                    </select>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Description</label>
                                    <textarea name="description" class="form-control" rows="2"></textarea>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Room Images (Select Multiple)</label>
                                    <input type="file" name="file" class="form-control" accept="image/*" multiple
                                        onchange="previewImages(this, 'createRoomPreviewContainer')">
                                    <div id="createRoomPreviewContainer"
                                        class="mt-2 d-flex flex-wrap gap-2 justify-content-center">
                                        <!-- Previews will be here -->
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                <button type="submit" class="btn btn-primary">Create Room</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Modal for Edit Room -->
            <div class="modal fade" id="editRoomModal" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog">
                    <form action="<c:url value='/owner/rooms'/>" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="action" value="updateRoom">
                        <input type="hidden" name="roomId" id="editRoomId">

                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">Edit Room</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                    aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <div class="mb-3">
                                    <label class="form-label">Room Number</label>
                                    <input type="text" name="roomNumber" id="editRoomNumber" class="form-control"
                                        required>
                                </div>
                                <div class="row">
                                    <div class="col-6 mb-3">
                                        <label class="form-label">Floor</label>
                                        <input type="number" name="floor" id="editFloor" class="form-control" required>
                                    </div>
                                    <div class="col-6 mb-3">
                                        <label class="form-label">Room Type</label>
                                        <select name="roomTypeId" id="editRoomTypeId" class="form-select" required>
                                            <c:forEach items="${roomTypes}" var="rt">
                                                <option value="${rt.roomTypeId}">${rt.typeName}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Status</label>
                                    <select name="status" id="editStatus" class="form-select">
                                        <option value="AVAILABLE">AVAILABLE</option>
                                        <option value="BOOKED">BOOKED</option>
                                        <option value="OCCUPIED">OCCUPIED</option>
                                        <option value="DIRTY">DIRTY</option>
                                        <option value="CLEANING">CLEANING</option>
                                        <option value="MAINTENANCE">MAINTENANCE</option>
                                    </select>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Description</label>
                                    <textarea name="description" id="editDescription" class="form-control"
                                        rows="2"></textarea>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Change Images (Select Multiple, Replaces All)</label>
                                    <input type="file" name="file" class="form-control" accept="image/*" multiple
                                        onchange="previewImages(this, 'editRoomPreviewContainer')">
                                    <div id="editRoomPreviewContainer"
                                        class="mt-2 d-flex flex-wrap gap-2 justify-content-center">
                                        <!-- Previews will be here -->
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                <button type="submit" class="btn btn-primary">Update Room</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Modal for Create Room Type -->
            <div class="modal fade" id="createTypeModal" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog">
                    <form action="<c:url value='/owner/rooms'/>" method="post">
                        <input type="hidden" name="action" value="createRoomType">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">Create Room Type</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                    aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <div class="mb-3">
                                    <label class="form-label">Type Name</label>
                                    <input type="text" name="typeName" class="form-control" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Description</label>
                                    <textarea name="description" class="form-control" rows="3"></textarea>
                                </div>
                                <div class="row">
                                    <div class="col-6 mb-3">
                                        <label class="form-label">Base Price ($)</label>
                                        <input type="number" step="0.01" name="basePrice" class="form-control" required>
                                    </div>
                                    <div class="col-6 mb-3">
                                        <label class="form-label">Max Occupancy</label>
                                        <input type="number" name="maxOccupancy" class="form-control" required>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                <button type="submit" class="btn btn-primary">Create</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
            <script>
                // Check if there's a notification from session
                <%
                    String notification = (String) session.getAttribute("notification");
                if (notification != null && !notification.isEmpty()) {
                    String[] parts = notification.split("\\|");
                        String type = parts[0];
                        String msg = parts.length > 1 ? parts[1] : "";
                %>
                        Swal.fire({
                            icon: '<%= type %>',
                            title: '<%= type.substring(0, 1).toUpperCase() + type.substring(1) %>',
                            text: '<%= msg %>',
                            timer: 3000,
                            showConfirmButton: false
                        });
                <%
                        session.removeAttribute("notification");
                }
                %>
            </script>
            <script>
                    function previewImages(input, containerId) {
                        const container = document.getElementById(containerId);
                        container.innerHTML = ''; // Clear current

                        if (input.files) {
                            Array.from(input.files).forEach(file => {
                                const reader = new FileReader();
                                reader.onload = function (e) {
                                    const img = document.createElement('img');
                                    img.src = e.target.result;
                                    img.className = 'img-thumbnail';
                                    img.style.maxHeight = '300px'; // Bigger preview
                                    img.style.maxWidth = '100%';
                                    container.appendChild(img);
                                }
                                reader.readAsDataURL(file);
                            });
                        }
                    }

                function openEditRoomModal(id, number, floor, typeId, status, desc, imageUrl) {
                    document.getElementById('editRoomId').value = id;
                    document.getElementById('editRoomNumber').value = number;
                    document.getElementById('editFloor').value = floor;
                    document.getElementById('editRoomTypeId').value = typeId;
                    document.getElementById('editStatus').value = status;
                    document.getElementById('editDescription').value = desc;

                    const container = document.getElementById('editRoomPreviewContainer');
                    container.innerHTML = ''; // Clear

                    if (imageUrl && imageUrl.trim() !== '') {
                        const images = imageUrl.split(';');
                        images.forEach(url => {
                            const img = document.createElement('img');
                            img.src = '${pageContext.request.contextPath}/' + url;
                            img.className = 'img-thumbnail';
                            img.style.maxHeight = '300px'; // Bigger preview
                            img.style.maxWidth = '100%';
                            container.appendChild(img);
                        });
                    }
                    // Reset file input in case it was used before
                    // Note: Cannot programeatically reset file input value easily to specific files, but clearing it is safe if needed. 
                    // Actually, if it's the same modal instance, the form might keep state? 
                    // The form is inside the modal, usually simple <form> reset might be needed, but separate issue.

                    var modal = new bootstrap.Modal(document.getElementById('editRoomModal'));
                    modal.show();
                }
            </script>
        </body>

        </html>