package com.demo.web.service;

import com.demo.web.dao.Vault.VaultDAO;
import com.demo.web.dao.Journals.JournalDAO;
import com.demo.web.dao.Memory.memoryDAO;
import com.demo.web.dao.Memory.MediaDAO;
import com.demo.web.dto.Vault.*;
import com.demo.web.model.Journals.Journal;
import com.demo.web.model.Memory.Memory;
import com.demo.web.model.Memory.MediaItem;
import com.demo.web.util.VaultUtil;

import java.sql.SQLException;
import java.util.List;

public class VaultService {

    private VaultDAO vaultDAO;
    private memoryDAO memoryDao;
    private JournalDAO journalDAO;
    private MediaDAO mediaDAO;

    public VaultService() {
        this.vaultDAO = new VaultDAO();
        this.memoryDao = new memoryDAO();
        this.journalDAO = new JournalDAO();
        this.mediaDAO = new MediaDAO();
    }

    public VaultSetupGetResponse getSetupState(VaultSetupGetRequest request) {
        VaultSetupGetResponse response = new VaultSetupGetResponse();
        response.setHasSetup(vaultDAO.hasVaultSetup(request.getUserId()));
        return response;
    }

    public VaultSetupPostResponse setupVault(VaultSetupPostRequest request) {
        VaultSetupPostResponse response = new VaultSetupPostResponse();
        
        if (request.getPassword() == null || request.getPassword().isEmpty()) {
            response.setErrorMessage("Password is required");
            return response;
        }

        if (!VaultUtil.isValidVaultPassword(request.getPassword())) {
            response.setErrorMessage(VaultUtil.getVaultPasswordRequirementsMessage());
            return response;
        }

        if (!request.getPassword().equals(request.getConfirmPassword())) {
            response.setErrorMessage("Passwords do not match");
            return response;
        }

        try {
            boolean success = vaultDAO.setupVaultPassword(request.getUserId(), request.getPassword());
            if (success) {
                response.setSuccess(true);
            } else {
                response.setErrorMessage("Failed to set up vault. Please try again.");
            }
        } catch (Exception e) {
            response.setErrorMessage("An error occurred. Please try again.");
        }
        return response;
    }

    public VaultEntryPostResponse verifyEntry(VaultEntryPostRequest request) {
        VaultEntryPostResponse response = new VaultEntryPostResponse();
        
        if (request.getPassword() == null || request.getPassword().isEmpty()) {
            response.setErrorMessage("Password is required");
            return response;
        }

        try {
            boolean isValid = vaultDAO.verifyVaultPassword(request.getUserId(), request.getPassword());
            response.setValid(isValid);
            if (!isValid) {
                response.setErrorMessage("Incorrect password. Please try again.");
            }
        } catch (Exception e) {
            response.setErrorMessage("An error occurred. Please try again.");
        }
        return response;
    }

    public VaultPasswordChangePostResponse changePassword(VaultPasswordChangePostRequest request) {
        VaultPasswordChangePostResponse response = new VaultPasswordChangePostResponse();
        
        if (request.getCurrentPassword() == null || request.getCurrentPassword().isEmpty()) {
            response.setErrorMessage("Current password is required");
            return response;
        }

        if (request.getNewPassword() == null || request.getNewPassword().isEmpty()) {
            response.setErrorMessage("New password is required");
            return response;
        }

        if (!VaultUtil.isValidVaultPassword(request.getNewPassword())) {
            response.setErrorMessage(VaultUtil.getVaultPasswordRequirementsMessage());
            return response;
        }

        if (!request.getNewPassword().equals(request.getConfirmPassword())) {
            response.setErrorMessage("New passwords do not match");
            return response;
        }

        try {
            boolean success = vaultDAO.changeVaultPassword(request.getUserId(), request.getCurrentPassword(), request.getNewPassword());
            if (success) {
                response.setSuccess(true);
                response.setSuccessMessage("Vault password changed successfully!");
            } else {
                response.setErrorMessage("Current password is incorrect");
            }
        } catch (Exception e) {
            response.setErrorMessage("An error occurred. Please try again.");
        }
        return response;
    }

