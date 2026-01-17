package com.demo.web.dao;

import com.demo.web.model.AutographEntry;
import com.demo.web.util.DatabaseUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AutographEntryDAO {

    public boolean createEntry(AutographEntry entry) throws SQLException {
        String sql = "INSERT INTO autograph_entry (autograph_id, user_id, content, decorations, submitted_at) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, entry.getAutographId());
            if (entry.getUserId() == 0) {
                stmt.setNull(2, java.sql.Types.INTEGER);
            } else {
                stmt.setInt(2, entry.getUserId());
            }
            stmt.setString(3, entry.getContent());
            stmt.setString(4, entry.getDecorations());
            stmt.setTimestamp(5, new Timestamp(System.currentTimeMillis()));

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
        String sql = "SELECT * FROM autograph_entry WHERE autograph_id = ? ORDER BY submitted_at DESC";
        List<AutographEntry> entries = new ArrayList<>();
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, autographId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                AutographEntry entry = new AutographEntry();
                entry.setEntryId(rs.getInt("entry_id"));
                entry.setAutographId(rs.getInt("autograph_id"));
                entry.setUserId(rs.getInt("user_id"));
                entry.setContent(rs.getString("content"));
                entry.setDecorations(rs.getString("decorations"));
                entry.setSubmittedAt(rs.getTimestamp("submitted_at"));
                entries.add(entry);
            }
        }
        return entries;
    }
}
