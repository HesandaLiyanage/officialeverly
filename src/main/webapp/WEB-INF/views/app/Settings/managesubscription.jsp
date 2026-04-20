<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
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
        <jsp:include page="/WEB-INF/views/public/header2.jsp" />

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

                    <div class="manage-sub-layout">

                        <!-- Current Plan Card -->
                        <div class="sub-card" style="grid-column: 1 / -1;">
                            <h3>
                                <span class="card-icon purple">
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M12 3 3 9l9 12 9-12-9-6z"></path>
                                    </svg>
                                </span>
                                Your Current Plan
                            </h3>
                            <div class="current-plan-header">
                                <div class="current-plan-info">
                                    <h4><c:out value="${planName}" /></h4>
                                    <p>
                                        <c:out value="${planPrice}" />
                                        <c:if test="${billingCycle != '—'}"> • Billed <c:out value="${billingCycle}" /></c:if>
                                    </p>
                                </div>
                                <span class="plan-status-badge active">Active</span>
                            </div>
                            <div class="plan-detail-row">
                                <span class="plan-detail-label">Billing cycle</span>
                                <span class="plan-detail-value"><c:out value="${billingCycle}" /></span>
                            </div>
                            <div class="plan-detail-row">
                                <span class="plan-detail-label">Next renewal</span>
                                <span class="plan-detail-value"><c:out value="${renewalDate}" /></span>
                            </div>
                            <div class="plan-detail-row">
                                <span class="plan-detail-label">Payment method</span>
                                <span class="plan-detail-value">
                                    <c:choose>
                                        <c:when test="${isBasicPlan}">None (Free plan)</c:when>
                                        <c:otherwise>•••• 4242</c:otherwise>
                                    </c:choose>
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
                                <c:if test="${not isBasicPlan}">
                                    <button class="sub-btn outline" id="cancelSubBtn">Cancel Subscription</button>
                                </c:if>
                            </div>
                        </div>

                        <!-- Storage Usage Card -->
                        <div class="sub-card">
                            <h3>
                                <span class="card-icon blue">
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <line x1="6" y1="18" x2="6" y2="10"></line>
                                        <line x1="12" y1="18" x2="12" y2="6"></line>
                                        <line x1="18" y1="18" x2="18" y2="13"></line>
                                    </svg>
                                </span>
                                Storage Usage
                            </h3>
                            <div class="storage-bar-container">
                                <div style="display: flex; justify-content: space-between; margin-bottom: 8px;">
                                    <span style="font-size: 14px; font-weight: 600; color: #1a1a2e;">
                                        <c:out value="${storageUsedFormatted}" /> used
                                    </span>
                                    <span style="font-size: 14px; color: #9ca3af;">
                                        <c:out value="${storageTotalFormatted}" /> total
                                    </span>
                                </div>
                                <div class="storage-bar-bg">
                                    <c:set var="barClass" value="low" />
                                    <c:if test="${storagePercentage >= 50}"><c:set var="barClass" value="medium" /></c:if>
                                    <c:if test="${storagePercentage >= 80}"><c:set var="barClass" value="high" /></c:if>
                                    <div class="storage-bar-fill ${barClass}"
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
                                    Photos — <c:out value="${storageUsedFormatted}" />
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
                                <c:if test="${needsMoreSpace}">
                                    <a href="${pageContext.request.contextPath}/changeplan" class="sub-btn primary">Need
                                        More Space?</a>
                                </c:if>
                            </div>
                        </div>

                        <!-- Comparison Card (Static Promo) -->
                        <div class="sub-card">
                            <h3>
                                <span class="card-icon green">
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M4 14c4-7 9-10 16-10-1 7-4 12-11 16l-5-6z"></path>
                                        <path d="M8 16l-1 4 4-1"></path>
                                    </svg>
                                </span>
                                Upgrade Benefits
                            </h3>
                            <p style="font-size: 14px; color: #6b7280; margin-bottom: 20px;">Unlock more with a
                                Premium or Pro plan</p>

                            <div style="display: flex; flex-direction: column; gap: 14px;">
                                <div
                                    style="display: flex; align-items: center; gap: 12px; padding: 12px 16px; background: #fdfbff; border-radius: 10px; border: 1px solid #f0e6ff;">
                                    <span style="display: inline-flex; align-items: center; justify-content: center;">
                                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#9A74D8" stroke-width="2">
                                            <path d="M3 7 12 3l9 4-9 4-9-4z"></path>
                                            <path d="M3 7v10l9 4 9-4V7"></path>
                                        </svg>
                                    </span>
                                    <div>
                                        <div style="font-size: 14px; font-weight: 600; color: #1a1a2e;">250 GB Storage
                                        </div>
                                        <div style="font-size: 12px; color: #9ca3af;">12.5x more space from $2.99/mo
                                        </div>
                                    </div>
                                </div>
                                <div
                                    style="display: flex; align-items: center; gap: 12px; padding: 12px 16px; background: #fdfbff; border-radius: 10px; border: 1px solid #f0e6ff;">
                                    <span style="display: inline-flex; align-items: center; justify-content: center;">
                                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#9A74D8" stroke-width="2">
                                            <circle cx="12" cy="12" r="8"></circle>
                                            <circle cx="9" cy="10" r="1"></circle>
                                            <circle cx="12" cy="8" r="1"></circle>
                                            <circle cx="15" cy="10" r="1"></circle>
                                        </svg>
                                    </span>
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
                            <span class="card-icon orange">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M14 3H6a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V9z"></path>
                                    <path d="M14 3v6h6"></path>
                                </svg>
                            </span>
                            Billing History
                        </h3>

                        <c:choose>
                            <c:when test="${isBasicPlan}">
                                <div style="text-align: center; padding: 40px 20px; color: #9ca3af;">
                                    <div style="margin-bottom: 12px;">
                                        <svg width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="#9ca3af" stroke-width="1.8">
                                            <rect x="8" y="3" width="8" height="4" rx="1"></rect>
                                            <path d="M7 5H6a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2h-1"></path>
                                        </svg>
                                    </div>
                                    <p style="font-size: 15px; font-weight: 500; margin-bottom: 4px;">No billing history yet
                                    </p>
                                    <p style="font-size: 13px;">Upgrade to a paid plan to start seeing your invoices here.
                                    </p>
                                </div>
                            </c:when>
                            <c:otherwise>
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
                                            <td><c:out value="${planName}" /> Plan — Monthly</td>
                                            <td><c:out value="${planPrice}" /></td>
                                            <td><span class="billing-status paid">Paid</span></td>
                                            <td><a href="#" class="billing-download">Download</a></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </c:otherwise>
                        </c:choose>
                    </div>

            </div>
        </div>

        <jsp:include page="/WEB-INF/views/public/footer.jsp" />
    </body>

    </html>
