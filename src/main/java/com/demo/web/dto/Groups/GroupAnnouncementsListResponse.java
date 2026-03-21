package com.demo.web.dto.Groups;

import com.demo.web.model.Groups.Group;
import com.demo.web.model.Groups.GroupAnnouncement;
import java.util.List;
import java.util.Map;

public class GroupAnnouncementsListResponse {
    private boolean isSuccess;
    private String errorMessage;
    private String redirectUrl;
    
    private Group group;
    private int groupId;
    private String groupName;
    private String groupDescription;
    private List<GroupAnnouncement> announcements;
    private List<Map<String, String>> announcementDisplayData;

    public boolean isSuccess() { return isSuccess; }
    public void setSuccess(boolean success) { isSuccess = success; }
    public String getErrorMessage() { return errorMessage; }
    public void setErrorMessage(String errorMessage) { this.errorMessage = errorMessage; }
    public String getRedirectUrl() { return redirectUrl; }
    public void setRedirectUrl(String redirectUrl) { this.redirectUrl = redirectUrl; }

    public Group getGroup() { return group; }
    public void setGroup(Group group) { this.group = group; }
    public int getGroupId() { return groupId; }
    public void setGroupId(int groupId) { this.groupId = groupId; }
    public String getGroupName() { return groupName; }
    public void setGroupName(String groupName) { this.groupName = groupName; }
    public String getGroupDescription() { return groupDescription; }
    public void setGroupDescription(String groupDescription) { this.groupDescription = groupDescription; }
    public List<GroupAnnouncement> getAnnouncements() { return announcements; }
    public void setAnnouncements(List<GroupAnnouncement> announcements) { this.announcements = announcements; }
    public List<Map<String, String>> getAnnouncementDisplayData() { return announcementDisplayData; }
    public void setAnnouncementDisplayData(List<Map<String, String>> announcementDisplayData) { this.announcementDisplayData = announcementDisplayData; }
}
