package com.demo.web.dto.Groups;

public class GroupInviteJoinRequest {
    private String pathInfo;
    private Integer userId;

    public GroupInviteJoinRequest(String pathInfo, Integer userId) {
        this.pathInfo = pathInfo;
        this.userId = userId;
    }

    public String getPathInfo() { return pathInfo; }
    public Integer getUserId() { return userId; }
}
