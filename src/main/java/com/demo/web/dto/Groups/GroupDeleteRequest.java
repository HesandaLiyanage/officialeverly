package com.demo.web.dto.Groups;

public class GroupDeleteRequest {
    private Integer userId;
    private String groupIdStr;
    
    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }
    public String getGroupIdStr() { return groupIdStr; }
    public void setGroupIdStr(String groupIdStr) { this.groupIdStr = groupIdStr; }
}
