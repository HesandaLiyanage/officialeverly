package com.demo.web.dto.Groups;

import com.demo.web.model.Groups.Group;

public class GroupEditResponse {
    private boolean success;
    private String errorMessage;
    private String redirectUrl;
    private Group group; // for re-rendering form on error

    public boolean isSuccess() { return success; }
    public void setSuccess(boolean success) { this.success = success; }
    public String getErrorMessage() { return errorMessage; }
    public void setErrorMessage(String errorMessage) { this.errorMessage = errorMessage; }
    public String getRedirectUrl() { return redirectUrl; }
    public void setRedirectUrl(String redirectUrl) { this.redirectUrl = redirectUrl; }
    public Group getGroup() { return group; }
    public void setGroup(Group group) { this.group = group; }

    public static GroupEditResponse success(String redirectUrl) {
        GroupEditResponse res = new GroupEditResponse();
        res.setSuccess(true);
        res.setRedirectUrl(redirectUrl);
        return res;
    }

    public static GroupEditResponse error(String message, String redirectUrl, Group group) {
        GroupEditResponse res = new GroupEditResponse();
        res.setSuccess(false);
        res.setErrorMessage(message);
        res.setRedirectUrl(redirectUrl);
        res.setGroup(group);
        return res;
    }
}
