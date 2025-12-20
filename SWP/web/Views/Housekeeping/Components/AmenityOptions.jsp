<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <option value="" disabled selected>Select Amenity</option>
        <c:if test="${empty roomAmenities}">
            <option value="" disabled>No amenities found for this room</option>
        </c:if>
        <c:forEach items="${roomAmenities}" var="ra">
            <option value="${ra.amenityId}" data-max="${ra.defaultQuantity}" data-price="${ra.amenity.price}">
                ${ra.amenity.name} (Max: ${ra.defaultQuantity})
            </option>
        </c:forEach>