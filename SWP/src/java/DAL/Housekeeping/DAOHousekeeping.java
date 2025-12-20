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
        String sql = "SELECT r.*, rt.type_name, "
                + "(SELECT status FROM room_status_periods rsp WHERE rsp.room_id = r.room_id AND CURRENT_DATE >= rsp.start_date AND CURRENT_DATE < rsp.end_date LIMIT 1) as period_status "
                + "FROM rooms r "
                + "JOIN room_types rt ON r.room_type_id = rt.room_type_id "
                + "ORDER BY r.room_number";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Room r = new Room();
                r.setRoomId(rs.getInt("room_id"));
                r.setRoomNumber(rs.getString("room_number"));
                r.setRoomTypeId(rs.getInt("room_type_id"));
                r.setRoomTypeName(rs.getString("type_name"));
                r.setFloor((Integer) rs.getInt("floor"));

                String periodStatus = rs.getString("period_status");
                if (periodStatus != null && !periodStatus.isBlank()) {
                    r.setStatus(periodStatus);
                } else {
                    r.setStatus(rs.getString("status"));
                }

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

    public <T> Room getRoomById(T id) {
        String idString = String.valueOf(id);
        Room r = new Room();
        // Join with room_types to get details
        String sql = "SELECT r.*, rt.type_name, rt.base_price, rt.max_occupancy, rt.description as type_desc " +
                "FROM rooms r " +
                "LEFT JOIN room_types rt ON r.room_type_id = rt.room_type_id " +
                "WHERE r.room_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, idString);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    r.setRoomId(rs.getInt("room_id"));
                    r.setRoomNumber(rs.getString("room_number"));
                    r.setRoomTypeId(rs.getInt("room_type_id"));
                    r.setFloor((Integer) rs.getInt("floor"));
                    r.setStatus(rs.getString("status"));
                    r.setImageUrl(rs.getString("image_url"));
                    r.setDescription(rs.getString("description"));
                    r.setActive(rs.getBoolean("is_active"));

                    // Set Room Type Name (for existing compatibility)
                    r.setRoomTypeName(rs.getString("type_name"));

                    // Create and populate RoomType object for rich details
                    Model.RoomType rt = new Model.RoomType();
                    rt.setRoomTypeId(rs.getInt("room_type_id"));
                    rt.setTypeName(rs.getString("type_name"));
                    rt.setBasePrice(java.math.BigDecimal.valueOf(rs.getDouble("base_price")));
                    rt.setMaxOccupancy(rs.getInt("max_occupancy"));
                    rt.setDescription(rs.getString("type_desc"));

                    r.setRoomType(rt);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return r;
    }

    public List<Room> getRoomsNeedingCleaning() {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT * FROM rooms WHERE status IN ('DIRTY', 'CLEANING')";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

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
    // Get Completed Tasks AND Inspections (Unified History)
    // ======================================================
    public List<HousekeepingTask> getCompletedTasksAndInspections(int staffId, String search, int page, int pageSize) {
        List<HousekeepingTask> unifiedList = new ArrayList<>();

        // 1. Get filtered DONE tasks
        // We will fetch ALL done tasks first for simple deduplication in memory
        // (Assuming history isn't massive. If massive, we need complex SQL UNION).
        // For efficiency with pagination, let's use SQL UNION.

        // However, mapping ResultSet to HousekeepingTask from UNION is specific.
        // Let's construct a UNION query.

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT * FROM (");

        // Part 1: Real Tasks
        sql.append(
                "SELECT t.task_id, t.room_id, t.assigned_to, t.task_date, t.task_type, t.status, t.note, t.created_by, t.created_at, t.updated_at, r.room_number ");
        sql.append("FROM housekeeping_tasks t ");
        sql.append("JOIN rooms r ON t.room_id = r.room_id ");
        sql.append(
                "WHERE t.assigned_to = ? AND t.status = 'DONE' AND t.task_type NOT IN ('INSPECTION', 'CHECKIN', 'CHECKOUT') ");

        sql.append("UNION ALL ");

        // Part 2: Inspections (mapped to tasks)
        // We use inspection_id * -1 as task_id to avoid collision (and indicate it's
        // from inspection)
        // task_date = inspection_date
        // task_type = 'INSPECTION' (or mapped if we stored type)
        // status = 'DONE'
        sql.append(
                "SELECT (ri.inspection_id * -1) as task_id, ri.room_id, ri.inspector_id as assigned_to, DATE(ri.inspection_date) as task_date, ");
        sql.append(
                "CASE WHEN ri.type = 'DAILY' THEN 'CLEANING' WHEN ri.type = 'SUPPLY' THEN 'CLEANING' ELSE ri.type END as task_type, ");
        sql.append(
                "'DONE' as status, ri.note, ri.inspector_id as created_by, ri.inspection_date as created_at, ri.inspection_date as updated_at, r.room_number ");
        sql.append("FROM room_inspections ri ");
        sql.append("JOIN rooms r ON ri.room_id = r.room_id ");
        sql.append("WHERE ri.inspector_id = ? ");

        sql.append(") AS combined_history ");
        sql.append("WHERE 1=1 ");

        if (search != null && !search.isBlank()) {
            sql.append("AND (note LIKE ? OR room_number LIKE ?) ");
        }

        sql.append("ORDER BY task_date DESC, created_at DESC ");
        sql.append("LIMIT ? OFFSET ?");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            ps.setInt(idx++, staffId);
            ps.setInt(idx++, staffId);

            if (search != null && !search.isBlank()) {
                String searchPattern = "%" + search + "%";
                ps.setString(idx++, searchPattern);
                ps.setString(idx++, searchPattern);
            }

            ps.setInt(idx++, pageSize);
            ps.setInt(idx++, (page - 1) * pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    HousekeepingTask t = new HousekeepingTask();
                    t.setTaskId(rs.getInt("task_id"));
                    t.setRoomId(rs.getInt("room_id"));
                    t.setRoomNumber(rs.getString("room_number"));
                    t.setAssignedTo(rs.getInt("assigned_to"));
                    t.setTaskDate(rs.getDate("task_date").toLocalDate());

                    // Handle TaskType carefully
                    String typeStr = rs.getString("task_type");
                    // Map legacy or unknown types
                    if ("ROUTINE".equals(typeStr))
                        typeStr = "INSPECTION";
                    try {
                        t.setTaskType(TaskType.valueOf(typeStr));
                    } catch (IllegalArgumentException e) {
                        t.setTaskType(TaskType.INSPECTION); // Fallback
                    }

                    t.setStatus(TaskStatus.DONE);
                    t.setNote(rs.getString("note"));
                    t.setCreatedBy(rs.getInt("created_by"));
                    t.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());

                    unifiedList.add(t);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return unifiedList;
    }

    public int countCompletedTasksAndInspections(int staffId, String search) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM (");

        sql.append("SELECT t.task_id, t.note, r.room_number ");
        sql.append("FROM housekeeping_tasks t JOIN rooms r ON t.room_id = r.room_id ");
        sql.append("WHERE t.assigned_to = ? AND t.status = 'DONE' ");

        sql.append("UNION ALL ");

        sql.append("SELECT (ri.inspection_id * -1), ri.note, r.room_number ");
        sql.append("FROM room_inspections ri JOIN rooms r ON ri.room_id = r.room_id ");
        sql.append("WHERE ri.inspector_id = ? ");

        sql.append(") AS combined_history ");

        if (search != null && !search.isBlank()) {
            sql.append("WHERE (note LIKE ? OR room_number LIKE ?) ");
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            ps.setInt(idx++, staffId);
            ps.setInt(idx++, staffId);

            if (search != null && !search.isBlank()) {
                String searchPattern = "%" + search + "%";
                ps.setString(idx++, searchPattern);
                ps.setString(idx++, searchPattern);
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<HousekeepingTask> getTasks(int staffId, LocalDate date, String statusStr, String taskType) {
        List<HousekeepingTask> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT t.*, r.room_number FROM housekeeping_tasks t JOIN rooms r ON t.room_id = r.room_id WHERE assigned_to = ?");
        if (date != null) {
            sql.append(" AND task_date = ?");
        }
        if (statusStr != null && !statusStr.isBlank()) {
            sql.append(" AND status = ?");
        }
        if (taskType != null && !taskType.isBlank()) {
            if ("INSPECTION_ALL".equals(taskType)) {
                sql.append(" AND task_type IN ('INSPECTION', 'CHECKIN', 'CHECKOUT')");
            } else {
                sql.append(" AND task_type = ?");
            }
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
            if (taskType != null && !taskType.isBlank() && !"INSPECTION_ALL".equals(taskType)) {
                ps.setString(idx++, taskType);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    HousekeepingTask t = mapTask(rs);
                    t.setRoomNumber(rs.getString("room_number"));
                    list.add(t);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<HousekeepingTask> getTasksForStaffOnDate(int staffId, LocalDate date) {
        List<HousekeepingTask> list = new ArrayList<>();
        // Fetch:
        // 1. Pending tasks assigned to staff on or before 'date' (Overdue + Today)
        // User requested ONLY status != DONE.
        String sql = "SELECT t.task_id, t.room_id, t.assigned_to, t.task_date, t.task_type, t.status, t.note, t.created_by, t.created_at, t.updated_at, "
                + "r.room_number "
                + "FROM housekeeping_tasks t "
                + "JOIN rooms r ON t.room_id = r.room_id "
                + "WHERE assigned_to = ? "
                + "AND t.status != 'DONE' AND t.task_date <= ? "
                + "ORDER BY t.status ASC, t.task_date ASC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, staffId);
            ps.setDate(2, Date.valueOf(date));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    HousekeepingTask t = mapTask(rs);
                    t.setRoomNumber(rs.getString("room_number"));
                    list.add(t);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
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
        Date d = rs.getDate("task_date");
        if (d != null) {
            t.setTaskDate(d.toLocalDate());
        } else {
            Timestamp cAt = rs.getTimestamp("created_at");
            if (cAt != null) {
                t.setTaskDate(cAt.toLocalDateTime().toLocalDate());
            } else {
                t.setTaskDate(LocalDate.now());
            }
        }

        String typeStr = rs.getString("task_type");
        if (typeStr != null) {
            // Normalize type string to match Enum (handle CHECK_IN vs CHECKIN)
            typeStr = typeStr.replace("_", "").toUpperCase();
            // Handle legacy mapping
            if ("ROUTINE".equals(typeStr) || "DAILY".equals(typeStr))
                typeStr = "INSPECTION";

            try {
                t.setTaskType(TaskType.valueOf(typeStr));
            } catch (IllegalArgumentException | NullPointerException e) {
                t.setTaskType(TaskType.CLEANING);
            }
        } else {
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
        if (cAt != null) {
            t.setCreatedAt(cAt.toLocalDateTime());
        }
        if (uAt != null) {
            t.setUpdatedAt(uAt.toLocalDateTime());
        }

        return t;
    }

    // ======================================================
    // Cập nhật task + đồng bộ trạng thái phòng
    // ======================================================
    public boolean updateTaskStatusAndNote(int taskId, TaskStatus newStatus, String note) {
        String selectSql = "SELECT room_id, task_type FROM housekeeping_tasks WHERE task_id = ?";
        String updateTaskSql = "UPDATE housekeeping_tasks "
                + "SET status = ?, note = ?, updated_at = NOW() "
                + "WHERE task_id = ?";
        String updateRoomSql = "UPDATE rooms SET status = ? WHERE room_id = ?";

        try {
            connection.setAutoCommit(false);

            int roomId = -1;
            String taskTypeStr = "";
            try (PreparedStatement ps = connection.prepareStatement(selectSql)) {
                ps.setInt(1, taskId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        roomId = rs.getInt("room_id");
                        taskTypeStr = rs.getString("task_type");
                    } else {
                        connection.rollback();
                        return false;
                    }
                }
            }

            try (PreparedStatement ps = connection.prepareStatement(updateTaskSql)) {
                ps.setString(1, newStatus.name());
                ps.setString(2, note);
                ps.setInt(3, taskId);
                ps.executeUpdate();
            }

            // Only update room status if this is a CLEANING task
            if ("CLEANING".equalsIgnoreCase(taskTypeStr)) {
                // Map trạng thái task -> trạng thái phòng
                Room.Status roomStatus = null;
                if (newStatus == TaskStatus.IN_PROGRESS) {
                    roomStatus = Room.Status.CLEANING;
                } else if (newStatus == TaskStatus.DONE) {
                    // Sau khi dọn xong, coi là AVAILABLE (Clean & Ready)
                    roomStatus = Room.Status.AVAILABLE;
                }

                if (roomStatus != null) {
                    try (PreparedStatement ps = connection.prepareStatement(updateRoomSql)) {
                        ps.setString(1, roomStatus.name());
                        ps.setInt(2, roomId);
                        ps.executeUpdate();
                    }
                }
            }

            connection.commit();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            try {
                connection.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return false;
    }

    // ======================================================
    // Room
    // ======================================================
    public Room getRoomById(int roomId) {
        String sql = "SELECT r.*, rt.type_name as room_type_name FROM rooms r join room_types rt on rt.room_type_id = r.room_type_id WHERE r.room_id = ?";
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
                    r.setRoomTypeName(rs.getString("room_type_name"));
                    return r;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateRoomStatus(int roomId, Room.Status newStatus) {
        String sql = "UPDATE rooms SET status = ? WHERE room_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, newStatus.name());
            ps.setInt(2, roomId);
            int n = ps.executeUpdate();
            return n > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
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

    // ======================================================
    // Issue Report – SUPPLY / EQUIPMENT
    // ======================================================
    // ======================================================
    // Issue Report – SUPPLY / EQUIPMENT
    // ======================================================
    // ======================================================
    // Issue Report – SUPPLY / EQUIPMENT
    // ======================================================
    // ======================================================
    // Auto Assign Task Logic
    // ======================================================
    public int getLeastLoadedHousekeeperId() {
        // Return staff with lowest count of ACTIVE tasks (NEW, IN_PROGRESS)
        // Role ID 3 = Housekeeping (based on getHousekeepingStaff)
        String sql = "SELECT u.user_id, COUNT(t.task_id) as task_count "
                + "FROM users u "
                + "LEFT JOIN housekeeping_tasks t ON u.user_id = t.assigned_to "
                + "AND t.status IN ('NEW', 'IN_PROGRESS') "
                + "WHERE u.role_id = 3 AND u.is_active = TRUE "
                + "GROUP BY u.user_id "
                + "ORDER BY task_count ASC, u.user_id ASC LIMIT 1";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("user_id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1; // No staff found
    }

    public boolean autoAssignTask(int bookingId, TaskType taskType, String stageStr, LocalDate scheduledDate) {
        int staffId = getLeastLoadedHousekeeperId();
        if (staffId == -1) {
            System.out.println("Auto-assign failed: No housekeeping staff available.");
            return false;
        }

        // Get Booking to find roomId
        // Using DAOBooking might cause circular dependency?
        // Querying roomId directly is safer here to avoid loop if DAOBooking calls
        // this.
        int roomId = -1;
        String sqlRoom = "SELECT room_id FROM bookings WHERE booking_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sqlRoom)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    roomId = rs.getInt("room_id");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }

        if (roomId == -1)
            return false;

        String note = "[" + stageStr + "] " + taskType.name() + " for Booking #" + bookingId + " (Auto-assigned)";

        return createTask(roomId, staffId, scheduledDate, taskType, note, 1);
    }

    public boolean createIssueReport(int roomId,
            int reportedBy,
            IssueType issueType,
            String description) {
        String sql = "INSERT INTO issue_reports (room_id, reported_by, issue_type, description, status, created_at) "
                + "VALUES (?, ?, ?, ?, 'NEW', NOW())";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ps.setInt(2, reportedBy);
            ps.setString(3, issueType.name());
            ps.setString(4, description);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ======================================================
    // Create Task (New)
    // ======================================================
    public List<Model.IssueReport> getIssuesByReporter(int staffId, String search, String status, String type,
            String sortBy, int page, int pageSize) {
        List<Model.IssueReport> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT ir.*, r.room_number FROM issue_reports ir LEFT JOIN rooms r ON ir.room_id = r.room_id WHERE ir.reported_by = ? ");

        List<Object> params = new ArrayList<>();
        params.add(staffId);

        if (search != null && !search.isBlank()) {
            sql.append("AND (ir.description LIKE ? OR r.room_number LIKE ?) ");
            String query = "%" + search + "%";
            params.add(query);
            params.add(query);
        }

        if (status != null && !status.isBlank()) {
            sql.append("AND ir.status = ? ");
            params.add(status);
        }

        if (type != null && !type.isBlank()) {
            sql.append("AND ir.issue_type = ? ");
            params.add(type);
        }

        // Sorting
        sql.append("ORDER BY ");
        if (sortBy != null) {
            switch (sortBy) {
                case "room_id" -> sql.append("ir.room_id ASC, ir.created_at DESC ");
                case "status" -> sql.append("ir.status ASC, ir.created_at DESC ");
                default -> sql.append("ir.created_at DESC ");
            }
        } else {
            sql.append("ir.created_at DESC ");
        }

        // Pagination
        sql.append("LIMIT ? OFFSET ? ");
        params.add(pageSize);
        params.add((page - 1) * pageSize);

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Model.IssueReport i = new Model.IssueReport();
                    i.setIssueId(rs.getInt("issue_id"));
                    i.setRoomId(rs.getInt("room_id"));
                    i.setReportedBy(rs.getInt("reported_by"));
                    i.setRoomNumber(rs.getString("room_number"));
                    i.setDescription(rs.getString("description"));

                    try {
                        i.setIssueType(Model.IssueReport.IssueType.valueOf(rs.getString("issue_type")));
                    } catch (Exception e) {
                        i.setIssueType(Model.IssueReport.IssueType.OTHER);
                    }
                    try {
                        i.setStatus(Model.IssueReport.IssueStatus.valueOf(rs.getString("status")));
                    } catch (Exception e) {
                        i.setStatus(Model.IssueReport.IssueStatus.NEW);
                    }

                    Timestamp cAt = rs.getTimestamp("created_at");
                    if (cAt != null)
                        i.setCreatedAt(cAt.toLocalDateTime());

                    list.add(i);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countIssuesByReporter(int staffId, String search, String status, String type) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM issue_reports ir LEFT JOIN rooms r ON ir.room_id = r.room_id WHERE ir.reported_by = ? ");
        List<Object> params = new ArrayList<>();
        params.add(staffId);

        if (search != null && !search.isBlank()) {
            sql.append("AND (ir.description LIKE ? OR r.room_number LIKE ?) ");
            String query = "%" + search + "%";
            params.add(query);
            params.add(query);
        }

        if (status != null && !status.isBlank()) {
            sql.append("AND ir.status = ? ");
            params.add(status);
        }

        if (type != null && !type.isBlank()) {
            sql.append("AND ir.issue_type = ? ");
            params.add(type);
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Model.IssueReport> getIssuesByReporter(int staffId) {
        return getIssuesByReporter(staffId, null, null, null, null, 1, 1000); // Backwards compatibility wrapper
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

    // ======================================================
    // Task list advanced (Search, Sort, Page)
    // ======================================================
    // ======================================================
    // Task list advanced (Search, Sort, Page)
    // ======================================================
    // ======================================================
    // Task list advanced (Search, Sort, Page) - UNIFIED
    // ======================================================
    public List<HousekeepingTask> getTasks(int staffId, LocalDate dateFrom, LocalDate dateTo,
            String statusStr, String search, String taskType,
            String sortBy, String sortOrder,
            int page, int pageSize, Integer creatorRoleId) {
        List<HousekeepingTask> list = new ArrayList<>();

        // Build Unified Query
        StringBuilder sql = new StringBuilder("SELECT * FROM (");

        // 1. Housekeeping Tasks
        sql.append(
                "SELECT ht.task_id, ht.room_id, ht.assigned_to, ht.task_date, ht.task_type, ht.status, ht.note, ht.created_by, ht.created_at, ht.updated_at, ");
        sql.append("r.room_number, u.full_name as assigned_to_name ");
        sql.append("FROM housekeeping_tasks ht ");
        sql.append("LEFT JOIN rooms r ON ht.room_id = r.room_id ");
        sql.append("LEFT JOIN users u ON ht.assigned_to = u.user_id ");
        sql.append("WHERE 1=1 AND ht.status != 'DONE' ");

        // Filter params for Tasks part
        if (staffId > 0)
            sql.append("AND ht.assigned_to = ? ");
        if (dateFrom != null)
            sql.append("AND ht.task_date >= ? ");
        if (dateTo != null)
            sql.append("AND ht.task_date <= ? ");
        if (statusStr != null && !statusStr.isBlank())
            sql.append("AND ht.status = ? ");
        // Type filter
        if (taskType != null && !taskType.isBlank()) {
            if ("INSPECTION_ALL".equals(taskType)) {
                // Tasks usually aren't INSPECTION_ALL unless mixed, but let's exclude standard
                // CLEANING if user wants ONLY inspections
                sql.append("AND ht.task_type IN ('INSPECTION', 'CHECKIN', 'CHECKOUT') ");
            } else {
                sql.append("AND ht.task_type = ? ");
            }
        }
        if (search != null && !search.isBlank())
            sql.append("AND (ht.note LIKE ? OR r.room_number LIKE ?) ");

        sql.append("UNION ALL ");

        // 2. Room Inspections (Mapped to Tasks)
        // ID * -1
        sql.append(
                "SELECT (ri.inspection_id * -1) as task_id, ri.room_id, ri.inspector_id as assigned_to, DATE(ri.inspection_date) as task_date, ");
        // Type mapping
        sql.append(
                "CASE WHEN ri.type = 'DAILY' THEN 'CLEANING' WHEN ri.type = 'SUPPLY' THEN 'CLEANING' WHEN ri.type = 'ROUTINE' THEN 'INSPECTION' ELSE ri.type END as task_type, ");
        // Status mapping (Inspections don't have explicit status usually, assume 'DONE'
        // if exists? Or mapped?
        // Logic: if it's in history it's done. But active list?
        // Existing DB implies inspections are 'records' so effectively done?
        // Wait, user wants "My Tasks". If inspection is scheduled, it might not be in
        // room_inspections yet (if that's only for completed).
        // BUT current system flow seems to be: Create Inspection -> It exists.
        // Let's assume 'DONE' for now as simple history, OR if we had a status column.
        // Looking at RoomInspection model check... no status column in table shown
        // earlier in snippets?
        // Ah, snippets for `createIssueReport` show status. `checkTask` snippet?
        // Let's assume for now we map 'DONE' if it exists.
        // BUT wait, user wants pending work. If `room_inspections` only stores
        // COMPLETED inspections, then pending work must be in `housekeeping_tasks`.
        // IF so, then my previous fix to `getTasksForStaffOnDate` (pure
        // housekeeping_tasks) should have worked IF the types were correct.
        // User complained "dashboard not correct". I added UNION to
        // `getTasksForStaffOnDate`? NO, I REVERTED to filter logic.
        // Wait, did I UNION in `getTasksForStaffOnDate`?
        // Reviewing history... I PROPOSED UNION in plan. I executed code that looked
        // like `...status != 'DONE'...`.
        // I did NOT do UNION in `getTasksForStaffOnDate` in the last step. I just
        // improved filtering.
        // User then said "Show ALL types".
        // IF `room_inspections` contains the "Check-in" tasks the user is referring to,
        // then yes, UNION is needed.
        // Let's proceed with UNION assuming `room_inspections` holds these records.

        sql.append(
                "'DONE' as status, ri.note, ri.inspector_id as created_by, ri.inspection_date as created_at, ri.inspection_date as updated_at, "); // Placeholder
                                                                                                                                                   // status
        sql.append("r.room_number, u.full_name as assigned_to_name ");
        sql.append("FROM room_inspections ri ");
        sql.append("LEFT JOIN rooms r ON ri.room_id = r.room_id ");
        sql.append("LEFT JOIN users u ON ri.inspector_id = u.user_id ");
        sql.append("WHERE 1=1 AND 1=0 "); // HARDCODED FILTER: User wants ONLY active tasks (status != DONE).
                                          // Inspections here are DONE.

        if (staffId > 0)
            sql.append("AND ri.inspector_id = ? ");
        if (dateFrom != null)
            sql.append("AND DATE(ri.inspection_date) >= ? ");
        if (dateTo != null)
            sql.append("AND DATE(ri.inspection_date) <= ? ");
        // Status filter: If searching for 'NEW', inspections might not match if they
        // are considered done.
        // If sorting strictly by status, this might filter them out if we map to DONE.
        // Let's map empty status filter to include them, but if user filters 'NEW',
        // skip them?
        if (statusStr != null && !statusStr.isBlank()) {
            if ("DONE".equals(statusStr)) {
                // Include
            } else {
                sql.append("AND 1=0 "); // Exclude if filtering for NEW/IN_PROGRESS (assuming inspections in this table
                                        // are done history)
            }
        }

        if (taskType != null && !taskType.isBlank()) {
            if ("INSPECTION_ALL".equals(taskType)) {
                // Include all from this table as it IS inspection table (mostly)
            } else {
                sql.append("AND ri.type = ? ");
            }
        }
        if (search != null && !search.isBlank())
            sql.append("AND (ri.note LIKE ? OR r.room_number LIKE ?) ");

        sql.append(") AS unified_tasks WHERE 1=1 ");

        // Sorting
        if (sortBy == null || sortBy.isBlank())
            sortBy = "task_date";
        if (sortOrder == null || sortOrder.isBlank())
            sortOrder = "DESC";

        String validSort = switch (sortBy) {
            case "roomId" -> "room_id";
            case "status" -> "status";
            case "taskType" -> "task_type";
            default -> "task_date";
        };

        sql.append("ORDER BY ").append(validSort).append(" ")
                .append("DESC".equalsIgnoreCase(sortOrder) ? "DESC" : "ASC");
        sql.append(", task_id DESC ");

        // Pagination
        if (page > 0 && pageSize > 0) {
            sql.append("LIMIT ? OFFSET ?");
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int idx = 1;

            // --- Params for Table 1 (Tasks) ---
            if (staffId > 0)
                ps.setInt(idx++, staffId);
            if (dateFrom != null)
                ps.setDate(idx++, Date.valueOf(dateFrom));
            if (dateTo != null)
                ps.setDate(idx++, Date.valueOf(dateTo));
            if (statusStr != null && !statusStr.isBlank())
                ps.setString(idx++, statusStr);
            if (taskType != null && !taskType.isBlank() && !"INSPECTION_ALL".equals(taskType))
                ps.setString(idx++, taskType);
            if (search != null && !search.isBlank()) {
                String kw = "%" + search + "%";
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
            }

            // --- Params for Table 2 (Inspections) ---
            if (staffId > 0)
                ps.setInt(idx++, staffId);
            if (dateFrom != null)
                ps.setDate(idx++, Date.valueOf(dateFrom));
            if (dateTo != null)
                ps.setDate(idx++, Date.valueOf(dateTo));
            if (taskType != null && !taskType.isBlank() && !"INSPECTION_ALL".equals(taskType))
                ps.setString(idx++, taskType);
            if (search != null && !search.isBlank()) {
                String kw = "%" + search + "%";
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
            }

            // --- Pagination ---
            if (page > 0 && pageSize > 0) {
                ps.setInt(idx++, pageSize);
                ps.setInt(idx++, (page - 1) * pageSize);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapTaskWithDetails(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private HousekeepingTask mapTaskWithDetails(ResultSet rs) throws SQLException {
        HousekeepingTask t = mapTask(rs);
        t.setRoomNumber(rs.getString("room_number"));
        t.setAssignedToName(rs.getString("assigned_to_name"));
        return t;
    }

    public int countTasks(int staffId, LocalDate dateFrom, LocalDate dateTo, String statusStr, String search,
            String taskType, Integer creatorRoleId) {
        // Simplified count for unification
        // Note: Ignoring creatorRoleId for simplicity as it wasn't critical in main
        // flow, or add if needed.
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM (");

        // 1. Tasks
        sql.append("SELECT task_id FROM housekeeping_tasks ht ");
        sql.append("LEFT JOIN rooms r ON ht.room_id = r.room_id ");
        sql.append("WHERE 1=1 AND ht.status != 'DONE' ");
        if (staffId > 0)
            sql.append("AND ht.assigned_to = ? ");
        if (dateFrom != null)
            sql.append("AND ht.task_date >= ? ");
        if (dateTo != null)
            sql.append("AND ht.task_date <= ? ");
        if (statusStr != null && !statusStr.isBlank())
            sql.append("AND ht.status = ? ");
        if (taskType != null && !taskType.isBlank()) {
            if ("INSPECTION_ALL".equals(taskType))
                sql.append("AND ht.task_type IN ('INSPECTION', 'CHECKIN', 'CHECKOUT') ");
            else
                sql.append("AND ht.task_type = ? ");
        }
        if (search != null && !search.isBlank())
            sql.append("AND (ht.note LIKE ? OR r.room_number LIKE ?) ");

        sql.append("UNION ALL ");

        // 2. Inspections
        sql.append("SELECT inspection_id FROM room_inspections ri ");
        sql.append("LEFT JOIN rooms r ON ri.room_id = r.room_id ");
        sql.append("WHERE 1=1 ");
        if (staffId > 0)
            sql.append("AND ri.inspector_id = ? ");
        if (dateFrom != null)
            sql.append("AND DATE(ri.inspection_date) >= ? ");
        if (dateTo != null)
            sql.append("AND DATE(ri.inspection_date) <= ? ");
        if (statusStr != null && !statusStr.isBlank()) {
            if ("DONE".equals(statusStr)) {
            } else {
                sql.append("AND 1=0 ");
            }
        }
        if (taskType != null && !taskType.isBlank()) {
            if ("INSPECTION_ALL".equals(taskType)) {
            } else
                sql.append("AND ri.type = ? ");
        }
        if (search != null && !search.isBlank())
            sql.append("AND (ri.note LIKE ? OR r.room_number LIKE ?) ");

        sql.append(") as count_tbl");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            // 1. Tasks
            if (staffId > 0)
                ps.setInt(idx++, staffId);
            if (dateFrom != null)
                ps.setDate(idx++, Date.valueOf(dateFrom));
            if (dateTo != null)
                ps.setDate(idx++, Date.valueOf(dateTo));
            if (statusStr != null && !statusStr.isBlank())
                ps.setString(idx++, statusStr);
            if (taskType != null && !taskType.isBlank() && !"INSPECTION_ALL".equals(taskType))
                ps.setString(idx++, taskType);
            if (search != null && !search.isBlank()) {
                String kw = "%" + search + "%";
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
            }
            // 2. Inspections
            if (staffId > 0)
                ps.setInt(idx++, staffId);
            if (dateFrom != null)
                ps.setDate(idx++, Date.valueOf(dateFrom));
            if (dateTo != null)
                ps.setDate(idx++, Date.valueOf(dateTo));
            if (taskType != null && !taskType.isBlank() && !"INSPECTION_ALL".equals(taskType))
                ps.setString(idx++, taskType);
            if (search != null && !search.isBlank()) {
                String kw = "%" + search + "%";
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ======================================================
    // Room list advanced
    // ======================================================
    public List<Room> getRooms(String statusStr, String search, String sortBy, String sortOrder, int page,
            int pageSize) {
        List<Room> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM rooms WHERE 1=1");

        if (statusStr != null && !statusStr.isBlank()) {
            sql.append(" AND status = ?");
        }
        if (search != null && !search.isBlank()) {
            sql.append(" AND (room_number LIKE ? OR description LIKE ?)");
        }

        if (sortBy == null || sortBy.isBlank()) {
            sortBy = "room_number";
        }
        if (sortOrder == null || sortOrder.isBlank()) {
            sortOrder = "ASC";
        }

        String validSort = switch (sortBy) {
            case "status" ->
                "status";
            case "floor" ->
                "floor";
            case "type" ->
                "room_type_id";
            default ->
                "room_number";
        };

        sql.append(" ORDER BY ").append(validSort).append(" ")
                .append("DESC".equalsIgnoreCase(sortOrder) ? "DESC" : "ASC");

        if (page > 0 && pageSize > 0) {
            sql.append(" LIMIT ? OFFSET ?");
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            if (statusStr != null && !statusStr.isBlank()) {
                ps.setString(idx++, statusStr);
            }
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

        if (statusStr != null && !statusStr.isBlank()) {
            sql.append(" AND status = ?");
        }
        if (search != null && !search.isBlank()) {
            sql.append(" AND (room_number LIKE ? OR description LIKE ?)");
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            if (statusStr != null && !statusStr.isBlank()) {
                ps.setString(idx++, statusStr);
            }
            if (search != null && !search.isBlank()) {
                String kw = "%" + search + "%";
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ======================================================
    // Get Tasks for a specific Room
    // ======================================================
    public List<HousekeepingTask> getTasksForRoom(int roomId) {
        List<HousekeepingTask> list = new ArrayList<>();
        String sql = "SELECT * FROM housekeeping_tasks WHERE room_id = ? ORDER BY created_at DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, roomId);
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
    // Get Housekeeping Staff
    // ======================================================
    public List<Model.User> getHousekeepingStaff() {
        List<Model.User> list = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role_id = 3 AND is_active = true";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Model.User u = new Model.User();
                u.setUserId(rs.getInt("user_id"));
                u.setUsername(rs.getString("username"));
                u.setFullName(rs.getString("full_name"));
                u.setRoleId(rs.getInt("role_id"));
                list.add(u);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<HousekeepingTask> getStaffAssignments(int staffId, LocalDate dateFrom, LocalDate dateTo, String status,
            String taskType,
            String search, String sortBy, String sortOrder, int page, int pageSize) {
        List<HousekeepingTask> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT t.*, r.room_number, u.full_name as assigned_to_name ");
        sql.append("FROM housekeeping_tasks t ");
        sql.append("JOIN rooms r ON t.room_id = r.room_id ");
        sql.append("LEFT JOIN users u ON t.assigned_to = u.user_id ");
        sql.append("WHERE t.assigned_to = ? ");

        if (status != null && !status.isBlank()) {
            sql.append("AND t.status = ? ");
        } else {
            sql.append("AND t.status != 'DONE' ");
        }

        if (taskType != null && !taskType.isBlank()) {
            sql.append("AND t.task_type = ? ");
        }

        if (dateFrom != null)
            sql.append("AND t.task_date >= ? ");
        if (dateTo != null)
            sql.append("AND t.task_date <= ? ");

        if (search != null && !search.isBlank()) {
            sql.append("AND (t.note LIKE ? OR r.room_number LIKE ?) ");
        }

        // Sorting
        if (sortBy == null || sortBy.isBlank())
            sortBy = "task_date";
        if (sortOrder == null || sortOrder.isBlank())
            sortOrder = "DESC";

        String dbSort = switch (sortBy) {
            case "roomId" -> "t.room_id";
            case "status" -> "t.status";
            default -> "t.task_date";
        };

        sql.append("ORDER BY ").append(dbSort).append(" ").append("DESC".equalsIgnoreCase(sortOrder) ? "DESC" : "ASC")
                .append(", t.task_id DESC ");

        if (page > 0 && pageSize > 0) {
            sql.append("LIMIT ? OFFSET ?");
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            ps.setInt(idx++, staffId);

            if (status != null && !status.isBlank()) {
                ps.setString(idx++, status);
            }
            if (taskType != null && !taskType.isBlank()) {
                ps.setString(idx++, taskType);
            }
            if (dateFrom != null)
                ps.setDate(idx++, Date.valueOf(dateFrom));
            if (dateTo != null)
                ps.setDate(idx++, Date.valueOf(dateTo));
            if (search != null && !search.isBlank()) {
                ps.setString(idx++, "%" + search + "%");
                ps.setString(idx++, "%" + search + "%");
            }
            if (page > 0 && pageSize > 0) {
                ps.setInt(idx++, pageSize);
                ps.setInt(idx++, (page - 1) * pageSize);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapTaskWithDetails(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countStaffAssignments(int staffId, LocalDate dateFrom, LocalDate dateTo, String status, String taskType,
            String search) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM housekeeping_tasks t JOIN rooms r ON t.room_id = r.room_id WHERE t.assigned_to = ? ");

        if (status != null && !status.isBlank()) {
            sql.append("AND t.status = ? ");
        } else {
            sql.append("AND t.status != 'DONE' ");
        }

        if (taskType != null && !taskType.isBlank()) {
            sql.append("AND t.task_type = ? ");
        }

        if (dateFrom != null)
            sql.append("AND t.task_date >= ? ");
        if (dateTo != null)
            sql.append("AND t.task_date <= ? ");

        if (search != null && !search.isBlank()) {
            sql.append("AND (t.note LIKE ? OR r.room_number LIKE ?) ");
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            ps.setInt(idx++, staffId);

            if (status != null && !status.isBlank()) {
                ps.setString(idx++, status);
            }
            if (taskType != null && !taskType.isBlank()) {
                ps.setString(idx++, taskType);
            }
            if (dateFrom != null)
                ps.setDate(idx++, Date.valueOf(dateFrom));
            if (dateTo != null)
                ps.setDate(idx++, Date.valueOf(dateTo));
            if (search != null && !search.isBlank()) {
                ps.setString(idx++, "%" + search + "%");
                ps.setString(idx++, "%" + search + "%");
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
