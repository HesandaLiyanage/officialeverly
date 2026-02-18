package com.demo.web.model;

import java.sql.Timestamp;

public class AutographActivity {
    private int activityId;
    private int autographId;
    private String autographTitle;
    private int writerUserId;
    private String writerUsername;
    private Timestamp createdAt;

    public AutographActivity() {
    }

    public int getActivityId() {
        return activityId;
    }

    public void setActivityId(int activityId) {
        this.activityId = activityId;
    }

    public int getAutographId() {
        return autographId;
    }

    public void setAutographId(int autographId) {
        this.autographId = autographId;
    }

    public String getAutographTitle() {
        return autographTitle;
    }

    public void setAutographTitle(String autographTitle) {
        this.autographTitle = autographTitle;
    }

    public int getWriterUserId() {
        return writerUserId;
    }

    public void setWriterUserId(int writerUserId) {
        this.writerUserId = writerUserId;
    }

    public String getWriterUsername() {
        return writerUsername;
    }

    public void setWriterUsername(String writerUsername) {
        this.writerUsername = writerUsername;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    /**
     * Returns the writer's initials (first two characters of username, uppercased).
     */
    public String getWriterInitials() {
        if (writerUsername == null || writerUsername.isEmpty()) {
            return "??";
        }
        String upper = writerUsername.toUpperCase();
        return upper.length() >= 2 ? upper.substring(0, 2) : upper;
    }

    /**
     * Returns a human-readable relative time string.
     */
    public String getRelativeTime() {
        if (createdAt == null)
            return "just now";
        long diffMs = System.currentTimeMillis() - createdAt.getTime();
        long diffMinutes = diffMs / (1000 * 60);
        long diffHours = diffMs / (1000 * 60 * 60);
        long diffDays = diffMs / (1000 * 60 * 60 * 24);

        if (diffMinutes < 1)
            return "just now";
        if (diffMinutes < 60)
            return diffMinutes + (diffMinutes == 1 ? " minute ago" : " minutes ago");
        if (diffHours < 24)
            return diffHours + (diffHours == 1 ? " hour ago" : " hours ago");
        if (diffDays < 30)
            return diffDays + (diffDays == 1 ? " day ago" : " days ago");
        return createdAt.toString().substring(0, 10);
    }
}
