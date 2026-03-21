package com.demo.web.dto.Groups;

public class GroupCreateResponse {
    private boolean success;
    private String errorMessage;
    private String successMessage;

    public boolean isSuccess() { return success; }
    public void setSuccess(boolean success) { this.success = success; }
    public String getErrorMessage() { return errorMessage; }
    public void setErrorMessage(String errorMessage) { this.errorMessage = errorMessage; }
    public String getSuccessMessage() { return successMessage; }
    public void setSuccessMessage(String successMessage) { this.successMessage = successMessage; }

    public static GroupCreateResponse success(String message) {
        GroupCreateResponse response = new GroupCreateResponse();
        response.setSuccess(true);
        response.setSuccessMessage(message);
        return response;
    }

    public static GroupCreateResponse error(String message) {
        GroupCreateResponse response = new GroupCreateResponse();
        response.setSuccess(false);
        response.setErrorMessage(message);
        return response;
    }
}
