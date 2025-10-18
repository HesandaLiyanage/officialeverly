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
        duplicates.add(new DuplicateFile("Vacation Photo 1", "vacation_photo_1.jpg", "2.5MB", "2024-01-20", "images/vacation1.jpg"));
        duplicates.add(new DuplicateFile("Vacation Photo 1 (Copy)", "vacation_photo_1_copy.jpg", "2.5MB", "2024-01-20", "images/vacation1copy.jpg"));
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
        response.sendRedirect("duplicateContent.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Duplicate Content | Everly</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/settings.css">
</head>
<body>
<jsp:include page="../public/header2.jsp" />
<div class="settings-container">
    <h2>Settings</h2>

    <<div class="settings-tabs">
    <a href="/settingsaccount" class="tab">Account</a>
    <a href="/settingsprivacy" class="tab">Privacy & Security</a>
    <a href="#" class="tab active">Storage Sense</a>
    <a href="/settingsnotifications" class="tab">Notifications</a>
    <a href="/settingsappearance" class="tab">Appearance</a>
</div>

    <div class="back-option">
        <a href="${pageContext.request.contextPath}/fragments/storagesense.jsp" class="back-link">&#8592; Back</a>
    </div>

    <h2>Duplicate Content</h2>

    <div class="duplicate-list">
        <%
            if (duplicates.isEmpty()) {
        %>
        <p style="color:#777;">No duplicate content found.</p>
        <%
        } else {
            for (DuplicateFile file : duplicates) {
        %>
        <div class="duplicate-item">
            <div class="duplicate-left">
                <img src="<%= file.imagePath %>" alt="<%= file.title %>" class="duplicate-thumb">
                <div class="duplicate-info">
                    <p class="duplicate-title"><%= file.title %></p>
                    <p class="duplicate-details">
                        File Name: <%= file.fileName %><br>
                        Size: <%= file.size %>, Added: <%= file.date %>
                    </p>
                </div>
            </div>
            <form method="post" action="duplicateContent.jsp">
                <input type="hidden" name="deleteTitle" value="<%= file.title %>">
                <button type="submit" class="delete-btn">&#128465;</button>
            </form>
        </div>
        <%
                }
            }
        %>
    </div>
</div>

<script>
    function navigateTo(tab) {
        window.location.href = tab + ".jsp";
    }
</script>

<jsp:include page="../public/footer.jsp" />
</body>
</html>
