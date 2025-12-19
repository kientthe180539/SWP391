<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Reports & Analytics | HMS Manager</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
                rel="stylesheet">
            <link rel="stylesheet" href="<c:url value='/CSS/housekeeping.css'/>">
            <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
            <style>
                /* Page Header */
                .page-header {
                    background: linear-gradient(135deg, #1e3a5f 0%, #0d1b2a 100%);
                    border-radius: 20px;
                    padding: 2.5rem;
                    color: white;
                    margin-bottom: 2rem;
                    position: relative;
                    overflow: hidden;
                }

                .page-header::before {
                    content: '';
                    position: absolute;
                    top: -100px;
                    right: -100px;
                    width: 300px;
                    height: 300px;
                    background: radial-gradient(circle, rgba(212, 175, 55, 0.2) 0%, transparent 70%);
                    border-radius: 50%;
                }

                .page-header::after {
                    content: '';
                    position: absolute;
                    bottom: -50px;
                    left: 30%;
                    width: 200px;
                    height: 200px;
                    background: radial-gradient(circle, rgba(59, 130, 246, 0.15) 0%, transparent 70%);
                    border-radius: 50%;
                }

                .page-header h1 {
                    color: white;
                    font-weight: 800;
                    font-size: 2rem;
                    margin: 0;
                    position: relative;
                    z-index: 1;
                }

                .page-header .subtitle {
                    color: rgba(255, 255, 255, 0.7);
                    font-size: 1rem;
                    margin-top: 0.5rem;
                }

                .header-actions {
                    position: relative;
                    z-index: 1;
                }

                .btn-print {
                    background: rgba(255, 255, 255, 0.15);
                    border: 1px solid rgba(255, 255, 255, 0.3);
                    color: white;
                    padding: 0.6rem 1.25rem;
                    border-radius: 10px;
                    font-weight: 500;
                    transition: all 0.3s ease;
                    backdrop-filter: blur(10px);
                }

                .btn-print:hover {
                    background: rgba(255, 255, 255, 0.25);
                    color: white;
                    transform: translateY(-2px);
                }

                .btn-export {
                    background: linear-gradient(135deg, #d4af37 0%, #b8960c 100%);
                    border: none;
                    color: #0d1b2a;
                    padding: 0.6rem 1.25rem;
                    border-radius: 10px;
                    font-weight: 600;
                    transition: all 0.3s ease;
                }

                .btn-export:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 8px 20px rgba(212, 175, 55, 0.4);
                    color: #0d1b2a;
                }

                /* KPI Cards */
                .kpi-card {
                    background: white;
                    border-radius: 16px;
                    padding: 1.5rem;
                    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
                    transition: all 0.3s ease;
                    position: relative;
                    overflow: hidden;
                }

                .kpi-card:hover {
                    transform: translateY(-5px);
                    box-shadow: 0 12px 30px rgba(0, 0, 0, 0.12);
                }

                .kpi-card::before {
                    content: '';
                    position: absolute;
                    top: 0;
                    left: 0;
                    right: 0;
                    height: 4px;
                }

                .kpi-card.primary::before {
                    background: linear-gradient(90deg, #667eea, #764ba2);
                }

                .kpi-card.success::before {
                    background: linear-gradient(90deg, #10b981, #059669);
                }

                .kpi-card.warning::before {
                    background: linear-gradient(90deg, #f59e0b, #d97706);
                }

                .kpi-card.danger::before {
                    background: linear-gradient(90deg, #ef4444, #dc2626);
                }

                .kpi-card.info::before {
                    background: linear-gradient(90deg, #3b82f6, #2563eb);
                }

                .kpi-card.gold::before {
                    background: linear-gradient(90deg, #d4af37, #b8960c);
                }

                .kpi-icon {
                    width: 56px;
                    height: 56px;
                    border-radius: 14px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-size: 1.5rem;
                    margin-bottom: 1rem;
                }

                .kpi-icon.primary {
                    background: linear-gradient(135deg, #667eea20, #764ba220);
                    color: #667eea;
                }

                .kpi-icon.success {
                    background: linear-gradient(135deg, #10b98120, #05966920);
                    color: #10b981;
                }

                .kpi-icon.warning {
                    background: linear-gradient(135deg, #f59e0b20, #d9770620);
                    color: #f59e0b;
                }

                .kpi-icon.danger {
                    background: linear-gradient(135deg, #ef444420, #dc262620);
                    color: #ef4444;
                }

                .kpi-icon.info {
                    background: linear-gradient(135deg, #3b82f620, #2563eb20);
                    color: #3b82f6;
                }

                .kpi-icon.gold {
                    background: linear-gradient(135deg, #d4af3720, #b8960c20);
                    color: #d4af37;
                }

                .kpi-value {
                    font-size: 2.25rem;
                    font-weight: 800;
                    color: #1e293b;
                    line-height: 1;
                    margin-bottom: 0.25rem;
                }

                .kpi-label {
                    font-size: 0.9rem;
                    color: #64748b;
                    font-weight: 500;
                }

                .kpi-trend {
                    display: inline-flex;
                    align-items: center;
                    gap: 0.25rem;
                    font-size: 0.8rem;
                    font-weight: 600;
                    padding: 0.25rem 0.5rem;
                    border-radius: 6px;
                    margin-top: 0.5rem;
                }

                .kpi-trend.up {
                    background: #dcfce7;
                    color: #16a34a;
                }

                .kpi-trend.down {
                    background: #fee2e2;
                    color: #dc2626;
                }

                /* Chart Cards */
                .chart-card {
                    background: white;
                    border-radius: 20px;
                    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
                    overflow: hidden;
                }

                .chart-card-header {
                    padding: 1.5rem;
                    border-bottom: 1px solid #f1f5f9;
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                }

                .chart-card-title {
                    font-weight: 700;
                    font-size: 1.1rem;
                    color: #1e293b;
                    margin: 0;
                    display: flex;
                    align-items: center;
                    gap: 0.75rem;
                }

                .chart-card-title i {
                    color: #667eea;
                }

                .chart-card-body {
                    padding: 1.5rem;
                }

                .chart-container {
                    position: relative;
                    height: 280px;
                }

                /* Progress Bars */
                .progress-item {
                    margin-bottom: 1.25rem;
                }

                .progress-item:last-child {
                    margin-bottom: 0;
                }

                .progress-header {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    margin-bottom: 0.5rem;
                }

                .progress-label {
                    font-weight: 600;
                    color: #374151;
                    font-size: 0.9rem;
                }

                .progress-value {
                    font-weight: 700;
                    color: #1e293b;
                    font-size: 0.9rem;
                }

                .progress {
                    height: 10px;
                    border-radius: 5px;
                    background: #f1f5f9;
                    overflow: hidden;
                }

                .progress-bar {
                    border-radius: 5px;
                    transition: width 1s ease;
                }

                .progress-bar.gradient-primary {
                    background: linear-gradient(90deg, #667eea, #764ba2);
                }

                .progress-bar.gradient-success {
                    background: linear-gradient(90deg, #10b981, #059669);
                }

                .progress-bar.gradient-warning {
                    background: linear-gradient(90deg, #f59e0b, #d97706);
                }

                .progress-bar.gradient-danger {
                    background: linear-gradient(90deg, #ef4444, #dc2626);
                }

                /* Summary Stats */
                .summary-stat {
                    text-align: center;
                    padding: 1rem;
                }

                .summary-stat-value {
                    font-size: 1.75rem;
                    font-weight: 800;
                    color: #1e293b;
                }

                .summary-stat-label {
                    font-size: 0.85rem;
                    color: #64748b;
                    font-weight: 500;
                }

                /* Section Header */
                .section-header {
                    margin-bottom: 1.5rem;
                }

                .section-title {
                    font-size: 1.25rem;
                    font-weight: 700;
                    color: #1e293b;
                    margin: 0;
                }

                .section-subtitle {
                    font-size: 0.9rem;
                    color: #64748b;
                    margin-top: 0.25rem;
                }

                /* Animations */
                @keyframes fadeInUp {
                    from {
                        opacity: 0;
                        transform: translateY(30px);
                    }

                    to {
                        opacity: 1;
                        transform: translateY(0);
                    }
                }

                .animate-in {
                    animation: fadeInUp 0.6s ease forwards;
                }

                .delay-1 {
                    animation-delay: 0.1s;
                    opacity: 0;
                }

                .delay-2 {
                    animation-delay: 0.2s;
                    opacity: 0;
                }

                .delay-3 {
                    animation-delay: 0.3s;
                    opacity: 0;
                }

                .delay-4 {
                    animation-delay: 0.4s;
                    opacity: 0;
                }

                .delay-5 {
                    animation-delay: 0.5s;
                    opacity: 0;
                }

                .delay-6 {
                    animation-delay: 0.6s;
                    opacity: 0;
                }

                /* Circular Progress */
                .circular-progress {
                    position: relative;
                    width: 120px;
                    height: 120px;
                    margin: 0 auto;
                }

                .circular-progress svg {
                    transform: rotate(-90deg);
                }

                .circular-progress-value {
                    position: absolute;
                    top: 50%;
                    left: 50%;
                    transform: translate(-50%, -50%);
                    font-size: 1.5rem;
                    font-weight: 800;
                    color: #1e293b;
                }
            </style>
        </head>

        <body>
            <div class="layout-wrapper">
                <jsp:include page="../Shared/Sidebar.jsp" />
                <div class="main-content">
                    <jsp:include page="../Shared/Header.jsp" />

                    <div class="container-fluid p-4">
                        <!-- Page Header -->
                        <div class="page-header animate-in">
                            <div class="d-flex justify-content-between align-items-start">
                                <div>
                                    <h1><i class="bi bi-graph-up-arrow me-3"></i>Reports & Analytics</h1>
                                    <p class="subtitle mb-0">Real-time insights into your housekeeping operations</p>
                                </div>
                                <div class="header-actions d-flex gap-2">
                                    <button class="btn btn-print" onclick="window.print()">
                                        <i class="bi bi-printer me-2"></i>Print
                                    </button>
                                    <button class="btn btn-export">
                                        <i class="bi bi-download me-2"></i>Export
                                    </button>
                                </div>
                            </div>
                        </div>

                        <!-- KPI Cards Row -->
                        <div class="row g-4 mb-4">
                            <div class="col-xl-2 col-lg-4 col-md-6">
                                <div class="kpi-card primary animate-in delay-1">
                                    <div class="kpi-icon primary">
                                        <i class="bi bi-clipboard-check"></i>
                                    </div>
                                    <div class="kpi-value">${totalTasks}</div>
                                    <div class="kpi-label">Total Tasks</div>
                                </div>
                            </div>
                            <div class="col-xl-2 col-lg-4 col-md-6">
                                <div class="kpi-card success animate-in delay-2">
                                    <div class="kpi-icon success">
                                        <i class="bi bi-check-circle"></i>
                                    </div>
                                    <div class="kpi-value">${completedTasks}</div>
                                    <div class="kpi-label">Completed</div>
                                    <div class="kpi-trend up">
                                        <i class="bi bi-arrow-up"></i>${completionRate}%
                                    </div>
                                </div>
                            </div>
                            <div class="col-xl-2 col-lg-4 col-md-6">
                                <div class="kpi-card warning animate-in delay-3">
                                    <div class="kpi-icon warning">
                                        <i class="bi bi-arrow-repeat"></i>
                                    </div>
                                    <div class="kpi-value">${inProgressTasks}</div>
                                    <div class="kpi-label">In Progress</div>
                                </div>
                            </div>
                            <div class="col-xl-2 col-lg-4 col-md-6">
                                <div class="kpi-card info animate-in delay-4">
                                    <div class="kpi-icon info">
                                        <i class="bi bi-door-open"></i>
                                    </div>
                                    <div class="kpi-value">${totalRooms}</div>
                                    <div class="kpi-label">Total Rooms</div>
                                </div>
                            </div>
                            <div class="col-xl-2 col-lg-4 col-md-6">
                                <div class="kpi-card danger animate-in delay-5">
                                    <div class="kpi-icon danger">
                                        <i class="bi bi-exclamation-triangle"></i>
                                    </div>
                                    <div class="kpi-value">${newIssues}</div>
                                    <div class="kpi-label">Open Issues</div>
                                </div>
                            </div>
                            <div class="col-xl-2 col-lg-4 col-md-6">
                                <div class="kpi-card gold animate-in delay-6">
                                    <div class="kpi-icon gold">
                                        <i class="bi bi-people"></i>
                                    </div>
                                    <div class="kpi-value">${totalStaff}</div>
                                    <div class="kpi-label">Staff Members</div>
                                </div>
                            </div>
                        </div>

                        <!-- Charts Row -->
                        <div class="row g-4 mb-4">
                            <!-- Task Status Chart -->
                            <div class="col-lg-4">
                                <div class="chart-card animate-in delay-2 h-100">
                                    <div class="chart-card-header">
                                        <h5 class="chart-card-title">
                                            <i class="bi bi-pie-chart-fill"></i>Task Status
                                        </h5>
                                    </div>
                                    <div class="chart-card-body">
                                        <div class="chart-container">
                                            <canvas id="taskStatusChart"></canvas>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Room Status Chart -->
                            <div class="col-lg-4">
                                <div class="chart-card animate-in delay-3 h-100">
                                    <div class="chart-card-header">
                                        <h5 class="chart-card-title">
                                            <i class="bi bi-bar-chart-fill"></i>Room Status
                                        </h5>
                                    </div>
                                    <div class="chart-card-body">
                                        <div class="chart-container">
                                            <canvas id="roomStatusChart"></canvas>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Task Types Chart -->
                            <div class="col-lg-4">
                                <div class="chart-card animate-in delay-4 h-100">
                                    <div class="chart-card-header">
                                        <h5 class="chart-card-title">
                                            <i class="bi bi-diagram-3-fill"></i>Task Types
                                        </h5>
                                    </div>
                                    <div class="chart-card-body">
                                        <div class="chart-container">
                                            <canvas id="taskTypesChart"></canvas>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Progress & Stats Row -->
                        <div class="row g-4">
                            <!-- Task Completion Progress -->
                            <div class="col-lg-6">
                                <div class="chart-card animate-in delay-3 h-100">
                                    <div class="chart-card-header">
                                        <h5 class="chart-card-title">
                                            <i class="bi bi-speedometer2"></i>Performance Metrics
                                        </h5>
                                    </div>
                                    <div class="chart-card-body">
                                        <!-- Completion Rate -->
                                        <div class="progress-item">
                                            <div class="progress-header">
                                                <span class="progress-label">Task Completion Rate</span>
                                                <span class="progress-value">${completionRate}%</span>
                                            </div>
                                            <div class="progress">
                                                <div class="progress-bar gradient-success"
                                                    style="width: ${completionRate}%"></div>
                                            </div>
                                        </div>

                                        <!-- Occupancy Rate -->
                                        <div class="progress-item">
                                            <div class="progress-header">
                                                <span class="progress-label">Room Occupancy Rate</span>
                                                <span class="progress-value">${occupancyRate}%</span>
                                            </div>
                                            <div class="progress">
                                                <div class="progress-bar gradient-primary"
                                                    style="width: ${occupancyRate}%"></div>
                                            </div>
                                        </div>

                                        <!-- Issue Resolution -->
                                        <c:set var="issueResolutionRate"
                                            value="${totalIssues > 0 ? (resolvedIssues * 100 / totalIssues) : 0}" />
                                        <div class="progress-item">
                                            <div class="progress-header">
                                                <span class="progress-label">Issue Resolution Rate</span>
                                                <span class="progress-value">${issueResolutionRate}%</span>
                                            </div>
                                            <div class="progress">
                                                <div class="progress-bar gradient-warning"
                                                    style="width: ${issueResolutionRate}%"></div>
                                            </div>
                                        </div>

                                        <!-- Room Cleanliness -->
                                        <c:set var="cleanlinessRate"
                                            value="${totalRooms > 0 ? ((totalRooms - dirtyRooms) * 100 / totalRooms) : 0}" />
                                        <div class="progress-item">
                                            <div class="progress-header">
                                                <span class="progress-label">Room Cleanliness</span>
                                                <span class="progress-value">${cleanlinessRate}%</span>
                                            </div>
                                            <div class="progress">
                                                <div class="progress-bar gradient-danger"
                                                    style="width: ${cleanlinessRate}%"></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Quick Stats -->
                            <div class="col-lg-6">
                                <div class="chart-card animate-in delay-4 h-100">
                                    <div class="chart-card-header">
                                        <h5 class="chart-card-title">
                                            <i class="bi bi-lightning-fill"></i>Quick Statistics
                                        </h5>
                                    </div>
                                    <div class="chart-card-body">
                                        <div class="row g-3">
                                            <div class="col-6">
                                                <div class="summary-stat">
                                                    <div class="summary-stat-value text-primary">${cleaningTasks}</div>
                                                    <div class="summary-stat-label">Cleaning Tasks</div>
                                                </div>
                                            </div>
                                            <div class="col-6">
                                                <div class="summary-stat">
                                                    <div class="summary-stat-value text-warning">${inspectionTasks}
                                                    </div>
                                                    <div class="summary-stat-label">Inspection Tasks</div>
                                                </div>
                                            </div>
                                            <div class="col-6">
                                                <div class="summary-stat">
                                                    <div class="summary-stat-value text-success">${availableRooms}</div>
                                                    <div class="summary-stat-label">Available Rooms</div>
                                                </div>
                                            </div>
                                            <div class="col-6">
                                                <div class="summary-stat">
                                                    <div class="summary-stat-value text-danger">${dirtyRooms}</div>
                                                    <div class="summary-stat-label">Dirty Rooms</div>
                                                </div>
                                            </div>
                                            <div class="col-6">
                                                <div class="summary-stat">
                                                    <div class="summary-stat-value text-info">${occupiedRooms}</div>
                                                    <div class="summary-stat-label">Occupied Rooms</div>
                                                </div>
                                            </div>
                                            <div class="col-6">
                                                <div class="summary-stat">
                                                    <div class="summary-stat-value" style="color: #d4af37;">
                                                        ${resolvedIssues}</div>
                                                    <div class="summary-stat-label">Resolved Issues</div>
                                                </div>
                                            </div>
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
                // Task Status Doughnut Chart
                const taskStatusCtx = document.getElementById('taskStatusChart').getContext('2d');
                new Chart(taskStatusCtx, {
                    type: 'doughnut',
                    data: {
                        labels: ['New', 'In Progress', 'Completed'],
                        datasets: [{
                            data: [${ newTasks }, ${ inProgressTasks }, ${ completedTasks }],
                            backgroundColor: [
                                'rgba(245, 158, 11, 0.9)',
                                'rgba(59, 130, 246, 0.9)',
                                'rgba(16, 185, 129, 0.9)'
                            ],
                            borderColor: [
                                'rgba(245, 158, 11, 1)',
                                'rgba(59, 130, 246, 1)',
                                'rgba(16, 185, 129, 1)'
                            ],
                            borderWidth: 2,
                            hoverOffset: 10
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        cutout: '65%',
                        plugins: {
                            legend: {
                                position: 'bottom',
                                labels: {
                                    padding: 20,
                                    usePointStyle: true,
                                    pointStyle: 'circle',
                                    font: { family: 'Inter', size: 12, weight: '500' }
                                }
                            }
                        }
                    }
                });

                // Room Status Bar Chart
                const roomStatusCtx = document.getElementById('roomStatusChart').getContext('2d');
                new Chart(roomStatusCtx, {
                    type: 'bar',
                    data: {
                        labels: ['Available', 'Occupied', 'Dirty', 'Maintenance'],
                        datasets: [{
                            label: 'Rooms',
                            data: [${ availableRooms }, ${ occupiedRooms }, ${ dirtyRooms }, ${ maintenanceRooms }],
                            backgroundColor: [
                                'rgba(16, 185, 129, 0.85)',
                                'rgba(59, 130, 246, 0.85)',
                                'rgba(239, 68, 68, 0.85)',
                                'rgba(245, 158, 11, 0.85)'
                            ],
                            borderColor: [
                                'rgba(16, 185, 129, 1)',
                                'rgba(59, 130, 246, 1)',
                                'rgba(239, 68, 68, 1)',
                                'rgba(245, 158, 11, 1)'
                            ],
                            borderWidth: 2,
                            borderRadius: 8,
                            borderSkipped: false
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: { display: false }
                        },
                        scales: {
                            y: {
                                beginAtZero: true,
                                grid: { color: 'rgba(0,0,0,0.05)' },
                                ticks: { font: { family: 'Inter', weight: '500' } }
                            },
                            x: {
                                grid: { display: false },
                                ticks: { font: { family: 'Inter', weight: '500' } }
                            }
                        }
                    }
                });

                // Task Types Polar Chart
                const taskTypesCtx = document.getElementById('taskTypesChart').getContext('2d');
                new Chart(taskTypesCtx, {
                    type: 'polarArea',
                    data: {
                        labels: ['Cleaning', 'Inspection'],
                        datasets: [{
                            data: [${ cleaningTasks }, ${ inspectionTasks }],
                            backgroundColor: [
                                'rgba(102, 126, 234, 0.8)',
                                'rgba(245, 158, 11, 0.8)'
                            ],
                            borderColor: [
                                'rgba(102, 126, 234, 1)',
                                'rgba(245, 158, 11, 1)'
                            ],
                            borderWidth: 2
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: {
                                position: 'bottom',
                                labels: {
                                    padding: 20,
                                    usePointStyle: true,
                                    pointStyle: 'circle',
                                    font: { family: 'Inter', size: 12, weight: '500' }
                                }
                            }
                        },
                        scales: {
                            r: {
                                grid: { color: 'rgba(0,0,0,0.05)' },
                                ticks: { display: false }
                            }
                        }
                    }
                });
            </script>
        </body>

        </html>