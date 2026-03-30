package com.demo.web.controller.Api;

import com.demo.web.dao.Events.EventDAO;
import com.demo.web.model.Events.Event;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;

@WebServlet("/api/events")
public class EventsApiServlet extends HttpServlet {
    private EventDAO eventDao;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        eventDao = new EventDAO();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        JsonObject jsonResponse = new JsonObject();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("error", "Not authenticated");
            response.getWriter().write(gson.toJson(jsonResponse));
            return;
        }

        try {
            Integer userId = (Integer) session.getAttribute("user_id");
            
            // Standard approach to just return all distinct items for Native Android list
            List<Event> upcomingEvents = eventDao.findUpcomingEventsByUserId(userId);
            List<Event> pastEvents = eventDao.findPastEventsByUserId(userId);
            
            HashMap<String, List<Event>> map = new HashMap<>();
            map.put("upcoming", upcomingEvents);
            map.put("past", pastEvents);
            
            response.getWriter().write(gson.toJson(map));

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("error", e.getMessage());
            response.getWriter().write(gson.toJson(jsonResponse));
        }
    }
}
