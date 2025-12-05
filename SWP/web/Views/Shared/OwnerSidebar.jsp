<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <aside class="sidebar">
            <div class="sidebar-brand">
                <i class="bi bi-building-fill"></i>
                <span>HMS Owner</span>
            </div>

            <ul class="sidebar-nav">
                <li class="nav-item">
                    <a href="<c:url value='/owner/dashboard'/>"
                        class="nav-link ${pageContext.request.servletPath.endsWith('Dashboard.jsp') ? 'active' : ''}">
                        <i class="bi bi-speedometer2"></i>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<c:url value='/owner/employees'/>"
                        class="nav-link ${pageContext.request.servletPath.endsWith('EmployeeList.jsp') || pageContext.request.servletPath.endsWith('EmployeeDetail.jsp') || pageContext.request.servletPath.endsWith('CreateEmployee.jsp') ? 'active' : ''}">
                        <i class="bi bi-people-fill"></i>
                        <span>Employees</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<c:url value='/owner/assignments'/>"
                        class="nav-link ${pageContext.request.servletPath.endsWith('JobAssignment.jsp') ? 'active' : ''}">
                        <i class="bi bi-calendar-check"></i>
                        <span>Job Assignment</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<c:url value='/owner/staff-status'/>"
                        class="nav-link ${pageContext.request.servletPath.endsWith('StaffStatus.jsp') ? 'active' : ''}">
                        <i class="bi bi-person-badge"></i>
                        <span>Staff Status</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<c:url value='/owner/reports'/>"
                        class="nav-link ${pageContext.request.servletPath.endsWith('Reports.jsp') ? 'active' : ''}">
                        <i class="bi bi-graph-up"></i>
                        <span>Reports</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<c:url value='/owner/rooms'/>"
                        class="nav-link ${pageContext.request.servletPath.endsWith('RoomManagement.jsp') ? 'active' : ''}">
                        <i class="bi bi-door-open-fill"></i>
                        <span>Room Management</span>
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