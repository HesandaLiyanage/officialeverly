package com.demo.web.service;

import com.demo.web.dao.memoryDAO;
import com.demo.web.dao.MediaDAO;
import com.demo.web.model.Memory;
import com.demo.web.model.MediaItem;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Service for memory operations.
 * Provides business logic for memory management.
 */
public class MemoryService {

    private memoryDAO memoryDAO;
    private MediaDAO mediaDAO;

    public MemoryService() {
        this.memoryDAO = new memoryDAO();
        this.mediaDAO = new MediaDAO();
    }

    /**
     * Gets all memories for a user.
     * 
     * @param userId The user ID
     * @return List of memories, empty list if error
     */
    public List<Memory> getMemoriesByUserId(int userId) {
        try {
            return memoryDAO.getMemoriesByUserId(userId);
        } catch (SQLException e) {
            System.err.println("Error getting memories for user " + userId + ": " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    /**
     * Gets a memory by ID with ownership verification.
     * 
     * @param memoryId The memory ID
     * @param userId   The user ID for ownership check
     * @return The memory if found and owned by user, null otherwise
     */
    public Memory getMemoryById(int memoryId, int userId) {
        try {
            Memory result = memoryDAO.getMemoryById(memoryId);

            // Verify ownership
            if (result == null || result.getUserId() != userId) {
                return null;
            }

            return result;
        } catch (SQLException e) {
            System.err.println("Error getting memory " + memoryId + ": " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Gets media items for a memory.
     * 
     * @param memoryId The memory ID
     * @return List of media items, empty list if error
     */
    public List<MediaItem> getMediaByMemoryId(int memoryId) {
        try {
            return mediaDAO.getMediaByMemoryId(memoryId);
        } catch (Exception e) {
            System.err.println("Error getting media for memory " + memoryId + ": " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    /**
     * Gets the first media item as cover image for a memory.
     * 
     * @param memoryId The memory ID
     * @return The first media item, or null if none
     */
    public MediaItem getCoverMedia(int memoryId) {
        List<MediaItem> mediaItems = getMediaByMemoryId(memoryId);
        return !mediaItems.isEmpty() ? mediaItems.get(0) : null;
    }
}
