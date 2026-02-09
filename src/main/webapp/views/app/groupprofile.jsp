<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.demo.web.model.Group" %>
        <%@ page import="com.demo.web.model.GroupMember" %>
            <%@ page import="java.text.SimpleDateFormat" %>

                <jsp:include page="../public/header2.jsp" />
                <% Group group=(Group) request.getAttribute("group"); GroupMember member=(GroupMember)
                    request.getAttribute("member"); Boolean isAdmin=(Boolean) request.getAttribute("isAdmin"); Integer
                    currentUserId=(Integer) request.getAttribute("currentUserId"); String groupName=(group !=null) ?
                    group.getName() : "Group" ; int groupId=(group !=null) ? group.getGroupId() : 0; String
                    creatorText=(group !=null && isAdmin !=null && isAdmin) ? "Created by You" : "" ; String
                    memberName=(member !=null && member.getUser() !=null) ? member.getUser().getUsername() : "User" ;
                    String memberEmail=(member !=null && member.getUser() !=null) ? member.getUser().getEmail() : "" ;
                    String memberRole=(member !=null) ? member.getRole() : "Member" ; String initials="" ; if
                    (memberName !=null && memberName.length()> 0) {
                    String[] parts = memberName.split(" ");
                    if (parts.length >= 2) {
                    initials = (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
                    } else {
                    initials = memberName.substring(0, Math.min(2, memberName.length())).toUpperCase();
                    }
                    }

                    String joinedDate = "Joined Recently";
                    if (member != null && member.getJoinedAt() != null) {
                    SimpleDateFormat sdf = new SimpleDateFormat("MMM yyyy");
                    joinedDate = "Joined " + sdf.format(member.getJoinedAt());
                    }

                    boolean canRemove = (isAdmin != null && isAdmin && member != null && member.getUser().getId() !=
                    currentUserId);
                    %>
                    <html>

                    <head>
                        <link rel="stylesheet" type="text/css"
                            href="${pageContext.request.contextPath}/resources/css/groupcontent.css">
                    </head>
                    <script>
                        // Handle floating buttons position on scroll
                        document.addEventListener('DOMContentLoaded', function () {
                            function handleFloatingButtons() {
                                const footer = document.querySelector('footer');
                                const floatingButtons = document.getElementById('floatingButtons');

                                if (!footer || !floatingButtons) return;

                                const footerRect = footer.getBoundingClientRect();
                                const windowHeight = window.innerHeight;
                                const buttonHeight = floatingButtons.offsetHeight;

                                if (footerRect.top < windowHeight - buttonHeight - 40) {
                                    const stopPosition = footer.offsetTop - buttonHeight - 40;
                                    floatingButtons.style.position = 'absolute';
                                    floatingButtons.style.bottom = 'auto';
                                    floatingButtons.style.top = stopPosition + 'px';
                                } else {
                                    floatingButtons.style.position = 'fixed';
                                    floatingButtons.style.bottom = '40px';
                                    floatingButtons.style.top = 'auto';
                                    floatingButtons.style.right = '40px';
                                }
                            }

                            window.addEventListener('scroll', handleFloatingButtons);
                            window.addEventListener('resize', handleFloatingButtons);
                            handleFloatingButtons();
                        });
                    </script>

                    <body>

                        <!-- Page Wrapper -->
                        <div class="page-wrapper">
                            <main class="main-content profile-page">
                                <!-- Page Header -->
                                <div class="page-header">
                                    <h1 class="group-name">
                                        <%= groupName %>
                                    </h1>
                                    <p class="group-creator">
                                        <%= creatorText %>
                                    </p>
                                </div>

                                <!-- Tab Navigation -->
                                <div class="tab-nav">
                                    <a href="${pageContext.request.contextPath}/groupmemories?groupId=<%= groupId %>"
                                        class="tab-link">Memories</a>
                                    <a href="${pageContext.request.contextPath}/groupannouncement?groupId=<%= groupId %>"
                                        class="tab-link">Announcements</a>
                                    <a href="${pageContext.request.contextPath}/groupmembers?groupId=<%= groupId %>"
                                        class="tab-link active">Members</a>
                                </div>

                                <!-- Profile Card -->
                                <div class="profile-card">
                                    <!-- Back Button -->
                                    <button class="back-btn" onclick="window.history.back()">
                                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2.5" stroke-linecap="round"
                                            stroke-linejoin="round">
                                            <polyline points="15 18 9 12 15 6"></polyline>
                                        </svg>
                                        Back
                                    </button>

                                    <!-- Profile Header -->
                                    <div class="profile-header">
                                        <div class="profile-avatar-large">
                                            <%= initials %>
                                        </div>
                                        <div class="profile-info-main">
                                            <h2 class="profile-name">
                                                <%= memberName %>
                                            </h2>
                                            <span class="profile-badge member">
                                                <%= memberRole %>
                                            </span>
                                            <p class="profile-joined">
                                                <%= joinedDate %>
                                            </p>
                                        </div>
                                    </div>

                                    <!-- Profile Details -->
                                    <div class="profile-details">
                                        <div class="profile-field">
                                            <label>Email</label>
                                            <p>
                                                <%= memberEmail %>
                                            </p>
                                        </div>

                                        <div class="profile-field">
                                            <label>Permissions</label>
                                            <div class="permissions-select">
                                                <select class="permissions-dropdown" disabled>
                                                    <option value="viewer" <%="viewer" .equalsIgnoreCase(memberRole)
                                                        ? "selected" : "" %>>Viewer</option>
                                                    <option value="member" <%="member" .equalsIgnoreCase(memberRole)
                                                        ? "selected" : "" %>>Member</option>
                                                    <option value="admin" <%="admin" .equalsIgnoreCase(memberRole)
                                                        ? "selected" : "" %>>Admin</option>
                                                </select>
                                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2.5">
                                                    <polyline points="6 9 12 15 18 9"></polyline>
                                                </svg>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Action Button -->
                                    <% if (canRemove) { %>
                                        <form id="removeMemberForm"
                                            action="${pageContext.request.contextPath}/group/removeMember"
                                            method="POST">
                                            <input type="hidden" name="groupId" value="<%= groupId %>">
                                            <input type="hidden" name="memberId"
                                                value="<%= member != null ? member.getUser().getId() : "" %>">
                                            <button type="button" class="remove-member-btn" onclick="confirmRemoval()">
                                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2.5" stroke-linecap="round"
                                                    stroke-linejoin="round">
                                                    <polyline points="3 6 5 6 21 6"></polyline>
                                                    <path
                                                        d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2">
                                                    </path>
                                                </svg>
                                                Remove from Group
                                            </button>
                                        </form>
                                        <% } %>
                                </div>
                            </main>
                        </div>

                        <jsp:include page="../public/footer.jsp" />

                        <script>
                            function confirmRemoval() {
                                if (confirm('Are you sure you want to remove this member from the group?')) {
                                    document.getElementById('removeMemberForm').submit();
                                }
                            }
                        </script>

                    </body>

                    </html>