package com.demo.web.model;

import java.sql.Timestamp;

/**
 * Model for memory collaboration membership
 */
public class MemoryMember {
    private int id;
    private int memoryId;
    private int userId;
    private String role; // 'owner' or 'member'
    private Timestamp joinedAt;

    // User details for display
    private String username;
    private String email;

    // Constructors
    public MemoryMember() {
    }

    public MemoryMember(int memoryId, int userId, String role) {
        this.memoryId = memoryId;
        this.userId = userId;
        this.role = role;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
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

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public boolean isOwner() {
        return "owner".equalsIgnoreCase(role);
    }

    @Override
    public String toString() {
        return "MemoryMember{" +
                "id=" + id +
                ", memoryId=" + memoryId +
                ", userId=" + userId +
                ", role='" + role + '\'' +
                ", username='" + username + '\'' +
                '}';
    }
}
