<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Change Plan | Everly</title>
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/settings.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/subscription.css">
    </head>

    <body>
        <jsp:include page="../public/header2.jsp" />

        <div class="subscription-page">
            <div class="subscription-container">

                <!-- Back -->
                <div class="back-option" style="margin-bottom: 20px;">
                    <a href="${pageContext.request.contextPath}/managesubscription" class="back-link">← Back to
                        Subscription</a>
                </div>

                <div class="subscription-header">
                    <h1>Change your plan</h1>
                    <p>Pick the plan that best fits your needs. You can upgrade or downgrade anytime.</p>
                </div>

                <% String currentPlan=(String) request.getAttribute("currentPlan"); if (currentPlan==null)
                    currentPlan="Basic" ; %>

                    <!-- Billing Toggle -->
                    <div class="billing-toggle">
                        <span class="active" id="monthlyLabel">Monthly</span>
                        <label class="toggle-switch">
                            <input type="checkbox" id="billingToggle">
                            <span class="toggle-slider"></span>
                        </label>
                        <span id="annualLabel">Annual</span>
                        <span class="savings-badge">Save 20%</span>
                    </div>

                    <!-- Plan Cards -->
                    <div class="plans-grid">

                        <!-- Basic -->
                        <div class="plan-card-new <%= currentPlan.equals(" Basic") ? "" : "" %>" id="planBasic">
                            <span class="plan-tier">Starter</span>
                            <h3 class="plan-name">Basic</h3>
                            <p class="plan-desc">For getting started</p>
                            <div class="plan-price">
                                <span class="currency">$</span><span class="amount" data-monthly="0"
                                    data-annual="0">0</span>
                                <span class="period">/ month</span>
                            </div>
                            <% if (currentPlan.equals("Basic")) { %>
                                <button class="plan-cta current">Current Plan</button>
                                <% } else { %>
                                    <button class="plan-cta secondary"
                                        onclick="confirmPlanChange('Basic', 'Free')">Downgrade to Basic</button>
                                    <% } %>
                                        <ul class="plan-features">
                                            <li><span class="check-icon"><svg viewBox="0 0 12 12" fill="none">
                                                        <path d="M2 6l3 3 5-5" stroke="#9A74D8" stroke-width="2"
                                                            stroke-linecap="round" stroke-linejoin="round" />
                                                    </svg></span>20 GB storage</li>
                                            <li><span class="check-icon"><svg viewBox="0 0 12 12" fill="none">
                                                        <path d="M2 6l3 3 5-5" stroke="#9A74D8" stroke-width="2"
                                                            stroke-linecap="round" stroke-linejoin="round" />
                                                    </svg></span>End-to-end encryption</li>
                                            <li><span class="check-icon"><svg viewBox="0 0 12 12" fill="none">
                                                        <path d="M2 6l3 3 5-5" stroke="#9A74D8" stroke-width="2"
                                                            stroke-linecap="round" stroke-linejoin="round" />
                                                    </svg></span>Basic journaling</li>
                                            <li><span class="check-icon"><svg viewBox="0 0 12 12" fill="none">
                                                        <path d="M2 6l3 3 5-5" stroke="#9A74D8" stroke-width="2"
                                                            stroke-linecap="round" stroke-linejoin="round" />
                                                    </svg></span>Up to 3 shared memories</li>
                                        </ul>
                        </div>

                        <!-- Premium -->
                        <div class="plan-card-new popular" id="planPremium">
                            <span class="popular-tag">Most Popular</span>
                            <span class="plan-tier">Essential</span>
                            <h3 class="plan-name">Premium</h3>
                            <p class="plan-desc">More space & features</p>
                            <div class="plan-price">
                                <span class="currency">$</span><span class="amount" data-monthly="2.99"
                                    data-annual="2.39">2.99</span>
                                <span class="period" id="premiumPeriod">/ month</span>
                                <span class="original-price" style="display:none">$2.99/mo</span>
                            </div>
                            <% if (currentPlan.equals("Premium")) { %>
                                <button class="plan-cta current">Current Plan</button>
                                <% } else { %>
                                    <button class="plan-cta primary"
                                        onclick="confirmPlanChange('Premium', getCurrentPrice('2.99', '2.39'))">
                                        <%= currentPlan.equals("Pro") || currentPlan.equals("Family")
                                            ? "Downgrade to Premium" : "Upgrade to Premium" %>
                                    </button>
                                    <% } %>
                                        <ul class="plan-features">
                                            <li><span class="check-icon"><svg viewBox="0 0 12 12" fill="none">
                                                        <path d="M2 6l3 3 5-5" stroke="#9A74D8" stroke-width="2"
                                                            stroke-linecap="round" stroke-linejoin="round" />
                                                    </svg></span>250 GB storage</li>
                                            <li><span class="check-icon"><svg viewBox="0 0 12 12" fill="none">
                                                        <path d="M2 6l3 3 5-5" stroke="#9A74D8" stroke-width="2"
                                                            stroke-linecap="round" stroke-linejoin="round" />
                                                    </svg></span>All themes unlocked</li>
                                            <li><span class="check-icon"><svg viewBox="0 0 12 12" fill="none">
                                                        <path d="M2 6l3 3 5-5" stroke="#9A74D8" stroke-width="2"
                                                            stroke-linecap="round" stroke-linejoin="round" />
                                                    </svg></span>No advertisements</li>
                                            <li><span class="check-icon"><svg viewBox="0 0 12 12" fill="none">
                                                        <path d="M2 6l3 3 5-5" stroke="#9A74D8" stroke-width="2"
                                                            stroke-linecap="round" stroke-linejoin="round" />
                                                    </svg></span>Smart journaling with AI</li>
                                            <li><span class="check-icon"><svg viewBox="0 0 12 12" fill="none">
                                                        <path d="M2 6l3 3 5-5" stroke="#9A74D8" stroke-width="2"
                                                            stroke-linecap="round" stroke-linejoin="round" />
                                                    </svg></span>Unlimited shared memories</li>
                                            <li><span class="check-icon"><svg viewBox="0 0 12 12" fill="none">
                                                        <path d="M2 6l3 3 5-5" stroke="#9A74D8" stroke-width="2"
                                                            stroke-linecap="round" stroke-linejoin="round" />
                                                    </svg></span>Priority support</li>
                                        </ul>
                        </div>

                        <!-- Pro -->
                        <div class="plan-card-new" id="planPro">
                            <span class="plan-tier">Professional</span>
                            <h3 class="plan-name">Pro</h3>
                            <p class="plan-desc">Maximum power</p>
                            <div class="plan-price">
                                <span class="currency">$</span><span class="amount" data-monthly="5.99"
                                    data-annual="4.79">5.99</span>
                                <span class="period">/ month</span>
                                <span class="original-price" style="display:none">$5.99/mo</span>
                            </div>
                            <% if (currentPlan.equals("Pro")) { %>
                                <button class="plan-cta current">Current Plan</button>
                                <% } else { %>
                                    <button class="plan-cta secondary"
                                        onclick="confirmPlanChange('Pro', getCurrentPrice('5.99', '4.79'))">
                                        <%= currentPlan.equals("Family") ? "Downgrade to Pro" : "Upgrade to Pro" %>
                                    </button>
                                    <% } %>
                                        <ul class="plan-features">
                                            <li><span class="check-icon"><svg viewBox="0 0 12 12" fill="none">
                                                        <path d="M2 6l3 3 5-5" stroke="#9A74D8" stroke-width="2"
                                                            stroke-linecap="round" stroke-linejoin="round" />
                                                    </svg></span>1 TB storage</li>
                                            <li><span class="check-icon"><svg viewBox="0 0 12 12" fill="none">
                                                        <path d="M2 6l3 3 5-5" stroke="#9A74D8" stroke-width="2"
                                                            stroke-linecap="round" stroke-linejoin="round" />
                                                    </svg></span>Everything in Premium</li>
                                            <li><span class="check-icon"><svg viewBox="0 0 12 12" fill="none">
                                                        <path d="M2 6l3 3 5-5" stroke="#9A74D8" stroke-width="2"
                                                            stroke-linecap="round" stroke-linejoin="round" />
                                                    </svg></span>Advanced AI features</li>
                                            <li><span class="check-icon"><svg viewBox="0 0 12 12" fill="none">
                                                        <path d="M2 6l3 3 5-5" stroke="#9A74D8" stroke-width="2"
                                                            stroke-linecap="round" stroke-linejoin="round" />
                                                    </svg></span>Beta feature access</li>
                                            <li><span class="check-icon"><svg viewBox="0 0 12 12" fill="none">
                                                        <path d="M2 6l3 3 5-5" stroke="#9A74D8" stroke-width="2"
                                                            stroke-linecap="round" stroke-linejoin="round" />
                                                    </svg></span>Dedicated support</li>
                                        </ul>
                        </div>

                        <!-- Family -->
                        <div class="plan-card-new" id="planFamily">
                            <span class="plan-tier">Together</span>
                            <h3 class="plan-name">Family</h3>
                            <p class="plan-desc">For the whole family</p>
                            <div class="plan-price">
                                <span class="currency">$</span><span class="amount" data-monthly="9.99"
                                    data-annual="7.99">9.99</span>
                                <span class="period">/ month</span>
                                <span class="original-price" style="display:none">$9.99/mo</span>
                            </div>
                            <% if (currentPlan.equals("Family")) { %>
                                <button class="plan-cta current">Current Plan</button>
                                <% } else { %>
                                    <button class="plan-cta secondary"
                                        onclick="confirmPlanChange('Family', getCurrentPrice('9.99', '7.99'))">Upgrade
                                        to Family</button>
                                    <% } %>
                                        <ul class="plan-features">
                                            <li><span class="check-icon"><svg viewBox="0 0 12 12" fill="none">
                                                        <path d="M2 6l3 3 5-5" stroke="#9A74D8" stroke-width="2"
                                                            stroke-linecap="round" stroke-linejoin="round" />
                                                    </svg></span>2 TB shared storage</li>
                                            <li><span class="check-icon"><svg viewBox="0 0 12 12" fill="none">
                                                        <path d="M2 6l3 3 5-5" stroke="#9A74D8" stroke-width="2"
                                                            stroke-linecap="round" stroke-linejoin="round" />
                                                    </svg></span>Up to 6 members</li>
                                            <li><span class="check-icon"><svg viewBox="0 0 12 12" fill="none">
                                                        <path d="M2 6l3 3 5-5" stroke="#9A74D8" stroke-width="2"
                                                            stroke-linecap="round" stroke-linejoin="round" />
                                                    </svg></span>Everything in Pro</li>
                                            <li><span class="check-icon"><svg viewBox="0 0 12 12" fill="none">
                                                        <path d="M2 6l3 3 5-5" stroke="#9A74D8" stroke-width="2"
                                                            stroke-linecap="round" stroke-linejoin="round" />
                                                    </svg></span>Family admin controls</li>
                                            <li><span class="check-icon"><svg viewBox="0 0 12 12" fill="none">
                                                        <path d="M2 6l3 3 5-5" stroke="#9A74D8" stroke-width="2"
                                                            stroke-linecap="round" stroke-linejoin="round" />
                                                    </svg></span>Shared family journal</li>
                                        </ul>
                        </div>
                    </div>

                    <!-- Feature Comparison -->
                    <div class="comparison-section">
                        <h2>Compare all features</h2>
                        <div class="comparison-table-wrapper">
                            <table class="comparison-table">
                                <thead>
                                    <tr>
                                        <th>Features</th>
                                        <th>Basic</th>
                                        <th class="highlight">Premium</th>
                                        <th>Pro</th>
                                        <th>Family</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>Storage</td>
                                        <td>20 GB</td>
                                        <td class="highlight">250 GB</td>
                                        <td>1 TB</td>
                                        <td>2 TB (shared)</td>
                                    </tr>
                                    <tr>
                                        <td>Encryption</td>
                                        <td><span class="table-check">✓</span></td>
                                        <td class="highlight"><span class="table-check">✓</span></td>
                                        <td><span class="table-check">✓</span></td>
                                        <td><span class="table-check">✓</span></td>
                                    </tr>
                                    <tr>
                                        <td>Themes</td>
                                        <td><span class="table-cross">—</span></td>
                                        <td class="highlight"><span class="table-check">✓</span></td>
                                        <td><span class="table-check">✓</span></td>
                                        <td><span class="table-check">✓</span></td>
                                    </tr>
                                    <tr>
                                        <td>Ad-free</td>
                                        <td><span class="table-cross">—</span></td>
                                        <td class="highlight"><span class="table-check">✓</span></td>
                                        <td><span class="table-check">✓</span></td>
                                        <td><span class="table-check">✓</span></td>
                                    </tr>
                                    <tr>
                                        <td>AI features</td>
                                        <td><span class="table-cross">—</span></td>
                                        <td class="highlight">Basic</td>
                                        <td>Advanced</td>
                                        <td>Advanced</td>
                                    </tr>
                                    <tr>
                                        <td>Shared memories</td>
                                        <td>Up to 3</td>
                                        <td class="highlight">Unlimited</td>
                                        <td>Unlimited</td>
                                        <td>Unlimited</td>
                                    </tr>
                                    <tr>
                                        <td>Beta access</td>
                                        <td><span class="table-cross">—</span></td>
                                        <td class="highlight"><span class="table-cross">—</span></td>
                                        <td><span class="table-check">✓</span></td>
                                        <td><span class="table-check">✓</span></td>
                                    </tr>
                                    <tr>
                                        <td>Family members</td>
                                        <td><span class="table-cross">—</span></td>
                                        <td class="highlight"><span class="table-cross">—</span></td>
                                        <td><span class="table-cross">—</span></td>
                                        <td>Up to 6</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

            </div>
        </div>

        <!-- Plan Change Confirmation Modal -->
        <div class="change-plan-modal-overlay" id="changePlanModal">
            <div class="change-plan-modal">
                <div style="font-size: 48px; margin-bottom: 8px;">✨</div>
                <h3 id="modalTitle">Confirm Plan Change</h3>
                <p style="font-size: 14px; color: #6b7280; margin-bottom: 0;" id="modalDesc">Review your plan change
                    below</p>

                <div class="plan-change-summary">
                    <div class="plan-change-from">
                        <h4 id="fromPlan">
                            <%= currentPlan %>
                        </h4>
                        <p>Current plan</p>
                    </div>
                    <div class="plan-change-arrow">→</div>
                    <div class="plan-change-to">
                        <h4 id="toPlan">Premium</h4>
                        <p id="toPrice">$2.99/mo</p>
                    </div>
                </div>

                <p style="font-size: 13px; color: #9ca3af; margin: 16px 0 0;" id="modalNote">
                    Changes take effect immediately. You'll be charged the prorated amount.
                </p>

                <div class="modal-actions">
                    <button class="sub-btn outline" onclick="closeModal()">Cancel</button>
                    <form action="${pageContext.request.contextPath}/changeplansubmit" method="POST"
                        style="display:inline;">
                        <input type="hidden" name="newPlan" id="newPlanInput">
                        <input type="hidden" name="billingCycle" id="billingCycleInput" value="monthly">
                        <button type="submit" class="sub-btn primary" id="confirmChangeBtn">Confirm Change</button>
                    </form>
                </div>
            </div>
        </div>

        <jsp:include page="../public/footer.jsp" />

        <script>
            var currentPlan = '<%= currentPlan %>';

            function getCurrentPrice(monthly, annual) {
                var toggle = document.getElementById('billingToggle');
                return toggle.checked ? '$' + annual + '/mo' : '$' + monthly + '/mo';
            }

            function confirmPlanChange(planName, price) {
                document.getElementById('toPlan').textContent = planName;
                document.getElementById('toPrice').textContent = price;
                document.getElementById('newPlanInput').value = planName;
                document.getElementById('billingCycleInput').value = document.getElementById('billingToggle').checked ? 'annual' : 'monthly';

                var planOrder = { 'Basic': 0, 'Premium': 1, 'Pro': 2, 'Family': 3 };
                var isUpgrade = planOrder[planName] > planOrder[currentPlan];

                if (isUpgrade) {
                    document.getElementById('modalTitle').textContent = 'Upgrade to ' + planName;
                    document.getElementById('modalNote').textContent = 'Changes take effect immediately. You\'ll be charged the prorated amount for the remaining billing period.';
                    document.getElementById('confirmChangeBtn').textContent = 'Confirm Upgrade';
                } else {
                    document.getElementById('modalTitle').textContent = 'Downgrade to ' + planName;
                    document.getElementById('modalNote').textContent = 'The downgrade takes effect at the end of your current billing cycle. You\'ll keep your current features until then.';
                    document.getElementById('confirmChangeBtn').textContent = 'Confirm Downgrade';
                }

                document.getElementById('changePlanModal').classList.add('active');
            }

            function closeModal() {
                document.getElementById('changePlanModal').classList.remove('active');
            }

            // Close on overlay click
            document.getElementById('changePlanModal').addEventListener('click', function (e) {
                if (e.target === this) closeModal();
            });

            // Billing toggle
            document.addEventListener('DOMContentLoaded', function () {
                var toggle = document.getElementById('billingToggle');
                var monthlyLabel = document.getElementById('monthlyLabel');
                var annualLabel = document.getElementById('annualLabel');
                var amounts = document.querySelectorAll('.amount');
                var originals = document.querySelectorAll('.original-price');

                toggle.addEventListener('change', function () {
                    var isAnnual = this.checked;
                    monthlyLabel.classList.toggle('active', !isAnnual);
                    annualLabel.classList.toggle('active', isAnnual);

                    amounts.forEach(function (el) {
                        var monthly = parseFloat(el.dataset.monthly);
                        var annual = parseFloat(el.dataset.annual);
                        el.textContent = isAnnual ? annual.toFixed(2) : monthly.toFixed(2);
                        if (monthly === 0) el.textContent = '0';
                    });

                    originals.forEach(function (el) {
                        el.style.display = isAnnual ? 'inline' : 'none';
                    });
                });
            });

            // Escape key
            document.addEventListener('keydown', function (e) {
                if (e.key === 'Escape') closeModal();
            });
        </script>
    </body>

    </html>