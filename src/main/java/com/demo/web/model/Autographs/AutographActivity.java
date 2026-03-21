package com.demo.web.model.Autographs;

import java.sql.Timestamp;

/**
 * Model class representing an activity in the autograph book.
 * Used to track when invitees write in autograph books.
 */
public class AutographActivity {
    private int activityId;
    private String activityType; // Default: "autograph_written"
    private int autographId;
    private Integer entryId; // Nullable - the entry that was created
    private int inviteeUserId;
    private String bookTitle;
    private Timestamp createdAt;

    // For display purposes - joined from users table
    private String inviteeUsername;

    // Constructors
    public AutographActivity() {
        this.activityType = "autograph_written";
    }

    // Getters and Setters
    public int getActivityId() {
        return activityId;
    }

    public void setActivityId(int activityId) {
        this.activityId = activityId;
    }

    public String getActivityType() {
        return activityType;
    }

    public void setActivityType(String activityType) {
        this.activityType = activityType;
    }

    public int getAutographId() {
        return autographId;
    }

    public void setAutographId(int autographId) {
        this.autographId = autographId;
    }

    public Integer getEntryId() {
        return entryId;
    }

    public void setEntryId(Integer entryId) {
        this.entryId = entryId;
    }

    public int getInviteeUserId() {
        return inviteeUserId;
    }

    public void setInviteeUserId(int inviteeUserId) {
        this.inviteeUserId = inviteeUserId;
    }

    public String getBookTitle() {
        return bookTitle;
    }

    public void setBookTitle(String bookTitle) {
        this.bookTitle = bookTitle;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getInviteeUsername() {
        return inviteeUsername;
    }

    public void setInviteeUsername(String inviteeUsername) {
        this.inviteeUsername = inviteeUsername;
    }

    /**
     * Get initials from the username for avatar display
     */
    public String getInitials() {
        if (inviteeUsername == null || inviteeUsername.isEmpty()) {
            return "??";
        }
        String[] parts = inviteeUsername.trim().split("\\s+");
        if (parts.length >= 2) {
            return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
        }
        return inviteeUsername.substring(0, Math.min(2, inviteeUsername.length())).toUpperCase();
    }

    public String getRelativeTime() {
        if (createdAt == null) return "Unknown";
        long diffMs = System.currentTimeMillis() - createdAt.getTime();
        long diffSec = diffMs / 1000;
        long diffMin = diffSec / 60;
        long diffHour = diffMin / 60;

        if (diffMin < 1) { return "Just now"; }
        else if (diffMin < 60) { return diffMin + " min ago"; }
        else if (diffHour < 24) { return diffHour + " hour" + (diffHour > 1 ? "s" : "") + " ago"; }
        else {
            return new java.text.SimpleDateFormat("MMM d").format(createdAt);
        }
    }

    public String getAvatarGradient() {
        String[] gradients = {
            "linear-gradient(135deg, #667eea 0%, #764ba2 100%)",
            "linear-gradient(135deg, #f093fb 0%, #f5576c 100%)",
            "linear-gradient(135deg, #a8edea 0%, #fed6e3 100%)",
            "linear-gradient(135deg, #ffecd2 0%, #fcb69f 100%)",
            "linear-gradient(135deg, #ff9a9e 0%, #fecfef 100%)",
            "linear-gradient(135deg, #4facfe 0%, #00f2fe 100%)",
            "linear-gradient(135deg, #43e97b 0%, #38f9d7 100%)"
        };
        // Use activityId or object hash to get a consistent color from array
        int index = Math.abs(this.hashCode()) % gradients.length;
        return gradients[index];
    }
}
