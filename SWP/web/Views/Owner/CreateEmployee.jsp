<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Add Employee | HMS Owner</title>
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                rel="stylesheet">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
            <link rel="stylesheet" href="<c:url value='/CSS/housekeeping.css'/>">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
            <style>
                body {
                    font-family: 'Outfit', 'Inter', sans-serif;
                    background: linear-gradient(135deg, #f1f5f9 0%, #e2e8f0 100%);
                    min-height: 100vh;
                }

                .card {
                    background: #fff;
                    border-radius: 20px;
                    box-shadow: 0 10px 30px -5px rgba(0, 0, 0, 0.05);
                    border: 1px solid rgba(0, 0, 0, 0.02);
                    transition: transform 0.3s ease;
                }

                .card:hover {
                    box-shadow: 0 20px 40px -5px rgba(0, 0, 0, 0.1);
                }

                .card-header {
                    background: rgba(255, 255, 255, 0.95);
                    border-bottom: 2px solid #f1f5f9;
                    padding: 1.5rem;
                    border-radius: 20px 20px 0 0 !important;
                }

                .card-header h5 {
                    color: #0f172a;
                    font-weight: 700;
                    font-size: 1.25rem;
                }

                .form-label {
                    font-weight: 600;
                    color: #475569;
                    font-size: 0.85rem;
                    text-transform: uppercase;
                    letter-spacing: 0.5px;
                    margin-bottom: 0.5rem;
                }

                .form-control,
                .form-select {
                    padding: 0.75rem 1rem;
                    border-radius: 12px;
                    border: 2px solid #e2e8f0;
                    font-weight: 500;
                    background-color: #f8fafc;
                    transition: all 0.2s ease;
                }

                .form-control:focus,
                .form-select:focus {
                    border-color: #6366f1;
                    background-color: #fff;
                    box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.1);
                    outline: none;
                }

                .btn-primary {
                    background: linear-gradient(135deg, #0f172a 0%, #334155 100%);
                    color: white;
                    padding: 0.75rem 2rem;
                    border-radius: 12px;
                    font-weight: 600;
                    border: none;
                    transition: all 0.3s;
                    box-shadow: 0 4px 6px rgba(15, 23, 42, 0.2);
                }

                .btn-primary:hover {
                    background: linear-gradient(135deg, #1e293b 0%, #475569 100%);
                    transform: translateY(-2px);
                    box-shadow: 0 8px 12px rgba(15, 23, 42, 0.3);
                }

                .text-muted {
                    color: #64748b !important;
                    font-weight: 500;
                    transition: color 0.2s;
                }

                .text-muted:hover {
                    color: #0f172a !important;
                }
            </style>
        </head>

        <body>

            <div class="layout-wrapper">
                <jsp:include page="../Shared/OwnerSidebar.jsp" />

                <div class="main-content">
                    <jsp:include page="../Shared/Header.jsp" />

                    <div class="container-fluid py-4 px-4">
                        <div class="row justify-content-center">
                            <div class="col-md-8 col-lg-6">
                                <div class="card shadow-lg border-0">
                                    <div class="card-header bg-white py-3">
                                        <h5 class="mb-0"><i class="bi bi-person-plus-fill me-2 text-primary"></i>Add New
                                            Employee
                                        </h5>
                                    </div>
                                    <div class="card-body p-4">
                                        <form action="<c:url value='/owner/employees'/>" method="post">
                                            <input type="hidden" name="action" value="createEmployee" />

                                            <div class="row mb-3">
                                                <div class="col-md-6">
                                                    <label class="form-label">Username</label>
                                                    <input type="text" name="username" class="form-control" required
                                                        placeholder="e.g. johndoe" value="${formData.username}">
                                                </div>
                                                <div class="col-md-6">
                                                    <label class="form-label">Password</label>
                                                    <div class="input-group">
                                                        <input type="password" name="password" class="form-control"
                                                            required minlength="6" placeholder="Enter secure password"
                                                            id="passwordInput" style="border-right: 0;">
                                                        <button class="btn btn-outline-secondary" type="button"
                                                            onclick="togglePassword('passwordInput', this)"
                                                            style="border-color: #e2e8f0; background: #fff; border-left: 0;">
                                                            <i class="bi bi-eye"></i>
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="mb-3">
                                                <label class="form-label">Full Name</label>
                                                <input type="text" name="fullName" class="form-control" required
                                                    placeholder="e.g. John Doe" value="${formData.fullName}">
                                            </div>

                                            <div class="row mb-3">
                                                <div class="col-md-6">
                                                    <label class="form-label">Email</label>
                                                    <input type="email" name="email" class="form-control" required
                                                        placeholder="name@example.com" value="${formData.email}">
                                                </div>
                                                <div class="col-md-6">
                                                    <label class="form-label">Phone</label>
                                                    <input type="tel" name="phone" class="form-control" required
                                                        placeholder="e.g. 0901234567" value="${formData.phone}">
                                                </div>
                                            </div>

                                            <div class="mb-4">
                                                <label class="form-label">Role</label>
                                                <select name="roleId" class="form-select" required>
                                                    <option value="" disabled selected>-- Select Role --</option>
                                                    <option value="6">Manager</option>
                                                    <option value="2">Receptionist</option>
                                                    <option value="3">Housekeeping</option>
                                                </select>
                                            </div>

                                            <div class="d-flex justify-content-between align-items-center">
                                                <a href="<c:url value='/owner/employees'/>"
                                                    class="text-decoration-none text-muted">Cancel</a>
                                                <button type="submit" class="btn btn-primary px-4">
                                                    Create Employee
                                                </button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <jsp:include page="../Shared/Footer.jsp" />
                </div>
            </div>

            </div>
            </div>

            <%@ include file="../public/notify.jsp" %>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
                <script>
                    function togglePassword(inputId, btn) {
                        const input = document.getElementById(inputId);
                        const icon = btn.querySelector('i');

                        if (input.type === "password") {
                            input.type = "text";
                            icon.classList.remove('bi-eye');
                            icon.classList.add('bi-eye-slash');
                        } else {
                            input.type = "password";
                            icon.classList.remove('bi-eye-slash');
                            icon.classList.add('bi-eye');
                        }
                    }
                </script>
        </body>

        </html>