<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Job Assignment | HMS Owner</title>
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                rel="stylesheet">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
            <link rel="stylesheet" href="<c:url value='/CSS/housekeeping.css'/>">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
        </head>

        <body>

            <div class="layout-wrapper">
                <jsp:include page="../Shared/OwnerSidebar.jsp" />

                <div class="main-content">
                    <jsp:include page="../Shared/Header.jsp" />

                    <div class="container-fluid py-4 px-4">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h2 class="mb-0">Manage Staff Shifts</h2>
                            <!-- Date picker removed for permanent shifts -->
                        </div>

                        <div class="row">
                            <div class="col-md-4">
                                <div class="card shadow-sm mb-4">
                                    <div class="card-header bg-white">
                                        <h5 class="mb-0">Assign Shift</h5>
                                    </div>
                                    <div class="card-body">
                                        <form action="<c:url value='/owner/assignments'/>" method="post">
                                            <input type="hidden" name="action" value="createAssignment">
                                            <!-- Date hidden input removed -->

                                            <div class="mb-3">
                                                <label class="form-label">Filter by Role</label>
                                                <select id="roleFilter" class="form-select"
                                                    onchange="filterEmployees()">
                                                    <option value="">All Roles</option>
                                                    <option value="6">Manager</option>
                                                    <option value="2">Reception</option>
                                                    <option value="3">Housekeeping</option>
                                                </select>
                                            </div>

                                            <div class="mb-3">
                                                <label class="form-label">Employee</label>
                                                <select name="employeeId" id="employeeSelect" class="form-select"
                                                    required>
                                                    <option value="">Select Employee</option>
                                                    <c:forEach items="${employees}" var="e">
                                                        <option value="${e.userId}" data-role-id="${e.roleId}">
                                                            ${e.fullName} (${e.roleId == 6 ? 'Manager' : (e.roleId == 2
                                                            ? 'Reception' : (e.roleId == 3 ? 'Housekeeping' :
                                                            'Staff'))})
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>

                                            <div class="mb-3">
                                                <label class="form-label">Shift</label>
                                                <select name="shift" class="form-select" required>
                                                    <option value="MORNING">Morning (6:00 - 14:00)</option>
                                                    <option value="AFTERNOON">Afternoon (14:00 - 22:00)</option>
                                                    <option value="NIGHT">Night (22:00 - 6:00)</option>
                                                </select>
                                            </div>

                                            <button type="submit" class="btn btn-primary w-100">Assign</button>
                                        </form>
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-8">
                                <div class="card shadow-sm">
                                    <div class="card-header bg-white">
                                        <h5 class="mb-0">current Staff Roster</h5>
                                    </div>
                                    <div class="card-body p-0">
                                        <div class="table-responsive">
                                            <table class="table table-hover align-middle mb-0">
                                                <thead class="bg-light">
                                                    <tr>
                                                        <th class="ps-4">Employee ID</th>
                                                        <th>Shift</th>
                                                        <th>Status</th>
                                                        <th class="text-end pe-4">Action</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:if test="${empty assignments}">
                                                        <tr>
                                                            <td colspan="4" class="text-center py-4 text-muted">No
                                                                active shifts assigned.</td>
                                                        </tr>
                                                    </c:if>
                                                    <c:forEach items="${assignments}" var="a">
                                                        <tr>
                                                            <td class="ps-4">#${a.employeeId}</td>
                                                            <td>
                                                                <span
                                                                    class="badge ${a.shiftType == 'MORNING' ? 'bg-info' : (a.shiftType == 'AFTERNOON' ? 'bg-warning' : 'bg-dark')}">
                                                                    ${a.shiftType}
                                                                </span>
                                                            </td>
                                                            <td>
                                                                <span class="badge bg-success">${a.status}</span>
                                                            </td>
                                                            <td class="text-end pe-4">
                                                                <form action="<c:url value='/owner/assignments'/>"
                                                                    method="post" class="d-inline">
                                                                    <input type="hidden" name="action"
                                                                        value="deleteAssignment">
                                                                    <input type="hidden" name="id"
                                                                        value="${a.assignmentId}">
                                                                    <input type="hidden" name="date" value="${date}">
                                                                    <button type="submit"
                                                                        class="btn btn-sm btn-outline-danger"
                                                                        onclick="return confirm('Remove this assignment?')">
                                                                        <i class="bi bi-trash"></i>
                                                                    </button>
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
                        </div>
                    </div>

                    <jsp:include page="../Shared/Footer.jsp" />
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
            <script>
                function filterEmployees() {
                    var roleId = document.getElementById("roleFilter").value;
                    var employeeSelect = document.getElementById("employeeSelect");
                    var options = employeeSelect.options;

                    // Show/Hide options
                    for (var i = 1; i < options.length; i++) { // Start at 1 to skip "Select Employee"
                        var opt = options[i];
                        var optRole = opt.getAttribute("data-role-id");

                        if (roleId === "" || optRole === roleId) {
                            opt.style.display = "block";
                        } else {
                            opt.style.display = "none";
                        }
                    }

                    // Reset selection if current selected is hidden
                    var selectedOpt = options[employeeSelect.selectedIndex];
                    if (selectedOpt.style.display === "none") {
                        employeeSelect.value = "";
                    }
                }
            </script>
        </body>

        </html>