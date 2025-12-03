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
