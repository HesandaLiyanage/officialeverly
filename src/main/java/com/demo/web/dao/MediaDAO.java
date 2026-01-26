package com.demo.web.dao;

import com.demo.web.model.MediaItem;
import com.demo.web.util.DatabaseUtil;
import com.demo.web.util.EncryptionService;
import com.demo.web.util.EncryptionService.EncryptedData;

import javax.crypto.SecretKey;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MediaDAO {

    /**
     * Save media metadata to database with encryption info
     */
    public int createMediaItem(MediaItem mediaItem, byte[] encryptionIv) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "INSERT INTO media_items (user_id, filename, original_filename, file_path, " +
                    "file_size, mime_type, media_type, title, description, is_encrypted, " +
                    "encryption_key_id, encryption_iv, original_file_size, is_split, split_count) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) RETURNING media_id";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, mediaItem.getUserId());
            stmt.setString(2, mediaItem.getFilename());
            stmt.setString(3, mediaItem.getOriginalFilename());
            stmt.setString(4, mediaItem.getFilePath());
            stmt.setLong(5, mediaItem.getFileSize());
            stmt.setString(6, mediaItem.getMimeType());
            stmt.setString(7, mediaItem.getMediaType());
            stmt.setString(8, mediaItem.getTitle());
            stmt.setString(9, mediaItem.getDescription());
            stmt.setBoolean(10, mediaItem.isEncrypted());
            stmt.setString(11, mediaItem.getEncryptionKeyId());
            stmt.setBytes(12, encryptionIv);
            stmt.setLong(13, mediaItem.getOriginalFileSize());
            stmt.setBoolean(14, mediaItem.isSplit());
            stmt.setInt(15, mediaItem.getSplitCount());

            rs = stmt.executeQuery();

            if (rs.next()) {
                int mediaId = rs.getInt("media_id");
                mediaItem.setMediaId(mediaId);
                return mediaId;
            }

            throw new SQLException("Failed to create media item, no ID obtained");

        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    /**
     * Store encrypted media encryption key in encryption_keys table
     */
    public boolean storeMediaEncryptionKey(String keyId, int userId, byte[] encryptedKey, byte[] iv)
            throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "INSERT INTO encryption_keys (key_id, user_id, encrypted_key, iv) VALUES (?, ?, ?, ?)";

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, keyId);
            stmt.setInt(2, userId);
            stmt.setBytes(3, encryptedKey);
            stmt.setBytes(4, iv);

            int rowsInserted = stmt.executeUpdate();
            return rowsInserted > 0;

        } finally {
            closeResources(null, stmt, conn);
        }
    }

    /**
     * Get media item by ID
     */
    public MediaItem getMediaById(int mediaId) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT media_id, user_id, filename, original_filename, file_path, " +
                    "file_size, mime_type, media_type, title, description, upload_timestamp, " +
                    "is_encrypted, encryption_key_id, encryption_iv, original_file_size, " +
                    "is_split, split_count FROM media_items WHERE media_id = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, mediaId);

            rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToMediaItem(rs);
            }

            return null;

        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    /**
     * Get encrypted media key for decryption
     */
    public EncryptionKeyData getMediaEncryptionKey(String keyId, int userId) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT encrypted_key, iv FROM encryption_keys WHERE key_id = ? AND user_id = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, keyId);
            stmt.setInt(2, userId);

            rs = stmt.executeQuery();

            if (rs.next()) {
                return new EncryptionKeyData(
                        rs.getBytes("encrypted_key"),
                        rs.getBytes("iv"));
            }

            return null;

        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    /**
     * Get all media for a memory
     */
    public List<MediaItem> getMediaByMemoryId(int memoryId) throws SQLException {
        List<MediaItem> mediaItems = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT mi.media_id, mi.user_id, mi.filename, mi.original_filename, mi.file_path, " +
                    "mi.file_size, mi.mime_type, mi.media_type, mi.title, mi.description, mi.upload_timestamp, " +
                    "mi.is_encrypted, mi.encryption_key_id, mi.encryption_iv, mi.original_file_size, " +
                    "mi.is_split, mi.split_count " +
                    "FROM media_items mi " +
                    "JOIN memory_media mm ON mi.media_id = mm.media_id " +
                    "WHERE mm.memory_id = ? ORDER BY mm.added_timestamp ASC";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, memoryId);

            rs = stmt.executeQuery();

            while (rs.next()) {
                mediaItems.add(mapResultSetToMediaItem(rs));
            }

            return mediaItems;

        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    /**
     * Get all media for a user
     */
    public List<MediaItem> getMediaByUserId(int userId) throws SQLException {
        List<MediaItem> mediaItems = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT media_id, user_id, filename, original_filename, file_path, " +
                    "file_size, mime_type, media_type, title, description, upload_timestamp, " +
                    "is_encrypted, encryption_key_id, encryption_iv, original_file_size, " +
                    "is_split, split_count FROM media_items WHERE user_id = ? " +
                    "ORDER BY upload_timestamp DESC";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);

            rs = stmt.executeQuery();

            while (rs.next()) {
                mediaItems.add(mapResultSetToMediaItem(rs));
            }

            return mediaItems;

        } finally {
            closeResources(rs, stmt, conn);
        }
    }

    /**
     * Delete media item
     */
    public boolean deleteMediaItem(int mediaId) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "DELETE FROM media_items WHERE media_id = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, mediaId);

            int rowsDeleted = stmt.executeUpdate();
            return rowsDeleted > 0;

        } finally {
            closeResources(null, stmt, conn);
        }
    }

    /**
     * Map ResultSet to MediaItem object
     */
    private MediaItem mapResultSetToMediaItem(ResultSet rs) throws SQLException {
        MediaItem item = new MediaItem();
        item.setMediaId(rs.getInt("media_id"));
        item.setUserId(rs.getInt("user_id"));
        item.setFilename(rs.getString("filename"));
        item.setOriginalFilename(rs.getString("original_filename"));
        item.setFilePath(rs.getString("file_path"));
        item.setFileSize(rs.getLong("file_size"));
        item.setMimeType(rs.getString("mime_type"));
        item.setMediaType(rs.getString("media_type"));
        item.setTitle(rs.getString("title"));
        item.setDescription(rs.getString("description"));
        item.setUploadTimestamp(rs.getTimestamp("upload_timestamp"));
        item.setEncrypted(rs.getBoolean("is_encrypted"));
        item.setEncryptionKeyId(rs.getString("encryption_key_id"));

        // NEW: Get encryption_iv
        byte[] encryptionIv = rs.getBytes("encryption_iv");
        if (encryptionIv != null) {
            item.setEncryptionIv(encryptionIv);
        }

        item.setOriginalFileSize(rs.getLong("original_file_size"));
        item.setSplit(rs.getBoolean("is_split"));
        item.setSplitCount(rs.getInt("split_count"));

        return item;
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

    /**
     * Helper class to hold encryption key data
     */
    public static class EncryptionKeyData {
        private final byte[] encryptedKey;
        private final byte[] iv;

        public EncryptionKeyData(byte[] encryptedKey, byte[] iv) {
            this.encryptedKey = encryptedKey;
            this.iv = iv;
        }

        public byte[] getEncryptedKey() {
            return encryptedKey;
        }

        public byte[] getIv() {
            return iv;
        }
    }

    /**
     * Get the memory ID that a media item belongs to
     */
    public int getMemoryIdForMedia(int mediaId) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT memory_id FROM memory_media WHERE media_id = ? LIMIT 1";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, mediaId);

            rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt("memory_id");
            }

            return -1; // Not associated with any memory

        } finally {
            closeResources(rs, stmt, conn);
        }
    }

}