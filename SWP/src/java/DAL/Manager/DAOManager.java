package DAL.Manager;

import DAL.DAO;
import Model.IssueReport;
import Model.IssueReport.IssueStatus;
import Model.IssueReport.IssueType;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class DAOManager extends DAO {

    public static final DAOManager INSTANCE = new DAOManager();

    private DAOManager() {
    }

    // ======================================================
    // Dashboard Stats
    // ======================================================
    public int getOpenIssuesCount() {
        String sql = "SELECT COUNT(*) FROM issue_reports WHERE status != 'CLOSED'";
        try (PreparedStatement ps = connection.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ======================================================
    // Issue Management
    // ======================================================
    public List<IssueReport> getAllIssues() {
        List<IssueReport> list = new ArrayList<>();
        String sql = "SELECT ir.*, r.room_number FROM issue_reports ir " +
                "LEFT JOIN rooms r ON ir.room_id = r.room_id " +
                "ORDER BY ir.created_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                IssueReport issue = mapIssue(rs);
                issue.setRoomNumber(rs.getString("room_number"));
                list.add(issue);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<IssueReport> getIssues(String search, String status, String type, String sortBy, int page,
            int pageSize) {
        List<IssueReport> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT ir.*, r.room_number FROM issue_reports ir LEFT JOIN rooms r ON ir.room_id = r.room_id WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

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
        if (sortBy != null) {
            switch (sortBy) {
                case "room_id" -> sql.append("ORDER BY ir.room_id ASC ");
                case "priority" -> sql.append("ORDER BY ir.status ASC "); // Mapping priority to status for now
                default -> sql.append("ORDER BY ir.created_at DESC ");
            }
        } else {
            sql.append("ORDER BY ir.created_at DESC ");
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
                    IssueReport issue = mapIssue(rs);
                    issue.setRoomNumber(rs.getString("room_number"));
                    list.add(issue);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countIssues(String search, String status, String type) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM issue_reports ir LEFT JOIN rooms r ON ir.room_id = r.room_id WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

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

    public boolean updateIssueStatus(int issueId, IssueStatus newStatus) {
        String sql = "UPDATE issue_reports SET status = ?, updated_at = NOW() WHERE issue_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, newStatus.name());
            ps.setInt(2, issueId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean createIssue(IssueReport issue) {
        String sql = "{CALL sp_create_issue_report(?, ?, ?, ?, ?, ?, ?)}";
        try (CallableStatement cs = connection.prepareCall(sql)) {
            cs.setInt(1, issue.getRoomId());
            if (issue.getBookingId() != null) {
                cs.setInt(2, issue.getBookingId());
            } else {
                cs.setNull(2, Types.INTEGER);
            }
            cs.setInt(3, issue.getReportedBy());
            cs.setString(4, issue.getIssueType().name());
            cs.setString(5, issue.getDescription());
            cs.setString(6, issue.getStatus().name());
            cs.registerOutParameter(7, Types.INTEGER);

            cs.execute();
            return cs.getInt(7) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private IssueReport mapIssue(ResultSet rs) throws SQLException {
        IssueReport i = new IssueReport();
        i.setIssueId(rs.getInt("issue_id"));
        i.setRoomId(rs.getInt("room_id"));
        i.setBookingId((Integer) rs.getObject("booking_id")); // Handle null
        i.setReportedBy(rs.getInt("reported_by"));

        try {
            i.setIssueType(IssueType.valueOf(rs.getString("issue_type")));
        } catch (Exception e) {
            i.setIssueType(IssueType.OTHER);
        }

        i.setDescription(rs.getString("description"));

        try {
            i.setStatus(IssueStatus.valueOf(rs.getString("status")));
        } catch (Exception e) {
            i.setStatus(IssueStatus.NEW);
        }

        Timestamp cAt = rs.getTimestamp("created_at");
        if (cAt != null)
            i.setCreatedAt(cAt.toLocalDateTime());

        Timestamp uAt = rs.getTimestamp("updated_at");
        if (uAt != null)
            i.setUpdatedAt(uAt.toLocalDateTime());

        return i;
    }

    // ======================================================
    // Staff Management
    // ======================================================
    public List<Model.StaffAssignment> getAllStaffAssignments(LocalDate date) {
        List<Model.StaffAssignment> list = new ArrayList<>();
        // Modified query: Get ALL staff (role_id=3) and left join their assignments for
        // the date
        String sql = "SELECT u.user_id, u.full_name, u.is_active, sa.* " +
                "FROM users u " +
                "LEFT JOIN staff_assignments sa ON u.user_id = sa.employee_id AND sa.work_date = ? " +
                "WHERE u.role_id = 3 " +
                "ORDER BY u.full_name";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setDate(1, Date.valueOf(date));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Model.StaffAssignment sa = new Model.StaffAssignment();

                    // Basic user info
                    sa.setEmployeeId(rs.getInt("user_id"));
                    sa.setEmployeeName(rs.getString("full_name"));
                    sa.setAccountActive(rs.getBoolean("is_active"));
                    sa.setWorkDate(date); // Even if unassigned, we show the queried date

                    // Check if assignment exists
                    if (rs.getObject("assignment_id") != null) {
                        sa.setAssignmentId(rs.getInt("assignment_id"));
                        try {
                            sa.setShiftType(Model.StaffAssignment.ShiftType.valueOf(rs.getString("shift_type")));
                        } catch (Exception e) {
                            sa.setShiftType(Model.StaffAssignment.ShiftType.MORNING);
                        }
                        try {
                            sa.setStatus(Model.StaffAssignment.StaffStatus.valueOf(rs.getString("status")));
                        } catch (Exception e) {
                            sa.setStatus(Model.StaffAssignment.StaffStatus.ON_SHIFT);
                        }
                    } else {
                        // Unassigned - Set as OFF_SHIFT
                        sa.setShiftType(Model.StaffAssignment.ShiftType.MORNING); // Default
                        sa.setStatus(Model.StaffAssignment.StaffStatus.OFF_SHIFT);
                    }

                    list.add(sa);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
