package com.demo.web.dao;

import com.demo.web.model.InviteLink;
import com.demo.web.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * DAO for managing memory invite links
 */
public class InviteLinkDAO {

    /**
     * Create a new invite link for a memory
     * Returns the generated invite token
     */
    public String createInviteLink(int memoryId, int createdBy, Timestamp expiresAt, Integer maxUses)
            throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;

        String token = UUID.randomUUID().toString().replace("-", "");

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "INSERT INTO memory_invite_link (memory_id, invite_token, created_by, expires_at, max_uses) " +
                    "VALUES (?, ?, ?, ?, ?)";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, memoryId);
            stmt.setString(2, token);
            stmt.setInt(3, createdBy);

            if (expiresAt != null) {
                stmt.setTimestamp(4, expiresAt);
            } else {
                stmt.setNull(4, Types.TIMESTAMP);
            }

            if (maxUses != null) {
                stmt.setInt(5, maxUses);
            } else {
                stmt.setNull(5, Types.INTEGER);
            }

            int rowsInserted = stmt.executeUpdate();
            if (rowsInserted > 0) {
                return token;
            }
            throw new SQLException("Failed to create invite link");

        } finally {
            closeResources(null, stmt, conn);
        }
    }

    /**
     * Create an invite link with a pre-generated token (for Option C)
     * The token is generated externally by EncryptionService.generateInviteToken()
     */
    public void createInviteLinkWithToken(int memoryId, int createdBy, String token,
            Timestamp expiresAt, Integer maxUses) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "INSERT INTO memory_invite_link (memory_id, invite_token, created_by, expires_at, max_uses) " +
                    "VALUES (?, ?, ?, ?, ?)";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, memoryId);
            stmt.setString(2, token);
            stmt.setInt(3, createdBy);

            if (expiresAt != null) {
                stmt.setTimestamp(4, expiresAt);
            } else {
                stmt.setNull(4, Types.TIMESTAMP);
            }

            if (maxUses != null) {
                stmt.setInt(5, maxUses);
            } else {
                stmt.setNull(5, Types.INTEGER);
            }

            stmt.executeUpdate();

        } finally {
            closeResources(null, stmt, conn);
        }
    }

    /**
     * Get invite link by token
     */
    public InviteLink getInviteLinkByToken(String token) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT invite_id, memory_id, invite_token, created_by, created_at, " +
                    "expires_at, max_uses, use_count, is_active " +
                    "FROM memory_invite_link WHERE invite_token = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, token);

            rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToInviteLink(rs);
            }
            return null;

        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    /**
     * Get all active invite links for a memory
     */
    public List<InviteLink> getActiveLinksForMemory(int memoryId) throws SQLException {
        List<InviteLink> links = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT invite_id, memory_id, invite_token, created_by, created_at, " +
                    "expires_at, max_uses, use_count, is_active " +
                    "FROM memory_invite_link WHERE memory_id = ? AND is_active = TRUE " +
                    "ORDER BY created_at DESC";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, memoryId);

            rs = stmt.executeQuery();

            while (rs.next()) {
                links.add(mapResultSetToInviteLink(rs));
            }
            return links;

        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    /**
     * Increment use count when someone joins via this link
     */
    public boolean incrementUseCount(String token) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "UPDATE memory_invite_link SET use_count = use_count + 1 WHERE invite_token = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, token);

            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0;

        } finally {
            closeResources(null, stmt, conn);
        }
    }

    /**
     * Revoke an invite link (deactivate it)
     */
    public boolean revokeInviteLink(String token) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "UPDATE memory_invite_link SET is_active = FALSE WHERE invite_token = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, token);

            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0;

        } finally {
            closeResources(null, stmt, conn);
        }
    }

    /**
     * Delete an invite link permanently
     */
    public boolean deleteInviteLink(String token) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "DELETE FROM memory_invite_link WHERE invite_token = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, token);

            int rowsDeleted = stmt.executeUpdate();
            return rowsDeleted > 0;

        } finally {
            closeResources(null, stmt, conn);
        }
    }

    /**
     * Map ResultSet to InviteLink object
     */
    private InviteLink mapResultSetToInviteLink(ResultSet rs) throws SQLException {
        InviteLink link = new InviteLink();
        link.setInviteId(rs.getInt("invite_id"));
        link.setMemoryId(rs.getInt("memory_id"));
        link.setInviteToken(rs.getString("invite_token"));
        link.setCreatedBy(rs.getInt("created_by"));
        link.setCreatedAt(rs.getTimestamp("created_at"));
        link.setExpiresAt(rs.getTimestamp("expires_at"));

        int maxUses = rs.getInt("max_uses");
        if (!rs.wasNull()) {
            link.setMaxUses(maxUses);
        }

        link.setUseCount(rs.getInt("use_count"));
        link.setActive(rs.getBoolean("is_active"));

        return link;
    }

    /**
     * Close database resources
     */
    private void closeResources(ResultSet rs, PreparedStatement stmt, Connection conn) {
        try {
            if (rs != null)
                rs.close();
            if (stmt != null)
                stmt.close();
            if (conn != null)
                conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
