<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Create Account</title>

        <link rel="stylesheet" href="CSS/Authen/register.css">
    </head>
    <body>

        <!-- Include Header -->
        <%@include file="../Components/Header.jsp" %>

        <main class="auth-main">
            <div class="auth-card">
                <div class="auth-header">
                    <div class="auth-logo">
                        <h2>Create New Account</h2>
                    </div>
                    <p class="auth-subtitle">Join our professional hotel management system.</p>
                </div>

                <form action="register" method="POST" class="auth-form">
                    <input type="hidden" name="action" value="register">

                    <div class="form-group">
                        <label for="username">User Name</label>
                        <input type="text" id="username" name="username" placeholder="VanA" value="${username}" required>
                    </div>

                    <div class="form-group">
                        <label for="fullName">Full Name</label>
                        <input type="text" id="fullName" name="fullName" placeholder="Nguyễn Văn A" value="${fullName}" required>
                    </div>

                    <!-- Phone Number -->
                    <div class="form-group">
                        <label for="phone">Phone Number</label>
                        <input type="text" id="phone" name="phone" placeholder="098 7654321" value="${phone}" required>
                    </div>

                    <div class="form-group">
                        <label for="email">Email</label>
                        <input type="email" id="email" name="email" placeholder="user@gmail.com" value="${email}" required>
                    </div>

                    <div class="form-group">
                        <label for="password">Password</label>
                        <input type="password" id="password" name="password" required>
                    </div>

                    <div class="form-group">
                        <label for="confirmPassword">Confirm Password</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" required>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="auth-button">Sign Up</button>
                    </div>
                </form>

                <div class="auth-footer-links">
                    <p>Already have an account? <a href="login">Log in now</a></p>
                </div>
            </div>
        </main>

        <!-- Include Footer -->
        <%@include file="../Components/Footer.jsp" %>
        <%@ include file="../public/notify.jsp" %>
    </body>
</html>
