package com.demo.web.dto.Feed;

import com.demo.web.model.Feed.FeedProfile;
import java.util.List;
import java.util.Map;

/**
 * DTO for the followers/following list page data.
 */
public class FeedFollowersViewDTO {
    private List<FeedProfile> userList;
    private String pageTitle;
    private String jspPage;
    private FeedProfile profileToView;
    private FeedProfile currentUserProfile;
    private boolean isOwnProfile;
    private String profileUsername;
    private int currentProfileId;

    // Getters and setters
    public List<FeedProfile> getUserList() { return userList; }
    public void setUserList(List<FeedProfile> userList) { this.userList = userList; }

    public String getPageTitle() { return pageTitle; }
    public void setPageTitle(String pageTitle) { this.pageTitle = pageTitle; }

    public String getJspPage() { return jspPage; }
    public void setJspPage(String jspPage) { this.jspPage = jspPage; }

    public FeedProfile getProfileToView() { return profileToView; }
    public void setProfileToView(FeedProfile profileToView) { this.profileToView = profileToView; }

    public FeedProfile getCurrentUserProfile() { return currentUserProfile; }
    public void setCurrentUserProfile(FeedProfile currentUserProfile) { this.currentUserProfile = currentUserProfile; }

    public boolean isOwnProfile() { return isOwnProfile; }
    public void setOwnProfile(boolean ownProfile) { isOwnProfile = ownProfile; }

    public String getProfileUsername() { return profileUsername; }
    public void setProfileUsername(String profileUsername) { this.profileUsername = profileUsername; }

    public int getCurrentProfileId() { return currentProfileId; }
    public void setCurrentProfileId(int currentProfileId) { this.currentProfileId = currentProfileId; }
}
