package com.demo.web.dto.Feed;

/**
 * Generic response DTO for Feed AJAX actions (like, follow, save, block, comment, report).
 * Provides a consistent JSON-serializable response structure.
 */
public class FeedActionResponse {
    private boolean success;
    private String message;
    private String error;

    // Optional extra fields for specific actions
    private Boolean isLiked;
    private Boolean isFollowing;
    private Boolean isSaved;
    private Integer likeCount;
    private Integer followerCount;
    private Integer followingCount;
    private String action;

    // Comment-specific fields
    private Integer commentId;
    private String commentText;
    private String username;
    private String initials;
    private String profilePictureUrl;
    private String relativeTime;
    private Integer feedProfileId;

    public FeedActionResponse(boolean success, String message) {
        this.success = success;
        this.message = message;
    }

    public static FeedActionResponse error(String error) {
        FeedActionResponse r = new FeedActionResponse(false, null);
        r.error = error;
        return r;
    }

    public static FeedActionResponse success(String message) {
        return new FeedActionResponse(true, message);
    }

    // Getters and setters
    public boolean isSuccess() { return success; }
    public void setSuccess(boolean success) { this.success = success; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public String getError() { return error; }
    public void setError(String error) { this.error = error; }

    public Boolean getIsLiked() { return isLiked; }
    public void setIsLiked(Boolean isLiked) { this.isLiked = isLiked; }

    public Boolean getIsFollowing() { return isFollowing; }
    public void setIsFollowing(Boolean isFollowing) { this.isFollowing = isFollowing; }

    public Boolean getIsSaved() { return isSaved; }
    public void setIsSaved(Boolean isSaved) { this.isSaved = isSaved; }

    public Integer getLikeCount() { return likeCount; }
    public void setLikeCount(Integer likeCount) { this.likeCount = likeCount; }

    public Integer getFollowerCount() { return followerCount; }
    public void setFollowerCount(Integer followerCount) { this.followerCount = followerCount; }

    public Integer getFollowingCount() { return followingCount; }
    public void setFollowingCount(Integer followingCount) { this.followingCount = followingCount; }

    public String getAction() { return action; }
    public void setAction(String action) { this.action = action; }

    public Integer getCommentId() { return commentId; }
    public void setCommentId(Integer commentId) { this.commentId = commentId; }

    public String getCommentText() { return commentText; }
    public void setCommentText(String commentText) { this.commentText = commentText; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getInitials() { return initials; }
    public void setInitials(String initials) { this.initials = initials; }

    public String getProfilePictureUrl() { return profilePictureUrl; }
    public void setProfilePictureUrl(String profilePictureUrl) { this.profilePictureUrl = profilePictureUrl; }

    public String getRelativeTime() { return relativeTime; }
    public void setRelativeTime(String relativeTime) { this.relativeTime = relativeTime; }

    public Integer getFeedProfileId() { return feedProfileId; }
    public void setFeedProfileId(Integer feedProfileId) { this.feedProfileId = feedProfileId; }
}
