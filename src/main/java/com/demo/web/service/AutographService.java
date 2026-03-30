package com.demo.web.service;

import com.demo.web.dao.Autographs.AutographEntryDAO;
import com.demo.web.dao.Autographs.autographDAO;
import com.demo.web.dao.Autographs.AutographActivityDAO;
import com.demo.web.dao.Notifications.NotificationDAO;
import com.demo.web.model.Autographs.AutographActivity;
import com.demo.web.model.Autographs.AutographEntry;
import com.demo.web.model.Autographs.autograph;
import com.demo.web.dto.Autographs.*;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import java.util.Collections;
import java.util.List;

public class AutographService {

    private final autographDAO autographDAO;
    private final AutographEntryDAO entryDAO;
    private final AutographActivityDAO activityDAO;
    private final NotificationDAO notifDAO;

    public AutographService() {
        this.autographDAO = new autographDAO();
        this.entryDAO = new AutographEntryDAO();
        this.activityDAO = new AutographActivityDAO();
        this.notifDAO = new NotificationDAO();
    }

    public List<autograph> getAutographsByUserId(int userId) {
        return autographDAO.findByUserId(userId);
    }

    public autograph getAutographById(int autographId, int userId) {
        autograph result = autographDAO.findById(autographId);
        if (result == null || result.getUserId() != userId) {
            return null;
        }
        return result;
    }

    public autograph getAutographByIdUnsafe(int autographId) {
        return autographDAO.findById(autographId);
    }

    // --- DTO MAPPINGS LOGIC ---
    
    public AutographCreateResponse createAutograph(AutographCreateRequest request) {
        AutographCreateResponse response = new AutographCreateResponse();

        if (request.getTitle() == null || request.getTitle().trim().isEmpty()) {
            response.setErrorMessage("Book Title is required.");
            response.setRedirectUrl("/addautograph");
            return response;
        }

        autograph newAutograph = new autograph();
        newAutograph.setTitle(request.getTitle());
        newAutograph.setDescription(request.getDescription());
        newAutograph.setUserId(request.getUserId());
        newAutograph.setAutographPicUrl(request.getPicUrl());

        boolean success = autographDAO.createAutograph(newAutograph);

        if (success) {
            response.setSuccess(true);
            response.setRedirectUrl("/autographs");
        } else {
            response.setErrorMessage("Failed to create autograph book.");
            response.setRedirectUrl("/addautograph");
        }
        return response;
    }

    public AutographUpdateResponse updateAutograph(AutographUpdateRequest request) {
        AutographUpdateResponse response = new AutographUpdateResponse();

        if (request.getAutographIdStr() == null || request.getAutographIdStr().trim().isEmpty()) {
            response.setRedirectUrl("/autographs");
            return response;
        }

        try {
            int autographId = Integer.parseInt(request.getAutographIdStr().trim());
            autograph existingAutograph = autographDAO.findById(autographId);

            if (existingAutograph == null || existingAutograph.getUserId() != request.getUserId()) {
                response.setRedirectUrl("/autographs");
                return response;
            }

            autograph updatedAutograph = new autograph();
            updatedAutograph.setAutographId(autographId);
            updatedAutograph.setTitle(request.getTitle());
            updatedAutograph.setDescription(request.getDescription());
            updatedAutograph.setAutographPicUrl(request.isFileUploaded() ? request.getNewPicUrl() : existingAutograph.getAutographPicUrl());
            updatedAutograph.setUserId(request.getUserId());

            boolean success = autographDAO.updateAutograph(updatedAutograph);

            if (success) {
                response.setSuccess(true);
                response.setRedirectUrl("/autographview?id=" + autographId);
            } else {
                response.setRedirectUrl("/autographs?error=update_failed");
            }
        } catch (NumberFormatException e) {
            response.setRedirectUrl("/autographs");
        } catch (Exception e) {
            response.setRedirectUrl("/autographs?error=unexpected_error");
        }
        return response;
    }

    public AutographDeleteResponse deleteAutograph(AutographDeleteRequest request) {
        AutographDeleteResponse response = new AutographDeleteResponse();

        if (request.getAutographIdStr() == null || request.getAutographIdStr().trim().isEmpty()) {
            response.setRedirectUrl("/autographs");
            return response;
        }

        try {
            int autographId = Integer.parseInt(request.getAutographIdStr());
            boolean success = autographDAO.deleteAutographToRecycleBin(autographId, request.getUserId());
            
            if (success) {
                response.setSuccess(true);
                response.setRedirectUrl("/autographs?msg=Autograph book moved to Recycle Bin");
            } else {
                response.setRedirectUrl("/autographs?error=Failed to delete autograph book");
            }
        } catch (NumberFormatException e) {
            response.setRedirectUrl("/autographs?error=Invalid ID");
        }
        return response;
    }

    public AutographShareResponse generateShareLink(AutographShareRequest request) {
        AutographShareResponse response = new AutographShareResponse();

        if (request.getAutographIdStr() == null || request.getAutographIdStr().isEmpty()) {
            response.setJsonOutput("{\"success\": false, \"error\": \"Missing autographId parameter\"}");
            return response;
        }

        try {
            int autographId = Integer.parseInt(request.getAutographIdStr());
            autograph ag = autographDAO.findById(autographId);
            
            if (ag == null) {
                response.setJsonOutput("{\"success\": false, \"error\": \"Autograph not found\"}");
                return response;
            }
            if (ag.getUserId() != request.getUserId()) {
                response.setJsonOutput("{\"success\": false, \"error\": \"You don't own this autograph\"}");
                return response;
            }

            String token = autographDAO.getOrCreateShareToken(autographId);
            
            // Just returning token in jsonOutput so Controller can construct full URL
            response.setSuccess(true);
            response.setJsonOutput("{\"success\": true, \"token\": \"" + token + "\"}");

        } catch (NumberFormatException e) {
            response.setJsonOutput("{\"success\": false, \"error\": \"Invalid autograph ID\"}");
        } catch (Exception e) {
            response.setJsonOutput("{\"success\": false, \"error\": \"Server error\"}");
        }
        return response;
    }

