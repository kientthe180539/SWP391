<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>Create Task | HMS Manager</title>
            <!-- Fonts -->
            <link rel="preconnect" href="https://fonts.googleapis.com">
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
            <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap"
                rel="stylesheet">

            <!-- Icons & Bootstrap -->
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
            <link rel="stylesheet" href="<c:url value='/CSS/housekeeping.css'/>">

            <style>
                :root {
                    --primary-dark: #0f172a;
                    --primary-light: #1e293b;
                    --accent-gold: #d4af37;
                    --accent-gold-hover: #bfa130;
                    --text-main: #334155;
                    --text-muted: #64748b;
                    --surface-light: #f8fafc;
                }

                body {
                    font-family: 'Outfit', sans-serif;
                    background-color: #f1f5f9;
                }

                /* Card Styling */
                .card-premium {
                    border: none;
                    border-radius: 20px;
                    box-shadow: 0 20px 40px rgba(15, 23, 42, 0.08);
                    overflow: hidden;
                    background: white;
                    transition: transform 0.3s ease;
                }

                .card-header-premium {
                    background: linear-gradient(135deg, var(--primary-dark) 0%, var(--primary-light) 100%);
                    padding: 2rem 2.5rem;
                    position: relative;
                    overflow: hidden;
                }

                /* Decorative circle in header */
                .card-header-premium::after {
                    content: '';
                    position: absolute;
                    top: -50%;
                    right: -10%;
                    width: 200px;
                    height: 200px;
                    background: radial-gradient(circle, rgba(212, 175, 55, 0.1) 0%, transparent 70%);
                    border-radius: 50%;
                    pointer-events: none;
                }

                .header-title {
                    font-weight: 600;
                    letter-spacing: 0.5px;
                    color: white;
                    font-size: 1.35rem;
                }

                /* Form Controls */
                .form-label-premium {
                    font-size: 0.75rem;
                    font-weight: 600;
                    text-transform: uppercase;
                    letter-spacing: 0.05em;
                    color: var(--text-muted);
                    margin-bottom: 0.5rem;
                }

                .input-group-premium {
                    border: 1px solid #e2e8f0;
                    border-radius: 12px;
                    overflow: hidden;
                    transition: all 0.3s ease;
                    background-color: var(--surface-light);
                }

                .input-group-premium:focus-within {
                    border-color: var(--accent-gold);
                    box-shadow: 0 0 0 3px rgba(212, 175, 55, 0.1);
                    background-color: white;
                    transform: translateY(-1px);
                }

                .input-group-text {
                    background-color: transparent;
                    border: none;
                    color: var(--primary-dark);
                    padding-left: 1.25rem;
                }

                .form-control,
                .form-select {
                    border: none;
                    background-color: transparent;
                    padding: 0.8rem 1rem;
                    color: var(--text-main);
                    font-weight: 500;
                }

                .form-control::placeholder {
                    color: #94a3b8;
                    font-weight: 400;
                }

                .form-control:focus,
                .form-select:focus {
                    box-shadow: none;
                    background-color: transparent;
                }

                /* Segmented Control Toggle */
                .toggle-container {
                    background-color: var(--surface-light);
                    border-radius: 50rem;
                    padding: 0.35rem;
                    display: inline-flex;
                    width: 100%;
                    border: 1px solid #e2e8f0;
                }

                .btn-toggle {
                    flex: 1;
                    border: none;
                    background: transparent;
                    color: var(--text-muted);
                    font-weight: 500;
                    padding: 0.6rem 1rem;
                    border-radius: 50rem;
                    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                    position: relative;
                    z-index: 1;
                }

                .btn-check:checked+.btn-toggle {
                    background-color: white;
                    color: var(--primary-dark);
                    font-weight: 600;
                    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -1px rgba(0, 0, 0, 0.03);
                    transform: scale(1.02);
                }

                .btn-check:not(:checked)+.btn-toggle:hover {
                    color: var(--primary-dark);
                    background-color: rgba(0, 0, 0, 0.02);
                }

                /* Primary Button */
                .btn-premium {
                    background: linear-gradient(135deg, var(--primary-dark) 0%, #2c3e50 100%);
                    color: white;
                    border: none;
                    padding: 1rem;
                    border-radius: 12px;
                    font-weight: 600;
                    letter-spacing: 0.5px;
                    transition: all 0.3s ease;
                    position: relative;
                    overflow: hidden;
                }

                .btn-premium:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 10px 20px -5px rgba(15, 23, 42, 0.2);
                    color: white;
                }

                .btn-premium::after {
                    content: '';
                    position: absolute;
                    top: 0;
                    left: 0;
                    width: 100%;
                    height: 100%;
                    background: linear-gradient(rgba(255, 255, 255, 0.1), transparent);
                    opacity: 0;
                    transition: opacity 0.3s;
                }

                .btn-premium:hover::after {
                    opacity: 1;
                }

                /* Animations */
                .animate-fade-up {
                    animation: fadeUp 0.5s cubic-bezier(0.16, 1, 0.3, 1);
                }

                @keyframes fadeUp {
                    from {
                        opacity: 0;
                        transform: translateY(10px);
                    }

                    to {
                        opacity: 1;
                        transform: translateY(0);
                    }
                }
            </style>
        </head>

        <body>
            <div class="layout-wrapper">
                <jsp:include page="../Shared/Sidebar.jsp" />
                <div class="main-content">
                    <jsp:include page="../Shared/Header.jsp" />

                    <div class="container-fluid p-4 p-lg-5">
                        <div class="row justify-content-center">
                            <div class="col-lg-7 col-xl-6">
                                <div class="card-premium animate-fade-up">
                                    <!-- Header -->
                                    <div class="card-header-premium d-flex align-items-center justify-content-center">
                                        <h5 class="header-title mb-0">
                                            <i class="bi bi-pencil-square me-2" style="color: var(--accent-gold);"></i>
                                            Create New Task
                                        </h5>
                                    </div>

                                    <div class="card-body p-4 p-md-5">
                                        <jsp:include page="../public/notify.jsp" />

                                        <!-- Task Type Toggle -->
                                        <div class="mb-5 px-md-4">
                                            <div class="toggle-container shadow-sm">
                                                <input type="radio" class="btn-check" name="taskCategory"
                                                    id="cat-housekeeping" autocomplete="off" checked
                                                    onchange="toggleTaskForm()">
                                                <label
                                                    class="btn btn-toggle d-flex align-items-center justify-content-center gap-2"
                                                    for="cat-housekeeping">
                                                    <i class="bi bi-bucket"></i> Housekeeping
                                                </label>

                                                <input type="radio" class="btn-check" name="taskCategory"
                                                    id="cat-inspection" autocomplete="off" onchange="toggleTaskForm()">
                                                <label
                                                    class="btn btn-toggle d-flex align-items-center justify-content-center gap-2"
                                                    for="cat-inspection">
                                                    <i class="bi bi-clipboard-check"></i> Inspection
                                                </label>
                                            </div>
                                        </div>

                                        <div class="position-relative px-md-2">
                                            <!-- Housekeeping Form -->
                                            <div id="form-housekeeping" class="animate-fade-up">
                                                <form action="create-task" method="post">
                                                    <div class="row g-4">
                                                        <div class="col-md-6">
                                                            <label class="form-label-premium">Target Room</label>
                                                            <div class="input-group-premium d-flex align-items-center">
                                                                <span class="input-group-text"><i
                                                                        class="bi bi-door-open"></i></span>
                                                                <select name="roomId" class="form-select" required>
                                                                    <option value="" disabled selected>Select Room...
                                                                    </option>
                                                                    <c:forEach items="${rooms}" var="r">
                                                                        <option value="${r.roomId}">Room ${r.roomNumber}
                                                                            (${r.status})</option>
                                                                    </c:forEach>
                                                                </select>
                                                            </div>
                                                        </div>

                                                        <div class="col-md-6">
                                                            <label class="form-label-premium">Assign Staff</label>
                                                            <div class="input-group-premium d-flex align-items-center">
                                                                <span class="input-group-text"><i
                                                                        class="bi bi-person"></i></span>
                                                                <select name="assignedTo" class="form-select" required>
                                                                    <option value="" disabled selected>Select Staff...
                                                                    </option>
                                                                    <c:forEach items="${staffList}" var="s">
                                                                        <option value="${s.userId}">${s.fullName}
                                                                        </option>
                                                                    </c:forEach>
                                                                </select>
                                                            </div>
                                                        </div>

                                                        <div class="col-12">
                                                            <label class="form-label-premium">Scheduled Date</label>
                                                            <div class="input-group-premium d-flex align-items-center">
                                                                <span class="input-group-text"><i
                                                                        class="bi bi-calendar-event"></i></span>
                                                                <input type="date" name="taskDate" class="form-control"
                                                                    required>
                                                            </div>
                                                        </div>

                                                        <input type="hidden" name="taskType" value="CLEANING">

                                                        <div class="col-12">
                                                            <label class="form-label-premium">Task Note</label>
                                                            <div class="input-group-premium">
                                                                <textarea name="note" class="form-control" rows="3"
                                                                    placeholder="Add specific cleaning instructions..."></textarea>
                                                            </div>
                                                        </div>

                                                        <div class="col-12 mt-5">
                                                            <button type="submit"
                                                                class="btn btn-premium w-100 shadow-sm">
                                                                <i class="bi bi-plus-lg me-2"></i>Create Housekeeping
                                                                Task
                                                            </button>
                                                        </div>
                                                    </div>
                                                </form>
                                            </div>

                                            <!-- Inspection Form -->
                                            <div id="form-inspection" class="animate-fade-up" style="display: none;">
                                                <form method="POST"
                                                    action="<c:url value='/manager/create-inspection'/>">
                                                    <div class="row g-4">
                                                        <div class="col-md-6">
                                                            <label class="form-label-premium">Target Room</label>
                                                            <div class="input-group-premium d-flex align-items-center">
                                                                <span class="input-group-text"><i
                                                                        class="bi bi-door-open"></i></span>
                                                                <select name="roomId" class="form-select" required>
                                                                    <option value="" disabled selected>Select Room...
                                                                    </option>
                                                                    <c:forEach items="${rooms}" var="room">
                                                                        <option value="${room.roomId}">Room
                                                                            ${room.roomNumber} - ${room.status}</option>
                                                                    </c:forEach>
                                                                </select>
                                                            </div>
                                                        </div>

                                                        <div class="col-md-6">
                                                            <label class="form-label-premium">Inspection Type</label>
                                                            <div class="input-group-premium d-flex align-items-center">
                                                                <span class="input-group-text"><i
                                                                        class="bi bi-list-check"></i></span>
                                                                <select name="inspectionType" class="form-select"
                                                                    required>
                                                                    <option value="" disabled selected>Select Type...
                                                                    </option>
                                                                    <option value="CHECKIN">Pre-Check-in Inspection
                                                                    </option>
                                                                    <option value="CHECKOUT">Post-Checkout Inspection
                                                                    </option>
                                                                    <option value="ROUTINE">Routine Inspection</option>
                                                                </select>
                                                            </div>
                                                        </div>

                                                        <div class="col-md-6">
                                                            <label class="form-label-premium">Assign Inspector</label>
                                                            <div class="input-group-premium d-flex align-items-center">
                                                                <span class="input-group-text"><i
                                                                        class="bi bi-person-badge"></i></span>
                                                                <select name="assignedTo" class="form-select" required>
                                                                    <option value="" disabled selected>Select
                                                                        Inspector...</option>
                                                                    <c:forEach items="${staffList}" var="staff">
                                                                        <option value="${staff.userId}">
                                                                            ${staff.fullName}</option>
                                                                    </c:forEach>
                                                                </select>
                                                            </div>
                                                        </div>

                                                        <!-- Related Booking (Restored) -->
                                                        <div class="col-md-6">
                                                            <label class="form-label-premium">Scheduled Date</label>
                                                            <div class="input-group-premium d-flex align-items-center">
                                                                <span class="input-group-text"><i
                                                                        class="bi bi-calendar-check"></i></span>
                                                                <input type="date" name="taskDate" class="form-control"
                                                                    required>
                                                            </div>
                                                        </div>

                                                        <div class="col-12">
                                                            <label class="form-label-premium">Instructions</label>
                                                            <div class="input-group-premium">
                                                                <textarea name="note" class="form-control" rows="3"
                                                                    placeholder="Enter inspection checklist or special notes..."></textarea>
                                                            </div>
                                                        </div>

                                                        <div class="col-12 mt-5">
                                                            <button type="submit"
                                                                class="btn btn-premium w-100 shadow-sm">
                                                                <i class="bi bi-check2-square me-2"></i>Create
                                                                Inspection Task
                                                            </button>
                                                        </div>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <script>
                        function toggleTaskForm() {
                            const isHousekeeping = document.getElementById('cat-housekeeping').checked;
                            const housekeepingForm = document.getElementById('form-housekeeping');
                            const inspectionForm = document.getElementById('form-inspection');

                            if (isHousekeeping) {
                                housekeepingForm.style.display = 'block';
                                inspectionForm.style.display = 'none';
                                enableFormInputs('form-housekeeping', true);
                                enableFormInputs('form-inspection', false);
                            } else {
                                housekeepingForm.style.display = 'none';
                                inspectionForm.style.display = 'block';
                                enableFormInputs('form-housekeeping', false);
                                enableFormInputs('form-inspection', true);
                            }
                        }

                        function enableFormInputs(containerId, enable) {
                            const container = document.getElementById(containerId);
                            const inputs = container.querySelectorAll('input, select, textarea');
                            inputs.forEach(input => {
                                if (enable) {
                                    input.removeAttribute('disabled');
                                } else {
                                    input.setAttribute('disabled', 'disabled');
                                }
                            });
                        }

                        document.addEventListener("DOMContentLoaded", function () {
                            toggleTaskForm();
                        });
                    </script>

                    <jsp:include page="../Shared/Footer.jsp" />
                </div>
            </div>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>