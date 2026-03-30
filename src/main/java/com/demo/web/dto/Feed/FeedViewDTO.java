package com.demo.web.dto.Feed;

import com.demo.web.model.Feed.FeedPost;
import com.demo.web.model.Feed.FeedProfile;
import java.util.List;

public class FeedViewDTO {
    private FeedProfile feedProfile;
    private List<FeedPost> posts;
    private List<FeedProfile> recommendedUsers;
    private String feedUsername;
    private String feedProfilePic;
    private String feedInitials;
    private boolean hasDefaultPic;
    private int currentProfileId;

    public FeedViewDTO(FeedProfile feedProfile, List<FeedPost> posts, List<FeedProfile> recommendedUsers,
                       String feedUsername, String feedProfilePic, String feedInitials,
                       boolean hasDefaultPic, int currentProfileId) {
        this.feedProfile = feedProfile;
        this.posts = posts;
        this.recommendedUsers = recommendedUsers;
        this.feedUsername = feedUsername;
        this.feedProfilePic = feedProfilePic;
        this.feedInitials = feedInitials;
        this.hasDefaultPic = hasDefaultPic;
        this.currentProfileId = currentProfileId;
    }

    // Getters
    public FeedProfile getFeedProfile() { return feedProfile; }
    public List<FeedPost> getPosts() { return posts; }
    public List<FeedProfile> getRecommendedUsers() { return recommendedUsers; }
    public String getFeedUsername() { return feedUsername; }
    public String getFeedProfilePic() { return feedProfilePic; }
    public String getFeedInitials() { return feedInitials; }
    public boolean hasDefaultPic() { return hasDefaultPic; }
    public int getCurrentProfileId() { return currentProfileId; }
}
