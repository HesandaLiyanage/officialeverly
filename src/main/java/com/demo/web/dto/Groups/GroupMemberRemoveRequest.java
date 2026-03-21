package com.demo.web.dto.Groups;

public class GroupMemberRemoveRequest {
    private Integer currentUserId;
    private String groupIdStr;
    private String memberIdStr;

    public GroupMemberRemoveRequest(Integer currentUserId, String groupIdStr, String memberIdStr) {
        this.currentUserId = currentUserId;
        this.groupIdStr = groupIdStr;
        this.memberIdStr = memberIdStr;
    }

    public Integer getCurrentUserId() { return currentUserId; }
    public String getGroupIdStr() { return groupIdStr; }
    public String getMemberIdStr() { return memberIdStr; }
}
