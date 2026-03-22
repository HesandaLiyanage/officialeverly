package com.demo.web.dto.Groups;

public class GroupMemberActionRequest {
    private Integer userId;
    private String action;
    private String groupIdStr;
    private String memberIdStr;
    private String newRole;

    public GroupMemberActionRequest(Integer userId, String action, String groupIdStr, String memberIdStr, String newRole) {
        this.userId = userId;
        this.action = action;
        this.groupIdStr = groupIdStr;
        this.memberIdStr = memberIdStr;
        this.newRole = newRole;
    }

    public Integer getUserId() { return userId; }
    public String getAction() { return action; }
    public String getGroupIdStr() { return groupIdStr; }
    public String getMemberIdStr() { return memberIdStr; }
    public String getNewRole() { return newRole; }
}
