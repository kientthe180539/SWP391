<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <aside class="sidebar">
            <div class="sidebar-brand">
                <i class="bi bi-building-fill"></i>
                <span>HMS Hotel</span>
            </div>

            <ul class="sidebar-nav">
                <c:choose>
                    <%-- Admin Role (ID: 5) --%>
                        <c:when test="${sessionScope.currentUser.roleId == 5}">
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
                                    <i class="bi bi-shield-lock"></i>
                                    <span>Roles & Permissions</span>
                                </a>
                            </li>
                            <li class="nav-header">Employees</li>
                            <li class="nav-item">
                                <a href="<c:url value='/admin/employees'/>"
                                    class="nav-link ${pageContext.request.servletPath.endsWith('EmployeeList.jsp') ? 'active' : ''}">
                                    <i class="bi bi-person-badge"></i>
                                    <span>Employee List</span>
                                </a>
                            </li>
                            <li class="nav-item">
                                <a href="<c:url value='/admin/create-employee'/>"
                                    class="nav-link ${pageContext.request.servletPath.endsWith('CreateEmployee.jsp') ? 'active' : ''}">
                                    <i class="bi bi-person-plus"></i>
                                    <span>Create Employee</span>
                                </a>
                            </li>
                        </c:when>

                        <%-- Manager Role (ID: 6) --%>
                            <c:when test="${sessionScope.currentUser.roleId == 6}">
                                <li class="nav-header">Overview</li>
                                <li class="nav-item">
                                    <a href="<c:url value='/manager/dashboard'/>"
                                        class="nav-link ${pageContext.request.servletPath.endsWith('Dashboard.jsp') ? 'active' : ''}">
                                        <i class="bi bi-speedometer2"></i>
                                        <span>Dashboard</span>
                                    </a>
                                </li>

                                <li class="nav-header">Operations</li>
                                <li class="nav-item">
                                    <a href="<c:url value='/manager/rooms'/>"
                                        class="nav-link ${pageContext.request.servletPath.endsWith('RoomList.jsp') ? 'active' : ''}">
                                        <i class="bi bi-door-open"></i>
                                        <span>Rooms</span>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a href="<c:url value='/manager/bookings'/>"
                                        class="nav-link ${pageContext.request.servletPath.endsWith('BookingList.jsp') ? 'active' : ''}">
                                        <i class="bi bi-calendar-check"></i>
                                        <span>Reservations</span>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a href="<c:url value='/manager/housekeeping'/>"
                                        class="nav-link ${pageContext.request.servletPath.endsWith('Housekeeping.jsp') ? 'active' : ''}">
                                        <i class="bi bi-bucket"></i>
                                        <span>Housekeeping Overview</span>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a href="<c:url value='/manager/inspections'/>"
                                        class="nav-link ${pageContext.request.servletPath.endsWith('InspectionList.jsp') ? 'active' : ''}">
                                        <i class="bi bi-clipboard-check"></i>
                                        <span>Inspections</span>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a href="<c:url value='/manager/replenishment-requests'/>"
                                        class="nav-link ${pageContext.request.servletPath.endsWith('ReplenishmentRequests.jsp') ? 'active' : ''}">
                                        <i class="bi bi-box-seam"></i>
                                        <span>Replenishment</span>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a href="<c:url value='/manager/create-task'/>"
                                        class="nav-link ${pageContext.request.servletPath.endsWith('CreateTask.jsp') ? 'active' : ''}">
                                        <i class="bi bi-plus-circle"></i>
                                        <span>Create Task</span>
                                    </a>
                                </li>

                                <li class="nav-header">Supervision</li>
                                <li class="nav-item">
                                    <a href="<c:url value='/manager/staff'/>"
                                        class="nav-link ${pageContext.request.servletPath.endsWith('StaffList.jsp') ? 'active' : ''}">
                                        <i class="bi bi-people"></i>
                                        <span>Staff Management</span>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a href="<c:url value='/manager/issues'/>"
                                        class="nav-link ${pageContext.request.servletPath.endsWith('IssueList.jsp') ? 'active' : ''}">
                                        <i class="bi bi-exclamation-triangle"></i>
                                        <span>Feedback & Issues</span>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a href="<c:url value='/manager/reports'/>"
                                        class="nav-link ${pageContext.request.servletPath.endsWith('Reports.jsp') ? 'active' : ''}">
                                        <i class="bi bi-bar-chart"></i>
                                        <span>Reports</span>
                                    </a>
                                </li>
                            </c:when>

                            <%-- Housekeeping Role (ID: 3) --%>
                                <c:when test="${sessionScope.currentUser.roleId == 3}">
                                    <li class="nav-item">
                                        <a href="<c:url value='/housekeeping/dashboard'/>"
                                            class="nav-link ${pageContext.request.servletPath.endsWith('Dashboard.jsp') ? 'active' : ''}">
                                            <i class="bi bi-grid-1x2-fill"></i>
                                            <span>Dashboard</span>
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="<c:url value='/housekeeping/tasks'><c:param name='type' value='CLEANING'/></c:url>"
                                            class="nav-link ${param.type == 'CLEANING' ? 'active' : ''}">
                                            <i class="bi bi-bucket"></i>
                                            <span>Cleaning Tasks</span>
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="<c:url value='/housekeeping/rooms'/>"
                                            class="nav-link ${pageContext.request.servletPath.endsWith('RoomList.jsp') ? 'active' : ''}">
                                            <i class="bi bi-door-open"></i>
                                            <span>Room Status</span>
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="<c:url value='/housekeeping/supplies'/>"
                                            class="nav-link ${pageContext.request.servletPath.endsWith('Supplies.jsp') ? 'active' : ''}">
                                            <i class="bi bi-box-seam"></i>
                                            <span>Supplies</span>
                                        </a>
                                    </li>
                                </c:when>
                </c:choose>
            </ul>

            <div class="sidebar-footer">
                <a href="<c:url value='/logout'/>" class="nav-link text-danger">
                    <i class="bi bi-box-arrow-right"></i>
                    <span>Logout</span>
                </a>
            </div>
        </aside>