package com.demo.web.dao.Feed;

import com.demo.web.util.DatabaseUtil;

import java.sql.*;
import java.util.*;
import java.util.logging.Logger;

/**
 * Data Access Object for Post Report operations.
 * Handles creating reports from the feed and retrieving them for admin panel.
 */
public class PostReportDAO {

    private static final Logger logger = Logger.getLogger(PostReportDAO.class.getName());

    /**
     * Create a new post report.
     * Returns true if report was created, false if already reported by this user.
     */
    public boolean createReport(int postId, int reporterProfileId, String reason) {
        String sql = "INSERT INTO post_reports (post_id, reporter_profile_id, reason) " +
                     "VALUES (?, ?, ?) ON CONFLICT (post_id, reporter_profile_id) DO NOTHING";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, postId);
            stmt.setInt(2, reporterProfileId);
            stmt.setString(3, reason != null ? reason : "other");

            int affected = stmt.executeUpdate();
            logger.info("[PostReportDAO] Report created for post " + postId + " by profile " + reporterProfileId + " (affected: " + affected + ")");
            return affected > 0;
        } catch (SQLException e) {
            logger.severe("[PostReportDAO] Error creating report: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Check if a user has already reported a post.
     */
    public boolean hasUserReported(int postId, int reporterProfileId) {
        String sql = "SELECT COUNT(*) FROM post_reports WHERE post_id = ? AND reporter_profile_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, postId);
            stmt.setInt(2, reporterProfileId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            logger.severe("[PostReportDAO] Error checking report: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Get all reported posts with details for admin content management.
     * Only returns posts that have been reported (not all posts).
     */
    public List<Map<String, Object>> getReportedPosts() {
        List<Map<String, Object>> reports = new ArrayList<>();

        String sql = "SELECT pr.report_id, pr.post_id, pr.reason, pr.status, pr.created_at, pr.admin_notes, " +
                     "pr.reviewed_at, " +
                     "fp_reporter.feed_username AS reporter_username, " +
                     "fp_poster.feed_username AS poster_username, " +
                     "p.caption, p.created_at AS post_date, " +
                     "COUNT(*) OVER (PARTITION BY pr.post_id) AS report_count " +
                     "FROM post_reports pr " +
                     "JOIN feed_profiles fp_reporter ON pr.reporter_profile_id = fp_reporter.feed_profile_id " +
                     "JOIN feed_posts p ON pr.post_id = p.post_id " +
                     "JOIN feed_profiles fp_poster ON p.feed_profile_id = fp_poster.feed_profile_id " +
                     "ORDER BY pr.created_at DESC";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> report = new HashMap<>();
                report.put("reportId", rs.getInt("report_id"));
                report.put("postId", rs.getInt("post_id"));
                report.put("reason", rs.getString("reason"));
                report.put("status", rs.getString("status"));
                report.put("createdAt", rs.getTimestamp("created_at"));
                report.put("adminNotes", rs.getString("admin_notes"));
                report.put("reviewedAt", rs.getTimestamp("reviewed_at"));
                report.put("reporterUsername", rs.getString("reporter_username"));
                report.put("posterUsername", rs.getString("poster_username"));
                report.put("caption", rs.getString("caption"));
                report.put("postDate", rs.getTimestamp("post_date"));
                report.put("reportCount", rs.getInt("report_count"));
                reports.add(report);
            }
            logger.info("[PostReportDAO] Loaded " + reports.size() + " reported posts");
        } catch (SQLException e) {
            logger.severe("[PostReportDAO] Error loading reported posts: " + e.getMessage());
            e.printStackTrace();
        }
        return reports;
    }

    /**
     * Get reported posts filtered by status.
     */
    public List<Map<String, Object>> getReportedPostsByStatus(String status) {
        List<Map<String, Object>> reports = new ArrayList<>();

        String sql = "SELECT pr.report_id, pr.post_id, pr.reason, pr.status, pr.created_at, pr.admin_notes, " +
                     "pr.reviewed_at, " +
                     "fp_reporter.feed_username AS reporter_username, " +
                     "fp_poster.feed_username AS poster_username, " +
                     "p.caption, p.created_at AS post_date, " +
                     "COUNT(*) OVER (PARTITION BY pr.post_id) AS report_count " +
                     "FROM post_reports pr " +
                     "JOIN feed_profiles fp_reporter ON pr.reporter_profile_id = fp_reporter.feed_profile_id " +
                     "JOIN feed_posts p ON pr.post_id = p.post_id " +
                     "JOIN feed_profiles fp_poster ON p.feed_profile_id = fp_poster.feed_profile_id " +
                     "WHERE pr.status = ? " +
                     "ORDER BY pr.created_at DESC";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Map<String, Object> report = new HashMap<>();
                report.put("reportId", rs.getInt("report_id"));
                report.put("postId", rs.getInt("post_id"));
                report.put("reason", rs.getString("reason"));
                report.put("status", rs.getString("status"));
                report.put("createdAt", rs.getTimestamp("created_at"));
                report.put("adminNotes", rs.getString("admin_notes"));
                report.put("reviewedAt", rs.getTimestamp("reviewed_at"));
                report.put("reporterUsername", rs.getString("reporter_username"));
                report.put("posterUsername", rs.getString("poster_username"));
                report.put("caption", rs.getString("caption"));
                report.put("postDate", rs.getTimestamp("post_date"));
                report.put("reportCount", rs.getInt("report_count"));
                reports.add(report);
            }
        } catch (SQLException e) {
            logger.severe("[PostReportDAO] Error loading reported posts by status: " + e.getMessage());
            e.printStackTrace();
        }
        return reports;
    }

    /**
     * Update report status (admin action).
     */
    public boolean updateReportStatus(int reportId, String status, String adminNotes, int reviewedBy) {
        String sql = "UPDATE post_reports SET status = ?, admin_notes = ?, reviewed_at = CURRENT_TIMESTAMP, " +
                     "reviewed_by = ? WHERE report_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            stmt.setString(2, adminNotes);
            stmt.setInt(3, reviewedBy);
            stmt.setInt(4, reportId);

            int affected = stmt.executeUpdate();
            logger.info("[PostReportDAO] Report " + reportId + " status updated to " + status);
            return affected > 0;
        } catch (SQLException e) {
            logger.severe("[PostReportDAO] Error updating report status: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Delete a reported post and mark all its reports as action_taken.
     */
    public boolean deleteReportedPost(int postId, int reviewedBy) {
        Connection conn = null;
        try {
            conn = DatabaseUtil.getConnection();
            conn.setAutoCommit(false);

            // Mark all reports for this post as action_taken
            String updateSql = "UPDATE post_reports SET status = 'action_taken', " +
                              "admin_notes = COALESCE(admin_notes, '') || ' Post deleted by admin.', " +
                              "reviewed_at = CURRENT_TIMESTAMP, reviewed_by = ? WHERE post_id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(updateSql)) {
                stmt.setInt(1, reviewedBy);
                stmt.setInt(2, postId);
                stmt.executeUpdate();
            }

            // Delete related data
            String[] deletionQueries = {
                "DELETE FROM feed_post_likes WHERE post_id = ?",
                "DELETE FROM feed_post_comments WHERE post_id = ?",
                "DELETE FROM saved_posts WHERE post_id = ?",
                "DELETE FROM post_reports WHERE post_id = ?",
                "DELETE FROM feed_posts WHERE post_id = ?"
            };

            for (String query : deletionQueries) {
                try (PreparedStatement stmt = conn.prepareStatement(query)) {
                    stmt.setInt(1, postId);
                    stmt.executeUpdate();
                } catch (SQLException e) {
                    logger.warning("[PostReportDAO] Non-critical delete error: " + e.getMessage());
                }
            }

            conn.commit();
            logger.info("[PostReportDAO] Deleted reported post " + postId);
            return true;
        } catch (SQLException e) {
            logger.severe("[PostReportDAO] Error deleting reported post: " + e.getMessage());
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
        return false;
    }

    /**
     * Get report statistics for admin overview dashboard.
     */
    public Map<String, Integer> getReportStats() {
        Map<String, Integer> stats = new HashMap<>();

        String sql = "SELECT status, COUNT(*) AS cnt FROM post_reports GROUP BY status";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            int total = 0;
            while (rs.next()) {
                String status = rs.getString("status");
                int count = rs.getInt("cnt");
                stats.put(status, count);
                total += count;
            }
            stats.put("total", total);
        } catch (SQLException e) {
            logger.severe("[PostReportDAO] Error getting report stats: " + e.getMessage());
            e.printStackTrace();
        }
        return stats;
    }

    /**
     * Get total pending reports count.
     */
    public int getPendingReportCount() {
        String sql = "SELECT COUNT(*) FROM post_reports WHERE status = 'pending'";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            logger.severe("[PostReportDAO] Error getting pending count: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
}
