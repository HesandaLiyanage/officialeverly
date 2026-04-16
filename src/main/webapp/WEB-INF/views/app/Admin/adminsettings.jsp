<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Settings - Everly</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/dashboard-styles.css">
    <style>
        .flash-message {
            padding: 1rem 1.5rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            font-weight: 500;
        }
        .flash-message.success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .flash-message.error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .settings-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 1.5rem;
            align-items: start;
        }
        .settings-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.08);
            padding: 1.5rem;
        }
        .settings-card h2 {
            margin: 0 0 1rem;
            font-size: 1.15rem;
            color: #1a202c;
        }
        .settings-card p {
            color: #4a5568;
            line-height: 1.6;
        }
        .plan-form {
            border: 1px solid #e2e8f0;
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 1rem;
        }
        .plan-form:last-child {
            margin-bottom: 0;
        }
        .plan-header {
            display: flex;
            justify-content: space-between;
            gap: 1rem;
            align-items: flex-start;
            margin-bottom: 1rem;
        }
        .plan-title {
            font-weight: 700;
            color: #1a202c;
            font-size: 1rem;
        }
        .plan-meta {
            color: #718096;
            font-size: 0.9rem;
            margin-top: 0.25rem;
        }
        .plan-badge {
            background: #eef2ff;
            color: #4c51bf;
            border-radius: 999px;
            padding: 0.35rem 0.75rem;
            font-size: 0.8rem;
            font-weight: 600;
            white-space: nowrap;
        }
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
            margin-bottom: 1rem;
        }
        .field-label {
            display: block;
            margin-bottom: 0.4rem;
            font-size: 0.9rem;
            font-weight: 600;
            color: #2d3748;
        }
        .field-input {
            width: 100%;
            border: 1px solid #cbd5e0;
            border-radius: 8px;
            padding: 0.65rem 0.75rem;
            font-size: 0.95rem;
        }
        .field-help {
            display: block;
            margin-top: 0.3rem;
            color: #718096;
            font-size: 0.8rem;
        }
        .save-btn {
            background: #5b4cdb;
            color: white;
            border: none;
            border-radius: 8px;
            padding: 0.7rem 1rem;
            font-weight: 600;
            cursor: pointer;
        }
        .summary-list {
            display: grid;
            gap: 0.8rem;
        }
        .summary-item {
            background: #f7fafc;
            border-radius: 10px;
            padding: 0.9rem 1rem;
        }
        .summary-name {
            font-weight: 700;
            color: #1a202c;
        }
        .summary-value {
            color: #4a5568;
            margin-top: 0.2rem;
            font-size: 0.9rem;
        }
        .callout {
            border-left: 4px solid #5b4cdb;
            padding: 0.9rem 1rem;
            background: #f8f7ff;
            color: #4a5568;
            border-radius: 8px;
            margin-top: 1rem;
        }
        @media (max-width: 980px) {
            .settings-grid,
            .form-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="logo" onclick="navigateTo('overview')">Everly</div>
        <div class="header-right">
            <div class="search-box">
                <input type="text" placeholder="Search plans..." id="searchInput" disabled>
                <span class="search-icon">⌕</span>
            </div>
            <button class="logout-btn" onclick="handleLogout()">Logout</button>
        </div>
    </div>

    <div class="container">
        <div class="sidebar">
            <div class="sidebar-title">Dashboard</div>
            <div class="nav-item" onclick="navigateTo('overview')">
                <span>○</span> Overview
            </div>
            <div class="nav-item" onclick="navigateTo('analytics')">
                <span>▢</span> Analytics & Reports
            </div>
            <div class="nav-item" onclick="navigateTo('users')">
                <span>▢</span> User Management
            </div>
            <div class="nav-item" onclick="navigateTo('content')">
                <span>▢</span> Content Management
            </div>
            <div class="nav-item active" onclick="navigateTo('settings')">
                <span>▢</span> Settings
            </div>
        </div>

        <div class="main-content">
            <div class="page-header">
                <div class="page-title-section">
                    <h1 class="page-title">Admin Settings</h1>
                    <p class="page-subtitle">PLAN LIMITS AND USEFUL SYSTEM CONTROLS</p>
                </div>
            </div>

            <c:if test="${not empty flashMessage}">
                <div class="flash-message ${flashType}">${flashMessage}</div>
            </c:if>

            <div class="settings-grid">
                <div class="settings-card">
                    <h2>Subscription Caps</h2>
                    <p>
                        These limits directly affect the app because memory creation and storage checks already
                        read from the <code>plans</code> table. Updating the Basic plan here immediately changes
                        the free-tier cap logic used by the memory feature.
                    </p>

                    <c:forEach var="plan" items="${planSummaries}">
                        <form class="plan-form" method="post" action="${pageContext.request.contextPath}/adminsettingsaction">
                            <input type="hidden" name="planId" value="${plan.planId}">

                            <div class="plan-header">
                                <div>
                                    <div class="plan-title">${plan.name}</div>
                                    <div class="plan-meta">
                                        ${plan.userCount} user(s) on this plan
                                        <c:if test="${plan.priceMonthly > 0}">
                                            • $<fmt:formatNumber value="${plan.priceMonthly}" minFractionDigits="2" maxFractionDigits="2"/> / month
                                        </c:if>
                                    </div>
                                </div>
                                <div class="plan-badge">${plan.maxMembers} member max</div>
                            </div>

                            <div class="form-grid">
                                <div>
                                    <label class="field-label" for="storageLimitGb_${plan.planId}">Storage Cap (GB)</label>
                                    <input class="field-input" id="storageLimitGb_${plan.planId}" type="number" min="1" name="storageLimitGb" value="${plan.storageLimitGb}" required>
                                    <span class="field-help">Current stored value: ${plan.storageLimitGb} GB</span>
                                </div>
                                <div>
                                    <label class="field-label" for="memoryLimit_${plan.planId}">Memory Cap</label>
                                    <input class="field-input" id="memoryLimit_${plan.planId}" type="number" min="-1" name="memoryLimit" value="${plan.memoryLimit}" required>
                                    <span class="field-help">Use <code>-1</code> for unlimited.</span>
                                </div>
                            </div>

                            <button type="submit" class="save-btn">Save Plan Limits</button>
                        </form>
                    </c:forEach>
                </div>

                <div class="settings-card">
                    <h2>What Is Real vs Placeholder</h2>
                    <div class="summary-list">
                        <div class="summary-item">
                            <div class="summary-name">Implemented now</div>
                            <div class="summary-value">Free/basic storage cap and memory cap management through the existing <code>plans</code> table.</div>
                        </div>
                        <div class="summary-item">
                            <div class="summary-name">Still placeholder before</div>
                            <div class="summary-value">Default language, app name, and fake storage labels in the old settings mockup.</div>
                        </div>
                        <div class="summary-item">
                            <div class="summary-name">Why this matters</div>
                            <div class="summary-value">The Memory module already checks these DB values during create/list flows, so plan changes here now have real effect.</div>
                        </div>
                    </div>

                    <div class="callout">
                        If you want more admin controls later, the next useful ones would be toggling registrations on/off,
                        changing default moderation behavior, and giving real admin roles instead of the current single-admin assumption.
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function navigateTo(page) {
            if (page === 'overview') {
                window.location.href = '${pageContext.request.contextPath}/admin';
            } else if (page === 'analytics') {
                window.location.href = '${pageContext.request.contextPath}/adminanalytics';
            } else if (page === 'users') {
                window.location.href = '${pageContext.request.contextPath}/adminuser';
            } else if (page === 'content') {
                window.location.href = '${pageContext.request.contextPath}/admincontent';
            } else if (page === 'settings') {
                window.location.href = '${pageContext.request.contextPath}/adminsettings';
            }
        }

        function handleLogout() {
            if (confirm('Are you sure you want to logout?')) {
                window.location.href = '${pageContext.request.contextPath}/logoutservlet';
            }
        }
    </script>
</body>
</html>
