<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Login - Hotel System</title>

        <!-- Google Font -->
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

        <!-- Dùng chung CSS với Register -->
        <link rel="stylesheet" href="CSS/Authen/login.css">
    </head>

    <body class="auth-page">

        <%@include file="../Components/Header.jsp" %>

        <main class="auth-main">
            <div class="auth-card">

                <div class="auth-header">
                    <div class="auth-logo">
                        <h2>Welcome Back</h2>
                    </div>
                    <p class="auth-subtitle">Log in to continue using Hotel Management System</p>
                </div>

                <form class="auth-form" method="post" action="login">
                    <input type="hidden" name="action" value="login">

                    <div class="form-group">
                        <label>Email or Phone Number</label>
                        <input type="text" 
                               name="identifier" 
                               placeholder="you@gmail.com or 0912345678"
                               value="${identifier}"
                               required>
                    </div>

                    <div class="form-group">
                        <label>Password</label>
                        <input type="password" 
                               name="password"
                               placeholder="Enter your password"
                               required>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="auth-button">Sign In</button>
                    </div>

                    <div class="auth-footer-links">
                        <p>
                            Don’t have an account? 
                            <a href="register">Register now</a>
                        </p>
                        <p style="margin-top: 5px;">
                            <a href="forgotPassword">Forgot your password?</a>
                        </p>
                    </div>
                </form>

            </div>
        </main>

        <%@include file="../Components/Footer.jsp" %>
        <%@ include file="../public/notify.jsp" %>

    </body>
</html>
