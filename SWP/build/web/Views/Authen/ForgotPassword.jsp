<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Forgot Password</title>
        <link rel="stylesheet" href="CSS/Authen/forgot_password.css" />
    </head>
    <body>

        <div class="forgot-wrapper">
            <div class="forgot-box">

                <h2 class="forgot-title">Forgot Password</h2>
                <p class="forgot-desc">Enter your email to receive a password reset link.</p>

                <form>
                    <div class="form-group">
                        <label for="email">Email</label>
                        <input 
                            type="email" 
                            id="email" 
                            name="email" 
                            placeholder="Enter your email"
                            required
                            />
                    </div>
                    <button type="submit" class="forgot-btn">Send Request</button>
                </form>

                <div class="forgot-links">
                    <a href="login">← Back to Login</a>
                </div>

            </div>
        </div>

    </body>
</html>