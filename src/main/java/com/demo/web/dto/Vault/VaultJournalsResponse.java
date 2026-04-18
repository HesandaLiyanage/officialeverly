package com.demo.web.dto.Vault;

import com.demo.web.model.Journals.Journal;

import java.util.List;

public class VaultJournalsResponse {
    private boolean hasSetup;
    private boolean accessGranted;
    private List<Journal> journals;
    private String errorMessage;
    private int storagePercentage;
    private String storageUsedFormatted;
    private String storageTotalFormatted;

    public boolean isHasSetup() { return hasSetup; }
    public void setHasSetup(boolean hasSetup) { this.hasSetup = hasSetup; }

    public boolean isAccessGranted() { return accessGranted; }
    public void setAccessGranted(boolean accessGranted) { this.accessGranted = accessGranted; }

    public List<Journal> getJournals() { return journals; }
    public void setJournals(List<Journal> journals) { this.journals = journals; }

    public int getJournalsCount() { return journals != null ? journals.size() : 0; }

    public String getErrorMessage() { return errorMessage; }
    public void setErrorMessage(String errorMessage) { this.errorMessage = errorMessage; }

    public int getStoragePercentage() { return storagePercentage; }
    public void setStoragePercentage(int storagePercentage) { this.storagePercentage = storagePercentage; }

    public String getStorageUsedFormatted() { return storageUsedFormatted; }
    public void setStorageUsedFormatted(String storageUsedFormatted) { this.storageUsedFormatted = storageUsedFormatted; }

    public String getStorageTotalFormatted() { return storageTotalFormatted; }
    public void setStorageTotalFormatted(String storageTotalFormatted) { this.storageTotalFormatted = storageTotalFormatted; }
}
