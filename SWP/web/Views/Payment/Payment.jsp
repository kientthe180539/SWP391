<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Payment - Hotel Management</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/Booking/booking.css">
                <style>
                    .payment-container {
                        max-width: 800px;
                        margin: 40px auto;
                        padding: 0 20px;
                    }

                    .payment-card {
                        background: white;
                        border-radius: 15px;
                        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
                        overflow: hidden;
                    }

                    .payment-header {
                        background: linear-gradient(135deg, #1a5f7a 0%, #2a9d8f 100%);
                        color: white;
                        padding: 30px;
                        text-align: center;
                    }

                    .payment-header h1 {
                        margin: 0 0 10px 0;
                        font-size: 28px;
                    }

                    .payment-amount {
                        font-size: 36px;
                        font-weight: bold;
                        margin: 15px 0;
                    }

                    .payment-body {
                        padding: 30px;
                    }

                    .booking-summary {
                        background: #f8f9fa;
                        border-radius: 10px;
                        padding: 20px;
                        margin-bottom: 30px;
                    }

                    .booking-summary h3 {
                        margin: 0 0 15px 0;
                        color: #1a5f7a;
                        border-bottom: 2px solid #1a5f7a;
                        padding-bottom: 10px;
                    }

                    .summary-row {
                        display: flex;
                        justify-content: space-between;
                        padding: 8px 0;
                        border-bottom: 1px solid #e9ecef;
                    }

                    .summary-row:last-child {
                        border-bottom: none;
                    }

                    .summary-label {
                        color: #666;
                    }

                    .summary-value {
                        font-weight: 600;
                        color: #333;
                    }

                    .payment-methods {
                        margin-bottom: 30px;
                    }

                    .payment-methods h3 {
                        margin: 0 0 15px 0;
                        color: #1a5f7a;
                    }

                    .method-option {
                        display: flex;
                        align-items: center;
                        padding: 15px 20px;
                        border: 2px solid #e9ecef;
                        border-radius: 10px;
                        margin-bottom: 10px;
                        cursor: pointer;
                        transition: all 0.3s ease;
                    }

                    .method-option:hover {
                        border-color: #1a5f7a;
                        background: #f8f9fa;
                    }

                    .method-option.selected {
                        border-color: #1a5f7a;
                        background: #e8f4f8;
                    }

                    .method-option input[type="radio"] {
                        margin-right: 15px;
                        width: 20px;
                        height: 20px;
                    }

                    .method-icon {
                        font-size: 24px;
                        margin-right: 15px;
                    }

                    .method-info h4 {
                        margin: 0;
                        color: #333;
                    }

                    .method-info p {
                        margin: 5px 0 0 0;
                        font-size: 13px;
                        color: #666;
                    }

                    .btn-pay {
                        width: 100%;
                        padding: 18px;
                        background: linear-gradient(135deg, #2a9d8f 0%, #1a5f7a 100%);
                        color: white;
                        border: none;
                        border-radius: 10px;
                        font-size: 18px;
                        font-weight: bold;
                        cursor: pointer;
                        transition: transform 0.2s, box-shadow 0.2s;
                    }

                    .btn-pay:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 6px 20px rgba(26, 95, 122, 0.4);
                    }

                    .btn-pay:disabled {
                        background: #ccc;
                        cursor: not-allowed;
                        transform: none;
                        box-shadow: none;
                    }

                    .btn-cancel {
                        display: block;
                        text-align: center;
                        margin-top: 15px;
                        color: #666;
                        text-decoration: none;
                    }

                    .btn-cancel:hover {
                        color: #dc3545;
                    }

                    .error-message {
                        background: #f8d7da;
                        color: #721c24;
                        padding: 15px;
                        border-radius: 10px;
                        margin-bottom: 20px;
                    }

                    .secure-badge {
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        margin-top: 20px;
                        color: #28a745;
                        font-size: 14px;
                    }

                    .secure-badge span {
                        margin-left: 8px;
                    }

                    .badge-recommend {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        color: white;
                        font-size: 10px;
                        padding: 3px 8px;
                        border-radius: 12px;
                        margin-left: 8px;
                        font-weight: 500;
                    }

                    .method-option.insufficient {
                        opacity: 0.7;
                        border-color: #ffcdd2;
                        background: #fff5f5;
                    }

                    .text-danger {
                        color: #dc3545;
                        font-weight: 500;
                        margin-left: 10px;
                    }

                    .deposit-link {
                        color: #667eea;
                        font-weight: 600;
                        margin-left: 10px;
                        text-decoration: none;
                    }

                    .deposit-link:hover {
                        text-decoration: underline;
                    }
                </style>
            </head>

            <body>
                <%@ include file="../Components/Header.jsp" %>

                    <div class="main-content">
                        <div class="payment-container">
                            <div class="payment-card">
                                <div class="payment-header">
                                    <h1>💳 Room Booking Payment</h1>
                                    <p>Booking #${booking.bookingId}</p>
                                    <div class="payment-amount">
                                        <fmt:formatNumber value="${booking.totalAmount}" type="currency"
                                            currencySymbol="" /> VND
                                    </div>
                                </div>

                                <div class="payment-body">
                                    <c:if test="${not empty error}">
                                        <div class="error-message">
                                            ⚠️ ${error}
                                        </div>
                                    </c:if>

                                    <!-- Booking Summary -->
                                    <div class="booking-summary">
                                        <h3>📋 Booking Information</h3>
                                        <div class="summary-row">
                                            <span class="summary-label">Room:</span>
                                            <span class="summary-value">${bookingDetails.roomNumber} -
                                                ${bookingDetails.typeName}</span>
                                        </div>
                                        <div class="summary-row">
                                            <span class="summary-label">Check-in:</span>
                                            <span class="summary-value">${booking.checkinDate}</span>
                                        </div>
                                        <div class="summary-row">
                                            <span class="summary-label">Check-out:</span>
                                            <span class="summary-value">${booking.checkoutDate}</span>
                                        </div>
                                        <div class="summary-row">
                                            <span class="summary-label">Guests:</span>
                                            <span class="summary-value">${booking.numGuests} guest(s)</span>
                                        </div>
                                        <div class="summary-row">
                                            <span class="summary-label">Status:</span>
                                            <span class="summary-value" style="color: #ffc107;">⏳ Pending payment</span>
                                        </div>
                                    </div>

                                    <!-- Payment Form -->
                                    <form action="${pageContext.request.contextPath}/payment/process" method="POST"
                                        id="paymentForm">
                                        <input type="hidden" name="bookingId" value="${booking.bookingId}">

                                        <div class="payment-methods">
                                            <h3>💰 Select Payment Method</h3>

                                            <!-- Wallet Payment - Recommended -->
                                            <label
                                                class="method-option selected ${wallet.balance < booking.totalAmount ? 'insufficient' : ''}">
                                                <input type="radio" name="paymentMethod" value="WALLET"
                                                    ${wallet.balance>= booking.totalAmount ? 'checked' : 'disabled'}>
                                                <span class="method-icon">💎</span>
                                                <div class="method-info">
                                                    <h4>Luxe Wallet <span class="badge-recommend">⭐ Recommended</span>
                                                    </h4>
                                                    <p>
                                                        Balance: <strong>
                                                            <fmt:formatNumber value="${wallet.balance}" type="number"
                                                                groupingUsed="true" maxFractionDigits="0" /> VND
                                                        </strong>
                                                        <c:if test="${wallet.balance < booking.totalAmount}">
                                                            <span class="text-danger">⚠️ Insufficient balance</span>
                                                            <a href="${pageContext.request.contextPath}/wallet/deposit"
                                                                class="deposit-link">Top up</a>
                                                        </c:if>
                                                    </p>
                                                </div>
                                            </label>

                                            <label
                                                class="method-option ${wallet.balance >= booking.totalAmount ? '' : 'selected'}">
                                                <input type="radio" name="paymentMethod" value="MOMO" ${wallet.balance>=
                                                booking.totalAmount ? '' : 'checked'}>
                                                <span class="method-icon">📱</span>
                                                <div class="method-info">
                                                    <h4>MoMo Wallet</h4>
                                                    <p>Quick payment via MoMo e-wallet</p>
                                                </div>
                                            </label>

                                            <label class="method-option">
                                                <input type="radio" name="paymentMethod" value="VNPAY">
                                                <span class="method-icon">🏦</span>
                                                <div class="method-info">
                                                    <h4>VNPay</h4>
                                                    <p>Payment via VNPay QR or bank card</p>
                                                </div>
                                            </label>

                                            <label class="method-option">
                                                <input type="radio" name="paymentMethod" value="BANK_TRANSFER">
                                                <span class="method-icon">💳</span>
                                                <div class="method-info">
                                                    <h4>Bank Transfer</h4>
                                                    <p>Direct transfer via Internet Banking</p>
                                                </div>
                                            </label>

                                            <label class="method-option">
                                                <input type="radio" name="paymentMethod" value="CREDIT_CARD">
                                                <span class="method-icon">💳</span>
                                                <div class="method-info">
                                                    <h4>Credit / Debit Card</h4>
                                                    <p>Visa, Mastercard, JCB</p>
                                                </div>
                                            </label>
                                        </div>

                                        <button type="submit" class="btn-pay" id="payButton">
                                            🔒 Pay
                                            <fmt:formatNumber value="${booking.totalAmount}" type="currency"
                                                currencySymbol="" /> VND
                                        </button>

                                        <a href="${pageContext.request.contextPath}/my_booking" class="btn-cancel">
                                            ← Back to bookings
                                        </a>

                                        <div class="secure-badge">
                                            🔐 <span>SSL secured transaction</span>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>

                    <%@ include file="../Components/Footer.jsp" %>

                        <script>
                            // Highlight selected payment method
                            document.querySelectorAll('.method-option').forEach(option => {
                                option.addEventListener('click', function () {
                                    document.querySelectorAll('.method-option').forEach(o => o.classList.remove('selected'));
                                    this.classList.add('selected');
                                });
                            });

                            // Disable button after click to prevent double submit
                            document.getElementById('paymentForm').addEventListener('submit', function () {
                                const btn = document.getElementById('payButton');
                                btn.disabled = true;
                                btn.textContent = '⏳ Processing...';
                            });
                        </script>
            </body>

            </html>