package com.demo.web.dto.Vault;

public class VaultEntryPostRequest { private int userId; private String password; public VaultEntryPostRequest(int userId, String password) { this.userId = userId; this.password = password; } public int getUserId() { return userId; } public String getPassword() { return password; } }
