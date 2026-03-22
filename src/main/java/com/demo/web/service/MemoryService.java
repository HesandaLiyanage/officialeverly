package com.demo.web.service;

import java.util.Map;
import java.util.HashMap;

import com.demo.web.dao.Memory.memoryDAO;
import com.demo.web.dao.Memory.MediaDAO;
import com.demo.web.dao.Memory.MemoryMemberDAO;
import com.demo.web.dao.Groups.GroupDAO;
import com.demo.web.dao.Groups.GroupMemberDAO;
import com.demo.web.dao.Settings.SubscriptionDAO;
import com.demo.web.dao.Notifications.NotificationDAO;
import com.demo.web.model.Memory.Memory;
import com.demo.web.model.Memory.MediaItem;
import com.demo.web.model.Groups.Group;
import com.demo.web.model.Settings.Plan;
import com.demo.web.util.EncryptionService;
import com.demo.web.dto.Memory.MemoryCreateRequest;
import com.demo.web.dto.Memory.MemoryCreateResponse;
import com.demo.web.dto.Memory.MemoryViewRequest;
import com.demo.web.dto.Memory.MemoryViewResponse;
import com.demo.web.dto.Memory.MemoryUpdateRequest;
import com.demo.web.dto.Memory.MemoryUpdateResponse;
import com.demo.web.dto.Memory.MemoryDeleteRequest;
import com.demo.web.dto.Memory.MemoryDeleteResponse;
import com.demo.web.dto.Memory.MemoriesListRequest;
import com.demo.web.dto.Memory.MemoriesListResponse;
import com.demo.web.dto.Memory.MemoryShareLinkRequest;
import com.demo.web.dto.Memory.MemoryShareLinkResponse;
import com.demo.web.dto.Memory.CollabActionRequest;
import com.demo.web.dto.Memory.CollabActionResponse;
import com.demo.web.dto.Memory.CollabMemoriesListRequest;
import com.demo.web.dto.Memory.CollabMemoriesListResponse;
import com.demo.web.dto.Memory.CollabMemoryViewRequest;
import com.demo.web.dto.Memory.CollabMemoryViewResponse;
import com.demo.web.dto.Memory.MemoryRecapRequest;
import com.demo.web.dto.Memory.MemoryRecapResponse;
import com.demo.web.dao.Memory.MemoryRecapDAO;


import javax.servlet.http.Part;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.UUID;

/**
 * Service for memory operations.
 * Provides business logic for memory management.
 */
public class MemoryService {

    private memoryDAO memoryDAO;
    private MediaDAO mediaDAO;
    private MemoryMemberDAO memberDAO;
    private SubscriptionDAO subscriptionDAO;
    private GroupDAO groupDAO;
    private GroupMemberDAO groupMemberDAO;
    private NotificationDAO notificationDAO;
    private MemoryRecapDAO recapDAO;

    // Path where media files are saved
    private static final String UPLOAD_DIR = "media_uploads";
    private static final String PHYSICAL_UPLOAD_PATH = "/Users/hesandaliyanage/Documents/officialeverly/src/main/webapp/media_uploads";

    public MemoryService() {
        this.memoryDAO = new memoryDAO();
        this.mediaDAO = new MediaDAO();
        this.memberDAO = new MemoryMemberDAO();
        this.subscriptionDAO = new SubscriptionDAO();
        this.groupDAO = new GroupDAO();
        this.groupMemberDAO = new GroupMemberDAO();
        this.notificationDAO = new NotificationDAO();
        this.recapDAO = new MemoryRecapDAO();

        // Create the upload directory if it doesn't exist
        try {
            Files.createDirectories(Paths.get(PHYSICAL_UPLOAD_PATH));
        } catch (IOException e) {
            System.err.println("Failed to create upload directory: " + e.getMessage());
        }
    }

