package com.demo.web.dto.Groups;

import com.demo.web.model.Groups.Group;
import java.util.List;
import java.util.Map;

public class GroupsListResponse {
    private List<Group> groups;
    private List<Map<String, Object>> groupDisplayData;
    private List<Map<String, Object>> announcementDisplayData;
    private String errorMessage;

    public List<Group> getGroups() { return groups; }
    public void setGroups(List<Group> groups) { this.groups = groups; }
    public List<Map<String, Object>> getGroupDisplayData() { return groupDisplayData; }
    public void setGroupDisplayData(List<Map<String, Object>> groupDisplayData) { this.groupDisplayData = groupDisplayData; }
    public List<Map<String, Object>> getAnnouncementDisplayData() { return announcementDisplayData; }
    public void setAnnouncementDisplayData(List<Map<String, Object>> announcementDisplayData) { this.announcementDisplayData = announcementDisplayData; }
    public String getErrorMessage() { return errorMessage; }
    public void setErrorMessage(String errorMessage) { this.errorMessage = errorMessage; }
}
