package com.demo.web.dao;

import com.demo.web.model.*;
import com.demo.web.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MediaDAO {

    /**
     * Save media item to database
     */
    public boolean saveMediaItem(MediaItem mediaItem) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "INSERT INTO media_items (user_id, filename, original_filename, " +
                    "file_path, file_size, mime_type, media_type, title, storage_bucket, metadata) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setInt(1, mediaItem.getUserId());
            stmt.setString(2, mediaItem.getFilename());
            stmt.setString(3, mediaItem.getOriginalFilename());
            stmt.setString(4, mediaItem.getFilePath());
            stmt.setLong(5, mediaItem.getFileSize());
            stmt.setString(6, mediaItem.getMimeType());
            stmt.setString(7, mediaItem.getMediaType());
            stmt.setString(8, mediaItem.getTitle());
            stmt.setString(9, mediaItem.getStorageBucket());
            stmt.setString(10, mediaItem.getMetadata());

            int rowsInserted = stmt.executeUpdate();

            if (rowsInserted > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    mediaItem.setMediaId(generatedKeys.getInt(1));
                }
                return true;
            }
            return false;

        } finally {
            closeResources(null, stmt, conn);
        }
    }

    /**
     * Get all media items for a user
     */
    public List<MediaItem> getUserMediaItems(int userId) throws SQLException {
        List<MediaItem> mediaItems = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT * FROM media_items WHERE user_id = ? ORDER BY upload_timestamp DESC";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                mediaItems.add(mapResultSetToMediaItem(rs));
            }

        } finally {
            closeResources(rs, stmt, conn);
        }

        return mediaItems;
    }

    /**
     * Get media item by ID
     */
    public MediaItem getMediaItemById(int mediaId) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT * FROM media_items WHERE media_id = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, mediaId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToMediaItem(rs);
            }

        } finally {
            closeResources(rs, stmt, conn);
        }

        return null;
    }

    /**
     * Create a new memory/album
     */
    public boolean createMemory(Memory memory) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "INSERT INTO memories (user_id, title, description, cover_media_id, is_public) " +
                    "VALUES (?, ?, ?, ?, ?)";

            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setInt(1, memory.getUserId());
            stmt.setString(2, memory.getTitle());
            stmt.setString(3, memory.getDescription());
            stmt.setObject(4, memory.getCoverMediaId(), Types.INTEGER);
            stmt.setBoolean(5, memory.isPublic());

            int rowsInserted = stmt.executeUpdate();

            if (rowsInserted > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    memory.setMemoryId(generatedKeys.getInt(1));
                }
                return true;
            }
            return false;

        } finally {
            closeResources(null, stmt, conn);
        }
    }

    /**
     * Add media to memory
     */
    public boolean addMediaToMemory(int memoryId, int mediaId) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "INSERT INTO memory_media (memory_id, media_id) VALUES (?, ?)";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, memoryId);
            stmt.setInt(2, mediaId);

            int rowsInserted = stmt.executeUpdate();
            return rowsInserted > 0;

        } finally {
            closeResources(null, stmt, conn);
        }
    }

    /**
     * Get memories for user
     */
    public List<Memory> getUserMemories(int userId) throws SQLException {
        List<Memory> memories = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT * FROM memories WHERE user_id = ? ORDER BY created_timestamp DESC";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                Memory memory = new Memory();
                memory.setMemoryId(rs.getInt("memory_id"));
                memory.setUserId(rs.getInt("user_id"));
                memory.setTitle(rs.getString("title"));
                memory.setDescription(rs.getString("description"));
                memory.setCoverMediaId(rs.getObject("cover_media_id", Integer.class));
                memory.setCreatedTimestamp(rs.getTimestamp("created_timestamp"));
                memory.setPublic(rs.getBoolean("is_public"));
                memories.add(memory);
            }

        } finally {
            closeResources(rs, stmt, conn);
        }

        return memories;
    }

    /**
     * Save encryption key
     */
    public boolean saveEncryptionKey(EncryptionKey encryptionKey) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "INSERT INTO encryption_keys (key_id, user_id, encrypted_key) VALUES (?, ?, ?)";

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, encryptionKey.getKeyId());
            stmt.setInt(2, encryptionKey.getUserId());
            stmt.setBytes(3, encryptionKey.getEncryptedKey());

            int rowsInserted = stmt.executeUpdate();
            return rowsInserted > 0;

        } finally {
            closeResources(null, stmt, conn);
        }
    }

    /**
     * Get user's encryption key
     */
    public EncryptionKey getUserEncryptionKey(String keyId, int userId) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT * FROM encryption_keys WHERE key_id = ? AND user_id = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, keyId);
            stmt.setInt(2, userId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                EncryptionKey key = new EncryptionKey();
                key.setKeyId(rs.getString("key_id"));
                key.setUserId(rs.getInt("user_id"));
                key.setEncryptedKey(rs.getBytes("encrypted_key"));
                key.setCreatedAt(rs.getTimestamp("created_at"));
                return key;
            }

        } finally {
            closeResources(rs, stmt, conn);
        }

        return null;
    }

    /**
     * Create media share
     */
    public boolean createMediaShare(MediaShare share) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "INSERT INTO media_shares (media_id, share_type, share_key, expires_at) VALUES (?, ?, ?, ?)";

            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setInt(1, share.getMediaId());
            stmt.setString(2, share.getShareType());
            stmt.setString(3, share.getShareKey());
            stmt.setTimestamp(4, share.getExpiresAt());

            int rowsInserted = stmt.executeUpdate();

            if (rowsInserted > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    share.setShareId(generatedKeys.getInt(1));
                }
                return true;
            }
            return false;

        } finally {
            closeResources(null, stmt, conn);
        }
    }

    /**
     * Get share by key (for link sharing)
     */
    public MediaShare getShareByKey(String shareKey) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT * FROM media_shares WHERE share_key = ? AND (expires_at IS NULL OR expires_at > ?)";

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, shareKey);
            stmt.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
            rs = stmt.executeQuery();

            if (rs.next()) {
                MediaShare share = new MediaShare();
                share.setShareId(rs.getInt("share_id"));
                share.setMediaId(rs.getInt("media_id"));
                share.setShareType(rs.getString("share_type"));
                share.setShareKey(rs.getString("share_key"));
                share.setExpiresAt(rs.getTimestamp("expires_at"));
                share.setCreatedAt(rs.getTimestamp("created_at"));
                return share;
            }

        } finally {
            closeResources(rs, stmt, conn);
        }

        return null;
    }

    /**
     * Share media with group
     */
    public boolean shareMediaWithGroup(int groupId, int mediaId, int sharedByUserId) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "INSERT INTO group_media_shares (group_id, media_id, shared_by_user_id) VALUES (?, ?, ?)";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, groupId);
            stmt.setInt(2, mediaId);
            stmt.setInt(3, sharedByUserId);

            int rowsInserted = stmt.executeUpdate();
            return rowsInserted > 0;

        } finally {
            closeResources(null, stmt, conn);
        }
    }

    /**
     * Get shared media for group
     */
    public List<MediaItem> getGroupSharedMedia(int groupId) throws SQLException {
        List<MediaItem> mediaItems = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT mi.* FROM media_items mi " +
                    "JOIN group_media_shares gms ON mi.media_id = gms.media_id " +
                    "WHERE gms.group_id = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, groupId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                mediaItems.add(mapResultSetToMediaItem(rs));
            }

        } finally {
            closeResources(rs, stmt, conn);
        }

        return mediaItems;
    }

    /**
     * Update media item with encryption info
     */
    public boolean updateMediaEncryptionInfo(MediaItem mediaItem) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "UPDATE media_items SET is_encrypted = ?, encryption_key_id = ?, " +
                    "file_hash = ?, split_count = ?, original_file_size = ?, is_split = ? " +
                    "WHERE media_id = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setBoolean(1, mediaItem.isEncrypted());
            stmt.setString(2, mediaItem.getEncryptionKeyId());
            stmt.setString(3, mediaItem.getFileHash());
            stmt.setInt(4, mediaItem.getSplitCount());
            stmt.setLong(5, mediaItem.getOriginalFileSize());
            stmt.setBoolean(6, mediaItem.isSplit());
            stmt.setInt(7, mediaItem.getMediaId());

            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0;

        } finally {
            closeResources(null, stmt, conn);
        }
    }

    /**
     * Map ResultSet to MediaItem
     */
    private MediaItem mapResultSetToMediaItem(ResultSet rs) throws SQLException {
        MediaItem mediaItem = new MediaItem();
        mediaItem.setMediaId(rs.getInt("media_id"));
        mediaItem.setUserId(rs.getInt("user_id"));
        mediaItem.setFilename(rs.getString("filename"));
        mediaItem.setOriginalFilename(rs.getString("original_filename"));
        mediaItem.setFilePath(rs.getString("file_path"));
        mediaItem.setFileSize(rs.getLong("file_size"));
        mediaItem.setMimeType(rs.getString("mime_type"));
        mediaItem.setMediaType(rs.getString("media_type"));
        mediaItem.setTitle(rs.getString("title"));
        mediaItem.setDescription(rs.getString("description"));
        mediaItem.setUploadTimestamp(rs.getTimestamp("upload_timestamp"));
        mediaItem.setPublic(rs.getBoolean("is_public"));
        mediaItem.setStorageBucket(rs.getString("storage_bucket"));
        mediaItem.setMetadata(rs.getString("metadata"));
        return mediaItem;
    }

    /**
     * Close database resources
     */
    private void closeResources(ResultSet rs, PreparedStatement stmt, Connection conn) {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}