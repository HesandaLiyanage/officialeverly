package com.demo.web.dto.Groups;

public class GroupDeleteResponse {
    private boolean success;
    private String redirectUrl;

    public boolean isSuccess() { return success; }
    public void setSuccess(boolean success) { this.success = success; }
    public String getRedirectUrl() { return redirectUrl; }
    public void setRedirectUrl(String redirectUrl) { this.redirectUrl = redirectUrl; }
    
    public static GroupDeleteResponse redirect(String url) {
        GroupDeleteResponse res = new GroupDeleteResponse();
        res.setSuccess(true);
        res.setRedirectUrl(url);
        return res;
    }
}