    /**
     * Creates a new memory, checks business constraints, encrypts media, and sends notifications.
     */
    public MemoryCreateResponse createMemory(MemoryCreateRequest request) {
        int userId = request.getUserId();
        
        try {
            // 1. Business Logic: Check Memory and Storage Limits
            int count = subscriptionDAO.getMemoryCount(userId);
            Plan plan = subscriptionDAO.getPlanByUserId(userId);
            if (plan == null) plan = subscriptionDAO.getPlanById(1);

            int memLimit = plan.getMemoryLimit();
            if (memLimit > 0 && count >= memLimit) {
                return MemoryCreateResponse.error("Memory limit reached. Upgrade plan.", 403);
            }

            long used = subscriptionDAO.getUsedStorage(userId);
            long storeLimit = plan.getStorageLimitBytes();
            if (storeLimit > 0 && used >= storeLimit) {
                return MemoryCreateResponse.error("Storage limit reached. Upgrade plan.", 403);
            }

            // 2. Business Logic: Validate Input
            String memoryName = request.getMemoryName();
            if (memoryName == null || memoryName.trim().isEmpty()) {
                return MemoryCreateResponse.error("Memory name is required", 400);
            }

            Memory memory = new Memory();
            memory.setTitle(memoryName.trim());
            memory.setDescription(request.getMemoryDate() != null ? "Created on " + request.getMemoryDate() : "");
            memory.setUserId(userId);
            memory.setPublic(false);
            memory.setCollaborative(request.isCollaborative());

            // 3. Business Logic: Handle Group Memory and Permissions
            Integer groupId = request.getGroupId();
            if (groupId != null) {
                Group group = groupDAO.findById(groupId);
                if (group == null) {
                    return MemoryCreateResponse.error("Group not found", 400);
                }
                boolean isGroupAdmin = (group.getUserId() == userId);
                String memberRole = groupMemberDAO.getMemberRole(groupId, userId);
                boolean isGroupMember = isGroupAdmin || memberRole != null;
                boolean canCreate = isGroupAdmin || "editor".equals(memberRole);
                
                if (!isGroupMember) {
                    return MemoryCreateResponse.error("You are not a member of this group", 403);
                }
                if (!canCreate) {
                    return MemoryCreateResponse.error("Viewers cannot create memories. Ask an admin or editor.", 403);
                }
                memory.setGroupId(groupId);
            }

            // 4. Persistence: Create Memory
            int memoryId;
            if (request.isCollaborative()) {
                memoryId = memoryDAO.createCollabMemory(memory);
                memberDAO.addMember(memoryId, userId, "owner"); // Add creator as owner
            } else {
                memoryId = memoryDAO.createMemory(memory);
            }

            // 5. Utility & DB: Encrypt and Save Files
            int uploadedCount = processMediaUploads(request.getMediaFiles(), userId, memoryId);

            // 6. Utility: Send Notifications
            if (uploadedCount > 0 && request.isCollaborative()) {
                sendCollabUploadNotifications(memoryId, userId, uploadedCount, memoryName.trim());
            }

            // 7. Return Result
            return MemoryCreateResponse.success(memoryId, uploadedCount, request.isCollaborative(), groupId);

        } catch (Exception e) {
            e.printStackTrace();
            return MemoryCreateResponse.error("Failed: " + e.getMessage().replace("\"", "'"), 500);
        }
    }

    /**
     * Encrypts and saves media files to disk, storing DB records.
     */
    private int processMediaUploads(Collection<Part> fileParts, int userId, int memoryId) throws Exception {
        int uploadedCount = 0;
        if (fileParts == null) return 0;

        for (Part filePart : fileParts) {
            if (!"mediaFiles".equals(filePart.getName()) || filePart.getSize() == 0) continue;

            String originalFilename = getFileName(filePart);
            if (originalFilename == null || originalFilename.isEmpty()) continue;

            byte[] fileBytes = readAllBytes(filePart.getInputStream());
            long originalSize = fileBytes.length;

            // USE UTILITY: Encrypt the file using EncryptionService
            EncryptionService.FileEncryptionResult encResult = EncryptionService.encryptFile(fileBytes);

            // Save encrypted data to physical disk
            String uniqueFilename = UUID.randomUUID().toString() + ".enc";
            String physicalPath = PHYSICAL_UPLOAD_PATH + File.separator + uniqueFilename;
            try (FileOutputStream fos = new FileOutputStream(physicalPath)) {
                fos.write(encResult.getEncryptedFileData());
            }

            // DB: Store encryption key and media metadata
            mediaDAO.storeMediaEncryptionKey(
                    encResult.getKeyId(), userId,
                    encResult.getEncryptedKey(), encResult.getKeyIv());

            MediaItem mediaItem = new MediaItem();
            mediaItem.setUserId(userId);
            mediaItem.setFilename(uniqueFilename);
            mediaItem.setOriginalFilename(originalFilename);
            mediaItem.setFilePath(UPLOAD_DIR + "/" + uniqueFilename);
            mediaItem.setFileSize(encResult.getEncryptedFileData().length);
            mediaItem.setOriginalFileSize(originalSize);
            mediaItem.setMimeType(filePart.getContentType());
            mediaItem.setMediaType(filePart.getContentType().startsWith("image/") ? "IMAGE" : "VIDEO");
            mediaItem.setTitle(originalFilename);
            mediaItem.setEncrypted(true);
            mediaItem.setEncryptionKeyId(encResult.getKeyId());

            int mediaId = mediaDAO.createMediaItem(mediaItem, encResult.getFileIv());
            memoryDAO.linkMediaToMemory(memoryId, mediaId);
            uploadedCount++;
        }
        return uploadedCount;
    }

