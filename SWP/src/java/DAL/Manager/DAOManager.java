package DAL.Manager;

import DAL.DAO;
import Model.IssueReport;
import Model.IssueReport.IssueStatus;
import Model.IssueReport.IssueType;
import java.sql.*;
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
        if (cAt != null) i.setCreatedAt(cAt.toLocalDateTime());
        
        Timestamp uAt = rs.getTimestamp("updated_at");
        if (uAt != null) i.setUpdatedAt(uAt.toLocalDateTime());
        
        return i;
    }
}
