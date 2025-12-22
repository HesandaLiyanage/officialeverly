// File: com/demo/web/dao/JournalDAO.java
package com.demo.web.dao;

import com.demo.web.model.Journal;
import com.demo.web.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class JournalDAO {

    /**
     * Find all ACTIVE (non-deleted) journals for a specific user
     */
    public List<Journal> findByUserId(int userId) {
        String sql = "SELECT * FROM journal WHERE user_id = ? AND is_deleted = false ORDER BY journal_id DESC";
        List<Journal> journals = new ArrayList<>();

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Journal journal = mapResultSetToJournal(rs);
                    journals.add(journal);
                }
            }

            System.out.println("[DEBUG JournalDAO] findByUserId(" + userId + ") returned " + journals.size() + " ACTIVE records.");

        } catch (SQLException e) {
            System.out.println("[ERROR JournalDAO] Error finding active journals by user ID: " + e.getMessage());
            e.printStackTrace();
        }

        return journals;
    }

    /**
     * Find a journal by ID
     */
    public Journal findById(int journalId) {
        String sql = "SELECT * FROM journal WHERE journal_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, journalId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToJournal(rs);
                }
            }

        } catch (SQLException e) {
            System.out.println("[ERROR JournalDAO] Error finding journal by ID: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Create a new journal entry
     */
    public boolean createJournal(Journal journal) {
        // ⚠️ IMPORTANT: Removed created_at and updated_at columns since they don't exist in DB
        String sql = "INSERT INTO journal (j_title, j_content, user_id, journal_pic) " +
                "VALUES (?, ?, ?, ?)";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setString(1, journal.getTitle());
            pstmt.setString(2, journal.getContent());
            pstmt.setInt(3, journal.getUserId());
            pstmt.setString(4, journal.getJournalPic());

            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        journal.setJournalId(generatedKeys.getInt(1));
                    }
                }
                System.out.println("[DEBUG JournalDAO] Journal created successfully with ID: " + journal.getJournalId());
                return true;
            }

        } catch (SQLException e) {
            System.out.println("[ERROR JournalDAO] Error creating journal: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Update an existing journal entry
     */
    public boolean updateJournal(Journal journal) {
        // ⚠️ IMPORTANT: Removed updated_at column since it doesn't exist in DB
        String sql = "UPDATE journal SET j_title = ?, j_content = ?, journal_pic = ? " +
                "WHERE journal_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, journal.getTitle());
            pstmt.setString(2, journal.getContent());
            pstmt.setString(3, journal.getJournalPic());
            pstmt.setInt(4, journal.getJournalId());

            int rowsAffected = pstmt.executeUpdate();
            System.out.println("[DEBUG JournalDAO] updateJournal - Rows affected: " + rowsAffected);

            return rowsAffected > 0;

        } catch (SQLException e) {
            System.out.println("[ERROR JournalDAO] Error updating journal: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Soft-delete a journal (move to Recycle Bin)
     */
    public boolean softDeleteJournal(int journalId) {
        String sql = "UPDATE journal SET is_deleted = true, deleted_at = NOW() WHERE journal_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, journalId);
            int rowsAffected = pstmt.executeUpdate();
            System.out.println("[DEBUG JournalDAO] softDeleteJournal - Rows affected: " + rowsAffected);
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.out.println("[ERROR JournalDAO] Error soft-deleting journal: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Get total count of journals for a user
     */
    public int getJournalCount(int userId) {
        String sql = "SELECT COUNT(*) as count FROM journal WHERE user_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("count");
                }
            }

        } catch (SQLException e) {
            System.out.println("[ERROR JournalDAO] Error getting journal count: " + e.getMessage());
            e.printStackTrace();
        }

        return 0;
    }

    /**
     * Restore a journal from Recycle Bin
     */
    public boolean restoreJournal(int journalId) {
        String sql = "UPDATE journal SET is_deleted = false, restored_at = NOW(), deleted_at = NULL WHERE journal_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, journalId);
            int rowsAffected = pstmt.executeUpdate();
            System.out.println("[DEBUG JournalDAO] restoreJournal - Rows affected: " + rowsAffected);
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.out.println("[ERROR JournalDAO] Error restoring journal: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Find all DELETED journals for a specific user (for Recycle Bin)
     */
    public List<Journal> findDeletedByUserId(int userId) {
        String sql = "SELECT * FROM journal WHERE user_id = ? AND is_deleted = true ORDER BY deleted_at DESC NULLS LAST";
        List<Journal> journals = new ArrayList<>();

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Journal journal = mapResultSetToJournal(rs);
                    journals.add(journal);
                }
            }

            System.out.println("[DEBUG JournalDAO] findDeletedByUserId(" + userId + ") returned " + journals.size() + " DELETED records.");

        } catch (SQLException e) {
            System.out.println("[ERROR JournalDAO] Error finding deleted journals: " + e.getMessage());
            e.printStackTrace();
        }

        return journals;
    }

    /**
     * Permanently delete a journal (used only for "Delete Forever" in Trash)
     */
    public boolean deleteJournal(int journalId) {
        String sql = "DELETE FROM journal WHERE journal_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, journalId);
            int rowsAffected = pstmt.executeUpdate();
            System.out.println("[DEBUG JournalDAO] Permanent delete - Rows affected: " + rowsAffected);
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.out.println("[ERROR JournalDAO] Error permanently deleting journal: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }


    /**
     * Helper method to map ResultSet to Journal object
     */
    private Journal mapResultSetToJournal(ResultSet rs) throws SQLException {
        Journal journal = new Journal();
        journal.setJournalId(rs.getInt("journal_id"));
        journal.setTitle(rs.getString("j_title"));
        journal.setContent(rs.getString("j_content"));
        journal.setUserId(rs.getInt("user_id"));
        journal.setJournalPic(rs.getString("journal_pic"));

        journal.setDeleted(rs.getBoolean("is_deleted"));
        journal.setDeletedAt(rs.getTimestamp("deleted_at"));
        journal.setRestoredAt(rs.getTimestamp("restored_at"));

        // No timestamps in model anymore
        return journal;
    }
}