    /**
     * Dispatches notifications for collaborative uploads.
     */
    private void sendCollabUploadNotifications(int memoryId, int userId, int uploadedCount, String memoryName) {
        try {
            List<Integer> members = notificationDAO.getCollabMemoryMembers(memoryId, userId);
            for (int memberId : members) {
                notificationDAO.createNotification(
                        memberId,
                        "memory_uploads",
                        "New Upload",
                        "uploaded " + uploadedCount + " file" + (uploadedCount > 1 ? "s" : "") + " to " + memoryName,
                        "/memoryview?id=" + memoryId,
                        userId);
            }
        } catch (Exception ex) {
            System.err.println("Warning: Failure sending notifications -> " + ex.getMessage());
        }
    }

    private byte[] readAllBytes(InputStream inputStream) throws IOException {
        ByteArrayOutputStream buffer = new ByteArrayOutputStream();
        byte[] data = new byte[8192];
        int bytesRead;
        while ((bytesRead = inputStream.read(data)) != -1) {
            buffer.write(data, 0, bytesRead);
        }
        return buffer.toByteArray();
    }

    private String getFileName(Part part) {
        String header = part.getHeader("content-disposition");
        if (header == null) return null;
        for (String partHeader : header.split(";")) {
            if (partHeader.trim().startsWith("filename")) {
                String filename = partHeader.substring(partHeader.indexOf('=') + 1).trim().replace("\"", "");
                return filename.substring(filename.lastIndexOf('/') + 1).substring(filename.lastIndexOf('\\') + 1);
            }
        }
        return null;
    }

   // ==========================================
    // View Memory Logic
    // ==========================================

    /**
     * Views a memory. Checks permissions and loads media items.
     */
    public MemoryViewResponse viewMemory(MemoryViewRequest request) {
        int memoryId = request.getMemoryId();
        int userId = request.getUserId();

        try {
            Memory memory = memoryDAO.getMemoryById(memoryId);
            if (memory == null) {
                return MemoryViewResponse.error("Memory not found", 404);
            }

            // Check access permissions
            boolean isOwner = (memory.getUserId() == userId);
            boolean isGroupMemory = (memory.getGroupId() != null);
            boolean hasAccess = isOwner;
            boolean isAdmin = false;
            boolean canEdit = isOwner;
            String userRole = isOwner ? "admin" : null;
            Group group = null;

            if (isGroupMemory) {
                int groupId = memory.getGroupId();
                group = groupDAO.findById(groupId);
                isAdmin = (group != null && group.getUserId() == userId);
                boolean isMember = groupMemberDAO.isUserMember(groupId, userId);
                String memberRole = groupMemberDAO.getMemberRole(groupId, userId);

                hasAccess = isAdmin || isMember;
                userRole = isAdmin ? "admin" : memberRole;
                canEdit = isAdmin || "editor".equals(memberRole);
            }

            if (!hasAccess) {
                return MemoryViewResponse.error("You don't have permission to view this memory", 403);
            }

            // Fetch associated media items
            List<MediaItem> mediaItems = mediaDAO.getMediaByMemoryId(memoryId);

            // Fetch collaborators (if any)
            // List<MemoryMember> collaborators = memberDAO.getMembers(memoryId); // Note: Assuming memberDAO has a getMembers method if needed later.

            MemoryViewResponse response = MemoryViewResponse.success(memory, mediaItems, null, isOwner);
            response.setGroupMemory(isGroupMemory);
            response.setCanEdit(canEdit);
            response.setUserRole(userRole);
            response.setAdmin(isAdmin || isOwner);
            if (group != null) {
                response.setGroup(group);
            }

            return response;

        } catch (Exception e) {
            e.printStackTrace();
            return MemoryViewResponse.error("Error loading memory: " + e.getMessage(), 500);
        }
    }

    // ==========================================
    // Update Memory Logic
    // ==========================================

