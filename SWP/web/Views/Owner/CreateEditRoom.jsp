<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${mode == 'UPDATE' ? 'Edit Room' : 'Add New Room'} | HMS Owner</title>

        <!-- Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap"
              rel="stylesheet">

        <!-- Bootstrap 5 -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

        <!-- Custom CSS -->
        <link rel="stylesheet" href="<c:url value='/CSS/housekeeping.css'/>">

        <style>
            body {
                font-family: 'Outfit', sans-serif;
                background: linear-gradient(135deg, #f1f5f9 0%, #e2e8f0 100%);
                min-height: 100vh;
            }

            .page-header {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                padding: 1.25rem 2rem;
                border-bottom: 1px solid rgba(0, 0, 0, 0.05);
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .form-card {
                background: #fff;
                border-radius: 20px;
                box-shadow: 0 10px 30px -5px rgba(0, 0, 0, 0.05);
                overflow: hidden;
                border: 1px solid rgba(0, 0, 0, 0.02);
                transition: transform 0.3s ease;
            }

            .form-card:hover {
                box-shadow: 0 20px 40px -5px rgba(0, 0, 0, 0.1);
            }

            .form-section-title {
                font-size: 1.1rem;
                font-weight: 700;
                color: #0f172a;
                margin-bottom: 1.5rem;
                padding-bottom: 0.75rem;
                border-bottom: 2px solid #f1f5f9;
                display: flex;
                align-items: center;
            }

            .form-label {
                font-weight: 600;
                color: #475569;
                font-size: 0.85rem;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                margin-bottom: 0.5rem;
            }

            .form-control,
            .form-select {
                padding: 0.75rem 1rem;
                border-radius: 12px;
                border: 2px solid #e2e8f0;
                font-weight: 500;
                background-color: #f8fafc;
                transition: all 0.2s ease;
            }

            .form-control:focus,
            .form-select:focus {
                border-color: #6366f1;
                background-color: #fff;
                box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.1);
                outline: none;
            }

            /* Image Upload Area */
            .upload-zone {
                background-color: #f8fafc;
                border: 2px dashed #cbd5e1;
                border-radius: 16px;
                padding: 1rem;
                text-align: center;
                transition: all 0.3s ease;
                cursor: pointer;
                position: relative;
                border-width: 3px;
            }

            .upload-zone:hover,
            .upload-zone.dragover {
                background-color: #f0fdf4;
                border-color: #22c55e;
                transform: translateY(-2px);
            }

            .upload-icon {
                font-size: 1.5rem;
                color: #94a3b8;
                margin-bottom: 0.5rem;
                transition: color 0.3s;
            }

            .upload-zone:hover .upload-icon {
                color: #22c55e;
            }

            .preview-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
                gap: 1.5rem;
                margin-top: 1.5rem;
            }

            .preview-item {
                position: relative;
                aspect-ratio: 4/3;
                border-radius: 12px;
                overflow: hidden;
                box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
                transition: transform 0.2s ease;
                border: 1px solid rgba(0, 0, 0, 0.05);
            }

            .preview-item:hover {
                transform: scale(1.02);
                box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
                z-index: 1;
            }

            .preview-item img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            .btn-primary-custom {
                background: linear-gradient(135deg, #0f172a 0%, #334155 100%);
                color: white;
                padding: 0.75rem 2rem;
                border-radius: 12px;
                font-weight: 600;
                border: none;
                transition: all 0.3s;
                box-shadow: 0 4px 6px rgba(15, 23, 42, 0.2);
            }

            .btn-primary-custom:hover {
                background: linear-gradient(135deg, #1e293b 0%, #475569 100%);
                transform: translateY(-2px);
                box-shadow: 0 8px 12px rgba(15, 23, 42, 0.3);
            }

            .badge-status {
                font-size: 0.8rem;
                padding: 0.5rem 1rem;
                border-radius: 50px;
            }
        </style>
    </head>

    <body>

        <div class="layout-wrapper">
            <jsp:include page="../Shared/OwnerSidebar.jsp" />

            <div class="main-content">
                <!-- Header -->
                <div class="page-header sticky-top shadow-sm z-3">
                    <div class="d-flex align-items-center gap-3">
                        <a href="<c:url value='/owner/rooms'/>"
                           class="btn btn-light rounded-circle p-2 d-flex align-items-center justify-content-center"
                           style="width: 40px; height: 40px;">
                            <i class="bi bi-arrow-left"></i>
                        </a>
                        <div>
                            <h4 class="mb-0 fw-bold">${mode == 'UPDATE' ? 'Edit Room' : 'Add New Room'}</h4>
                            <nav aria-label="breadcrumb">
                                <ol class="breadcrumb mb-0 small text-muted">
                                    <li class="breadcrumb-item">Owner</li>
                                    <li class="breadcrumb-item">Rooms</li>
                                    <li class="breadcrumb-item active">${mode == 'UPDATE' ? room.roomNumber : 'New'}
                                    </li>
                                </ol>
                            </nav>
                        </div>
                    </div>
                    <div class="d-flex gap-2">
                        <a href="<c:url value='/owner/rooms'/>" class="btn btn-light border">Cancel</a>
                        <button type="button" onclick="submitForm()" class="btn btn-primary-custom">
                            <i class="bi bi-check-lg me-2"></i> Save Changes
                        </button>
                    </div>
                </div>

                <div class="container-fluid p-4">
                    <form id="roomForm" action="<c:url value='/owner/rooms'/>" method="post"
                          enctype="multipart/form-data">
                        <input type="hidden" name="action"
                               value="${mode == 'UPDATE' ? 'updateRoom' : 'createRoom'}">
                        <c:if test="${mode == 'UPDATE'}">
                            <input type="hidden" name="roomId" value="${room.roomId}">
                        </c:if>

                        <div class="row g-4">
                            <!-- LEFT COLUMN: Basic Info -->
                            <div class="col-lg-7">
                                <div class="form-card p-4 h-100">
                                    <h5 class="form-section-title">
                                        <i class="bi bi-info-circle me-2 text-primary"></i> Basic Information
                                    </h5>

                                    <div class="row g-3">
                                        <div class="col-md-6">
                                            <label class="form-label">Room Number</label>
                                            <input type="text" name="roomNumber" class="form-control"
                                                   value="${room.roomNumber}" required placeholder="e.g. 101">
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label">Floor</label>
                                            <input type="number" name="floor" class="form-control"
                                                   value="${room.floor}" required placeholder="e.g. 1">
                                        </div>

                                        <div class="col-md-6">
                                            <label class="form-label">Room Type</label>
                                            <select name="roomTypeId" class="form-select" required>
                                                <option value="">Select Type...</option>
                                                <c:forEach items="${roomTypes}" var="rt">
                                                    <option value="${rt.roomTypeId}"
                                                            ${room.roomTypeId==rt.roomTypeId ? 'selected' : '' }>
                                                        ${rt.typeName} ($${rt.basePrice})
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <div class="col-md-6">
                                            <label class="form-label">Current Status</label>
                                            <select name="status" class="form-select">
                                                <option value="AVAILABLE" ${room.status=='AVAILABLE' ? 'selected'
                                                                            : '' }>Available</option>
                                                <option value="BOOKED" ${room.status=='BOOKED' ? 'selected' : '' }>
                                                    Booked</option>
                                                <option value="OCCUPIED" ${room.status=='OCCUPIED' ? 'selected' : ''
                                                        }>Occupied</option>
                                                <option value="DIRTY" ${room.status=='DIRTY' ? 'selected' : '' }>
                                                    Dirty</option>
                                                <option value="CLEANING" ${room.status=='CLEANING' ? 'selected' : ''
                                                        }>Cleaning</option>
                                                <option value="MAINTENANCE" ${room.status=='MAINTENANCE'
                                                                              ? 'selected' : '' }>Maintenance</option>
                                            </select>
                                        </div>

                                        <div class="col-12">
                                            <label class="form-label">Description</label>
                                            <textarea name="description" class="form-control" rows="4"
                                                      placeholder="Enter room details, features, view...">${room.description}</textarea>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- RIGHT COLUMN: Images -->
                            <div class="col-lg-5">
                                <div class="form-card p-4 h-100">
                                    <h5 class="form-section-title">
                                        <i class="bi bi-images me-2 text-primary"></i> Room Gallery
                                    </h5>

                                    <div class="alert alert-light border small text-muted">
                                        <i class="bi bi-info-circle me-1"></i>
                                        Supported formats: JPG, PNG. Max size: 5MB per file.
                                    </div>

                                    <div class="upload-zone" onclick="document.getElementById('fileInput').click()">
                                        <i class="bi bi-cloud-arrow-up upload-icon"></i>
                                        <h6 class="fw-bold text-dark">Click to upload images</h6>
                                        <p class="text-muted small mb-0">or drag and drop here</p>
                                        <input type="file" id="fileInput" name="file" class="d-none" multiple
                                               accept="image/*" onchange="handleFileSelect(this)">
                                    </div>

                                    <div id="previewContainer" class="preview-grid">
                                        <!-- Existing Images -->
                                        <c:if test="${not empty room.imageList}">
                                            <c:forEach items="${room.imageList}" var="imgUrl">
                                                <div class="preview-item">
                                                    <img src="${pageContext.request.contextPath}/${imgUrl}"
                                                         alt="Room Image">
                                                    <!-- Note: Removing existing server images is complex without AJAX. 
                                                 For now we assume new upload REPLACES all if provided, 
                                                 or keeps old if no new files. -->
                                                </div>
                                            </c:forEach>
                                        </c:if>
                                    </div>

                                    <c:if test="${mode == 'UPDATE'}">
                                        <div class="mt-3 text-warning small">
                                            <i class="bi bi-exclamation-triangle"></i>
                                            Note: Uploading new images will replace all existing images.
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>

                <jsp:include page="../Shared/Footer.jsp" />
            </div>
        </div>

        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

        <script>
                                                   function submitForm() {
                                                       const form = document.getElementById('roomForm');

                                                       // Client-side validation
                                                       const roomNumber = form.querySelector('[name="roomNumber"]').value;
                                                       const floor = form.querySelector('[name="floor"]').value;
                                                       const typeId = form.querySelector('[name="roomTypeId"]').value;

                                                       if (!roomNumber.trim()) {
                                                           Swal.fire('Error', 'Please enter a Room Number', 'error');
                                                           return;
                                                       }
                                                       if (!floor.trim()) {
                                                           Swal.fire('Error', 'Please enter a Floor number', 'error');
                                                           return;
                                                       }
                                                       if (!typeId) {
                                                           Swal.fire('Error', 'Please select a Room Type', 'error');
                                                           return;
                                                       }

                                                       // Confirm before submit
                                                       Swal.fire({
                                                           title: 'Are you sure?',
                                                           text: "Do you want to save these changes?",
                                                           icon: 'question',
                                                           showCancelButton: true,
                                                           confirmButtonColor: '#3085d6',
                                                           cancelButtonColor: '#d33',
                                                           confirmButtonText: 'Yes, save it!'
                                                       }).then((result) => {
                                                           if (result.isConfirmed) {
                                                               form.submit();
                                                           }
                                                       });
                                                   }

                                                   function handleFileSelect(input) {
                                                       const container = document.getElementById('previewContainer');
                                                       // Check if we should clear existing (if replacing)
                                                       // For this simple implementation, showing what will be uploaded matches the "replace all" logic
                                                       container.innerHTML = '';

                                                       if (input.files) {
                                                           Array.from(input.files).forEach(file => {
                                                               // Validate file size (e.g. 5MB)
                                                               if (file.size > 5 * 1024 * 1024) {
                                                                   Swal.fire('Error', 'File ' + file.name + ' is too large (Max 5MB)', 'error');
                                                                   return;
                                                               }

                                                               const reader = new FileReader();
                                                               reader.onload = function (e) {
                                                                   const div = document.createElement('div');
                                                                   div.className = 'preview-item';
                                                                   div.innerHTML = '<img src="' + e.target.result + '" alt="Preview">';
                                                                   container.appendChild(div);
                                                               }
                                                               reader.readAsDataURL(file);
                                                           });
                                                       }
                                                   }

                                                   function removePreview(btn) {
                                                       btn.closest('.preview-item').remove();
                                                   }

                                                   // Drag and drop handlers for the upload zone
                                                   const dropZone = document.querySelector('.upload-zone');

                                                   ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
                                                       dropZone.addEventListener(eventName, preventDefaults, false);
                                                   });

                                                   function preventDefaults(e) {
                                                       e.preventDefault();
                                                       e.stopPropagation();
                                                   }

                                                   ['dragenter', 'dragover'].forEach(eventName => {
                                                       dropZone.addEventListener(eventName, highlight, false);
                                                   });

                                                   ['dragleave', 'drop'].forEach(eventName => {
                                                       dropZone.addEventListener(eventName, unhighlight, false);
                                                   });

                                                   function highlight(e) {
                                                       dropZone.classList.add('dragover');
                                                   }

                                                   function unhighlight(e) {
                                                       dropZone.classList.remove('dragover');
                                                   }

                                                   dropZone.addEventListener('drop', handleDrop, false);

                                                   function handleDrop(e) {
                                                       const dt = e.dataTransfer;
                                                       const files = dt.files;

                                                       document.getElementById('fileInput').files = files;
                                                       handleFileSelect(document.getElementById('fileInput'));
                                                   }
        </script>
    </body>

</html>