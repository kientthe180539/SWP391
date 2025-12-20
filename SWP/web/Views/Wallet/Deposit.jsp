<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Top up - Luxe Wallet</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/Booking/booking.css">
                <style>
                    .deposit-container {
                        max-width: 600px;
                        margin: 40px auto;
                        padding: 0 20px;
                    }

                    .deposit-card {
                        background: white;
                        border-radius: 20px;
                        box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
                        overflow: hidden;
                    }

                    .deposit-header {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        color: white;
                        padding: 30px;
                        text-align: center;
                    }

                    .deposit-header h1 {
                        margin: 0 0 10px 0;
                        font-size: 26px;
                    }

                    .current-balance {
                        font-size: 14px;
                        opacity: 0.9;
                    }

                    .current-balance strong {
                        font-size: 20px;
                    }

                    .deposit-body {
                        padding: 30px;
                    }

                    .section-title {
                        font-size: 16px;
                        font-weight: 600;
                        color: #333;
                        margin-bottom: 15px;
                    }

                    .preset-amounts {
                        display: grid;
                        grid-template-columns: repeat(3, 1fr);
                        gap: 12px;
                        margin-bottom: 25px;
                    }

                    .preset-btn {
                        padding: 16px 10px;
                        border: 2px solid #e0e0e0;
                        border-radius: 12px;
                        background: white;
                        cursor: pointer;
                        font-size: 15px;
                        font-weight: 600;
                        color: #333;
                        transition: all 0.2s ease;
                    }

                    .preset-btn:hover {
                        border-color: #667eea;
                        background: #f5f3ff;
                    }

                    .preset-btn.selected {
                        border-color: #667eea;
                        background: #667eea;
                        color: white;
                    }

                    .custom-amount {
                        margin-bottom: 25px;
                    }

                    .amount-input-wrapper {
                        position: relative;
                    }

                    .amount-input {
                        width: 100%;
                        padding: 18px 80px 18px 20px;
                        font-size: 20px;
                        font-weight: 600;
                        border: 2px solid #e0e0e0;
                        border-radius: 12px;
                        outline: none;
                        transition: border-color 0.2s;
                    }

                    .amount-input:focus {
                        border-color: #667eea;
                    }

                    .amount-suffix {
                        position: absolute;
                        right: 20px;
                        top: 50%;
                        transform: translateY(-50%);
                        font-size: 16px;
                        color: #888;
                    }

                    .note {
                        background: #fff8e1;
                        border-radius: 10px;
                        padding: 15px;
                        margin-bottom: 25px;
                        display: flex;
                        align-items: flex-start;
                        gap: 10px;
                    }

                    .note-icon {
                        font-size: 20px;
                    }

                    .note-text {
                        font-size: 13px;
                        color: #666;
                        line-height: 1.5;
                    }

                    .btn-submit {
                        width: 100%;
                        padding: 18px;
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        color: white;
                        border: none;
                        border-radius: 12px;
                        font-size: 18px;
                        font-weight: 600;
                        cursor: pointer;
                        transition: transform 0.2s, box-shadow 0.2s;
                    }

                    .btn-submit:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
                    }

                    .btn-back {
                        display: block;
                        text-align: center;
                        margin-top: 20px;
                        color: #666;
                        text-decoration: none;
                        font-size: 14px;
                    }

                    .btn-back:hover {
                        color: #667eea;
                    }

                    .alert {
                        padding: 15px 20px;
                        border-radius: 10px;
                        margin-bottom: 20px;
                    }

                    .alert-error {
                        background: #f8d7da;
                        color: #721c24;
                    }
                </style>
            </head>

            <body>
                <%@ include file="../Components/Header.jsp" %>

                    <div class="main-content">
                        <div class="deposit-container">
                            <div class="deposit-card">
                                <div class="deposit-header">
                                    <h1>💰 Top up Luxe Wallet</h1>
                                    <div class="current-balance">
                                        Current balance: <strong>
                                            <fmt:formatNumber value="${wallet.balance}" type="number"
                                                groupingUsed="true" maxFractionDigits="0" /> VND
                                        </strong>
                                    </div>
                                </div>

                                <div class="deposit-body">
                                    <c:if test="${not empty sessionScope.error}">
                                        <div class="alert alert-error">
                                            ⚠️ ${sessionScope.error}
                                        </div>
                                        <c:remove var="error" scope="session" />
                                    </c:if>

                                    <form action="${pageContext.request.contextPath}/wallet/deposit" method="POST"
                                        id="depositForm">
                                        <div class="section-title">Select amount</div>
                                        <div class="preset-amounts">
                                            <button type="button" class="preset-btn"
                                                data-amount="100000">100,000đ</button>
                                            <button type="button" class="preset-btn"
                                                data-amount="200000">200,000đ</button>
                                            <button type="button" class="preset-btn"
                                                data-amount="500000">500,000đ</button>
                                            <button type="button" class="preset-btn"
                                                data-amount="1000000">1,000,000đ</button>
                                            <button type="button" class="preset-btn"
                                                data-amount="2000000">2,000,000đ</button>
                                            <button type="button" class="preset-btn"
                                                data-amount="5000000">5,000,000đ</button>
                                        </div>

                                        <div class="custom-amount">
                                            <div class="section-title">Or enter custom amount</div>
                                            <div class="amount-input-wrapper">
                                                <input type="text" class="amount-input" name="amount" id="amountInput"
                                                    placeholder="0" required autocomplete="off">
                                                <span class="amount-suffix">VND</span>
                                            </div>
                                        </div>

                                        <div class="note">
                                            <span class="note-icon">ℹ️</span>
                                            <span class="note-text">
                                                This is a <strong>demo</strong> top-up feature.
                                                Funds will be added to your wallet immediately without real payment.
                                            </span>
                                        </div>

                                        <button type="submit" class="btn-submit">
                                            💎 Top up now
                                        </button>
                                    </form>

                                    <a href="${pageContext.request.contextPath}/wallet" class="btn-back">
                                        ← Back to Wallet
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>

                    <%@ include file="../Components/Footer.jsp" %>

                        <script>
                            // Format number with thousand separators
                            function formatNumber(num) {
                                return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
                            }

                            // Parse formatted number back to integer
                            function parseFormattedNumber(str) {
                                return parseInt(str.replace(/,/g, '')) || 0;
                            }

                            // Handle preset amount buttons
                            document.querySelectorAll('.preset-btn').forEach(btn => {
                                btn.addEventListener('click', function () {
                                    // Remove selected class from all buttons
                                    document.querySelectorAll('.preset-btn').forEach(b => b.classList.remove('selected'));
                                    // Add selected class to clicked button
                                    this.classList.add('selected');
                                    // Set amount in input
                                    const amount = this.dataset.amount;
                                    document.getElementById('amountInput').value = formatNumber(amount);
                                });
                            });

                            // Format input as user types
                            const amountInput = document.getElementById('amountInput');
                            amountInput.addEventListener('input', function (e) {
                                // Get cursor position
                                const cursorPos = this.selectionStart;
                                const oldLength = this.value.length;

                                // Remove non-digits
                                let value = this.value.replace(/[^\d]/g, '');

                                // Format with thousand separators
                                if (value) {
                                    this.value = formatNumber(value);
                                }

                                // Adjust cursor position
                                const newLength = this.value.length;
                                const diff = newLength - oldLength;
                                this.setSelectionRange(cursorPos + diff, cursorPos + diff);

                                // Remove selected class from preset buttons
                                document.querySelectorAll('.preset-btn').forEach(b => b.classList.remove('selected'));
                            });

                            // Validate before submit
                            document.getElementById('depositForm').addEventListener('submit', function (e) {
                                const amount = parseFormattedNumber(amountInput.value);
                                if (amount < 10000) {
                                    e.preventDefault();
                                    alert('Minimum top-up amount is 10,000 VND');
                                    return false;
                                }
                                if (amount > 100000000) {
                                    e.preventDefault();
                                    alert('Maximum top-up amount is 100,000,000 VND');
                                    return false;
                                }
                            });
                        </script>
            </body>

            </html>