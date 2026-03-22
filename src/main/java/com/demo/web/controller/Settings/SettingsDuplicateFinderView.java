package com.demo.web.controller.Settings;

import com.demo.web.dao.Settings.SubscriptionDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

/**
 * View controller for the Duplicate Finder page.
 * Pre-computes grouped duplicate data with formatted values
 * so the JSP can use JSTL/EL instead of scriptlets.
 */
@WebServlet("/duplicatefinderview")
public class SettingsDuplicateFinderView extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = (Integer) request.getSession().getAttribute("user_id");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        SubscriptionDAO subDAO = new SubscriptionDAO();
        List<Map<String, Object>> duplicates = subDAO.getDuplicateFiles(userId);

        // Group duplicates by fileSize + mimeType
        Map<String, List<Map<String, Object>>> groupedDups = new LinkedHashMap<>();
        for (Map<String, Object> dup : duplicates) {
            String key = dup.get("fileSize") + "_" + dup.get("mimeType");
            groupedDups.computeIfAbsent(key, k -> new ArrayList<>()).add(dup);
        }

        SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy");

        int totalDuplicates = duplicates.size();
        long totalDupSize = 0;
        for (Map<String, Object> d : duplicates) {
            totalDupSize += (Long) d.get("fileSize");
        }

        // Build display-ready grouped data
        List<Map<String, Object>> groupDisplayData = new ArrayList<>();

        for (Map.Entry<String, List<Map<String, Object>>> entry : groupedDups.entrySet()) {
            List<Map<String, Object>> group = entry.getValue();
            if (group.size() < 2) continue;

            long groupFileSize = (Long) group.get(0).get("fileSize");
            String mimeType = (String) group.get(0).get("mimeType");

            // Determine icon
            String icon = "&#128196;"; // 📄
            if (mimeType != null) {
                if (mimeType.startsWith("image/")) icon = "&#128444;"; // 🖼
                else if (mimeType.startsWith("video/")) icon = "&#127909;"; // 🎥
                else if (mimeType.startsWith("audio/")) icon = "&#127925;"; // 🎵
            }

            Map<String, Object> groupData = new HashMap<>();
            groupData.put("count", group.size());
            groupData.put("mimeType", mimeType != null ? mimeType : "unknown");
            groupData.put("sizeFormatted", formatSize(groupFileSize));
            groupData.put("icon", icon);

            // Pre-process items in this group
            List<Map<String, Object>> itemsDisplay = new ArrayList<>();
            for (Map<String, Object> dup : group) {
                Map<String, Object> itemData = new HashMap<>();
                String title = (String) dup.get("title");
                String memoryTitle = (String) dup.get("memoryTitle");
                java.sql.Timestamp uploadDate = (java.sql.Timestamp) dup.get("uploadDate");
                String dateStr = uploadDate != null ? dateFormat.format(uploadDate) : "Unknown";
                int mediaId = (Integer) dup.get("mediaId");
                Object memIdObj = dup.get("memoryId");
                int memoryId = (memIdObj != null) ? (Integer) memIdObj : 0;
                if (title == null || title.isEmpty()) title = "File #" + mediaId;

                itemData.put("title", title);
                itemData.put("memoryTitle", memoryTitle);
                itemData.put("dateStr", dateStr);
                itemData.put("sizeFormatted", formatSize(groupFileSize));
                itemData.put("memoryId", memoryId);
                itemData.put("icon", icon);
                itemsDisplay.add(itemData);
            }

            groupData.put("items", itemsDisplay);
            groupDisplayData.add(groupData);
        }

        // Set request attributes
        request.setAttribute("totalDuplicates", totalDuplicates);
        request.setAttribute("totalDupSizeFormatted", formatSize(totalDupSize));
        request.setAttribute("groupDisplayData", groupDisplayData);

        request.getRequestDispatcher("/WEB-INF/views/app/Settings/duplicatefinder.jsp").forward(request, response);
    }

    private String formatSize(long bytes) {
        if (bytes <= 0) return "0 B";
        if (bytes < 1024) return bytes + " B";
        if (bytes < 1024 * 1024) return String.format("%.1f KB", bytes / 1024.0);
        if (bytes < 1024L * 1024 * 1024) return String.format("%.1f MB", bytes / (1024.0 * 1024));
        return String.format("%.2f GB", bytes / (1024.0 * 1024 * 1024));
    }
}
