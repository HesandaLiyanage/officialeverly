package com.demo.web.dao;

import com.demo.web.model.AutographEntry;
import com.demo.web.util.DatabaseUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AutographEntryDAO {

    public boolean createEntry(AutographEntry entry) throws SQLException {
        String sql = "INSERT INTO autograph_entry (link, content, submitted_at, autograph_id, user_id, content_plain) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, entry.getLink());
            stmt.setString(2, entry.getContent());
            stmt.setDate(3, new java.sql.Date(System.currentTimeMillis())); // Schema uses DATE
            stmt.setInt(4, entry.getAutographId());
            stmt.setInt(5, entry.getUserId()); // user_id is NOT NULL
            stmt.setString(6, entry.getContentPlain());

            int rows = stmt.executeUpdate();
            if (rows > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    entry.setEntryId(rs.getInt(1));
                }
                return true;
            }
        }
        return false;
    }

    public List<AutographEntry> findByAutographId(int autographId) throws SQLException {
        String sql = "SELECT * FROM autograph_entry WHERE autograph_id = ? ORDER BY submitted_at DESC, entry_id DESC";
        List<AutographEntry> entries = new ArrayList<>();
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, autographId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                AutographEntry entry = new AutographEntry();
                entry.setEntryId(rs.getInt("entry_id"));
                entry.setLink(rs.getString("link"));
                entry.setContent(rs.getString("content"));
                entry.setSubmittedAt(rs.getDate("submitted_at"));
                entry.setAutographId(rs.getInt("autograph_id"));
                entry.setUserId(rs.getInt("user_id"));
                entry.setContentPlain(rs.getString("content_plain"));
                entries.add(entry);
            }
        }
        return entries;
    }
}
