<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Analytics Dashboard | HMS</title>

                <!-- Fonts & Icons -->
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
                <link rel="stylesheet"
                    href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

                <!-- Custom CSS -->
                <link rel="stylesheet" href="<c:url value='/CSS/housekeeping.css'/>">
                <style>
                    :root {
                        --primary: #4f46e5;
                        --primary-light: #eef2ff;
                        --bg-light: #f8fafc;
                        --card-shadow: 0 1px 3px 0 rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1);
                    }

                    body {
                        font-family: 'Inter', sans-serif;
                        background-color: var(--bg-light);
                        color: #0f172a;
                    }

                    .layout-wrapper {
                        display: flex;
                        min-height: 100vh;
                    }

                    .main-content {
                        flex: 1;
                        display: flex;
                        flex-direction: column;
                        overflow-x: hidden;
                    }

                    .dashboard-header {
                        background-color: white;
                        border-bottom: 1px solid #e2e8f0;
                        padding: 1.5rem 2rem;
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        flex-wrap: wrap;
                        gap: 1rem;
                    }

                    .page-title {
                        font-weight: 700;
                        font-size: 1.5rem;
                        color: #1e293b;
                        margin: 0;
                    }

                    .page-subtitle {
                        color: #64748b;
                        font-size: 0.875rem;
                        margin: 0;
                    }

                    .kpi-card {
                        background: white;
                        border-radius: 1rem;
                        padding: 1.5rem;
                        border: 1px solid #e2e8f0;
                        box-shadow: var(--card-shadow);
                        height: 100%;
                    }

                    .kpi-value {
                        font-size: 1.875rem;
                        font-weight: 700;
                        color: #0f172a;
                    }

                    .kpi-label {
                        font-size: 0.875rem;
                        color: #64748b;
                        font-weight: 500;
                    }

                    .kpi-icon {
                        width: 48px;
                        height: 48px;
                        border-radius: 12px;
                        background: var(--primary-light);
                        color: var(--primary);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-size: 1.5rem;
                        margin-bottom: 1rem;
                    }

                    .chart-card {
                        background: white;
                        border-radius: 1rem;
                        padding: 1.5rem;
                        border: 1px solid #e2e8f0;
                        box-shadow: var(--card-shadow);
                        height: 100%;
                    }

                    .chart-title {
                        font-size: 1.125rem;
                        font-weight: 600;
                        color: #1e293b;
                        margin-bottom: 1.5rem;
                    }

                    #loadingOverlay {
                        position: fixed;
                        top: 0;
                        left: 0;
                        width: 100%;
                        height: 100%;
                        background: rgba(255, 255, 255, 0.9);
                        z-index: 9999;
                        display: none;
                        align-items: center;
                        justify-content: center;
                        flex-direction: column;
                    }

                    @media print {

                        .sidebar,
                        .btn,
                        form {
                            display: none !important;
                        }

                        .card {
                            break-inside: avoid;
                            border: 1px solid #ccc;
                            box-shadow: none;
                        }
                    }
                </style>
            </head>

            <body>
                <!-- Loading Screen -->
                <div id="loadingOverlay">
                    <div class="spinner-border text-primary mb-3" role="status"></div>
                    <h5 class="fw-bold text-dark">Exporting Data with Charts...</h5>
                    <p class="text-muted small">This may take a few seconds.</p>
                </div>

                <div class="layout-wrapper">
                    <jsp:include page="../Shared/OwnerSidebar.jsp" />

                    <div class="main-content">
                        <jsp:include page="../Shared/Header.jsp" />

                        <div class="dashboard-header">
                            <div>
                                <h1 class="page-title">Analytics Dashboard</h1>
                                <p class="page-subtitle">Overview of performance from ${startDate} to ${endDate}</p>
                            </div>

                            <div class="d-flex gap-2 align-items-center">
                                <form action="<c:url value='/owner/reports'/>" method="get"
                                    class="d-flex gap-2 bg-light p-1 rounded-3 border">
                                    <input type="date" name="startDate"
                                        class="form-control form-control-sm border-0 bg-transparent"
                                        value="${startDate}" required>
                                    <span class="text-muted align-self-center">-</span>
                                    <input type="date" name="endDate"
                                        class="form-control form-control-sm border-0 bg-transparent" value="${endDate}"
                                        required>
                                    <button type="submit" class="btn btn-primary btn-sm rounded-2"><i
                                            class="bi bi-arrow-right"></i></button>
                                </form>

                                <button class="btn btn-light border shadow-sm" onclick="window.print()">
                                    <i class="bi bi-printer"></i>
                                </button>

                                <div class="dropdown">
                                    <button class="btn btn-primary shadow-sm dropdown-toggle" type="button"
                                        data-bs-toggle="dropdown">
                                        <i class="bi bi-download me-1"></i> Export
                                    </button>
                                    <ul class="dropdown-menu shadow border-0 p-2 rounded-3">
                                        <li><a class="dropdown-item rounded-2" href="#" onclick="handleExport('excel')">
                                                <i class="bi bi-file-earmark-excel text-success me-2"></i> Excel (With
                                                Charts)
                                            </a></li>
                                        <li><a class="dropdown-item rounded-2" href="#" onclick="handleExport('pdf')">
                                                <i class="bi bi-file-earmark-pdf text-danger me-2"></i> PDF Dashboard
                                            </a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <div class="container-fluid py-4 px-4">

                            <!-- KPI Cards -->
                            <c:set var="totalRev" value="0" />
                            <c:forEach items="${revenueData}" var="item">
                                <c:set var="totalRev" value="${totalRev + item.revenue}" />
                            </c:forEach>

                            <div class="row g-4 mb-4">
                                <div class="col-md-3">
                                    <div class="kpi-card">
                                        <div class="kpi-icon"><i class="bi bi-currency-dollar"></i></div>
                                        <h2 class="kpi-value">$
                                            <fmt:formatNumber value="${totalRev}" pattern="#,##0" />
                                        </h2>
                                        <span class="kpi-label">Total Revenue</span>
                                    </div>
                                </div>
                                <!-- Other KPIs omitted for brevity but logic is same -->
                                <div class="col-md-3">
                                    <div class="kpi-card">
                                        <div class="kpi-icon" style="background: #ecfdf5; color: #10b981;"><i
                                                class="bi bi-calendar-check"></i></div>
                                        <h2 class="kpi-value">${bookingStats['CONFIRMED'] != null ?
                                            bookingStats['CONFIRMED'] : 0}</h2>
                                        <span class="kpi-label">Confirmed Bookings</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Charts -->
                            <div class="row g-4 mb-4">
                                <div class="col-lg-8">
                                    <div class="chart-card">
                                        <h3 class="chart-title">Revenue Trend</h3>
                                        <div style="height: 300px;"><canvas id="revenueChart"></canvas></div>
                                    </div>
                                </div>
                                <div class="col-lg-4">
                                    <div class="chart-card">
                                        <h3 class="chart-title">Room Status</h3>
                                        <div style="height: 300px; display:flex; justify-content:center;"><canvas
                                                id="roomStatusChart"></canvas></div>
                                    </div>
                                </div>
                            </div>

                            <div class="row g-4">
                                <div class="col-lg-6">
                                    <div class="chart-card">
                                        <h3 class="chart-title">Revenue by Room Type</h3>
                                        <div style="height: 300px;"><canvas id="roomTypeChart"></canvas></div>
                                    </div>
                                </div>
                                <div class="col-lg-6">
                                    <div class="chart-card">
                                        <h3 class="chart-title">Booking Stats</h3>
                                        <div style="height: 300px; display:flex; justify-content:center;"><canvas
                                                id="bookingStatsChart"></canvas></div>
                                    </div>
                                </div>
                            </div>

                        </div>
                        <jsp:include page="../Shared/Footer.jsp" />
                    </div>
                </div>

                <!-- Scripts -->
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
                <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

                <!-- ExcelJS and FileSaver for Advanced Excel Export -->
                <script src="https://cdnjs.cloudflare.com/ajax/libs/exceljs/4.3.0/exceljs.min.js"></script>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/2.0.5/FileSaver.min.js"></script>

                <!-- html2canvas and jsPDF for PDF -->
                <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>

                <script>
                    // --- DATA ---
                    const colors = { primary: '#4f46e5', success: '#10b981', warning: '#f59e0b', danger: '#ef4444', info: '#3b82f6', gray: '#94a3b8' };

                    const revLabels = [<c:forEach items="${revenueData}" var="item" varStatus="loop">'${item.date}'${!loop.last ? ',' : ''}</c:forEach>];
                    const revValues = [<c:forEach items="${revenueData}" var="item" varStatus="loop">${item.revenue}${!loop.last ? ',' : ''}</c:forEach>];

                    const statusLabels = [], statusValues = [], statusColors = [];
                    <c:forEach items="${roomStatusData}" var="entry">
                        statusLabels.push('${entry.key}'); statusValues.push(${entry.value});
                        // Simple color mapping
                        if('${entry.key}'=='AVAILABLE') statusColors.push(colors.success);
                        else if('${entry.key}'=='OCCUPIED') statusColors.push(colors.danger);
                        else statusColors.push(colors.gray);
                    </c:forEach>

                    const rtLabels = [<c:forEach items="${roomTypeRevenueData}" var="item" varStatus="loop">'${item.type}'${!loop.last ? ',' : ''}</c:forEach>];
                    const rtValues = [<c:forEach items="${roomTypeRevenueData}" var="item" varStatus="loop">${item.revenue}${!loop.last ? ',' : ''}</c:forEach>];

                    const bookLabels = [], bookValues = [];
                    <c:forEach items="${bookingStats}" var="entry">bookLabels.push('${entry.key}'); bookValues.push(${entry.value});</c:forEach>

                    // --- CHARTS INIT ---
                    Chart.defaults.font.family = "'Inter', sans-serif";
                    const commonOpts = { responsive: true, maintainAspectRatio: false, scales: { x: { grid: { display: false } }, y: { beginAtZero: true } } };

                    new Chart(document.getElementById('revenueChart'), { type: 'line', data: { labels: revLabels, datasets: [{ label: 'Revenue', data: revValues, borderColor: colors.primary, backgroundColor: 'rgba(79,70,229,0.1)', fill: true }] }, options: commonOpts });
                    new Chart(document.getElementById('roomStatusChart'), { type: 'doughnut', data: { labels: statusLabels, datasets: [{ data: statusValues, backgroundColor: statusColors }] }, options: commonOpts });
                    new Chart(document.getElementById('roomTypeChart'), { type: 'bar', data: { labels: rtLabels, datasets: [{ label: 'Revenue', data: rtValues, backgroundColor: colors.primary }] }, options: commonOpts });
                    new Chart(document.getElementById('bookingStatsChart'), { type: 'pie', data: { labels: bookLabels, datasets: [{ data: bookValues, backgroundColor: [colors.success, colors.warning, colors.danger, colors.info] }] }, options: commonOpts });

                    // --- EXPORT LOGIC ---
                    async function handleExport(type) {
                        document.getElementById('loadingOverlay').style.display = 'flex';
                        await new Promise(r => setTimeout(r, 200)); // UI update render
                        try {
                            if (type === 'excel') await exportExcelWithImages();
                            else if (type === 'pdf') await exportPDF();
                        } catch (e) { console.error(e); alert('Export failed'); }
                        finally { document.getElementById('loadingOverlay').style.display = 'none'; }
                    }

                    async function exportExcelWithImages() {
                        const workbook = new ExcelJS.Workbook();
                        const sheet = workbook.addWorksheet('Dashboard Report');

                        // 1. Add Title
                        sheet.mergeCells('A1:H1');
                        const titleCell = sheet.getCell('A1');
                        titleCell.value = 'HMS Analytics Report (${startDate} - ${endDate})';
                        titleCell.font = { name: 'Inter', size: 16, bold: true };
                        titleCell.alignment = { horizontal: 'center' };

                        // 2. Add Revenue Chart
                        const revCanvas = document.getElementById('revenueChart');
                        const revImg = workbook.addImage({
                            base64: revCanvas.toDataURL('image/png'),
                            extension: 'png',
                        });
                        sheet.addImage(revImg, {
                            tl: { col: 0, row: 3 }, // Top-left: A4
                            ext: { width: 600, height: 300 }
                        });
                        sheet.getCell('A3').value = "Revenue Trend";
                        sheet.getCell('A3').font = { bold: true };

                        // 3. Add Status Chart
                        const statusCanvas = document.getElementById('roomStatusChart');
                        const statusImg = workbook.addImage({
                            base64: statusCanvas.toDataURL('image/png'),
                            extension: 'png',
                        });
                        sheet.addImage(statusImg, {
                            tl: { col: 8, row: 3 }, // Top-left: I4
                            ext: { width: 300, height: 300 }
                        });

                        // 4. Add Data Tables below charts (Row 20 approx)
                        let currentRow = 20;

                        // Revenue Table
                        sheet.getCell(`A\${currentRow}`).value = "Revenue Data";
                        sheet.getCell(`A\${currentRow}`).font = { bold: true };
                        currentRow++;
                        sheet.getRow(currentRow).values = ['Date', 'Revenue ($)'];
                        sheet.getRow(currentRow).font = { bold: true };
                        currentRow++;
                        for (let i = 0; i < revLabels.length; i++) {
                            sheet.getRow(currentRow).values = [revLabels[i], revValues[i]];
                            currentRow++;
                        }

                        // Save
                        const buffer = await workbook.xlsx.writeBuffer();
                        saveAs(new Blob([buffer]), 'HMS_Report_With_Charts.xlsx');
                    }

                    async function exportPDF() {
                        window.jsPDF = window.jspdf.jsPDF;
                        const content = document.querySelector('.container-fluid');
                        const canvas = await html2canvas(content, { scale: 2, backgroundColor: '#ffffff' });
                        const pdf = new jsPDF('p', 'mm', 'a4');
                        const w = pdf.internal.pageSize.getWidth();
                        const h = (canvas.height * w) / canvas.width;
                        pdf.addImage(canvas.toDataURL('image/png'), 'PNG', 0, 0, w, h);
                        pdf.save("HMS_Dashboard.pdf");
                    }
                </script>
            </body>

            </html>