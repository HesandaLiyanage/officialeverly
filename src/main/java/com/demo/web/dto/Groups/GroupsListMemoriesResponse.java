package com.demo.web.dto.Groups;

import com.demo.web.model.Groups.Group;
import com.demo.web.model.Memory.Memory;
import java.util.List;
import java.util.Map;

public class GroupsListMemoriesResponse {
    private Group group;
    private int groupId;
    private String groupName;
    private List<Memory> memories;
    private Map<Integer, String> coverImageUrls;
    private boolean isAdmin;
    private boolean isMember;
    private String currentUserRole;
    private int currentUserId;
    private boolean canCreate;
    private String redirectUrl;
    private String errorMessage;

    public Group getGroup() { return group; }
    public void setGroup(Group group) { this.group = group; }
    public int getGroupId() { return groupId; }
    public void setGroupId(int groupId) { this.groupId = groupId; }
    public String getGroupName() { return groupName; }
    public void setGroupName(String groupName) { this.groupName = groupName; }
    public List<Memory> getMemories() { return memories; }
    public void setMemories(List<Memory> memories) { this.memories = memories; }
    public Map<Integer, String> getCoverImageUrls() { return coverImageUrls; }
    public void setCoverImageUrls(Map<Integer, String> coverImageUrls) { this.coverImageUrls = coverImageUrls; }
    public boolean isAdmin() { return isAdmin; }
    public void setAdmin(boolean admin) { isAdmin = admin; }
    public boolean isMember() { return isMember; }
    public void setMember(boolean member) { isMember = member; }
    public String getCurrentUserRole() { return currentUserRole; }
    public void setCurrentUserRole(String currentUserRole) { this.currentUserRole = currentUserRole; }
    public int getCurrentUserId() { return currentUserId; }
    public void setCurrentUserId(int currentUserId) { this.currentUserId = currentUserId; }
    public boolean isCanCreate() { return canCreate; }
    public void setCanCreate(boolean canCreate) { this.canCreate = canCreate; }
    public String getRedirectUrl() { return redirectUrl; }
    public void setRedirectUrl(String redirectUrl) { this.redirectUrl = redirectUrl; }
    public String getErrorMessage() { return errorMessage; }
    public void setErrorMessage(String errorMessage) { this.errorMessage = errorMessage; }
}
