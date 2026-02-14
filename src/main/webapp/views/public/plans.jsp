<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Plans & Pricing | Everly</title>
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap"
            rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/base.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/header.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/subscription.css">
        <style>
            body {
                font-family: "Plus Jakarta Sans", sans-serif;
                margin: 0;
                background: #FAFBFD;
            }
        </style>
    </head>

    <body>
        <jsp:include page="header.jsp" />

        <div class="subscription-page">
            <div class="subscription-container">

                <!-- Header -->
                <div class="subscription-header">
                    <h1>Choose the perfect plan for you</h1>
                    <p>Preserve your most precious memories with the plan that fits your needs. All plans include
                        end-to-end encryption.</p>
                </div>

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

                    <!-- Basic (Free) -->
                    <div class="plan-card-new">
                        <span class="plan-tier">Starter</span>
                        <h3 class="plan-name">Basic</h3>
                        <p class="plan-desc">Perfect for getting started with your memories</p>
                        <div class="plan-price">
                            <span class="currency">$</span><span class="amount" data-monthly="0"
                                data-annual="0">0</span>
                            <span class="period">/ month</span>
                        </div>
                        <a href="${pageContext.request.contextPath}/signup" class="plan-cta secondary">Get Started
                            Free</a>
                        <ul class="plan-features">
                            <li>
                                <span class="check-icon"><svg viewBox="0 0 12 12" fill="none">
                                        <path d="M2 6l3 3 5-5" stroke="#9A74D8" stroke-width="2" stroke-linecap="round"
                                            stroke-linejoin="round" />
                                    </svg></span>
                                20 GB storage
                            </li>
                            <li>
                                <span class="check-icon"><svg viewBox="0 0 12 12" fill="none">
                                        <path d="M2 6l3 3 5-5" stroke="#9A74D8" stroke-width="2" stroke-linecap="round"
                                            stroke-linejoin="round" />
                                    </svg></span>
                                End-to-end encryption
                            </li>
                            <li>
                                <span class="check-icon"><svg viewBox="0 0 12 12" fill="none">
                                        <path d="M2 6l3 3 5-5" stroke="#9A74D8" stroke-width="2" stroke-linecap="round"
                                            stroke-linejoin="round" />
                                    </svg></span>
                                Basic journaling
                            </li>
                            <li>
                                <span class="check-icon"><svg viewBox="0 0 12 12" fill="none">
                                        <path d="M2 6l3 3 5-5" stroke="#9A74D8" stroke-width="2" stroke-linecap="round"
                                            stroke-linejoin="round" />
                                    </svg></span>
                                Up to 3 shared memories
                            </li>
                        </ul>
                    </div>

                    <!-- Premium -->
                    <div class="plan-card-new popular">
                        <span class="popular-tag">Most Popular</span>
                        <span class="plan-tier">Essential</span>
                        <h3 class="plan-name">Premium</h3>
                        <p class="plan-desc">For families who want more space and features</p>
                        <div class="plan-price">
                            <span class="currency">$</span><span class="amount" data-monthly="2.99"
                                data-annual="2.39">2.99</span>
                            <span class="period">/ month</span>
                            <span class="original-price" style="display:none" id="premiumOriginal">$2.99/mo</span>
                        </div>
                        <a href="${pageContext.request.contextPath}/signup" class="plan-cta primary">Start 7-day Free
                            Trial</a>
                        <ul class="plan-features">
                            <li>
                                <span class="check-icon"><svg viewBox="0 0 12 12" fill="none">
                                        <path d="M2 6l3 3 5-5" stroke="#9A74D8" stroke-width="2" stroke-linecap="round"
                                            stroke-linejoin="round" />
                                    </svg></span>
                                250 GB storage
                            </li>
                            <li>
                                <span class="check-icon"><svg viewBox="0 0 12 12" fill="none">
                                        <path d="M2 6l3 3 5-5" stroke="#9A74D8" stroke-width="2" stroke-linecap="round"
                                            stroke-linejoin="round" />
                                    </svg></span>
                                All themes unlocked
                            </li>
                            <li>
                                <span class="check-icon"><svg viewBox="0 0 12 12" fill="none">
                                        <path d="M2 6l3 3 5-5" stroke="#9A74D8" stroke-width="2" stroke-linecap="round"
                                            stroke-linejoin="round" />
                                    </svg></span>
                                No advertisements
                            </li>
                            <li>
                                <span class="check-icon"><svg viewBox="0 0 12 12" fill="none">
                                        <path d="M2 6l3 3 5-5" stroke="#9A74D8" stroke-width="2" stroke-linecap="round"
                                            stroke-linejoin="round" />
                                    </svg></span>
                                Smart journaling with AI
                            </li>
                            <li>
                                <span class="check-icon"><svg viewBox="0 0 12 12" fill="none">
                                        <path d="M2 6l3 3 5-5" stroke="#9A74D8" stroke-width="2" stroke-linecap="round"
                                            stroke-linejoin="round" />
                                    </svg></span>
                                Unlimited shared memories
                            </li>
                            <li>
                                <span class="check-icon"><svg viewBox="0 0 12 12" fill="none">
                                        <path d="M2 6l3 3 5-5" stroke="#9A74D8" stroke-width="2" stroke-linecap="round"
                                            stroke-linejoin="round" />
                                    </svg></span>
                                Priority support
                            </li>
                        </ul>
                    </div>

                    <!-- Pro -->
                    <div class="plan-card-new">
                        <span class="plan-tier">Professional</span>
                        <h3 class="plan-name">Pro</h3>
                        <p class="plan-desc">Maximum power for creators and large families</p>
                        <div class="plan-price">
                            <span class="currency">$</span><span class="amount" data-monthly="5.99"
                                data-annual="4.79">5.99</span>
                            <span class="period">/ month</span>
                            <span class="original-price" style="display:none" id="proOriginal">$5.99/mo</span>
                        </div>
                        <a href="${pageContext.request.contextPath}/signup" class="plan-cta secondary">Choose Pro</a>
                        <ul class="plan-features">
                            <li>
                                <span class="check-icon"><svg viewBox="0 0 12 12" fill="none">
                                        <path d="M2 6l3 3 5-5" stroke="#9A74D8" stroke-width="2" stroke-linecap="round"
                                            stroke-linejoin="round" />
                                    </svg></span>
                                1 TB storage
                            </li>
                            <li>
                                <span class="check-icon"><svg viewBox="0 0 12 12" fill="none">
                                        <path d="M2 6l3 3 5-5" stroke="#9A74D8" stroke-width="2" stroke-linecap="round"
                                            stroke-linejoin="round" />
                                    </svg></span>
                                Everything in Premium
                            </li>
                            <li>
                                <span class="check-icon"><svg viewBox="0 0 12 12" fill="none">
                                        <path d="M2 6l3 3 5-5" stroke="#9A74D8" stroke-width="2" stroke-linecap="round"
                                            stroke-linejoin="round" />
                                    </svg></span>
                                Advanced AI features
                            </li>
                            <li>
                                <span class="check-icon"><svg viewBox="0 0 12 12" fill="none">
                                        <path d="M2 6l3 3 5-5" stroke="#9A74D8" stroke-width="2" stroke-linecap="round"
                                            stroke-linejoin="round" />
                                    </svg></span>
                                Beta feature access
                            </li>
                            <li>
                                <span class="check-icon"><svg viewBox="0 0 12 12" fill="none">
                                        <path d="M2 6l3 3 5-5" stroke="#9A74D8" stroke-width="2" stroke-linecap="round"
                                            stroke-linejoin="round" />
                                    </svg></span>
                                Dedicated support
                            </li>
                        </ul>
                    </div>

                    <!-- Family -->
                    <div class="plan-card-new">
                        <span class="plan-tier">Together</span>
                        <h3 class="plan-name">Family</h3>
                        <p class="plan-desc">Share memories with up to 6 family members</p>
                        <div class="plan-price">
                            <span class="currency">$</span><span class="amount" data-monthly="9.99"
                                data-annual="7.99">9.99</span>
                            <span class="period">/ month</span>
                            <span class="original-price" style="display:none" id="familyOriginal">$9.99/mo</span>
                        </div>
                        <a href="${pageContext.request.contextPath}/signup" class="plan-cta secondary">Choose Family</a>
                        <ul class="plan-features">
                            <li>
                                <span class="check-icon"><svg viewBox="0 0 12 12" fill="none">
                                        <path d="M2 6l3 3 5-5" stroke="#9A74D8" stroke-width="2" stroke-linecap="round"
                                            stroke-linejoin="round" />
                                    </svg></span>
                                2 TB shared storage
                            </li>
                            <li>
                                <span class="check-icon"><svg viewBox="0 0 12 12" fill="none">
                                        <path d="M2 6l3 3 5-5" stroke="#9A74D8" stroke-width="2" stroke-linecap="round"
                                            stroke-linejoin="round" />
                                    </svg></span>
                                Up to 6 family members
                            </li>
                            <li>
                                <span class="check-icon"><svg viewBox="0 0 12 12" fill="none">
                                        <path d="M2 6l3 3 5-5" stroke="#9A74D8" stroke-width="2" stroke-linecap="round"
                                            stroke-linejoin="round" />
                                    </svg></span>
                                Everything in Pro
                            </li>
                            <li>
                                <span class="check-icon"><svg viewBox="0 0 12 12" fill="none">
                                        <path d="M2 6l3 3 5-5" stroke="#9A74D8" stroke-width="2" stroke-linecap="round"
                                            stroke-linejoin="round" />
                                    </svg></span>
                                Family admin controls
                            </li>
                            <li>
                                <span class="check-icon"><svg viewBox="0 0 12 12" fill="none">
                                        <path d="M2 6l3 3 5-5" stroke="#9A74D8" stroke-width="2" stroke-linecap="round"
                                            stroke-linejoin="round" />
                                    </svg></span>
                                Shared family journal
                            </li>
                        </ul>
                    </div>
                </div>

                <!-- Feature Comparison Table -->
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
                                    <td>End-to-end Encryption</td>
                                    <td><span class="table-check">✓</span></td>
                                    <td class="highlight"><span class="table-check">✓</span></td>
                                    <td><span class="table-check">✓</span></td>
                                    <td><span class="table-check">✓</span></td>
                                </tr>
                                <tr>
                                    <td>Journals</td>
                                    <td>Basic</td>
                                    <td class="highlight">Smart AI</td>
                                    <td>Smart AI</td>
                                    <td>Smart AI + Shared</td>
                                </tr>
                                <tr>
                                    <td>Themes</td>
                                    <td><span class="table-cross">—</span></td>
                                    <td class="highlight"><span class="table-check">✓</span></td>
                                    <td><span class="table-check">✓</span></td>
                                    <td><span class="table-check">✓</span></td>
                                </tr>
                                <tr>
                                    <td>Ad-free experience</td>
                                    <td><span class="table-cross">—</span></td>
                                    <td class="highlight"><span class="table-check">✓</span></td>
                                    <td><span class="table-check">✓</span></td>
                                    <td><span class="table-check">✓</span></td>
                                </tr>
                                <tr>
                                    <td>Shared memories</td>
                                    <td>Up to 3</td>
                                    <td class="highlight">Unlimited</td>
                                    <td>Unlimited</td>
                                    <td>Unlimited</td>
                                </tr>
                                <tr>
                                    <td>AI features</td>
                                    <td><span class="table-cross">—</span></td>
                                    <td class="highlight">Basic</td>
                                    <td>Advanced</td>
                                    <td>Advanced</td>
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
                                <tr>
                                    <td>Support</td>
                                    <td>Community</td>
                                    <td class="highlight">Priority</td>
                                    <td>Dedicated</td>
                                    <td>Dedicated</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- FAQ Section -->
                <div class="subscription-faq">
                    <h2>Frequently asked questions</h2>

                    <div class="faq-item">
                        <button class="faq-question">
                            Can I switch plans anytime?
                            <svg class="faq-arrow" width="16" height="16" viewBox="0 0 24 24" fill="none"
                                stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                <polyline points="6 9 12 15 18 9"></polyline>
                            </svg>
                        </button>
                        <div class="faq-answer">
                            <p>Yes! You can upgrade or downgrade your plan at any time. When upgrading, you'll get
                                immediate access to new features. When downgrading, the change takes effect at the end
                                of your current billing cycle.</p>
                        </div>
                    </div>

                    <div class="faq-item">
                        <button class="faq-question">
                            What happens to my data if I downgrade?
                            <svg class="faq-arrow" width="16" height="16" viewBox="0 0 24 24" fill="none"
                                stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                <polyline points="6 9 12 15 18 9"></polyline>
                            </svg>
                        </button>
                        <div class="faq-answer">
                            <p>Your data is never deleted when you downgrade. If you exceed the storage limit of your
                                new plan, you won't be able to upload new content until you free up space or upgrade
                                again.</p>
                        </div>
                    </div>

                    <div class="faq-item">
                        <button class="faq-question">
                            Is my data really encrypted?
                            <svg class="faq-arrow" width="16" height="16" viewBox="0 0 24 24" fill="none"
                                stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                <polyline points="6 9 12 15 18 9"></polyline>
                            </svg>
                        </button>
                        <div class="faq-answer">
                            <p>Absolutely. All plans include end-to-end encryption. Your memories are encrypted before
                                they leave your device, and only you (and people you choose to share with) can access
                                them.</p>
                        </div>
                    </div>

                    <div class="faq-item">
                        <button class="faq-question">
                            How does the Family plan work?
                            <svg class="faq-arrow" width="16" height="16" viewBox="0 0 24 24" fill="none"
                                stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                <polyline points="6 9 12 15 18 9"></polyline>
                            </svg>
                        </button>
                        <div class="faq-answer">
                            <p>The Family plan allows up to 6 family members to share a single subscription. Each member
                                gets their own private space plus access to a shared family journal and storage pool.
                            </p>
                        </div>
                    </div>

                    <div class="faq-item">
                        <button class="faq-question">
                            Can I cancel anytime?
                            <svg class="faq-arrow" width="16" height="16" viewBox="0 0 24 24" fill="none"
                                stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                <polyline points="6 9 12 15 18 9"></polyline>
                            </svg>
                        </button>
                        <div class="faq-answer">
                            <p>Yes, you can cancel your subscription anytime with no cancellation fees. You'll continue
                                to have access to your paid features until the end of your billing period, then you'll
                                revert to the Basic plan.</p>
                        </div>
                    </div>
                </div>

            </div>
        </div>

        <jsp:include page="footer.jsp" />

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const toggle = document.getElementById('billingToggle');
                const monthlyLabel = document.getElementById('monthlyLabel');
                const annualLabel = document.getElementById('annualLabel');
                const amounts = document.querySelectorAll('.amount');
                const originals = document.querySelectorAll('.original-price');

                toggle.addEventListener('change', function () {
                    const isAnnual = this.checked;

                    monthlyLabel.classList.toggle('active', !isAnnual);
                    annualLabel.classList.toggle('active', isAnnual);

                    amounts.forEach(function (el) {
                        const monthly = parseFloat(el.dataset.monthly);
                        const annual = parseFloat(el.dataset.annual);
                        el.textContent = isAnnual ? annual.toFixed(2) : monthly.toFixed(2);
                        if (monthly === 0) el.textContent = '0';
                    });

                    originals.forEach(function (el) {
                        el.style.display = isAnnual ? 'inline' : 'none';
                    });
                });

                // FAQ Accordion
                document.querySelectorAll('.faq-question').forEach(function (btn) {
                    btn.addEventListener('click', function () {
                        const item = this.closest('.faq-item');
                        const isOpen = item.classList.contains('open');

                        // Close all
                        document.querySelectorAll('.faq-item').forEach(function (i) {
                            i.classList.remove('open');
                        });

                        // Toggle current
                        if (!isOpen) {
                            item.classList.add('open');
                        }
                    });
                });
            });
        </script>
    </body>

    </html>