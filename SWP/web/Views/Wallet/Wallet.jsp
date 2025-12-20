<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Luxe Wallet - Hotel Management</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/Booking/booking.css">
                <style>
                    .wallet-container {
                        max-width: 900px;
                        margin: 40px auto;
                        padding: 0 20px;
                    }

                    .wallet-card {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        border-radius: 20px;
                        padding: 30px;
                        color: white;
                        margin-bottom: 30px;
                        box-shadow: 0 10px 40px rgba(102, 126, 234, 0.4);
                    }

                    .wallet-header {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        margin-bottom: 20px;
                    }

                    .wallet-title {
                        font-size: 18px;
                        opacity: 0.9;
                    }

                    .wallet-logo {
                        font-size: 28px;
                    }

                    .wallet-balance-label {
                        font-size: 14px;
                        opacity: 0.8;
                        margin-bottom: 5px;
                    }

                    .wallet-balance {
                        font-size: 42px;
                        font-weight: 700;
                        letter-spacing: -1px;
                    }

                    .wallet-balance small {
                        font-size: 20px;
                        font-weight: 400;
                    }

                    .wallet-actions {
                        display: flex;
                        gap: 15px;
                        margin-top: 25px;
                    }

                    .btn-wallet {
                        flex: 1;
                        padding: 14px 20px;
                        border-radius: 12px;
                        font-size: 16px;
                        font-weight: 600;
                        text-decoration: none;
                        text-align: center;
                        transition: all 0.3s ease;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        gap: 8px;
                    }

                    .btn-deposit {
                        background: rgba(255, 255, 255, 0.2);
                        color: white;
                        border: 2px solid rgba(255, 255, 255, 0.3);
                    }

                    .btn-deposit:hover {
                        background: rgba(255, 255, 255, 0.3);
                        transform: translateY(-2px);
                    }

                    .btn-book {
                        background: white;
                        color: #667eea;
                    }

                    .btn-book:hover {
                        background: #f8f9fa;
                        transform: translateY(-2px);
                    }

                    .section-title {
                        font-size: 20px;
                        font-weight: 600;
                        color: #333;
                        margin-bottom: 20px;
                        display: flex;
                        align-items: center;
                        gap: 10px;
                    }

                    .transactions-card {
                        background: white;
                        border-radius: 15px;
                        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
                        overflow: hidden;
                    }

                    .transaction-list {
                        list-style: none;
                        padding: 0;
                        margin: 0;
                    }

                    .transaction-item {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        padding: 18px 25px;
                        border-bottom: 1px solid #f0f0f0;
                        transition: background 0.2s;
                    }

                    .transaction-item:last-child {
                        border-bottom: none;
                    }

                    .transaction-item:hover {
                        background: #f9f9f9;
                    }

                    .transaction-info {
                        display: flex;
                        align-items: center;
                        gap: 15px;
                    }

                    .transaction-icon {
                        width: 45px;
                        height: 45px;
                        border-radius: 12px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-size: 20px;
                    }

                    .icon-deposit {
                        background: #e8f5e9;
                        color: #2e7d32;
                    }

                    .icon-payment {
                        background: #fff3e0;
                        color: #ef6c00;
                    }

                    .icon-refund {
                        background: #e3f2fd;
                        color: #1565c0;
                    }

                    .transaction-details h4 {
                        margin: 0 0 4px 0;
                        font-size: 15px;
                        color: #333;
                    }

                    .transaction-details p {
                        margin: 0;
                        font-size: 13px;
                        color: #888;
                    }

                    .transaction-amount {
                        text-align: right;
                    }

                    .amount-value {
                        font-size: 16px;
                        font-weight: 600;
                    }

                    .amount-positive {
                        color: #2e7d32;
                    }

                    .amount-negative {
                        color: #d32f2f;
                    }

                    .amount-balance {
                        font-size: 12px;
                        color: #999;
                        margin-top: 3px;
                    }

                    .empty-state {
                        padding: 60px 20px;
                        text-align: center;
                        color: #888;
                    }

                    .empty-state .icon {
                        font-size: 48px;
                        margin-bottom: 15px;
                        opacity: 0.5;
                    }

                    .alert {
                        padding: 15px 20px;
                        border-radius: 10px;
                        margin-bottom: 20px;
                        display: flex;
                        align-items: center;
                        gap: 10px;
                    }

                    .alert-success {
                        background: #d4edda;
                        color: #155724;
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
                        <div class="wallet-container">

                            <!-- Success/Error Messages -->
                            <c:if test="${not empty sessionScope.success}">
                                <div class="alert alert-success">
                                    ✅ ${sessionScope.success}
                                </div>
                                <c:remove var="success" scope="session" />
                            </c:if>
                            <c:if test="${not empty sessionScope.error}">
                                <div class="alert alert-error">
                                    ⚠️ ${sessionScope.error}
                                </div>
                                <c:remove var="error" scope="session" />
                            </c:if>

                            <!-- Wallet Card -->
                            <div class="wallet-card">
                                <div class="wallet-header">
                                    <span class="wallet-title">💎 Luxe Wallet</span>
                                    <span class="wallet-logo">🏨</span>
                                </div>
                                <div class="wallet-balance-label">Available balance</div>
                                <div class="wallet-balance">
                                    <fmt:formatNumber value="${wallet.balance}" type="number" groupingUsed="true"
                                        maxFractionDigits="0" />
                                    <small>VND</small>
                                </div>
                                <div class="wallet-actions">
                                    <a href="${pageContext.request.contextPath}/wallet/deposit"
                                        class="btn-wallet btn-deposit">
                                        💰 Top up
                                    </a>
                                    <a href="${pageContext.request.contextPath}/rooms" class="btn-wallet btn-book">
                                        🛏️ Book room
                                    </a>
                                </div>
                            </div>

                            <!-- Transaction History -->
                            <h2 class="section-title">📜 Transaction history</h2>
                            <div class="transactions-card">
                                <c:choose>
                                    <c:when test="${empty transactions}">
                                        <div class="empty-state">
                                            <div class="icon">📭</div>
                                            <p>No transactions yet</p>
                                            <p style="font-size: 13px;">Top up your wallet to start booking rooms!</p>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <ul class="transaction-list">
                                            <c:forEach items="${transactions}" var="txn">
                                                <li class="transaction-item">
                                                    <div class="transaction-info">
                                                        <div class="transaction-icon 
                                            <c:choose>
                                                <c:when test=" ${txn.transactionType=='DEPOSIT' }">icon-deposit
                                                            </c:when>
                                                            <c:when test="${txn.transactionType == 'PAYMENT'}">
                                                                icon-payment</c:when>
                                                            <c:when test="${txn.transactionType == 'REFUND'}">
                                                                icon-refund</c:when>
                                </c:choose>">
                                <c:choose>
                                    <c:when test="${txn.transactionType == 'DEPOSIT'}">💰</c:when>
                                    <c:when test="${txn.transactionType == 'PAYMENT'}">💳</c:when>
                                    <c:when test="${txn.transactionType == 'REFUND'}">↩️</c:when>
                                </c:choose>
                            </div>
                            <div class="transaction-details">
                                <h4>${txn.typeDisplayName}</h4>
                                <p>
                                    ${txn.description}
                                    <c:if test="${txn.referenceId != null}">
                                        • Booking #${txn.referenceId}
                                    </c:if>
                                </p>
                            </div>
                        </div>
                        <div class="transaction-amount">
                            <div class="amount-value 
                                            <c:choose>
                                                <c:when test=" ${txn.transactionType=='PAYMENT' }">amount-negative
                                </c:when>
                                <c:otherwise>amount-positive</c:otherwise>
                                </c:choose>">
                                <c:choose>
                                    <c:when test="${txn.transactionType == 'PAYMENT'}">-</c:when>
                                    <c:otherwise>+</c:otherwise>
                                </c:choose>
                                <fmt:formatNumber value="${txn.amount}" type="number" groupingUsed="true"
                                    maxFractionDigits="0" /> đ
                            </div>
                            <div class="amount-balance">
                                Balance:
                                <fmt:formatNumber value="${txn.balanceAfter}" type="number" groupingUsed="true"
                                    maxFractionDigits="0" /> đ
                            </div>
                        </div>
                        </li>
                        </c:forEach>
                        </ul>
                        </c:otherwise>
                        </c:choose>
                    </div>
                    </div>
                    </div>

                    <%@ include file="../Components/Footer.jsp" %>
            </body>

            </html>