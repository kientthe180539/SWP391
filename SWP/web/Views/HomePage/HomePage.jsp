<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Royal Hotel - Luxury Experience & Premium Service</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/homepage.css">
            </head>

            <body>
                <!-- Include Header Component -->
                <%@ include file="../Components/Header.jsp" %>

                    <!-- Hero Banner Slider -->
                    <div class="hero-slider">
                        <!-- Slide 1 -->
                        <div class="slide active">
                            <img src="https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?w=1920&h=1080&fit=crop"
                                alt="Luxury Hotel">
                            <div class="slide-overlay">
                                <div class="slide-content">
                                    <h1>Welcome to Royal Hotel</h1>
                                    <p>Experience luxury and comfort at its finest</p>
                                    <a href="#rooms" class="cta-button">Book Now</a>
                                </div>
                            </div>
                        </div>

                        <!-- Slide 2 -->
                        <div class="slide">
                            <img src="https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=1920&h=1080&fit=crop"
                                alt="Hotel Room">
                            <div class="slide-overlay">
                                <div class="slide-content">
                                    <h1>Stunning Accommodations</h1>
                                    <p>Elegant rooms with modern amenities</p>
                                    <a href="#rooms" class="cta-button">Explore</a>
                                </div>
                            </div>
                        </div>

                        <!-- Slide 3 -->
                        <div class="slide">
                            <img src="https://images.unsplash.com/photo-1566073771259-6a8506099945?w=1920&h=1080&fit=crop"
                                alt="Hotel Pool">
                            <div class="slide-overlay">
                                <div class="slide-content">
                                    <h1>Premium Facilities</h1>
                                    <p>Infinity pool, spa, and fine dining restaurant</p>
                                    <a href="#features" class="cta-button">Learn More</a>
                                </div>
                            </div>
                        </div>

                        <!-- Slider Navigation Dots -->
                        <div class="slider-nav">
                            <span class="dot active" onclick="currentSlide(1)"></span>
                            <span class="dot" onclick="currentSlide(2)"></span>
                            <span class="dot" onclick="currentSlide(3)"></span>
                        </div>
                    </div>

                    <!-- About Section -->
                    <section class="about-section" id="about">
                        <div class="container">
                            <div class="section-title">
                                <h2>About Us</h2>
                                <p>Your perfect destination for an unforgettable stay</p>
                            </div>
                            <div class="about-content">
                                <div class="about-text">
                                    <h3>Royal Hotel - International Standards</h3>
                                    <p>
                                        Located in the heart of the city, Royal Hotel offers you a 5-star luxury
                                        experience with elegant rooms, modern facilities, and dedicated service.
                                    </p>
                                    <p>
                                        With over 200 beautifully designed rooms, fine dining restaurants serving
                                        international cuisine, infinity pool, spa, and state-of-the-art fitness center,
                                        we are committed to creating unforgettable memories for you.
                                    </p>
                                    <p>
                                        Our professional and friendly staff are available 24/7 to ensure all your
                                        needs are met to the highest standards.
                                    </p>
                                </div>
                                <div class="about-image">
                                    <img src="https://images.unsplash.com/photo-1584132967334-10e028bd69f7?w=800&h=600&fit=crop"
                                        alt="Hotel Lobby">
                                </div>
                            </div>

                            <!-- Features Grid -->
                            <div class="features-grid">
                                <div class="feature-card">
                                    <div class="feature-icon">🏊</div>
                                    <h4>Infinity Pool</h4>
                                    <p>Relax at our rooftop infinity pool with panoramic city views</p>
                                </div>
                                <div class="feature-card">
                                    <div class="feature-icon">🍽️</div>
                                    <h4>Fine Dining</h4>
                                    <p>Experience international cuisine prepared by renowned chefs</p>
                                </div>
                                <div class="feature-card">
                                    <div class="feature-icon">💆</div>
                                    <h4>Spa & Massage</h4>
                                    <p>Unwind with premium spa treatments and therapeutic massages</p>
                                </div>
                                <div class="feature-card">
                                    <div class="feature-icon">🏋️</div>
                                    <h4>Fitness Center</h4>
                                    <p>Stay fit with our modern, fully-equipped gym facilities</p>
                                </div>
                            </div>
                        </div>
                    </section>

                    <!-- Rooms Section -->
                    <section class="rooms-section" id="rooms">
                        <div class="container">
                            <div class="section-title">
                                <h2>Our Rooms</h2>
                                <p>Choose the perfect room for your needs</p>
                            </div>
                            <div class="rooms-grid">
                                <c:forEach items="${roomTypes}" var="type" varStatus="status" end="2">
                                    <div class="room-card">
                                        <div class="room-image">
                                            <img src="https://images.unsplash.com/photo-1611892440504-42a792e24d32?w=600&h=400&fit=crop"
                                                alt="Deluxe Room">
                                            <div class="room-price">
                                                <fmt:formatNumber value="${type.basePrice}" type="currency"
                                                    currencySymbol="₫" maxFractionDigits="0" />/night
                                            </div>
                                        </div>
                                        <div class="room-content">
                                            <h3>${type.typeName}</h3>
                                            <p>${type.description}</p>
                                            <div class="room-features">
                                                <span>👥 ${type.maxOccupancy} guests</span>
                                                <span>🛏️ Premium Bedding</span>
                                                <span>📺 Smart TV</span>
                                                <span>📶 Free Wi-Fi</span>
                                            </div>
                                            <a href="${pageContext.request.contextPath}/rooms" class="btn-book">View
                                                Details</a>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </section>

                    <!-- Testimonials Section -->
                    <section class="testimonials-section">
                        <div class="container">
                            <div class="section-title" style="color: white;">
                                <h2>Guest Reviews</h2>
                                <p style="color: rgba(255,255,255,0.9);">Real experiences from our valued guests</p>
                            </div>
                            <div class="testimonials-grid">
                                <div class="testimonial-card">
                                    <p class="testimonial-text">
                                        "Absolutely wonderful hotel! Clean rooms, excellent facilities, and incredibly
                                        friendly staff. Will definitely return."
                                    </p>
                                    <div class="testimonial-author">
                                        <div class="author-avatar">J</div>
                                        <div class="author-info">
                                            <h5>John Smith</h5>
                                            <p>Regular Guest</p>
                                        </div>
                                    </div>
                                </div>

                                <div class="testimonial-card">
                                    <p class="testimonial-text">
                                        "Stunning views from the room, delicious food, and professional service.
                                        Worth every penny!"
                                    </p>
                                    <div class="testimonial-author">
                                        <div class="author-avatar">S</div>
                                        <div class="author-info">
                                            <h5>Sarah Johnson</h5>
                                            <p>Traveler</p>
                                        </div>
                                    </div>
                                </div>

                                <div class="testimonial-card">
                                    <p class="testimonial-text">
                                        "Best vacation ever! Beautiful pool, relaxing spa, and attentive staff.
                                        Highly recommended!"
                                    </p>
                                    <div class="testimonial-author">
                                        <div class="author-avatar">M</div>
                                        <div class="author-info">
                                            <h5>Michael Chen</h5>
                                            <p>Business Traveler</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </section>

                    <!-- Include Footer Component -->
                    <%@ include file="../Components/Footer.jsp" %>

                        <!-- JavaScript for Slider -->
                        <script>
                            let slideIndex = 0;
                            let autoSlideTimer;

                            // Auto slide function
                            function autoSlide() {
                                slideIndex++;
                                showSlides(slideIndex);
                            }

                            // Show slides function
                            function showSlides(n) {
                                let slides = document.getElementsByClassName("slide");
                                let dots = document.getElementsByClassName("dot");

                                if (n > slides.length) { slideIndex = 1 }
                                if (n < 1) { slideIndex = slides.length }

                                for (let i = 0; i < slides.length; i++) {
                                    slides[i].classList.remove("active");
                                }
                                for (let i = 0; i < dots.length; i++) {
                                    dots[i].classList.remove("active");
                                }

                                slides[slideIndex - 1].classList.add("active");
                                dots[slideIndex - 1].classList.add("active");

                                // Reset timer
                                clearTimeout(autoSlideTimer);
                                autoSlideTimer = setTimeout(autoSlide, 5000); // Change slide every 5 seconds
                            }

                            // Manual slide control
                            function currentSlide(n) {
                                slideIndex = n;
                                showSlides(slideIndex);
                            }

                            // Initialize slider
                            slideIndex = 1;
                            showSlides(slideIndex);

                            // Smooth scrolling for anchor links
                            document.querySelectorAll('a[href^="#"]').forEach(anchor => {
                                anchor.addEventListener('click', function (e) {
                                    e.preventDefault();
                                    const target = document.querySelector(this.getAttribute('href'));
                                    if (target) {
                                        target.scrollIntoView({
                                            behavior: 'smooth',
                                            block: 'start'
                                        });
                                    }
                                });
                            });
                        </script>
            </body>

            </html>