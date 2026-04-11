package com.demo.web.controller.Events;

import com.demo.web.service.EventService;
import com.demo.web.dto.Events.*;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class EventView extends HttpServlet {

  private EventService eventService;

  @Override
  public void init() throws ServletException {
    super.init();
    // Removed authService initialization
    eventService = new EventService();
  }

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {

    // 1. Standardized Session Check (Matches EventCreate and EventUpdate exactly)
    HttpSession session = request.getSession(false);
    if (session == null || session.getAttribute("user_id") == null) {
      response.sendRedirect(request.getContextPath() + "/login");
      return;
    }

    // 2. Extract userId from the validated session
    Integer userId = (Integer) session.getAttribute("user_id");

    String action = request.getParameter("action");
    String eventIdParam = request.getParameter("event_id");
    if (eventIdParam == null && request.getParameter("id") != null) {
      eventIdParam = request.getParameter("id");
    }

    if ("create".equals(action)) {
      EventCreateFormRequest req = new EventCreateFormRequest(userId);
      EventCreateFormResponse res = eventService.getCreateFormData(req);

      if (res.isNoGroups()) {
        request.setAttribute("error", res.getErrorMessage());
        request.setAttribute("noGroups", true);
      } else if (res.getErrorMessage() != null) {
        request.setAttribute("error", res.getErrorMessage());
      }

      request.setAttribute("userGroups", res.getUserGroups());
      request.getRequestDispatcher("/WEB-INF/views/app/Events/createevent.jsp").forward(request, response);

    } else if ("edit".equals(action)) {
      EventEditFormRequest req = new EventEditFormRequest(userId, eventIdParam);
      EventEditFormResponse res = eventService.getEditFormData(req);

      // Removed authService.getSession(request); we use the global 'session' now

      if (!res.isSuccess()) {
        session.setAttribute("errorMessage", res.getErrorMessage());
        response.sendRedirect(request.getContextPath() + "/events");
        return;
      }

      request.setAttribute("event", res.getEvent());
      request.setAttribute("userGroups", res.getUserGroups());
      request.setAttribute("eventGroupIds", res.getEventGroupIds());
      request.setAttribute("formattedDate", res.getFormattedDate());
      if (res.getDisplayImageUrl() != null) {
        request.setAttribute("displayImageUrl", request.getContextPath() + "/" + res.getDisplayImageUrl());
      }

      String errorMessage = (String) request.getAttribute("error");
      if (errorMessage == null) {
        errorMessage = (String) session.getAttribute("errorMessage");
        if (errorMessage != null) session.removeAttribute("errorMessage");
      }
      if (errorMessage != null) request.setAttribute("errorMessage", errorMessage);

      request.getRequestDispatcher("/WEB-INF/views/app/Events/editevent.jsp").forward(request, response);

    } else if ("info".equals(action)) {
      EventInfoRequest req = new EventInfoRequest(userId, eventIdParam, request.getParameter("groupId"));
      EventInfoResponse res = eventService.getEventInfoData(req, request.getContextPath());

      if (!res.isSuccess()) {
        // Removed request.getSession(); we use the global 'session' now
        session.setAttribute("errorMessage", res.getErrorMessage());
        response.sendRedirect(request.getContextPath() + "/events");
        return;
      }

      request.setAttribute("voteCountsMap", res.getVoteCountsMap());
      request.setAttribute("userVoteMap", res.getUserVoteMap());
      request.setAttribute("votersMap", res.getVotersMap());

      request.setAttribute("event", res.getEvent());
      request.setAttribute("eventGroups", res.getEventGroups());
      request.setAttribute("formattedDate", res.getFormattedDate());
      request.setAttribute("hasImage", res.isHasImage());
      request.setAttribute("displayPicUrl", res.getDisplayPicUrl());
      request.setAttribute("isPastEvent", res.isPastEvent());
      request.setAttribute("groupNamesStr", res.getGroupNamesStr());
      request.setAttribute("pollGroups", res.getPollGroups());
      request.setAttribute("userId", res.getUserId());

      request.getRequestDispatcher("/WEB-INF/views/app/Events/eventinfo.jsp").forward(request, response);

    } else {
      // Dashboard
      EventDashboardRequest req = new EventDashboardRequest(userId);
      EventDashboardResponse res = eventService.getDashboardData(req);

      if (res.getErrorMessage() != null) {
        request.setAttribute("error", res.getErrorMessage());
      }

      request.setAttribute("isGroupAdmin", res.isGroupAdmin());
      request.setAttribute("allEvents", res.getAllEvents());
      request.setAttribute("upcomingEvents", res.getUpcomingEvents());
      request.setAttribute("pastEvents", res.getPastEvents());
      request.setAttribute("upcomingCount", res.getUpcomingCount());
      request.setAttribute("pastCount", res.getPastCount());
      request.setAttribute("totalCount", res.getTotalCount());

      request.getRequestDispatcher("/WEB-INF/views/app/Events/eventdashboard.jsp").forward(request, response);
    }
  }
}
