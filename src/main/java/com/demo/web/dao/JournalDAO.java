// File: src/main/java/com/demo/web/dao/JournalDAO.java
package com.demo.web.dao;

import com.demo.web.model.Journal;
import com.demo.web.model.RecycleBinItem;
import com.demo.web.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class JournalDAO {

    public List<Journal> findByUserId(int userId) {
        String sql = "SELECT * FROM journal WHERE user_id = ? ORDER BY journal_id DESC";
        List<Journal> journals = new ArrayList<>();
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    journals.add(mapResultSetToJournal(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return journals;
    }

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
            e.printStackTrace();
        }
        return null;
    }

    public boolean createJournal(Journal journal) {
        String sql = "INSERT INTO journal (j_title, j_content, user_id, journal_pic) VALUES (?, ?, ?, ?)";
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
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // File: src/main/java/com/demo/web/dao/JournalDAO.java


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
            e.printStackTrace();
        }
        return 0;
    }

    // File: src/main/java/com/demo/web/dao/JournalDAO.java

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

    public boolean deleteJournalToRecycleBin(int journalId, int userId) {
        Journal journal = findById(journalId);
        if (journal == null || journal.getUserId() != userId) {
            return false;
        }

        RecycleBinItem item = new RecycleBinItem();
        item.setOriginalId(journal.getJournalId());
        item.setUserId(userId);
        item.setTitle(journal.getTitle());
        item.setContent(journal.getContent());
        String metadata = "{\"journalPic\": \"" +
                (journal.getJournalPic() != null ? journal.getJournalPic() : "") +
                "\"}";
        item.setMetadata(metadata);

        RecycleBinDAO rbDao = new RecycleBinDAO();
        int recycleId = rbDao.saveJournalToRecycleBin(item);
        if (recycleId <= 0) return false;

        String deleteSql = "DELETE FROM journal WHERE journal_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(deleteSql)) {
            stmt.setInt(1, journalId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean restoreJournalFromRecycleBin(int recycleBinId, int userId) {
        RecycleBinDAO rbDao = new RecycleBinDAO();
        RecycleBinItem item = rbDao.findById(recycleBinId);
        if (item == null || !"journal".equals(item.getItemType()) || item.getUserId() != userId) {
            return false;
        }

        Journal journal = new Journal();
        journal.setTitle(item.getTitle());
        journal.setContent(item.getContent());
        journal.setUserId(userId);

        String journalPic = "";
        if (item.getMetadata() != null) {
            String meta = item.getMetadata();
            int start = meta.indexOf("\"journalPic\": \"");
            if (start != -1) {
                start += 15;
                int end = meta.indexOf("\"", start);
                if (end != -1) {
                    journalPic = meta.substring(start, end);
                }
            }
        }
        journal.setJournalPic(journalPic);

        boolean restored = createJournal(journal);
        if (restored) {
            rbDao.deleteFromRecycleBin(recycleBinId);
            return true;
        }
        return false;
    }

    private Journal mapResultSetToJournal(ResultSet rs) throws SQLException {
        Journal journal = new Journal();
        journal.setJournalId(rs.getInt("journal_id"));
        journal.setTitle(rs.getString("j_title"));
        journal.setContent(rs.getString("j_content"));
        journal.setUserId(rs.getInt("user_id"));
        journal.setJournalPic(rs.getString("journal_pic"));
        return journal;
    }
}