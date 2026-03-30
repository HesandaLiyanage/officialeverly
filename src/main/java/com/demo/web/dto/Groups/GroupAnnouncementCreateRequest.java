package com.demo.web.dto.Groups;

public class GroupAnnouncementCreateRequest {
    private int userId;
    private String groupIdStr;
    private String title;
    private String content;

    public GroupAnnouncementCreateRequest(int userId, String groupIdStr, String title, String content) {
        this.userId = userId;
        this.groupIdStr = groupIdStr;
        this.title = title;
        this.content = content;
    }

    public int getUserId() { return userId; }
    public String getGroupIdStr() { return groupIdStr; }
    public String getTitle() { return title; }
    public String getContent() { return content; }
}
