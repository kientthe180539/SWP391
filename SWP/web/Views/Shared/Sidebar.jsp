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
                                <li class="nav-item">
                                    <a href="<c:url value='/manager/dashboard'/>"
                                        class="nav-link ${pageContext.request.servletPath.endsWith('Dashboard.jsp') ? 'active' : ''}">
                                        <i class="bi bi-speedometer2"></i>
                                        <span>Dashboard</span>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a href="<c:url value='/manager/schedule'/>"
                                        class="nav-link ${pageContext.request.servletPath.endsWith('ViewSchedule.jsp') ? 'active' : ''}">
                                        <i class="bi bi-calendar-week"></i>
                                        <span>Work Schedule</span>
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
                                    <a href="<c:url value='/manager/inspections'/>"
                                        class="nav-link ${pageContext.request.servletPath.endsWith('InspectionList.jsp') ? 'active' : ''}">
                                        <i class="bi bi-clipboard-check"></i>
                                        <span>Inspections</span>
                                    </a>
                                </li>
                                <!--                                <li class="nav-item">
                                    <a href="<c:url value='/manager/replenishment-requests'/>"
                                        class="nav-link ${pageContext.request.servletPath.endsWith('ReplenishmentRequests.jsp') ? 'active' : ''}">
                                        <i class="bi bi-box-seam"></i>
                                        <span>Replenishment</span>
                                    </a>
                                </li>-->
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
                                        <a href="<c:url value='/housekeeping/schedule'/>"
                                            class="nav-link ${pageContext.request.servletPath.endsWith('ViewSchedule.jsp') ? 'active' : ''}">
                                            <i class="bi bi-calendar-week"></i>
                                            <span>My Schedule</span>
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="<c:url value='/housekeeping/tasks'/>"
                                            class="nav-link ${pageContext.request.servletPath.endsWith('TaskList.jsp') ? 'active' : ''}">
                                            <i class="bi bi-list-check"></i>
                                            <span>My Tasks</span>
                                        </a>
                                    </li>

                                    <!--                                    <li class="nav-item">
                                        <a href="<c:url value='/housekeeping/supplies'/>"
                                            class="nav-link ${pageContext.request.servletPath.endsWith('Supplies.jsp') ? 'active' : ''}">
                                            <i class="bi bi-box-seam"></i>
                                            <span>Supplies</span>
                                        </a>
                                    </li>-->
                                    <li class="nav-item">
                                        <a href="<c:url value='/housekeeping/history'/>"
                                            class="nav-link ${pageContext.request.servletPath.endsWith('TaskHistory.jsp') ? 'active' : ''}">
                                            <i class="bi bi-clock-history"></i>
                                            <span>Task History</span>
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="<c:url value='/housekeeping/my-issues'/>"
                                            class="nav-link ${pageContext.request.servletPath.endsWith('MyIssueList.jsp') || pageContext.request.servletPath.endsWith('IssueReport.jsp') ? 'active' : ''}">
                                            <i class="bi bi-exclamation-triangle"></i>
                                            <span>My Issues</span>
                                        </a>
                                    </li>
                                </c:when>

                                <%-- Receptionist Role (ID: 2) --%>
                                    <c:when test="${sessionScope.currentUser.roleId == 2}">
                                        <li class="nav-item">
                                            <a href="<c:url value='/receptionist/dashboard'/>"
                                                class="nav-link ${pageContext.request.servletPath.endsWith('Dashboard.jsp') ? 'active' : ''}">
                                                <i class="bi bi-speedometer2"></i>
                                                <span>Dashboard</span>
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="<c:url value='/receptionist/reservations'/>"
                                                class="nav-link ${pageContext.request.servletPath.endsWith('ReservationList.jsp') ? 'active' : ''}">
                                                <i class="bi bi-calendar-check"></i>
                                                <span>Reservations</span>
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="<c:url value='/receptionist/checkinout'/>"
                                                class="nav-link ${pageContext.request.servletPath.endsWith('CheckInOut.jsp') ? 'active' : ''}">
                                                <i class="bi bi-key"></i>
                                                <span>Check-in/out</span>
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="<c:url value='/receptionist/room-status'/>"
                                                class="nav-link ${pageContext.request.servletPath.endsWith('RoomStatus.jsp') ? 'active' : ''}">
                                                <i class="bi bi-door-open"></i>
                                                <span>Rooms</span>
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="<c:url value='/receptionist/direct-booking'/>"
                                                class="nav-link ${pageContext.request.servletPath.endsWith('DirectBooking.jsp') ? 'active' : ''}">
                                                <i class="bi bi-plus-circle"></i>
                                                <span>Direct Booking</span>
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="<c:url value='/receptionist/availability'/>"
                                                class="nav-link ${pageContext.request.servletPath.endsWith('AvailabilityCalendar.jsp') ? 'active' : ''}">
                                                <i class="bi bi-calendar2-check"></i>
                                                <span>Availability</span>
                                            </a>
                                        </li>
                                        <li class="nav-header">Personal</li>

                                        <li class="nav-item">
                                            <a href="<c:url value='/receptionist/schedule'/>"
                                                class="nav-link ${pageContext.request.servletPath.endsWith('Schedule.jsp') ? 'active' : ''}">
                                                <i class="bi bi-calendar-week"></i>
                                                <span>My Shift</span>
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="<c:url value='/receptionist/profile'/>"
                                                class="nav-link ${pageContext.request.servletPath.endsWith('Profile.jsp') ? 'active' : ''}">
                                                <i class="bi bi-person"></i>
                                                <span>Profile</span>
                                            </a>
                                        </li>
                                    </c:when>
                </c:choose>
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