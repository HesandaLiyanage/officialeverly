<%@ page contentType="text/html;charset=UTF-8" language="java" %>
  <%@ page import="com.demo.web.model.Group" %>
    <%@ page import="com.demo.web.model.GroupMember" %>
      <%@ page import="java.util.List" %>

        <jsp:include page="../public/header2.jsp" />
        <html>

        <head>
          <link rel="stylesheet" type="text/css"
            href="${pageContext.request.contextPath}/resources/css/groupcontent.css">
          <style>
            /* Invite Modal Styles */
            .invite-modal-overlay {
              display: none;
              position: fixed;
              top: 0;
              left: 0;
              width: 100%;
              height: 100%;
              background: rgba(0, 0, 0, 0.5);
              z-index: 1000;
              justify-content: center;
              align-items: center;
            }

            .invite-modal-overlay.active {
              display: flex;
            }

            .invite-modal {
              background: white;
              border-radius: 16px;
              padding: 32px;
              max-width: 500px;
              width: 90%;
              box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            }

            .invite-modal h3 {
              margin: 0 0 16px 0;
              color: #333;
            }

            .invite-link-container {
              display: flex;
              gap: 8px;
              margin: 16px 0;
            }

            .invite-link-input {
              flex: 1;
              padding: 12px 16px;
              border: 2px solid #e0e0e0;
              border-radius: 8px;
              font-size: 14px;
              color: #666;
            }

            .copy-btn,
            .share-btn {
              padding: 12px 20px;
              border: none;
              border-radius: 8px;
              cursor: pointer;
              font-weight: 600;
              transition: all 0.2s;
            }

            .copy-btn {
              background: #3b82f6;
              color: white;
            }

            .copy-btn:hover {
              background: #2563eb;
            }

            .share-buttons {
              display: flex;
              gap: 12px;
              margin-top: 16px;
            }

            .share-btn {
              flex: 1;
              display: flex;
              align-items: center;
              justify-content: center;
              gap: 8px;
            }

            .share-btn.whatsapp {
              background: #25D366;
              color: white;
            }

            .share-btn.sms {
              background: #6366f1;
              color: white;
            }

            .close-modal {
              margin-top: 16px;
              width: 100%;
              padding: 12px;
              background: #f3f4f6;
              border: none;
              border-radius: 8px;
              cursor: pointer;
              font-weight: 500;
            }

            .generate-btn {
              background: #10b981;
              color: white;
              border: none;
              padding: 12px 24px;
              border-radius: 8px;
              cursor: pointer;
              font-weight: 600;
              width: 100%;
            }

            .generate-btn:hover {
              background: #059669;
            }

            .invite-status {
              padding: 12px;
              border-radius: 8px;
              margin-top: 12px;
              display: none;
            }

            .invite-status.success {
              background: #d1fae5;
              color: #065f46;
              display: block;
            }

            .invite-status.error {
              background: #fee2e2;
              color: #991b1b;
              display: block;
            }

            .message-banner {
              padding: 12px 20px;
              border-radius: 8px;
              margin-bottom: 16px;
            }

            .message-banner.success {
              background: #d1fae5;
              color: #065f46;
            }

            .message-banner.error {
              background: #fee2e2;
              color: #991b1b;
            }

            /* Role Management Styles */
            .member-card {
              position: relative;
            }

            .member-actions {
              display: flex;
              align-items: center;
              gap: 8px;
              margin-left: auto;
            }

            .role-select {
              padding: 6px 12px;
              border: 2px solid #e0e0e0;
              border-radius: 8px;
              font-size: 13px;
              font-weight: 500;
              color: #374151;
              background: white;
              cursor: pointer;
              transition: all 0.2s;
              appearance: auto;
            }

            .role-select:hover {
              border-color: #6366f1;
            }

            .role-select:focus {
              outline: none;
              border-color: #6366f1;
              box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
            }

            .remove-member-btn {
              padding: 6px 10px;
              border: none;
              border-radius: 8px;
              background: #fee2e2;
              color: #dc2626;
              cursor: pointer;
              font-size: 12px;
              font-weight: 600;
              transition: all 0.2s;
            }

            .remove-member-btn:hover {
              background: #fecaca;
            }

            .member-role.editor {
              background: #dbeafe;
              color: #1d4ed8;
            }

            .member-role.viewer {
              background: #f3f4f6;
              color: #6b7280;
            }

            /* Override member-card to allow actions inline */
            .members-grid .member-card {
              display: flex;
              align-items: center;
              text-decoration: none;
            }

            .floating-btn.leave-btn {
              background: #ef4444 !important;
              color: white;
            }

            .floating-btn.leave-btn:hover {
              background: #dc2626 !important;
            }
          </style>
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

          // Invite Modal Functions
          function openInviteModal() {
            document.getElementById('inviteModal').classList.add('active');
          }

          function closeInviteModal() {
            document.getElementById('inviteModal').classList.remove('active');
          }

          function generateInviteLink() {
            const groupId = document.getElementById('groupId').value;
            const generateBtn = document.querySelector('.generate-btn');
            const statusDiv = document.getElementById('inviteStatus');

            generateBtn.disabled = true;
            generateBtn.textContent = 'Generating...';

            fetch('${pageContext.request.contextPath}/group/invite/generate', {
              method: 'POST',
              headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
              },
              body: 'groupId=' + groupId
            })
              .then(response => response.json())
              .then(data => {
                if (data.success) {
                  document.getElementById('inviteLinkInput').value = data.inviteUrl;
                  document.getElementById('linkContainer').style.display = 'flex';
                  document.getElementById('shareButtons').style.display = 'flex';
                  generateBtn.style.display = 'none';
                  statusDiv.textContent = 'Link generated successfully!';
                  statusDiv.className = 'invite-status success';
                } else {
                  statusDiv.textContent = data.error || 'Failed to generate link';
                  statusDiv.className = 'invite-status error';
                  generateBtn.disabled = false;
                  generateBtn.textContent = 'Generate Invite Link';
                }
              })
              .catch(error => {
                statusDiv.textContent = 'Error generating link';
                statusDiv.className = 'invite-status error';
                generateBtn.disabled = false;
                generateBtn.textContent = 'Generate Invite Link';
              });
          }

          function copyInviteLink() {
            const input = document.getElementById('inviteLinkInput');
            input.select();
            document.execCommand('copy');

            const btn = document.querySelector('.copy-btn');
            btn.textContent = 'Copied!';
            setTimeout(() => btn.textContent = 'Copy', 2000);
          }

          function shareWhatsApp() {
            const link = document.getElementById('inviteLinkInput').value;
            const text = encodeURIComponent('Join our group on Everly! ' + link);
            window.open('https://wa.me/?text=' + text, '_blank');
          }

          function shareSMS() {
            const link = document.getElementById('inviteLinkInput').value;
            const text = encodeURIComponent('Join our group on Everly! ' + link);
            window.open('sms:?body=' + text, '_blank');
          }

          // Role Management Functions
          function updateMemberRole(groupId, memberId, newRole) {
            if (!confirm('Change this member\'s role to ' + newRole + '?')) return;

            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/groupmembersservlet';

            const fields = {
              action: 'updateRole',
              groupId: groupId,
              memberId: memberId,
              role: newRole
            };

            for (const [key, value] of Object.entries(fields)) {
              const input = document.createElement('input');
              input.type = 'hidden';
              input.name = key;
              input.value = value;
              form.appendChild(input);
            }

            document.body.appendChild(form);
            form.submit();
          }

          function removeMember(groupId, memberId, username) {
            if (!confirm('Remove ' + username + ' from this group? This action cannot be undone.')) return;

            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/groupmembersservlet';

            const fields = {
              action: 'removeMember',
              groupId: groupId,
              memberId: memberId
            };

            for (const [key, value] of Object.entries(fields)) {
              const input = document.createElement('input');
              input.type = 'hidden';
              input.name = key;
              input.value = value;
              form.appendChild(input);
            }

            document.body.appendChild(form);
            form.submit();
          }

          function leaveGroup(groupId) {
            if (!confirm('Are you sure you want to leave this group? You will lose access to all group memories.')) return;

            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/groupmembersservlet';

            const fields = {
              action: 'leaveGroup',
              groupId: groupId
            };

            for (const [key, value] of Object.entries(fields)) {
              const input = document.createElement('input');
              input.type = 'hidden';
              input.name = key;
              input.value = value;
              form.appendChild(input);
            }

            document.body.appendChild(form);
            form.submit();
          }
        </script>

        <body>

          <% Group group=(Group) request.getAttribute("group"); List<GroupMember> members = (List<GroupMember>)
              request.getAttribute("members");
              Boolean isAdmin = (Boolean) request.getAttribute("isAdmin");
              String successMessage = (String) request.getAttribute("successMessage");
              String errorMessage = (String) request.getAttribute("errorMessage");

              String groupName = group != null ? group.getName() : "Group";
              int groupId = group != null ? group.getGroupId() : 0;
              %>

              <!-- Hidden field for groupId -->
              <input type="hidden" id="groupId" value="<%= groupId %>">

              <!-- Page Wrapper -->
              <div class="page-wrapper">
                <main class="main-content">
                  <!-- Messages -->
                  <% if (successMessage !=null) { %>
                    <div class="message-banner success">
                      <%= successMessage %>
                    </div>
                    <% } %>
                      <% if (errorMessage !=null) { %>
                        <div class="message-banner error">
                          <%= errorMessage %>
                        </div>
                        <% } %>

                          <!-- Page Header -->
                          <div class="page-header">
                            <h1 class="group-name">
                              <%= groupName %>
                            </h1>
                            <p class="group-creator">
                              <% if (group !=null && group.getDescription() !=null && !group.getDescription().isEmpty())
                                { %>
                                <%= group.getDescription() %>
                                  <% } else { %>
                                    Created by You
                                    <% } %>
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

                          <!-- Members Grid -->
                          <div class="members-grid">
                            <% if (members !=null && !members.isEmpty()) { String[] avatarColors={"#6366f1", "#ec4899"
                              , "#f59e0b" , "#10b981" , "#3b82f6" , "#8b5cf6" , "#ef4444" , "#14b8a6" }; int
                              colorIndex=0; for (GroupMember member : members) { String
                              username=member.getUser().getUsername(); String initials="" ; if (username !=null &&
                              username.length()> 0) {
                              String[] parts = username.split(" ");
                              if (parts.length >= 2) {
                              initials = (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
                              } else {
                              initials = username.substring(0, Math.min(2, username.length())).toUpperCase();
                              }
                              }

                              String role = member.getRole();
                              boolean isAdminMember = "admin".equalsIgnoreCase(role);
                              boolean isEditorMember = "editor".equalsIgnoreCase(role);
                              boolean isViewerMember = "viewer".equalsIgnoreCase(role);
                              String avatarColor = avatarColors[colorIndex % avatarColors.length];
                              colorIndex++;
                              int memberId = member.getUser().getId();
                              %>
                              <div class="member-card">
                                <a href="${pageContext.request.contextPath}/groupprofile?memberId=<%= memberId %>&groupId=<%= groupId %>"
                                  style="display: flex; align-items: center; text-decoration: none; color: inherit; flex: 1;">
                                  <div class="member-avatar" style="background: <%= avatarColor %>; color: white;">
                                    <%= initials %>
                                  </div>
                                  <div class="member-details">
                                    <h3 class="member-name">
                                      <%= username %>
                                    </h3>
                                    <span class="member-role <%= isAdminMember ? " admin" : isEditorMember ? "editor"
                                      : "viewer" %>">
                                      <%= isAdminMember ? "Admin" : isEditorMember ? "Editor" : "Viewer" %>
                                    </span>
                                  </div>
                                </a>

                                <% if (isAdmin !=null && isAdmin && !isAdminMember) { %>
                                  <div class="member-actions">
                                    <select class="role-select"
                                      onchange="updateMemberRole(<%= groupId %>, <%= memberId %>, this.value)">
                                      <option value="" disabled selected>Change Role</option>
                                      <option value="editor" <%=isEditorMember ? "disabled" : "" %>>Editor</option>
                                      <option value="viewer" <%=isViewerMember ? "disabled" : "" %>>Viewer</option>
                                    </select>
                                    <button class="remove-member-btn"
                                      onclick="event.preventDefault(); removeMember(<%= groupId %>, <%= memberId %>, '<%= username.replace("'", "\\'") %>')">
                                      Remove
                                    </button>
                                  </div>
                                  <% } %>
                              </div>
                              <% } } else { %>
                                <p style="text-align: center; color: #888; grid-column: 1/-1; padding: 40px;">No members
                                  yet. Invite people to join!</p>
                                <% } %>
                          </div>

                          <!-- Floating Buttons -->
                          <div class="floating-buttons" id="floatingButtons">
                            <% if (isAdmin !=null && isAdmin) { %>
                              <button onclick="openInviteModal()" class="floating-btn" style="background: #10b981;">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                  stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                  <path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                  <circle cx="8.5" cy="7" r="4"></circle>
                                  <line x1="20" y1="8" x2="20" y2="14"></line>
                                  <line x1="23" y1="11" x2="17" y2="11"></line>
                                </svg>
                                Invite Members
                              </button>
                              <% } %>
                                <% if (isAdmin !=null && isAdmin) { %>
                                  <a href="${pageContext.request.contextPath}/editgroup?groupId=<%= groupId %>"
                                    class="floating-btn edit-btn">
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                      stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                      <path d="M17 3a2.828 2.828 0 1 1 4 4L7.5 20.5 2 22l1.5-5.5L17 3z"></path>
                                    </svg>
                                    Edit Group
                                  </a>
                                  <% } %>
                                    <% if (isAdmin==null || !isAdmin) { %>
                                      <button onclick="leaveGroup(<%= groupId %>)" class="floating-btn leave-btn">
                                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                                          stroke="currentColor" stroke-width="2.5" stroke-linecap="round"
                                          stroke-linejoin="round">
                                          <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
                                          <polyline points="16 17 21 12 16 7"></polyline>
                                          <line x1="21" y1="12" x2="9" y2="12"></line>
                                        </svg>
                                        Leave Group
                                      </button>
                                      <% } %>
                          </div>
                </main>
              </div>

              <!-- Invite Modal -->
              <div class="invite-modal-overlay" id="inviteModal">
                <div class="invite-modal">
                  <h3>Invite Members to <%= groupName %>
                  </h3>
                  <p style="color: #666; margin-bottom: 16px;">Generate a shareable link that anyone can use to join
                    this group.</p>

                  <button class="generate-btn" onclick="generateInviteLink()">Generate Invite Link</button>

                  <div class="invite-link-container" id="linkContainer" style="display: none;">
                    <input type="text" class="invite-link-input" id="inviteLinkInput" readonly>
                    <button class="copy-btn" onclick="copyInviteLink()">Copy</button>
                  </div>

                  <div class="share-buttons" id="shareButtons" style="display: none;">
                    <button class="share-btn whatsapp" onclick="shareWhatsApp()">
                      <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                        <path
                          d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 01-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 01-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 012.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0012.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L.057 24l6.305-1.654a11.882 11.882 0 005.683 1.448h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 00-3.48-8.413z" />
                      </svg>
                      WhatsApp
                    </button>
                    <button class="share-btn sms" onclick="shareSMS()">
                      <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                        stroke-width="2">
                        <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path>
                      </svg>
                      SMS
                    </button>
                  </div>

                  <div class="invite-status" id="inviteStatus"></div>

                  <button class="close-modal" onclick="closeInviteModal()">Close</button>
                </div>
              </div>

              <jsp:include page="../public/footer.jsp" />

        </body>

        </html>