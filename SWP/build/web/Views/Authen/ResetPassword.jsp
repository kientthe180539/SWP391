<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Reset Password</title>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="CSS/Authen/reset_password.css" />
    </head>
    <body>

        <div class="reset-wrapper">
            <div class="reset-box">

                <h2 class="reset-title">Reset Password</h2>
                <p class="reset-desc">Enter your new password to complete the reset process.</p>

                <form>
                    <div class="form-group">
                        <label for="newPassword">New Password</label>
                        <input 
                            type="password" 
                            id="newPassword" 
                            name="newPassword" 
                            placeholder="Enter your new password"
                            required
                            />
                    </div>

                    <div class="form-group">
                        <label for="confirmPassword">Confirm Password</label>
                        <input 
                            type="password" 
                            id="confirmPassword" 
                            name="confirmPassword" 
                            placeholder="Re-enter your new password"
                            required
                            />
                    </div>

                    <button type="submit" class="reset-btn">Change Password</button>
                </form>

                <div class="reset-links">
                    <a href="login">← Back to Login</a>
                </div>

            </div>
        </div>

    </body>
</html>
