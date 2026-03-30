package com.demo.web.dto.Groups;

public class GroupMembersListRequest {
    private Integer userId;
    private String groupIdStr;
    private String msg;
    private String error;

    public GroupMembersListRequest(Integer userId, String groupIdStr, String msg, String error) {
        this.userId = userId;
        this.groupIdStr = groupIdStr;
        this.msg = msg;
        this.error = error;
    }

    public Integer getUserId() { return userId; }
    public String getGroupIdStr() { return groupIdStr; }
    public String getMsg() { return msg; }
    public String getError() { return error; }
}
