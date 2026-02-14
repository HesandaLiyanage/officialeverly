<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>Settings - Subscription</title>
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/settings.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/subscription.css">
        <style>
            /* Override subscription container specifically for settings tab context */
            .settings-sub-wrapper {
                padding: 0;
                margin-top: 20px;
            }

            .limit-bar-container {
                margin-top: 15px;
                margin-bottom: 25px;
            }

            .limit-label {
                display: flex;
                justify-content: space-between;
                font-size: 14px;
                color: #4b5563;
                margin-bottom: 8px;
                font-weight: 500;
            }

            .limit-track {
                height: 8px;
                background: #f0f0f5;
                border-radius: 4px;
                overflow: hidden;
            }

            .limit-fill {
                height: 100%;
                background: #9A74D8;
                border-radius: 4px;
                width: 0%;
                /* Dynamic */
                transition: width 0.5s ease;
            }

            .upgrade-hero {
                background: linear-gradient(135deg, #f5f0ff 0%, #ede3ff 100%);
                border-radius: 16px;
                padding: 24px;
                display: flex;
                align-items: center;
                justify-content: space-between;
                margin-bottom: 30px;
                border: 1px solid #e0d0f0;
            }

            .upgrade-content h3 {
                margin: 0 0 8px 0;
                font-size: 18px;
                color: #1a1a2e;
            }

            .upgrade-content p {
                margin: 0;
                color: #6b7280;
                font-size: 14px;
            }

            .upgrade-btn {
                background: #9A74D8;
                color: white;
                padding: 10px 20px;
                border-radius: 8px;
                text-decoration: none;
                font-weight: 600;
                font-size: 14px;
                transition: background 0.2s;
                white-space: nowrap;
            }

            .upgrade-btn:hover {
                background: #8a64c8;
            }

            .billing-empty-state {
                text-align: center;
                padding: 40px;
                background: #fafbfd;
                border-radius: 12px;
                border: 1px dashed #d1d5db;
                color: #6b7280;
            }
        </style>
    </head>

    <body>
        <jsp:include page="../public/header2.jsp" />

        <div class="settings-container">
            <h2>Settings</h2>

            <div class="settings-tabs">
                <a href="${pageContext.request.contextPath}/settingsaccount" class="tab">Account</a>
                <a href="${pageContext.request.contextPath}/settingssubscription" class="tab active">Subscription</a>
                <a href="${pageContext.request.contextPath}/settingsprivacy" class="tab">Privacy & Security</a>
                <a href="${pageContext.request.contextPath}/storagesense" class="tab">Storage Sense</a>
                <a href="${pageContext.request.contextPath}/settingsnotifications" class="tab">Notifications</a>
                <a href="${pageContext.request.contextPath}/settingsappearance" class="tab">Appearance</a>
            </div>

            <!-- Main Subscription Content -->
            <div class="settings-sub-wrapper">

                <!-- Plan Overview Card -->
                <h3 style="font-size: 20px; margin-bottom: 20px; color: #1a1a2e;">Current Plan</h3>

                <div class="sub-card" style="margin-bottom: 30px; display: block;">
                    <div
                        style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 20px;">
                        <div>
                            <h2 style="margin: 0 0 5px 0; font-size: 24px; color: #1a1a2e;">Free Tier</h2>
                            <p style="margin: 0; color: #6b7280; font-size: 14px;">The basics for personal memory
                                keeping.</p>
                        </div>
                        <span class="plan-status-badge active">Active</span>
                    </div>

                    <div
                        style="border-top: 1px solid #f0f0f5; padding-top: 20px; display: grid; grid-template-columns: 1fr 1fr; gap: 40px;">

                        <!-- Storage Limit -->
                        <div>
                            <div class="limit-label">
                                <span>Storage</span>
                                <span>2.4 GB / 20 GB</span>
                            </div>
                            <div class="limit-track">
                                <div class="limit-fill" style="width: 12%;"></div>
                            </div>
                            <p style="font-size: 12px; color: #9ca3af; margin-top: 6px;">12% used</p>
                        </div>

                        <!-- Pages/Journal Limit -->
                        <div>
                            <div class="limit-label">
                                <span>Monthly Uploads</span>
                                <span>15 / 50</span>
                            </div>
                            <div class="limit-track">
                                <div class="limit-fill medium" style="width: 30%; background: #fbbf24;"></div>
                            </div>
                            <p style="font-size: 12px; color: #9ca3af; margin-top: 6px;">30% used</p>
                        </div>
                    </div>

                    <div
                        style="margin-top: 24px; padding-top: 20px; border-top: 1px solid #f0f0f5; display: flex; justify-content: flex-end;">
                        <a href="${pageContext.request.contextPath}/managesubscription"
                            style="color: #9A74D8; font-weight: 600; font-size: 14px; text-decoration: none; display: flex; align-items: center; gap: 4px;">
                            View Subscription Details
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                stroke-width="2">
                                <path d="M5 12h14M12 5l7 7-7 7" />
                            </svg>
                        </a>
                    </div>
                </div>

                <!-- Upgrade Promo -->
                <div class="upgrade-hero">
                    <div class="upgrade-content">
                        <h3>Unlock more space & features</h3>
                        <p>Get unlimited storage, AI journaling, and themes with Premium.</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/changeplan" class="upgrade-btn">Change Plan</a>
                </div>

                <!-- Billing & Payment -->
                <h3 style="font-size: 20px; margin-bottom: 20px; color: #1a1a2e;">Billing & Payment</h3>

                <div class="sub-card" style="margin-bottom: 30px;">
                    <div style="margin-bottom: 10px; font-weight: 600; font-size: 15px;">Payment Method</div>
                    <div
                        style="display: flex; justify-content: space-between; align-items: center; padding: 15px; background: #fafbfd; border-radius: 8px; border: 1px solid #f0f0f5;">
                        <div style="color: #6b7280; font-size: 14px;">No payment method added</div>
                        <button class="sub-btn outline" style="padding: 6px 14px; font-size: 13px;"
                            disabled>Manage</button>
                    </div>

                    <div style="margin-top: 25px; margin-bottom: 10px; font-weight: 600; font-size: 15px;">Billing
                        History</div>
                    <div class="billing-empty-state">
                        <div style="font-size: 24px; margin-bottom: 10px;">🧾</div>
                        <p style="margin: 0;">No invoices available for Free Tier.</p>
                    </div>
                </div>

            </div>
        </div>

        <jsp:include page="../public/footer.jsp" />
    </body>

    </html>