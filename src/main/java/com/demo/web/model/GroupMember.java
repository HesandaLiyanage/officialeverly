package com.demo.web.model;

import java.sql.Timestamp;

public class GroupMember {
    private int groupId;      // link to group
    private user user;        // member details
    private String role;      // e.g., admin, member
    private Timestamp joinedAt; // when the user joined
    private String status;    // e.g., active, inactive

    // Default constructor
    public GroupMember() {
    }

    // Constructor with parameters
    public GroupMember(int groupId, user user, String role, Timestamp joinedAt, String status) {
        this.groupId = groupId;
        this.user = user;
        this.role = role;
        this.joinedAt = joinedAt;
        this.status = status;
    }

    // Getters and Setters
    public int getGroupId() {
        return groupId;
    }

    public void setGroupId(int groupId) {
        this.groupId = groupId;
    }

    public user getUser() {
        return user;
    }

    public void setUser(user user) {
        this.user = user;
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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "GroupMember{" +
                "groupId=" + groupId +
                ", user=" + user +
                ", role='" + role + '\'' +
                ", joinedAt=" + joinedAt +
                ", status='" + status + '\'' +
                '}';
    }
}
