package com.demo.web.dto.Memory;

public class CollabActionResponse {
    private boolean success;
    private String errorMessage;
    private int statusCode;
    private Integer targetMemoryId;

    public static CollabActionResponse success() {
        CollabActionResponse response = new CollabActionResponse();
        response.setSuccess(true);
        response.setStatusCode(200);
        return response;
    }

    public static CollabActionResponse successWithData(Integer memoryId) {
        CollabActionResponse response = new CollabActionResponse();
        response.setSuccess(true);
        response.setStatusCode(200);
        response.setTargetMemoryId(memoryId);
        return response;
    }

    public static CollabActionResponse error(String errorMessage, int statusCode) {
        CollabActionResponse response = new CollabActionResponse();
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
    public Integer getTargetMemoryId() { return targetMemoryId; }
    public void setTargetMemoryId(Integer targetMemoryId) { this.targetMemoryId = targetMemoryId; }
}
