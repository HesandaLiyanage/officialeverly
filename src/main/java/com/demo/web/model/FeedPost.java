package com.demo.web.model;

import java.sql.Timestamp;
import java.util.List;

/**
 * Model class for Feed Post data.
 * A post is a memory shared to the public feed.
 */
public class FeedPost {
    private int postId;
    private int memoryId;
    private int feedProfileId;
    private String caption;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Transient fields for display (populated by DAO joins)
    private Memory memory;
    private FeedProfile feedProfile;
    private String coverMediaUrl; // First media URL for display
    private List<MediaItem> mediaItems; // All media items for carousel display
    private int likeCount; // Number of likes on this post
    private boolean likedByCurrentUser; // Whether current user has liked this post

    // Default constructor
    public FeedPost() {
    }

    // Constructor with essential fields
    public FeedPost(int memoryId, int feedProfileId) {
        this.memoryId = memoryId;
        this.feedProfileId = feedProfileId;
    }

    // Getters and Setters
    public int getPostId() {
        return postId;
    }

    public void setPostId(int postId) {
        this.postId = postId;
    }

    public int getMemoryId() {
        return memoryId;
    }

    public void setMemoryId(int memoryId) {
        this.memoryId = memoryId;
    }

    public int getFeedProfileId() {
        return feedProfileId;
    }

    public void setFeedProfileId(int feedProfileId) {
        this.feedProfileId = feedProfileId;
    }

    public String getCaption() {
        return caption;
    }

    public void setCaption(String caption) {
        this.caption = caption;
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

    // Transient getters and setters
    public Memory getMemory() {
        return memory;
    }

    public void setMemory(Memory memory) {
        this.memory = memory;
    }

    public FeedProfile getFeedProfile() {
        return feedProfile;
    }

    public void setFeedProfile(FeedProfile feedProfile) {
        this.feedProfile = feedProfile;
    }

    public String getCoverMediaUrl() {
        return coverMediaUrl;
    }

    public void setCoverMediaUrl(String coverMediaUrl) {
        this.coverMediaUrl = coverMediaUrl;
    }

    public List<MediaItem> getMediaItems() {
        return mediaItems;
    }

    public void setMediaItems(List<MediaItem> mediaItems) {
        this.mediaItems = mediaItems;
    }

    public int getLikeCount() {
        return likeCount;
    }

    public void setLikeCount(int likeCount) {
        this.likeCount = likeCount;
    }

    public boolean isLikedByCurrentUser() {
        return likedByCurrentUser;
    }

    public void setLikedByCurrentUser(boolean likedByCurrentUser) {
        this.likedByCurrentUser = likedByCurrentUser;
    }

    /**
     * Get relative time string for display (e.g., "2 hours ago")
     */
    public String getRelativeTime() {
        if (createdAt == null)
            return "";

        long diffMs = System.currentTimeMillis() - createdAt.getTime();
        long diffSeconds = diffMs / 1000;
        long diffMinutes = diffSeconds / 60;
        long diffHours = diffMinutes / 60;
        long diffDays = diffHours / 24;

        if (diffDays > 0) {
            return diffDays == 1 ? "1 day ago" : diffDays + " days ago";
        } else if (diffHours > 0) {
            return diffHours == 1 ? "1 hour ago" : diffHours + " hours ago";
        } else if (diffMinutes > 0) {
            return diffMinutes == 1 ? "1 minute ago" : diffMinutes + " minutes ago";
        } else {
            return "Just now";
        }
    }

    @Override
    public String toString() {
        return "FeedPost{" +
                "postId=" + postId +
                ", memoryId=" + memoryId +
                ", feedProfileId=" + feedProfileId +
                ", caption='" + caption + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
