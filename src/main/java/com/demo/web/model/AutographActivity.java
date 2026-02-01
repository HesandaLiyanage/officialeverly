package com.demo.web.model;

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
}
