package com.demo.web.service;

import com.demo.web.dao.Journals.JournalDAO;
import com.demo.web.dao.Journals.JournalStreakDAO;
import com.demo.web.dao.Journals.RecycleBinDAO;
import com.demo.web.dao.Autographs.autographDAO;
import com.demo.web.model.Journals.Journal;
import com.demo.web.model.Journals.JournalStreak;
import com.demo.web.model.Journals.RecycleBinItem;
import com.demo.web.dto.Journals.*;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.ArrayList;

public class JournalService {

    private final JournalDAO journalDAO;
    private final JournalStreakDAO streakDAO;
    private final RecycleBinDAO rbDao;
    private final autographDAO autographDAO;

    public JournalService() {
        this.journalDAO = new JournalDAO();
        this.streakDAO = new JournalStreakDAO();
        this.rbDao = new RecycleBinDAO();
        this.autographDAO = new autographDAO();
    }

    public List<Journal> getJournalsByUserId(int userId) {
        return journalDAO.findByUserId(userId);
    }

    public Journal getJournalById(int journalId, int userId) {
        Journal result = journalDAO.findById(journalId);
        if (result == null || result.getUserId() != userId) {
            return null;
        }
        return result;
    }

    public int getJournalCount(int userId) {
        return journalDAO.getJournalCount(userId);
    }

    public JournalStreak getStreakInfo(int userId) {
        streakDAO.checkAndUpdateStreakStatus(userId);
        return streakDAO.getStreakByUserId(userId);
    }

    public int getCurrentStreakDays(int userId) {
        JournalStreak streak = getStreakInfo(userId);
        return streak != null ? streak.getCurrentStreak() : 0;
    }

    public int getLongestStreakDays(int userId) {
        JournalStreak streak = getStreakInfo(userId);
        return streak != null ? streak.getLongestStreak() : 0;
    }

    // --- DTO METHODS ---

    public JournalCreateResponse createJournal(JournalCreateRequest request) {
        JournalCreateResponse response = new JournalCreateResponse();
        
        if (request.getContent() == null || request.getContent().trim().isEmpty() || request.getContent().equals("<br>")) {
            response.setErrorMessage("Please write something in your journal!");
            response.setRedirectUrl("/writejournal");
            return response;
        }

        String journalTitle = generateDateTitle();
        String completeContent = buildCompleteJournalContent(request.getContent(), request.getDecorationsJson(), request.getBackgroundTheme());

        Journal newJournal = new Journal();
        newJournal.setTitle(journalTitle);
        newJournal.setContent(completeContent);
        newJournal.setUserId(request.getUserId());
        newJournal.setJournalPic(null);

        boolean success = journalDAO.createJournal(newJournal);

        if (success) {
            try {
                java.sql.Date today = new java.sql.Date(System.currentTimeMillis());
                streakDAO.updateStreakOnNewEntry(request.getUserId(), today);
            } catch (Exception e) { }
            
            response.setSuccess(true);
            response.setRedirectUrl("/journals");
        } else {
            response.setErrorMessage("Failed to save journal entry. Please try again.");
            response.setRedirectUrl("/writejournal");
        }
        return response;
    }

    public JournalEditResponse editJournal(JournalEditRequest request) {
        JournalEditResponse response = new JournalEditResponse();

        if (request.getJournalIdStr() == null || request.getJournalIdStr().trim().isEmpty()) {
            response.setErrorMessage("Journal ID is required.");
            response.setRedirectUrl("/journals");
            return response;
        }

        try {
            int journalId = Integer.parseInt(request.getJournalIdStr());
            Journal journal = getJournalById(journalId, request.getUserId());
            
            if (journal == null) {
                response.setErrorMessage("Journal entry not found or you do not have permission.");
                response.setRedirectUrl("/journals");
                return response;
            }

            if (request.getContent() == null || request.getContent().trim().isEmpty() || request.getContent().equals("<br>")) {
                response.setErrorMessage("Please write something in your journal!");
                response.setJournal(journal);
                response.setRedirectUrl("/WEB-INF/views/app/Journals/editjournal.jsp");
                return response;
            }

            String updatedContent = buildCompleteJournalContent(request.getContent(), request.getDecorationsJson(), request.getBackgroundTheme());
            String journalTitle = (request.getTitle() != null && !request.getTitle().trim().isEmpty()) ? request.getTitle() : journal.getTitle();

            journal.setTitle(journalTitle);
            journal.setContent(updatedContent);

            boolean success = journalDAO.updateJournal(journal);

            if (success) {
                response.setSuccess(true);
                response.setRedirectUrl("/journalview?id=" + journalId);
            } else {
                response.setErrorMessage("Failed to update journal entry.");
                response.setJournal(journal);
                response.setRedirectUrl("/WEB-INF/views/app/Journals/editjournal.jsp");
            }
        } catch (NumberFormatException e) {
            response.setErrorMessage("Invalid Journal ID.");
            response.setRedirectUrl("/journals");
        }
        return response;
    }

