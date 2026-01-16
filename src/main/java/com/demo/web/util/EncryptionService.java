package com.demo.web.util;

import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.spec.PBEKeySpec;
import javax.crypto.spec.SecretKeySpec;
import java.security.SecureRandom;
import java.security.spec.KeySpec;
import java.util.Base64;
import java.util.UUID;

/**
 * Complete Encryption Service for Album App
 * Handles personal and collaborative album encryption
 */
public class EncryptionService {
    private static final String ALGORITHM = "AES";
    private static final String TRANSFORMATION = "AES/GCM/NoPadding";
    private static final int GCM_IV_LENGTH = 12;
    private static final int GCM_TAG_LENGTH = 16;
    private static final int KEY_SIZE = 256;

    // PBKDF2 configuration for password-based key derivation
    private static final String PBKDF2_ALGORITHM = "PBKDF2WithHmacSHA256";
    private static final int PBKDF2_ITERATIONS = 100000;
    private static final int SALT_LENGTH = 32;

    // ============================================
    // BASIC KEY OPERATIONS
    // ============================================

    public static SecretKey generateKey() throws Exception {
        KeyGenerator keyGenerator = KeyGenerator.getInstance(ALGORITHM);
        keyGenerator.init(KEY_SIZE);
        return keyGenerator.generateKey();
    }

    public static String generateKeyId() {
        return UUID.randomUUID().toString();
    }

    public static byte[] generateSalt() {
        byte[] salt = new byte[SALT_LENGTH];
        new SecureRandom().nextBytes(salt);
        return salt;
    }

    // ============================================
    // PASSWORD-BASED KEY DERIVATION
    // ============================================

    public static SecretKey deriveKeyFromPassword(String password, byte[] salt) throws Exception {
        SecretKeyFactory factory = SecretKeyFactory.getInstance(PBKDF2_ALGORITHM);
        KeySpec spec = new PBEKeySpec(password.toCharArray(), salt, PBKDF2_ITERATIONS, KEY_SIZE);
        SecretKey tmp = factory.generateSecret(spec);
        return new SecretKeySpec(tmp.getEncoded(), ALGORITHM);
    }

    // ============================================
    // BASIC ENCRYPTION/DECRYPTION
    // ============================================

    public static EncryptedData encrypt(byte[] data, SecretKey key) throws Exception {
        Cipher cipher = Cipher.getInstance(TRANSFORMATION);

        byte[] iv = new byte[GCM_IV_LENGTH];
        new SecureRandom().nextBytes(iv);

        GCMParameterSpec spec = new GCMParameterSpec(GCM_TAG_LENGTH * 8, iv);
        cipher.init(Cipher.ENCRYPT_MODE, key, spec);

        byte[] encryptedData = cipher.doFinal(data);

        return new EncryptedData(encryptedData, iv);
    }

    public static byte[] decrypt(EncryptedData encryptedData, SecretKey key) throws Exception {
        Cipher cipher = Cipher.getInstance(TRANSFORMATION);

        GCMParameterSpec spec = new GCMParameterSpec(GCM_TAG_LENGTH * 8, encryptedData.getIv());
        cipher.init(Cipher.DECRYPT_MODE, key, spec);

        return cipher.doFinal(encryptedData.getEncryptedData());
    }

    public static byte[] decrypt(byte[] encryptedData, byte[] iv, SecretKey key) throws Exception {
        Cipher cipher = Cipher.getInstance(TRANSFORMATION);

        GCMParameterSpec spec = new GCMParameterSpec(GCM_TAG_LENGTH * 8, iv);
        cipher.init(Cipher.DECRYPT_MODE, key, spec);

        return cipher.doFinal(encryptedData);
    }

    // ============================================
    // KEY ENCRYPTION
    // ============================================

    public static EncryptedData encryptKey(SecretKey keyToEncrypt, SecretKey encryptionKey) throws Exception {
        byte[] keyBytes = keyToEncrypt.getEncoded();
        return encrypt(keyBytes, encryptionKey);
    }

    public static SecretKey decryptKey(EncryptedData encryptedKey, SecretKey decryptionKey) throws Exception {
        byte[] decryptedKeyBytes = decrypt(encryptedKey, decryptionKey);
        return new SecretKeySpec(decryptedKeyBytes, ALGORITHM);
    }

    public static SecretKey decryptKey(byte[] encryptedKeyBytes, byte[] iv, SecretKey decryptionKey) throws Exception {
        byte[] decryptedKeyBytes = decrypt(encryptedKeyBytes, iv, decryptionKey);
        return new SecretKeySpec(decryptedKeyBytes, ALGORITHM);
    }

    // ============================================
    // USER MASTER KEY OPERATIONS
    // ============================================

    public static EncryptedData createUserMasterKey(String password, byte[] salt) throws Exception {
        SecretKey masterKey = generateKey();
        SecretKey passwordKey = deriveKeyFromPassword(password, salt);
        return encryptKey(masterKey, passwordKey);
    }

    public static SecretKey unlockUserMasterKey(String password, byte[] salt,
            byte[] encryptedMasterKey, byte[] iv) throws Exception {
        SecretKey passwordKey = deriveKeyFromPassword(password, salt);
        return decryptKey(encryptedMasterKey, iv, passwordKey);
    }

    // ============================================
    // GROUP KEY OPERATIONS
    // ============================================

    public static EncryptedData encryptGroupKeyForUser(SecretKey groupKey, SecretKey userMasterKey) throws Exception {
        return encryptKey(groupKey, userMasterKey);
    }

