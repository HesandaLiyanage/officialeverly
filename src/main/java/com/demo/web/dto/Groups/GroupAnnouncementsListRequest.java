package com.demo.web.dto.Groups;

public class GroupAnnouncementsListRequest {
    private int userId;
    private String groupIdStr;

    public GroupAnnouncementsListRequest(int userId, String groupIdStr) {
        this.userId = userId;
        this.groupIdStr = groupIdStr;
    }

    public int getUserId() { return userId; }
    public String getGroupIdStr() { return groupIdStr; }
}
