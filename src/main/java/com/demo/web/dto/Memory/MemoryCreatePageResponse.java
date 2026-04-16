package com.demo.web.dto.Memory;

public class MemoryCreatePageResponse {
    private boolean allowed;
    private boolean limitReached;
    private String errorMessage;

    public static MemoryCreatePageResponse allowed() {
        MemoryCreatePageResponse response = new MemoryCreatePageResponse();
        response.setAllowed(true);
        return response;
    }

    public static MemoryCreatePageResponse limitReached(String errorMessage) {
        MemoryCreatePageResponse response = new MemoryCreatePageResponse();
        response.setAllowed(false);
        response.setLimitReached(true);
        response.setErrorMessage(errorMessage);
        return response;
    }

    public static MemoryCreatePageResponse error(String errorMessage) {
        MemoryCreatePageResponse response = new MemoryCreatePageResponse();
        response.setAllowed(false);
        response.setErrorMessage(errorMessage);
        return response;
    }

    public boolean isAllowed() {
        return allowed;
    }

    public void setAllowed(boolean allowed) {
        this.allowed = allowed;
    }

    public boolean isLimitReached() {
        return limitReached;
    }

    public void setLimitReached(boolean limitReached) {
        this.limitReached = limitReached;
    }

    public String getErrorMessage() {
        return errorMessage;
    }

    public void setErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }
}
