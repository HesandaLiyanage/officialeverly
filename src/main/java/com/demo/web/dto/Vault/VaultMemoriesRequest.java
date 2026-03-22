package com.demo.web.dto.Vault;

public class VaultMemoriesRequest { private int userId; private String vaultPassword; private Boolean vaultUnlockedSession; public VaultMemoriesRequest(int userId, String vaultPassword, Boolean vaultUnlockedSession) { this.userId = userId; this.vaultPassword = vaultPassword; this.vaultUnlockedSession = vaultUnlockedSession; } public int getUserId() { return userId; } public String getVaultPassword() { return vaultPassword; } public Boolean getVaultUnlockedSession() { return vaultUnlockedSession; } }
