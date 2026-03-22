package com.demo.web.dto.Memory;

public class MemoryUpdateResponse {
    private boolean success;
    private String errorMessage;
    private int statusCode;

    public static MemoryUpdateResponse success() {
        MemoryUpdateResponse response = new MemoryUpdateResponse();
        response.setSuccess(true);
        response.setStatusCode(200);
        return response;
    }

    public static MemoryUpdateResponse error(String errorMessage, int statusCode) {
        MemoryUpdateResponse response = new MemoryUpdateResponse();
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
}
