package com.demo.web.dao.Admin;

import com.demo.web.util.DatabaseUtil;

import java.sql.*;
import java.util.*;
import java.util.logging.Logger;

public class AdminUserDAO {

    private static final Logger logger = Logger.getLogger(AdminUserDAO.class.getName());

    public List<Map<String, Object>> getAllUsers() {
        List<Map<String, Object>> users = new ArrayList<>();

        String sql = "SELECT u.user_id, u.username, u.email, u.is_active, u.joined_at, u.last_login, " +
                     "u.profile_picture_url " +
                     "FROM users u ORDER BY u.user_id ASC";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> user = new HashMap<>();
                user.put("userId", rs.getInt("user_id"));
                user.put("username", rs.getString("username"));
                user.put("email", rs.getString("email"));
                user.put("isActive", rs.getBoolean("is_active"));
                user.put("joinedAt", rs.getDate("joined_at"));
                user.put("lastLogin", rs.getTimestamp("last_login"));
                user.put("profilePictureUrl", rs.getString("profile_picture_url"));
                users.add(user);
            }
            logger.info("[AdminUserDAO] Loaded " + users.size() + " users");
        } catch (SQLException e) {
            logger.severe("[AdminUserDAO] Error loading users: " + e.getMessage());
            e.printStackTrace();
        }
        return users;
    }

    public int getTotalUserCount() {
        String sql = "SELECT COUNT(*) FROM users";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            logger.severe("[AdminUserDAO] Error getting user count: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    public int getActiveUserCount() {
        String sql = "SELECT COUNT(*) FROM users WHERE is_active = true";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            logger.severe("[AdminUserDAO] Error getting active user count: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    public int getInactiveUserCount() {
        String sql = "SELECT COUNT(*) FROM users WHERE is_active = false";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            logger.severe("[AdminUserDAO] Error getting inactive user count: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    public int getNewUsersCount() {
        String sql = "SELECT COUNT(*) FROM users WHERE joined_at >= CURRENT_DATE - INTERVAL '30 days'";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            logger.severe("[AdminUserDAO] Error getting new users count: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    public boolean setUserActiveStatus(int userId, boolean active) {
        String sql = "UPDATE users SET is_active = ? WHERE user_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setBoolean(1, active);
            stmt.setInt(2, userId);
            int affected = stmt.executeUpdate();
            logger.info("[AdminUserDAO] User " + userId + " active status set to " + active + " (affected: " + affected + ")");
            return affected > 0;
        } catch (SQLException e) {
            logger.severe("[AdminUserDAO] Error updating user status: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteUser(int userId) {
        Connection conn = null;
        try {
            conn = DatabaseUtil.getConnection();
            conn.setAutoCommit(false);

            String[] deletionQueries = {
                "DELETE FROM feed_comment_likes WHERE feed_profile_id IN (SELECT feed_profile_id FROM feed_profiles WHERE user_id = ?)",
                "DELETE FROM feed_post_likes WHERE feed_profile_id IN (SELECT feed_profile_id FROM feed_profiles WHERE user_id = ?)",
                "DELETE FROM feed_post_comments WHERE feed_profile_id IN (SELECT feed_profile_id FROM feed_profiles WHERE user_id = ?)",
                "DELETE FROM saved_posts WHERE feed_profile_id IN (SELECT feed_profile_id FROM feed_profiles WHERE user_id = ?)",
                "DELETE FROM feed_follows WHERE follower_id IN (SELECT feed_profile_id FROM feed_profiles WHERE user_id = ?) OR following_id IN (SELECT feed_profile_id FROM feed_profiles WHERE user_id = ?)",
                "DELETE FROM blocked_users WHERE blocker_profile_id IN (SELECT feed_profile_id FROM feed_profiles WHERE user_id = ?) OR blocked_profile_id IN (SELECT feed_profile_id FROM feed_profiles WHERE user_id = ?)",
                "DELETE FROM post_reports WHERE reporter_profile_id IN (SELECT feed_profile_id FROM feed_profiles WHERE user_id = ?)",
                "DELETE FROM post_reports WHERE post_id IN (SELECT post_id FROM feed_posts WHERE feed_profile_id IN (SELECT feed_profile_id FROM feed_profiles WHERE user_id = ?))",
                "DELETE FROM feed_posts WHERE feed_profile_id IN (SELECT feed_profile_id FROM feed_profiles WHERE user_id = ?)",
                "DELETE FROM feed_profiles WHERE user_id = ?",
                "DELETE FROM autograph_entry WHERE user_id = ?",
                "DELETE FROM autograph_activity WHERE user_id = ?",
                "DELETE FROM autograph WHERE user_id = ?",
                "DELETE FROM journal_streaks WHERE user_id = ?",
                "DELETE FROM journal WHERE user_id = ?",
                "DELETE FROM group_member WHERE member_id = ?",
                "DELETE FROM memory_members WHERE user_id = ?",
                "DELETE FROM user_sessions WHERE user_id = ?",
                "DELETE FROM users WHERE user_id = ?"
            };

            for (String query : deletionQueries) {
                try (PreparedStatement stmt = conn.prepareStatement(query)) {
                    int paramCount = query.length() - query.replace("?", "").length();
                    for (int i = 1; i <= paramCount; i++) {
                        stmt.setInt(i, userId);
                    }
                    stmt.executeUpdate();
                } catch (SQLException e) {
                    logger.warning("[AdminUserDAO] Non-critical delete error for user " + userId + ": " + e.getMessage());
                }
            }

            conn.commit();
            logger.info("[AdminUserDAO] Successfully deleted user " + userId);
            return true;
        } catch (SQLException e) {
            logger.severe("[AdminUserDAO] Error deleting user " + userId + ": " + e.getMessage());
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        return false;
    }

    public Map<String, Object> getUserById(int userId) {
        String sql = "SELECT u.user_id, u.username, u.email, u.is_active, u.joined_at, u.last_login, " +
                     "u.profile_picture_url, u.bio " +
                     "FROM users u WHERE u.user_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Map<String, Object> user = new HashMap<>();
                user.put("userId", rs.getInt("user_id"));
                user.put("username", rs.getString("username"));
                user.put("email", rs.getString("email"));
                user.put("isActive", rs.getBoolean("is_active"));
                user.put("joinedAt", rs.getDate("joined_at"));
                user.put("lastLogin", rs.getTimestamp("last_login"));
                user.put("profilePictureUrl", rs.getString("profile_picture_url"));
                user.put("bio", rs.getString("bio"));
                return user;
            }
        } catch (SQLException e) {
            logger.severe("[AdminUserDAO] Error getting user by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public List<Map<String, Object>> getMostActiveUsers(int limit) {
        List<Map<String, Object>> users = new ArrayList<>();

        String sql = "SELECT u.user_id, u.username, u.profile_picture_url, " +
                     "COALESCE(fp_count.post_count, 0) + COALESCE(m_count.memory_count, 0) + COALESCE(j_count.journal_count, 0) AS activity_count " +
                     "FROM users u " +
                     "LEFT JOIN (SELECT fp.user_id, COUNT(fpt.post_id) AS post_count FROM feed_profiles fp " +
                     "LEFT JOIN feed_posts fpt ON fp.feed_profile_id = fpt.feed_profile_id GROUP BY fp.user_id) fp_count ON u.user_id = fp_count.user_id " +
                     "LEFT JOIN (SELECT user_id, COUNT(*) AS memory_count FROM memory GROUP BY user_id) m_count ON u.user_id = m_count.user_id " +
                     "LEFT JOIN (SELECT user_id, COUNT(*) AS journal_count FROM journal GROUP BY user_id) j_count ON u.user_id = j_count.user_id " +
                     "WHERE u.is_active = true " +
                     "ORDER BY activity_count DESC LIMIT ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Map<String, Object> user = new HashMap<>();
                user.put("userId", rs.getInt("user_id"));
                user.put("username", rs.getString("username"));
                user.put("profilePictureUrl", rs.getString("profile_picture_url"));
                user.put("activityCount", rs.getInt("activity_count"));
                users.add(user);
            }
        } catch (SQLException e) {
            logger.severe("[AdminUserDAO] Error getting most active users: " + e.getMessage());
            e.printStackTrace();
        }
        return users;
    }

    public List<Map<String, Object>> getLeastActiveUsers(int limit) {
        List<Map<String, Object>> users = new ArrayList<>();

        String sql = "SELECT u.user_id, u.username, u.profile_picture_url, " +
                     "COALESCE(fp_count.post_count, 0) + COALESCE(m_count.memory_count, 0) + COALESCE(j_count.journal_count, 0) AS activity_count " +
                     "FROM users u " +
                     "LEFT JOIN (SELECT fp.user_id, COUNT(fpt.post_id) AS post_count FROM feed_profiles fp " +
                     "LEFT JOIN feed_posts fpt ON fp.feed_profile_id = fpt.feed_profile_id GROUP BY fp.user_id) fp_count ON u.user_id = fp_count.user_id " +
                     "LEFT JOIN (SELECT user_id, COUNT(*) AS memory_count FROM memory GROUP BY user_id) m_count ON u.user_id = m_count.user_id " +
                     "LEFT JOIN (SELECT user_id, COUNT(*) AS journal_count FROM journal GROUP BY user_id) j_count ON u.user_id = j_count.user_id " +
                     "WHERE u.is_active = true " +
                     "ORDER BY activity_count ASC LIMIT ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Map<String, Object> user = new HashMap<>();
                user.put("userId", rs.getInt("user_id"));
                user.put("username", rs.getString("username"));
                user.put("profilePictureUrl", rs.getString("profile_picture_url"));
                user.put("activityCount", rs.getInt("activity_count"));
                users.add(user);
            }
        } catch (SQLException e) {
            logger.severe("[AdminUserDAO] Error getting least active users: " + e.getMessage());
            e.printStackTrace();
        }
        return users;
    }
}
