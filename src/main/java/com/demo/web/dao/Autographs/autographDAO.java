package com.demo.web.dao.Autographs;

import com.demo.web.model.Autographs.autograph;
import com.demo.web.model.Autographs.AutographEntry;
import com.demo.web.model.Journals.RecycleBinItem;
import com.demo.web.dao.Journals.RecycleBinDAO;
import com.demo.web.util.DatabaseUtil;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
import java.util.logging.Level;

public class autographDAO {

    private static final Logger logger = Logger.getLogger(autographDAO.class.getName());

    public boolean createAutograph(autograph autograph) {
        return createAutographAndReturnId(autograph) > 0;
    }

    public int createAutographAndReturnId(autograph autograph) {
        String sql = "INSERT INTO autograph (a_title, a_description, created_at, user_id, autograph_pic_url) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, autograph.getTitle());
            stmt.setString(2, autograph.getDescription());
            stmt.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
            stmt.setInt(4, autograph.getUserId());
            stmt.setString(5, autograph.getAutographPicUrl());
            int rowsInserted = stmt.executeUpdate();
            System.out.println("[DEBUG autographDAO] createAutograph affected " + rowsInserted + " rows.");
            if (rowsInserted <= 0) {
                return -1;
            }
            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    int newId = rs.getInt(1);
                    autograph.setAutographId(newId);
                    return newId;
                }
            }
            return -1;
        } catch (SQLException e) {
            System.out.println("[DEBUG autographDAO] Error while creating autograph: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Error while creating autograph", e);
        }
    }

    public String getOrCreateShareToken(int autographId) throws SQLException {
        String selectSql = "SELECT share_token FROM autograph WHERE autograph_id = ?";
        String updateSql = "UPDATE autograph SET share_token = ? WHERE autograph_id = ?";
        String newToken = generateToken();

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement selectStmt = conn.prepareStatement(selectSql)) {

            selectStmt.setInt(1, autographId);
            ResultSet rs = selectStmt.executeQuery();

            if (rs.next()) {
                String existingToken = rs.getString("share_token");
                if (existingToken != null && !existingToken.isEmpty()) {
                    return existingToken;
                }
            }

            try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                updateStmt.setString(1, newToken);
                updateStmt.setInt(2, autographId);
                updateStmt.executeUpdate();
            }

            return newToken;
        }
    }

    public boolean revokeShareToken(int autographId) {
        String sql = "UPDATE autograph SET share_token = NULL WHERE autograph_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, autographId);
            int rows = stmt.executeUpdate();
            System.out.println("[DEBUG autographDAO] revokeShareToken for ID " + autographId + ": " + rows + " rows.");
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public autograph getAutographByShareToken(String shareToken) throws SQLException {
        String sql = "SELECT autograph_id, a_title, a_description, created_at, user_id, autograph_pic_url, share_token "
                +
                "FROM autograph WHERE share_token = ?";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, shareToken);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                autograph ag = new autograph();
                ag.setAutographId(rs.getInt("autograph_id"));
                ag.setTitle(rs.getString("a_title"));
                ag.setDescription(rs.getString("a_description"));
                ag.setCreatedAt(rs.getTimestamp("created_at"));
                ag.setUserId(rs.getInt("user_id"));
                ag.setAutographPicUrl(rs.getString("autograph_pic_url"));
                ag.setShareToken(rs.getString("share_token"));
                return ag;
            }
        }

        return null;
    }

    public autograph findById(int autographId) {
        String sql = "SELECT autograph_id, a_title, a_description, created_at, user_id, autograph_pic_url FROM autograph WHERE autograph_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, autographId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                autograph result = mapResultSetToAutograph(rs);
                System.out.println("[DEBUG autographDAO] findById(" + autographId + ") returned: " + result);
                return result;
            } else {
                System.out.println(
                        "[DEBUG autographDAO] findById(" + autographId + ") returned null (record not found).");
            }
        } catch (SQLException e) {
            System.out.println(
                    "[DEBUG autographDAO] Error while fetching autograph by ID " + autographId + ": " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Error while fetching autograph by ID", e);
        }
        return null;
    }


    public List<autograph> findByUserId(int userId) {
        String sql = "SELECT autograph_id, a_title, a_description, created_at, user_id, autograph_pic_url, share_token FROM autograph WHERE user_id = ?";
        List<autograph> autographs = new ArrayList<>();
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                autographs.add(mapResultSetToAutograph(rs));
            }
            System.out.println(
                    "[DEBUG autographDAO] findByUserId(" + userId + ") returned " + autographs.size() + " records.");
        } catch (SQLException e) {
            System.out.println("[DEBUG autographDAO] Error while fetching autographs by user ID " + userId + ": "
                    + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Error while fetching autographs by user ID", e);
        }
        return autographs;
    }

    public boolean updateAutograph(autograph autograph) {
        String sql = "UPDATE autograph SET a_title = ?, a_description = ?, autograph_pic_url = ? WHERE autograph_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, autograph.getTitle()); // Parameter 1: new title
            stmt.setString(2, autograph.getDescription()); // Parameter 2: new description
            stmt.setString(3, autograph.getAutographPicUrl()); // Parameter 3: new pic URL
            stmt.setInt(4, autograph.getAutographId()); // Parameter 4: WHERE autograph_id

            System.out.println("[DEBUG autographDAO] updateAutograph preparing statement with values - Title: '"
                    + autograph.getTitle() + "', Description: '" + autograph.getDescription() + "', Pic URL: '"
                    + autograph.getAutographPicUrl() + "', ID: " + autograph.getAutographId());

            int rowsUpdated = stmt.executeUpdate();

            System.out.println("[DEBUG autographDAO] updateAutograph executed. Rows affected: " + rowsUpdated
                    + " for ID: " + autograph.getAutographId());

            return rowsUpdated > 0;
        } catch (SQLException e) {
            System.out.println("[DEBUG autographDAO] Error while updating autograph ID " + autograph.getAutographId()
                    + ": " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Error while updating autograph", e);
        }
    }

    public boolean deleteAutograph(int autographId) {
        String sql = "DELETE FROM autograph WHERE autograph_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, autographId);
            int rowsDeleted = stmt.executeUpdate();
            System.out.println(
                    "[DEBUG autographDAO] deleteAutograph affected " + rowsDeleted + " rows for ID: " + autographId);
            return rowsDeleted > 0;
        } catch (SQLException e) {
            System.out.println(
                    "[DEBUG autographDAO] Error while deleting autograph ID " + autographId + ": " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Error while deleting autograph", e);
        }
    }

    private autograph mapResultSetToAutograph(ResultSet rs) throws SQLException {
        autograph autograph = new autograph();
        autograph.setAutographId(rs.getInt("autograph_id"));
        autograph.setTitle(rs.getString("a_title"));
        autograph.setDescription(rs.getString("a_description"));
        autograph.setCreatedAt(rs.getTimestamp("created_at"));
        autograph.setUserId(rs.getInt("user_id"));
        autograph.setAutographPicUrl(rs.getString("autograph_pic_url"));
        try {
            autograph.setShareToken(rs.getString("share_token"));
        } catch (SQLException e) {
        }
        return autograph;
    }

    public boolean deleteAutographToRecycleBin(int autographId, int userId) {
        autograph autograph = findById(autographId);
        if (autograph == null || autograph.getUserId() != userId) {
            return false;
        }

        RecycleBinItem item = new RecycleBinItem();
        item.setOriginalId(autograph.getAutographId());
        item.setUserId(userId);
        item.setTitle(autograph.getTitle());
        item.setContent(autograph.getDescription());
        item.setMetadata(buildRecycleMetadata(autographId, autograph));

        RecycleBinDAO rbDao = new RecycleBinDAO();
        int recycleId = rbDao.saveAutographToRecycleBin(item);
        if (recycleId <= 0)
            return false;

        String deleteSql = "DELETE FROM autograph WHERE autograph_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(deleteSql)) {
            stmt.setInt(1, autographId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean restoreAutographFromRecycleBin(int recycleBinId, int userId) {
        RecycleBinDAO rbDao = new RecycleBinDAO();
        RecycleBinItem item = rbDao.findById(recycleBinId);
        if (item == null || !"autograph".equals(item.getItemType()) || item.getUserId() != userId) {
            return false;
        }

        autograph autograph = new autograph();
        autograph.setTitle(item.getTitle());
        autograph.setDescription(item.getContent());
        autograph.setUserId(userId);

        JsonObject metadata = parseMetadata(item.getMetadata());
        String autographPicUrl = getString(metadata, "autographPicUrl");
        autograph.setAutographPicUrl(autographPicUrl);

        int restoredAutographId = createAutographAndReturnId(autograph);
        boolean restored = restoredAutographId > 0;
        if (restored) {
            restoreEntries(metadata, restoredAutographId, userId);
            rbDao.deleteFromRecycleBin(recycleBinId);
            return true;
        }
        return false;
    }

    private String buildRecycleMetadata(int autographId, autograph autograph) {
        JsonObject metadata = new JsonObject();
        metadata.addProperty("autographPicUrl", autograph.getAutographPicUrl() != null ? autograph.getAutographPicUrl() : "");

        JsonArray entriesArray = new JsonArray();
        try {
            AutographEntryDAO entryDAO = new AutographEntryDAO();
            List<AutographEntry> entries = entryDAO.findByAutographId(autographId);
            for (AutographEntry entry : entries) {
                JsonObject entryJson = new JsonObject();
                entryJson.addProperty("link", entry.getLink() != null ? entry.getLink() : "");
                entryJson.addProperty("content", entry.getContent() != null ? entry.getContent() : "");
                entryJson.addProperty("contentPlain", entry.getContentPlain() != null ? entry.getContentPlain() : "");
                entryJson.addProperty("userId", entry.getUserId());
                if (entry.getSubmittedAt() != null) {
                    entryJson.addProperty("submittedAtEpoch", entry.getSubmittedAt().getTime());
                }
                entriesArray.add(entryJson);
            }
        } catch (Exception e) {
            logger.log(Level.WARNING, "Failed to capture autograph entries for recycle bin metadata", e);
        }

        metadata.add("entries", entriesArray);
        return metadata.toString();
    }

    private void restoreEntries(JsonObject metadata, int restoredAutographId, int fallbackUserId) {
        if (metadata == null || !metadata.has("entries") || !metadata.get("entries").isJsonArray()) {
            return;
        }

        AutographEntryDAO entryDAO = new AutographEntryDAO();
        JsonArray entries = metadata.getAsJsonArray("entries");
        for (JsonElement entryElement : entries) {
            if (!entryElement.isJsonObject()) {
                continue;
            }
            JsonObject entryJson = entryElement.getAsJsonObject();
            AutographEntry entry = new AutographEntry();
            entry.setAutographId(restoredAutographId);
            entry.setLink(getString(entryJson, "link"));
            entry.setContent(getString(entryJson, "content"));
            entry.setContentPlain(getString(entryJson, "contentPlain"));
            entry.setUserId(getInt(entryJson, "userId", fallbackUserId));
            long submittedEpoch = getLong(entryJson, "submittedAtEpoch", -1L);
            if (submittedEpoch > 0) {
                entry.setSubmittedAt(new java.util.Date(submittedEpoch));
            }

            try {
                entryDAO.createEntry(entry);
            } catch (Exception e) {
                logger.log(Level.WARNING, "Failed to restore autograph entry for autograph " + restoredAutographId, e);
            }
        }
    }

    private JsonObject parseMetadata(String metadata) {
        if (metadata == null || metadata.trim().isEmpty()) {
            return new JsonObject();
        }
        try {
            JsonElement parsed = JsonParser.parseString(metadata);
            if (parsed.isJsonObject()) {
                return parsed.getAsJsonObject();
            }
        } catch (Exception ignored) {
        }
        return new JsonObject();
    }

    private String getString(JsonObject obj, String key) {
        if (obj == null || !obj.has(key) || obj.get(key).isJsonNull()) {
            return "";
        }
        try {
            return obj.get(key).getAsString();
        } catch (Exception e) {
            return "";
        }
    }

    private int getInt(JsonObject obj, String key, int fallback) {
        if (obj == null || !obj.has(key) || obj.get(key).isJsonNull()) {
            return fallback;
        }
        try {
            return obj.get(key).getAsInt();
        } catch (Exception e) {
            return fallback;
        }
    }

    private long getLong(JsonObject obj, String key, long fallback) {
        if (obj == null || !obj.has(key) || obj.get(key).isJsonNull()) {
            return fallback;
        }
        try {
            return obj.get(key).getAsLong();
        } catch (Exception e) {
            return fallback;
        }
    }

    private String generateToken() {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        StringBuilder token = new StringBuilder();
        java.util.Random random = new java.util.Random();

        for (int i = 0; i < 12; i++) {
            token.append(chars.charAt(random.nextInt(chars.length())));
        }
        return token.toString();
    }
}
