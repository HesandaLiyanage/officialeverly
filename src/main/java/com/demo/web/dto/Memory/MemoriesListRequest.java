package com.demo.web.dto.Memory;

public class MemoriesListRequest {
    private int userId;
    private boolean includeCollaborative;
    private String searchQuery;

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public boolean isIncludeCollaborative() { return includeCollaborative; }
    public void setIncludeCollaborative(boolean includeCollaborative) { this.includeCollaborative = includeCollaborative; }
    public String getSearchQuery() { return searchQuery; }
    public void setSearchQuery(String searchQuery) { this.searchQuery = searchQuery; }
}
