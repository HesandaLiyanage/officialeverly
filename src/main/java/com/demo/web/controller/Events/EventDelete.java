package com.demo.web.controller.Events;

import com.demo.web.service.EventService;
import com.demo.web.dto.Events.EventDeleteRequest;
import com.demo.web.dto.Events.EventDeleteResponse;
import com.demo.web.util.ControllerSessionUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class EventDelete extends HttpServlet {

    private EventService eventService;

    @Override
    public void init() throws ServletException {
        this.eventService = new EventService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        Integer userId = ControllerSessionUtil.requireUserId(request, response);
        if (userId == null) {
            return;
        }

        HttpSession session = request.getSession(false);

        try {
            EventDeleteRequest req = new EventDeleteRequest(
                userId,
                request.getParameter("event_id"),
                getServletContext().getRealPath("")
            );

            EventDeleteResponse res = eventService.deleteEvent(req);

            if (res.isSuccess()) {
                session.setAttribute("successMessage", "Event deleted successfully!");
            } else {
                session.setAttribute("errorMessage", res.getErrorMessage());
            }
            response.sendRedirect(request.getContextPath() + "/events");

        } catch (Exception e) {
            session.setAttribute("errorMessage", "An error occurred while deleting the event");
            response.sendRedirect(request.getContextPath() + "/events");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/events");
    }
}
