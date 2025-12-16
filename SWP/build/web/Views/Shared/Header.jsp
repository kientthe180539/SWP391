<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <header class="top-header">
            <div class="d-flex align-items-center">
                <button class="btn btn-link text-dark d-md-none me-2" id="sidebarToggle">
                    <i class="bi bi-list fs-4"></i>
                </button>
                <h5 class="header-title mb-0">Housekeeping Management</h5>
            </div>

            <div class="user-profile">
                <div class="text-end d-none d-sm-block">
                    <div class="fw-bold text-dark">${sessionScope.currentUser.fullName}</div>
                    <div class="small text-muted">Housekeeping Staff</div>
                </div>
                <div class="user-avatar">
                    ${sessionScope.currentUser.username.substring(0, 1).toUpperCase()}
                </div>
            </div>
        </header>