    public MemoryUpdateResponse updateMemory(MemoryUpdateRequest request) {
        int memoryId = request.getMemoryId();
        int userId = request.getUserId();

        try {
            Memory memory = memoryDAO.getMemoryById(memoryId);
            if (memory == null) {
                return MemoryUpdateResponse.error("Memory not found", 404);
            }

            // Check edit permissions
            boolean canEdit = false;
            boolean isGroupMemory = (memory.getGroupId() != null);

            if (isGroupMemory) {
                int groupId = memory.getGroupId();
                Group group = groupDAO.findById(groupId);
                boolean isAdmin = (group != null && group.getUserId() == userId);
                String memberRole = groupMemberDAO.getMemberRole(groupId, userId);
                canEdit = isAdmin || "editor".equals(memberRole);
            } else {
                canEdit = (memory.getUserId() == userId);
            }

            if (!canEdit) {
                return MemoryUpdateResponse.error("You don't have permission to edit this memory", 403);
            }

            // Update title and description
            String title = request.getTitle();
            String description = request.getDescription();
            if (title != null && !title.trim().isEmpty()) {
                memory.setTitle(title.trim());
            }
            if (description != null) {
                memory.setDescription(description.trim());
            }

            memoryDAO.updateMemory(memory);

            // Handle removed media items
            if (request.getRemovedMediaIds() != null) {
                for (String mediaIdStr : request.getRemovedMediaIds()) {
                    try {
                        int mediaId = Integer.parseInt(mediaIdStr);
                        memoryDAO.unlinkMediaFromMemory(memoryId, mediaId);
                    } catch (NumberFormatException ignored) {}
                }
            }

            // Handle new file uploads
            if (request.getNewMediaFiles() != null) {
                for (Part filePart : request.getNewMediaFiles()) {
                    if (!"mediaFiles".equals(filePart.getName()) || filePart.getSize() == 0) continue;

                    String originalFilename = getFileName(filePart);
                    if (originalFilename == null || originalFilename.isEmpty()) continue;

                    byte[] fileBytes = readAllBytes(filePart.getInputStream());
                    long originalSize = fileBytes.length;

                    // Encrypt
                    EncryptionService.FileEncryptionResult encResult = EncryptionService.encryptFile(fileBytes);

                    // Save physical file
                    String uniqueFilename = UUID.randomUUID().toString() + ".enc";
                    String physicalPath = PHYSICAL_UPLOAD_PATH + File.separator + uniqueFilename;
                    try (FileOutputStream fos = new FileOutputStream(physicalPath)) {
                        fos.write(encResult.getEncryptedFileData());
                    }

                    // Store encryption key lookup
                    mediaDAO.storeMediaEncryptionKey(
                            encResult.getKeyId(), userId,
                            encResult.getEncryptedKey(), encResult.getKeyIv());

                    // Create DB item
                    MediaItem mediaItem = new MediaItem();
                    mediaItem.setUserId(userId);
                    mediaItem.setFilename(uniqueFilename);
                    mediaItem.setOriginalFilename(originalFilename);
                    mediaItem.setFilePath(UPLOAD_DIR + "/" + uniqueFilename);
                    mediaItem.setFileSize(encResult.getEncryptedFileData().length);
                    mediaItem.setOriginalFileSize(originalSize);
                    mediaItem.setMimeType(filePart.getContentType());
                    mediaItem.setMediaType(filePart.getContentType().startsWith("image/") ? "IMAGE" : "VIDEO");
                    mediaItem.setTitle(originalFilename);
                    mediaItem.setEncrypted(true);
                    mediaItem.setEncryptionKeyId(encResult.getKeyId());

                    int mediaId = mediaDAO.createMediaItem(mediaItem, encResult.getFileIv());
                    memoryDAO.linkMediaToMemory(memoryId, mediaId);
                }
            }

            return MemoryUpdateResponse.success();

        } catch (Exception e) {
            e.printStackTrace();
            return MemoryUpdateResponse.error("Error updating memory: " + e.getMessage(), 500);
        }
    }

    // ==========================================
    // Delete Memory Logic
    // ==========================================

