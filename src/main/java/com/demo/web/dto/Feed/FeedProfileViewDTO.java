package com.demo.web.dto.Feed;

import com.demo.web.model.Feed.FeedPost;
import com.demo.web.model.Feed.FeedProfile;

import java.util.List;
import java.util.Map;

/**
 * DTO for the profile view page data.
 */
public class FeedProfileViewDTO {
    private FeedProfile profileToView;
    private boolean isOwnProfile;
    private boolean isFollowing;
    private boolean isBlocked;
    private int followerCount;
    private int followingCount;
    private int postCount;
    private List<FeedPost> userPosts;
    private List<FeedPost> savedPosts;
    private List<FeedProfile> recommendedUsers;
    private FeedProfile currentUserProfile;

    // Pre-computed display values
    private String profileUsername;
    private String profilePic;
    private String profileBio;
    private String profileInitials;
    private int profileId;
    private boolean hasProfilePic;

    // Getters and setters
    public FeedProfile getProfileToView() { return profileToView; }
    public void setProfileToView(FeedProfile profileToView) { this.profileToView = profileToView; }

    public boolean isOwnProfile() { return isOwnProfile; }
    public void setOwnProfile(boolean ownProfile) { isOwnProfile = ownProfile; }

    public boolean isFollowing() { return isFollowing; }
    public void setFollowing(boolean following) { isFollowing = following; }

    public boolean isBlocked() { return isBlocked; }
    public void setBlocked(boolean blocked) { isBlocked = blocked; }

    public int getFollowerCount() { return followerCount; }
    public void setFollowerCount(int followerCount) { this.followerCount = followerCount; }

    public int getFollowingCount() { return followingCount; }
    public void setFollowingCount(int followingCount) { this.followingCount = followingCount; }

    public int getPostCount() { return postCount; }
    public void setPostCount(int postCount) { this.postCount = postCount; }

    public List<FeedPost> getUserPosts() { return userPosts; }
    public void setUserPosts(List<FeedPost> userPosts) { this.userPosts = userPosts; }

    public List<FeedPost> getSavedPosts() { return savedPosts; }
    public void setSavedPosts(List<FeedPost> savedPosts) { this.savedPosts = savedPosts; }

    public List<FeedProfile> getRecommendedUsers() { return recommendedUsers; }
    public void setRecommendedUsers(List<FeedProfile> recommendedUsers) { this.recommendedUsers = recommendedUsers; }

    public FeedProfile getCurrentUserProfile() { return currentUserProfile; }
    public void setCurrentUserProfile(FeedProfile currentUserProfile) { this.currentUserProfile = currentUserProfile; }

    public String getProfileUsername() { return profileUsername; }
    public void setProfileUsername(String profileUsername) { this.profileUsername = profileUsername; }

    public String getProfilePic() { return profilePic; }
    public void setProfilePic(String profilePic) { this.profilePic = profilePic; }

    public String getProfileBio() { return profileBio; }
    public void setProfileBio(String profileBio) { this.profileBio = profileBio; }

    public String getProfileInitials() { return profileInitials; }
    public void setProfileInitials(String profileInitials) { this.profileInitials = profileInitials; }

    public int getProfileId() { return profileId; }
    public void setProfileId(int profileId) { this.profileId = profileId; }

    public boolean isHasProfilePic() { return hasProfilePic; }
    public void setHasProfilePic(boolean hasProfilePic) { this.hasProfilePic = hasProfilePic; }
}
