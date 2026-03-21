package com.demo.web.dto.Memory;

import com.demo.web.model.Memory.Memory;
import java.util.List;
import java.util.Map;

public class CollabMemoriesListResponse {
    private List<Memory> memories;
    private Map<Integer, String> coverImageUrls;
    private Map<Integer, Integer> memberCounts;
    private Map<Integer, Boolean> isOwnerMap;

    public List<Memory> getMemories() { return memories; }
    public void setMemories(List<Memory> memories) { this.memories = memories; }
    public Map<Integer, String> getCoverImageUrls() { return coverImageUrls; }
    public void setCoverImageUrls(Map<Integer, String> coverImageUrls) { this.coverImageUrls = coverImageUrls; }
    public Map<Integer, Integer> getMemberCounts() { return memberCounts; }
    public void setMemberCounts(Map<Integer, Integer> memberCounts) { this.memberCounts = memberCounts; }
    public Map<Integer, Boolean> getIsOwnerMap() { return isOwnerMap; }
    public void setIsOwnerMap(Map<Integer, Boolean> isOwnerMap) { this.isOwnerMap = isOwnerMap; }
}