    public MemoryDeleteResponse deleteMemory(MemoryDeleteRequest request) {
        int memoryId = request.getMemoryId();
        int userId = request.getUserId();

        try {
            Memory memory = memoryDAO.getMemoryById(memoryId);
            if (memory == null) {
                return MemoryDeleteResponse.error("Memory not found", 404);
            }

            // Check delete permissions
            boolean canDelete = false;
            boolean isGroupMemory = (memory.getGroupId() != null);
            Integer groupId = memory.getGroupId();

            if (isGroupMemory) {
                Group group = groupDAO.findById(groupId);
                boolean isAdmin = (group != null && group.getUserId() == userId);
                String memberRole = groupMemberDAO.getMemberRole(groupId, userId);
                canDelete = isAdmin || "editor".equals(memberRole);
            } else {
                canDelete = (memory.getUserId() == userId);
            }

            if (!canDelete) {
                return MemoryDeleteResponse.error("You don't have permission to delete this memory", 403);
            }

            // Get media items
            List<MediaItem> mediaItems = mediaDAO.getMediaByMemoryId(memoryId);

            // Delete physical media files
            for (MediaItem item : mediaItems) {
                try {
                    String filePath = item.getFilePath();
                    if (filePath != null && !filePath.isEmpty()) {
                        File file = new File(filePath);
                        if (file.exists()) {
                            file.delete();
                        }
                    }
                    mediaDAO.deleteMediaItem(item.getMediaId());
                } catch (Exception ignored) {}
            }

            // Cascade delete the memory
            memoryDAO.deleteMemory(memoryId);

            return MemoryDeleteResponse.success(groupId);

        } catch (Exception e) {
            e.printStackTrace();
            return MemoryDeleteResponse.error("Error deleting memory: " + e.getMessage(), 500);
        }
    }

    // ==========================================
    // Fetch Memories List
    // ==========================================

    public MemoriesListResponse getMemoriesList(MemoriesListRequest request) {
        int userId = request.getUserId();
        try {
            SubscriptionDAO subDAO = new SubscriptionDAO();
            Plan plan = subDAO.getPlanByUserId(userId);
            if (plan == null) plan = subDAO.getPlanById(1);

            long used = subDAO.getUsedStorage(userId);
            int count = subDAO.getMemoryCount(userId);

            boolean warning = false;
            boolean full = false;

            long limit = plan.getStorageLimitBytes();
            if (limit > 0) {
                if (used >= limit) full = true;
                else if ((double) used / limit > 0.9) warning = true;
            }

            int memLimit = plan.getMemoryLimit();
            if (memLimit > 0) {
                if (count >= memLimit) full = true;
                else if ((double) count / memLimit > 0.9) warning = true;
            }

            List<Memory> memories = memoryDAO.getMemoriesByUserId(userId);
            Map<Integer, String> coverImages = new HashMap<>();

            for (Memory memory : memories) {
                try {
                    List<MediaItem> mediaItems = mediaDAO.getMediaByMemoryId(memory.getMemoryId());
                    if (!mediaItems.isEmpty()) {
                        MediaItem coverMedia = mediaItems.get(0);
                        // Store exactly the query path expected by the JSP
                        coverImages.put(memory.getMemoryId(), "/viewMedia?mediaId=" + coverMedia.getMediaId());
                    }
                } catch (Exception ignored) {}
            }

            MemoriesListResponse response = MemoriesListResponse.success(memories, coverImages);
            response.setShowStorageWarning(warning);
            response.setStorageFull(full);
            return response;

        } catch (Exception e) {
            e.printStackTrace();
            return MemoriesListResponse.error("Error loading memories: " + e.getMessage(), 500);
        }
    }

    // ==========================================
    // Handle Shared Links
    // ==========================================

    public MemoryShareLinkResponse handleShareLink(MemoryShareLinkRequest request) {
        int memoryId = request.getMemoryId();
        int userId = request.getUserId();

        try {
            // Check authorization
            if (!memberDAO.isMember(memoryId, userId)) {
                return MemoryShareLinkResponse.error("Not authorized", 403);
            }

            Memory memory = memoryDAO.getMemoryById(memoryId);
            if (memory == null || !memory.isCollaborative()) {
                return MemoryShareLinkResponse.error("Collaborative memory not found", 404);
            }

            String shareKey = memory.getCollabShareKey();

            if (request.isRevoke()) {
                // Not actually implemented in existing pure servlet, but a nice to have
                // memoryDAO.setCollabShareKey(memoryId, null);
                // return MemoryShareLinkResponse.success("");
            }

            if (shareKey == null || shareKey.isEmpty() || request.isGenerateNew()) {
                shareKey = generateShareKey(14);
                memoryDAO.setCollabShareKey(memoryId, shareKey);
            }

            return MemoryShareLinkResponse.success(shareKey);

        } catch (Exception e) {
            e.printStackTrace();
            return MemoryShareLinkResponse.error("Error handling share link: " + e.getMessage(), 500);
        }
    }

