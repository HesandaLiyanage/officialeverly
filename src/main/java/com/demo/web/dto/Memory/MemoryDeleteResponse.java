package com.demo.web.dto.Memory;

public class MemoryDeleteResponse {
    private boolean success;
    private String errorMessage;
    private int statusCode;
    
    private Integer groupId;

    public static MemoryDeleteResponse success(Integer groupId) {
        MemoryDeleteResponse response = new MemoryDeleteResponse();
        response.setSuccess(true);
        response.setGroupId(groupId);
        response.setStatusCode(200);
        return response;
    }

    public static MemoryDeleteResponse error(String errorMessage, int statusCode) {
        MemoryDeleteResponse response = new MemoryDeleteResponse();
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
    public Integer getGroupId() { return groupId; }
    public void setGroupId(Integer groupId) { this.groupId = groupId; }
}
