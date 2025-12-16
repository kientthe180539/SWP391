<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>${empty amenity ? 'Create' : 'Edit'} Amenity | HMS</title>
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                rel="stylesheet">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
            <link rel="stylesheet" href="<c:url value='/CSS/housekeeping.css'/>">
        </head>

        <body>
            <div class="layout-wrapper">
                <jsp:include page="../Shared/AdminSidebar.jsp" />
                <div class="main-content">
                    <jsp:include page="../Shared/Header.jsp" />
                    <div class="container-fluid py-4 px-4">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <div>
                                <h2 class="mb-1">${empty amenity ? 'Create New' : 'Edit'} Amenity</h2>
                                <nav aria-label="breadcrumb">
                                    <ol class="breadcrumb mb-0">
                                        <li class="breadcrumb-item"><a href="amenities">Amenities</a></li>
                                        <li class="breadcrumb-item active" aria-current="page">${empty amenity ?
                                            'Create' : 'Edit'}</li>
                                    </ol>
                                </nav>
                            </div>
                        </div>

                        <div class="card border-0 shadow-sm" style="max-width: 600px;">
                            <div class="card-body p-4">
                                <form action="amenities" method="post">
                                    <input type="hidden" name="action" value="${empty amenity ? 'create' : 'update'}">
                                    <c:if test="${not empty amenity}">
                                        <input type="hidden" name="amenityId" value="${amenity.amenityId}">
                                    </c:if>

                                    <div class="mb-3">
                                        <label class="form-label">Name</label>
                                        <input type="text" class="form-control" name="name" value="${amenity.name}"
                                            required>
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label">Description</label>
                                        <textarea class="form-control" name="description"
                                            rows="3">${amenity.description}</textarea>
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label">Price (Cost if damaged)</label>
                                        <input type="number" class="form-control" name="price" value="${amenity.price}"
                                            step="0.01" min="0">
                                    </div>

                                    <c:if test="${not empty amenity}">
                                        <div class="mb-3 form-check">
                                            <input type="checkbox" class="form-check-input" id="isActive"
                                                name="isActive" ${amenity.active ? 'checked' : '' }>
                                            <label class="form-check-label" for="isActive">Active</label>
                                        </div>
                                    </c:if>

                                    <div class="d-flex justify-content-end gap-2">
                                        <a href="amenities" class="btn btn-light">Cancel</a>
                                        <button type="submit" class="btn btn-primary">Save Changes</button>
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