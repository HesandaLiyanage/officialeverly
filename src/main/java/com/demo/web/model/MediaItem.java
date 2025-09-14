package com.demo.web.model;

import java.sql.Timestamp;

public class MediaItem {
    private int mediaId;
    private int userId;
    private String filename;
    private String originalFilename;
    private String filePath;
    private long fileSize;
    private String mimeType;
    private String mediaType; // IMAGE, VIDEO, AUDIO, DOCUMENT
    private String title;
    private String description;
    private Timestamp uploadTimestamp;
    private boolean isPublic;
    private String storageBucket;
    private String metadata; // JSON string for additional data

    // Constructors
    public MediaItem() {}

    public MediaItem(int userId, String filename, String originalFilename,
                     String filePath, long fileSize, String mimeType,
                     String mediaType, String storageBucket) {
        this.userId = userId;
        this.filename = filename;
        this.originalFilename = originalFilename;
        this.filePath = filePath;
        this.fileSize = fileSize;
        this.mimeType = mimeType;
        this.mediaType = mediaType;
        this.storageBucket = storageBucket;
        this.title = originalFilename;
        this.uploadTimestamp = new Timestamp(System.currentTimeMillis());
    }

    // Getters and Setters
    public int getMediaId() { return mediaId; }
    public void setMediaId(int mediaId) { this.mediaId = mediaId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getFilename() { return filename; }
    public void setFilename(String filename) { this.filename = filename; }

    public String getOriginalFilename() { return originalFilename; }
    public void setOriginalFilename(String originalFilename) { this.originalFilename = originalFilename; }

    public String getFilePath() { return filePath; }
    public void setFilePath(String filePath) { this.filePath = filePath; }

    public long getFileSize() { return fileSize; }
    public void setFileSize(long fileSize) { this.fileSize = fileSize; }

    public String getMimeType() { return mimeType; }
    public void setMimeType(String mimeType) { this.mimeType = mimeType; }

    public String getMediaType() { return mediaType; }
    public void setMediaType(String mediaType) { this.mediaType = mediaType; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Timestamp getUploadTimestamp() { return uploadTimestamp; }
    public void setUploadTimestamp(Timestamp uploadTimestamp) { this.uploadTimestamp = uploadTimestamp; }

    public boolean isPublic() { return isPublic; }
    public void setPublic(boolean isPublic) { this.isPublic = isPublic; }

    public String getStorageBucket() { return storageBucket; }
    public void setStorageBucket(String storageBucket) { this.storageBucket = storageBucket; }

    public String getMetadata() { return metadata; }
    public void setMetadata(String metadata) { this.metadata = metadata; }

    @Override
    public String toString() {
        return "MediaItem{" +
                "mediaId=" + mediaId +
                ", userId=" + userId +
                ", filename='" + filename + '\'' +
                ", mediaType='" + mediaType + '\'' +
                ", fileSize=" + fileSize +
                ", uploadTimestamp=" + uploadTimestamp +
                '}';
    }
}