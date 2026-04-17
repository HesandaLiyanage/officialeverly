package com.demo.web.dao.Notifications;

import com.demo.web.util.DatabaseUtil;

import java.sql.*;
import java.util.*;

public class NotificationDAO {

    private static volatile boolean schemaEnsured = false;

    public NotificationDAO() {
        ensureSchema();
    }

    private void ensureSchema() {
        if (schemaEnsured) {
            return;
        }

        synchronized (NotificationDAO.class) {
            if (schemaEnsured) {
                return;
            }

            try (Connection conn = DatabaseUtil.getConnection();
                 Statement stmt = conn.createStatement()) {

                stmt.execute("""
                        CREATE TABLE IF NOT EXISTS notification_preferences (
                            pref_id SERIAL PRIMARY KEY,
                            user_id INTEGER NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
                            notif_type VARCHAR(50) NOT NULL,
                            enabled BOOLEAN NOT NULL DEFAULT TRUE,
                            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                            UNIQUE (user_id, notif_type)
                        )
                        """);

                stmt.execute("""
                        CREATE TABLE IF NOT EXISTS notifications (
                            notification_id SERIAL PRIMARY KEY,
                            user_id INTEGER NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
                            notif_type VARCHAR(50) NOT NULL,
                            title VARCHAR(255) NOT NULL,
                            message TEXT NOT NULL,
                            link VARCHAR(500),
                            is_read BOOLEAN NOT NULL DEFAULT FALSE,
                            actor_id INTEGER REFERENCES users(user_id) ON DELETE SET NULL,
                            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                        )
                        """);

                stmt.execute("CREATE INDEX IF NOT EXISTS idx_notif_prefs_user_id ON notification_preferences (user_id)");
                stmt.execute("CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON notifications (user_id)");
                stmt.execute("CREATE INDEX IF NOT EXISTS idx_notifications_user_unread ON notifications (user_id, is_read)");
                stmt.execute("CREATE INDEX IF NOT EXISTS idx_notifications_created_at ON notifications (created_at DESC)");

                schemaEnsured = true;
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // =========== NOTIFICATION PREFERENCES ===========

    /**
     * Get all notification preferences for a user.
     * If a preference doesn't exist yet, it defaults to enabled (true).
     */
    public Map<String, Boolean> getPreferences(int userId) {
        // Default all to true
        Map<String, Boolean> prefs = new LinkedHashMap<>();
        prefs.put("memory_uploads", true);
        prefs.put("comments_reactions", true);
        prefs.put("group_announcements", true);
        prefs.put("event_updates", true);
        prefs.put("group_invites", true);
        prefs.put("memory_recaps", true);

        String sql = "SELECT notif_type, enabled FROM notification_preferences WHERE user_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    String type = rs.getString("notif_type");
                    boolean enabled = rs.getBoolean("enabled");
                    if (prefs.containsKey(type)) {
                        prefs.put(type, enabled);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return prefs;
    }

    /**
     * Update a single notification preference (upsert).
     */
    public boolean updatePreference(int userId, String notifType, boolean enabled) {
        String sql = "INSERT INTO notification_preferences (user_id, notif_type, enabled, updated_at) " +
                "VALUES (?, ?, ?, CURRENT_TIMESTAMP) " +
                "ON CONFLICT (user_id, notif_type) DO UPDATE SET enabled = ?, updated_at = CURRENT_TIMESTAMP";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setString(2, notifType);
            stmt.setBoolean(3, enabled);
            stmt.setBoolean(4, enabled);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Check if a specific notification type is enabled for a user.
     */
    public boolean isNotificationEnabled(int userId, String notifType) {
        String sql = "SELECT enabled FROM notification_preferences WHERE user_id = ? AND notif_type = ?";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setString(2, notifType);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getBoolean("enabled");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return true; // default enabled
    }

    // =========== NOTIFICATIONS ===========

    /**
     * Create a notification for a user.
     * Checks preferences first — won't create if user disabled that type.
     */
    public boolean createNotification(int userId, String notifType, String title, String message, String link,
            Integer actorId) {
        // Don't notify yourself
        if (actorId != null && actorId == userId) {
            return false;
        }
        if (!isNotificationEnabled(userId, notifType)) {
            return false; // user opted out
        }
        String sql = "INSERT INTO notifications (user_id, notif_type, title, message, link, actor_id) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setString(2, notifType);
            stmt.setString(3, title);
            stmt.setString(4, message);
            stmt.setString(5, link);
            if (actorId != null) {
                stmt.setInt(6, actorId);
            } else {
                stmt.setNull(6, Types.INTEGER);
            }
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Get user_id from feed_profile_id.
     */
    public int getUserIdFromFeedProfile(int feedProfileId) {
        String sql = "SELECT user_id FROM feed_profiles WHERE feed_profile_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, feedProfileId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next())
                    return rs.getInt("user_id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    /**
     * Get the post owner's user_id from a post_id.
     */
    public int getPostOwnerUserId(int postId) {
        String sql = "SELECT fp.user_id FROM feed_posts p JOIN feed_profiles fp ON p.feed_profile_id = fp.feed_profile_id WHERE p.post_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, postId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next())
                    return rs.getInt("user_id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    /**
     * Get the autograph owner's user_id from an autograph_id.
     */
    public int getAutographOwnerUserId(int autographId) {
        String sql = "SELECT user_id FROM autographs WHERE autograph_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, autographId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next())
                    return rs.getInt("user_id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    /**
     * Get all member user_ids of a collab memory (excluding a specific user).
     */
    public List<Integer> getCollabMemoryMembers(int memoryId, int excludeUserId) {
        List<Integer> members = new ArrayList<>();
        String sql = "SELECT user_id FROM memory_members WHERE memory_id = ? AND user_id != ?";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, memoryId);
            stmt.setInt(2, excludeUserId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    members.add(rs.getInt("user_id"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        // Also add the memory owner
        String ownerSql = "SELECT user_id FROM memories WHERE memory_id = ? AND user_id != ?";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(ownerSql)) {
            stmt.setInt(1, memoryId);
            stmt.setInt(2, excludeUserId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    int ownerId = rs.getInt("user_id");
                    if (!members.contains(ownerId)) {
                        members.add(ownerId);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return members;
    }

    /**
     * Get all notifications for a user (most recent first), with actor info.
     */
    public List<Map<String, Object>> getNotifications(int userId, int limit) {
        List<Map<String, Object>> notifications = new ArrayList<>();
        String sql = "SELECT n.*, " +
                "u.username AS actor_username " +
                "FROM notifications n " +
                "LEFT JOIN users u ON n.actor_id = u.user_id " +
                "WHERE n.user_id = ? " +
                "ORDER BY n.created_at DESC LIMIT ?";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> notif = new HashMap<>();
                    notif.put("notificationId", rs.getInt("notification_id"));
                    notif.put("notifType", rs.getString("notif_type"));
                    notif.put("title", rs.getString("title"));
                    notif.put("message", rs.getString("message"));
                    notif.put("link", rs.getString("link"));
                    notif.put("isRead", rs.getBoolean("is_read"));
                    notif.put("actorId", rs.getObject("actor_id"));
                    notif.put("actorUsername", rs.getString("actor_username"));
                    notif.put("createdAt", rs.getTimestamp("created_at"));
                    notifications.add(notif);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return notifications;
    }

    /**
     * Get count of unread notifications.
     */
    public int getUnreadCount(int userId) {
        String sql = "SELECT COUNT(*) FROM notifications WHERE user_id = ? AND is_read = FALSE";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next())
                    return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Mark a single notification as read.
     */
    public boolean markAsRead(int notificationId, int userId) {
        String sql = "UPDATE notifications SET is_read = TRUE WHERE notification_id = ? AND user_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, notificationId);
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Mark all notifications as read for a user.
     */
    public boolean markAllAsRead(int userId) {
        String sql = "UPDATE notifications SET is_read = TRUE WHERE user_id = ? AND is_read = FALSE";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            return stmt.executeUpdate() >= 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Delete a notification.
     */
    public boolean deleteNotification(int notificationId, int userId) {
        String sql = "DELETE FROM notifications WHERE notification_id = ? AND user_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, notificationId);
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
