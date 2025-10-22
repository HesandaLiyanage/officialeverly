<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>

<%
    // Define a basic class for duplicate content
    class DuplicateFile {
        String title, fileName, size, date, imagePath;
        DuplicateFile(String title, String fileName, String size, String date, String imagePath) {
            this.title = title;
            this.fileName = fileName;
            this.size = size;
            this.date = date;
            this.imagePath = imagePath;
        }
    }

    // Retrieve duplicate files from session or create sample data
    List<DuplicateFile> duplicates = (List<DuplicateFile>) session.getAttribute("duplicateFiles");

    if (duplicates == null) {
        duplicates = new ArrayList<>();
        duplicates.add(new DuplicateFile("Vacation Photo 1", "vacation_photo_1.jpg", "2.5MB", "2024-01-20", "https://images.unsplash.com/photo-1507525428034-b723cf961d3e"));
        duplicates.add(new DuplicateFile("Vacation Photo 1 (Copy)", "vacation_photo_1_copy.jpg", "2.5MB", "2024-01-20", "https://images.unsplash.com/photo-1507525428034-b723cf961d3e"));
        duplicates.add(new DuplicateFile("Beach Memories", "beach_memories.jpg", "3.2MB", "2024-03-02", "https://images.unsplash.com/photo-1493558103817-58b2924bce98"));
        duplicates.add(new DuplicateFile("Beach Memories (Copy)", "beach_memories_copy.jpg", "3.2MB", "2024-03-02", "https://images.unsplash.com/photo-1493558103817-58b2924bce98"));
        session.setAttribute("duplicateFiles", duplicates);
    }

    // --- DELETE FUNCTIONALITY ---
    String deleteTitle = request.getParameter("deleteTitle");
    if (deleteTitle != null && !deleteTitle.isEmpty()) {
        Iterator<DuplicateFile> iterator = duplicates.iterator();
        while (iterator.hasNext()) {
            DuplicateFile file = iterator.next();
            if (file.title.equals(deleteTitle)) {
                iterator.remove();
                break;
            }
        }
        session.setAttribute("duplicateFiles", duplicates);
        response.sendRedirect("duplicatefinder.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Duplicate Content | Everly</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/settings.css">
    <style>
        /* Extra styles specific to Duplicate Finder */
        .duplicate-list {
            margin-top: 20px;
        }

        .duplicate-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #eee;
            padding: 15px 0;
        }

        .duplicate-left {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .duplicate-thumb {
            width: 60px;
            height: 60px;
            border-radius: 8px;
            object-fit: cover;
            background-color: #f0f0f0;
        }

        .duplicate-info {
            display: flex;
            flex-direction: column;
        }

        .duplicate-title {
            font-weight: 600;
            font-size: 15px;
            color: #222;
            margin: 0 0 4px 0;
        }

        .duplicate-details {
            font-size: 13px;
            color: #777;
        }

        .delete-btn {
            background-color: #d00000;
            border: none;
            color: white;
            font-size: 14px;
            font-weight: 600;
            padding: 8px 14px;
            border-radius: 6px;
            cursor: pointer;
            transition: background-color 0.3s ease;
            border-color: #d00000;
        }

        .delete-btn:hover {
            background-color: #e60000;
        }

        .empty-message {
            text-align: center;
            color: #777;
            font-style: italic;
            margin-top: 20px;
        }
    </style>
</head>
<body>
<jsp:include page="../public/header2.jsp" />

<div class="settings-container">
    <h2>Settings</h2>

    <div class="settings-tabs">
        <a href="/settingsaccount" class="tab">Account</a>
        <a href="/settingsprivacy" class="tab">Privacy & Security</a>
        <a href="#" class="tab active">Storage Sense</a>
        <a href="/settingsnotifications" class="tab">Notifications</a>
        <a href="/settingsappearance" class="tab">Appearance</a>
    </div>

    <button class="filter-btn">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
            <polyline points="15 18 9 12 15 6"></polyline>
        </svg>
            <a href="/storagesense" class="back-link">Back</a>
    </button>

    <h2>Duplicate Content</h2>

    <div class="duplicate-list">
        <%
            if (duplicates.isEmpty()) {
        %>
        <p class="empty-message">No duplicate content found.</p>
        <%
        } else {
            for (DuplicateFile file : duplicates) {
        %>
        <div class="duplicate-item">
            <div class="duplicate-left">
                <img src="<%= file.imagePath %>?auto=format&fit=crop&w=80&h=80&q=60"
                     alt="<%= file.title %>"
                     class="duplicate-thumb">
                <div class="duplicate-info">
                    <p class="duplicate-title"><%= file.title %></p>
                    <p class="duplicate-details">
                        File Name: <%= file.fileName %><br>
                        Size: <%= file.size %>, Added: <%= file.date %>
                    </p>
                </div>
            </div>
            <form method="post" action="duplicatefinder.jsp">
                <input type="hidden" name="deleteTitle" value="<%= file.title %>">
                <button type="submit" class="delete-btn">Delete</button>
            </form>
        </div>
        <%
                }
            }
        %>
    </div>
</div>

<jsp:include page="../public/footer.jsp" />
</body>
</html>