    public JournalDeleteResponse deleteJournal(JournalDeleteRequest request) {
        JournalDeleteResponse response = new JournalDeleteResponse();
        if (request.getJournalIdStr() == null) {
            response.setRedirectUrl("/journals");
            return response;
        }
        try {
            int journalId = Integer.parseInt(request.getJournalIdStr());
            boolean success = journalDAO.deleteJournalToRecycleBin(journalId, request.getUserId());
            if (success) {
                response.setRedirectUrl("/journals?msg=Journal moved to Recycle Bin");
            } else {
                response.setRedirectUrl("/journals?error=Failed to delete journal");
            }
        } catch (NumberFormatException e) {
            response.setRedirectUrl("/journals?error=Invalid journal ID");
        }
        return response;
    }

    public JournalTrashResponse getTrash(JournalTrashRequest request) {
        JournalTrashResponse response = new JournalTrashResponse();
        
        List<RecycleBinItem> journalItems = rbDao.findByUserId(request.getUserId());
        List<RecycleBinItem> autographItems = rbDao.findAutographsByUserId(request.getUserId());
        
        List<RecycleBinItem> trashItems = new ArrayList<>();
        trashItems.addAll(journalItems);
        trashItems.addAll(autographItems);
        
        trashItems.sort((a, b) -> {
            if (a.getDeletedAt() == null && b.getDeletedAt() == null) return 0;
            if (a.getDeletedAt() == null) return 1;
            if (b.getDeletedAt() == null) return -1;
            return b.getDeletedAt().compareTo(a.getDeletedAt());
        });
        
        response.setTrashItems(trashItems);
        response.setSuccess(true);
        return response;
    }

    public JournalTrashResponse handleTrashAction(JournalTrashRequest request) {
        JournalTrashResponse response = new JournalTrashResponse();
        
        if (request.getRecycleBinIdStr() == null || request.getRecycleBinIdStr().isEmpty()) {
            response.setRedirectUrl("/trashmgt?error=Invalid item");
            return response;
        }

        try {
            int recycleBinId = Integer.parseInt(request.getRecycleBinIdStr());
            String action = request.getAction();
            
            if ("permanentDelete".equals(action)) {
                boolean success = rbDao.deleteFromRecycleBin(recycleBinId);
                response.setRedirectUrl(success ? "/trashmgt?msg=Item permanently deleted" : "/trashmgt?error=Failed to delete");
            } else if ("restore".equals(action)) {
                RecycleBinItem item = rbDao.findById(recycleBinId);
                if (item == null || item.getUserId() != request.getUserId()) {
                    response.setRedirectUrl("/trashmgt?error=Item not found");
                    return response;
                }
                
                boolean success = false;
                if ("journal".equals(item.getItemType())) {
                    success = journalDAO.restoreJournalFromRecycleBin(recycleBinId, request.getUserId());
                } else if ("autograph".equals(item.getItemType())) {
                    success = autographDAO.restoreAutographFromRecycleBin(recycleBinId, request.getUserId());
                }
                
                if (success) {
                    response.setRedirectUrl("/trashmgt?msg=" + item.getItemType().substring(0, 1).toUpperCase() + item.getItemType().substring(1) + " restored successfully");
                } else {
                    response.setRedirectUrl("/trashmgt?error=Failed to restore");
                }
            } else {
                response.setRedirectUrl("/trashmgt?error=Unknown action");
            }
        } catch (NumberFormatException e) {
            response.setRedirectUrl("/trashmgt?error=Invalid ID");
        }
        return response;
    }

