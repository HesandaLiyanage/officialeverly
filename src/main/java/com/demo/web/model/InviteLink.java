package com.demo.web.model;

import java.sql.Timestamp;

/**
 * Model class representing a memory invite link
 * Used for collaborative memory sharing
 */
public class InviteLink {
    private int inviteId;
    private int memoryId;
    private String inviteToken;
    private int createdBy;
    private Timestamp createdAt;
    private Timestamp expiresAt;
    private Integer maxUses;
    private int useCount;
    private boolean isActive;

    // Constructors
    public InviteLink() {
    }

    public InviteLink(int memoryId, String inviteToken, int createdBy) {
        this.memoryId = memoryId;
        this.inviteToken = inviteToken;
        this.createdBy = createdBy;
        this.isActive = true;
        this.useCount = 0;
    }

    // Getters and Setters
    public int getInviteId() {
        return inviteId;
    }

    public void setInviteId(int inviteId) {
        this.inviteId = inviteId;
    }

    public int getMemoryId() {
        return memoryId;
    }

    public void setMemoryId(int memoryId) {
        this.memoryId = memoryId;
    }

    public String getInviteToken() {
        return inviteToken;
    }

    public void setInviteToken(String inviteToken) {
        this.inviteToken = inviteToken;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getExpiresAt() {
        return expiresAt;
    }

    public void setExpiresAt(Timestamp expiresAt) {
        this.expiresAt = expiresAt;
    }

    public Integer getMaxUses() {
        return maxUses;
    }

    public void setMaxUses(Integer maxUses) {
        this.maxUses = maxUses;
    }

    public int getUseCount() {
        return useCount;
    }

    public void setUseCount(int useCount) {
        this.useCount = useCount;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    /**
     * Check if this invite link is valid for use
     */
    public boolean isValid() {
        if (!isActive) {
            return false;
        }
        if (expiresAt != null && expiresAt.before(new Timestamp(System.currentTimeMillis()))) {
            return false;
        }
        if (maxUses != null && useCount >= maxUses) {
            return false;
        }
        return true;
    }

    /**
     * Generate the full invite URL
     */
    public String getInviteUrl(String baseUrl) {
        return baseUrl + "/invite/" + inviteToken;
    }

    @Override
    public String toString() {
        return "InviteLink{" +
                "inviteId=" + inviteId +
                ", memoryId=" + memoryId +
                ", inviteToken='" + inviteToken + '\'' +
                ", isActive=" + isActive +
                ", useCount=" + useCount +
                '}';
    }
}
