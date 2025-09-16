package com.demo.web.model;

import java.sql.Timestamp;

public class EncryptionKey {
    private String keyId;
    private int userId;
    private byte[] encryptedKey;
    private Timestamp createdAt;

    public EncryptionKey() {}

    public EncryptionKey(String keyId, int userId, byte[] encryptedKey) {
        this.keyId = keyId;
        this.userId = userId;
        this.encryptedKey = encryptedKey;
        this.createdAt = new Timestamp(System.currentTimeMillis());
    }

    // Getters and Setters
    public String getKeyId() { return keyId; }
    public void setKeyId(String keyId) { this.keyId = keyId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public byte[] getEncryptedKey() { return encryptedKey; }
    public void setEncryptedKey(byte[] encryptedKey) { this.encryptedKey = encryptedKey; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}