package com.demo.web.model;

import java.sql.Timestamp;

public class GroupInvite {
    private int inviteId;
    private int groupId;
    private String inviteToken;
    private int createdBy;
    private Timestamp createdAt;
    private boolean isActive;

    // Default constructor
    public GroupInvite() {
    }

    // Constructor with parameters
    public GroupInvite(int inviteId, int groupId, String inviteToken, int createdBy, Timestamp createdAt, boolean isActive) {
        this.inviteId = inviteId;
        this.groupId = groupId;
        this.inviteToken = inviteToken;
        this.createdBy = createdBy;
        this.createdAt = createdAt;
        this.isActive = isActive;
    }

    // Getters and Setters
    public int getInviteId() {
        return inviteId;
    }

    public void setInviteId(int inviteId) {
        this.inviteId = inviteId;
    }

    public int getGroupId() {
        return groupId;
    }

    public void setGroupId(int groupId) {
        this.groupId = groupId;
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

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    @Override
    public String toString() {
        return "GroupInvite{" +
                "inviteId=" + inviteId +
                ", groupId=" + groupId +
                ", inviteToken='" + inviteToken + '\'' +
                ", createdBy=" + createdBy +
                ", createdAt=" + createdAt +
                ", isActive=" + isActive +
                '}';
    }
}
