<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Family Plan | Everly</title>
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/settings.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/subscription.css">
    </head>

    <body>
        <jsp:include page="/WEB-INF/views/public/header2.jsp" />

        <div class="subscription-page">
            <div class="subscription-container">

                <!-- Back -->
                <div class="back-option" style="margin-bottom: 20px;">
                    <a href="${pageContext.request.contextPath}/managesubscription" class="back-link">← Back to
                        Subscription</a>
                </div>

                    <!-- Hero Section -->
                    <div class="family-hero">
                        <div class="family-hero-content">
                            <h2>Everly Family Plan</h2>
                            <p>Share your subscription with up to 6 family members. Everyone gets their own private
                                space, plus access to a shared family journal and storage pool.</p>
                            <c:if test="${not isFamilyPlan}">
                                <a href="${pageContext.request.contextPath}/changeplan" class="sub-btn primary">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <path d="M12 5v14M5 12h14" />
                                    </svg>
                                    Upgrade to Family — $9.99/mo
                                </a>
                            </c:if>
                        </div>
                        <div class="family-hero-illustration">
                            <svg width="180" height="140" viewBox="0 0 180 140" fill="none"
                                xmlns="http://www.w3.org/2000/svg">
                                <circle cx="90" cy="50" r="24" fill="#9A74D8" />
                                <circle cx="90" cy="42" r="10" fill="#EADDFF" />
                                <rect x="79" y="60" width="22" height="28" rx="4" fill="#9A74D8" />
                                <circle cx="45" cy="60" r="18" fill="#EADDFF" />
                                <circle cx="45" cy="54" r="8" fill="#fff" />
                                <rect x="37" y="68" width="16" height="22" rx="3" fill="#EADDFF" />
                                <circle cx="135" cy="60" r="18" fill="#EADDFF" />
                                <circle cx="135" cy="54" r="8" fill="#fff" />
                                <rect x="127" y="68" width="16" height="22" rx="3" fill="#EADDFF" />
                                <circle cx="24" cy="75" r="14" fill="#d4bcf0" />
                                <circle cx="24" cy="70" r="6" fill="#fff" />
                                <rect x="18" y="80" width="12" height="18" rx="3" fill="#d4bcf0" />
                                <circle cx="156" cy="75" r="14" fill="#d4bcf0" />
                                <circle cx="156" cy="70" r="6" fill="#fff" />
                                <rect x="150" y="80" width="12" height="18" rx="3" fill="#d4bcf0" />
                                <path d="M50 110 Q90 130 130 110" stroke="#9A74D8" stroke-width="2"
                                    stroke-dasharray="4 3" fill="none" />
                                <text x="90" y="126" text-anchor="middle" font-size="10" fill="#9A74D8"
                                    font-weight="600">Connected</text>
                            </svg>
                        </div>
                    </div>

                    <c:choose>
                        <c:when test="${isFamilyPlan}">

                        <!-- Shared Storage -->
                        <div class="shared-storage-card">
                            <h3>
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="vertical-align: middle; margin-right: 8px;">
                                    <circle cx="7" cy="8" r="3"></circle>
                                    <circle cx="17" cy="8" r="3"></circle>
                                    <circle cx="12" cy="6" r="3"></circle>
                                    <path d="M3 21v-2a4 4 0 0 1 4-4"></path>
                                    <path d="M13 21v-2a5 5 0 0 0-10 0v2"></path>
                                    <path d="M21 21v-2a4 4 0 0 0-4-4"></path>
                                </svg>
                                Shared Family Storage
                            </h3>
                            <div class="shared-storage-bar-bg">
                                <div class="shared-storage-bar-fill" style="width: 35%;"></div>
                            </div>
                            <div class="shared-storage-info">
                                <span>700 GB used</span>
                                <span>2 TB total</span>
                            </div>
                        </div>

                        <!-- Family Members -->
                        <div class="family-members-section">
                            <h3>Family Members (3 of 6)</h3>

                            <!-- Owner -->
                            <div class="family-member-card">
                                <div class="member-info">
                                    <div class="member-avatar" style="background: #9A74D8;">Y</div>
                                    <div class="member-details">
                                        <h4>You (Plan Owner)</h4>
                                        <p>youremail@example.com</p>
                                    </div>
                                </div>
                                <div class="member-actions">
                                    <span class="member-role owner">Owner</span>
                                </div>
                            </div>

                            <!-- Member 2 -->
                            <div class="family-member-card">
                                <div class="member-info">
                                    <div class="member-avatar" style="background: #60a5fa;">S</div>
                                    <div class="member-details">
                                        <h4>Sarah Johnson</h4>
                                        <p>sarah@example.com • Joined Jan 15, 2026</p>
                                    </div>
                                </div>
                                <div class="member-actions">
                                    <span class="member-role member">Member</span>
                                    <button class="member-remove-btn" onclick="removeMember('sarah@example.com')"
                                        title="Remove member">
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2" stroke-linecap="round">
                                            <line x1="18" y1="6" x2="6" y2="18" />
                                            <line x1="6" y1="6" x2="18" y2="18" />
                                        </svg>
                                    </button>
                                </div>
                            </div>

                            <!-- Member 3 -->
                            <div class="family-member-card">
                                <div class="member-info">
                                    <div class="member-avatar" style="background: #34d399;">D</div>
                                    <div class="member-details">
                                        <h4>David Liyanage</h4>
                                        <p>david@example.com • Joined Feb 2, 2026</p>
                                    </div>
                                </div>
                                <div class="member-actions">
                                    <span class="member-role member">Member</span>
                                    <button class="member-remove-btn" onclick="removeMember('david@example.com')"
                                        title="Remove member">
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2" stroke-linecap="round">
                                            <line x1="18" y1="6" x2="6" y2="18" />
                                            <line x1="6" y1="6" x2="18" y2="18" />
                                        </svg>
                                    </button>
                                </div>
                            </div>

                            <!-- Add Member Button -->
                            <div class="add-member-card" id="openInviteModal">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2" stroke-linecap="round">
                                    <line x1="12" y1="5" x2="12" y2="19" />
                                    <line x1="5" y1="12" x2="19" y2="12" />
                                </svg>
                                Invite a family member
                            </div>
                        </div>

                        <!-- Family plan benefits -->
                        <div class="sub-card">
                            <h3>
                                <span class="card-icon purple">
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <rect x="3" y="8" width="18" height="4"></rect>
                                        <rect x="4" y="12" width="16" height="9"></rect>
                                        <path d="M12 8v13"></path>
                                        <path d="M9.5 8a2.5 2.5 0 1 1 0-5c1.5 0 2.5 1.8 2.5 3"></path>
                                        <path d="M14.5 8a2.5 2.5 0 1 0 0-5C13 3 12 4.8 12 6"></path>
                                    </svg>
                                </span>
                                What each member gets
                            </h3>
                            <div
                                style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 16px; margin-top: 8px;">
                                <div
                                    style="display: flex; align-items: center; gap: 10px; padding: 14px; background: #fdfbff; border-radius: 10px;">
                                    <span style="display: inline-flex; align-items: center; justify-content: center;">
                                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#9A74D8" stroke-width="2">
                                            <rect x="3" y="11" width="18" height="10" rx="2"></rect>
                                            <path d="M7 11V8a5 5 0 0 1 10 0v3"></path>
                                        </svg>
                                    </span>
                                    <div>
                                        <div style="font-size: 14px; font-weight: 600; color: #1a1a2e;">Private Space
                                        </div>
                                        <div style="font-size: 12px; color: #9ca3af;">Own encrypted memories</div>
                                    </div>
                                </div>
                                <div
                                    style="display: flex; align-items: center; gap: 10px; padding: 14px; background: #fdfbff; border-radius: 10px;">
                                    <span style="display: inline-flex; align-items: center; justify-content: center;">
                                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#9A74D8" stroke-width="2">
                                            <path d="M3 21h6"></path>
                                            <path d="M14 3l7 7L8 23H1v-7z"></path>
                                        </svg>
                                    </span>
                                    <div>
                                        <div style="font-size: 14px; font-weight: 600; color: #1a1a2e;">Family Journal
                                        </div>
                                        <div style="font-size: 12px; color: #9ca3af;">Shared family entries</div>
                                    </div>
                                </div>
                                <div
                                    style="display: flex; align-items: center; gap: 10px; padding: 14px; background: #fdfbff; border-radius: 10px;">
                                    <span style="display: inline-flex; align-items: center; justify-content: center;">
                                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#9A74D8" stroke-width="2">
                                            <rect x="6" y="8" width="12" height="10" rx="2"></rect>
                                            <path d="M12 4v4"></path>
                                            <circle cx="10" cy="12" r="1"></circle>
                                            <circle cx="14" cy="12" r="1"></circle>
                                        </svg>
                                    </span>
                                    <div>
                                        <div style="font-size: 14px; font-weight: 600; color: #1a1a2e;">AI Features
                                        </div>
                                        <div style="font-size: 12px; color: #9ca3af;">Advanced AI for all</div>
                                    </div>
                                </div>
                                <div
                                    style="display: flex; align-items: center; gap: 10px; padding: 14px; background: #fdfbff; border-radius: 10px;">
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
                                        <div style="font-size: 12px; color: #9ca3af;">Unlock every theme</div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        </c:when>
                        <c:otherwise>
                            <!-- Not on Family Plan — Show Upsell -->
                            <div class="sub-card" style="text-align: center; padding: 48px;">
                                <div style="margin-bottom: 16px;">
                                    <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="#9A74D8" stroke-width="1.6">
                                        <circle cx="7" cy="9" r="2.5"></circle>
                                        <circle cx="17" cy="9" r="2.5"></circle>
                                        <circle cx="12" cy="7" r="2.5"></circle>
                                        <path d="M3 21v-1.5a3.5 3.5 0 0 1 3.5-3.5"></path>
                                        <path d="M17.5 16A3.5 3.5 0 0 1 21 19.5V21"></path>
                                        <path d="M8 21v-2a4 4 0 0 1 8 0v2"></path>
                                    </svg>
                                </div>
                                <h3 style="font-size: 22px; font-weight: 800; color: #1a1a2e; margin-bottom: 8px;">Bring
                                    your family together</h3>
                                <p
                                    style="font-size: 15px; color: #6b7280; max-width: 480px; margin: 0 auto 24px; line-height: 1.6;">
                                    Share 2 TB of storage with up to 6 family members. Everyone gets their own private
                                    space, shared journals, and full access to all Pro features.
                                </p>

                                <div
                                    style="display: flex; justify-content: center; gap: 32px; margin-bottom: 32px; flex-wrap: wrap;">
                                    <div style="text-align: center;">
                                        <div style="font-size: 28px; font-weight: 800; color: #9A74D8;">2 TB</div>
                                        <div style="font-size: 13px; color: #9ca3af;">Shared Storage</div>
                                    </div>
                                    <div style="text-align: center;">
                                        <div style="font-size: 28px; font-weight: 800; color: #9A74D8;">6</div>
                                        <div style="font-size: 13px; color: #9ca3af;">Family Members</div>
                                    </div>
                                    <div style="text-align: center;">
                                        <div style="font-size: 28px; font-weight: 800; color: #9A74D8;">$9.99</div>
                                        <div style="font-size: 13px; color: #9ca3af;">Per Month</div>
                                    </div>
                                </div>

                                <a href="${pageContext.request.contextPath}/changeplan" class="sub-btn primary"
                                    style="display: inline-flex;">
                                    Upgrade to Family Plan →
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>

            </div>
        </div>

        <!-- Invite Member Modal -->
        <div class="invite-modal-overlay" id="inviteModal">
            <div class="invite-modal">
                <h3>Invite a family member</h3>
                <p>Enter their email address to send an invitation. They'll need to create an Everly account if they
                    don't have one.</p>
                <form action="${pageContext.request.contextPath}/inviteFamilyMember" method="POST">
                    <div class="invite-input-group">
                        <input type="email" name="email" class="invite-input" placeholder="Enter email address"
                            required>
                        <button type="submit" class="invite-send-btn">Send</button>
                    </div>
                </form>
                <button class="invite-close-btn" id="closeInviteModal">Cancel</button>
            </div>
        </div>

        <jsp:include page="/WEB-INF/views/public/footer.jsp" />

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                var openBtn = document.getElementById('openInviteModal');
                var modal = document.getElementById('inviteModal');
                var closeBtn = document.getElementById('closeInviteModal');

                if (openBtn) {
                    openBtn.addEventListener('click', function () {
                        modal.classList.add('active');
                    });
                }

                if (closeBtn) {
                    closeBtn.addEventListener('click', function () {
                        modal.classList.remove('active');
                    });
                }

                if (modal) {
                    modal.addEventListener('click', function (e) {
                        if (e.target === modal) modal.classList.remove('active');
                    });
                }

                document.addEventListener('keydown', function (e) {
                    if (e.key === 'Escape' && modal && modal.classList.contains('active')) {
                        modal.classList.remove('active');
                    }
                });
            });

            function removeMember(email) {
                if (confirm('Are you sure you want to remove ' + email + ' from your family plan?')) {
                    // Will be replaced with actual form submission
                    alert('Member removed (backend not yet implemented)');
                }
            }
        </script>
    </body>

    </html>
