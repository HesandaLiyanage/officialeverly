package com.demo.web.dto.Memory;

import com.demo.web.model.Memory.MediaItem;

public class MediaStreamResponse {
    private boolean success;
    private int statusCode;
    private String errorMessage;
    private MediaItem mediaItem;
    private byte[] fileData;

    public static MediaStreamResponse success(MediaItem mediaItem, byte[] fileData) {
        MediaStreamResponse response = new MediaStreamResponse();
        response.setSuccess(true);
        response.setStatusCode(200);
        response.setMediaItem(mediaItem);
        response.setFileData(fileData);
        return response;
    }

    public static MediaStreamResponse error(int statusCode, String errorMessage) {
        MediaStreamResponse response = new MediaStreamResponse();
        response.setSuccess(false);
        response.setStatusCode(statusCode);
        response.setErrorMessage(errorMessage);
        return response;
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public int getStatusCode() {
        return statusCode;
    }

    public void setStatusCode(int statusCode) {
        this.statusCode = statusCode;
    }

    public String getErrorMessage() {
        return errorMessage;
    }

    public void setErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }

    public MediaItem getMediaItem() {
        return mediaItem;
    }

    public void setMediaItem(MediaItem mediaItem) {
        this.mediaItem = mediaItem;
    }

    public byte[] getFileData() {
        return fileData;
    }

    public void setFileData(byte[] fileData) {
        this.fileData = fileData;
    }
}
