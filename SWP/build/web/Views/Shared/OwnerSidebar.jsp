<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <aside class="sidebar">
            <div class="sidebar-brand">
                <i class="bi bi-person-workspace"></i>
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

                <li class="nav-header">Staff Management</li>

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
                        <i class="bi bi-calendar-week"></i>
                        <span>Assignments</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<c:url value='/owner/staff-status'/>"
                        class="nav-link ${pageContext.request.servletPath.endsWith('StaffStatus.jsp') ? 'active' : ''}">
                        <i class="bi bi-person-check"></i>
                        <span>Staff Status</span>
                    </a>
                </li>

                <li class="nav-header">Hotel Management</li>

                <li class="nav-item">
                    <a href="<c:url value='/owner/rooms'/>"
                        class="nav-link ${pageContext.request.servletPath.endsWith('RoomManagement.jsp') ? 'active' : ''}">
                        <i class="bi bi-door-open-fill"></i>
                        <span>Rooms</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<c:url value='/owner/bookings'/>"
                        class="nav-link ${pageContext.request.servletPath.endsWith('BookingList.jsp') ? 'active' : ''}">
                        <i class="bi bi-bookmark-check-fill"></i>
                        <span>Bookings</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<c:url value='/owner/reports'/>"
                        class="nav-link ${pageContext.request.servletPath.endsWith('Reports.jsp') ? 'active' : ''}">
                        <i class="bi bi-graph-up"></i>
                        <span>Reports</span>
                    </a>
                </li>
            </ul>

            <div class="sidebar-footer">
                <a href="javascript:void(0)" onclick="confirmLogout()" class="nav-link text-danger">
                    <i class="bi bi-box-arrow-right"></i>
                    <span>Logout</span>
                </a>
            </div>
        </aside>

        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script>
            function confirmLogout() {
                Swal.fire({
                    title: 'Confirm Logout',
                    text: 'Are you sure you want to logout?',
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#dc3545',
                    cancelButtonColor: '#6c757d',
                    confirmButtonText: 'Yes, Logout',
                    cancelButtonText: 'Cancel'
                }).then((result) => {
                    if (result.isConfirmed) {
                        window.location.href = '<c:url value="/logout"/>';
                    }
                });
            }
        </script>