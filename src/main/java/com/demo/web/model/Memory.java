package com.demo.web.model;

import java.sql.Timestamp;
import java.util.List;

public class Memory {
    private int memoryId;
    private int userId;
    private String title;
    private String description;
    private Integer coverMediaId;
    private Timestamp createdTimestamp;
    private boolean isPublic;
    private List<MediaItem> mediaItems; // For convenience

    // Sharing enhancements
    private String shareKey; // For link sharing
    private Timestamp expiresAt; // For time-limited sharing
    private boolean isLinkShared; // Flag to indicate if shared via link

    // Constructors
    public Memory() {}

    public Memory(int userId, String title, String description) {
        this.userId = userId;
        this.title = title;
        this.description = description;
        this.createdTimestamp = new Timestamp(System.currentTimeMillis());
        this.isPublic = false;
        this.isLinkShared = false;
    }

    // Getters and Setters
    public int getMemoryId() {
        return memoryId;
    }

    public void setMemoryId(int memoryId) {
        this.memoryId = memoryId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getCoverMediaId() {
        return coverMediaId;
    }

    public void setCoverMediaId(Integer coverMediaId) {
        this.coverMediaId = coverMediaId;
    }

    public Timestamp getCreatedTimestamp() {
        return createdTimestamp;
    }

    public void setCreatedTimestamp(Timestamp createdTimestamp) {
        this.createdTimestamp = createdTimestamp;
    }

    public boolean isPublic() {
        return isPublic;
    }

    public void setPublic(boolean isPublic) {
        this.isPublic = isPublic;
    }

    public List<MediaItem> getMediaItems() {
        return mediaItems;
    }

    public void setMediaItems(List<MediaItem> mediaItems) {
        this.mediaItems = mediaItems;
    }

    // Sharing enhancement getters and setters
    public String getShareKey() {
        return shareKey;
    }

    public void setShareKey(String shareKey) {
        this.shareKey = shareKey;
        if (shareKey != null && !shareKey.isEmpty()) {
            this.isLinkShared = true;
        }
    }

    public Timestamp getExpiresAt() {
        return expiresAt;
    }

    public void setExpiresAt(Timestamp expiresAt) {
        this.expiresAt = expiresAt;
    }

    public boolean isLinkShared() {
        return isLinkShared;
    }

    public void setLinkShared(boolean isLinkShared) {
        this.isLinkShared = isLinkShared;
    }

    // Convenience methods
    public boolean isShared() {
        return isPublic || (isLinkShared && shareKey != null && !shareKey.isEmpty());
    }

    public boolean isExpired() {
        return expiresAt != null && expiresAt.before(new Timestamp(System.currentTimeMillis()));
    }

    public boolean isValidShare() {
        if (!isLinkShared || shareKey == null || shareKey.isEmpty()) {
            return false;
        }
        return !isExpired();
    }

    public void enableLinkSharing() {
        if (this.shareKey == null || this.shareKey.isEmpty()) {
            this.shareKey = java.util.UUID.randomUUID().toString();
        }
        this.isLinkShared = true;
    }

    public void disableLinkSharing() {
        this.shareKey = null;
        this.isLinkShared = false;
        this.expiresAt = null;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Memory memory = (Memory) o;

        return memoryId == memory.memoryId;
    }

    @Override
    public int hashCode() {
        return memoryId;
    }

    @Override
    public String toString() {
        return "Memory{" +
                "memoryId=" + memoryId +
                ", userId=" + userId +
                ", title='" + title + '\'' +
                ", description='" + description + '\'' +
                ", isPublic=" + isPublic +
                ", shareKey='" + (shareKey != null ? "[PROTECTED]" : "null") + '\'' +
                ", isLinkShared=" + isLinkShared +
                ", expiresAt=" + expiresAt +
                ", createdTimestamp=" + createdTimestamp +
                '}';
    }
}