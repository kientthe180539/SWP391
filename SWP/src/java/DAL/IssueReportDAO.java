package DAL;

import Model.IssueReport;
import Model.IssueReport.IssueStatus;
import Model.IssueReport.IssueType;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class IssueReportDAO extends DAO {

    public static final IssueReportDAO INSTANCE = new IssueReportDAO();

    private IssueReportDAO() {
    }

    public boolean createIssueReport(IssueReport report) {
        String sql = "INSERT INTO issue_reports (room_id, booking_id, reported_by, issue_type, description, status, created_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, NOW())";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, report.getRoomId());

            if (report.getBookingId() != null) {
                ps.setInt(2, report.getBookingId());
            } else {
                ps.setNull(2, Types.INTEGER);
            }

            ps.setInt(3, report.getReportedBy());
            ps.setString(4, report.getIssueType().name());
            ps.setString(5, report.getDescription());
            ps.setString(6, report.getStatus().name());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<IssueReport> getIssuesByBookingId(int bookingId) {
        List<IssueReport> list = new ArrayList<>();
        String sql = "SELECT * FROM issue_reports WHERE booking_id = ? ORDER BY created_at DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapIssueReport(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private IssueReport mapIssueReport(ResultSet rs) throws SQLException {
        IssueReport report = new IssueReport();
        report.setIssueId(rs.getInt("issue_id"));
        report.setRoomId(rs.getInt("room_id"));
        report.setBookingId(rs.getInt("booking_id"));
        report.setReportedBy(rs.getInt("reported_by"));

        try {
            report.setIssueType(IssueType.valueOf(rs.getString("issue_type")));
        } catch (Exception e) {
            report.setIssueType(IssueType.OTHER);
        }

        report.setDescription(rs.getString("description"));

        try {
            report.setStatus(IssueStatus.valueOf(rs.getString("status")));
        } catch (Exception e) {
            report.setStatus(IssueStatus.NEW);
        }

        Timestamp cAt = rs.getTimestamp("created_at");
        if (cAt != null)
            report.setCreatedAt(cAt.toLocalDateTime());

        Timestamp uAt = rs.getTimestamp("updated_at");
        if (uAt != null)
            report.setUpdatedAt(uAt.toLocalDateTime());

        return report;
    }
}
