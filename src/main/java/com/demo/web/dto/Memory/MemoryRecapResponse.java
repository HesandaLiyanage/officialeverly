package com.demo.web.dto.Memory;

import java.util.List;
import java.util.Map;

public class MemoryRecapResponse {
    private List<Map<String, Object>> allRecaps;
    private List<Map<String, Object>> timeRecaps;
    private List<Map<String, Object>> eventRecaps;
    private List<Map<String, Object>> groupRecaps;
    private int totalMemories;
    private int totalEvents;
    private int totalGroups;
    private String recapDataJson;

    public List<Map<String, Object>> getAllRecaps() { return allRecaps; }
    public void setAllRecaps(List<Map<String, Object>> allRecaps) { this.allRecaps = allRecaps; }
    public List<Map<String, Object>> getTimeRecaps() { return timeRecaps; }
    public void setTimeRecaps(List<Map<String, Object>> timeRecaps) { this.timeRecaps = timeRecaps; }
    public List<Map<String, Object>> getEventRecaps() { return eventRecaps; }
    public void setEventRecaps(List<Map<String, Object>> eventRecaps) { this.eventRecaps = eventRecaps; }
    public List<Map<String, Object>> getGroupRecaps() { return groupRecaps; }
    public void setGroupRecaps(List<Map<String, Object>> groupRecaps) { this.groupRecaps = groupRecaps; }
    public int getTotalMemories() { return totalMemories; }
    public void setTotalMemories(int totalMemories) { this.totalMemories = totalMemories; }
    public int getTotalEvents() { return totalEvents; }
    public void setTotalEvents(int totalEvents) { this.totalEvents = totalEvents; }
    public int getTotalGroups() { return totalGroups; }
    public void setTotalGroups(int totalGroups) { this.totalGroups = totalGroups; }
    public String getRecapDataJson() { return recapDataJson; }
    public void setRecapDataJson(String recapDataJson) { this.recapDataJson = recapDataJson; }
}
