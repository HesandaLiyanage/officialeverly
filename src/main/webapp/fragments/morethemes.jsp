<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Appearance Settings</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/settings.css">
</head>
<body>
<jsp:include page="/fragments/header2.jsp" />
<div class="settings-container">
    <h2>Settings</h2>

    <div class="settings-tabs">
        <button class="tab" onclick="navigateTo('settingsaccount')">Account</button>
        <button class="tab" onclick="navigateTo('settingsprivacy')">Privacy & Security</button>
        <button class="tab" onclick="navigateTo('storagesense')">Storage Sense</button>
        <button class="tab" onclick="navigateTo('settingsnotifications')">Notifications</button>
        <button class="tab active">Appearance</button>
    </div>

    <div class="back-option">
        <a href="settingsappearance.jsp" class="back-link">← Back</a>
    </div>

    <h2>More Themes</h2>

    <form action="saveTheme.jsp" method="post" id="themeForm">
        <div class="themes-grid">
            <!-- Example Theme Cards -->
            <div class="theme-card" data-theme="light">
                <div class="theme-thumb light"></div>
                <p class="theme-name">Light</p>
            </div>
            <div class="theme-card" data-theme="dark">
                <div class="theme-thumb dark"></div>
                <p class="theme-name">Dark</p>
            </div>
            <div class="theme-card" data-theme="aesthetic">
                <div class="theme-thumb aesthetic"></div>
                <p class="theme-name">Aesthetic</p>
            </div>
            <div class="theme-card" data-theme="system">
                <div class="theme-thumb system"></div>
                <p class="theme-name">System</p>
            </div>
            <div class="theme-card" data-theme="premium">
                <div class="theme-thumb premium"></div>
                <p class="theme-name">Premium</p>
            </div>
        </div>

        <input type="hidden" name="selectedTheme" id="selectedTheme">

        <div class="action-buttons">
            <button type="button" class="btn restore" id="restoreBtn">Restore Default</button>
            <button type="submit" class="btn save">Save Changes</button>
        </div>
    </form>
</div>

<script>
    // Handle theme selection
    const cards = document.querySelectorAll('.theme-card');
    const hiddenInput = document.getElementById('selectedTheme');

    cards.forEach(card => {
        card.addEventListener('click', () => {
            cards.forEach(c => c.classList.remove('active'));
            card.classList.add('active');
            hiddenInput.value = card.dataset.theme;
        });
    });

    // Handle Restore Default
    document.getElementById('restoreBtn').addEventListener('click', () => {
        cards.forEach(c => c.classList.remove('active'));
        hiddenInput.value = "";
        alert("Theme restored to default.");
    });

    function navigateTo(tab) {
        window.location.href = tab + ".jsp";
    }
</script>
<jsp:include page="/fragments/footer.jsp" />
</body>
</html>
