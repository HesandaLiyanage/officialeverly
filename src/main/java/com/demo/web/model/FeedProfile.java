package com.demo.web.model;

import java.sql.Timestamp;

/**
 * Model class for Feed Profile data.
 * Feed profiles are separate from user accounts and used for the public feed
 * feature.
 */
public class FeedProfile {
    private int feedProfileId;
    private int userId;
    private String feedUsername;
    private String feedProfilePictureUrl;
    private String feedBio;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Default constructor
    public FeedProfile() {
    }

    // Constructor with essential fields
    public FeedProfile(int userId, String feedUsername) {
        this.userId = userId;
        this.feedUsername = feedUsername;
    }

    // Getters and Setters
    public int getFeedProfileId() {
        return feedProfileId;
    }

    public void setFeedProfileId(int feedProfileId) {
        this.feedProfileId = feedProfileId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getFeedUsername() {
        return feedUsername;
    }

    public void setFeedUsername(String feedUsername) {
        this.feedUsername = feedUsername;
    }

    public String getFeedProfilePictureUrl() {
        return feedProfilePictureUrl;
    }

    public void setFeedProfilePictureUrl(String feedProfilePictureUrl) {
        this.feedProfilePictureUrl = feedProfilePictureUrl;
    }

    public String getFeedBio() {
        return feedBio;
    }

    public void setFeedBio(String feedBio) {
        this.feedBio = feedBio;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    /**
     * Get initials for avatar display (first 2 characters of username, uppercase)
     */
    public String getInitials() {
        if (feedUsername == null || feedUsername.isEmpty()) {
            return "??";
        }
        String cleaned = feedUsername.replaceAll("[^a-zA-Z0-9]", "");
        if (cleaned.length() >= 2) {
            return cleaned.substring(0, 2).toUpperCase();
        }
        return cleaned.toUpperCase();
    }

    @Override
    public String toString() {
        return "FeedProfile{" +
                "feedProfileId=" + feedProfileId +
                ", userId=" + userId +
                ", feedUsername='" + feedUsername + '\'' +
                ", feedBio='" + feedBio + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
