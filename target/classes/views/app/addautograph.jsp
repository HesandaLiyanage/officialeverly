<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Create a New Autograph Book</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/autograph.css">
</head>
<body>
<jsp:include page="../public/header2.jsp" />
<div class="main-content">
    <div class="create-book-container">
        <h1 class="main-title">Create a New Autograph Book</h1>
        <p class="subtext">Fill in the details to create your new book and start collecting memories.</p>

        <form action="saveBook.jsp" method="post" enctype="multipart/form-data" class="create-book-form">
            <!-- Book Details -->
            <div class="section">
                <h3>Book Details</h3>
                <label for="bookTitle">Book Title</label>
                <input type="text" id="bookTitle" name="bookTitle" placeholder="e.g., Graduation 2024, Summer Vacation" required>

                <label for="description">Description</label>
                <textarea id="description" name="description" placeholder="A short description of your book's theme"></textarea>

                <label>Cover Image</label>
                <div class="upload-box" id="dropArea">
                    <input type="file" name="coverImage" id="fileInput" accept="image/png, image/jpeg, image/gif">
                    <p><span class="upload-text">Upload a file</span> or drag and drop<br>PNG, JPG, GIF up to 10MB</p>
                </div>
            </div>

            <!-- Share With -->
            <div class="section">
                <h3>Share With</h3>
                <div class="share-input">
                    <span class="share-icon">👥</span>
                    <input type="text" id="shareWith" name="shareWith" placeholder="Invite friends or groups by name or email">
                </div>

                <div class="share-tags">
                    <span class="tag">Sarah Miller ×</span>
                    <span class="tag">Family Group ×</span>
                </div>
            </div>

            <!-- Add Your Own Memory -->
            <div class="section">
                <h3>Add Your Own Memory</h3>
                <p class="section-subtext">You can add your own message, photos, or voice notes to start the book.</p>

                <div class="memory-options">
                    <button type="button" class="memory-btn"><span>🎙️</span> Voice Note</button>
                    <button type="button" class="memory-btn"><span>🖼️</span> Image</button>
                    <button type="button" class="memory-btn"><span>🎥</span> Video</button>
                    <button type="button" class="memory-btn"><span>💌</span> Sticker</button>
                </div>
            </div>

            <!-- Actions -->
            <div class="form-actions">
                <button type="button" class="btn cancel">Cancel</button>
                <button type="submit" class="btn create">Create Book</button>
            </div>
        </form>
    </div>
</div>

<script>
    // Simple drag & drop for file input
    const dropArea = document.getElementById('dropArea');
    const fileInput = document.getElementById('fileInput');

    dropArea.addEventListener('click', () => fileInput.click());

    dropArea.addEventListener('dragover', (e) => {
        e.preventDefault();
        dropArea.classList.add('dragover');
    });

    dropArea.addEventListener('dragleave', () => dropArea.classList.remove('dragover'));

    dropArea.addEventListener('drop', (e) => {
        e.preventDefault();
        dropArea.classList.remove('dragover');
        fileInput.files = e.dataTransfer.files;
    });
</script>
<jsp:include page="../public/footer.jsp" />
</body>
</html>
