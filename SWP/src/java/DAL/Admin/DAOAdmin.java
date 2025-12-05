package DAL.Admin;

import DAL.DBContext;
import Model.User;
import security.PasswordUtils;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DAOAdmin extends DBContext {
    
    public static final DAOAdmin INSTANCE = new DAOAdmin();
    
    private DAOAdmin() {
    }
    
    // ==========================================
    // DASHBOARD METRICS
    // ==========================================
    
    public int getTotalAccounts() {
        String sql = "SELECT COUNT(*) FROM users";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOAdmin.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }
    
    // ==========================================
    // USER MANAGEMENT (Advanced)
    // ==========================================
    
    public List<User> getUsers(String search, String roleIdStr, String statusStr, 
                               String sortBy, String sortOrder, int page, int pageSize) {
        List<User> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM users WHERE 1=1");
        
        if (search != null && !search.isBlank()) {
            sql.append(" AND (username LIKE ? OR full_name LIKE ? OR email LIKE ? OR phone LIKE ?)");
        }
        if (roleIdStr != null && !roleIdStr.isBlank()) {
            sql.append(" AND role_id = ?");
        }
        if (statusStr != null && !statusStr.isBlank()) {
            sql.append(" AND is_active = ?");
        }
        
        // Sorting
        if (sortBy == null || sortBy.isBlank()) sortBy = "user_id";
        if (sortOrder == null || sortOrder.isBlank()) sortOrder = "ASC";
        
        String validSort = switch (sortBy) {
            case "username" -> "username";
            case "fullName" -> "full_name";
            case "roleId" -> "role_id";
            case "status" -> "is_active";
            default -> "user_id";
        };
        
        sql.append(" ORDER BY ").append(validSort).append(" ").append("DESC".equalsIgnoreCase(sortOrder) ? "DESC" : "ASC");
        
        // Pagination
        if (page > 0 && pageSize > 0) {
            sql.append(" LIMIT ? OFFSET ?");
        }
        
        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            if (search != null && !search.isBlank()) {
                String kw = "%" + search + "%";
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
            }
            if (roleIdStr != null && !roleIdStr.isBlank()) {
                ps.setInt(idx++, Integer.parseInt(roleIdStr));
            }
            if (statusStr != null && !statusStr.isBlank()) {
                ps.setBoolean(idx++, Boolean.parseBoolean(statusStr));
            }
            if (page > 0 && pageSize > 0) {
                ps.setInt(idx++, pageSize);
                ps.setInt(idx++, (page - 1) * pageSize);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    User u = new User();
                    u.setUserId(rs.getInt("user_id"));
                    u.setUsername(rs.getString("username"));
                    u.setFullName(rs.getString("full_name"));
                    u.setEmail(rs.getString("email"));
                    u.setPhone(rs.getString("phone"));
                    u.setRoleId(rs.getInt("role_id"));
                    u.setActive(rs.getBoolean("is_active"));
                    list.add(u);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOAdmin.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }
    
    public int countUsers(String search, String roleIdStr, String statusStr) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM users WHERE 1=1");
        
        if (search != null && !search.isBlank()) {
            sql.append(" AND (username LIKE ? OR full_name LIKE ? OR email LIKE ? OR phone LIKE ?)");
        }
        if (roleIdStr != null && !roleIdStr.isBlank()) {
            sql.append(" AND role_id = ?");
        }
        if (statusStr != null && !statusStr.isBlank()) {
            sql.append(" AND is_active = ?");
        }
        
        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            if (search != null && !search.isBlank()) {
                String kw = "%" + search + "%";
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
            }
            if (roleIdStr != null && !roleIdStr.isBlank()) {
                ps.setInt(idx++, Integer.parseInt(roleIdStr));
            }
            if (statusStr != null && !statusStr.isBlank()) {
                ps.setBoolean(idx++, Boolean.parseBoolean(statusStr));
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOAdmin.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }
    
    public User getUserById(int id) {
        String sql = "SELECT * FROM users WHERE user_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User u = new User();
                    u.setUserId(rs.getInt("user_id"));
                    u.setUsername(rs.getString("username"));
                    u.setFullName(rs.getString("full_name"));
                    u.setEmail(rs.getString("email"));
                    u.setPhone(rs.getString("phone"));
                    u.setRoleId(rs.getInt("role_id"));
                    u.setActive(rs.getBoolean("is_active"));
                    return u;
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOAdmin.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }
    
    public boolean updateUser(User user) {
        String sql = "UPDATE users SET full_name=?, email=?, phone=?, role_id=?, is_active=? WHERE user_id=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setInt(4, user.getRoleId());
            ps.setBoolean(5, user.getActive());
            ps.setInt(6, user.getUserId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(DAOAdmin.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }
    
    public boolean toggleUserStatus(int userId, boolean isActive) {
        String sql = "UPDATE users SET is_active=? WHERE user_id=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setBoolean(1, isActive);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(DAOAdmin.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }
    
    public boolean resetPassword(int userId, String newPassword) {
        String sql = "UPDATE users SET password_hash=? WHERE user_id=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, PasswordUtils.hashPassword(newPassword));
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(DAOAdmin.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }
}
