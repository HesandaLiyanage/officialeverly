package com.demo.web.dao;

import com.demo.web.model.MemoryMember;
import com.demo.web.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO for memory collaboration membership operations
 */
public class MemoryMemberDAO {

    /**
     * Add a member to a collaborative memory
     */
    public boolean addMember(int memoryId, int userId, String role) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "INSERT INTO memory_members (memory_id, user_id, role) VALUES (?, ?, ?) " +
                    "ON CONFLICT (memory_id, user_id) DO NOTHING";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, memoryId);
            stmt.setInt(2, userId);
            stmt.setString(3, role);

            int rowsInserted = stmt.executeUpdate();
            return rowsInserted > 0;

        } finally {
            closeResources(null, stmt, conn);
        }
    }

    /**
     * Remove a member from a collaborative memory
     */
    public boolean removeMember(int memoryId, int userId) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "DELETE FROM memory_members WHERE memory_id = ? AND user_id = ? AND role != 'owner'";

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
     * Member leaves a collaborative memory (cannot be owner)
     */
    public boolean leaveMembership(int memoryId, int userId) throws SQLException {
        return removeMember(memoryId, userId);
    }

    /**
     * Get all members of a collaborative memory with user details
     */
    public List<MemoryMember> getMembers(int memoryId) throws SQLException {
        List<MemoryMember> members = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT mm.id, mm.memory_id, mm.user_id, mm.role, mm.joined_at, " +
                    "u.username, u.email " +
                    "FROM memory_members mm " +
                    "JOIN users u ON mm.user_id = u.user_id " +
                    "WHERE mm.memory_id = ? " +
                    "ORDER BY mm.role DESC, mm.joined_at ASC"; // owner first

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, memoryId);

            rs = stmt.executeQuery();

            while (rs.next()) {
                MemoryMember member = new MemoryMember();
                member.setId(rs.getInt("id"));
                member.setMemoryId(rs.getInt("memory_id"));
                member.setUserId(rs.getInt("user_id"));
                member.setRole(rs.getString("role"));
                member.setJoinedAt(rs.getTimestamp("joined_at"));
                member.setUsername(rs.getString("username"));
                member.setEmail(rs.getString("email"));
                members.add(member);
            }

            return members;

        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    /**
     * Get member role for a user in a memory
     * Returns null if user is not a member
     */
    public String getMemberRole(int memoryId, int userId) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT role FROM memory_members WHERE memory_id = ? AND user_id = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, memoryId);
            stmt.setInt(2, userId);

            rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getString("role");
            }

            return null;

        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    /**
     * Check if user is a member (or owner) of a memory
     */
    public boolean isMember(int memoryId, int userId) throws SQLException {
        return getMemberRole(memoryId, userId) != null;
    }

    /**
     * Check if user is the owner of a memory
     */
    public boolean isOwner(int memoryId, int userId) throws SQLException {
        String role = getMemberRole(memoryId, userId);
        return "owner".equalsIgnoreCase(role);
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
            String sql = "SELECT COUNT(*) as count FROM memory_members WHERE memory_id = ?";

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
