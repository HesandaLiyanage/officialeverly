package com.demo.web.dao.Admin;

import com.demo.web.util.DatabaseUtil;

import java.sql.*;
import java.util.*;
import java.util.logging.Logger;

public class AdminDashboardDAO {

    private static final Logger logger = Logger.getLogger(AdminDashboardDAO.class.getName());


    public int getTotalUsers() {
        return getCount("SELECT COUNT(*) FROM users");
    }

    public int getActiveUsers() {
        return getCount("SELECT COUNT(*) FROM users WHERE is_active = true");
    }

    public int getNewUsersThisWeek() {
        return getCount("SELECT COUNT(*) FROM users WHERE joined_at >= CURRENT_DATE - INTERVAL '7 days'");
    }

    public int getNewUsersThisMonth() {
        return getCount("SELECT COUNT(*) FROM users WHERE joined_at >= CURRENT_DATE - INTERVAL '30 days'");
    }

    public int getTotalPosts() {
        return getCount("SELECT COUNT(*) FROM feed_posts");
    }

    public int getTotalMemories() {
        return getCount("SELECT COUNT(*) FROM memory");
    }

    public int getTotalJournals() {
        return getCount("SELECT COUNT(*) FROM journal");
    }

    public int getTotalGroups() {
        return getCount("SELECT COUNT(*) FROM \"group\"");
    }

    public int getTotalEvents() {
        return getCount("SELECT COUNT(*) FROM event");
    }

    public int getPendingReports() {
        return getCount("SELECT COUNT(*) FROM post_reports WHERE status = 'pending'");
    }

    public int getTotalContent() {
        return getTotalPosts() + getTotalMemories() + getTotalJournals();
    }


    public List<Map<String, Object>> getUserRegistrationTrend(int days) {
        List<Map<String, Object>> trend = new ArrayList<>();

        String sql = "SELECT DATE(joined_at) AS reg_date, COUNT(*) AS count " +
                     "FROM users WHERE joined_at >= CURRENT_DATE - INTERVAL '" + days + " days' " +
                     "GROUP BY DATE(joined_at) ORDER BY reg_date ASC";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> entry = new HashMap<>();
                entry.put("date", rs.getDate("reg_date"));
                entry.put("count", rs.getInt("count"));
                trend.add(entry);
            }
        } catch (SQLException e) {
            logger.severe("[AdminDashboardDAO] Error getting registration trend: " + e.getMessage());
        }
        return trend;
    }

    public List<Map<String, Object>> getPostTrend(int days) {
        List<Map<String, Object>> trend = new ArrayList<>();

        String sql = "SELECT DATE(created_at) AS post_date, COUNT(*) AS count " +
                     "FROM feed_posts WHERE created_at >= CURRENT_DATE - INTERVAL '" + days + " days' " +
                     "GROUP BY DATE(created_at) ORDER BY post_date ASC";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> entry = new HashMap<>();
                entry.put("date", rs.getDate("post_date"));
                entry.put("count", rs.getInt("count"));
                trend.add(entry);
            }
        } catch (SQLException e) {
            logger.severe("[AdminDashboardDAO] Error getting post trend: " + e.getMessage());
        }
        return trend;
    }

    public List<Map<String, Object>> getTopPosters(int limit) {
        List<Map<String, Object>> posters = new ArrayList<>();

        String sql = "SELECT fp.feed_username, COUNT(p.post_id) AS post_count " +
                     "FROM feed_posts p " +
                     "JOIN feed_profiles fp ON p.feed_profile_id = fp.feed_profile_id " +
                     "GROUP BY fp.feed_username " +
                     "ORDER BY post_count DESC LIMIT ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Map<String, Object> entry = new HashMap<>();
                entry.put("username", rs.getString("feed_username"));
                entry.put("postCount", rs.getInt("post_count"));
                posters.add(entry);
            }
        } catch (SQLException e) {
            logger.severe("[AdminDashboardDAO] Error getting top posters: " + e.getMessage());
        }
        return posters;
    }

    public List<Map<String, Object>> getMostLikedPosts(int limit) {
        List<Map<String, Object>> posts = new ArrayList<>();

        String sql = "SELECT p.post_id, p.caption, fp.feed_username, " +
                     "COUNT(l.like_id) AS like_count " +
                     "FROM feed_posts p " +
                     "JOIN feed_profiles fp ON p.feed_profile_id = fp.feed_profile_id " +
                     "LEFT JOIN feed_post_likes l ON p.post_id = l.post_id " +
                     "GROUP BY p.post_id, p.caption, fp.feed_username " +
                     "ORDER BY like_count DESC LIMIT ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Map<String, Object> entry = new HashMap<>();
                entry.put("postId", rs.getInt("post_id"));
                entry.put("caption", rs.getString("caption"));
                entry.put("username", rs.getString("feed_username"));
                entry.put("likeCount", rs.getInt("like_count"));
                posts.add(entry);
            }
        } catch (SQLException e) {
            logger.severe("[AdminDashboardDAO] Error getting most liked posts: " + e.getMessage());
        }
        return posts;
    }

    public List<Map<String, Object>> getRecentSignups(int limit) {
        List<Map<String, Object>> users = new ArrayList<>();

        String sql = "SELECT username, email, joined_at FROM users " +
                     "ORDER BY joined_at DESC LIMIT ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Map<String, Object> entry = new HashMap<>();
                entry.put("username", rs.getString("username"));
                entry.put("email", rs.getString("email"));
                entry.put("joinedAt", rs.getTimestamp("joined_at"));
                users.add(entry);
            }
        } catch (SQLException e) {
            logger.severe("[AdminDashboardDAO] Error getting recent signups: " + e.getMessage());
        }
        return users;
    }

    public Map<String, Integer> getContentBreakdown() {
        Map<String, Integer> breakdown = new HashMap<>();
        breakdown.put("posts", getTotalPosts());
        breakdown.put("memories", getTotalMemories());
        breakdown.put("journals", getTotalJournals());

        try {
            breakdown.put("groups", getTotalGroups());
        } catch (Exception e) {
            breakdown.put("groups", 0);
        }
        try {
            breakdown.put("events", getTotalEvents());
        } catch (Exception e) {
            breakdown.put("events", 0);
        }

        return breakdown;
    }


    private int getCount(String sql) {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            logger.warning("[AdminDashboardDAO] Error executing count query: " + e.getMessage());
        }
        return 0;
    }
}
