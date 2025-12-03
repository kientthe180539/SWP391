<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Hotel Booking - Home</title>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="CSS/Home/home.css">
    </head>
    <body>

        <%-- Include Header Component --%>
        <%@ include file="../Components/Header.jsp" %>

        <main class="home-main">
            <!-- Hero / Search Section -->
            <section class="hero-section">
                <div class="hero-content">
                    <h1>Find Your Perfect Stay</h1>
                    <p>Search and book hotels easily with our platform.</p>
                </div>
                <div class="search-content">
                    <form class="search-form" action="searchRooms" method="get">
                        <div class="search-field">
                            <label>Check-in Date</label>
                            <input type="date" name="checkin" required />
                        </div>

                        <div class="search-field">
                            <label>Check-out Date</label>
                            <input type="date" name="checkout" required />
                        </div>

                        <div class="search-field narrow">
                            <label>Guests</label>
                            <input type="text" name="guests" value="2" min="1" />
                        </div>

                        <button type="submit" class="btn-primary">Search Rooms</button>
                    </form>
                </div>
            </section>

            <!-- Featured Rooms -->
            <section class="rooms-section">
                <h2 class="section-title">Featured Rooms</h2>

                <div class="rooms-wrapper">
                    <div class="rooms-cards">
                        <!-- Room 1 -->
                        <div class="room-card">
                            <img src="https://placehold.co/600x400/1d4ed8/FFFFFF?text=Deluxe+Room" alt="Deluxe Room" onerror="this.onerror=null;this.src='https://placehold.co/600x400/1d4ed8/FFFFFF?text=Placeholder+Image';" >
                            <div class="room-info">
                                <h3>Luxury Suite - Ho Chi Minh</h3>
                                <div class="room-rating">
                                    <span class="stars">★★★★★</span> (88 Reviews)
                                </div>
                                <p class="price">250.000₫ / night</p>
                                <div class="room-amenities">
                                    <span class="amenity">🛏️</span>
                                     <span title="Free Breakfast">🥐</span>
                                    <span class="amenity">📺 </span>
                                    <span class="amenity">🚿</span>
                                </div>
                                <a href="room-detail?id=1" class="btn-book">View Details</a>
                            </div>
                        </div>

                        <!-- Room 2 -->
                        <div class="room-card">
                            <img src="https://placehold.co/600x400/059669/FFFFFF?text=Family+Room" alt="Family Room" onerror="this.onerror=null;this.src='https://placehold.co/600x400/059669/FFFFFF?text=Placeholder+Image';" >
                            <div class="room-info">
                                <h3>Family Room - Da Nang</h3>
                                <div class="room-rating">
                                    <span class="stars">★★★★☆</span> (62 Reviews)
                                </div>
                                <p class="price">180.000₫ / night</p>
                                <div class="room-amenities">
                                    <span title="Free Wi-Fi">📶</span>
                                    <span title="Free Breakfast">🥐</span>
                                    <span title="Two Double Beds">🛏️🛏️</span>
                                </div>
                                <a href="room-detail" class="btn-book">View Details</a>
                            </div>
                        </div>

                        <!-- Room 3 -->
                        <div class="room-card">
                            <img src="https://placehold.co/600x400/9d174d/FFFFFF?text=Standard+Twin" alt="Standard Twin" onerror="this.onerror=null;this.src='https://placehold.co/600x400/9d174d/FFFFFF?text=Placeholder+Image';" >
                            <div class="room-info">
                                <h3>Standard Twin - Ha Noi</h3>
                                <div class="room-rating">
                                    <span class="stars">★★★☆☆</span> (45 Reviews)
                                </div>
                                <p class="price">120.000₫ / night</p>
                                <div class="room-amenities">
                                    <span title="Free Wi-Fi">📶</span>
                                    <span title="King Bed">🛌</span>
                                    <span title="Air Conditioning">❄️</span>
                                </div>
                                <a href="room-detail?id=3" class="btn-book">View Details</a>
                            </div>
                        </div>
                    </div>
                </div>
                <a href="rooms" class="btn-view-all">View all rooms</a>
            </section>
        </main>

        <%-- Include Footer Component --%>
        <%@ include file="../Components/Footer.jsp" %>
    </body>
</html>