    public JournalDashboardResponse getDashboard(JournalDashboardRequest request) {
        JournalDashboardResponse response = new JournalDashboardResponse();

        try {
            int streakDays = getCurrentStreakDays(request.getUserId());
            int longestStreak = getLongestStreakDays(request.getUserId());
            List<Journal> journals = getJournalsByUserId(request.getUserId());
            int totalCount = getJournalCount(request.getUserId());

            Map<Integer, Integer> wordCounts = buildWordCounts(journals);

            response.setStreakDays(streakDays);
            response.setLongestStreak(longestStreak);
            response.setJournals(journals);
            response.setTotalCount(totalCount);
            response.setWordCounts(wordCounts);
        } catch (Exception e) {
            response.setError("An error occurred: " + e.getMessage());
        }

        return response;
    }

    public JournalViewResponse getJournalViewData(JournalViewRequest request) {
        JournalViewResponse response = new JournalViewResponse();
        response.setSuccess(false);

        try {
            if (request.getJournalIdParam() == null || request.getJournalIdParam().trim().isEmpty()) {
                response.setErrorMessage("Journal ID is required.");
                return response;
            }

            int journalId = Integer.parseInt(request.getJournalIdParam());
            Journal journal = getJournalById(journalId, request.getUserId());

            if (journal == null) {
                response.setErrorMessage("Journal entry not found or no permission.");
                return response;
            }

            response.setJournal(journal);
            response.setSuccess(true);
        } catch (NumberFormatException e) {
            response.setErrorMessage("Invalid Journal ID.");
        } catch (Exception e) {
            response.setErrorMessage("An error occurred while loading the journal.");
        }

        return response;
    }

    public JournalEditFormResponse getJournalEditFormData(JournalEditFormRequest request) {
        JournalEditFormResponse response = new JournalEditFormResponse();
        response.setSuccess(false);

        try {
            if (request.getJournalIdParam() == null || request.getJournalIdParam().trim().isEmpty()) {
                response.setErrorMessage("Journal ID is required.");
                return response;
            }

            int journalId = Integer.parseInt(request.getJournalIdParam());
            Journal journal = getJournalById(journalId, request.getUserId());

            if (journal == null) {
                response.setErrorMessage("Journal entry not found or no permission.");
                return response;
            }

            response.setJournal(journal);
            response.setSuccess(true);
        } catch (NumberFormatException e) {
            response.setErrorMessage("Invalid Journal ID.");
        } catch (Exception e) {
            response.setErrorMessage("An error occurred while loading the journal.");
        }

        return response;
    }

    private Map<Integer, Integer> buildWordCounts(List<Journal> journals) {
        Map<Integer, Integer> wordCounts = new HashMap<>();

        for (Journal journal : journals) {
            int wordCount = 0;
            String rawContent = journal.getContent();
            if (rawContent != null && !rawContent.isEmpty()) {
                try {
                    com.google.gson.JsonObject cObj = new com.google.gson.Gson().fromJson(rawContent, com.google.gson.JsonObject.class);
                    String htmlText = cObj.get("htmlContent").getAsString();
                    String plainText = htmlText.replaceAll("<[^>]*>", "").trim();
                    if (!plainText.isEmpty()) {
                        wordCount = plainText.split("\\s+").length;
                    }
                } catch (Exception e) {
                }
            }
            wordCounts.put(journal.getJournalId(), wordCount);
        }

        return wordCounts;
    }

    private String buildCompleteJournalContent(String htmlContent, String decorationsJson, String backgroundTheme) {
        StringBuilder jsonBuilder = new StringBuilder();
        jsonBuilder.append("{");
        jsonBuilder.append("\"htmlContent\":").append(escapeJson(htmlContent)).append(",");
        jsonBuilder.append("\"decorations\":").append(decorationsJson != null ? decorationsJson : "[]").append(",");
        jsonBuilder.append("\"backgroundTheme\":").append(escapeJson(backgroundTheme != null ? backgroundTheme : ""));
        jsonBuilder.append("}");
        return jsonBuilder.toString();
    }

    private String escapeJson(String text) {
        if (text == null) return "\"\"";
        return "\"" + text.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r").replace("\t", "\\t") + "\"";
    }

    private String generateDateTitle() {
        Date now = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("d");
        String day = sdf.format(now);
        String suffix = "th";
        if (day.endsWith("1") && !day.endsWith("11")) { suffix = "st"; }
        else if (day.endsWith("2") && !day.endsWith("12")) { suffix = "nd"; }
        else if (day.endsWith("3") && !day.endsWith("13")) { suffix = "rd"; }
        sdf = new SimpleDateFormat("MMMM yyyy");
        return day + suffix + " " + sdf.format(now);
    }
}
