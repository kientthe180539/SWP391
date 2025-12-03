<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<link rel="stylesheet" href="CSS/Components/header.css" />

<header class="header">
    <div class="header-container">

        <a href="home" class="header-logo">
            <span>Hotel Manager</span>
        </a>

        <button class="menu-toggle" aria-label="Toggle navigation">
            <span class="bar"></span>
            <span class="bar"></span>
            <span class="bar"></span>
        </button>

        <ul class="header-nav" id="main-nav">
            <li><a href="home">Home</a></li>
            <li><a href="rooms">Rooms</a></li>
            <li><a href="my_booking">My Booking</a></li>
            <li class="nav-auth-item mobile-only-auth"> 
                <a href="login" class="login-button">Login</a>
            </li>
        </ul>

        <div class="header-right desktop-only-auth"> 
            <a href="login" class="login-button">Login</a>
        </div>
    </div>
</header>

<script>
    // Lấy các phần tử cần thiết
    const menuToggle = document.querySelector('.menu-toggle');
    const mainNav = document.getElementById('main-nav');

    // Thêm sự kiện click cho nút hamburger
    menuToggle.addEventListener('click', () => {
        // Chuyển đổi class 'open' trên menu để hiện/ẩn
        mainNav.classList.toggle('open');
        menuToggle.classList.toggle('is-active');
    });
</script>