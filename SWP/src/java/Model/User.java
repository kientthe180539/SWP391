package Model;

import security.PasswordUtils;
import java.time.LocalDateTime;
import java.util.regex.Pattern;

public class User {

    // ==========================
    // Regex pattern
    // ==========================
    // Số điện thoại VN
    private static final Pattern PHONE_PATTERN = Pattern.compile(
            "^(?:\\+84|84|0)(3[2-9]|8[1-5]|7(?:[6-9]|0))\\d{1}([-.]?)\\d{3}\\2\\d{3}$"
    );

    // Email
    private static final Pattern EMAIL_PATTERN = Pattern.compile(
            "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"
    );

    // ==========================
    // FIELDS (GIỮ NGUYÊN NHƯ DB)
    // ==========================

    private Integer userId;
    private String username;
    private String passwordHash;   // CHỈ có field này, lưu HASH
    private String fullName;
    private String email;
    private String phone;
    private Integer roleId;
    private Boolean isActive;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public User() {
    }

    // Constructor này không bắt buộc truyền password (tùy bạn muốn dùng hay không)
    public User(Integer userId,
                String username,
                String fullName,
                String email,
                String phone,
                Integer roleId,
                Boolean isActive,
                LocalDateTime createdAt,
                LocalDateTime updatedAt) {

        setUserId(userId);
        setUsername(username);
        setFullName(fullName);
        setEmail(email);
        setPhone(phone);
        setRoleId(roleId);
        setActive(isActive != null ? isActive : Boolean.TRUE);
        setCreatedAt(createdAt);
        setUpdatedAt(updatedAt);
    }

    // ==========================
    // Getter / Setter + validate
    // ==========================

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId; // có thể null khi chưa insert DB
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        if (username == null || username.isBlank()) {
            throw new IllegalArgumentException("Username cannot be null or blank");
        }
        this.username = username.trim();
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    /**
     * Dùng khi MAPPING DB -> MODEL:
     * truyền trực tiếp hash lấy từ cột password_hash trong DB.
     */
    public void setPasswordHash(String passwordHash) {
        if (passwordHash == null || passwordHash.isBlank()) {
            throw new IllegalArgumentException("Password hash cannot be null or blank");
        }
        this.passwordHash = passwordHash;
    }

    /**
     * Dùng khi ĐĂNG KÝ / ĐỔI MẬT KHẨU:
     * nhận password thường, tự động hash rồi gán vào passwordHash.
     */
    public void setPlainPassword(String plainPassword) {
        if (plainPassword == null || plainPassword.isBlank()) {
            throw new IllegalArgumentException("Password cannot be null or blank");
        }
        if (plainPassword.length() < 6) {
            throw new IllegalArgumentException("Password must be at least 6 characters");
        }
        this.passwordHash = PasswordUtils.hashPassword(plainPassword);
    }

    /**
     * Dùng khi ĐĂNG NHẬP (nhận password thường từ form):
     * Model sẽ tự hash password input và so sánh với passwordHash đã lưu.
     */
    public boolean checkPasswordRaw(String plainPassword) {
        if (this.passwordHash == null) {
            throw new IllegalStateException("User has no password hash stored");
        }
        return PasswordUtils.matches(plainPassword, this.passwordHash);
    }

    /**
     * Nếu bạn đã hash sẵn ở ngoài (vd: ở service),
     * có thể truyền mã hash vào đây để so sánh trực tiếp.
     */
    public boolean checkPasswordHash(String inputHash) {
        if (this.passwordHash == null || inputHash == null) {
            return false;
        }
        return this.passwordHash.equals(inputHash);
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        if (fullName == null || fullName.isBlank()) {
            throw new IllegalArgumentException("Full name cannot be null or blank");
        }
        this.fullName = fullName.trim();
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        // Cho phép null hoặc rỗng
        if (email != null && !email.isBlank()) {
            String trimmed = email.trim();
            if (!EMAIL_PATTERN.matcher(trimmed).matches()) {
                throw new IllegalArgumentException("Email is not valid: " + email);
            }
            this.email = trimmed;
        } else {
            this.email = null;
        }
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        // Cho phép null hoặc rỗng
        if (phone != null && !phone.isBlank()) {
            String trimmed = phone.trim();
            if (!PHONE_PATTERN.matcher(trimmed).matches()) {
                throw new IllegalArgumentException("Phone number is not valid: " + phone);
            }
            this.phone = trimmed;
        } else {
            this.phone = null;
        }
    }

    public Integer getRoleId() {
        return roleId;
    }

    public void setRoleId(Integer roleId) {
        if (roleId == null) {
            throw new IllegalArgumentException("Role id cannot be null");
        }
        this.roleId = roleId;
    }

    public Boolean getActive() {
        return isActive;
    }

    public void setActive(Boolean active) {
        isActive = (active == null) ? Boolean.TRUE : active;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    // ==========================
    // toString
    // ==========================

    @Override
    public String toString() {
        return "User{" +
                "userId=" + userId +
                ", username='" + username + '\'' +
                ", fullName='" + fullName + '\'' +
                ", email='" + email + '\'' +
                ", phone='" + phone + '\'' +
                ", roleId=" + roleId +
                ", isActive=" + isActive +
                '}';
    }
}
