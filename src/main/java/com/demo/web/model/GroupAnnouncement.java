package com.demo.web.model;

import java.sql.Timestamp;

public class GroupAnnouncement {
    private int announcementId;
    private int groupId;
    private int userId;
    private String title;
    private String content;
    private Timestamp createdAt;
    
    // Virtual field for easy display
    private user postedBy;

    public GroupAnnouncement() {}

    public GroupAnnouncement(int groupId, int userId, String title, String content) {
        this.groupId = groupId;
        this.userId = userId;
        this.title = title;
        this.content = content;
    }

    public int getAnnouncementId() {
        return announcementId;
    }

    public void setAnnouncementId(int announcementId) {
        this.announcementId = announcementId;
    }

    public int getGroupId() {
        return groupId;
    }

    public void setGroupId(int groupId) {
        this.groupId = groupId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public user getPostedBy() {
        return postedBy;
    }

    public void setPostedBy(user postedBy) {
        this.postedBy = postedBy;
    }

    @Override
    public String toString() {
        return "GroupAnnouncement{" +
                "announcementId=" + announcementId +
                ", groupId=" + groupId +
                ", userId=" + userId +
                ", title='" + title + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
