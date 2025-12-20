<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

    <!-- SweetAlert2 -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <script>
        document.addEventListener("DOMContentLoaded", function () {

            // Check request attributes first, then session attributes
            let type = "${type}".trim().toString();
            let mess = "${mess}".trim().toString();
            const href = "${href}".trim().toString();

            // Also check session-based success/error messages
            const sessionSuccess = "${sessionScope.success}".trim().toString();
            const sessionError = "${sessionScope.error}".trim().toString();

            if (sessionSuccess && sessionSuccess !== "") {
                type = "success";
                mess = sessionSuccess;
            } else if (sessionError && sessionError !== "") {
                type = "error";
                mess = sessionError;
            }

            if (type === "success") {
                if (href) {
                    Swal.fire({
                        icon: 'success',
                        title: 'Success',
                        text: mess,
                        timer: 2000,
                        showConfirmButton: true
                    }).then(() => {
                        if (href) {
                            window.location.href = href;
                        }
                    });
                }
                else {
                    Swal.fire({
                        icon: 'success',
                        title: 'Success',
                        text: mess,
                        timer: 2000,
                        showConfirmButton: true
                    });
                }
            }
            else if (type === "error") {
                if (href) {
                    Swal.fire({
                        icon: 'error',
                        title: 'Error',
                        text: mess,
                        timer: 2000,
                        showConfirmButton: true
                    }).then(() => {
                        if (href) {
                            window.location.href = href;
                        }
                    });
                }
                else {
                    Swal.fire({
                        icon: 'error',
                        title: 'Error',
                        text: mess,
                        timer: 2000,
                        showConfirmButton: true
                    });
                }

            }
        });
    </script>

    <!-- Clear session messages after display -->
    <c:remove var="success" scope="session" />
    <c:remove var="error" scope="session" />