    private String generateShareKey(int length) {
        String CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        java.security.SecureRandom RANDOM = new java.security.SecureRandom();
        StringBuilder sb = new StringBuilder(length);
        for (int i = 0; i < length; i++) {
            sb.append(CHARS.charAt(RANDOM.nextInt(CHARS.length())));
        }
        return sb.toString();
    }

    // ==========================================
    // Memory Edit Handling
    // ==========================================

    public com.demo.web.dto.Memory.MemoryEditResponse getMemoryForEdit(com.demo.web.dto.Memory.MemoryEditRequest request) {
        com.demo.web.dto.Memory.MemoryEditResponse response = new com.demo.web.dto.Memory.MemoryEditResponse();
        int memoryId = request.getMemoryId();
        int userId = request.getUserId();

        try {
            Memory memory = memoryDAO.getMemoryById(memoryId);

            if (memory == null) {
                response.setErrorMessage("Memory not found");
                return response;
            }

            boolean canEdit = false;
            boolean isGroupMemory = (memory.getGroupId() != null);

            if (isGroupMemory) {
                int groupId = memory.getGroupId();
                com.demo.web.model.Groups.Group group = groupDAO.findById(groupId);
                boolean isAdmin = (group != null && group.getUserId() == userId);
                String memberRole = groupMemberDAO.getMemberRole(groupId, userId);
                canEdit = isAdmin || "editor".equals(memberRole);

                if (canEdit) {
                    response.setGroup(group);
                    response.setGroupMemory(true);
                }
                response.setRedirectGroupId(groupId); // For redirection on error
            } else {
                canEdit = (memory.getUserId() == userId);
            }

            if (!canEdit) {
                response.setErrorMessage("You don't have permission to edit this memory");
                response.setCanEdit(false);
                return response;
            }

            response.setCanEdit(true);
            response.setMemory(memory);
            response.setMediaItems(mediaDAO.getMediaByMemoryId(memoryId));

        } catch (Exception e) {
            e.printStackTrace();
            response.setErrorMessage("Error loading memory for edit: " + e.getMessage());
        }

        return response;
    }

    // ==========================================
    // Collab Memories Listing and Viewing
    // ==========================================

    public CollabMemoriesListResponse getCollabMemoriesList(CollabMemoriesListRequest request) {
        CollabMemoriesListResponse response = new CollabMemoriesListResponse();
        int userId = request.getUserId();
        String contextPath = request.getContextPath();

        try {
            List<Memory> memories = memoryDAO.getCollabMemoriesByUserId(userId);
            java.util.Map<Integer, String> coverImageUrls = new java.util.HashMap<>();
            java.util.Map<Integer, Integer> memberCounts = new java.util.HashMap<>();
            java.util.Map<Integer, Boolean> isOwnerMap = new java.util.HashMap<>();

            for (Memory memory : memories) {
                try {
                    List<MediaItem> mediaItems = mediaDAO.getMediaByMemoryId(memory.getMemoryId());
                    if (!mediaItems.isEmpty()) {
                        MediaItem coverMedia = mediaItems.get(0);
                        coverImageUrls.put(memory.getMemoryId(), contextPath + "/viewMedia?mediaId=" + coverMedia.getMediaId());
                    }

                    memberCounts.put(memory.getMemoryId(), memberDAO.getMemberCount(memory.getMemoryId()));
                    isOwnerMap.put(memory.getMemoryId(), memberDAO.isOwner(memory.getMemoryId(), userId));

                } catch (Exception e) {
                    System.err.println("Error getting data for memory " + memory.getMemoryId() + ": " + e.getMessage());
                }
            }

            response.setMemories(memories);
            response.setCoverImageUrls(coverImageUrls);
            response.setMemberCounts(memberCounts);
            response.setIsOwnerMap(isOwnerMap);

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error loading collab memories: " + e.getMessage());
        }

        return response;
    }

