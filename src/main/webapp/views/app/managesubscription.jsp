<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Manage Subscription | Everly</title>
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/settings.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/subscription.css">
    </head>

    <body>
        <jsp:include page="../public/header2.jsp" />

        <div class="subscription-page">
            <div class="subscription-container">

                <!-- Back to Settings Link -->
                <div class="back-option" style="margin-bottom: 20px;">
                    <a href="${pageContext.request.contextPath}/settingsaccount" class="back-link">← Back to
                        Settings</a>
                </div>

                <div class="subscription-header" style="text-align: left; margin-bottom: 36px;">
                    <h1 style="font-size: 32px;">Manage Subscription</h1>
                    <p style="margin: 0;">View and manage your current plan, billing, and storage usage.</p>
                </div>

                <% // Retrieve attributes for scriptlet logic String pName=(String) request.getAttribute("planName"); if
                    (pName==null) { pName="Basic" ; } %>

                    <div class="manage-sub-layout">

                        <!-- Current Plan Card -->
                        <div class="sub-card" style="grid-column: 1 / -1;">
                            <h3>
                                <span class="card-icon purple">💎</span>
                                Your Current Plan
                            </h3>
                            <div class="current-plan-header">
                                <div class="current-plan-info">
                                    <h4>${planName}</h4>
                                    <p>
                                        ${planPrice}
                                        ${!billingCycle.equals("—") ? "• Billed " : ""}${!billingCycle.equals("—") ?
                                        billingCycle : ""}
                                    </p>
                                </div>
                                <span class="plan-status-badge active">Active</span>
                            </div>
                            <div class="plan-detail-row">
                                <span class="plan-detail-label">Billing cycle</span>
                                <span class="plan-detail-value">${billingCycle}</span>
                            </div>
                            <div class="plan-detail-row">
                                <span class="plan-detail-label">Next renewal</span>
                                <span class="plan-detail-value">${renewalDate}</span>
                            </div>
                            <div class="plan-detail-row">
                                <span class="plan-detail-label">Payment method</span>
                                <span class="plan-detail-value">
                                    ${planName == 'Basic' ? 'None (Free plan)' : '•••• 4242'}
                                </span>
                            </div>
                            <div class="sub-actions">
                                <a href="${pageContext.request.contextPath}/changeplan" class="sub-btn primary">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <path d="M12 5v14M5 12h14" />
                                    </svg>
                                    Upgrade Plan
                                </a>
                                <% if (!"Basic".equals(pName)) { %>
                                    <button class="sub-btn outline" id="cancelSubBtn">Cancel Subscription</button>
                                    <% } %>
                            </div>
                        </div>

                        <!-- Storage Usage Card -->
                        <div class="sub-card">
                            <h3>
                                <span class="card-icon blue">📊</span>
                                Storage Usage
                            </h3>
                            <div class="storage-bar-container">
                                <div style="display: flex; justify-content: space-between; margin-bottom: 8px;">
                                    <span style="font-size: 14px; font-weight: 600; color: #1a1a2e;">
                                        ${storageUsed} GB used
                                    </span>
                                    <span style="font-size: 14px; color: #9ca3af;">
                                        ${storageTotal} GB total
                                    </span>
                                </div>
                                <div class="storage-bar-bg">
                                    <div class="storage-bar-fill ${storagePercentage < 50 ? 'low' : (storagePercentage < 80 ? 'medium' : 'high')}"
                                        style="width: ${storagePercentage}%;">
                                    </div>
                                </div>
                                <span style="font-size: 13px; color: #9ca3af;">
                                    ${storagePercentage}% used
                                </span>
                            </div>

                            <div class="storage-breakdown">
                                <div class="storage-item">
                                    <span class="storage-dot" style="background: #9A74D8;"></span>
                                    Photos — ${storageUsed} GB <!-- Simplified breakdown -->
                                </div>
                            </div>

                            <div class="sub-actions" style="margin-top: 20px;">
                                <a href="${pageContext.request.contextPath}/storagesense" class="sub-btn outline">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <circle cx="12" cy="12" r="3" />
                                        <path d="M12 1v6m0 6v6" />
                                    </svg>
                                    Storage Sense
                                </a>
                                <% if ((Integer)request.getAttribute("storagePercentage")> 70) { %>
                                    <a href="${pageContext.request.contextPath}/changeplan" class="sub-btn primary">Need
                                        More Space?</a>
                                    <% } %>
                            </div>
                        </div>

                        <!-- Comparison Card (Static Promo) -->
                        <div class="sub-card">
                            <h3>
                                <span class="card-icon green">🚀</span>
                                Upgrade Benefits
                            </h3>
                            <p style="font-size: 14px; color: #6b7280; margin-bottom: 20px;">Unlock more with a
                                Premium or Pro plan</p>

                            <div style="display: flex; flex-direction: column; gap: 14px;">
                                <div
                                    style="display: flex; align-items: center; gap: 12px; padding: 12px 16px; background: #fdfbff; border-radius: 10px; border: 1px solid #f0e6ff;">
                                    <span style="font-size: 20px;">📦</span>
                                    <div>
                                        <div style="font-size: 14px; font-weight: 600; color: #1a1a2e;">250 GB Storage
                                        </div>
                                        <div style="font-size: 12px; color: #9ca3af;">12.5x more space from $2.99/mo
                                        </div>
                                    </div>
                                </div>
                                <div
                                    style="display: flex; align-items: center; gap: 12px; padding: 12px 16px; background: #fdfbff; border-radius: 10px; border: 1px solid #f0e6ff;">
                                    <span style="font-size: 20px;">🎨</span>
                                    <div>
                                        <div style="font-size: 14px; font-weight: 600; color: #1a1a2e;">All Themes</div>
                                        <div style="font-size: 12px; color: #9ca3af;">Personalize your experience</div>
                                    </div>
                                </div>
                            </div>

                            <div class="sub-actions" style="margin-top: 20px;">
                                <a href="${pageContext.request.contextPath}/changeplan" class="sub-btn primary"
                                    style="width: 100%; justify-content: center;">
                                    Compare Plans →
                                </a>
                            </div>
                        </div>

                    </div>

                    <!-- Billing History -->
                    <div class="sub-card" style="margin-bottom: 40px;">
                        <h3>
                            <span class="card-icon orange">📄</span>
                            Billing History
                        </h3>

                        <% if ("Basic".equals(pName)) { %>
                            <div style="text-align: center; padding: 40px 20px; color: #9ca3af;">
                                <div style="font-size: 36px; margin-bottom: 12px;">📋</div>
                                <p style="font-size: 15px; font-weight: 500; margin-bottom: 4px;">No billing history yet
                                </p>
                                <p style="font-size: 13px;">Upgrade to a paid plan to start seeing your invoices here.
                                </p>
                            </div>
                            <% } else { %>
                                <table class="billing-table">
                                    <thead>
                                        <tr>
                                            <th>Date</th>
                                            <th>Description</th>
                                            <th>Amount</th>
                                            <th>Status</th>
                                            <th>Invoice</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <!-- Placeholder Data -->
                                        <tr>
                                            <td>Feb 1, 2026</td>
                                            <td>${planName} Plan — Monthly</td>
                                            <td>${planPrice}</td>
                                            <td><span class="billing-status paid">Paid</span></td>
                                            <td><a href="#" class="billing-download">Download</a></td>
                                        </tr>
                                    </tbody>
                                </table>
                                <% } %>
                    </div>

            </div>
        </div>

        <jsp:include page="../public/footer.jsp" />
    </body>

    </html>