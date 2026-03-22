package com.demo.web.dto.Groups;

public class GroupMemberActionResponse {
    private String redirectUrl;

    public GroupMemberActionResponse(String redirectUrl) {
        this.redirectUrl = redirectUrl;
    }

    public String getRedirectUrl() { return redirectUrl; }
}