    public CollabMemoryViewResponse viewCollabMemory(CollabMemoryViewRequest request) {
        CollabMemoryViewResponse response = new CollabMemoryViewResponse();
        int memoryId = request.getMemoryId();
        int userId = request.getUserId();

        try {
            Memory memory = memoryDAO.getMemoryById(memoryId);
            if (memory == null) {
                response.setErrorMessage("Memory not found");
                return response;
            }
            if (!memory.isCollaborative()) {
                response.setCollaborative(false);
                return response;
            }
            response.setCollaborative(true);

            if (!memberDAO.isMember(memoryId, userId)) {
                response.setErrorMessage("You don't have access to this memory");
                return response;
            }

            response.setMemory(memory);
            response.setMediaItems(mediaDAO.getMediaByMemoryId(memoryId));
            response.setMembers(memberDAO.getMembers(memoryId));
            response.setOwner(memberDAO.isOwner(memoryId, userId));
            response.setMember(true);

        } catch (Exception e) {
            e.printStackTrace();
            response.setErrorMessage("Error loading memory: " + e.getMessage());
        }

        return response;
    }

    // ==========================================
    // Memory Recap Generation
    // ==========================================

    public MemoryRecapResponse getMemoryRecaps(MemoryRecapRequest request) {
        MemoryRecapResponse response = new MemoryRecapResponse();
        int userId = request.getUserId();
        String contextPath = request.getContextPath();
        int memoriesPerBundle = 10;

        try {
            List<java.util.Map<String, Object>> timeRecaps = recapDAO.getTimeRecaps(userId, memoriesPerBundle);
            List<java.util.Map<String, Object>> eventRecaps = recapDAO.getEventRecaps(userId, 5, memoriesPerBundle);
            List<java.util.Map<String, Object>> groupRecaps = recapDAO.getGroupRecaps(userId, 5, memoriesPerBundle);

            resolveCovers(contextPath, timeRecaps);
            resolveCovers(contextPath, eventRecaps);
            resolveCovers(contextPath, groupRecaps);

            List<java.util.Map<String, Object>> allRecaps = new ArrayList<>();
            for (java.util.Map<String, Object> r : timeRecaps) { r.put("category", "time"); allRecaps.add(r); }
            for (java.util.Map<String, Object> r : eventRecaps) { r.put("category", "event"); allRecaps.add(r); }
            for (java.util.Map<String, Object> r : groupRecaps) { r.put("category", "group"); allRecaps.add(r); }
            
            java.util.Collections.shuffle(allRecaps);

            response.setTotalMemories(recapDAO.getTotalMemoryCount(userId));
            response.setTotalEvents(recapDAO.getTotalEventCount(userId));
            response.setTotalGroups(recapDAO.getTotalGroupCount(userId));
            
            response.setAllRecaps(allRecaps);
            response.setTimeRecaps(timeRecaps);
            response.setEventRecaps(eventRecaps);
            response.setGroupRecaps(groupRecaps);
            
            // Build JSON
            StringBuilder json = new StringBuilder("{");
            for (int i = 0; i < allRecaps.size(); i++) {
                java.util.Map<String, Object> recap = allRecaps.get(i);
                String label = (String) recap.get("label");
                String emoji = (String) recap.get("emoji");
                @SuppressWarnings("unchecked")
                List<Memory> memories = (List<Memory>) recap.get("memories");

                String escapedLabel = escapeJson(label != null ? label : "");
                String escapedEmoji = emoji != null ? emoji : "📸";

                if (i > 0) json.append(",");
                json.append("\"recap-").append(i).append("\":{");
                json.append("\"name\":\"").append(escapedLabel).append("\",");
                json.append("\"avatar\":\"").append(escapeJson(escapedEmoji)).append("\",");
                json.append("\"memories\":[");

                if (memories != null) {
                    for (int j = 0; j < memories.size(); j++) {
                        Memory memory = memories.get(j);
                        String memTitle = escapeJson(memory.getTitle() != null ? memory.getTitle() : "Memory");
                        String memDesc = escapeJson(memory.getDescription() != null ? memory.getDescription() : "");
                        String coverUrl = memory.getCoverUrl();
                        int memoryId = memory.getMemoryId();

                        if (j > 0) json.append(",");
                        json.append("{");
                        json.append("\"image\":\"").append(coverUrl != null ? escapeJson(coverUrl) : "").append("\",");
                        json.append("\"title\":\"").append(memTitle).append("\",");
                        json.append("\"caption\":\"").append(memDesc).append("\",");
                        json.append("\"memoryId\":").append(memoryId);
                        json.append("}");
                    }
                }
                json.append("]}");
            }
            json.append("}");
            response.setRecapDataJson(json.toString());

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error loading memory recaps: " + e.getMessage());
        }

        return response;
    }

