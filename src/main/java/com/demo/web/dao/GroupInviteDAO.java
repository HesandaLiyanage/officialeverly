package com.demo.web.dao;

import com.demo.web.model.GroupInvite;
import com.demo.web.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.logging.Logger;

public class GroupInviteDAO {
    private static final Logger logger = Logger.getLogger(GroupInviteDAO.class.getName());

    /**
     * Generate a unique invite token
     */
    public String generateToken() {
        return UUID.randomUUID().toString().replace("-", "").substring(0, 16);
    }

    /**
     * Create a new invite link
     */
    public boolean createInvite(GroupInvite invite) {
        String sql = "INSERT INTO group_invite (group_id, invite_token, created_by, created_at, is_active) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, invite.getGroupId());
            stmt.setString(2, invite.getInviteToken());
            stmt.setInt(3, invite.getCreatedBy());
            stmt.setTimestamp(4, invite.getCreatedAt() != null ? invite.getCreatedAt() : new Timestamp(System.currentTimeMillis()));
            stmt.setBoolean(5, invite.isActive());
            
            int rowsInserted = stmt.executeUpdate();
            if (rowsInserted > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    invite.setInviteId(rs.getInt(1));
                }
                System.out.println("[DEBUG GroupInviteDAO] createInvite: Created invite with token " + invite.getInviteToken());
                return true;
            }
        } catch (SQLException e) {
            System.out.println("[DEBUG GroupInviteDAO] Error creating invite: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Find invite by token
     */
    public GroupInvite findByToken(String token) {
        String sql = "SELECT invite_id, group_id, invite_token, created_by, created_at, is_active FROM group_invite WHERE invite_token = ? AND is_active = TRUE";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, token);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                GroupInvite invite = mapResultSetToInvite(rs);
                System.out.println("[DEBUG GroupInviteDAO] findByToken: Found invite for group " + invite.getGroupId());
                return invite;
            } else {
                System.out.println("[DEBUG GroupInviteDAO] findByToken: No active invite found for token " + token);
            }
        } catch (SQLException e) {
            System.out.println("[DEBUG GroupInviteDAO] Error finding invite by token: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Find all invites for a group (for access revoking feature)
     */
    public List<GroupInvite> findByGroupId(int groupId) {
        String sql = "SELECT invite_id, group_id, invite_token, created_by, created_at, is_active FROM group_invite WHERE group_id = ? ORDER BY created_at DESC";
        List<GroupInvite> invites = new ArrayList<>();
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, groupId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                invites.add(mapResultSetToInvite(rs));
            }
            System.out.println("[DEBUG GroupInviteDAO] findByGroupId: Found " + invites.size() + " invites for group " + groupId);
        } catch (SQLException e) {
            System.out.println("[DEBUG GroupInviteDAO] Error finding invites by group ID: " + e.getMessage());
            e.printStackTrace();
        }
        return invites;
    }

    /**
     * Delete/deactivate an invite link
     */
    public boolean deleteInvite(int inviteId) {
        String sql = "DELETE FROM group_invite WHERE invite_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, inviteId);
            int rowsDeleted = stmt.executeUpdate();
            System.out.println("[DEBUG GroupInviteDAO] deleteInvite: Deleted " + rowsDeleted + " rows for invite " + inviteId);
            return rowsDeleted > 0;
        } catch (SQLException e) {
            System.out.println("[DEBUG GroupInviteDAO] Error deleting invite: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Deactivate an invite instead of deleting
     */
    public boolean deactivateInvite(int inviteId) {
        String sql = "UPDATE group_invite SET is_active = FALSE WHERE invite_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, inviteId);
            int rowsUpdated = stmt.executeUpdate();
            System.out.println("[DEBUG GroupInviteDAO] deactivateInvite: Deactivated invite " + inviteId);
            return rowsUpdated > 0;
        } catch (SQLException e) {
            System.out.println("[DEBUG GroupInviteDAO] Error deactivating invite: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    private GroupInvite mapResultSetToInvite(ResultSet rs) throws SQLException {
        GroupInvite invite = new GroupInvite();
        invite.setInviteId(rs.getInt("invite_id"));
        invite.setGroupId(rs.getInt("group_id"));
        invite.setInviteToken(rs.getString("invite_token"));
        invite.setCreatedBy(rs.getInt("created_by"));
        invite.setCreatedAt(rs.getTimestamp("created_at"));
        invite.setActive(rs.getBoolean("is_active"));
        return invite;
    }
}
