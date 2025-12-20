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
                            <div class="card-header bg-white py-3">
                                <form action="<c:url value='/admin/amenities'/>" method="get">
                                    <div class="row g-3">
                                        <div class="col-md-3">
                                            <div class="input-group input-group-sm">
                                                <span class="input-group-text bg-light border-end-0"><i
                                                        class="bi bi-search"></i></span>
                                                <input type="text" name="search" class="form-control border-start-0"
                                                    placeholder="Search amenity..." value="${search}">
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <select name="status" class="form-select form-select-sm">
                                                <option value="">All Status</option>
                                                <option value="true" ${status=='true' ? 'selected' : '' }>Active
                                                </option>
                                                <option value="false" ${status=='false' ? 'selected' : '' }>Inactive
                                                </option>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <select name="sortBy" class="form-select form-select-sm">
                                                <option value="amenity_id" ${sortBy=='amenity_id' ? 'selected' : '' }>
                                                    Sort by ID</option>
                                                <option value="name" ${sortBy=='name' ? 'selected' : '' }>Sort by Name
                                                </option>
                                                <option value="price" ${sortBy=='price' ? 'selected' : '' }>Sort by
                                                    Price</option>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <select name="sortOrder" class="form-select form-select-sm">
                                                <option value="ASC" ${sortOrder=='ASC' ? 'selected' : '' }>Ascending
                                                </option>
                                                <option value="DESC" ${sortOrder=='DESC' ? 'selected' : '' }>Descending
                                                </option>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <button type="submit" class="btn btn-sm btn-primary w-100">Filter</button>
                                        </div>
                                    </div>
                                </form>
                            </div>
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
                                            <c:if test="${empty amenities}">
                                                <tr>
                                                    <td colspan="6" class="text-center py-5 text-muted">
                                                        <i class="bi bi-box fs-1 d-block mb-2"></i>
                                                        No amenities found.
                                                    </td>
                                                </tr>
                                            </c:if>
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
                            <div class="card-footer bg-white py-3">
                                <nav class="d-flex justify-content-between align-items-center">
                                    <small class="text-muted">Showing ${amenities.size()} of ${totalAmenities}
                                        amenities</small>
                                    <c:if test="${totalPages > 1}">
                                        <ul class="pagination pagination-sm mb-0">
                                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                <a class="page-link"
                                                    href="?page=${currentPage - 1}&search=${search}&status=${status}&sortBy=${sortBy}&sortOrder=${sortOrder}">Previous</a>
                                            </li>
                                            <c:forEach begin="1" end="${totalPages}" var="p">
                                                <li class="page-item ${currentPage == p ? 'active' : ''}">
                                                    <a class="page-link"
                                                        href="?page=${p}&search=${search}&status=${status}&sortBy=${sortBy}&sortOrder=${sortOrder}">${p}</a>
                                                </li>
                                            </c:forEach>
                                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                                <a class="page-link"
                                                    href="?page=${currentPage + 1}&search=${search}&status=${status}&sortBy=${sortBy}&sortOrder=${sortOrder}">Next</a>
                                            </li>
                                        </ul>
                                    </c:if>
                                </nav>
                            </div>
                        </div>
                    </div>
                    <jsp:include page="../Shared/Footer.jsp" />
                </div>
            </div>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>