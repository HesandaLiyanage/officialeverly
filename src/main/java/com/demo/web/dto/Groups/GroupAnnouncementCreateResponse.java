package com.demo.web.dto.Groups;

public class GroupAnnouncementCreateResponse {
    private boolean isSuccess;
    private String errorMessage;
    private int groupId;
    private String redirectUrl;

    public GroupAnnouncementCreateResponse(boolean isSuccess, String errorMessage, int groupId, String redirectUrl) {
        this.isSuccess = isSuccess;
        this.errorMessage = errorMessage;
        this.groupId = groupId;
        this.redirectUrl = redirectUrl;
    }

    public boolean isSuccess() { return isSuccess; }
    public String getErrorMessage() { return errorMessage; }
    public int getGroupId() { return groupId; }
    public String getRedirectUrl() { return redirectUrl; }
}
