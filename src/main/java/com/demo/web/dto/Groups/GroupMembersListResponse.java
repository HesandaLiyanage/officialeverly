package com.demo.web.dto.Groups;

import com.demo.web.model.Groups.Group;
import com.demo.web.model.Groups.GroupMember;
import java.util.List;
import java.util.Map;

public class GroupMembersListResponse {
    private String redirectUrl;
    
    private Group group;
    private List<GroupMember> members;
    private boolean isAdmin;
    private boolean isMember;
    private Integer currentUserId;
    private String currentUserRole;
    private String groupName;
    private Integer groupId;
    private List<Map<String, Object>> memberDisplayData;
    private List<Map<String, String>> editableRoleOptions;
    private String successMessage;
    private String errorMessage;

    public String getRedirectUrl() { return redirectUrl; }
    public void setRedirectUrl(String redirectUrl) { this.redirectUrl = redirectUrl; }

    public Group getGroup() { return group; }
    public void setGroup(Group group) { this.group = group; }
    public List<GroupMember> getMembers() { return members; }
    public void setMembers(List<GroupMember> members) { this.members = members; }
    public boolean isAdmin() { return isAdmin; }
    public void setAdmin(boolean isAdmin) { this.isAdmin = isAdmin; }
    public boolean isMember() { return isMember; }
    public void setMember(boolean isMember) { this.isMember = isMember; }
    public Integer getCurrentUserId() { return currentUserId; }
    public void setCurrentUserId(Integer currentUserId) { this.currentUserId = currentUserId; }
    public String getCurrentUserRole() { return currentUserRole; }
    public void setCurrentUserRole(String currentUserRole) { this.currentUserRole = currentUserRole; }
    public String getGroupName() { return groupName; }
    public void setGroupName(String groupName) { this.groupName = groupName; }
    public Integer getGroupId() { return groupId; }
    public void setGroupId(Integer groupId) { this.groupId = groupId; }
    public List<Map<String, Object>> getMemberDisplayData() { return memberDisplayData; }
    public void setMemberDisplayData(List<Map<String, Object>> memberDisplayData) { this.memberDisplayData = memberDisplayData; }
    public List<Map<String, String>> getEditableRoleOptions() { return editableRoleOptions; }
    public void setEditableRoleOptions(List<Map<String, String>> editableRoleOptions) { this.editableRoleOptions = editableRoleOptions; }
    public String getSuccessMessage() { return successMessage; }
    public void setSuccessMessage(String successMessage) { this.successMessage = successMessage; }
    public String getErrorMessage() { return errorMessage; }
    public void setErrorMessage(String errorMessage) { this.errorMessage = errorMessage; }
}
