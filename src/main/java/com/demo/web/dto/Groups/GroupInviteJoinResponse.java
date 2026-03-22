package com.demo.web.dto.Groups;

public class GroupInviteJoinResponse {
    private boolean isSuccess;
    private String redirectUrl;
    private String pendingInviteToken;

    public GroupInviteJoinResponse(boolean isSuccess, String redirectUrl, String pendingInviteToken) {
        this.isSuccess = isSuccess;
        this.redirectUrl = redirectUrl;
        this.pendingInviteToken = pendingInviteToken;
    }

    public boolean isSuccess() { return isSuccess; }
    public String getRedirectUrl() { return redirectUrl; }
    public String getPendingInviteToken() { return pendingInviteToken; }
}
