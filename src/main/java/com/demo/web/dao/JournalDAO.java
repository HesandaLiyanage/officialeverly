// File: com/demo/web/dao/JournalDAO.java
package com.demo.web.dao;

import com.demo.web.model.Journal;
import com.demo.web.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class JournalDAO {

    /**
     * Find all journals for a specific user
     */
    public List<Journal> findByUserId(int userId) {
        String sql = "SELECT * FROM journal WHERE user_id = ? ORDER BY journal_id DESC"; // Changed to order by id since no created_at
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

            System.out.println("[DEBUG JournalDAO] findByUserId(" + userId + ") returned " + journals.size() + " records.");

        } catch (SQLException e) {
            System.out.println("[ERROR JournalDAO] Error finding journals by user ID: " + e.getMessage());
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
     * Delete a journal entry
     */
    public boolean deleteJournal(int journalId) {
        String sql = "DELETE FROM journal WHERE journal_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, journalId);

            int rowsAffected = pstmt.executeUpdate();
            System.out.println("[DEBUG JournalDAO] deleteJournal - Rows affected: " + rowsAffected);

            return rowsAffected > 0;

        } catch (SQLException e) {
            System.out.println("[ERROR JournalDAO] Error deleting journal: " + e.getMessage());
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
     * Helper method to map ResultSet to Journal object
     */
    private Journal mapResultSetToJournal(ResultSet rs) throws SQLException {
        Journal journal = new Journal();
        journal.setJournalId(rs.getInt("journal_id"));
        journal.setTitle(rs.getString("j_title"));
        journal.setContent(rs.getString("j_content"));
        journal.setUserId(rs.getInt("user_id"));
        journal.setJournalPic(rs.getString("journal_pic"));

        // No timestamps in model anymore
        return journal;
    }
}