    public static SecretKey decryptGroupKeyForUser(byte[] encryptedGroupKey, byte[] iv,
            SecretKey userMasterKey) throws Exception {
        return decryptKey(encryptedGroupKey, iv, userMasterKey);
    }

    // ============================================
    // TOKEN-BASED GROUP KEY OPERATIONS (Option C)
    // For collaborative memories where group key is
    // encrypted with key derived from invite token
    // ============================================

    /**
     * Generate a cryptographically secure invite token (32 chars)
     */
    public static String generateInviteToken() {
        byte[] tokenBytes = new byte[24]; // 24 bytes = 32 chars in base64
        new SecureRandom().nextBytes(tokenBytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(tokenBytes);
    }

    /**
     * Derive an encryption key from an invite token using PBKDF2
     * This allows anyone with the token to decrypt the group key
     */
    public static SecretKey deriveKeyFromToken(String token, byte[] salt) throws Exception {
        // Reuse the existing PBKDF2 infrastructure
        return deriveKeyFromPassword(token, salt);
    }

    /**
     * Encrypt group key with token-derived key for sharing via invite links
     */
    public static EncryptedData encryptGroupKeyWithToken(SecretKey groupKey, String token, byte[] salt)
            throws Exception {
        SecretKey tokenKey = deriveKeyFromToken(token, salt);
        return encryptKey(groupKey, tokenKey);
    }

    /**
     * Decrypt group key using invite token
     */
    public static SecretKey decryptGroupKeyWithToken(byte[] encryptedGroupKey, byte[] iv,
            String token, byte[] salt) throws Exception {
        SecretKey tokenKey = deriveKeyFromToken(token, salt);
        return decryptKey(encryptedGroupKey, iv, tokenKey);
    }

    // ============================================
    // FILE CHUNKING
    // ============================================

    public static byte[][] splitFile(byte[] fileData, int chunkSize) {
        int numChunks = (int) Math.ceil((double) fileData.length / chunkSize);
        byte[][] chunks = new byte[numChunks][];

        for (int i = 0; i < numChunks; i++) {
            int start = i * chunkSize;
            int end = Math.min(start + chunkSize, fileData.length);
            int length = end - start;

            chunks[i] = new byte[length];
            System.arraycopy(fileData, start, chunks[i], 0, length);
        }

        return chunks;
    }

    public static byte[] combineChunks(byte[][] chunks) {
        int totalLength = 0;
        for (byte[] chunk : chunks) {
            totalLength += chunk.length;
        }

        byte[] combined = new byte[totalLength];
        int offset = 0;

        for (byte[] chunk : chunks) {
            System.arraycopy(chunk, 0, combined, offset, chunk.length);
            offset += chunk.length;
        }

        return combined;
    }

    public static EncryptedData[] encryptFileInChunks(byte[] fileData, SecretKey key, int chunkSize) throws Exception {
        byte[][] chunks = splitFile(fileData, chunkSize);
        EncryptedData[] encryptedChunks = new EncryptedData[chunks.length];

        for (int i = 0; i < chunks.length; i++) {
            encryptedChunks[i] = encrypt(chunks[i], key);
        }

        return encryptedChunks;
    }

    public static byte[] decryptFileChunks(EncryptedData[] encryptedChunks, SecretKey key) throws Exception {
        byte[][] decryptedChunks = new byte[encryptedChunks.length][];

        for (int i = 0; i < encryptedChunks.length; i++) {
            decryptedChunks[i] = decrypt(encryptedChunks[i], key);
        }

        return combineChunks(decryptedChunks);
    }

    // ============================================
    // KEY CONVERSION UTILITIES
    // ============================================

    public static String keyToString(SecretKey key) {
        return Base64.getEncoder().encodeToString(key.getEncoded());
    }

    public static SecretKey stringToKey(String keyString) {
        byte[] keyBytes = Base64.getDecoder().decode(keyString);
        return new SecretKeySpec(keyBytes, ALGORITHM);
    }

    public static String bytesToBase64(byte[] bytes) {
        return Base64.getEncoder().encodeToString(bytes);
    }

    public static byte[] base64ToBytes(String base64) {
        return Base64.getDecoder().decode(base64);
    }

    // ============================================
    // DATA CLASSES
    // ============================================

    public static class EncryptedData {
        private final byte[] encryptedData;
        private final byte[] iv;

        public EncryptedData(byte[] encryptedData, byte[] iv) {
            this.encryptedData = encryptedData;
            this.iv = iv;
        }

        public byte[] getEncryptedData() {
            return encryptedData;
        }

        public byte[] getIv() {
            return iv;
        }

        public String getIvBase64() {
            return Base64.getEncoder().encodeToString(iv);
        }

        public String getEncryptedDataBase64() {
            return Base64.getEncoder().encodeToString(encryptedData);
        }
    }

    public static class UserMasterKeyData {
        private final byte[] encryptedMasterKey;
        private final byte[] iv;
        private final byte[] salt;

        public UserMasterKeyData(byte[] encryptedMasterKey, byte[] iv, byte[] salt) {
            this.encryptedMasterKey = encryptedMasterKey;
            this.iv = iv;
            this.salt = salt;
        }

        public byte[] getEncryptedMasterKey() {
            return encryptedMasterKey;
        }

        public byte[] getIv() {
            return iv;
        }

        public byte[] getSalt() {
            return salt;
        }
    }

    public static UserMasterKeyData setupUserMasterKey(String password) throws Exception {
        byte[] salt = generateSalt();
        EncryptedData encryptedMasterKey = createUserMasterKey(password, salt);

        return new UserMasterKeyData(
                encryptedMasterKey.getEncryptedData(),
                encryptedMasterKey.getIv(),
                salt);
    }
}