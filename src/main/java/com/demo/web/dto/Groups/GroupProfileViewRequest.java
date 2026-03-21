package com.demo.web.dto.Groups;

public class GroupProfileViewRequest {
    private Integer currentUserId;
    private String groupIdStr;
    private String memberIdStr;

    public Integer getCurrentUserId() { return currentUserId; }
    public void setCurrentUserId(Integer currentUserId) { this.currentUserId = currentUserId; }
    public String getGroupIdStr() { return groupIdStr; }
    public void setGroupIdStr(String groupIdStr) { this.groupIdStr = groupIdStr; }
    public String getMemberIdStr() { return memberIdStr; }
    public void setMemberIdStr(String memberIdStr) { this.memberIdStr = memberIdStr; }
}
