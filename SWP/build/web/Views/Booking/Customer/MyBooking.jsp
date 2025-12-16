<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đơn Đặt Phòng Của Tôi - Khách Sạn</title>
        <link rel="stylesheet" href="CSS/Booking/my_booking.css">
    </head>
    <body>
        <!-- HEADER -->
        <%@ include file="../../Components/Header.jsp" %>

        <!-- Main Content -->
        <main>
            <div class="back-home">
                <a href="home" class="btn-back-home">← Back to Home</a>
            </div>

            <h1 class="page-title">Đơn Đặt Phòng Của Tôi</h1>

            <!-- Filter Section -->
            <div class="filter-section">
                <input
                    type="text"
                    id="searchInput"
                    placeholder="🔍 Tìm theo mã đặt, tên phòng, tên khách..."
                    oninput="filterBookings()"
                    class="search-input"
                    />

                <select id="statusFilter" onchange="filterBookings()">
                    <option value="all">Tất Cả Trạng Thái</option>
                    <option value="pending">⏳ Chờ Duyệt</option>
                    <option value="confirmed">✓ Đã Duyệt</option>
                    <option value="checked-in">📍 Đã Nhập Phòng</option>
                    <option value="completed">✓ Hoàn Tất</option>
                    <option value="cancelled">✗ Đã Hủy</option>
                </select>
                <select id="dateFilter" onchange="filterBookings()">
                    <option value="all">Tất Cả Thời Gian</option>
                    <option value="upcoming">Sắp Tới</option>
                    <option value="past">Đã Qua</option>
                </select>
            </div>

            <!-- Bookings Container -->
            <div class="bookings-container" id="bookingsContainer">
                <!-- Booking 1 - Pending -->
                <div class="booking-card" data-status="pending" data-date="upcoming">
                    <div class="booking-card-header">
                        <div>
                            <div class="booking-id">Mã Đặt: #BK001234</div>
                            <div style="font-size: 12px; margin-top: 5px;">Ngày đặt: 03/12/2025</div>
                        </div>
                        <span class="booking-status status-pending">Chờ Duyệt</span>
                    </div>
                    <div class="booking-card-body">
                        <div class="booking-info">
                            <div class="info-box">
                                <div class="info-box-label">Phòng</div>
                                <div class="info-box-value">Suite Premium</div>
                            </div>
                            <div class="info-box">
                                <div class="info-box-label">Nhập</div>
                                <div class="info-box-value">15/12/2025</div>
                            </div>
                            <div class="info-box">
                                <div class="info-box-label">Trả</div>
                                <div class="info-box-value">18/12/2025</div>
                            </div>
                            <div class="info-box">
                                <div class="info-box-label">Đêm</div>
                                <div class="info-box-value">3 đêm</div>
                            </div>
                        </div>
                        <div class="booking-details">
                            <div class="detail-item">
                                <div class="detail-label">Tên Khách</div>
                                <div class="detail-value">Nguyễn Văn A</div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">Số Khách</div>
                                <div class="detail-value">2 người</div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">Tổng Giá</div>
                                <div class="detail-value">7.500.000 VNĐ</div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">Thanh Toán</div>
                                <div class="detail-value">Chưa thanh toán</div>
                            </div>
                        </div>
                    </div>
                    <div class="booking-card-footer">
                        <button class="btn btn-primary" onclick="viewDetails('#BK001234')">Chi Tiết</button>
                        <button class="btn btn-danger" onclick="cancelBooking('#BK001234')">Hủy Đặt</button>
                    </div>
                </div>

                <!-- Booking 2 - Confirmed -->
                <div class="booking-card" data-status="confirmed" data-date="upcoming">
                    <div class="booking-card-header">
                        <div>
                            <div class="booking-id">Mã Đặt: #BK001235</div>
                            <div style="font-size: 12px; margin-top: 5px;">Ngày đặt: 02/12/2025</div>
                        </div>
                        <span class="booking-status status-confirmed">Đã Duyệt</span>
                    </div>
                    <div class="booking-card-body">
                        <div class="booking-info">
                            <div class="info-box">
                                <div class="info-box-label">Phòng</div>
                                <div class="info-box-value">Phòng Đôi</div>
                            </div>
                            <div class="info-box">
                                <div class="info-box-label">Nhập</div>
                                <div class="info-box-value">20/12/2025</div>
                            </div>
                            <div class="info-box">
                                <div class="info-box-label">Trả</div>
                                <div class="info-box-value">22/12/2025</div>
                            </div>
                            <div class="info-box">
                                <div class="info-box-label">Đêm</div>
                                <div class="info-box-value">2 đêm</div>
                            </div>
                        </div>
                        <div class="booking-details">
                            <div class="detail-item">
                                <div class="detail-label">Tên Khách</div>
                                <div class="detail-value">Trần Thị B</div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">Số Khách</div>
                                <div class="detail-value">2 người</div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">Tổng Giá</div>
                                <div class="detail-value">4.000.000 VNĐ</div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">Thanh Toán</div>
                                <div class="detail-value">Đã thanh toán</div>
                            </div>
                        </div>
                    </div>
                    <div class="booking-card-footer">
                        <button class="btn btn-primary" onclick="viewDetails('#BK001235')">Chi Tiết</button>
                        <button class="btn btn-secondary" onclick="modifyBooking('#BK001235')">Sửa Đặt</button>
                    </div>
                </div>

                <!-- Booking 3 - Checked-in -->
                <div class="booking-card" data-status="checked-in" data-date="upcoming">
                    <div class="booking-card-header">
                        <div>
                            <div class="booking-id">Mã Đặt: #BK001233</div>
                            <div style="font-size: 12px; margin-top: 5px;">Ngày đặt: 01/12/2025</div>
                        </div>
                        <span class="booking-status status-checked-in">Đã Nhập Phòng</span>
                    </div>
                    <div class="booking-card-body">
                        <div class="booking-info">
                            <div class="info-box">
                                <div class="info-box-label">Phòng</div>
                                <div class="info-box-value">Deluxe Plus</div>
                            </div>
                            <div class="info-box">
                                <div class="info-box-label">Nhập</div>
                                <div class="info-box-value">10/12/2025</div>
                            </div>
                            <div class="info-box">
                                <div class="info-box-label">Trả</div>
                                <div class="info-box-value">13/12/2025</div>
                            </div>
                            <div class="info-box">
                                <div class="info-box-label">Đêm</div>
                                <div class="info-box-value">3 đêm</div>
                            </div>
                        </div>
                        <div class="booking-details">
                            <div class="detail-item">
                                <div class="detail-label">Tên Khách</div>
                                <div class="detail-value">Lê Văn C</div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">Số Khách</div>
                                <div class="detail-value">3 người</div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">Tổng Giá</div>
                                <div class="detail-value">6.300.000 VNĐ</div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">Thanh Toán</div>
                                <div class="detail-value">Đã thanh toán</div>
                            </div>
                        </div>
                    </div>
                    <div class="booking-card-footer">
                        <button class="btn btn-primary" onclick="viewDetails('#BK001233')">Chi Tiết</button>
                        <button class="btn btn-secondary" onclick="requestService('#BK001233')">Dịch Vụ Phòng</button>
                    </div>
                </div>

                <!-- Booking 4 - Completed -->
                <div class="booking-card" data-status="completed" data-date="past">
                    <div class="booking-card-header">
                        <div>
                            <div class="booking-id">Mã Đặt: #BK001232</div>
                            <div style="font-size: 12px; margin-top: 5px;">Ngày đặt: 25/11/2025</div>
                        </div>
                        <span class="booking-status status-completed">Hoàn Tất</span>
                    </div>
                    <div class="booking-card-body">
                        <div class="booking-info">
                            <div class="info-box">
                                <div class="info-box-label">Phòng</div>
                                <div class="info-box-value">Phòng Cao Cấp</div>
                            </div>
                            <div class="info-box">
                                <div class="info-box-label">Nhập</div>
                                <div class="info-box-value">28/11/2025</div>
                            </div>
                            <div class="info-box">
                                <div class="info-box-label">Trả</div>
                                <div class="info-box-value">30/11/2025</div>
                            </div>
                            <div class="info-box">
                                <div class="info-box-label">Đêm</div>
                                <div class="info-box-value">2 đêm</div>
                            </div>
                        </div>
                        <div class="booking-details">
                            <div class="detail-item">
                                <div class="detail-label">Tên Khách</div>
                                <div class="detail-value">Phạm Thị D</div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">Số Khách</div>
                                <div class="detail-value">2 người</div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">Tổng Giá</div>
                                <div class="detail-value">5.000.000 VNĐ</div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">Thanh Toán</div>
                                <div class="detail-value">Đã thanh toán</div>
                            </div>
                        </div>
                    </div>
                    <div class="booking-card-footer">
                        <button class="btn btn-primary" onclick="viewDetails('#BK001232')">Chi Tiết</button>
                        <button class="btn btn-secondary" onclick="leaveReview('#BK001232')">Đánh Giá</button>
                    </div>
                </div>

                <!-- Booking 5 - Cancelled -->
                <div class="booking-card" data-status="cancelled" data-date="past">
                    <div class="booking-card-header">
                        <div>
                            <div class="booking-id">Mã Đặt: #BK001231</div>
                            <div style="font-size: 12px; margin-top: 5px;">Ngày đặt: 20/11/2025</div>
                        </div>
                        <span class="booking-status status-cancelled">Đã Hủy</span>
                    </div>
                    <div class="booking-card-body">
                        <div class="booking-info">
                            <div class="info-box">
                                <div class="info-box-label">Phòng</div>
                                <div class="info-box-value">Phòng Gia Đình</div>
                            </div>
                            <div class="info-box">
                                <div class="info-box-label">Nhập</div>
                                <div class="info-box-value">25/11/2025</div>
                            </div>
                            <div class="info-box">
                                <div class="info-box-label">Trả</div>
                                <div class="info-box-value">27/11/2025</div>
                            </div>
                            <div class="info-box">
                                <div class="info-box-label">Đêm</div>
                                <div class="info-box-value">2 đêm</div>
                            </div>
                        </div>
                        <div class="booking-details">
                            <div class="detail-item">
                                <div class="detail-label">Tên Khách</div>
                                <div class="detail-value">Vũ Văn E</div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">Số Khách</div>
                                <div class="detail-value">4 người</div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">Tổng Giá</div>
                                <div class="detail-value">8.000.000 VNĐ</div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">Lý Do Hủy</div>
                                <div class="detail-value">Khách hàng yêu cầu hủy</div>
                            </div>
                        </div>
                    </div>
                    <div class="booking-card-footer">
                        <button class="btn btn-primary" onclick="viewDetails('#BK001231')">Chi Tiết</button>
                        <button class="btn btn-secondary" onclick="bookAgain('#BK001231')">Đặt Lại</button>
                    </div>
                </div>
            </div>

            <!-- Empty Data -->
            <div class="empty-state" id="emptyState" style="display: none;">
                <div class="empty-state-icon">📭</div>
                <div class="empty-state-text">
                    Không tìm thấy đơn đặt phòng phù hợp
                </div>
                <div style="font-size:14px;">
                    Vui lòng thử lại với từ khóa hoặc bộ lọc khác.
                </div>
            </div>


            <!-- PAGINATION -->
            <div class="pagination" id="pagination"></div>

        </main>

        <!-- FOOTER -->
        <%@ include file="../../Components/Footer.jsp" %>

        <script>
            const ITEMS_PER_PAGE = 2;
            let currentPage = 1;

            function getFilteredBookings() {
                const statusFilter = document.getElementById('statusFilter').value;
                const dateFilter = document.getElementById('dateFilter').value;
                const searchKeyword = document.getElementById('searchInput').value
                        .toLowerCase()
                        .trim();

                return Array.from(document.querySelectorAll('.booking-card')).filter(card => {

                    // Filter status
                    if (statusFilter !== 'all' && card.dataset.status !== statusFilter)
                        return false;

                    // Filter date
                    if (dateFilter !== 'all' && card.dataset.date !== dateFilter)
                        return false;

                    // Search filter
                    if (searchKeyword) {
                        const cardText = card.innerText.toLowerCase();
                        if (!cardText.includes(searchKeyword))
                            return false;
                    }

                    return true;
                });
            }

            function showPage(page) {
                const bookings = getFilteredBookings();
                const start = (page - 1) * ITEMS_PER_PAGE;
                const end = start + ITEMS_PER_PAGE;

                const emptyState = document.getElementById('emptyState');
                const pagination = document.getElementById('pagination');

                // Hide all cards first
                document.querySelectorAll('.booking-card').forEach(card => {
                    card.style.display = 'none';
                });

                // No data
                if (bookings.length === 0) {
                    emptyState.style.display = 'block';
                    pagination.style.display = 'none';
                    return;
                }

                //  have data
                emptyState.style.display = 'none';
                pagination.style.display = 'flex';

                bookings.forEach((card, index) => {
                    if (index >= start && index < end) {
                        card.style.display = 'block';
                    }
                });
            }
            {
                const bookings = getFilteredBookings();
                const start = (page - 1) * ITEMS_PER_PAGE;
                const end = start + ITEMS_PER_PAGE;

                // hide all first
                document.querySelectorAll('.booking-card').forEach(card => {
                    card.style.display = 'none';
                });

                // show only current page items
                bookings.forEach((card, index) => {
                    if (index >= start && index < end) {
                        card.style.display = 'block';
                    }
                });
            }

            function renderPagination() {
                const bookings = getFilteredBookings();
                const totalPages = Math.ceil(bookings.length / ITEMS_PER_PAGE);
                const pagination = document.getElementById('pagination');
                pagination.innerHTML = '';

                if (totalPages <= 1)
                    return;

                // Prev button
                const prevBtn = document.createElement('button');
                prevBtn.textContent = '« Prev';
                prevBtn.className = 'page-btn' + (currentPage === 1 ? ' disabled' : '');
                prevBtn.onclick = () => changePage(currentPage - 1);
                pagination.appendChild(prevBtn);

                // Page numbers
                for (let i = 1; i <= totalPages; i++) {
                    const btn = document.createElement('button');
                    btn.textContent = i;
                    btn.className = 'page-btn' + (i === currentPage ? ' active' : '');
                    btn.onclick = () => changePage(i);
                    pagination.appendChild(btn);
                }

                // Next button
                const nextBtn = document.createElement('button');
                nextBtn.textContent = 'Next »';
                nextBtn.className = 'page-btn' + (currentPage === totalPages ? ' disabled' : '');
                nextBtn.onclick = () => changePage(currentPage + 1);
                pagination.appendChild(nextBtn);
            }

            function changePage(page) {
                const bookings = getFilteredBookings();
                const totalPages = Math.ceil(bookings.length / ITEMS_PER_PAGE);

                if (page < 1 || page > totalPages)
                    return;

                currentPage = page;
                showPage(currentPage);
                renderPagination();
            }

            function filterBookings() {
                currentPage = 1;
                showPage(currentPage);
                renderPagination();
            }

            document.addEventListener('DOMContentLoaded', () => {
                filterBookings();
            });
        </script>
    </body>
</html>

