package com.demo.web.model;

import java.sql.Timestamp;

/**
 * Model class representing a member of a collaborative memory
 */
public class MemoryMember {
    private int memberId;
    private int memoryId;
    private int userId;
    private String role; // 'owner' or 'contributor'
    private Timestamp joinedAt;
    private byte[] encryptedGroupKey;
    private byte[] groupKeyIv;

    // For display purposes
    private String username;
    private String displayName;

    // Constructors
    public MemoryMember() {
    }

    public MemoryMember(int memoryId, int userId, String role) {
        this.memoryId = memoryId;
        this.userId = userId;
        this.role = role;
    }

    // Getters and Setters
    public int getMemberId() {
        return memberId;
    }

    public void setMemberId(int memberId) {
        this.memberId = memberId;
    }

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

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public Timestamp getJoinedAt() {
        return joinedAt;
    }

    public void setJoinedAt(Timestamp joinedAt) {
        this.joinedAt = joinedAt;
    }

    public byte[] getEncryptedGroupKey() {
        return encryptedGroupKey;
    }

    public void setEncryptedGroupKey(byte[] encryptedGroupKey) {
        this.encryptedGroupKey = encryptedGroupKey;
    }

    public byte[] getGroupKeyIv() {
        return groupKeyIv;
    }

    public void setGroupKeyIv(byte[] groupKeyIv) {
        this.groupKeyIv = groupKeyIv;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getDisplayName() {
        return displayName;
    }

    public void setDisplayName(String displayName) {
        this.displayName = displayName;
    }

    public boolean isOwner() {
        return "owner".equals(role);
    }

    public boolean isContributor() {
        return "contributor".equals(role);
    }

    @Override
    public String toString() {
        return "MemoryMember{" +
                "memberId=" + memberId +
                ", memoryId=" + memoryId +
                ", userId=" + userId +
                ", role='" + role + '\'' +
                '}';
    }
}
