<%@ page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/Components/header.css" />

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
                        <li><a href="${pageContext.request.contextPath}/rooms">Rooms</a></li>
                        <li><a href="${pageContext.request.contextPath}/my_booking">My Booking</a></li>
                        <li><a href="${pageContext.request.contextPath}/customer/amenities">Room Amenities</a></li>

                        <c:if test="${not empty sessionScope.currentUser}">
                            <!-- Mobile User Menu -->
                            <li class="nav-auth-item mobile-only-auth">
                                <a href="${pageContext.request.contextPath}/customer/profile">Profile</a>
                            </li>
                            <li class="nav-auth-item mobile-only-auth">
                                <a href="javascript:void(0)" onclick="confirmLogout()" class="login-button">Logout</a>
                            </li>
                        </c:if>
                        <c:if test="${empty sessionScope.currentUser}">
                            <!-- Mobile Login Button -->
                            <li class="nav-auth-item mobile-only-auth">
                                <a href="login" class="login-button">Login</a>
                            </li>
                        </c:if>
                    </ul>

                    <div class="header-right desktop-only-auth">
                        <c:choose>
                            <c:when test="${not empty sessionScope.currentUser}">
                                <!-- Desktop User Menu -->
                                <div class="header-user" id="user-menu-trigger">
                                    <div class="user-avatar">${sessionScope.currentUser.fullName.substring(0,
                                        1).toUpperCase()}</div>
                                    <span class="user-name">Xin chào, ${sessionScope.currentUser.fullName}</span>
                                    <svg class="dropdown-icon" width="16" height="16" viewBox="0 0 16 16" fill="none"
                                        xmlns="http://www.w3.org/2000/svg">
                                        <path d="M4 6L8 10L12 6" stroke="currentColor" stroke-width="2"
                                            stroke-linecap="round" stroke-linejoin="round" />
                                    </svg>
                                    <ul class="dropdown-menu" id="user-dropdown">
                                        <li><a href="${pageContext.request.contextPath}/customer/profile">Profile</a>
                                        </li>
                                        <li><a href="javascript:void(0)" onclick="confirmLogout()">Logout</a></li>
                                    </ul>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <!-- Desktop Login Button -->
                                <a href="login" class="login-button">Login</a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </header>

            <script>
                // Đợi DOM load xong
                document.addEventListener('DOMContentLoaded', function () {

                    // Xử lý menu toggle cho mobile
                    const menuToggle = document.querySelector('.menu-toggle');
                    const mainNav = document.getElementById('main-nav');

                    if (menuToggle && mainNav) {
                        menuToggle.addEventListener('click', function (e) {
                            e.preventDefault();
                            mainNav.classList.toggle('open');
                            menuToggle.classList.toggle('is-active');
                        });
                    }

                    // Xử lý dropdown menu cho user
                    const userMenuTrigger = document.getElementById('user-menu-trigger');
                    const userDropdown = document.getElementById('user-dropdown');

                    if (userMenuTrigger && userDropdown) {
                        // Click vào user menu để toggle dropdown
                        userMenuTrigger.addEventListener('click', function (e) {
                            e.preventDefault();
                            e.stopPropagation();
                            userDropdown.classList.toggle('show');
                        });

                        // Click ra ngoài để đóng dropdown
                        document.addEventListener('click', function (e) {
                            if (!userMenuTrigger.contains(e.target)) {
                                userDropdown.classList.remove('show');
                            }
                        });

                        // Ngăn dropdown đóng khi click vào nó
                        userDropdown.addEventListener('click', function (e) {
                            e.stopPropagation();
                        });
                    }
                });

                function confirmLogout() {
                    Swal.fire({
                        title: 'Confirm Logout',
                        text: 'Are you sure you want to logout?',
                        icon: 'warning',
                        showCancelButton: true,
                        confirmButtonColor: '#dc3545',
                        cancelButtonColor: '#6c757d',
                        confirmButtonText: 'Yes, Logout',
                        cancelButtonText: 'Cancel'
                    }).then((result) => {
                        if (result.isConfirmed) {
                            window.location.href = '${pageContext.request.contextPath}/logout';
                        }
                    });
                }
            </script>
            <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>