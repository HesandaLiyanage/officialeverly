package com.demo.web.dto.Memory;

/**
 * Data Transfer Object for the response of creating a new memory.
 * Carries the result from the Service layer back to the Controller.
 */
public class MemoryCreateResponse {
    private boolean success;
    private int memoryId;
    private int filesUploaded;
    private boolean isCollaborative;
    private Integer groupId;
    
    // For error handling
    private String errorMessage;
    private int statusCode;

    public MemoryCreateResponse() {}

    public static MemoryCreateResponse success(int memoryId, int filesUploaded, boolean isCollaborative, Integer groupId) {
        MemoryCreateResponse response = new MemoryCreateResponse();
        response.setSuccess(true);
        response.setMemoryId(memoryId);
        response.setFilesUploaded(filesUploaded);
        response.setCollaborative(isCollaborative);
        response.setGroupId(groupId);
        response.setStatusCode(200);
        return response;
    }

    public static MemoryCreateResponse error(String errorMessage, int statusCode) {
        MemoryCreateResponse response = new MemoryCreateResponse();
        response.setSuccess(false);
        response.setErrorMessage(errorMessage);
        response.setStatusCode(statusCode);
        return response;
    }

    // Getters and Setters

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public int getMemoryId() {
        return memoryId;
    }

    public void setMemoryId(int memoryId) {
        this.memoryId = memoryId;
    }

    public int getFilesUploaded() {
        return filesUploaded;
    }

    public void setFilesUploaded(int filesUploaded) {
        this.filesUploaded = filesUploaded;
    }

    public boolean isCollaborative() {
        return isCollaborative;
    }

    public void setCollaborative(boolean collaborative) {
        isCollaborative = collaborative;
    }

    public Integer getGroupId() {
        return groupId;
    }

    public void setGroupId(Integer groupId) {
        this.groupId = groupId;
    }

    public String getErrorMessage() {
        return errorMessage;
    }

    public void setErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }

    public int getStatusCode() {
        return statusCode;
    }

    public void setStatusCode(int statusCode) {
        this.statusCode = statusCode;
    }
}
