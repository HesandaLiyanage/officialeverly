package com.demo.web.dao;

import com.demo.web.model.*;
import com.demo.web.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MediaDAO {

    // ... existing methods ...

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
}