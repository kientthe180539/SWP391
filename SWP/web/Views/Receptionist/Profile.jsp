<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!DOCTYPE html>
                <html>

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>My Profile - Receptionist</title>
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/receptionist.css">
                    <style>
                        .profile-container {
                            max-width: 800px;
                            margin: 0 auto;
                        }

                        .profile-card {
                            background: white;
                            border-radius: 12px;
                            padding: 30px;
                            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                            margin-bottom: 20px;
                        }

                        .profile-header {
                            text-align: center;
                            padding-bottom: 20px;
                            border-bottom: 2px solid #e0e0e0;
                            margin-bottom: 30px;
                        }

                        .profile-avatar-large {
                            width: 100px;
                            height: 100px;
                            border-radius: 50%;
                            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
                            color: white;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            font-size: 40px;
                            font-weight: bold;
                            margin: 0 auto 15px;
                        }

                        .form-group {
                            margin-bottom: 20px;
                        }

                        .form-group label {
                            display: block;
                            margin-bottom: 8px;
                            font-weight: 600;
                            color: #333;
                        }

                        .form-group input {
                            width: 100%;
                            padding: 12px;
                            border: 2px solid #e0e0e0;
                            border-radius: 8px;
                            font-size: 14px;
                            transition: border-color 0.3s;
                        }

                        .form-group input:focus {
                            outline: none;
                            border-color: #1e3c72;
                        }

                        .form-group input:disabled {
                            background: #f8f9fa;
                            cursor: not-allowed;
                        }

                        .info-badge {
                            display: inline-block;
                            padding: 6px 12px;
                            background: #e3f2fd;
                            color: #1976d2;
                            border-radius: 6px;
                            font-size: 13px;
                            font-weight: 600;
                        }

                        .button-group {
                            display: flex;
                            gap: 10px;
                            margin-top: 30px;
                        }
                    </style>
                </head>

                <body>
                    <header>
                        <div class="logo">🏨 Hotel Management</div>
                        <div class="header-right">
                            <div class="nav-links">
                                <a href="${pageContext.request.contextPath}/receptionist/dashboard">Dashboard</a>
                                <a href="${pageContext.request.contextPath}/reservation_approval">Approvals</a>
                                <a href="${pageContext.request.contextPath}/receptionist/reservations">Reservations</a>
                                <a href="${pageContext.request.contextPath}/receptionist/checkinout">Check-in/out</a>
                                <a href="${pageContext.request.contextPath}/receptionist/room-status">Rooms</a>
                                <a href="${pageContext.request.contextPath}/receptionist/profile"
                                    class="active">Profile</a>
                                <a href="${pageContext.request.contextPath}/logout">Logout</a>
                            </div>
                            <div class="staff-profile">
                                <span>${sessionScope.currentUser.fullName}</span>
                                <div class="staff-avatar">${fn:substring(sessionScope.currentUser.fullName, 0, 2)}</div>
                            </div>
                        </div>
                    </header>

                    <div class="container">
                        <div class="profile-container">
                            <h1 class="page-title">👤 My Profile</h1>

                            <!-- Messages -->
                            <jsp:include page="../public/notify.jsp" />

                            <!-- Profile Card -->
                            <div class="profile-card">
                                <div class="profile-header">
                                    <div class="profile-avatar-large">
                                        ${fn:substring(profile.fullName, 0, 2)}
                                    </div>
                                    <h2 style="margin: 10px 0; color: #1e3c72;">${profile.fullName}</h2>
                                    <span class="info-badge">${profile.roleName}</span>
                                </div>

                                <form method="post" action="${pageContext.request.contextPath}/receptionist/profile">

                                    <div class="form-group">
                                        <label>Full Name *</label>
                                        <input type="text" name="fullName" value="${profile.fullName}" required>
                                    </div>

                                    <div class="form-group">
                                        <label>Email Address *</label>
                                        <input type="email" name="email" value="${profile.email}" required>
                                    </div>

                                    <div class="form-group">
                                        <label>Phone Number *</label>
                                        <input type="tel" name="phone" value="${profile.phone}" required>
                                    </div>

                                    <div class="form-group">
                                        <label>Role</label>
                                        <input type="text" value="${profile.roleName}" disabled>
                                    </div>

                                    <div class="form-group">
                                        <label>Account Created</label>
                                        <input type="text"
                                            value="<fmt:formatDate value='${profile.createdAt}' pattern='yyyy-MM-dd HH:mm'/>"
                                            disabled>
                                    </div>

                                    <div class="button-group">
                                        <button type="submit" class="btn btn-primary" style="flex: 1;">
                                            💾 Save Changes
                                        </button>
                                        <a href="${pageContext.request.contextPath}/receptionist/change-password"
                                            class="btn btn-approve" style="flex: 1; text-align: center;">
                                            🔒 Change Password
                                        </a>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <footer>
                        <p>&copy; 2025 Hotel Management System. All rights reserved.</p>
                    </footer>
                </body>

                </html>