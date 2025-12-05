package DAL.Owner;

import DAL.DBContext;
import Model.User;
import Model.StaffAssignment;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DAOOwner extends DBContext {
    
    public static final DAOOwner INSTANCE = new DAOOwner();
    
    private DAOOwner() {
    }
    
    // ==========================================
    // DASHBOARD METRICS
    // ==========================================
    
    public int getTotalRooms() {
        String sql = "SELECT COUNT(*) FROM rooms";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOOwner.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }
    
    public int getOccupiedRooms() {
        // Assuming 'OCCUPIED' is a status or checking bookings
        // For simplicity, let's count rooms with status 'OCCUPIED' if that exists, 
        // or join with active bookings. 
        // Based on previous context, Room status might be AVAILABLE, DIRTY, CLEANING, MAINTENANCE.
        // Let's assume we check bookings for today.
        String sql = "SELECT COUNT(*) FROM bookings WHERE status = 'CHECKED_IN'";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOOwner.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }
    
    public double getTodayRevenue() {
        // Mock implementation or real query if payment table exists
        // SELECT SUM(amount) FROM payments WHERE payment_date = CURRENT_DATE
        return 0.0; 
    }

    // ==========================================
    // EMPLOYEE MANAGEMENT (Advanced)
    // ==========================================
    
    public List<User> getEmployees(String search, String roleIdStr, String statusStr, 
                                   String sortBy, String sortOrder, int page, int pageSize) {
        List<User> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM users WHERE role_id IN (2, 3)");
        
        if (search != null && !search.isBlank()) {
            sql.append(" AND (username LIKE ? OR full_name LIKE ? OR email LIKE ? OR phone LIKE ?)");
        }
        if (roleIdStr != null && !roleIdStr.isBlank()) {
            sql.append(" AND role_id = ?");
        }
        if (statusStr != null && !statusStr.isBlank()) {
            boolean isActive = Boolean.parseBoolean(statusStr);
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
            Logger.getLogger(DAOOwner.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }
    
    public int countEmployees(String search, String roleIdStr, String statusStr) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM users WHERE role_id IN (2, 3)");
        
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
            Logger.getLogger(DAOOwner.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    // ==========================================
    // ROOM MANAGEMENT (Advanced)
    // ==========================================
    
    public List<Model.Room> getRooms(String statusStr, String search, String sortBy, String sortOrder, int page, int pageSize) {
        List<Model.Room> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM rooms WHERE 1=1");
        
        if (statusStr != null && !statusStr.isBlank()) sql.append(" AND status = ?");
        if (search != null && !search.isBlank()) {
            sql.append(" AND (room_number LIKE ? OR description LIKE ?)");
        }
        
        if (sortBy == null || sortBy.isBlank()) sortBy = "room_number";
        if (sortOrder == null || sortOrder.isBlank()) sortOrder = "ASC";
        
        String validSort = switch (sortBy) {
            case "status" -> "status";
            case "floor" -> "floor";
            case "type" -> "room_type_id";
            default -> "room_number";
        };
        
        sql.append(" ORDER BY ").append(validSort).append(" ").append("DESC".equalsIgnoreCase(sortOrder) ? "DESC" : "ASC");
        
        if (page > 0 && pageSize > 0) {
            sql.append(" LIMIT ? OFFSET ?");
        }
        
        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            if (statusStr != null && !statusStr.isBlank()) ps.setString(idx++, statusStr);
            if (search != null && !search.isBlank()) {
                String kw = "%" + search + "%";
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
            }
            if (page > 0 && pageSize > 0) {
                ps.setInt(idx++, pageSize);
                ps.setInt(idx++, (page - 1) * pageSize);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Model.Room r = new Model.Room();
                    r.setRoomId(rs.getInt("room_id"));
                    r.setRoomNumber(rs.getString("room_number"));
                    r.setRoomTypeId(rs.getInt("room_type_id"));
                    r.setFloor((Integer) rs.getInt("floor"));
                    r.setStatus(rs.getString("status"));
                    r.setImageUrl(rs.getString("image_url"));
                    r.setDescription(rs.getString("description"));
                    r.setActive(rs.getBoolean("is_active"));
                    list.add(r);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOOwner.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }
    
    public int countRooms(String statusStr, String search) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM rooms WHERE 1=1");
        
        if (statusStr != null && !statusStr.isBlank()) sql.append(" AND status = ?");
        if (search != null && !search.isBlank()) {
            sql.append(" AND (room_number LIKE ? OR description LIKE ?)");
        }
        
        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            if (statusStr != null && !statusStr.isBlank()) ps.setString(idx++, statusStr);
            if (search != null && !search.isBlank()) {
                String kw = "%" + search + "%";
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOOwner.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }
    
    public User getEmployeeById(int id) {
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
            Logger.getLogger(DAOOwner.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }
    
    public boolean createEmployee(User user, String plainPassword) {
        // Using stored procedure or raw insert
        // Assuming we use raw insert for now as sp_create_user might not exist or we don't know it
        String sql = "INSERT INTO users (username, password_hash, full_name, email, phone, role_id, is_active) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            // Hash password here or in controller. Let's assume controller/model handles hashing
            // But wait, User model has setPlainPassword which hashes it.
            // If we receive a User object with passwordHash already set:
            ps.setString(2, user.getPasswordHash());
            ps.setString(3, user.getFullName());
            ps.setString(4, user.getEmail());
            ps.setString(5, user.getPhone());
            ps.setInt(6, user.getRoleId());
            ps.setBoolean(7, true);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(DAOOwner.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }
    
    public boolean updateEmployee(User user) {
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
            Logger.getLogger(DAOOwner.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }
    
    public boolean toggleEmployeeStatus(int userId, boolean isActive) {
        String sql = "UPDATE users SET is_active=? WHERE user_id=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setBoolean(1, isActive);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(DAOOwner.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    // ==========================================
    // JOB ASSIGNMENT
    // ==========================================
    
    // ... Implement assignment methods later or reuse DAOHousekeeping for tasks
    // For StaffAssignment (shifts):
    
    // ==========================================
    // JOB ASSIGNMENT
    // ==========================================
    
    public List<StaffAssignment> getAssignments(LocalDate date) {
        List<StaffAssignment> list = new ArrayList<>();
        String sql = "SELECT sa.*, u.full_name as employee_name FROM staff_assignments sa " +
                     "JOIN users u ON sa.employee_id = u.user_id " +
                     "WHERE sa.work_date = ? ORDER BY sa.shift_type";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setDate(1, java.sql.Date.valueOf(date));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    StaffAssignment sa = new StaffAssignment();
                    sa.setAssignmentId(rs.getInt("assignment_id"));
                    sa.setEmployeeId(rs.getInt("employee_id"));
                    sa.setWorkDate(rs.getDate("work_date").toLocalDate());
                    
                    try {
                        sa.setShiftType(StaffAssignment.ShiftType.valueOf(rs.getString("shift_type")));
                    } catch (Exception e) {
                        sa.setShiftType(StaffAssignment.ShiftType.MORNING);
                    }
                    
                    try {
                        sa.setStatus(StaffAssignment.StaffStatus.valueOf(rs.getString("status")));
                    } catch (Exception e) {
                        sa.setStatus(StaffAssignment.StaffStatus.ON_SHIFT);
                    }
                    
                    // We might need to extend StaffAssignment model to hold employee name or fetch it separately
                    // For now, we'll just return the assignment object.
                    list.add(sa);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOOwner.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }
    
    public boolean createAssignment(int employeeId, LocalDate date, String shiftType) {
        String sql = "INSERT INTO staff_assignments (employee_id, work_date, shift_type, status, created_at) VALUES (?, ?, ?, 'ON_SHIFT', NOW())";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            ps.setDate(2, java.sql.Date.valueOf(date));
            ps.setString(3, shiftType);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(DAOOwner.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }
    
    public boolean deleteAssignment(int assignmentId) {
        String sql = "DELETE FROM staff_assignments WHERE assignment_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, assignmentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(DAOOwner.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }
}
