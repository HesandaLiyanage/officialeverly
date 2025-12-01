package com.demo.web.model;

import java.sql.Timestamp;

public class Memory {
    private int memoryId;
    private String title;
    private String description;
    private Timestamp updatedAt;
    private int userId;
    private Integer coverMediaId; // Can be null
    private Timestamp createdTimestamp;
    private boolean isPublic;
    private String shareKey;
    private Timestamp expiresAt;
    private boolean isLinkShared;

    // Constructors
    public Memory() {
    }

    public Memory(String title, String description, int userId) {
        this.title = title;
        this.description = description;
        this.userId = userId;
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

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
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

    public void setPublic(boolean aPublic) {
        isPublic = aPublic;
    }

    public String getShareKey() {
        return shareKey;
    }

    public void setShareKey(String shareKey) {
        this.shareKey = shareKey;
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

    public void setLinkShared(boolean linkShared) {
        isLinkShared = linkShared;
    }

    @Override
    public String toString() {
        return "Memory{" +
                "memoryId=" + memoryId +
                ", title='" + title + '\'' +
                ", description='" + description + '\'' +
                ", userId=" + userId +
                ", coverMediaId=" + coverMediaId +
                ", isPublic=" + isPublic +
                ", createdTimestamp=" + createdTimestamp +
                '}';
    }
}