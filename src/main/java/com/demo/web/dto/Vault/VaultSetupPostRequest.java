package com.demo.web.dto.Vault;

public class VaultSetupPostRequest { private int userId; private String password; private String confirmPassword; public VaultSetupPostRequest(int userId, String password, String confirmPassword) { this.userId = userId; this.password = password; this.confirmPassword = confirmPassword; } public int getUserId() { return userId; } public String getPassword() { return password; } public String getConfirmPassword() { return confirmPassword; } }