    public AutographEntrySubmitResponse submitEntry(AutographEntrySubmitRequest request) {
        AutographEntrySubmitResponse response = new AutographEntrySubmitResponse();

        if (request.getToken() == null || request.getToken().isEmpty()) {
            response.setMessage("Invalid share token.");
            return response;
        }
        if (request.getContent() == null || request.getContent().trim().isEmpty()) {
            response.setMessage("Please write a message.");
            return response;
        }
        if (request.getAuthor() == null || request.getAuthor().trim().isEmpty()) {
            response.setMessage("Please enter your name.");
            return response;
        }

        try {
            autograph ag = autographDAO.getAutographByShareToken(request.getToken());

            if (ag == null) {
                response.setMessage("Autograph book not found or link has expired.");
                return response;
            }

            AutographEntry entry = new AutographEntry();
            entry.setAutographId(ag.getAutographId());
            entry.setUserId(request.getUserId());
            entry.setContent(request.getContent());
            entry.setContentPlain(request.getContentPlain() != null ? request.getContentPlain() : "");
            entry.setLink(request.getToken());

            boolean saved = entryDAO.createEntry(entry);

            if (saved) {
                response.setSuccess(true);
                response.setMessage("Autograph submitted successfully!");
                try {
                    int ownerUserId = ag.getUserId();
                    notifDAO.createNotification(
                            ownerUserId,
                            "comments_reactions",
                            "New Autograph Entry",
                            "wrote in your autograph book",
                            "/autographs",
                            request.getUserId());
                } catch (Exception ex) {}
            } else {
                response.setMessage("Failed to save your autograph. Please try again.");
            }

        } catch (Exception e) {
            response.setStatusCode(500);
            response.setMessage("Server error.");
        }
        return response;
    }

    public AutographDashboardResponse getDashboard(AutographDashboardRequest request) {
        AutographDashboardResponse response = new AutographDashboardResponse();

        try {
            String action = request.getAction();
            if ("view".equals(action) && request.getIdParam() != null) {
                int autographId = Integer.parseInt(request.getIdParam());
                autograph autographDetail = getAutographById(autographId, request.getUserId());

                if (autographDetail == null) {
                    response.setRedirectUrl("/autographs");
                    return response;
                }

                response.setView(true);
                response.setAutograph(autographDetail);
                
                try {
                    List<AutographEntry> entries = entryDAO.findByAutographId(autographId);
                    response.setEntries(entries);
                    Gson gson = new GsonBuilder().disableHtmlEscaping().create();
                    response.setEntriesJson(gson.toJson(entries != null ? entries : Collections.emptyList()));
                    response.setEntryCount(entries != null ? entries.size() : 0);
                } catch (Exception e) {
                    response.setEntries(Collections.emptyList());
                    response.setEntriesJson("[]");
                    response.setEntryCount(0);
                }
                
                response.setRedirectUrl("/WEB-INF/views/app/Autographs/viewautograph.jsp");

            } else if ("edit".equals(action) && request.getIdParam() != null) {
                int autographId = Integer.parseInt(request.getIdParam());
                autograph autographToEdit = getAutographById(autographId, request.getUserId());

                if (autographToEdit == null) {
                    response.setRedirectUrl("/autographs");
                    return response;
                }

                response.setEdit(true);
                response.setAutograph(autographToEdit);
                response.setRedirectUrl("/WEB-INF/views/app/Autographs/editautograph.jsp");

            } else {
                response.setList(true);
                response.setAutographs(getAutographsByUserId(request.getUserId()));
                
                try {
                    List<AutographActivity> recentActivities = activityDAO.findByAutographOwner(request.getUserId(), 5);
                    response.setRecentActivities(recentActivities);
                } catch (Exception e) {
                    response.setRecentActivities(Collections.emptyList());
                }
                
                response.setRedirectUrl("/WEB-INF/views/app/Autographs/autographcontent.jsp");
            }

        } catch (NumberFormatException e) {
            response.setRedirectUrl("/autographs");
        }
        return response;
    }

    public AutographWriteResponse getWriteView(AutographWriteRequest request) {
        AutographWriteResponse response = new AutographWriteResponse();

        if (request.getToken() == null || request.getToken().isEmpty()) {
            response.setErrorCode(404);
            return response;
        }

        try {
            autograph ag = autographDAO.getAutographByShareToken(request.getToken());

            if (ag == null) {
                response.setErrorCode(404);
                return response;
            }
            
            response.setSuccess(true);
            response.setAutograph(ag);
            response.setShareToken(request.getToken());
            response.setDisplayTitle(ag.getTitle() != null ? ag.getTitle() : "Autograph Book");
            response.setRedirectUrl("/WEB-INF/views/app/Autographs/writeautograph.jsp");

        } catch (Exception e) {
            response.setErrorCode(500);
        }
        return response;
    }
}