    public VaultMemoriesResponse getVaultMemories(VaultMemoriesRequest request, String contextPath) {
        VaultMemoriesResponse response = new VaultMemoriesResponse();
        
        if (!vaultDAO.hasVaultSetup(request.getUserId())) {
            response.setHasSetup(false);
            return response;
        }
        response.setHasSetup(true);

        boolean isUnlocked = false;
        
        // If password provided (POST), verify it
        if (request.getVaultPassword() != null) {
            if (vaultDAO.verifyVaultPassword(request.getUserId(), request.getVaultPassword())) {
                isUnlocked = true;
            } else {
                response.setErrorMessage("Invalid vault password");
            }
        } 
        // If no password provided (GET), check session
        else if (request.getVaultUnlockedSession() != null && request.getVaultUnlockedSession()) {
            isUnlocked = true;
        }
        
        response.setAccessGranted(isUnlocked);

        if (isUnlocked) {
            try {
                List<Memory> vaultMemories = memoryDao.getVaultMemoriesByUserId(request.getUserId());
                for (Memory memory : vaultMemories) {
                    if (memory.getCoverMediaId() != null) {
                        try {
                            MediaItem coverMedia = mediaDAO.getMediaById(memory.getCoverMediaId());
                            if (coverMedia != null) {
                                memory.setCoverUrl(contextPath + "/viewmedia?id=" + coverMedia.getMediaId());
                            }
                        } catch (SQLException ignore) {}
                    }
                }
                response.setMemories(vaultMemories);
            } catch (SQLException e) {
                response.setErrorMessage("Error loading vault memories");
            }
        }
        return response;
    }

    public VaultJournalsResponse getVaultJournals(VaultJournalsRequest request) {
        VaultJournalsResponse response = new VaultJournalsResponse();
        
        if (!vaultDAO.hasVaultSetup(request.getUserId())) {
            response.setHasSetup(false);
            return response;
        }
        response.setHasSetup(true);

        boolean isUnlocked = false;
        
        if (request.getVaultPassword() != null) {
            if (vaultDAO.verifyVaultPassword(request.getUserId(), request.getVaultPassword())) {
                isUnlocked = true;
            } else {
                response.setErrorMessage("Invalid vault password");
            }
        } else if (request.getVaultUnlockedSession() != null && request.getVaultUnlockedSession()) {
            isUnlocked = true;
        }
        
        response.setAccessGranted(isUnlocked);

        if (isUnlocked) {
            List<Journal> vaultJournals = journalDAO.getVaultJournalsByUserId(request.getUserId());
            response.setJournals(vaultJournals);
        }
        return response;
    }

    public VaultMoveItemResponse moveItem(VaultMoveItemRequest request) {
        VaultMoveItemResponse response = new VaultMoveItemResponse();
        
        if (request.getType() == null || request.getIdStr() == null || request.getAction() == null) {
            response.setErrorMessage("Missing required parameters");
            return response;
        }

        int id;
        try {
            id = Integer.parseInt(request.getIdStr());
        } catch (NumberFormatException e) {
            response.setErrorMessage("Invalid ID");
            return response;
        }

        if (!vaultDAO.hasVaultSetup(request.getUserId())) {
            response.setErrorMessage("Vault not set up");
            response.setRedirectToSetup(true);
            return response;
        }

        if ("add".equals(request.getAction())) {
            if (request.getVaultPassword() == null || request.getVaultPassword().isEmpty()) {
                response.setErrorMessage("Vault password required");
                response.setRequiresPassword(true);
                return response;
            }

            if (!vaultDAO.verifyVaultPassword(request.getUserId(), request.getVaultPassword())) {
                response.setErrorMessage("Incorrect vault password");
                return response;
            }
        }

        boolean success = false;
        try {
            if ("memory".equals(request.getType())) {
                if ("add".equals(request.getAction())) {
                    success = memoryDao.moveToVault(id, request.getUserId());
                } else if ("remove".equals(request.getAction())) {
                    success = memoryDao.removeFromVault(id, request.getUserId());
                }
            } else if ("journal".equals(request.getType())) {
                if ("add".equals(request.getAction())) {
                    success = journalDAO.moveToVault(id, request.getUserId());
                } else if ("remove".equals(request.getAction())) {
                    success = journalDAO.removeFromVault(id, request.getUserId());
                }
            } else {
                response.setErrorMessage("Invalid type");
                return response;
            }
        } catch (SQLException e) {
            response.setErrorMessage("Database error");
            return response;
        }

        if (success) {
            response.setSuccess(true);
            String displayType = request.getType().substring(0, 1).toUpperCase() + request.getType().substring(1);
            if ("add".equals(request.getAction())) {
                response.setSuccessMessage(displayType + " moved to vault");
            } else {
                response.setSuccessMessage(displayType + " restored from vault");
            }
        } else {
            response.setErrorMessage("Failed to " + (request.getAction().equals("add") ? "move to" : "remove from") + " vault");
        }
        
        return response;
    }
}
