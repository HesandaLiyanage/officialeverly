package com.demo.web.dto.Feed;

import com.demo.web.model.Feed.FeedProfile;

/**
 * DTO for the profile edit page data.
 */
public class FeedProfileEditDTO {
    private FeedProfile feedProfile;
    private String feedUsername;
    private String feedBio;
    private String feedProfilePicture;
    private String feedInitials;
    private boolean hasDefaultPic;
    private int feedBioLength;

    // Getters and setters
    public FeedProfile getFeedProfile() { return feedProfile; }
    public void setFeedProfile(FeedProfile feedProfile) { this.feedProfile = feedProfile; }

    public String getFeedUsername() { return feedUsername; }
    public void setFeedUsername(String feedUsername) { this.feedUsername = feedUsername; }

    public String getFeedBio() { return feedBio; }
    public void setFeedBio(String feedBio) { this.feedBio = feedBio; }

    public String getFeedProfilePicture() { return feedProfilePicture; }
    public void setFeedProfilePicture(String feedProfilePicture) { this.feedProfilePicture = feedProfilePicture; }

    public String getFeedInitials() { return feedInitials; }
    public void setFeedInitials(String feedInitials) { this.feedInitials = feedInitials; }

    public boolean isHasDefaultPic() { return hasDefaultPic; }
    public void setHasDefaultPic(boolean hasDefaultPic) { this.hasDefaultPic = hasDefaultPic; }

    public int getFeedBioLength() { return feedBioLength; }
    public void setFeedBioLength(int feedBioLength) { this.feedBioLength = feedBioLength; }
}
