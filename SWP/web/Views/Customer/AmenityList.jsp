<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                <title>Room Amenities - Hotel Management System</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/customer/style.css">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
                <style>
                    .amenity-container {
                        max-width: 1000px;
                        margin: 40px auto;
                        padding: 0 20px;
                    }

                    .amenity-header {
                        background: white;
                        padding: 30px;
                        border-radius: 15px;
                        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
                        margin-bottom: 30px;
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                    }

                    .amenity-header h2 {
                        color: #2c3e50;
                        margin: 0;
                        font-size: 24px;
                    }

                    .room-info {
                        color: #7f8c8d;
                        font-size: 16px;
                    }

                    .amenity-grid {
                        display: grid;
                        grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
                        gap: 25px;
                    }

                    .amenity-card {
                        background: white;
                        border-radius: 12px;
                        padding: 25px;
                        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.02);
                        transition: transform 0.2s, box-shadow 0.2s;
                        border: 1px solid #eee;
                        display: flex;
                        flex-direction: column;
                    }

                    .amenity-card:hover {
                        transform: translateY(-5px);
                        box-shadow: 0 8px 15px rgba(0, 0, 0, 0.1);
                    }

                    .amenity-icon {
                        width: 50px;
                        height: 50px;
                        background: #f8f9fa;
                        border-radius: 10px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        margin-bottom: 15px;
                        color: #3498db;
                        font-size: 24px;
                    }

                    .amenity-name {
                        font-size: 18px;
                        font-weight: 600;
                        color: #2c3e50;
                        margin-bottom: 10px;
                    }

                    .amenity-desc {
                        color: #7f8c8d;
                        font-size: 14px;
                        line-height: 1.5;
                        margin-bottom: 15px;
                        flex-grow: 1;
                    }

                    .amenity-footer {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        border-top: 1px solid #eee;
                        padding-top: 15px;
                        margin-top: auto;
                    }

                    .amenity-qty {
                        font-weight: 600;
                        color: #3498db;
                        background: rgba(52, 152, 219, 0.1);
                        padding: 5px 12px;
                        border-radius: 20px;
                        font-size: 14px;
                    }

                    .amenity-status {
                        font-size: 14px;
                        color: #27ae60;
                        display: flex;
                        align-items: center;
                        gap: 5px;
                    }

                    .amenity-status.issue {
                        color: #e74c3c;
                    }

                    .empty-state {
                        text-align: center;
                        padding: 50px;
                        background: white;
                        border-radius: 15px;
                        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
                    }

                    .empty-state i {
                        font-size: 60px;
                        color: #bdc3c7;
                        margin-bottom: 20px;
                    }

                    .empty-state h3 {
                        color: #2c3e50;
                        margin-bottom: 10px;
                    }

                    .empty-state p {
                        color: #7f8c8d;
                    }

                    .report-btn {
                        display: inline-block;
                        margin-top: 20px;
                        padding: 10px 20px;
                        background: #e74c3c;
                        color: white;
                        text-decoration: none;
                        border-radius: 8px;
                        transition: background 0.2s;
                    }

                    .report-btn:hover {
                        background: #c0392b;
                    }

                    .amenity-container {
                        max-width: 1000px;
                        margin: 40px auto;
                        padding: 0 20px;
                    }

                    .amenity-header {
                        background: white;
                        padding: 30px;
                        border-radius: 15px;
                        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
                        margin-bottom: 30px;
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                    }

                    .amenity-header h2 {
                        color: #2c3e50;
                        margin: 0;
                        font-size: 24px;
                    }

                    .room-info {
                        color: #7f8c8d;
                        font-size: 16px;
                    }

                    .amenity-grid {
                        display: grid;
                        grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
                        gap: 25px;
                    }

                    .amenity-card {
                        background: white;
                        border-radius: 12px;
                        padding: 25px;
                        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.02);
                        transition: transform 0.2s, box-shadow 0.2s;
                        border: 1px solid #eee;
                        display: flex;
                        flex-direction: column;
                    }

                    .amenity-card:hover {
                        transform: translateY(-5px);
                        box-shadow: 0 8px 15px rgba(0, 0, 0, 0.1);
                    }

                    .amenity-icon {
                        width: 50px;
                        height: 50px;
                        background: #f8f9fa;
                        border-radius: 10px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        margin-bottom: 15px;
                        color: #3498db;
                        font-size: 24px;
                    }

                    .amenity-name {
                        font-size: 18px;
                        font-weight: 600;
                        color: #2c3e50;
                        margin-bottom: 10px;
                    }

                    .amenity-desc {
                        color: #7f8c8d;
                        font-size: 14px;
                        line-height: 1.5;
                        margin-bottom: 15px;
                        flex-grow: 1;
                    }

                    .amenity-footer {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        border-top: 1px solid #eee;
                        padding-top: 15px;
                        margin-top: auto;
                    }

                    .amenity-qty {
                        font-weight: 600;
                        color: #3498db;
                        background: rgba(52, 152, 219, 0.1);
                        padding: 5px 12px;
                        border-radius: 20px;
                        font-size: 14px;
                    }

                    .amenity-status {
                        font-size: 14px;
                        color: #27ae60;
                        display: flex;
                        align-items: center;
                        gap: 5px;
                    }

                    .amenity-status.issue {
                        color: #e74c3c;
                    }

                    .empty-state {
                        text-align: center;
                        padding: 50px;
                        background: white;
                        border-radius: 15px;
                        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
                    }

                    .empty-state i {
                        font-size: 60px;
                        color: #bdc3c7;
                        margin-bottom: 20px;
                    }

                    .empty-state h3 {
                        color: #2c3e50;
                        margin-bottom: 10px;
                    }

                    .empty-state p {
                        color: #7f8c8d;
                    }

                    .report-btn {
                        display: inline-block;
                        margin-top: 20px;
                        padding: 10px 20px;
                        background: #e74c3c;
                        color: white;
                        text-decoration: none;
                        border-radius: 8px;
                        transition: background 0.2s;
                    }

                    .report-btn:hover {
                        background: #c0392b;
                    }
                </style>
            </head>

            <body>
                <jsp:include page="../Components/Header.jsp" />

                <div class="amenity-container">
                    <c:choose>
                        <c:when test="${not empty booking}">
                            <div class="amenity-header">
                                <div>
                                                <h2>Room Amenities</h2>
                                                <div class="room-info">
                                                    Room ${booking.room.roomNumber} -
                                                    ${booking.room.roomType.typeName}
                                                </div>
                                            </div>
                                            <a href="#" class="report-btn" id="openReportModalBtn">
                                                <i class="fas fa-exclamation-circle"></i> Report Issue
                                            </a>
                                        </div>

                                        <c:choose>
                                            <c:when test="${not empty amenityList}">
                                                <div class="amenity-grid">
                                                    <c:forEach items="${amenityList}" var="detail">
                                                        <div class="amenity-card">
                                                            <div class="amenity-icon">
                                                                <i class="fas fa-concierge-bell"></i>
                                                            </div>
                                                            <div class="amenity-name">${detail.amenity.name}</div>
                                                            <div class="amenity-desc">${detail.amenity.description}
                                                            </div>
                                                            <div class="amenity-footer">
                                                                <div class="amenity-qty">
                                                                    Qty: ${detail.quantityActual}
                                                                </div>
                                                                <div
                                                                    class="amenity-status ${detail.conditionStatus != 'OK' ? 'issue' : ''}">
                                                                    <c:choose>
                                                                        <c:when
                                                                            test="${detail.conditionStatus == 'OK'}">
                                                                            <i class="fas fa-check-circle"></i> Good
                                                                            Condition
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <i class="fas fa-exclamation-triangle"></i>
                                                                            ${detail.conditionStatus}
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="empty-state">
                                                    <i class="fas fa-box-open"></i>
                                                    <h3>No Amenities Listed</h3>
                                                    <p>There are no amenity records for this room inspection.</p>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="empty-state">
                                            <i class="fas fa-door-closed"></i>
                                            <h3>No Active Room Found</h3>
                                            <p>You need to be checked into a room to view amenities.</p>
                                            <a href="${pageContext.request.contextPath}/" class="report-btn"
                                                style="background: #3498db;">Back to Home</a>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                </div>

                <div id="reportModal" class="modal">
                    <div class="modal-content">
                        <span class="close">&times;</span>
                        <h2>Report an Issue</h2>
                        <form action="${pageContext.request.contextPath}/customer/amenities" method="POST">
                            <input type="hidden" name="action" value="report_issue">
                            <input type="hidden" name="bookingId" value="${booking.bookingId}">
                            <input type="hidden" name="roomId" value="${booking.roomId}">

                            <div class="form-group">
                                <label for="issueType">Issue Type</label>
                                <select name="issueType" id="issueType" required>
                                    <option value="SUPPLY">Missing Supply</option>
                                    <option value="EQUIPMENT">Equipment Malfunction</option>
                                    <option value="OTHER">Other</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="description">Description</label>
                                <textarea name="description" id="description" rows="4" required
                                    placeholder="Please describe the issue..."></textarea>
                            </div>

                            <button type="submit" class="submit-btn">Submit Report</button>
                        </form>
                    </div>
                </div>

                <style>
                    /* Modal Styles */
                    .modal {
                        display: none;
                        position: fixed;
                        z-index: 1000;
                        left: 0;
                        top: 0;
                        width: 100%;
                        height: 100%;
                        overflow: auto;
                        background-color: rgba(0, 0, 0, 0.5);
                        animation: fadeIn 0.3s;
                    }

                    .modal-content {
                        background-color: #fefefe;
                        margin: 10% auto;
                        padding: 30px;
                        border-radius: 15px;
                        width: 90%;
                        max-width: 500px;
                        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
                        position: relative;
                        animation: slideIn 0.3s;
                    }

                    @keyframes fadeIn {
                        from {
                            opacity: 0
                        }

                        to {
                            opacity: 1
                        }
                    }

                    @keyframes slideIn {
                        from {
                            transform: translateY(-50px);
                            opacity: 0
                        }

                        to {
                            transform: translateY(0);
                            opacity: 1
                        }
                    }

                    .close {
                        color: #aaa;
                        float: right;
                        font-size: 28px;
                        font-weight: bold;
                        cursor: pointer;
                        transition: color 0.2s;
                    }

                    .close:hover,
                    .close:focus {
                        color: #2c3e50;
                        text-decoration: none;
                    }

                    .modal h2 {
                        margin-top: 0;
                        color: #2c3e50;
                        margin-bottom: 20px;
                        font-size: 24px;
                    }

                    .form-group {
                        margin-bottom: 20px;
                    }

                    .form-group label {
                        display: block;
                        margin-bottom: 8px;
                        color: #2c3e50;
                        font-weight: 600;
                    }

                    .form-group select,
                    .form-group textarea {
                        width: 100%;
                        padding: 10px;
                        border: 1px solid #ddd;
                        border-radius: 8px;
                        font-family: inherit;
                        font-size: 14px;
                        transition: border-color 0.2s;
                    }

                    .form-group select:focus,
                    .form-group textarea:focus {
                        outline: none;
                        border-color: #3498db;
                    }

                    .submit-btn {
                        background: #e74c3c;
                        color: white;
                        border: none;
                        padding: 12px 25px;
                        border-radius: 8px;
                        cursor: pointer;
                        font-size: 16px;
                        width: 100%;
                        transition: background 0.2s;
                    }

                    .submit-btn:hover {
                        background: #c0392b;
                    }
                </style>

                <script>
                    // Get the modal
                    var modal = document.getElementById("reportModal");

                    // Get the button that opens the modal
                    var btn = document.getElementById("openReportModalBtn");

                    // Get the <span> element that closes the modal
                    var span = document.getElementsByClassName("close")[0];

                    // When the user clicks the button, open the modal 
                    if (btn) {
                        btn.onclick = function () {
                            modal.style.display = "block";
                        }
                    }

                    // When the user clicks on <span> (x), close the modal
                    span.onclick = function () {
                        modal.style.display = "none";
                    }

                    // When the user clicks anywhere outside of the modal, close it
                    window.onclick = function (event) {
                        if (event.target == modal) {
                            modal.style.display = "none";
                        }
                    }
                </script>

                <jsp:include page="../Components/Footer.jsp" />
                <jsp:include page="../public/notify.jsp" />
            </body>

            </html>