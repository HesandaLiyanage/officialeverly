package com.demo.web.controller.Events;

import com.demo.web.service.EventService;
import com.demo.web.dto.Events.EventVoteActionRequest;
import com.demo.web.dto.Events.EventVoteActionResponse;
import com.demo.web.dto.Events.EventVoteDataRequest;
import com.demo.web.dto.Events.EventVoteDataResponse;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

public class EventVote extends HttpServlet {

    private EventService eventService;

    @Override
    public void init() throws ServletException {
        eventService = new EventService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.setStatus(401);
            out.print("{\"success\": false, \"error\": \"Not logged in\"}");
            return;
        }
        Integer userId = (Integer) session.getAttribute("user_id");

        EventVoteActionRequest req = new EventVoteActionRequest(
            userId,
            request.getParameter("event_id"),
            request.getParameter("group_id"),
            request.getParameter("vote")
        );

        EventVoteActionResponse res = eventService.castVote(req);
        
        response.setStatus(res.getStatusCode());
        out.print(res.getJsonResponse());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.setStatus(401);
            out.print("{\"success\": false, \"error\": \"Not logged in\"}");
            return;
        }
        Integer userId = (Integer) session.getAttribute("user_id");

        EventVoteDataRequest req = new EventVoteDataRequest(
            userId,
            request.getParameter("event_id"),
            request.getParameter("group_id"),
            request.getParameter("type")
        );

        EventVoteDataResponse res = eventService.getVoteData(req);
        
        response.setStatus(res.getStatusCode());
        out.print(res.getJsonResponse());
    }
}
