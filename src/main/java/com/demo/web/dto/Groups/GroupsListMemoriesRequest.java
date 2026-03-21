package com.demo.web.dto.Groups;

public class GroupsListMemoriesRequest {
    private Integer userId;
    private String groupIdParam;

    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }
    public String getGroupIdParam() { return groupIdParam; }
    public void setGroupIdParam(String groupIdParam) { this.groupIdParam = groupIdParam; }
}
