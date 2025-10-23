package com.demo.web.model;

import java.sql.Timestamp;
import java.util.List;

public class Group {
    private int groupId; // Maps to 'group_id' in DB
    private String name; // Maps to 'g_name' in DB
    private String description; // Maps to 'g_description' in DB
    private Timestamp createdAt; // Maps to 'created_at' in DB
    private int userId; // Maps to 'user_id' in DB (creator)
    private String groupPicUrl; // Maps to 'group_pic' in DB
    private String groupUrl; // Maps to 'group_url' in DB
    private List<GroupMember> members; // list of group members

    // Default constructor
    public Group() {
    }

    // Constructor with parameters (excluding members list)
    public Group(int groupId, String name, String description, Timestamp createdAt, int userId, String groupPicUrl, String groupUrl) {
        this.groupId = groupId;
        this.name = name;
        this.description = description;
        this.createdAt = createdAt;
        this.userId = userId;
        this.groupPicUrl = groupPicUrl;
        this.groupUrl = groupUrl;
    }

    // Getters and Setters
    public int getGroupId() {
        return groupId;
    }

    public void setGroupId(int groupId) {
        this.groupId = groupId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getGroupPicUrl() {
        return groupPicUrl;
    }

    public void setGroupPicUrl(String groupPicUrl) {
        this.groupPicUrl = groupPicUrl;
    }

    public String getGroupUrl() {
        return groupUrl;
    }

    public void setGroupUrl(String groupUrl) {
        this.groupUrl = groupUrl;
    }

    public List<GroupMember> getMembers() {
        return members;
    }

    public void setMembers(List<GroupMember> members) {
        this.members = members;
    }

    @Override
    public String toString() {
        return "Group{" +
                "groupId=" + groupId +
                ", name='" + name + '\'' +
                ", description='" + description + '\'' +
                ", createdAt=" + createdAt +
                ", userId=" + userId +
                ", groupPicUrl='" + groupPicUrl + '\'' +
                ", groupUrl='" + groupUrl + '\'' +
                ", members=" + members +
                '}';
    }
}