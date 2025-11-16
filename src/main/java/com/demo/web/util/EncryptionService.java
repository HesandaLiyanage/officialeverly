package com.demo.web.util;

import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.security.SecureRandom;
import java.util.Base64;
import java.util.UUID;

public class EncryptionService {
    private static final String ALGORITHM = "AES";
    private static final String TRANSFORMATION = "AES/GCM/NoPadding";
    private static final int GCM_IV_LENGTH = 12;
    private static final int GCM_TAG_LENGTH = 16;

    //working on a 4th year project because our panel
    //failed to understand us (they told us to add more features)

    public static SecretKey generateKey() throws Exception {
        KeyGenerator keyGenerator = KeyGenerator.getInstance(ALGORITHM);
        keyGenerator.init(256);
        return keyGenerator.generateKey();
    }


    public static String generateKeyId() {

        return UUID.randomUUID().toString();
    }


    public static EncryptedData encrypt(byte[] data, SecretKey key) throws Exception {
        Cipher cipher = Cipher.getInstance(TRANSFORMATION);

        // Generate initilization vector (same as salt hehe)
        byte[] iv = new byte[GCM_IV_LENGTH];
        new SecureRandom().nextBytes(iv);

        GCMParameterSpec spec = new GCMParameterSpec(GCM_TAG_LENGTH * 8, iv);
        cipher.init(Cipher.ENCRYPT_MODE, key, spec);

        byte[] encryptedData = cipher.doFinal(data);

        return new EncryptedData(encryptedData, iv);
    }

    /**
     * Decrypt data with AES-GCM
     */
    public static byte[] decrypt(EncryptedData encryptedData, SecretKey key) throws Exception {
        Cipher cipher = Cipher.getInstance(TRANSFORMATION);

        GCMParameterSpec spec = new GCMParameterSpec(GCM_TAG_LENGTH * 8, encryptedData.getIv());
        cipher.init(Cipher.DECRYPT_MODE, key, spec);

        return cipher.doFinal(encryptedData.getEncryptedData());
    }

    /**
     * Split large file into chunks for faster processing
     */
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

    /**
     * Combine file chunks back together
     */
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

    /**
     * Convert SecretKey to Base64 string
     */
    public static String keyToString(SecretKey key) {
        return Base64.getEncoder().encodeToString(key.getEncoded());
    }

    /**
     * Convert Base64 string to SecretKey
     */
    public static SecretKey stringToKey(String keyString) {
        byte[] keyBytes = Base64.getDecoder().decode(keyString);
        return new SecretKeySpec(keyBytes, ALGORITHM);
    }

    /**
     * Simple class to hold encrypted data and IV
     */
    public static class EncryptedData {
        private byte[] encryptedData;
        private byte[] iv;

        public EncryptedData(byte[] encryptedData, byte[] iv) {
            this.encryptedData = encryptedData;
            this.iv = iv;
        }

        public byte[] getEncryptedData() { return encryptedData; }
        public byte[] getIv() { return iv; }
    }
}