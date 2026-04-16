package com.demo.web.dto.Groups;

public class GroupsListRequest {
    private Integer userId;

    public GroupsListRequest(Integer userId) {
        this.userId = userId;
    }

    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }
}
