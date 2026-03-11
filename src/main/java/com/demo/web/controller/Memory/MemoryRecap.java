package com.demo.web.controller.Memory;

import com.demo.web.dao.Memory.MemoryRecapDAO;
import com.demo.web.model.Memory.Memory;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;

/**
 * Servlet for Memory Recap page.
 * Fetches random memories grouped by time, event, and group and forwards to
 * JSP.
 */
public class MemoryRecap extends HttpServlet {

    private MemoryRecapDAO recapDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        recapDAO = new MemoryRecapDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check if user is logged in
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");

        try {
            int memoriesPerBundle = 10; // max memories per recap card

            // --- Fetch all 3 categories ---
            List<Map<String, Object>> timeRecaps = recapDAO.getTimeRecaps(userId, memoriesPerBundle);
            List<Map<String, Object>> eventRecaps = recapDAO.getEventRecaps(userId, 5, memoriesPerBundle);
            List<Map<String, Object>> groupRecaps = recapDAO.getGroupRecaps(userId, 5, memoriesPerBundle);

            // For each recap, resolve cover images for the memories
            resolveCovers(request, timeRecaps);
            resolveCovers(request, eventRecaps);
            resolveCovers(request, groupRecaps);

            // Combine all recaps into one randomized list for "All" view
            List<Map<String, Object>> allRecaps = new ArrayList<>();
            for (Map<String, Object> r : timeRecaps) {
                r.put("category", "time");
                allRecaps.add(r);
            }
            for (Map<String, Object> r : eventRecaps) {
                r.put("category", "event");
                allRecaps.add(r);
            }
            for (Map<String, Object> r : groupRecaps) {
                r.put("category", "group");
                allRecaps.add(r);
            }
            Collections.shuffle(allRecaps);

            // --- Stats for sidebar ---
            int totalMemories = recapDAO.getTotalMemoryCount(userId);
            int totalEvents = recapDAO.getTotalEventCount(userId);
            int totalGroups = recapDAO.getTotalGroupCount(userId);

            // Set attributes
            request.setAttribute("allRecaps", allRecaps);
            request.setAttribute("timeRecaps", timeRecaps);
            request.setAttribute("eventRecaps", eventRecaps);
            request.setAttribute("groupRecaps", groupRecaps);
            request.setAttribute("totalMemories", totalMemories);
            request.setAttribute("totalEvents", totalEvents);
            request.setAttribute("totalGroups", totalGroups);

            System.out.println("[MemoryRecapServlet] Loaded " + allRecaps.size() + " recap bundles for user " + userId);
            System.out.println("[MemoryRecapServlet] Time: " + timeRecaps.size() +
                    ", Event: " + eventRecaps.size() +
                    ", Group: " + groupRecaps.size());

            // Forward to JSP
            request.getRequestDispatcher("/WEB-INF/views/app/Memory/memoryrecap.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading memory recaps: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/app/Memory/memoryrecap.jsp").forward(request, response);
        }
    }

    /**
     * For each recap bundle, resolve cover image URLs for each memory in the
     * bundle.
     */
    private void resolveCovers(HttpServletRequest request, List<Map<String, Object>> recaps) {
        for (Map<String, Object> recap : recaps) {
            @SuppressWarnings("unchecked")
            List<Memory> memories = (List<Memory>) recap.get("memories");
            if (memories != null) {
                for (Memory memory : memories) {
                    try {
                        // Use cover_media_id if set, otherwise get first media
                        Integer mediaId = memory.getCoverMediaId();
                        if (mediaId == null) {
                            mediaId = recapDAO.getFirstMediaIdForMemory(memory.getMemoryId());
                        }
                        if (mediaId != null) {
                            String coverUrl = request.getContextPath() + "/viewMedia?mediaId=" + mediaId;
                            memory.setCoverUrl(coverUrl);
                        }
                    } catch (Exception e) {
                        System.err.println("[MemoryRecapServlet] Error resolving cover for memory "
                                + memory.getMemoryId() + ": " + e.getMessage());
                    }
                }
            }
        }
    }
}
