package com.demo.web.dto.Settings;

import com.demo.web.model.Settings.Plan;
import java.util.List;
import java.util.Map;

public class SettingsStorageSenseResponse {
    private Plan plan;
    private long usedStorageBytes;
    private long storageLimitBytes;
    private int usedPercent;
    private String usedFormatted;
    private String totalFormatted;
    private String progressBarColor;
    private List<Map<String, Object>> contentTypeDisplay;
    private List<Map<String, Object>> topMemoryDisplay;
    private List<Map<String, Object>> topGroupDisplay;
    private int duplicateCount;
    private long duplicateSize;
    private String duplicateSizeFormatted;
    private int trashCount;
    private int memoryCount;
    private int journalCount;
    private int autographCount;
    private int otherContentCount;
    private String redirectUrl;

    public Plan getPlan() {
        return plan;
    }

    public void setPlan(Plan plan) {
        this.plan = plan;
    }

    public long getUsedStorageBytes() {
        return usedStorageBytes;
    }

    public void setUsedStorageBytes(long usedStorageBytes) {
        this.usedStorageBytes = usedStorageBytes;
    }

    public long getStorageLimitBytes() {
        return storageLimitBytes;
    }

    public void setStorageLimitBytes(long storageLimitBytes) {
        this.storageLimitBytes = storageLimitBytes;
    }

    public int getUsedPercent() {
        return usedPercent;
    }

    public void setUsedPercent(int usedPercent) {
        this.usedPercent = usedPercent;
    }

    public String getUsedFormatted() {
        return usedFormatted;
    }

    public void setUsedFormatted(String usedFormatted) {
        this.usedFormatted = usedFormatted;
    }

    public String getTotalFormatted() {
        return totalFormatted;
    }

    public void setTotalFormatted(String totalFormatted) {
        this.totalFormatted = totalFormatted;
    }

    public String getProgressBarColor() {
        return progressBarColor;
    }

    public void setProgressBarColor(String progressBarColor) {
        this.progressBarColor = progressBarColor;
    }

    public List<Map<String, Object>> getContentTypeDisplay() {
        return contentTypeDisplay;
    }

    public void setContentTypeDisplay(List<Map<String, Object>> contentTypeDisplay) {
        this.contentTypeDisplay = contentTypeDisplay;
    }

    public List<Map<String, Object>> getTopMemoryDisplay() {
        return topMemoryDisplay;
    }

    public void setTopMemoryDisplay(List<Map<String, Object>> topMemoryDisplay) {
        this.topMemoryDisplay = topMemoryDisplay;
    }

    public List<Map<String, Object>> getTopGroupDisplay() {
        return topGroupDisplay;
    }

    public void setTopGroupDisplay(List<Map<String, Object>> topGroupDisplay) {
        this.topGroupDisplay = topGroupDisplay;
    }

    public int getDuplicateCount() {
        return duplicateCount;
    }

    public void setDuplicateCount(int duplicateCount) {
        this.duplicateCount = duplicateCount;
    }

    public long getDuplicateSize() {
        return duplicateSize;
    }

    public void setDuplicateSize(long duplicateSize) {
        this.duplicateSize = duplicateSize;
    }

    public String getDuplicateSizeFormatted() {
        return duplicateSizeFormatted;
    }

    public void setDuplicateSizeFormatted(String duplicateSizeFormatted) {
        this.duplicateSizeFormatted = duplicateSizeFormatted;
    }

    public int getTrashCount() {
        return trashCount;
    }

    public void setTrashCount(int trashCount) {
        this.trashCount = trashCount;
    }

    public int getMemoryCount() {
        return memoryCount;
    }

    public void setMemoryCount(int memoryCount) {
        this.memoryCount = memoryCount;
    }

    public int getJournalCount() {
        return journalCount;
    }

    public void setJournalCount(int journalCount) {
        this.journalCount = journalCount;
    }

    public int getAutographCount() {
        return autographCount;
    }

    public void setAutographCount(int autographCount) {
        this.autographCount = autographCount;
    }

    public int getOtherContentCount() {
        return otherContentCount;
    }

    public void setOtherContentCount(int otherContentCount) {
        this.otherContentCount = otherContentCount;
    }

    public String getRedirectUrl() {
        return redirectUrl;
    }

    public void setRedirectUrl(String redirectUrl) {
        this.redirectUrl = redirectUrl;
    }
}
