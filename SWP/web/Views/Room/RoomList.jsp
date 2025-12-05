<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Room List</title>
        <link rel="stylesheet" href="CSS/Authen/login.css" />
        <link rel="stylesheet" href="CSS/Pages/room-list.css" />
    </head>
    <body>
        <%@ include file="./../Components/Header.jsp" %>

        <div class="room-container">
            <div class="breadcrumb">
                <a href="home">Home</a>
                <span>/</span>
                <span class="current">Room List</span>
            </div>

            <div class="room-header">
                <h1>Room List</h1>
                <p>Find and view available rooms</p>
            </div>

            <!-- Search & Filter Section -->
            <div class="search-section">
                <form class="search-form" method="GET" action="rooms">
                    <div class="search-group">
                        <label for="room-type">Room Type</label>
                        <select id="room-type" name="roomType" class="search-input">
                            <option value="">-- All Types --</option>
                            <c:forEach var="type" items="${roomTypes}">
                                <option value="${type.roomTypeId}" 
                                        ${type.roomTypeId == selectedType ? 'selected' : ''}>
                                    ${type.typeName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="search-group">
                        <label for="min-price">Min Price</label>
                        <input type="number" id="min-price" name="minPrice" class="search-input"
                               value="${minPrice != null ? minPrice : ''}" placeholder="₫">
                    </div>

                    <div class="search-group">
                        <label for="max-price">Max Price</label>
                        <input type="number" id="max-price" name="maxPrice" class="search-input"
                               value="${maxPrice != null ? maxPrice : ''}" placeholder="₫">
                    </div>
                    <button type="submit" class="btn btn-primary search-btn">Search</button>
                </form>
            </div>

            <!-- Room List -->
            <div class="room-list">
                <c:choose>
                    <c:when test="${not empty rooms}">
                        <c:forEach var="entry" items="${rooms}">
                            <c:set var="room" value="${entry.key}" />
                            <c:set var="type" value="${entry.value}" />
                            <div class="room-card">
                                <div class="room-image">
                                    <img src="${room.imageUrl != null ? room.imageUrl : '/placeholder.svg?height=250&width=350'}" 
                                         alt="${type.typeName}">
                                    <span class="room-type-badge">${type.typeName}</span>
                                </div>
                                <div class="room-info">
                                    <h3>Room ${room.roomNumber}</h3>
                                    <p class="room-description">${room.description}</p>
                                    <p class="room-description">${type.maxOccupancy}</p>
                                    <div class="room-footer">
                                        <div class="room-price">
                                            <span class="price">${type.basePrice}₫</span>
                                            <span class="per-night">/Night</span>
                                        </div>
                                        <a href="room-detail?id=${room.roomId}" class="btn btn-secondary">View Details</a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="no-results">
                            <p>No suitable rooms found. Please try again with different criteria.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Pagination -->
            <div class="pagination">
                <c:if test="${currentPage > 1}">
                    <a href="rooms?page=${currentPage - 1}&roomType=${selectedType}" class="page-link">&laquo; Prev</a>
                </c:if>

                <c:forEach begin="1" end="${totalPage}" var="i">
                    <a href="rooms?page=${i}&roomType=${selectedType}" 
                       class="page-link ${i == currentPage ? 'active' : ''}">${i}</a>
                </c:forEach>

                <c:if test="${currentPage < totalPage}">
                    <a href="rooms?page=${currentPage + 1}&roomType=${selectedType}" class="page-link">Next &raquo;</a>
                </c:if>
            </div>

            <!-- No Results Message (Hidden by default) -->
            <div class="no-results" style="display: none;">
                <p>No suitable rooms found. Please try again with different criteria.</p>
            </div>
        </div>

        <%@ include file="./../Components/Footer.jsp" %>
        <%@ include file="./../public/notify.jsp" %>
    </body>
    <script>
        const roomsPerPage = 3; // number of rooms per page
        const rooms = document.querySelectorAll('.room-card');
        const pageLinks = document.querySelectorAll('.page-link[data-page]');
        const prevBtn = document.getElementById('prevPage');
        const nextBtn = document.getElementById('nextPage');

        let currentPage = 1;
        const totalPages = Math.ceil(rooms.length / roomsPerPage);

        function showPage(page) {
            if (page < 1 || page > totalPages)
                return;

            currentPage = page;

            rooms.forEach((room, index) => {
                room.style.display =
                        index >= (page - 1) * roomsPerPage &&
                        index < page * roomsPerPage
                        ? 'block'
                        : 'none';
            });

            pageLinks.forEach(link => {
                link.classList.toggle(
                        'active',
                        Number(link.dataset.page) === page
                        );
            });
        }

        pageLinks.forEach(link => {
            link.addEventListener('click', e => {
                e.preventDefault();
                showPage(Number(link.dataset.page));
            });
        });

        prevBtn.addEventListener('click', e => {
            e.preventDefault();
            showPage(currentPage - 1);
        });

        nextBtn.addEventListener('click', e => {
            e.preventDefault();
            showPage(currentPage + 1);
        });

        showPage(1); // initialize
    </script>
</html>
