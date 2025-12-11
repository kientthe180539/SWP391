<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <aside class="sidebar">
            <div class="sidebar-brand">
                <i class="bi bi-building-fill"></i>
                <span>HMS Hotel</span>
            </div>

            <ul class="sidebar-nav">
                <c:choose>
                    <%-- Manager Role (ID: 6) --%>
                        <c:when test="${sessionScope.currentUser.roleId == 6}">
                            <li class="nav-item">
                                <a href="<c:url value='/manager/dashboard'/>"
                                    class="nav-link ${pageContext.request.servletPath.endsWith('Dashboard.jsp') ? 'active' : ''}">
                                    <i class="bi bi-speedometer2"></i>
                                    <span>Dashboard</span>
                                </a>
                            </li>
                            <li class="nav-item">
                                <a href="<c:url value='/manager/create-task'/>"
                                    class="nav-link ${pageContext.request.servletPath.endsWith('CreateTask.jsp') ? 'active' : ''}">
                                    <i class="bi bi-plus-square"></i>
                                    <span>Assign Task</span>
                                </a>
                            </li>
                            <li class="nav-item">
                                <a href="<c:url value='/manager/issues'/>"
                                    class="nav-link ${pageContext.request.servletPath.endsWith('IssueList.jsp') ? 'active' : ''}">
                                    <i class="bi bi-exclamation-triangle"></i>
                                    <span>Issues</span>
                                </a>
                            </li>
                        </c:when>

                        <%-- Housekeeping Role (ID: 3) --%>
                            <c:otherwise>
                                <li class="nav-item">
                                    <a href="<c:url value='/housekeeping/dashboard'/>"
                                        class="nav-link ${pageContext.request.servletPath.endsWith('Dashboard.jsp') ? 'active' : ''}">
                                        <i class="bi bi-grid-1x2-fill"></i>
                                        <span>Dashboard</span>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a href="<c:url value='/housekeeping/tasks'/>"
                                        class="nav-link ${pageContext.request.servletPath.endsWith('TaskList.jsp') ? 'active' : ''}">
                                        <i class="bi bi-list-check"></i>
                                        <span>My Tasks</span>
                                    </a>
                                </li>
                               
                                <li class="nav-item">
                                    <a href="<c:url value='/housekeeping/issue-report'/>"
                                        class="nav-link ${pageContext.request.servletPath.endsWith('IssueReport.jsp') ? 'active' : ''}">
                                        <i class="bi bi-exclamation-triangle"></i>
                                        <span>Report Issue</span>
                                    </a>
                                </li>
                            </c:otherwise>
                </c:choose>
            </ul>

            <div class="sidebar-footer">
                <a href="<c:url value='/logout'/>" class="nav-link text-danger">
                    <i class="bi bi-box-arrow-right"></i>
                    <span>Logout</span>
                </a>
            </div>
        </aside>