package com.demo.web.dto.Groups;

public class GroupMemberRemoveResponse {
    private String redirectUrl;

    public GroupMemberRemoveResponse(String redirectUrl) {
        this.redirectUrl = redirectUrl;
    }

    public String getRedirectUrl() { return redirectUrl; }
}
