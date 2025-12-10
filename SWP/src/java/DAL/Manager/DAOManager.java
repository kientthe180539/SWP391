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
        String sql = "SELECT * FROM issue_reports ORDER BY created_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapIssue(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
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
        String sql = "SELECT sa.*, u.full_name FROM staff_assignments sa " +
                "JOIN users u ON sa.employee_id = u.user_id " +
                "WHERE sa.work_date = ? " +
                "ORDER BY sa.shift_type, u.full_name";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setDate(1, Date.valueOf(date));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Model.StaffAssignment sa = new Model.StaffAssignment();
                    sa.setAssignmentId(rs.getInt("assignment_id"));
                    sa.setEmployeeId(rs.getInt("employee_id"));
                    sa.setEmployeeName(rs.getString("full_name"));
                    sa.setWorkDate(rs.getDate("work_date").toLocalDate());

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

                    // We might need to extend StaffAssignment model to hold employee name
                    // or just fetch it separately. For now, let's assume we can't easily add it
                    // without modifying the model.
                    // Ideally, we should update the Model or use a DTO.
                    // Let's check StaffAssignment model first.
                    // For now, I'll just return the object and let the controller/view handle name
                    // fetching
                    // or I'll modify the model in a separate step if needed.
                    // Actually, let's check the model first.

                    list.add(sa);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
