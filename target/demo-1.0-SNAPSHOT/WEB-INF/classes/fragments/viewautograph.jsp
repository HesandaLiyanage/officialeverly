<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Autograph Book</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/autograph.css">
</head>
<body>
<jsp:include page="/fragments/header2.jsp" />
<div class="main-content">
    <h1 class="main-title">Autograph Book</h1>

    <div class="tab-container">
        <button class="tab-btn active" id="viewTab" onclick="showTab('view')">View</button>
        <button class="tab-btn" id="addTab" onclick="showTab('add')">Add</button>
    </div>

    <!-- View Section -->
    <div id="viewSection" class="tab-section">
        <h3 class="page-label">Page 1</h3>

        <div class="autograph-grid">
            <div class="autograph-card">
                <img src="images/grad1.jpg" alt="Graduate 1">
            </div>
            <div class="autograph-card">
                <img src="images/grad2.jpg" alt="Graduate 2">
            </div>
            <div class="autograph-card">
                <img src="images/grad3.jpg" alt="Graduate 3">
            </div>
            <div class="autograph-card">
                <img src="images/grad4.jpg" alt="Graduate 4">
            </div>
        </div>

        <div class="autograph-texts">
            <p>Congratulations on your graduation, Sarah! Wishing you all the best in your future endeavors. – Emily</p>
            <p>Sarah, it's been a pleasure knowing you. Best of luck! – David</p>
        </div>

        <div class="pagination">
            <span class="page-arrow" onclick="prevPage()">&lt;</span>
            <span class="page-number active">1</span>
            <span class="page-number">2</span>
            <span class="page-number">3</span>
            <span class="page-number">4</span>
            <span class="page-number">5</span>
            <span class="page-arrow" onclick="nextPage()">&gt;</span>
        </div>
    </div>

    <!-- Add Section -->
    <div id="addSection" class="tab-section">
        <div class="create-book-container">
            <form class="create-book-form">
                <div class="section">
                    <label for="name">Name</label>
                    <input type="text" id="name" placeholder="Your name">
                </div>

                <div class="section">
                    <label for="message">Message</label>
                    <textarea id="message" placeholder="Write your autograph message here..."></textarea>
                </div>

                <div class="section">
                    <label for="photo">Upload Photo</label>
                    <div class="upload-box" onclick="document.getElementById('photo').click()">
                        <input type="file" id="photo" accept="image/*">
                        <p class="upload-text">Click to upload image</p>
                    </div>
                </div>

                <!-- NEW: Voice Note Upload -->
                <div class="section">
                    <label for="voiceNote">Add Voice Note</label>
                    <div class="upload-box" onclick="document.getElementById('voiceNote').click()">
                        <input type="file" id="voiceNote" accept="audio/*">
                        <p class="upload-text">Click to upload voice note (MP3/WAV)</p>
                    </div>
                </div>

                <!-- NEW: Video Upload -->
                <div class="section">
                    <label for="videoFile">Add Video</label>
                    <div class="upload-box" onclick="document.getElementById('videoFile').click()">
                        <input type="file" id="videoFile" accept="video/*">
                        <p class="upload-text">Click to upload video</p>
                    </div>
                </div>

                <!-- NEW: Sticker Selection -->
                <div class="section">
                    <label>Select a Sticker</label>
                    <div class="sticker-grid">
                        <div class="sticker-item" onclick="selectSticker(this)">
                            <img src="stickers/happy.png" alt="Happy Sticker">
                        </div>
                        <div class="sticker-item" onclick="selectSticker(this)">
                            <img src="stickers/love.png" alt="Love Sticker">
                        </div>
                        <div class="sticker-item" onclick="selectSticker(this)">
                            <img src="stickers/wink.png" alt="Wink Sticker">
                        </div>
                        <div class="sticker-item" onclick="selectSticker(this)">
                            <img src="stickers/graduation.png" alt="Graduation Sticker">
                        </div>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="button" class="btn cancel" onclick="showTab('view')">Cancel</button>
                    <button type="submit" class="btn create">Add Autograph</button>
                </div>
            </form>
        </div>
    </div>

<script>
    function showTab(tab) {
        const viewTab = document.getElementById('viewTab');
        const addTab = document.getElementById('addTab');
        const viewSection = document.getElementById('viewSection');
        const addSection = document.getElementById('addSection');

        if (tab === 'view') {
            viewTab.classList.add('active');
            addTab.classList.remove('active');
            viewSection.classList.remove('hidden');
            addSection.classList.add('hidden');
        } else {
            addTab.classList.add('active');
            viewTab.classList.remove('active');
            addSection.classList.remove('hidden');
            viewSection.classList.add('hidden');
        }
    }

    // Pagination placeholders
    function prevPage() { alert('Previous page'); }
    function nextPage() { alert('Next page'); }
    function selectSticker(element) {
        document.querySelectorAll('.sticker-item').forEach(item => item.classList.remove('selected'));
        element.classList.add('selected');
    }
</script>
<jsp:include page="/fragments/footer.jsp" />
</body>
</html>
