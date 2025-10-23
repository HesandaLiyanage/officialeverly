<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<jsp:include page="../../public/header2.jsp" />
<html>
<body>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/adminsettings.css">

<!-- Page Wrapper -->
<div class="settings-page-wrapper">
    <main class="analytics-main-content">
        <!-- Page Header with Back Button -->
        <div class="page-header-nav">
            <a href="/admin" class="back-button">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                    <polyline points="15 18 9 12 15 6"></polyline>
                </svg>
            </a>
            <h1 class="page-title">Analytics</h1>
        </div>

        <!-- Analytics Grid -->
        <div class="analytics-grid">
            <!-- Left Column - Content Performance -->
            <div class="analytics-left">
                <h2 class="analytics-section-title">Content Performance</h2>

                <!-- Reporting Period Tabs -->
                <div class="reporting-period">
                    <span class="period-label">Reporting Period</span>
                    <div class="period-tabs">
                        <button class="period-tab">7D</button>
                        <button class="period-tab active">30D</button>
                        <button class="period-tab">90D</button>
                    </div>
                </div>

                <!-- Performance Cards -->
                <div class="performance-cards">
                    <!-- Uploads Over Time Card -->
                    <div class="performance-card">
                        <div class="card-header">
                            <h3 class="card-title">Uploads Over Time</h3>
                            <div class="card-stat positive">+15%</div>
                        </div>
                        <p class="card-subtitle">Last 30 Days <span class="positive">+15%</span></p>

                        <!-- Simple Chart Visualization -->
                        <div class="chart-container">
                            <svg viewBox="0 0 300 120" class="line-chart">
                                <path d="M 10,60 Q 40,30 70,50 T 130,40 T 190,70 T 250,30 T 290,45"
                                      fill="none"
                                      stroke="#6f42c1"
                                      stroke-width="3"/>
                            </svg>
                            <div class="chart-labels">
                                <span>Jan</span>
                                <span>Feb</span>
                                <span>Mar</span>
                                <span>Apr</span>
                                <span>May</span>
                            </div>
                        </div>
                    </div>

                    <!-- Popular Content Card -->
                    <div class="performance-card">
                        <div class="card-header">
                            <h3 class="card-title">Popular Content</h3>
                            <div class="card-stat negative">-8%</div>
                        </div>
                        <p class="card-subtitle">Last 7 Days <span class="negative">-8%</span></p>

                        <!-- Bar Chart Visualization -->
                        <div class="bar-chart-container">
                            <div class="bar-chart">
                                <div class="bar" style="height: 70%;"></div>
                                <div class="bar" style="height: 85%;"></div>
                                <div class="bar" style="height: 60%;"></div>
                                <div class="bar" style="height: 75%;"></div>
                                <div class="bar" style="height: 80%;"></div>
                            </div>
                            <div class="bar-labels">
                                <span>Photo<br>1</span>
                                <span>Photo<br>2</span>
                                <span>Photo<br>3</span>
                                <span>Photo<br>4</span>
                                <span>Photo<br>5</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Divider -->
            <div class="vertical-divider"></div>

            <!-- Right Column - Engagement -->
            <div class="analytics-right">
                <h2 class="analytics-section-title">Engagement</h2>

                <div class="engagement-cards">
                    <!-- Active Users -->
                    <div class="engagement-card">
                        <div class="engagement-label">Active Users</div>
                        <div class="engagement-value">12,345</div>
                        <div class="engagement-change positive">+10%</div>
                    </div>

                    <!-- Content Uploads -->
                    <div class="engagement-card">
                        <div class="engagement-label">Content<br>Uploads</div>
                        <div class="engagement-value">6,789</div>
                        <div class="engagement-change negative">-5%</div>
                    </div>

                    <!-- Platform Activity -->
                    <div class="engagement-card full-width">
                        <div class="engagement-label">Platform Activity</div>
                        <div class="engagement-value">3,456</div>
                        <div class="engagement-change positive">+2%</div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<jsp:include page="../../public/footer.jsp" />
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Period tab switching
        const periodTabs = document.querySelectorAll('.period-tab');
        periodTabs.forEach(tab => {
            tab.addEventListener('click', function() {
                periodTabs.forEach(t => t.classList.remove('active'));
                this.classList.add('active');
                console.log('Selected period:', this.textContent);
            });
        });
    });
</script>
</body>
</html>