<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="../public/header2.jsp"/>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Family Memories - Everly</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/groupmemories.css">
    <link href="https://fonts.googleapis.com/css2?family=Epilogue:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="header.css">
    <link rel="stylesheet" href="footer.css">
</head>
<body>

<!-- Main Content -->
<main class="container">
    <div class="page-header">
        <h1>Family Memories</h1>
        <p>Created by You.</p>
    </div>

    <!-- Tab Navigation -->
    <div class="tab-nav">
        <a href="#" class="tab-btn active">Memories</a>
        <a href="${pageContext.request.contextPath}/groupannouncement.jsp" class="tab-btn">Announcements</a>
        <a href="${pageContext.request.contextPath}/groupmembers.jsp" class="tab-btn">Members</a>
    </div>

    <!-- Memories Grid -->
    <div class="memories-grid">

        <!-- Memory Card 1 -->
        <a href="${pageContext.request.contextPath}/memoryinfo.jsp?memoryId=1" class="memory-card-link">
            <div class="memory-card">
                <div class="memory-image" style="background-image: url('https://via.placeholder.com/300x200?text=Beach+Family')"></div>
                <div class="memory-content">
                    <h3 class="memory-title">Summer Beach Trip</h3>
                    <p class="memory-date">June 15, 2023</p>
                </div>
            </div>
        </a>

        <!-- Memory Card 2 -->
        <a href="${pageContext.request.contextPath}/memoryinfo.jsp?memoryId=2" class="memory-card-link">
            <div class="memory-card">
                <div class="memory-image" style="background-image: url('https://via.placeholder.com/300x200?text=Family+Dinner')"></div>
                <div class="memory-content">
                    <h3 class="memory-title">Holiday Dinner</h3>
                    <p class="memory-date">Dec 24, 2023</p>
                </div>
            </div>
        </a>

        <!-- Memory Card 3 -->
        <a href="${pageContext.request.contextPath}/memoryinfo.jsp?memoryId=3" class="memory-card-link">
            <div class="memory-card">
                <div class="memory-image" style="background-image: url('https://via.placeholder.com/300x200?text=Vacation+Door')"></div>
                <div class="memory-content">
                    <h3 class="memory-title">Safe Vacation</h3>
                    <p class="memory-date">Aug 5, 2023</p>
                </div>
            </div>
        </a>

        <!-- Memory Card 4 -->
        <a href="${pageContext.request.contextPath}/memoryinfo.jsp?memoryId=4" class="memory-card-link">
            <div class="memory-card">
                <div class="memory-image" style="background-image: url('https://via.placeholder.com/300x200?text=Family+Beach+Walk')"></div>
                <div class="memory-content">
                    <h3 class="memory-title">Beach Walk</h3>
                    <p class="memory-date">Jul 22, 2023</p>
                </div>
            </div>
        </a>

        <!-- Memory Card 5 -->
        <a href="${pageContext.request.contextPath}/memoryinfo.jsp?memoryId=5" class="memory-card-link">
            <div class="memory-card">
                <div class="memory-image" style="background-image: url('https://via.placeholder.com/300x200?text=Family+Photo+Shoot')"></div>
                <div class="memory-content">
                    <h3 class="memory-title">Photo Shoot Day</h3>
                    <p class="memory-date">May 10, 2023</p>
                </div>
            </div>
        </a>

        <!-- Memory Card 6 -->
        <a href="${pageContext.request.contextPath}/memoryinfo.jsp?memoryId=6" class="memory-card-link">
            <div class="memory-card">
                <div class="memory-image" style="background-image: url('https://via.placeholder.com/300x200?text=Family+Picnic')"></div>
                <div class="memory-content">
                    <h3 class="memory-title">Picnic in Park</h3>
                    <p class="memory-date">Sep 3, 2023</p>
                </div>
            </div>
        </a>

        <!-- Memory Card 7 -->
        <a href="${pageContext.request.contextPath}/memoryinfo.jsp?memoryId=7" class="memory-card-link">
            <div class="memory-card">
                <div class="memory-image" style="background-image: url('https://via.placeholder.com/300x200?text=Family+Hiking')"></div>
                <div class="memory-content">
                    <h3 class="memory-title">Mountain Hike</h3>
                    <p class="memory-date">Oct 12, 2023</p>
                </div>
            </div>
        </a>

        <!-- Memory Card 8 -->
        <a href="${pageContext.request.contextPath}/memoryinfo.jsp?memoryId=8" class="memory-card-link">
            <div class="memory-card">
                <div class="memory-image" style="background-image: url('https://via.placeholder.com/300x200?text=Family+Reunion')"></div>
                <div class="memory-content">
                    <h3 class="memory-title">Grand Reunion</h3>
                    <p class="memory-date">Nov 1, 2023</p>
                </div>
            </div>
        </a>

        <!-- Memory Card 9 -->
        <a href="${pageContext.request.contextPath}/memoryinfo.jsp?memoryId=9" class="memory-card-link">
            <div class="memory-card">
                <div class="memory-image" style="background-image: url('https://via.placeholder.com/300x200?text=Family+Wedding')"></div>
                <div class="memory-content">
                    <h3 class="memory-title">Cousin's Wedding</h3>
                    <p class="memory-date">Apr 20, 2023</p>
                </div>
            </div>
        </a>

        <!-- Memory Card 10 -->
        <a href="${pageContext.request.contextPath}/memoryinfo.jsp?memoryId=10" class="memory-card-link">
            <div class="memory-card">
                <div class="memory-image" style="background-image: url('https://via.placeholder.com/300x200?text=Family+Road+Trip')"></div>
                <div class="memory-content">
                    <h3 class="memory-title">Road Trip Adventure</h3>
                    <p class="memory-date">Mar 8, 2023</p>
                </div>
            </div>
        </a>

    </div>

    <!-- Add Memory Button -->
    <button class="add-memory-btn" onclick="window.location.href='${pageContext.request.contextPath}/addmemory.jsp'">Add Memory</button>

</main>

<!-- Include Footer -->
<jsp:include page="../public/footer.jsp"/>


<script>
    // Optional: Keep "Memories" tab active if user clicks it again
    document.querySelectorAll('.tab-btn').forEach(btn => {
        btn.addEventListener('click', function(e) {
            // If it's the "Memories" tab (href="#"), prevent default to stay on page
            if (this.getAttribute('href') === '#') {
                e.preventDefault();
                document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
                this.classList.add('active');
            }
            // Other tabs will redirect via href
        });
    });
</script>

</body>
</html>