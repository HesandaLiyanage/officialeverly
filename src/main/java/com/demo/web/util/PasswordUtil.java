package com.demo.web.util;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import java.util.Base64;

public class PasswordUtil {

    private static final String LEGACY_HASH_ALGORITHM = "SHA-256";
    private static final String PBKDF2_ALGORITHM = "PBKDF2WithHmacSHA256";
    private static final String PBKDF2_PREFIX = "pbkdf2_sha256";
    private static final int SALT_LENGTH = 16;
    private static final int PBKDF2_ITERATIONS = 210000;
    private static final int PBKDF2_KEY_LENGTH = 256;
    private static final SecureRandom SECURE_RANDOM = new SecureRandom();

    public static String generateSalt() {
        byte[] salt = new byte[SALT_LENGTH];
        SECURE_RANDOM.nextBytes(salt);
        return Base64.getEncoder().encodeToString(salt);
    }

    public static String hashPassword(String password, String salt) {
        try {
            byte[] saltBytes = Base64.getDecoder().decode(salt);
            byte[] hashedBytes = pbkdf2(password.toCharArray(), saltBytes, PBKDF2_ITERATIONS);
            return PBKDF2_PREFIX + "$" + PBKDF2_ITERATIONS + "$" +
                    Base64.getEncoder().encodeToString(hashedBytes);
        } catch (IllegalArgumentException | NoSuchAlgorithmException | InvalidKeySpecException e) {
            throw new RuntimeException("Hashing algorithm not available", e);
        }
    }

    public static boolean verifyPassword(String password, String salt, String storedHash) {
        if (password == null || salt == null || storedHash == null || storedHash.isBlank()) {
            return false;
        }

        try {
            if (storedHash.startsWith(PBKDF2_PREFIX + "$")) {
                String[] parts = storedHash.split("\\$");
                if (parts.length != 3) {
                    return false;
                }

                int iterations = Integer.parseInt(parts[1]);
                byte[] saltBytes = Base64.getDecoder().decode(salt);
                byte[] expectedHash = Base64.getDecoder().decode(parts[2]);
                byte[] candidateHash = pbkdf2(password.toCharArray(), saltBytes, iterations);
                return MessageDigest.isEqual(candidateHash, expectedHash);
            }

            byte[] legacyExpected = Base64.getDecoder().decode(storedHash);
            byte[] legacyCandidate = legacyHash(password, salt);
            return MessageDigest.isEqual(legacyCandidate, legacyExpected);
        } catch (IllegalArgumentException | NoSuchAlgorithmException | InvalidKeySpecException e) {
            return false;
        }
    }

    public static boolean needsRehash(String storedHash) {
        return storedHash == null || !storedHash.startsWith(PBKDF2_PREFIX + "$");
    }

    public static boolean isPasswordStrong(String password) {
        if (password == null || password.length() < 8) {
            return false;
        }

        boolean hasUpper = false;
        boolean hasLower = false;
        boolean hasDigit = false;
        boolean hasSpecial = false;

        for (char c : password.toCharArray()) {
            if (Character.isUpperCase(c)) {
                hasUpper = true;
            } else if (Character.isLowerCase(c)) {
                hasLower = true;
            } else if (Character.isDigit(c)) {
                hasDigit = true;
            } else if (!Character.isLetterOrDigit(c)) {
                hasSpecial = true;
            }
        }

        return hasUpper && hasLower && hasDigit && hasSpecial;
    }

    public static String getPasswordRequirements() {
        return "Password must be at least 8 characters long and contain at least one uppercase letter, " +
                "one lowercase letter, one digit, and one special character.";
    }

    private static byte[] pbkdf2(char[] password, byte[] salt, int iterations)
            throws NoSuchAlgorithmException, InvalidKeySpecException {
        PBEKeySpec spec = new PBEKeySpec(password, salt, iterations, PBKDF2_KEY_LENGTH);
        SecretKeyFactory factory = SecretKeyFactory.getInstance(PBKDF2_ALGORITHM);
        return factory.generateSecret(spec).getEncoded();
    }

    private static byte[] legacyHash(String password, String salt) throws NoSuchAlgorithmException {
        MessageDigest md = MessageDigest.getInstance(LEGACY_HASH_ALGORITHM);
        String saltedPassword = password + salt;
        return md.digest(saltedPassword.getBytes(StandardCharsets.UTF_8));
    }
}
