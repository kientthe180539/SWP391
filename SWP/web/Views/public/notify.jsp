<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- SweetAlert2 -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
    document.addEventListener("DOMContentLoaded", function () {

        const type = "${type}".trim().toString();
        const mess = "${mess}".trim().toString();
        const href = "${href}".trim().toString();

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
