package com.demo.web.util;

/**
 * Utility class specifically for Vault security rules and validations.
 */
public class VaultUtil {

    /**
     * Define the minimum length for a vault password.
     * Vault passwords can be treated with stricter constraints than normal login passwords if desired.
     */
    private static final int MIN_VAULT_PASSWORD_LENGTH = 8;

    /**
     * Validates if a vault password meets the minimum security criteria.
     *
     * @param password the unhashed password input
     * @return true if it meets criteria, false otherwise
     */
    public static boolean isValidVaultPassword(String password) {
        if (password == null) {
            return false;
        }
        return password.length() >= MIN_VAULT_PASSWORD_LENGTH;
    }

    /**
     * Get password requirements message specifically for Vaults.
     */
    public static String getVaultPasswordRequirementsMessage() {
        return "Vault password must be at least " + MIN_VAULT_PASSWORD_LENGTH + " characters long.";
    }
}
