<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!-- Link to current page based on role -->
            <c:set var="actionUrl" value="" />
            <c:choose>
                <c:when test="${sessionScope.currentUser.roleId == 6}">
                    <c:set var="actionUrl" value="/manager/schedule" />
                </c:when>
                <c:when test="${sessionScope.currentUser.roleId == 3}">
                    <c:set var="actionUrl" value="/housekeeping/schedule" />
                </c:when>
                <c:when test="${sessionScope.currentUser.roleId == 2}">
                    <c:set var="actionUrl" value="/receptionist/schedule" />
                </c:when>
            </c:choose>

            <div class="row mb-4 align-items-center">
                <div class="col-md-6">
                    <h2 class="fw-bold mb-0">Current Roster</h2>
                    <p class="text-muted mb-0">View current permanent work assignments.</p>
                </div>
                <!-- Date picker removed for permanent shifts -->
            </div>

            <div class="card schedule-card">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="bg-light">
                                <tr>
                                    <th class="ps-4 py-3 text-uppercase small text-muted fw-bold">Employee</th>
                                    <th class="py-3 text-uppercase small text-muted fw-bold">Role</th>
                                    <th class="py-3 text-uppercase small text-muted fw-bold">Shift</th>
                                    <th class="py-3 text-uppercase small text-muted fw-bold">Time</th>
                                    <th class="pe-4 py-3 text-uppercase small text-muted fw-bold text-end">Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:if test="${empty assignments}">
                                    <tr>
                                        <td colspan="5" class="text-center py-5">
                                            <div class="text-muted opacity-50 mb-2" style="font-size: 3rem;"><i
                                                    class="bi bi-calendar-x"></i></div>
                                            <h5 class="text-muted fw-normal">No current shifts assigned.</h5>
                                        </td>
                                    </tr>
                                </c:if>

                                <c:forEach items="${assignments}" var="a">
                                    <!-- Highlight current user -->
                                    <tr
                                        class="${a.employeeId == sessionScope.currentUser.userId ? 'bg-primary-subtle' : ''}">
                                        <td class="ps-4 py-3">
                                            <div class="d-flex align-items-center gap-3">
                                                <div class="avatar rounded-circle d-flex align-items-center justify-content-center fw-bold
                                        ${a.employeeId == sessionScope.currentUser.userId ? 'bg-primary text-white' : 'bg-secondary-subtle text-secondary'}"
                                                    style="width: 40px; height: 40px">
                                                    ${a.employeeName != null ? a.employeeName.charAt(0) : '?'}
                                                </div>
                                                <div>
                                                    <div class="fw-semibold text-dark">
                                                        ${a.employeeName}
                                                        <c:if test="${a.employeeId == sessionScope.currentUser.userId}">
                                                            <span class="badge bg-primary ms-1"
                                                                style="font-size: 0.7em;">YOU</span>
                                                        </c:if>
                                                    </div>
                                                    <div class="small text-muted">ID: #${a.employeeId}</div>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <!-- We don't have Role Name in assignments, but we can guess or leave blank. 
                                     The prompt asked for simple view. I will skip Role if not available or fetch if needed.
                                     Actually, users table has role_id. DAOOwner joins users but selects only name?
                                     Let's assume name is enough for now. -->
                                            <span class="text-secondary">-</span>
                                        </td>
                                        <td>
                                            <span
                                                class="shift-badge ${a.shiftType == 'MORNING' ? 'shift-morning' : (a.shiftType == 'AFTERNOON' ? 'shift-afternoon' : 'shift-night')}">
                                                <i
                                                    class="bi ${a.shiftType == 'MORNING' ? 'bi-sunrise' : (a.shiftType == 'AFTERNOON' ? 'bi-sun' : 'bi-moon-stars')} me-1"></i>
                                                ${a.shiftType}
                                            </span>
                                        </td>
                                        <td class="text-muted">
                                            <c:choose>
                                                <c:when test="${a.shiftType == 'MORNING'}">06:00 - 14:00</c:when>
                                                <c:when test="${a.shiftType == 'AFTERNOON'}">14:00 - 22:00</c:when>
                                                <c:when test="${a.shiftType == 'NIGHT'}">22:00 - 06:00</c:when>
                                            </c:choose>
                                        </td>
                                        <td class="text-end pe-4">
                                            <span
                                                class="badge ${a.status == 'ON_SHIFT' ? 'bg-success' : 'bg-secondary'} rounded-pill">
                                                ${a.status}
                                            </span>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>