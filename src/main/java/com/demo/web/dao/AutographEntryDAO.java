package com.demo.web.dao;

import com.demo.web.model.AutographEntry;
import com.demo.web.util.DatabaseUtil;

import java.security.SecureRandom;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AutographEntryDAO {

    // Constants for secure token generation (for entry links)
    private static final String ALPHANUMERIC = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    private static final SecureRandom SECURE_RANDOM = new SecureRandom();
    private static final int ENTRY_TOKEN_LENGTH = 15;

    /**
     * Generates a secure 15-character alphanumeric token for entry links
     */
    private String generateSecureToken() {
        StringBuilder token = new StringBuilder(ENTRY_TOKEN_LENGTH);
        for (int i = 0; i < ENTRY_TOKEN_LENGTH; i++) {
            token.append(ALPHANUMERIC.charAt(SECURE_RANDOM.nextInt(ALPHANUMERIC.length())));
        }
        return token.toString();
    }

    /**
     * Checks if an entry link token already exists
     */
    private boolean isTokenExists(Connection conn, String token) throws SQLException {
        String sql = "SELECT COUNT(*) FROM autograph_entry WHERE link = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, token);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    /**
     * Create a new autograph entry
     */
    public boolean createEntry(AutographEntry entry) throws SQLException {
        String sql = "INSERT INTO autograph_entry (link, content, autograph_id, user_id) VALUES (?, ?, ?, ?)";

        try (Connection conn = DatabaseUtil.getConnection()) {
            // Generate unique token for this entry
            String newToken;
            int attempts = 0;
            do {
                newToken = generateSecureToken();
                attempts++;
                if (attempts > 100) {
                    throw new SQLException("Failed to generate unique entry token after 100 attempts");
                }
            } while (isTokenExists(conn, newToken));

            entry.setLink(newToken);

            try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                stmt.setString(1, newToken);
                stmt.setString(2, entry.getContent());
                stmt.setInt(3, entry.getAutographId());
                stmt.setInt(4, entry.getUserId());

                int rowsInserted = stmt.executeUpdate();

                if (rowsInserted > 0) {
                    ResultSet generatedKeys = stmt.getGeneratedKeys();
                    if (generatedKeys.next()) {
                        entry.setEntryId(generatedKeys.getInt(1));
                    }
                    System.out.println("[DEBUG AutographEntryDAO] Created entry with ID: " + entry.getEntryId()
                            + ", link: " + newToken);
                    return true;
                }
                return false;
            }
        }
    }

    /**
     * Find all entries for a specific autograph book
     */
    public List<AutographEntry> findByAutographId(int autographId) throws SQLException {
        String sql = "SELECT entry_id, link, content, submitted_at, autograph_id, user_id " +
                "FROM autograph_entry WHERE autograph_id = ? ORDER BY submitted_at DESC";
        List<AutographEntry> entries = new ArrayList<>();

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, autographId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                entries.add(mapResultSetToEntry(rs));
            }

            System.out.println("[DEBUG AutographEntryDAO] findByAutographId(" + autographId + ") returned "
                    + entries.size() + " entries");
        }

        return entries;
    }

    /**
     * Find entry by its unique link token
     */
    public AutographEntry findByLink(String link) throws SQLException {
        String sql = "SELECT entry_id, link, content, submitted_at, autograph_id, user_id " +
                "FROM autograph_entry WHERE link = ?";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, link);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToEntry(rs);
            }
        }

        return null;
    }

    /**
     * Count entries for a specific autograph book
     */
    public int countByAutographId(int autographId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM autograph_entry WHERE autograph_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, autographId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }
        }

        return 0;
    }

    /**
     * Delete an entry by ID
     */
    public boolean deleteEntry(int entryId) throws SQLException {
        String sql = "DELETE FROM autograph_entry WHERE entry_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, entryId);
            int rowsDeleted = stmt.executeUpdate();

            System.out.println(
                    "[DEBUG AutographEntryDAO] deleteEntry affected " + rowsDeleted + " rows for ID: " + entryId);
            return rowsDeleted > 0;
        }
    }

    /**
     * Map ResultSet to AutographEntry object
     */
    private AutographEntry mapResultSetToEntry(ResultSet rs) throws SQLException {
        AutographEntry entry = new AutographEntry();
        entry.setEntryId(rs.getInt("entry_id"));
        entry.setLink(rs.getString("link"));
        entry.setContent(rs.getString("content"));
        entry.setSubmittedAt(rs.getDate("submitted_at"));
        entry.setAutographId(rs.getInt("autograph_id"));
        entry.setUserId(rs.getInt("user_id"));
        return entry;
    }
}
