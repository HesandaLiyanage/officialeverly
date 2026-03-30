package com.demo.web.controller.Api;

import com.demo.web.dao.Groups.GroupDAO;
import com.demo.web.model.Groups.Group;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/api/groups")
public class GroupsApiServlet extends HttpServlet {
    private GroupDAO groupDao;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        groupDao = new GroupDAO();
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
            List<Group> groups = groupDao.findGroupsByMemberId(userId);
            response.getWriter().write(gson.toJson(groups));

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("error", e.getMessage());
            response.getWriter().write(gson.toJson(jsonResponse));
        }
    }
}
