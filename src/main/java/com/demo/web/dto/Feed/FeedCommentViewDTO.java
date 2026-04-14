package com.demo.web.dto.Feed;

import com.demo.web.model.Feed.FeedComment;
import com.demo.web.model.Feed.FeedPost;
import com.demo.web.model.Feed.FeedProfile;
import com.demo.web.model.Memory.MediaItem;

import java.util.List;
import java.util.Map;

/**
 * DTO for the comment view page data.
 */
public class FeedCommentViewDTO {
    private FeedPost post;
    private List<FeedComment> comments;
    private int likeCount;
    private boolean isLikedByUser;
    private int commentCount;
    private FeedProfile currentProfile;
    private boolean isPostOwner;
    private List<MediaItem> mediaItems;

    // Derived presentation values
    private boolean hasOwnerPic;
    private String ownerPic;
    private String ownerGradient;
    private String postLikedClass;
    private String postFillColor;
    private String postStrokeColor;
    private String cpUrlSafe;
    private boolean hasMultipleMedia;
    private int mediaCount;
    private int currentProfileId;

    // Getters and setters
    public FeedPost getPost() { return post; }
    public void setPost(FeedPost post) { this.post = post; }

    public List<FeedComment> getComments() { return comments; }
    public void setComments(List<FeedComment> comments) { this.comments = comments; }

    public int getLikeCount() { return likeCount; }
    public void setLikeCount(int likeCount) { this.likeCount = likeCount; }

    public boolean isLikedByUser() { return isLikedByUser; }
    public void setLikedByUser(boolean likedByUser) { isLikedByUser = likedByUser; }

    public int getCommentCount() { return commentCount; }
    public void setCommentCount(int commentCount) { this.commentCount = commentCount; }

    public FeedProfile getCurrentProfile() { return currentProfile; }
    public void setCurrentProfile(FeedProfile currentProfile) { this.currentProfile = currentProfile; }

    public boolean isPostOwner() { return isPostOwner; }
    public void setPostOwner(boolean postOwner) { isPostOwner = postOwner; }

    public List<MediaItem> getMediaItems() { return mediaItems; }
    public void setMediaItems(List<MediaItem> mediaItems) { this.mediaItems = mediaItems; }

    public boolean isHasOwnerPic() { return hasOwnerPic; }
    public void setHasOwnerPic(boolean hasOwnerPic) { this.hasOwnerPic = hasOwnerPic; }

    public String getOwnerPic() { return ownerPic; }
    public void setOwnerPic(String ownerPic) { this.ownerPic = ownerPic; }

    public String getOwnerGradient() { return ownerGradient; }
    public void setOwnerGradient(String ownerGradient) { this.ownerGradient = ownerGradient; }

    public String getPostLikedClass() { return postLikedClass; }
    public void setPostLikedClass(String postLikedClass) { this.postLikedClass = postLikedClass; }

    public String getPostFillColor() { return postFillColor; }
    public void setPostFillColor(String postFillColor) { this.postFillColor = postFillColor; }

    public String getPostStrokeColor() { return postStrokeColor; }
    public void setPostStrokeColor(String postStrokeColor) { this.postStrokeColor = postStrokeColor; }

    public String getCpUrlSafe() { return cpUrlSafe; }
    public void setCpUrlSafe(String cpUrlSafe) { this.cpUrlSafe = cpUrlSafe; }

    public boolean isHasMultipleMedia() { return hasMultipleMedia; }
    public void setHasMultipleMedia(boolean hasMultipleMedia) { this.hasMultipleMedia = hasMultipleMedia; }

    public int getMediaCount() { return mediaCount; }
    public void setMediaCount(int mediaCount) { this.mediaCount = mediaCount; }

    public int getCurrentProfileId() { return currentProfileId; }
    public void setCurrentProfileId(int currentProfileId) { this.currentProfileId = currentProfileId; }
}
