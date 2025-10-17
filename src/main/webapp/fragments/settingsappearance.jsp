<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Appearance Settings</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/settings.css">
    <script>
        // Theme switch functionality
        function setTheme(theme) {
            document.body.classList.remove("light-theme", "dark-theme");
            if (theme === "light") {
                document.body.classList.add("light-theme");
                localStorage.setItem("theme", "light");
            } else if (theme === "dark") {
                document.body.classList.add("dark-theme");
                localStorage.setItem("theme", "dark");
            } else {
                localStorage.removeItem("theme");
            }

            // Update active button styling
            const buttons = document.querySelectorAll(".theme-btn");
            buttons.forEach(btn => btn.classList.remove("active"));
            document.getElementById(theme + "-btn").classList.add("active");
        }

        // Load saved theme preference
        window.onload = function() {
            const savedTheme = localStorage.getItem("theme");
            if (savedTheme) setTheme(savedTheme);
            else setTheme("system");
        }
        function navigateTo(page) {
            window.location.href = page + ".jsp";
        }
    </script>
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

    <div class="account-section">
        <h3>Appearance</h3>

        <div class="theme-section">
            <div class="theme-info">
                <div class="icon">🌞</div>
                <div>
                    <p class="title">Theme</p>
                    <p class="desc">Choose how Memories looks to you.</p>
                </div>
            </div>
            <div class="theme-buttons">
                <button id="light-btn" class="theme-btn" onclick="setTheme('light')">Light</button>
                <button id="dark-btn" class="theme-btn" onclick="setTheme('dark')">Dark</button>
                <button id="system-btn" class="theme-btn active" onclick="setTheme('system')">System Default</button>
            </div>
        </div>

        <div class="more-themes">
            <p class="more-title">More themes</p>

            <div class="themes-grid">
                <div class="theme-card">
                    <div class="theme-thumb aesthetic"></div>
                    <p class="theme-name">Aesthetic</p>
                </div>

                <div class="theme-card">
                    <div class="theme-thumb dark"></div>
                    <p class="theme-name">Dark</p>
                </div>

                <div class="theme-card">
                    <div class="theme-thumb system"></div>
                    <p class="theme-name">System Default</p>
                </div>

                <div class="theme-card">
                    <div class="theme-thumb premium"></div>
                    <p class="theme-name">Premium Theme 1</p>
                </div>

                <button class="more-btn"><a href="${pageContext.request.contextPath}/fragments/morethemes.jsp" style="text-decoration: none;">More</button>
            </div>
        </div>
    </div>
</div>
<jsp:include page="/fragments/footer.jsp" />
</body>
</html>
