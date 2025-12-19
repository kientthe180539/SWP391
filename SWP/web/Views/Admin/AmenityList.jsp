<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Amenity Management | HMS</title>
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                rel="stylesheet">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
            <link rel="stylesheet" href="<c:url value='/CSS/housekeeping.css'/>">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
        </head>

        <body>
            <div class="layout-wrapper">
                <jsp:include page="../Shared/AdminSidebar.jsp" />
                <div class="main-content">
                    <jsp:include page="../Shared/Header.jsp" />
                    <div class="container-fluid py-4 px-4">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <div>
                                <h2 class="mb-1">Amenity Management</h2>
                                <p class="text-muted mb-0">Manage list of amenities for inspection.</p>
                            </div>
                            <a href="amenity-detail" class="btn btn-primary">
                                <i class="bi bi-plus-lg me-1"></i> Add New Amenity
                            </a>
                        </div>

                        <c:if test="${not empty param.msg}">
                            <c:set var="type" value="success" scope="request" />
                            <c:set var="mess" value="Action completed successfully!" scope="request" />
                        </c:if>
                        <jsp:include page="../public/notify.jsp" />

                        <div class="card border-0 shadow-sm">
                            <div class="card-body p-0">
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle mb-0">
                                        <thead class="bg-light">
                                            <tr>
                                                <th class="ps-4">ID</th>
                                                <th>Name</th>
                                                <th>Description</th>
                                                <th>Price</th>
                                                <th>Status</th>
                                                <th class="text-end pe-4">Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${amenities}" var="a">
                                                <tr>
                                                    <td class="ps-4">#${a.amenityId}</td>
                                                    <td class="fw-bold">${a.name}</td>
                                                    <td>${a.description}</td>
                                                    <td>${a.price}</td>
                                                    <td>
                                                        <span class="badge ${a.active ? 'bg-success' : 'bg-secondary'}">
                                                            ${a.active ? 'Active' : 'Inactive'}
                                                        </span>
                                                    </td>
                                                    <td class="text-end pe-4">
                                                        <a href="amenity-detail?id=${a.amenityId}"
                                                            class="btn btn-sm btn-outline-primary">
                                                            Edit
                                                        </a>
                                                        <form action="amenities" method="post" class="d-inline"
                                                            onsubmit="return confirm('Are you sure?');">
                                                            <input type="hidden" name="action" value="delete">
                                                            <input type="hidden" name="amenityId"
                                                                value="${a.amenityId}">
                                                            <button type="submit"
                                                                class="btn btn-sm btn-outline-danger">Delete</button>
                                                        </form>
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