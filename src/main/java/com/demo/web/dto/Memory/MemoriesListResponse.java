package com.demo.web.dto.Memory;

import com.demo.web.model.Memory.Memory;
import java.util.List;
import java.util.Map;

public class MemoriesListResponse {
    private boolean success;
    private String errorMessage;
    private int statusCode;
    
    private List<Memory> memories;
    // Map of memory ID to its cover image path
    private Map<Integer, String> coverImages;
    
    // Subscription flags
    private boolean showStorageWarning;
    private boolean storageFull;

    public static MemoriesListResponse success(List<Memory> memories, Map<Integer, String> coverImages) {
        MemoriesListResponse response = new MemoriesListResponse();
        response.setSuccess(true);
        response.setMemories(memories);
        response.setCoverImages(coverImages);
        response.setStatusCode(200);
        return response;
    }

    public static MemoriesListResponse error(String errorMessage, int statusCode) {
        MemoriesListResponse response = new MemoriesListResponse();
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
    public List<Memory> getMemories() { return memories; }
    public void setMemories(List<Memory> memories) { this.memories = memories; }
    public Map<Integer, String> getCoverImages() { return coverImages; }
    public void setCoverImages(Map<Integer, String> coverImages) { this.coverImages = coverImages; }
    public boolean isShowStorageWarning() { return showStorageWarning; }
    public void setShowStorageWarning(boolean showStorageWarning) { this.showStorageWarning = showStorageWarning; }
    public boolean isStorageFull() { return storageFull; }
    public void setStorageFull(boolean storageFull) { this.storageFull = storageFull; }
}
