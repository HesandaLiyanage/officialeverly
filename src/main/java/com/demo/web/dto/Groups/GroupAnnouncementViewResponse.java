package com.demo.web.dto.Groups;

import com.demo.web.model.Groups.GroupAnnouncement;
import java.util.List;
import java.util.Map;

public class GroupAnnouncementViewResponse {
    private boolean isSuccess;
    private String errorMessage;
    private String redirectUrl;
    
    private GroupAnnouncement announcement;
    private String authorInitial;
    private String authorName;
    private String postDate;
    private boolean hasEvent;
    private String eventPicUrl;
    private String formattedEventDate;
    private String linkedEventTitle;
    private Integer currentUserId;

    // Voting data
    private Integer pollEventId;
    private Integer pollGroupId;
    private Integer totalVotes;
    private Integer goingCount;
    private Integer notGoingCount;
    private Integer maybeCount;
    private Integer goingPercent;
    private Integer notGoingPercent;
    private Integer maybePercent;
    private String userCurrentVote;
    private List<Map<String, String>> voterDisplayData;
    private String totalVotesLabel;

    public boolean isSuccess() { return isSuccess; }
    public void setSuccess(boolean success) { isSuccess = success; }
    public String getErrorMessage() { return errorMessage; }
    public void setErrorMessage(String errorMessage) { this.errorMessage = errorMessage; }
    public String getRedirectUrl() { return redirectUrl; }
    public void setRedirectUrl(String redirectUrl) { this.redirectUrl = redirectUrl; }

    public GroupAnnouncement getAnnouncement() { return announcement; }
    public void setAnnouncement(GroupAnnouncement announcement) { this.announcement = announcement; }
    public String getAuthorInitial() { return authorInitial; }
    public void setAuthorInitial(String authorInitial) { this.authorInitial = authorInitial; }
    public String getAuthorName() { return authorName; }
    public void setAuthorName(String authorName) { this.authorName = authorName; }
    public String getPostDate() { return postDate; }
    public void setPostDate(String postDate) { this.postDate = postDate; }
    public boolean isHasEvent() { return hasEvent; }
    public void setHasEvent(boolean hasEvent) { this.hasEvent = hasEvent; }
    public String getEventPicUrl() { return eventPicUrl; }
    public void setEventPicUrl(String eventPicUrl) { this.eventPicUrl = eventPicUrl; }
    public String getFormattedEventDate() { return formattedEventDate; }
    public void setFormattedEventDate(String formattedEventDate) { this.formattedEventDate = formattedEventDate; }
    public String getLinkedEventTitle() { return linkedEventTitle; }
    public void setLinkedEventTitle(String linkedEventTitle) { this.linkedEventTitle = linkedEventTitle; }
    public Integer getCurrentUserId() { return currentUserId; }
    public void setCurrentUserId(Integer currentUserId) { this.currentUserId = currentUserId; }

    public Integer getPollEventId() { return pollEventId; }
    public void setPollEventId(Integer pollEventId) { this.pollEventId = pollEventId; }
    public Integer getPollGroupId() { return pollGroupId; }
    public void setPollGroupId(Integer pollGroupId) { this.pollGroupId = pollGroupId; }
    public Integer getTotalVotes() { return totalVotes; }
    public void setTotalVotes(Integer totalVotes) { this.totalVotes = totalVotes; }
    public Integer getGoingCount() { return goingCount; }
    public void setGoingCount(Integer goingCount) { this.goingCount = goingCount; }
    public Integer getNotGoingCount() { return notGoingCount; }
    public void setNotGoingCount(Integer notGoingCount) { this.notGoingCount = notGoingCount; }
    public Integer getMaybeCount() { return maybeCount; }
    public void setMaybeCount(Integer maybeCount) { this.maybeCount = maybeCount; }
    public Integer getGoingPercent() { return goingPercent; }
    public void setGoingPercent(Integer goingPercent) { this.goingPercent = goingPercent; }
    public Integer getNotGoingPercent() { return notGoingPercent; }
    public void setNotGoingPercent(Integer notGoingPercent) { this.notGoingPercent = notGoingPercent; }
    public Integer getMaybePercent() { return maybePercent; }
    public void setMaybePercent(Integer maybePercent) { this.maybePercent = maybePercent; }
    public String getUserCurrentVote() { return userCurrentVote; }
    public void setUserCurrentVote(String userCurrentVote) { this.userCurrentVote = userCurrentVote; }
    public List<Map<String, String>> getVoterDisplayData() { return voterDisplayData; }
    public void setVoterDisplayData(List<Map<String, String>> voterDisplayData) { this.voterDisplayData = voterDisplayData; }
    public String getTotalVotesLabel() { return totalVotesLabel; }
    public void setTotalVotesLabel(String totalVotesLabel) { this.totalVotesLabel = totalVotesLabel; }
}
