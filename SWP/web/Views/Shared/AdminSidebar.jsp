<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <aside class="sidebar">
            <div class="sidebar-brand">
                <i class="bi bi-shield-lock-fill"></i>
                <span>HMS Admin</span>
            </div>

            <ul class="sidebar-nav">
                <li class="nav-item">
                    <a href="<c:url value='/admin/dashboard'/>"
                        class="nav-link ${pageContext.request.servletPath.endsWith('Dashboard.jsp') ? 'active' : ''}">
                        <i class="bi bi-speedometer2"></i>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<c:url value='/admin/users'/>"
                        class="nav-link ${pageContext.request.servletPath.endsWith('UserList.jsp') || pageContext.request.servletPath.endsWith('UserDetail.jsp') ? 'active' : ''}">
                        <i class="bi bi-people-fill"></i>
                        <span>User Accounts</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<c:url value='/admin/roles'/>"
                        class="nav-link ${pageContext.request.servletPath.endsWith('RoleManagement.jsp') ? 'active' : ''}">
                        <i class="bi bi-person-badge-fill"></i>
                        <span>Roles & Permissions</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<c:url value='/admin/config'/>"
                        class="nav-link ${pageContext.request.servletPath.endsWith('SystemConfig.jsp') ? 'active' : ''}">
                        <i class="bi bi-gear-fill"></i>
                        <span>System Config</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<c:url value='/admin/logs'/>"
                        class="nav-link ${pageContext.request.servletPath.endsWith('SystemLogs.jsp') ? 'active' : ''}">
                        <i class="bi bi-journal-text"></i>
                        <span>System Logs</span>
                    </a>
                </li>
            </ul>

            <div class="sidebar-footer">
                <a href="<c:url value='/logout'/>" class="nav-link text-danger">
                    <i class="bi bi-box-arrow-right"></i>
                    <span>Logout</span>
                </a>
            </div>
        </aside>