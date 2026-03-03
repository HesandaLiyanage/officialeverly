package com.demo.web.controller.Events;

import com.demo.web.dao.EventVoteDAO;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

/**
 * AJAX servlet for event voting (RSVP).
 * Supports casting votes and getting vote data (counts + voters).
 */
public class EventVote extends HttpServlet {

    private EventVoteDAO voteDAO;

    @Override
    public void init() throws ServletException {
        voteDAO = new EventVoteDAO();
    }

    /**
     * POST - Cast or update a vote
     * Params: event_id, group_id, vote (going/not_going/maybe)
     */
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

        int userId = (Integer) session.getAttribute("user_id");

        try {
            int eventId = Integer.parseInt(request.getParameter("event_id"));
            int groupId = Integer.parseInt(request.getParameter("group_id"));
            String vote = request.getParameter("vote");

            if (vote == null || (!vote.equals("going") && !vote.equals("not_going") && !vote.equals("maybe"))) {
                response.setStatus(400);
                out.print("{\"success\": false, \"error\": \"Invalid vote. Must be going, not_going, or maybe\"}");
                return;
            }

            // Check if user already voted the same thing -> toggle off (remove vote)
            String existingVote = voteDAO.getUserVote(eventId, groupId, userId);
            if (existingVote != null && existingVote.equals(vote)) {
                // Same vote = un-vote
                voteDAO.removeVote(eventId, groupId, userId);
            } else {
                // New or different vote = cast/update
                voteDAO.castVote(eventId, groupId, userId, vote);
            }

            // Return updated counts + user's current vote
            Map<String, Integer> counts = voteDAO.getVoteCounts(eventId, groupId);
            String currentVote = voteDAO.getUserVote(eventId, groupId, userId);

            out.print("{\"success\": true, " +
                    "\"going\": " + counts.get("going") + ", " +
                    "\"not_going\": " + counts.get("not_going") + ", " +
                    "\"maybe\": " + counts.get("maybe") + ", " +
                    "\"total\": " + counts.get("total") + ", " +
                    "\"userVote\": " + (currentVote != null ? "\"" + currentVote + "\"" : "null") +
                    "}");

        } catch (NumberFormatException e) {
            response.setStatus(400);
            out.print("{\"success\": false, \"error\": \"Invalid event_id or group_id\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(500);
            out.print("{\"success\": false, \"error\": \"Server error: " + e.getMessage() + "\"}");
        }
    }

    /**
     * GET - Get vote data for an event+group
     * Params: event_id, group_id
     * Optional: type=voters to get voter list
     */
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

        int userId = (Integer) session.getAttribute("user_id");

        try {
            int eventId = Integer.parseInt(request.getParameter("event_id"));
            int groupId = Integer.parseInt(request.getParameter("group_id"));
            String type = request.getParameter("type");

            if ("voters".equals(type)) {
                // Return voter list
                List<Map<String, Object>> voters = voteDAO.getVoters(eventId, groupId);
                StringBuilder sb = new StringBuilder("{\"success\": true, \"voters\": [");
                for (int i = 0; i < voters.size(); i++) {
                    Map<String, Object> v = voters.get(i);
                    sb.append("{");
                    sb.append("\"user_id\": ").append(v.get("user_id")).append(", ");
                    sb.append("\"username\": \"").append(escapeJson((String) v.get("username"))).append("\", ");
                    sb.append("\"profile_picture_url\": ")
                            .append(v.get("profile_picture_url") != null
                                    ? "\"" + escapeJson((String) v.get("profile_picture_url")) + "\""
                                    : "null")
                            .append(", ");
                    sb.append("\"vote\": \"").append(v.get("vote")).append("\"");
                    sb.append("}");
                    if (i < voters.size() - 1)
                        sb.append(", ");
                }
                sb.append("]}");
                out.print(sb.toString());
            } else {
                // Return counts + user's current vote
                Map<String, Integer> counts = voteDAO.getVoteCounts(eventId, groupId);
                String currentVote = voteDAO.getUserVote(eventId, groupId, userId);

                out.print("{\"success\": true, " +
                        "\"going\": " + counts.get("going") + ", " +
                        "\"not_going\": " + counts.get("not_going") + ", " +
                        "\"maybe\": " + counts.get("maybe") + ", " +
                        "\"total\": " + counts.get("total") + ", " +
                        "\"userVote\": " + (currentVote != null ? "\"" + currentVote + "\"" : "null") +
                        "}");
            }

        } catch (NumberFormatException e) {
            response.setStatus(400);
            out.print("{\"success\": false, \"error\": \"Invalid event_id or group_id\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(500);
            out.print("{\"success\": false, \"error\": \"Server error\"}");
        }
    }

    private String escapeJson(String s) {
        if (s == null)
            return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");
    }
}
