package DAL.Housekeeping;

import DAL.DAO;
import Model.HousekeepingTask;
import Model.HousekeepingTask.TaskStatus;
import Model.HousekeepingTask.TaskType;
import Model.Room;
import Model.StaffAssignment;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class DAOHousekeeping extends DAO {

    public static final DAOHousekeeping INSTANCE = new DAOHousekeeping();

    private DAOHousekeeping() {
    }

    // Enum dùng cho báo sự cố (mapping sang bảng issue_reports)
    public enum IssueType {
        SUPPLY,
        EQUIPMENT,
        OTHER
    }

    // ======================================================
    // Dashboard: phòng cần dọn
    // ======================================================
    public List<Room> getAllRooms() {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT * FROM rooms";

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Room r = new Room();
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

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // tìm thong tin Room cần vệ sinh
    public List<Room> getRoomsNeedingCleaning() {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT * FROM rooms WHERE status IN ('DIRTY', 'CLEANING')";

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Room r = new Room();
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

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
      // ======================================================
    // Task list advanced (Search, Sort, Page)
    // ======================================================
    public List<HousekeepingTask> getTasks(int staffId, LocalDate dateFrom, LocalDate dateTo, 
                                           String statusStr, String search, 
                                           String sortBy, String sortOrder, 
                                           int page, int pageSize) {
        List<HousekeepingTask> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM housekeeping_tasks WHERE assigned_to = ?");
        
        if (dateFrom != null) sql.append(" AND task_date >= ?");
        if (dateTo != null) sql.append(" AND task_date <= ?");
        if (statusStr != null && !statusStr.isBlank()) sql.append(" AND status = ?");
        if (search != null && !search.isBlank()) {
            sql.append(" AND (note LIKE ? OR room_id IN (SELECT room_id FROM rooms WHERE room_number LIKE ?))");
        }
        
        // Sorting
        if (sortBy == null || sortBy.isBlank()) sortBy = "task_date";
        if (sortOrder == null || sortOrder.isBlank()) sortOrder = "ASC";
        
        // Validate sort columns to prevent SQL injection
        String validSort = switch (sortBy) {
            case "roomId" -> "room_id";
            case "status" -> "status";
            case "taskType" -> "task_type";
            default -> "task_date";
        };
        
        sql.append(" ORDER BY ").append(validSort).append(" ").append("DESC".equalsIgnoreCase(sortOrder) ? "DESC" : "ASC");
        sql.append(", task_id ASC"); // Stable sort
        
        // Pagination
        if (page > 0 && pageSize > 0) {
            sql.append(" LIMIT ? OFFSET ?");
        }
        
        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            ps.setInt(idx++, staffId);
            if (dateFrom != null) ps.setDate(idx++, Date.valueOf(dateFrom));
            if (dateTo != null) ps.setDate(idx++, Date.valueOf(dateTo));
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
                    list.add(mapTask(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
 // ======================================================
    // Task list theo nhân viên + ngày + status
    // ======================================================
    
  public List<HousekeepingTask> getTasks(int staffId, LocalDate date, String statusStr) {
        List<HousekeepingTask> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT * FROM housekeeping_tasks WHERE assigned_to = ?"
        );
        if (date != null) {
            sql.append(" AND task_date = ?");
        }
        if (statusStr != null && !statusStr.isBlank()) {
            sql.append(" AND status = ?");
        }
        sql.append(" ORDER BY task_date, task_id");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            ps.setInt(idx++, staffId);
            if (date != null) {
                ps.setDate(idx++, Date.valueOf(date));
            }
            if (statusStr != null && !statusStr.isBlank()) {
                ps.setString(idx++, statusStr);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapTask(rs));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<HousekeepingTask> getTasksForStaffOnDate(int staffId, LocalDate date) {
        return getTasks(staffId, date, null);
    }

    public HousekeepingTask getTaskById(int taskId) {
        String sql = "SELECT * FROM housekeeping_tasks WHERE task_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, taskId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapTask(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    
    private HousekeepingTask mapTask(ResultSet rs) throws SQLException {
        HousekeepingTask t = new HousekeepingTask();
        t.setTaskId(rs.getInt("task_id"));
        t.setRoomId(rs.getInt("room_id"));
        t.setAssignedTo(rs.getInt("assigned_to"));
        t.setTaskDate(rs.getDate("task_date").toLocalDate());

        String typeStr = rs.getString("task_type");
        try {
            t.setTaskType(TaskType.valueOf(typeStr));
        } catch (IllegalArgumentException | NullPointerException e) {
            t.setTaskType(TaskType.CLEANING);
        }

        String statusStr = rs.getString("status");
        try {
            t.setStatus(TaskStatus.valueOf(statusStr));
        } catch (IllegalArgumentException | NullPointerException e) {
            t.setStatus(TaskStatus.NEW);
        }

        t.setNote(rs.getString("note"));
        t.setCreatedBy((Integer) rs.getInt("created_by"));
        Timestamp cAt = rs.getTimestamp("created_at");
        Timestamp uAt = rs.getTimestamp("updated_at");
        if (cAt != null) t.setCreatedAt(cAt.toLocalDateTime());
        if (uAt != null) t.setUpdatedAt(uAt.toLocalDateTime());

        return t;
    }

  

    // ======================================================
    // Room
    // ======================================================
    public Room getRoomById(int roomId) {
        String sql = "SELECT * FROM rooms WHERE room_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Room r = new Room();
                    r.setRoomId(rs.getInt("room_id"));
                    r.setRoomNumber(rs.getString("room_number"));
                    r.setRoomTypeId(rs.getInt("room_type_id"));
                    r.setFloor((Integer) rs.getInt("floor"));
                    r.setStatus(rs.getString("status"));
                    r.setImageUrl(rs.getString("image_url"));
                    r.setDescription(rs.getString("description"));
                    r.setActive(rs.getBoolean("is_active"));
                    return r;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
 public int countTasks(int staffId, LocalDate dateFrom, LocalDate dateTo, String statusStr, String search) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM housekeeping_tasks WHERE assigned_to = ?");
        
        if (dateFrom != null) sql.append(" AND task_date >= ?");
        if (dateTo != null) sql.append(" AND task_date <= ?");
        if (statusStr != null && !statusStr.isBlank()) sql.append(" AND status = ?");
        if (search != null && !search.isBlank()) {
            sql.append(" AND (note LIKE ? OR room_id IN (SELECT room_id FROM rooms WHERE room_number LIKE ?))");
        }
        
        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            ps.setInt(idx++, staffId);
            if (dateFrom != null) ps.setDate(idx++, Date.valueOf(dateFrom));
            if (dateTo != null) ps.setDate(idx++, Date.valueOf(dateTo));
            if (statusStr != null && !statusStr.isBlank()) ps.setString(idx++, statusStr);
            if (search != null && !search.isBlank()) {
                String kw = "%" + search + "%";
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    // ======================================================
    // Room list advanced
    // ======================================================
    public List<Room> getRooms(String statusStr, String search, String sortBy, String sortOrder, int page, int pageSize) {
        List<Room> list = new ArrayList<>();
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
                    Room r = new Room();
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
        } catch (SQLException e) {
            e.printStackTrace();
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
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    // ======================================================
    // StaffAssignment – phân ca làm việc
    // ======================================================
    public List<StaffAssignment> getAssignmentsForStaffOnDate(int staffId, LocalDate date) {
        List<StaffAssignment> list = new ArrayList<>();
        String sql = "SELECT * FROM staff_assignments WHERE employee_id = ? AND work_date = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, staffId);
            ps.setDate(2, Date.valueOf(date));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    StaffAssignment sa = new StaffAssignment();
                    sa.setAssignmentId(rs.getInt("assignment_id"));
                    sa.setEmployeeId(rs.getInt("employee_id"));
                    sa.setWorkDate(rs.getDate("work_date").toLocalDate());
                    String shiftTypeStr = rs.getString("shift_type");
                    try {
                        sa.setShiftType(StaffAssignment.ShiftType.valueOf(shiftTypeStr));
                    } catch (IllegalArgumentException | NullPointerException e) {
                        sa.setShiftType(StaffAssignment.ShiftType.MORNING);
                    }
                    String statusStr = rs.getString("status");
                    try {
                        sa.setStatus(StaffAssignment.StaffStatus.valueOf(statusStr));
                    } catch (IllegalArgumentException | NullPointerException e) {
                        sa.setStatus(StaffAssignment.StaffStatus.ON_SHIFT);
                    }
                    Timestamp cAt = rs.getTimestamp("created_at");
                    if (cAt != null) {
                        sa.setCreatedAt(cAt.toLocalDateTime());
                    }
                    list.add(sa);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
   
    
    public boolean createTask(int roomId,
                              int assignedTo,
                              LocalDate taskDate,
                              TaskType taskType,
                              String note,
                              int createdBy) {
        String sql = "INSERT INTO housekeeping_tasks (room_id, assigned_to, task_date, task_type, status, note, created_by, created_at) "
                   + "VALUES (?, ?, ?, ?, 'NEW', ?, ?, NOW())";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ps.setInt(2, assignedTo);
            ps.setDate(3, Date.valueOf(taskDate));
            ps.setString(4, taskType.name());
            ps.setString(5, note);
            ps.setInt(6, createdBy);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

   

   
  
}
