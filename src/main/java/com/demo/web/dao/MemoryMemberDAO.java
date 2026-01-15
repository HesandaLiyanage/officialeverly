package com.demo.web.dao;

import com.demo.web.model.MemoryMember;
import com.demo.web.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO for managing memory membership (collaborators)
 */
public class MemoryMemberDAO {

    /**
     * Add a member to a collaborative memory
     */
    public boolean addMember(int memoryId, int userId, String role,
            byte[] encryptedGroupKey, byte[] groupKeyIv) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "INSERT INTO memory_member (memory_id, user_id, role, encrypted_group_key, group_key_iv) " +
                    "VALUES (?, ?, ?, ?, ?) " +
                    "ON CONFLICT (memory_id, user_id) DO NOTHING";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, memoryId);
            stmt.setInt(2, userId);
            stmt.setString(3, role);
            stmt.setBytes(4, encryptedGroupKey);
            stmt.setBytes(5, groupKeyIv);

            int rowsInserted = stmt.executeUpdate();
            return rowsInserted > 0;

        } finally {
            closeResources(null, stmt, conn);
        }
    }

    /**
     * Check if a user is a member of a memory
     */
    public boolean isUserMemberOf(int memoryId, int userId) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT 1 FROM memory_member WHERE memory_id = ? AND user_id = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, memoryId);
            stmt.setInt(2, userId);

            rs = stmt.executeQuery();
            return rs.next();

        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    /**
     * Get a specific member of a memory
     */
    public MemoryMember getMember(int memoryId, int userId) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT mm.member_id, mm.memory_id, mm.user_id, mm.role, mm.joined_at, " +
                    "mm.encrypted_group_key, mm.group_key_iv, u.username " +
                    "FROM memory_member mm " +
                    "JOIN users u ON mm.user_id = u.user_id " +
                    "WHERE mm.memory_id = ? AND mm.user_id = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, memoryId);
            stmt.setInt(2, userId);

            rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToMember(rs);
            }
            return null;

        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    /**
     * Get all members of a memory
     */
    public List<MemoryMember> getMembersOfMemory(int memoryId) throws SQLException {
        List<MemoryMember> members = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT mm.member_id, mm.memory_id, mm.user_id, mm.role, mm.joined_at, " +
                    "mm.encrypted_group_key, mm.group_key_iv, u.username " +
                    "FROM memory_member mm " +
                    "JOIN users u ON mm.user_id = u.user_id " +
                    "WHERE mm.memory_id = ? " +
                    "ORDER BY mm.role DESC, mm.joined_at ASC";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, memoryId);

            rs = stmt.executeQuery();

            while (rs.next()) {
                members.add(mapResultSetToMember(rs));
            }
            return members;

        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    /**
     * Get all collaborative memories for a user (memories they've joined)
     */
    public List<MemoryMember> getCollaborativeMemoriesForUser(int userId) throws SQLException {
        List<MemoryMember> memberships = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT mm.member_id, mm.memory_id, mm.user_id, mm.role, mm.joined_at, " +
                    "mm.encrypted_group_key, mm.group_key_iv " +
                    "FROM memory_member mm " +
                    "WHERE mm.user_id = ? " +
                    "ORDER BY mm.joined_at DESC";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);

            rs = stmt.executeQuery();

            while (rs.next()) {
                memberships.add(mapResultSetToMemberWithoutUsername(rs));
            }
            return memberships;

        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    /**
     * Remove a member from a memory
     */
    public boolean removeMember(int memoryId, int userId) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "DELETE FROM memory_member WHERE memory_id = ? AND user_id = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, memoryId);
            stmt.setInt(2, userId);

            int rowsDeleted = stmt.executeUpdate();
            return rowsDeleted > 0;

        } finally {
            closeResources(null, stmt, conn);
        }
    }

    /**
     * Get member count for a memory
     */
    public int getMemberCount(int memoryId) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT COUNT(*) as count FROM memory_member WHERE memory_id = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, memoryId);

            rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt("count");
            }
            return 0;

        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    /**
     * Map ResultSet to MemoryMember object (with username)
     */
    private MemoryMember mapResultSetToMember(ResultSet rs) throws SQLException {
        MemoryMember member = new MemoryMember();
        member.setMemberId(rs.getInt("member_id"));
        member.setMemoryId(rs.getInt("memory_id"));
        member.setUserId(rs.getInt("user_id"));
        member.setRole(rs.getString("role"));
        member.setJoinedAt(rs.getTimestamp("joined_at"));
        member.setEncryptedGroupKey(rs.getBytes("encrypted_group_key"));
        member.setGroupKeyIv(rs.getBytes("group_key_iv"));
        member.setUsername(rs.getString("username"));
        return member;
    }

    /**
     * Map ResultSet to MemoryMember object (without username)
     */
    private MemoryMember mapResultSetToMemberWithoutUsername(ResultSet rs) throws SQLException {
        MemoryMember member = new MemoryMember();
        member.setMemberId(rs.getInt("member_id"));
        member.setMemoryId(rs.getInt("memory_id"));
        member.setUserId(rs.getInt("user_id"));
        member.setRole(rs.getString("role"));
        member.setJoinedAt(rs.getTimestamp("joined_at"));
        member.setEncryptedGroupKey(rs.getBytes("encrypted_group_key"));
        member.setGroupKeyIv(rs.getBytes("group_key_iv"));
        return member;
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
