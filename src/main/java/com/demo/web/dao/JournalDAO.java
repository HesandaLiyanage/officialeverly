// File: com/demo/web/dao/JournalDAO.java
package com.demo.web.dao;

import com.demo.web.model.Journal;
import com.demo.web.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class JournalDAO {

    /**
     * Find all journals for a specific user (no soft-delete needed)
     */
    public List<Journal> findByUserId(int userId) {
        String sql = "SELECT * FROM journal WHERE user_id = ? ORDER BY journal_id DESC";
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
     * Delete a journal: move to recycle_bin, then delete from journal table
     */
    public boolean deleteJournalToRecycleBin(int journalId, int userId) {
        // 1. Fetch the journal to verify ownership
        Journal journal = findById(journalId);
        if (journal == null || journal.getUserId() != userId) {
            return false;
        }

        // 2. Insert into recycle_bin
        String insertSql = """
            INSERT INTO recycle_bin (original_id, item_type, user_id, title, content, metadata)
            VALUES (?, 'journal', ?, ?, ?, ?::JSONB)
            """;

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {

            insertStmt.setInt(1, journal.getJournalId());
            insertStmt.setInt(2, userId);
            insertStmt.setString(3, journal.getTitle());
            insertStmt.setString(4, journal.getContent());

            // Store journalPic in metadata as JSON
            String metadata = "{\"journalPic\": \"" +
                    (journal.getJournalPic() != null ? journal.getJournalPic() : "") +
                    "\"}";
            insertStmt.setString(5, metadata);

            int inserted = insertStmt.executeUpdate();
            if (inserted <= 0) {
                return false;
            }

            // 3. Delete from journal table
            String deleteSql = "DELETE FROM journal WHERE journal_id = ?";
            try (PreparedStatement deleteStmt = conn.prepareStatement(deleteSql)) {
                deleteStmt.setInt(1, journalId);
                int deleted = deleteStmt.executeUpdate();
                System.out.println("[DEBUG JournalDAO] Journal moved to recycle_bin and deleted. ID: " + journalId);
                return deleted > 0;
            }

        } catch (SQLException e) {
            System.out.println("[ERROR JournalDAO] Error moving journal to recycle_bin: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Restore a journal from recycle_bin
     */
    public boolean restoreJournalFromRecycleBin(int recycleBinId, int userId) {
        // 1. Fetch from recycle_bin
        RecycleBinItem item = getRecycleBinItemById(recycleBinId);
        if (item == null || !item.getItemType().equals("journal") || item.getUserId() != userId) {
            return false;
        }

        // 2. Rebuild journal
        Journal journal = new Journal();
        journal.setTitle(item.getTitle());
        journal.setContent(item.getContent());
        journal.setUserId(userId);

        // Extract journalPic from metadata
        String journalPic = "";
        if (item.getMetadata() != null) {
            // Simple JSON parsing (improve with Gson if needed)
            String meta = item.getMetadata();
            int start = meta.indexOf("\"journalPic\": \"");
            if (start != -1) {
                start += 15; // length of "\"journalPic\": \""
                int end = meta.indexOf("\"", start);
                if (end != -1) {
                    journalPic = meta.substring(start, end);
                }
            }
        }
        journal.setJournalPic(journalPic);

        // 3. Insert back into journal table
        boolean restored = createJournal(journal);
        if (restored) {
            // 4. Remove from recycle_bin
            deleteFromRecycleBin(recycleBinId);
            return true;
        }
        return false;
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
     * Helper: Get item from recycle_bin by ID
     */
    private RecycleBinItem getRecycleBinItemById(int id) {
        String sql = "SELECT * FROM recycle_bin WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                RecycleBinItem item = new RecycleBinItem();
                item.setId(rs.getInt("id"));
                item.setOriginalId(rs.getInt("original_id"));
                item.setItemType(rs.getString("item_type"));
                item.setUserId(rs.getInt("user_id"));
                item.setTitle(rs.getString("title"));
                item.setContent(rs.getString("content"));
                item.setMetadata(rs.getString("metadata"));
                item.setDeletedAt(rs.getTimestamp("deleted_at"));
                return item;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Helper: Delete from recycle_bin
     */
    private boolean deleteFromRecycleBin(int id) {
        String sql = "DELETE FROM recycle_bin WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
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
        return journal;
    }

    // --- Embedded RecycleBinItem class (for internal use) ---
    private static class RecycleBinItem {
        private int id;
        private int originalId;
        private String itemType;
        private int userId;
        private String title;
        private String content;
        private String metadata;
        private Timestamp deletedAt;

        // Getters & Setters
        public int getId() { return id; }
        public void setId(int id) { this.id = id; }

        public int getOriginalId() { return originalId; }
        public void setOriginalId(int originalId) { this.originalId = originalId; }

        public String getItemType() { return itemType; }
        public void setItemType(String itemType) { this.itemType = itemType; }

        public int getUserId() { return userId; }
        public void setUserId(int userId) { this.userId = userId; }

        public String getTitle() { return title; }
        public void setTitle(String title) { this.title = title; }

        public String getContent() { return content; }
        public void setContent(String content) { this.content = content; }

        public String getMetadata() { return metadata; }
        public void setMetadata(String metadata) { this.metadata = metadata; }

        public Timestamp getDeletedAt() { return deletedAt; }
        public void setDeletedAt(Timestamp deletedAt) { this.deletedAt = deletedAt; }
    }
}