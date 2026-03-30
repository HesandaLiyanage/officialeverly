package com.demo.web.controller.Groups;

import com.demo.web.dto.Groups.GroupAnnouncementViewRequest;
import com.demo.web.dto.Groups.GroupAnnouncementViewResponse;
import com.demo.web.service.GroupService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class GroupAnnouncementView extends HttpServlet {

    private GroupService groupService;

    @Override
    public void init() throws ServletException {
        groupService = new GroupService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer currentUserId = (Integer) session.getAttribute("user_id");
        String idStr = request.getParameter("id");

        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/groups");
            return;
        }

        GroupAnnouncementViewRequest req = new GroupAnnouncementViewRequest(currentUserId, idStr);
        GroupAnnouncementViewResponse res = groupService.viewGroupAnnouncement(req);

        if (!res.isSuccess()) {
            response.sendRedirect(request.getContextPath() + res.getRedirectUrl());
            return;
        }

        request.setAttribute("announcement", res.getAnnouncement());
        request.setAttribute("authorInitial", res.getAuthorInitial());
        request.setAttribute("authorName", res.getAuthorName());
        request.setAttribute("postDate", res.getPostDate());
        request.setAttribute("hasEvent", res.isHasEvent());
        
        if (res.getEventPicUrl() != null) {
            request.setAttribute("eventPicUrl", request.getContextPath() + res.getEventPicUrl());
        }
        
        request.setAttribute("formattedEventDate", res.getFormattedEventDate());
        request.setAttribute("linkedEventTitle", res.getLinkedEventTitle());
        request.setAttribute("currentUserId", res.getCurrentUserId());

        if (res.isHasEvent()) {
            request.setAttribute("pollEventId", res.getPollEventId());
            request.setAttribute("pollGroupId", res.getPollGroupId());
            request.setAttribute("totalVotes", res.getTotalVotes());
            request.setAttribute("goingCount", res.getGoingCount());
            request.setAttribute("notGoingCount", res.getNotGoingCount());
            request.setAttribute("maybeCount", res.getMaybeCount());
            request.setAttribute("goingPercent", res.getGoingPercent());
            request.setAttribute("notGoingPercent", res.getNotGoingPercent());
            request.setAttribute("maybePercent", res.getMaybePercent());
            request.setAttribute("userCurrentVote", res.getUserCurrentVote());
            request.setAttribute("voterDisplayData", res.getVoterDisplayData());
            request.setAttribute("totalVotesLabel", res.getTotalVotesLabel());
        }

        request.getRequestDispatcher("/WEB-INF/views/app/Groups/viewannouncement.jsp").forward(request, response);
    }
}
