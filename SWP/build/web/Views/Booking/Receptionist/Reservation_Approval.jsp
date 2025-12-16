

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Duyệt Đặt Phòng - Quản Lí Khách Sạn</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: #f5f7fa;
                min-height: 100vh;
                display: flex;
                flex-direction: column;
            }

            /* Header */
            header {
                background: white;
                padding: 20px 40px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .logo {
                font-size: 28px;
                font-weight: bold;
                color: #1e3c72;
            }

            .staff-profile {
                display: flex;
                align-items: center;
                gap: 15px;
                color: #666;
            }

            .staff-avatar {
                width: 40px;
                height: 40px;
                background: #2a5298;
                border-radius: 50%;
                color: white;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            /* Main Content */
            main {
                flex: 1;
                padding: 40px 20px;
            }

            .container {
                max-width: 1200px;
                margin: 0 auto;
            }

            .page-title {
                font-size: 32px;
                font-weight: bold;
                color: #1e3c72;
                margin-bottom: 30px;
            }

            .reservations-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(450px, 1fr));
                gap: 25px;
            }

            .reservation-card {
                background: white;
                border-radius: 12px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
                overflow: hidden;
                transition: all 0.3s ease;
            }

            .reservation-card:hover {
                box-shadow: 0 8px 25px rgba(0, 0, 0, 0.12);
                transform: translateY(-5px);
            }

            .reservation-header {
                background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
                color: white;
                padding: 20px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .reservation-id {
                font-size: 18px;
                font-weight: bold;
            }

            .reservation-status {
                display: inline-block;
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
                background: rgba(255, 255, 255, 0.25);
            }

            .status-pending {
                background: rgba(255, 193, 7, 0.3);
                color: #ffc107;
            }

            .reservation-body {
                padding: 25px;
            }

            .guest-info {
                margin-bottom: 20px;
            }

            .guest-name {
                font-size: 20px;
                font-weight: bold;
                color: #1e3c72;
                margin-bottom: 8px;
            }

            .guest-contact {
                font-size: 14px;
                color: #666;
                display: flex;
                flex-direction: column;
                gap: 5px;
            }

            .info-table {
                width: 100%;
                margin: 20px 0;
                border-collapse: collapse;
            }

            .info-table td {
                padding: 12px 0;
                border-bottom: 1px solid #e0e0e0;
                font-size: 14px;
            }

            .info-table td:first-child {
                color: #666;
                font-weight: 500;
                width: 35%;
            }

            .info-table td:last-child {
                color: #1e3c72;
                font-weight: 600;
                text-align: right;
            }

            .room-details {
                background: #f8f9fa;
                padding: 15px;
                border-radius: 8px;
                margin: 20px 0;
            }

            .room-name {
                font-size: 16px;
                font-weight: 600;
                color: #1e3c72;
                margin-bottom: 8px;
            }

            .room-specs {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 10px;
                font-size: 13px;
                color: #666;
            }

            .spec-item {
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .action-buttons {
                display: flex;
                gap: 12px;
                margin-top: 25px;
            }

            .btn {
                flex: 1;
                padding: 12px 20px;
                border: none;
                border-radius: 8px;
                font-size: 14px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
            }

            .btn-approve {
                background: #28a745;
                color: white;
            }

            .btn-approve:hover {
                background: #218838;
                box-shadow: 0 4px 12px rgba(40, 167, 69, 0.3);
            }

            .btn-reject {
                background: #dc3545;
                color: white;
            }

            .btn-reject:hover {
                background: #c82333;
                box-shadow: 0 4px 12px rgba(220, 53, 69, 0.3);
            }

            .btn-details {
                background: white;
                color: #2a5298;
                border: 2px solid #2a5298;
            }

            .btn-details:hover {
                background: #f8f9fa;
            }

            /* Footer */
            footer {
                background: white;
                color: #666;
                text-align: center;
                padding: 20px;
                border-top: 1px solid #e0e0e0;
                margin-top: auto;
            }

            @media (max-width: 768px) {
                .reservations-grid {
                    grid-template-columns: 1fr;
                }

                .page-title {
                    font-size: 24px;
                }

                .action-buttons {
                    flex-direction: column;
                }
            }
        </style>
    </head>
    <body>
        <header>
            <div class="logo">🏨 Khách Sạn Royal - Quản Lí</div>
            <div class="staff-profile">
                <span>Lễ Tân - Trần Thị B</span>
                <div class="staff-avatar">TB</div>
            </div>
        </header>

        <main>
            <div class="container">
                <h1 class="page-title">📋 Duyệt Đặt Phòng</h1>

                <div class="reservations-grid">
                    <!-- Reservation Card 1 - PENDING -->
                    <div class="reservation-card">
                        <div class="reservation-header">
                            <span class="reservation-id">BK-2024-12345</span>
                            <span class="reservation-status status-pending">CHỜ XÁC NHẬN</span>
                        </div>
                        <div class="reservation-body">
                            <div class="guest-info">
                                <div class="guest-name">Nguyễn Văn A</div>
                                <div class="guest-contact">
                                    <span>📧 nguyena@email.com</span>
                                    <span>📱 0912-345-678</span>
                                </div>
                            </div>

                            <table class="info-table">
                                <tr>
                                    <td>Check-in:</td>
                                    <td>05/01/2025</td>
                                </tr>
                                <tr>
                                    <td>Check-out:</td>
                                    <td>08/01/2025</td>
                                </tr>
                                <tr>
                                    <td>Số Đêm:</td>
                                    <td>3 đêm</td>
                                </tr>
                                <tr>
                                    <td>Số Khách:</td>
                                    <td>2 người</td>
                                </tr>
                            </table>

                            <div class="room-details">
                                <div class="room-name">Phòng Đôi Cao Cấp</div>
                                <div class="room-specs">
                                    <div class="spec-item">🛏️ Giường đôi</div>
                                    <div class="spec-item">🚿 Phòng tắm</div>
                                    <div class="spec-item">📺 TV màn hình</div>
                                    <div class="spec-item">❄️ Điều hòa</div>
                                </div>
                            </div>

                            <table class="info-table" style="border-bottom: none;">
                                <tr>
                                    <td style="font-weight: 700; color: #ff9800;">Tổng Tiền:</td>
                                    <td style="font-weight: 700; color: #ff9800; font-size: 16px;">7.500.000 ₫</td>
                                </tr>
                            </table>

                            <div class="action-buttons">
                                <button class="btn btn-approve">✓ Duyệt</button>
                                <button class="btn btn-reject">✗ Từ Chối</button>
                                <button class="btn btn-details">Chi Tiết</button>
                            </div>
                        </div>
                    </div>

                    <!-- Reservation Card 2 -->
                    <div class="reservation-card">
                        <div class="reservation-header">
                            <span class="reservation-id">BK-2024-12346</span>
                            <span class="reservation-status status-pending">CHỜ XÁC NHẬN</span>
                        </div>
                        <div class="reservation-body">
                            <div class="guest-info">
                                <div class="guest-name">Trần Thị C</div>
                                <div class="guest-contact">
                                    <span>📧 tranthic@email.com</span>
                                    <span>📱 0923-456-789</span>
                                </div>
                            </div>

                            <table class="info-table">
                                <tr>
                                    <td>Check-in:</td>
                                    <td>06/01/2025</td>
                                </tr>
                                <tr>
                                    <td>Check-out:</td>
                                    <td>09/01/2025</td>
                                </tr>
                                <tr>
                                    <td>Số Đêm:</td>
                                    <td>3 đêm</td>
                                </tr>
                                <tr>
                                    <td>Số Khách:</td>
                                    <td>1 người</td>
                                </tr>
                            </table>

                            <div class="room-details">
                                <div class="room-name">Phòng Đơn Premium</div>
                                <div class="room-specs">
                                    <div class="spec-item">🛏️ Giường đơn</div>
                                    <div class="spec-item">🚿 Phòng tắm</div>
                                    <div class="spec-item">📺 TV</div>
                                    <div class="spec-item">❄️ Điều hòa</div>
                                </div>
                            </div>

                            <table class="info-table" style="border-bottom: none;">
                                <tr>
                                    <td style="font-weight: 700; color: #ff9800;">Tổng Tiền:</td>
                                    <td style="font-weight: 700; color: #ff9800; font-size: 16px;">4.500.000 ₫</td>
                                </tr>
                            </table>

                            <div class="action-buttons">
                                <button class="btn btn-approve">✓ Duyệt</button>
                                <button class="btn btn-reject">✗ Từ Chối</button>
                                <button class="btn btn-details">Chi Tiết</button>
                            </div>
                        </div>
                    </div>

                    <!-- Reservation Card 3 -->
                    <div class="reservation-card">
                        <div class="reservation-header">
                            <span class="reservation-id">BK-2024-12347</span>
                            <span class="reservation-status status-pending">CHỜ XÁC NHẬN</span>
                        </div>
                        <div class="reservation-body">
                            <div class="guest-info">
                                <div class="guest-name">Lê Minh D</div>
                                <div class="guest-contact">
                                    <span>📧 leminhd@email.com</span>
                                    <span>📱 0934-567-890</span>
                                </div>
                            </div>

                            <table class="info-table">
                                <tr>
                                    <td>Check-in:</td>
                                    <td>07/01/2025</td>
                                </tr>
                                <tr>
                                    <td>Check-out:</td>
                                    <td>10/01/2025</td>
                                </tr>
                                <tr>
                                    <td>Số Đêm:</td>
                                    <td>3 đêm</td>
                                </tr>
                                <tr>
                                    <td>Số Khách:</td>
                                    <td>4 người</td>
                                </tr>
                            </table>

                            <div class="room-details">
                                <div class="room-name">Phòng Gia Đình Suite</div>
                                <div class="room-specs">
                                    <div class="spec-item">🛏️ 2 Giường</div>
                                    <div class="spec-item">🚿 2 Phòng tắm</div>
                                    <div class="spec-item">📺 Smart TV</div>
                                    <div class="spec-item">❄️ Điều hòa</div>
                                </div>
                            </div>

                            <table class="info-table" style="border-bottom: none;">
                                <tr>
                                    <td style="font-weight: 700; color: #ff9800;">Tổng Tiền:</td>
                                    <td style="font-weight: 700; color: #ff9800; font-size: 16px;">12.000.000 ₫</td>
                                </tr>
                            </table>

                            <div class="action-buttons">
                                <button class="btn btn-approve">✓ Duyệt</button>
                                <button class="btn btn-reject">✗ Từ Chối</button>
                                <button class="btn btn-details">Chi Tiết</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <footer>
            <p>&copy; 2025 Khách Sạn Royal. Hệ Thống Quản Lí Khách Sạn | Hotline: 1900-1234</p>
        </footer>

        <script>
            // Xử lý nút Duyệt
            document.querySelectorAll('.btn-approve').forEach(btn => {
                btn.addEventListener('click', function () {
                    const card = this.closest('.reservation-card');
                    const status = card.querySelector('.reservation-status');
                    alert('✓ Đã duyệt đặt phòng này!');
                    // Có thể thay đổi giao diện hoặc cập nhật trạng thái
                });
            });

            // Xử lý nút Từ Chối
            document.querySelectorAll('.btn-reject').forEach(btn => {
                btn.addEventListener('click', function () {
                    const card = this.closest('.reservation-card');
                    const reason = prompt('Nhập lý do từ chối:');
                    if (reason) {
                        alert('✗ Đã từ chối đặt phòng này.\nLý do: ' + reason);
                    }
                });
            });

            // Xử lý nút Chi Tiết
            document.querySelectorAll('.btn-details').forEach(btn => {
                btn.addEventListener('click', function () {
                    const bookingId = this.closest('.reservation-card')
                            .querySelector('.reservation-id').textContent;
                    alert('Mở chi tiết cho: ' + bookingId);
                });
            });
        </script>
    </body>
</html>
