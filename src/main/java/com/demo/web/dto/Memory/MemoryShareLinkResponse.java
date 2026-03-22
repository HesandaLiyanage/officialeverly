package com.demo.web.dto.Memory;

public class MemoryShareLinkResponse {
    private boolean success;
    private String errorMessage;
    private int statusCode;
    private String shareLink;

    public static MemoryShareLinkResponse success(String shareLink) {
        MemoryShareLinkResponse response = new MemoryShareLinkResponse();
        response.setSuccess(true);
        response.setShareLink(shareLink);
        response.setStatusCode(200);
        return response;
    }

    public static MemoryShareLinkResponse error(String errorMessage, int statusCode) {
        MemoryShareLinkResponse response = new MemoryShareLinkResponse();
        response.setSuccess(false);
        response.setErrorMessage(errorMessage);
        response.setStatusCode(statusCode);
        return response;
    }

    public boolean isSuccess() { return success; }
    public void setSuccess(boolean success) { this.success = success; }
    public String getErrorMessage() { return errorMessage; }
    public void setErrorMessage(String errorMessage) { this.errorMessage = errorMessage; }
    public int getStatusCode() { return statusCode; }
    public void setStatusCode(int statusCode) { this.statusCode = statusCode; }
    public String getShareLink() { return shareLink; }
    public void setShareLink(String shareLink) { this.shareLink = shareLink; }
}
