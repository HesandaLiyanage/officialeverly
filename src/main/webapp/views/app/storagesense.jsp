<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.demo.web.model.Plan" %>
        <%@ page import="java.util.List" %>
            <%@ page import="java.util.Map" %>
                <%! String formatBytes(long bytes) { if (bytes < 1024) return bytes + " B" ; if (bytes < 1024 * 1024)
                    return String.format("%.1f KB", bytes / 1024.0); if (bytes < 1024L * 1024 * 1024) return
                    String.format("%.1f MB", bytes / (1024.0 * 1024)); return String.format("%.2f GB", bytes / (1024.0 *
                    1024 * 1024)); } %>
                    <% Plan plan=(Plan) request.getAttribute("plan"); long usedStorageBytes=(Long)
                        request.getAttribute("usedStorageBytes"); long storageLimitBytes=(Long)
                        request.getAttribute("storageLimitBytes"); int usedPercent=(Integer)
                        request.getAttribute("usedPercent"); List<Map<String, Object>> topMemories = (List<Map<String,
                            Object>>) request.getAttribute("topMemories");
                            List<Map<String, Object>> topGroups = (List<Map<String, Object>>)
                                    request.getAttribute("topGroups");
                                    int duplicateCount = (Integer) request.getAttribute("duplicateCount");
                                    long duplicateSize = (Long) request.getAttribute("duplicateSize");
                                    int trashCount = (Integer) request.getAttribute("trashCount");
                                    int memoryCount = (Integer) request.getAttribute("memoryCount");

                                    String usedDisplay = formatBytes(usedStorageBytes);
                                    String limitDisplay = formatBytes(storageLimitBytes);
                                    String freeDisplay = formatBytes(storageLimitBytes - usedStorageBytes);

                                    String progressColor = usedPercent < 60 ? "#22c55e" : usedPercent < 85 ? "#f59e0b"
                                        : "#ef4444" ; %>
                                        <!DOCTYPE html>
                                        <html>

                                        <head>
                                            <meta charset="UTF-8">
                                            <title>Settings - Storage Sense</title>
                                            <link rel="stylesheet" type="text/css"
                                                href="${pageContext.request.contextPath}/resources/css/settings.css">
                                            <style>
                                                .ss-main {
                                                    margin-top: 8px;
                                                }

                                                .ss-gauge-card {
                                                    background: linear-gradient(135deg, #f8f5ff 0%, #f0ebff 100%);
                                                    border-radius: 16px;
                                                    padding: 28px 32px;
                                                    margin-bottom: 24px;
                                                    border: 1px solid #e8e0ff;
                                                }

                                                .ss-gauge-header {
                                                    display: flex;
                                                    justify-content: space-between;
                                                    align-items: center;
                                                    margin-bottom: 16px;
                                                }

                                                .ss-gauge-plan {
                                                    display: inline-flex;
                                                    align-items: center;
                                                    gap: 6px;
                                                    font-size: 12px;
                                                    font-weight: 700;
                                                    color: #9A74D8;
                                                    background: white;
                                                    padding: 5px 12px;
                                                    border-radius: 20px;
                                                    border: 1px solid #e8e0ff;
                                                }

                                                .ss-gauge-usage {
                                                    font-size: 13px;
                                                    font-weight: 600;
                                                    color: #6b7280;
                                                }

                                                .ss-gauge-usage strong {
                                                    color: #1f2937;
                                                    font-size: 18px;
                                                }

                                                .ss-progress-track {
                                                    height: 10px;
                                                    background: #e5e7eb;
                                                    border-radius: 10px;
                                                    overflow: hidden;
                                                    margin-bottom: 8px;
                                                }

                                                .ss-progress-fill {
                                                    height: 100%;
                                                    border-radius: 10px;
                                                    transition: width 0.8s ease;
                                                }

                                                .ss-progress-labels {
                                                    display: flex;
                                                    justify-content: space-between;
                                                    font-size: 11px;
                                                    color: #9ca3af;
                                                    font-weight: 500;
                                                }

                                                .ss-memory-count {
                                                    font-size: 12px;
                                                    color: #6b7280;
                                                    margin-top: 10px;
                                                }

                                                .ss-memory-count strong {
                                                    color: #9A74D8;
                                                }

                                                .ss-section-title {
                                                    font-size: 15px;
                                                    font-weight: 700;
                                                    color: #1f2937;
                                                    margin-bottom: 16px;
                                                }

                                                .ss-consumers {
                                                    display: grid;
                                                    grid-template-columns: 1fr 1fr;
                                                    gap: 16px;
                                                    margin-bottom: 28px;
                                                }

                                                .ss-consumer-card {
                                                    background: white;
                                                    border: 1px solid #f3f4f6;
                                                    border-radius: 12px;
                                                    padding: 20px;
                                                }

                                                .ss-consumer-title {
                                                    font-size: 13px;
                                                    font-weight: 700;
                                                    color: #6b7280;
                                                    margin-bottom: 14px;
                                                }

                                                .ss-consumer-item {
                                                    display: flex;
                                                    align-items: center;
                                                    gap: 10px;
                                                    padding: 8px 0;
                                                    border-bottom: 1px solid #f9fafb;
                                                }

                                                .ss-consumer-item:last-child {
                                                    border-bottom: none;
                                                }

                                                .ss-consumer-rank {
                                                    width: 22px;
                                                    height: 22px;
                                                    border-radius: 6px;
                                                    background: #f3f0ff;
                                                    color: #9A74D8;
                                                    display: flex;
                                                    align-items: center;
                                                    justify-content: center;
                                                    font-size: 10px;
                                                    font-weight: 800;
                                                    flex-shrink: 0;
                                                }

                                                .ss-consumer-info {
                                                    flex: 1;
                                                    min-width: 0;
                                                }

                                                .ss-consumer-name {
                                                    font-size: 13px;
                                                    font-weight: 600;
                                                    color: #1f2937;
                                                    white-space: nowrap;
                                                    overflow: hidden;
                                                    text-overflow: ellipsis;
                                                }

                                                .ss-consumer-meta {
                                                    font-size: 11px;
                                                    color: #9ca3af;
                                                }

                                                .ss-consumer-size {
                                                    font-size: 12px;
                                                    font-weight: 700;
                                                    color: #374151;
                                                    flex-shrink: 0;
                                                }

                                                .ss-empty-state {
                                                    text-align: center;
                                                    padding: 16px;
                                                    color: #9ca3af;
                                                    font-size: 13px;
                                                    font-style: italic;
                                                }

                                                .ss-manage-grid {
                                                    display: grid;
                                                    grid-template-columns: 1fr 1fr;
                                                    gap: 12px;
                                                    margin-bottom: 24px;
                                                }

                                                .ss-manage-card {
                                                    display: flex;
                                                    align-items: center;
                                                    gap: 14px;
                                                    background: white;
                                                    border: 1px solid #f3f4f6;
                                                    border-radius: 12px;
                                                    padding: 16px 20px;
                                                    cursor: pointer;
                                                    transition: all 0.2s;
                                                    text-decoration: none;
                                                    color: inherit;
                                                }

                                                .ss-manage-card:hover {
                                                    border-color: #9A74D8;
                                                    background: #faf8ff;
                                                    transform: translateY(-1px);
                                                    box-shadow: 0 2px 8px rgba(154, 116, 216, 0.12);
                                                }

                                                .ss-manage-icon {
                                                    width: 44px;
                                                    height: 44px;
                                                    border-radius: 10px;
                                                    display: flex;
                                                    align-items: center;
                                                    justify-content: center;
                                                    font-size: 20px;
                                                    flex-shrink: 0;
                                                }

                                                .ss-manage-icon.duplicates {
                                                    background: #fef3c7;
                                                }

                                                .ss-manage-icon.trash {
                                                    background: #fee2e2;
                                                }

                                                .ss-manage-text {
                                                    flex: 1;
                                                }

                                                .ss-manage-title {
                                                    font-size: 14px;
                                                    font-weight: 700;
                                                    color: #1f2937;
                                                    margin-bottom: 2px;
                                                }

                                                .ss-manage-desc {
                                                    font-size: 12px;
                                                    color: #9ca3af;
                                                }

                                                .ss-manage-badge {
                                                    font-size: 11px;
                                                    font-weight: 700;
                                                    padding: 3px 10px;
                                                    border-radius: 12px;
                                                    flex-shrink: 0;
                                                }

                                                .ss-manage-badge.duplicates {
                                                    background: #fef3c7;
                                                    color: #d97706;
                                                }

                                                .ss-manage-badge.trash {
                                                    background: #fee2e2;
                                                    color: #dc2626;
                                                }

                                                .ss-upgrade-btn {
                                                    display: inline-flex;
                                                    align-items: center;
                                                    gap: 8px;
                                                    background: #9A74D8;
                                                    color: white;
                                                    border: none;
                                                    border-radius: 12px;
                                                    padding: 12px 24px;
                                                    font-size: 14px;
                                                    font-weight: 700;
                                                    cursor: pointer;
                                                    text-decoration: none;
                                                    transition: all 0.2s;
                                                    box-shadow: 0 4px 14px rgba(154, 116, 216, 0.3);
                                                }

                                                .ss-upgrade-btn:hover {
                                                    background: #8a64c8;
                                                    transform: translateY(-1px);
                                                    box-shadow: 0 6px 20px rgba(154, 116, 216, 0.4);
                                                }

                                                @media (max-width: 768px) {
                                                    .ss-consumers {
                                                        grid-template-columns: 1fr;
                                                    }

                                                    .ss-manage-grid {
                                                        grid-template-columns: 1fr;
                                                    }
                                                }
                                            </style>
                                        </head>

                                        <body>
                                            <jsp:include page="../public/header2.jsp" />
                                            <div class="settings-container">
                                                <h2>Settings</h2>
                                                <div class="settings-tabs">
                                                    <a href="${pageContext.request.contextPath}/settingsaccount"
                                                        class="tab">Account</a>
                                                    <a href="${pageContext.request.contextPath}/settingssubscription"
                                                        class="tab">Subscription</a>
                                                    <a href="${pageContext.request.contextPath}/settingsprivacy"
                                                        class="tab">Privacy &amp; Security</a>
                                                    <a href="#" class="tab active">Storage Sense</a>
                                                    <a href="${pageContext.request.contextPath}/settingsnotifications"
                                                        class="tab">Notifications</a>
                                                </div>

                                                <div class="ss-main">
                                                    <!-- Storage Gauge -->
                                                    <div class="ss-gauge-card">
                                                        <div class="ss-gauge-header">
                                                            <span class="ss-gauge-plan">&#9733; <%= plan.getName() %>
                                                                    Plan</span>
                                                            <div class="ss-gauge-usage">
                                                                <strong>
                                                                    <%= usedDisplay %>
                                                                </strong> of <%= limitDisplay %>
                                                            </div>
                                                        </div>
                                                        <div class="ss-progress-track">
                                                            <div class="ss-progress-fill"
                                                                style="width: <%= usedPercent %>%; background: <%= progressColor %>;">
                                                            </div>
                                                        </div>
                                                        <div class="ss-progress-labels">
                                                            <span>
                                                                <%= usedPercent %>% used
                                                            </span>
                                                            <span>
                                                                <%= freeDisplay %> free
                                                            </span>
                                                        </div>
                                                        <p class="ss-memory-count"><strong>
                                                                <%= memoryCount %>
                                                            </strong> memories stored</p>
                                                    </div>

                                                    <!-- Top Storage Consumers -->
                                                    <div class="ss-section-title">Top Storage Consumers</div>
                                                    <div class="ss-consumers">
                                                        <div class="ss-consumer-card">
                                                            <div class="ss-consumer-title">Top Memories</div>
                                                            <% if (topMemories !=null && !topMemories.isEmpty()) { int
                                                                rank=1; boolean hasData=false; for (Map<String, Object>
                                                                mem : topMemories) {
                                                                long mSize = (Long) mem.get("totalSize");
                                                                if (mSize == 0) continue;
                                                                hasData = true;
                                                                %>
                                                                <div class="ss-consumer-item">
                                                                    <div class="ss-consumer-rank">
                                                                        <%= rank %>
                                                                    </div>
                                                                    <div class="ss-consumer-info">
                                                                        <div class="ss-consumer-name">
                                                                            <%= mem.get("title") !=null ?
                                                                                mem.get("title") : "Untitled" %>
                                                                        </div>
                                                                        <div class="ss-consumer-meta">
                                                                            <%= mem.get("fileCount") %> files
                                                                        </div>
                                                                    </div>
                                                                    <div class="ss-consumer-size">
                                                                        <%= formatBytes(mSize) %>
                                                                    </div>
                                                                </div>
                                                                <% rank++; } if (!hasData) { %>
                                                                    <div class="ss-empty-state">No data yet</div>
                                                                    <% } } else { %>
                                                                        <div class="ss-empty-state">No memories yet
                                                                        </div>
                                                                        <% } %>
                                                        </div>

                                                        <div class="ss-consumer-card">
                                                            <div class="ss-consumer-title">Top Groups</div>
                                                            <% if (topGroups !=null && !topGroups.isEmpty()) { int
                                                                gRank=1; boolean gHasData=false; for (Map<String,
                                                                Object> grp : topGroups) {
                                                                long gSize = (Long) grp.get("totalSize");
                                                                if (gSize == 0) continue;
                                                                gHasData = true;
                                                                %>
                                                                <div class="ss-consumer-item">
                                                                    <div class="ss-consumer-rank">
                                                                        <%= gRank %>
                                                                    </div>
                                                                    <div class="ss-consumer-info">
                                                                        <div class="ss-consumer-name">
                                                                            <%= grp.get("name") %>
                                                                        </div>
                                                                        <div class="ss-consumer-meta">
                                                                            <%= grp.get("memoryCount") %> memories
                                                                        </div>
                                                                    </div>
                                                                    <div class="ss-consumer-size">
                                                                        <%= formatBytes(gSize) %>
                                                                    </div>
                                                                </div>
                                                                <% gRank++; } if (!gHasData) { %>
                                                                    <div class="ss-empty-state">No data yet</div>
                                                                    <% } } else { %>
                                                                        <div class="ss-empty-state">No groups yet</div>
                                                                        <% } %>
                                                        </div>
                                                    </div>

                                                    <!-- Manage Storage -->
                                                    <div class="ss-section-title">Manage Storage</div>
                                                    <div class="ss-manage-grid">
                                                        <a href="${pageContext.request.contextPath}/duplicatefinder"
                                                            class="ss-manage-card">
                                                            <div class="ss-manage-icon duplicates">&#128450;</div>
                                                            <div class="ss-manage-text">
                                                                <div class="ss-manage-title">Duplicate Finder</div>
                                                                <div class="ss-manage-desc">Review and delete duplicate
                                                                    files</div>
                                                            </div>
                                                            <% if (duplicateCount> 0) { %>
                                                                <span class="ss-manage-badge duplicates">
                                                                    <%= duplicateCount %> found
                                                                </span>
                                                                <% } %>
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/trashmgt"
                                                            class="ss-manage-card">
                                                            <div class="ss-manage-icon trash">&#128465;</div>
                                                            <div class="ss-manage-text">
                                                                <div class="ss-manage-title">Trash Management</div>
                                                                <div class="ss-manage-desc">Recover or permanently
                                                                    delete items</div>
                                                            </div>
                                                            <% if (trashCount> 0) { %>
                                                                <span class="ss-manage-badge trash">
                                                                    <%= trashCount %> items
                                                                </span>
                                                                <% } %>
                                                        </a>
                                                    </div>

                                                    <a href="${pageContext.request.contextPath}/plans"
                                                        class="ss-upgrade-btn">&#9733; Upgrade Storage</a>
                                                </div>
                                            </div>
                                            <jsp:include page="../public/footer.jsp" />
                                        </body>

                                        </html>