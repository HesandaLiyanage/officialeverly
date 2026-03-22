package com.demo.web.service;

import com.demo.web.dao.Auth.userDAO;
import com.demo.web.dao.Auth.userSessionDAO;
import com.demo.web.dao.Groups.GroupInviteDAO;
import com.demo.web.dao.Autographs.autographDAO;
import com.demo.web.dao.Memory.memoryDAO;
import com.demo.web.dao.Settings.SubscriptionDAO;
import com.demo.web.model.Auth.user;
import com.demo.web.model.Auth.UserSession;
import com.demo.web.model.Autographs.autograph;
import com.demo.web.model.Groups.GroupInvite;
import com.demo.web.model.Memory.Memory;
import com.demo.web.model.Settings.Plan;
import com.demo.web.dto.Settings.*;
import com.demo.web.util.DatabaseUtil;
import com.demo.web.util.PasswordUtil;
import com.demo.web.util.SessionUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class SettingsService {

    private final userDAO userDAO;
    private final userSessionDAO userSessionDAO;
    private final autographDAO autographDAO;
    private final memoryDAO memoryDAO;
    private final GroupInviteDAO groupInviteDAO;
    private final SubscriptionDAO subscriptionDAO;

    public SettingsService() {
        this.userDAO = new userDAO();
        this.userSessionDAO = new userSessionDAO();
        this.autographDAO = new autographDAO();
        this.memoryDAO = new memoryDAO();
        this.groupInviteDAO = new GroupInviteDAO();
        this.subscriptionDAO = new SubscriptionDAO();
    }

    // --- Profile Update ---
    
    public SettingsProfileResponse updateProfile(SettingsProfileRequest request) {
        SettingsProfileResponse response = new SettingsProfileResponse();

        user currentUser = userDAO.findById(request.getUserId());
        if (currentUser == null) {
            response.setRedirectUrl("/login");
            return response;
        }

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();

            if (request.getUsername() != null && !request.getUsername().trim().isEmpty()) {
                user existingUser = userDAO.findByUsername(request.getUsername().trim());
                if (existingUser != null && existingUser.getId() != currentUser.getId()) {
                    response.setErrorMessage("Username is already taken");
                    response.setRedirectUrl("/editprofile");
                    return response;
                }
            }

            String newPasswordHash = null;
            String newSalt = null;

            if (request.getCurrentPassword() != null && !request.getCurrentPassword().isEmpty()
                    && request.getNewPassword() != null && !request.getNewPassword().isEmpty()) {

                if (!request.getNewPassword().equals(request.getConfirmPassword())) {
                    response.setErrorMessage("New passwords do not match");
                    response.setRedirectUrl("/editprofile");
                    return response;
                }

                if (!PasswordUtil.verifyPassword(request.getCurrentPassword(), currentUser.getSalt(), currentUser.getPassword())) {
                    response.setErrorMessage("Current password is incorrect");
                    response.setRedirectUrl("/editprofile");
                    return response;
                }

                newSalt = PasswordUtil.generateSalt();
                newPasswordHash = PasswordUtil.hashPassword(request.getNewPassword(), newSalt);
            }

            StringBuilder sql = new StringBuilder("UPDATE users SET ");
            boolean needsComma = false;

            if (request.getUsername() != null && !request.getUsername().trim().isEmpty()) {
                sql.append("username = ?");
                needsComma = true;
            }

            if (needsComma) sql.append(", ");
            sql.append("bio = ?");

            if (request.isFileUploaded() && request.getProfilePictureUrl() != null && !request.getProfilePictureUrl().equals(currentUser.getProfilePictureUrl())) {
                sql.append(", profile_picture_url = ?");
            }

            if (newPasswordHash != null && newSalt != null) {
                sql.append(", password = ?, salt = ?");
            }

            sql.append(" WHERE user_id = ?");

            stmt = conn.prepareStatement(sql.toString());
            int paramIndex = 1;

            if (request.getUsername() != null && !request.getUsername().trim().isEmpty()) {
                stmt.setString(paramIndex++, request.getUsername().trim());
            }

            stmt.setString(paramIndex++, request.getBio() != null ? request.getBio().trim() : "");

            if (request.isFileUploaded() && request.getProfilePictureUrl() != null && !request.getProfilePictureUrl().equals(currentUser.getProfilePictureUrl())) {
                stmt.setString(paramIndex++, request.getProfilePictureUrl());
            }

            if (newPasswordHash != null && newSalt != null) {
                stmt.setString(paramIndex++, newPasswordHash);
                stmt.setString(paramIndex++, newSalt);
            }

            stmt.setInt(paramIndex, currentUser.getId());

            int rowsUpdated = stmt.executeUpdate();

            if (rowsUpdated > 0) {
                if (request.getUsername() != null && !request.getUsername().trim().isEmpty()) {
                    currentUser.setUsername(request.getUsername().trim());
                }
                currentUser.setBio(request.getBio() != null ? request.getBio().trim() : "");

                if (request.isFileUploaded() && request.getProfilePictureUrl() != null) {
                    currentUser.setProfilePictureUrl(request.getProfilePictureUrl());
                }

                if (newPasswordHash != null && newSalt != null) {
                    currentUser.setPassword(newPasswordHash);
                    currentUser.setSalt(newSalt);
                }

                response.setSuccess(true);
                response.setSuccessMessage("Profile updated successfully");
                response.setUpdatedUser(currentUser);
                response.setRedirectUrl("/editprofile");
            } else {
                response.setErrorMessage("Failed to update profile");
                response.setRedirectUrl("/editprofile");
            }

        } catch (SQLException e) {
            response.setErrorMessage("Database error: " + e.getMessage());
            response.setRedirectUrl("/editprofile");
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {}
        }
        return response;
    }

    public SettingsDeactivateResponse deactivateAccount(SettingsDeactivateRequest request) {
        SettingsDeactivateResponse response = new SettingsDeactivateResponse();

        try {
            boolean deactivated = userDAO.deactivateAccount(request.getUserId());
            if (deactivated) {
                response.setSuccess(true);
                response.setRedirectUrl("/login?deactivated=true");
            } else {
                response.setErrorMessage("Failed to deactivate account. Please try again.");
                response.setRedirectUrl("/WEB-INF/views/app/Settings/settingsaccount.jsp");
            }
        } catch (Exception e) {
            response.setErrorMessage("An error occurred while deactivating your account.");
            response.setRedirectUrl("/WEB-INF/views/app/Settings/settingsaccount.jsp");
        }
        return response;
    }

    // --- Linked Devices ---

    public SettingsLinkedDevicesResponse getLinkedDevices(SettingsLinkedDevicesRequest request) {
        SettingsLinkedDevicesResponse response = new SettingsLinkedDevicesResponse();
        
        List<UserSession> devices = userSessionDAO.getUserSessions(request.getUserId());
        for (UserSession device : devices) {
            if (device.getSessionId().equals(request.getCurrentSessionId())) {
                device.setDeviceName(device.getDeviceName() + " (This device)");
            }
        }
        
        response.setDevices(devices);
        response.setRedirectUrl("/WEB-INF/views/settings/linkeddevices.jsp");
        return response;
    }

    public SettingsLinkedDevicesResponse handleLinkedDevicesAction(SettingsLinkedDevicesRequest request) {
        SettingsLinkedDevicesResponse response = new SettingsLinkedDevicesResponse();

        if ("removeDevice".equals(request.getAction())) {
            if (request.getSessionIdToRemove() != null && !request.getSessionIdToRemove().equals(request.getCurrentSessionId())) {
                boolean removed = SessionUtil.revokeSessionById(request.getSessionIdToRemove());
                if (removed) {
                    response.setSuccess(true);
                    response.setSuccessMessage("Device removed successfully");
                } else {
                    response.setErrorMessage("Failed to remove device");
                }
            } else {
                response.setErrorMessage("Cannot remove current device");
            }
        } else if ("logoutAll".equals(request.getAction())) {
            int removedCount = userSessionDAO.revokeAllSessionsExcept(request.getUserId(), request.getCurrentSessionId());
            response.setSuccess(true);
            response.setSuccessMessage("Logged out from " + removedCount + " device(s)");
        }

        response.setRedirectUrl("/linkeddevices");
        return response;
    }

    // --- Storage Sense ---

    public SettingsStorageSenseResponse getStorageSense(SettingsStorageSenseRequest request) {
        SettingsStorageSenseResponse response = new SettingsStorageSenseResponse();

        Plan plan = subscriptionDAO.getPlanByUserId(request.getUserId());
        if (plan == null) {
            plan = new Plan(0, "Free", 5L * 1024 * 1024 * 1024, 0, 0, 1, "Free Plan", 50);
        }
        response.setPlan(plan);

        long usedStorageBytes = subscriptionDAO.getUsedStorage(request.getUserId());
        long storageLimitBytes = plan.getStorageLimitBytes();
        
        response.setUsedStorageBytes(usedStorageBytes);
        response.setStorageLimitBytes(storageLimitBytes);

        int usedPercent = storageLimitBytes > 0 ? (int) (usedStorageBytes * 100 / storageLimitBytes) : 0;
        if (usedPercent > 100) usedPercent = 100;
        response.setUsedPercent(usedPercent);

        response.setUsedFormatted(formatSize(usedStorageBytes));
        response.setTotalFormatted(formatSize(storageLimitBytes));

        if (usedPercent < 50) {
            response.setProgressBarColor("#10b981");
        } else if (usedPercent < 80) {
            response.setProgressBarColor("#f59e0b");
        } else {
            response.setProgressBarColor("#ef4444");
        }

        Map<String, Long> contentTypeBreakdown = subscriptionDAO.getStorageByContentType(request.getUserId());
        List<Map<String, Object>> contentTypeDisplay = new ArrayList<>();
        String[] colorPalette = { "#9A74D8", "#60a5fa", "#34d399", "#f59e0b", "#ef4444" };
        int colorIdx = 0;
        for (Map.Entry<String, Long> entry : contentTypeBreakdown.entrySet()) {
            Map<String, Object> ctData = new HashMap<>();
            ctData.put("name", entry.getKey());
            ctData.put("sizeFormatted", formatSize(entry.getValue()));
            long ctPercent = storageLimitBytes > 0 ? (entry.getValue() * 100 / storageLimitBytes) : 0;
            ctData.put("percent", ctPercent);
            ctData.put("color", colorPalette[colorIdx % colorPalette.length]);
            contentTypeDisplay.add(ctData);
            colorIdx++;
        }
        response.setContentTypeDisplay(contentTypeDisplay);

        List<Map<String, Object>> topMemories = subscriptionDAO.getStorageByMemory(request.getUserId(), 5);
        List<Map<String, Object>> topMemoryDisplay = new ArrayList<>();
        for (Map<String, Object> mem : topMemories) {
            Map<String, Object> memData = new HashMap<>(mem);
            Object sizeObj = mem.get("totalSize");
            long sizeVal = (sizeObj instanceof Long) ? (Long) sizeObj : ((Number) sizeObj).longValue();
            memData.put("sizeFormatted", formatSize(sizeVal));
            topMemoryDisplay.add(memData);
        }
        response.setTopMemoryDisplay(topMemoryDisplay);

        List<Map<String, Object>> topGroups = subscriptionDAO.getStorageByGroup(request.getUserId(), 5);
        List<Map<String, Object>> topGroupDisplay = new ArrayList<>();
        for (Map<String, Object> grp : topGroups) {
            Map<String, Object> grpData = new HashMap<>(grp);
            Object sizeObj = grp.get("totalSize");
            long sizeVal = (sizeObj instanceof Long) ? (Long) sizeObj : ((Number) sizeObj).longValue();
            grpData.put("sizeFormatted", formatSize(sizeVal));
            topGroupDisplay.add(grpData);
        }
        response.setTopGroupDisplay(topGroupDisplay);

        List<Map<String, Object>> duplicates = subscriptionDAO.getDuplicateFiles(request.getUserId());
        response.setDuplicateCount(duplicates.size());
        
        long duplicateSize = 0;
        for (Map<String, Object> dup : duplicates) {
            duplicateSize += (Long) dup.get("fileSize");
        }
        response.setDuplicateSize(duplicateSize);
        response.setDuplicateSizeFormatted(formatSize(duplicateSize));

        response.setTrashCount(subscriptionDAO.getTrashItemCount(request.getUserId()));
        response.setMemoryCount(subscriptionDAO.getMemoryCount(request.getUserId()));

        response.setRedirectUrl("/WEB-INF/views/app/Settings/storagesense.jsp");
        return response;
    }

    // --- Shared Links ---

    public SettingsSharedLinksResponse getSharedLinks(SettingsSharedLinksRequest request) {
        SettingsSharedLinksResponse response = new SettingsSharedLinksResponse();

        List<autograph> allAutographs = autographDAO.findByUserId(request.getUserId());
        List<autograph> sharedAutographs = new ArrayList<>();
        for (autograph a : allAutographs) {
            if (a.getShareToken() != null && !a.getShareToken().isEmpty()) {
                sharedAutographs.add(a);
            }
        }
        response.setSharedAutographs(sharedAutographs);
        response.setSharedMemories(memoryDAO.getSharedMemoriesByOwner(request.getUserId()));
        response.setSharedInvites(groupInviteDAO.findInvitesByCreator(request.getUserId()));
        
        response.setRedirectUrl("/WEB-INF/views/app/Settings/sharedlinks.jsp");
        return response;
    }

    public SettingsSharedLinksResponse revokeSharedLink(SettingsSharedLinksRequest request) {
        SettingsSharedLinksResponse response = new SettingsSharedLinksResponse();
        
        if (request.getIdStr() != null && !request.getIdStr().isEmpty()) {
            try {
                int id = Integer.parseInt(request.getIdStr());

                if ("revokeAutograph".equals(request.getAction())) {
                    autograph ag = autographDAO.findById(id);
                    if (ag != null && ag.getUserId() == request.getUserId()) {
                        autographDAO.revokeShareToken(id);
                    }
                } else if ("revokeCollab".equals(request.getAction())) {
                    Memory mem = memoryDAO.getMemoryById(id);
                    if (mem != null && mem.getUserId() == request.getUserId()) {
                        memoryDAO.setCollabShareKey(id, null);
                    }
                } else if ("revokeGroup".equals(request.getAction())) {
                    groupInviteDAO.deleteInvite(id);
                }
            } catch (Exception e) {}
        }
        response.setRedirectUrl("/sharedlinks");
        return response;
    }

    // --- Subscription Manage ---

    public SettingsSubscriptionResponse getSubscriptionDetails(SettingsSubscriptionRequest request) {
        SettingsSubscriptionResponse response = new SettingsSubscriptionResponse();

        Plan plan = subscriptionDAO.getPlanByUserId(request.getUserId());
        if (plan == null) plan = subscriptionDAO.getPlanById(1);

        long usedBytes = subscriptionDAO.getUsedStorage(request.getUserId());
        long totalBytes = plan.getStorageLimitBytes();

        response.setCurrentPlan(plan);
        response.setPlanName(plan.getName());
        response.setPlanPrice((plan.getPriceMonthly() == 0) ? "Free" : "$" + plan.getPriceMonthly() + "/mo");
        
        response.setStorageUsedFormatted(formatSize(usedBytes));
        response.setStorageTotalFormatted(formatSize(totalBytes));

        int pct = 0;
        if (totalBytes > 0) pct = (int) (((double) usedBytes / totalBytes) * 100);
        
        response.setStoragePercentage(pct);
        response.setBillingCycle((plan.getPriceMonthly() == 0) ? "—" : "Monthly");
        response.setRenewalDate("—");
        
        response.setBasicPlan("Basic".equals(plan.getName()));
        response.setNeedsMoreSpace(pct > 70);

        response.setRedirectUrl("/WEB-INF/views/app/Settings/managesubscription.jsp");
        return response;
    }

    private String formatSize(long bytes) {
        if (bytes <= 0) return "0 B";
        if (bytes < 1024) return bytes + " B";
        if (bytes < 1024 * 1024) return String.format("%.2f KB", bytes / 1024.0);
        if (bytes < 1024 * 1024 * 1024) return String.format("%.2f MB", bytes / (1024.0 * 1024));
        if (bytes < 1024L * 1024 * 1024 * 1024) return String.format("%.2f GB", bytes / (1024.0 * 1024 * 1024));
        return String.format("%.2f TB", bytes / (1024.0 * 1024 * 1024 * 1024));
    }
}
