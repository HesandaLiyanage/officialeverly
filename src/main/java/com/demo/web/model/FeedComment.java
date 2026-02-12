package com.demo.web.model;

import java.sql.Timestamp;

/**
 * Model class for Feed Post Comment data.
 * Represents a comment on a feed post.
 */
public class FeedComment {
    private int commentId;
    private int postId;
    private int feedProfileId;
    private Integer parentCommentId; // null for top-level comments
    private String commentText;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Transient fields for display (populated by DAO joins)
    private FeedProfile feedProfile;
    private int likeCount;
    private boolean likedByCurrentUser;

    // Default constructor
    public FeedComment() {
    }

    // Constructor with essential fields
    public FeedComment(int postId, int feedProfileId, String commentText) {
        this.postId = postId;
        this.feedProfileId = feedProfileId;
        this.commentText = commentText;
    }

    // Getters and Setters
    public int getCommentId() {
        return commentId;
    }

    public void setCommentId(int commentId) {
        this.commentId = commentId;
    }

    public int getPostId() {
        return postId;
    }

    public void setPostId(int postId) {
        this.postId = postId;
    }

    public int getFeedProfileId() {
        return feedProfileId;
    }

    public void setFeedProfileId(int feedProfileId) {
        this.feedProfileId = feedProfileId;
    }

    public Integer getParentCommentId() {
        return parentCommentId;
    }

    public void setParentCommentId(Integer parentCommentId) {
        this.parentCommentId = parentCommentId;
    }

    public String getCommentText() {
        return commentText;
    }

    public void setCommentText(String commentText) {
        this.commentText = commentText;
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
    public FeedProfile getFeedProfile() {
        return feedProfile;
    }

    public void setFeedProfile(FeedProfile feedProfile) {
        this.feedProfile = feedProfile;
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
     * Get relative time string for display (e.g., "2h", "3d")
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
            return diffDays + "d";
        } else if (diffHours > 0) {
            return diffHours + "h";
        } else if (diffMinutes > 0) {
            return diffMinutes + "m";
        } else {
            return "Just now";
        }
    }

    @Override
    public String toString() {
        return "FeedComment{" +
                "commentId=" + commentId +
                ", postId=" + postId +
                ", feedProfileId=" + feedProfileId +
                ", parentCommentId=" + parentCommentId +
                ", commentText='" + commentText + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
