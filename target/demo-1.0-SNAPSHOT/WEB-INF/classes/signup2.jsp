<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile Setup - Everly</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/signup.css">
</head>
<body>

<main class="profile-container">
    <h1 class="profile-title">Tell us about Yourself</h1>

    <form class="profile-form" action="${pageContext.request.contextPath}/view?page=saveprofile" method="post" enctype="multipart/form-data">

        <!-- Name Field -->
        <label for="name" class="profile-label">Name</label>
        <input type="text" id="name" name="name" class="profile-input" placeholder="Enter your name" required>

        <!-- Bio Field -->
        <label for="bio" class="profile-label">Bio</label>
        <textarea id="bio" name="bio" class="profile-textarea" placeholder="Write a short bio..." rows="4"></textarea>

        <!-- Profile Picture -->
        <label for="profilePicture" class="profile-label">Profile Picture</label>
        <div class="profile-picture-container">
            <input type="file" id="profilePicture" name="profilePicture" accept="image/*" class="profile-file-input">
        </div>

        <!-- Buttons -->
        <div class="profile-actions">
            <button type="submit" class="btn btn-primary">
                <a href="${pageContext.request.contextPath}/landingContent.jsp">Next</a>
            </button>
            <button type="button" onclick="window.history.back()" class="btn btn-secondary">
                <a href="${pageContext.request.contextPath}/fragments/signup.jsp">Back</a>
            </button>
        </div>
    </form>
</main>

</body>
</html>
