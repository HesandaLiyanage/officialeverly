package com.demo.web.dto.Groups;

import com.demo.web.model.Groups.Group;

public class GroupsListEditResponse {
    private Group group;
    private String redirectUrl;
    private String errorMessage;

    public Group getGroup() { return group; }
    public void setGroup(Group group) { this.group = group; }
    public String getRedirectUrl() { return redirectUrl; }
    public void setRedirectUrl(String redirectUrl) { this.redirectUrl = redirectUrl; }
    public String getErrorMessage() { return errorMessage; }
    public void setErrorMessage(String errorMessage) { this.errorMessage = errorMessage; }
}
