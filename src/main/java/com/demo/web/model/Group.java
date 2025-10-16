package com.demo.web.model;

import java.util.List;

public class Group {
    private int groupId;
    private String name;
    private int creatorId;
    private List<GroupMember> members; // list of group members

    // Default constructor
    public Group() {
    }

    // Constructor with parameters
    public Group(int groupId, String name, int creatorId, List<GroupMember> members) {
        this.groupId = groupId;
        this.name = name;
        this.creatorId = creatorId;
        this.members = members;
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

    public int getCreatorId() {
        return creatorId;
    }

    public void setCreatorId(int creatorId) {
        this.creatorId = creatorId;
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
                ", creatorId=" + creatorId +
                ", members=" + members +
                '}';
    }
}
