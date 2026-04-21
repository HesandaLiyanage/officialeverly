package com.demo.web.dto.Groups;

import com.demo.web.model.Groups.Group;
import com.demo.web.model.Groups.GroupMember;

public class GroupProfileViewResponse {
    private boolean success;
    private String errorMessage;
    private String redirectUrl;
    
    // View attributes
    private Group group;
    private GroupMember member;
    private boolean isAdmin;
    private int currentUserId;
    private int groupId;
    private String groupName;
    private String creatorText;
    private String memberName;
    private String memberEmail;
    private String memberRole;
    private String initials;
    private String joinedDate;
    private boolean canRemove;
    private int memberId;
    private boolean isRoleViewer;
    private boolean isRoleEditor;
    private boolean isRoleAdmin;

    public boolean isSuccess() { return success; }
    public void setSuccess(boolean success) { this.success = success; }
    public String getErrorMessage() { return errorMessage; }
    public void setErrorMessage(String errorMessage) { this.errorMessage = errorMessage; }
    public String getRedirectUrl() { return redirectUrl; }
    public void setRedirectUrl(String redirectUrl) { this.redirectUrl = redirectUrl; }

    public Group getGroup() { return group; }
    public void setGroup(Group group) { this.group = group; }
    public GroupMember getMember() { return member; }
    public void setMember(GroupMember member) { this.member = member; }
    public boolean isAdmin() { return isAdmin; }
    public void setAdmin(boolean admin) { isAdmin = admin; }
    public int getCurrentUserId() { return currentUserId; }
    public void setCurrentUserId(int currentUserId) { this.currentUserId = currentUserId; }
    public int getGroupId() { return groupId; }
    public void setGroupId(int groupId) { this.groupId = groupId; }
    public String getGroupName() { return groupName; }
    public void setGroupName(String groupName) { this.groupName = groupName; }
    public String getCreatorText() { return creatorText; }
    public void setCreatorText(String creatorText) { this.creatorText = creatorText; }
    public String getMemberName() { return memberName; }
    public void setMemberName(String memberName) { this.memberName = memberName; }
    public String getMemberEmail() { return memberEmail; }
    public void setMemberEmail(String memberEmail) { this.memberEmail = memberEmail; }
    public String getMemberRole() { return memberRole; }
    public void setMemberRole(String memberRole) { this.memberRole = memberRole; }
    public String getInitials() { return initials; }
    public void setInitials(String initials) { this.initials = initials; }
    public String getJoinedDate() { return joinedDate; }
    public void setJoinedDate(String joinedDate) { this.joinedDate = joinedDate; }
    public boolean isCanRemove() { return canRemove; }
    public void setCanRemove(boolean canRemove) { this.canRemove = canRemove; }
    public int getMemberId() { return memberId; }
    public void setMemberId(int memberId) { this.memberId = memberId; }
    public boolean isRoleViewer() { return isRoleViewer; }
    public void setRoleViewer(boolean roleViewer) { isRoleViewer = roleViewer; }
    public boolean isRoleEditor() { return isRoleEditor; }
    public void setRoleEditor(boolean roleEditor) { isRoleEditor = roleEditor; }
    public boolean isRoleAdmin() { return isRoleAdmin; }
    public void setRoleAdmin(boolean roleAdmin) { isRoleAdmin = roleAdmin; }

    public static GroupProfileViewResponse error(String redirectUrl) {
        GroupProfileViewResponse res = new GroupProfileViewResponse();
        res.setSuccess(false);
        res.setRedirectUrl(redirectUrl);
        return res;
    }
}
