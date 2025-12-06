<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <div class="toast-container position-fixed top-0 end-0 p-3" style="z-index: 1050">
            <c:if test="${not empty mess}">
                <div id="liveToast"
                    class="toast align-items-center text-white bg-${type == 'success' ? 'success' : 'danger'} border-0"
                    role="alert" aria-live="assertive" aria-atomic="true">
                    <div class="d-flex">
                        <div class="toast-body">
                            <i class="bi ${type == 'success' ? 'bi-check-circle' : 'bi-exclamation-circle'} me-2"></i>
                            ${mess}
                        </div>
                        <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"
                            aria-label="Close"></button>
                    </div>
                </div>
                <script>
                    document.addEventListener('DOMContentLoaded', function () {
                        var toastEl = document.getElementById('liveToast');
                        var toast = new bootstrap.Toast(toastEl);
                        toast.show();
                    });
                </script>
            </c:if>
        </div>