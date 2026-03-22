package com.demo.web.dto.Groups;

public class GroupAnnouncementViewRequest {
    private Integer currentUserId;
    private String announcementIdStr;

    public GroupAnnouncementViewRequest(Integer currentUserId, String announcementIdStr) {
        this.currentUserId = currentUserId;
        this.announcementIdStr = announcementIdStr;
    }

    public Integer getCurrentUserId() { return currentUserId; }
    public String getAnnouncementIdStr() { return announcementIdStr; }
}