    private void resolveCovers(String contextPath, List<java.util.Map<String, Object>> recaps) {
        for (java.util.Map<String, Object> recap : recaps) {
            @SuppressWarnings("unchecked")
            List<Memory> memories = (List<Memory>) recap.get("memories");
            if (memories != null) {
                for (Memory memory : memories) {
                    try {
                        Integer mediaId = memory.getCoverMediaId();
                        if (mediaId == null) {
                            mediaId = recapDAO.getFirstMediaIdForMemory(memory.getMemoryId());
                        }
                        if (mediaId != null) {
                            String coverUrl = contextPath + "/viewMedia?mediaId=" + mediaId;
                            memory.setCoverUrl(coverUrl);
                        }
                    } catch (Exception e) {
                        System.err.println("[MemoryService] Error resolving cover for memory " + memory.getMemoryId());
                    }
                }
            }
        }
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("'", "\\'")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }

    // ==========================================
    // Handle Collaborative Actions (Join/Leave/Remove)
    // ==========================================

    public CollabActionResponse processCollabAction(CollabActionRequest request) {
        int userId = request.getRequesterId();
        String action = request.getAction();

        try {
            if ("JOIN".equalsIgnoreCase(action)) {
                String shareKey = request.getShareKey();
                if (shareKey == null || shareKey.isEmpty()) {
                    return CollabActionResponse.error("Invalid invite link", 400);
                }

                Memory memory = memoryDAO.getMemoryByShareKey(shareKey);
                if (memory == null) {
                    return CollabActionResponse.error("Invalid or expired invite link", 404);
                }
                if (!memory.isCollaborative()) {
                    return CollabActionResponse.error("This memory is not collaborative", 400);
                }

                if (!memberDAO.isMember(memory.getMemoryId(), userId)) {
                    memberDAO.addMember(memory.getMemoryId(), userId, "member");
                }

                return CollabActionResponse.successWithData(memory.getMemoryId());

            } else if ("LEAVE".equalsIgnoreCase(action)) {
                int memoryId = request.getMemoryId();

                if (memberDAO.isOwner(memoryId, userId)) {
                    return CollabActionResponse.error("Owner cannot leave. Delete the memory instead.", 400);
                }
                if (!memberDAO.isMember(memoryId, userId)) {
                    return CollabActionResponse.error("You are not a member of this memory", 400);
                }

                boolean left = memberDAO.leaveMembership(memoryId, userId);
                if (left) return CollabActionResponse.success();
                else return CollabActionResponse.error("Failed to leave memory", 500);

            } else if ("REMOVE".equalsIgnoreCase(action)) {
                int memoryId = request.getMemoryId();
                Integer targetUserId = request.getTargetUserId();

                if (targetUserId == null) {
                    return CollabActionResponse.error("Target member ID is required", 400);
                }
                if (!memberDAO.isOwner(memoryId, userId)) {
                    return CollabActionResponse.error("Only the owner can remove members", 403);
                }
                if (memberDAO.isOwner(memoryId, targetUserId)) {
                    return CollabActionResponse.error("Cannot remove the owner", 400);
                }

                boolean removed = memberDAO.removeMember(memoryId, targetUserId);
                if (removed) return CollabActionResponse.success();
                else return CollabActionResponse.error("Failed to remove member", 500);

            }

            return CollabActionResponse.error("Unknown action", 400);

        } catch (Exception e) {
            e.printStackTrace();
            return CollabActionResponse.error("Error processing collab action: " + e.getMessage(), 500);
        }
    }

    // ==========================================
    // Legacy Getters (kept for backwards compatibility)
    // ==========================================

    public List<Memory> getMemoriesByUserId(int userId) {
        try {
            return memoryDAO.getMemoriesByUserId(userId);
        } catch (SQLException e) {
            return new ArrayList<>();
        }
    }

    public Memory getMemoryById(int memoryId, int userId) {
        try {
            Memory result = memoryDAO.getMemoryById(memoryId);
            if (result == null || result.getUserId() != userId) return null;
            return result;
        } catch (SQLException e) {
            return null;
        }
    }

    public List<MediaItem> getMediaByMemoryId(int memoryId) {
        try {
            return mediaDAO.getMediaByMemoryId(memoryId);
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }

    public MediaItem getCoverMedia(int memoryId) {
        List<MediaItem> mediaItems = getMediaByMemoryId(memoryId);
        return !mediaItems.isEmpty() ? mediaItems.get(0) : null;
    }
}
