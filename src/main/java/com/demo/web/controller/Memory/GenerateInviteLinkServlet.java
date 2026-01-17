package com.demo.web.controller.Memory;

import com.demo.web.dao.InviteLinkDAO;
import com.demo.web.dao.MemoryMemberDAO;
import com.demo.web.dao.memoryDAO;
import com.demo.web.model.Memory;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.util.UUID;

/**
 * Servlet for generating invite links for collaborative memories
 * 
 * POST /memory/generate-invite
 * Parameters:
 * - memoryId: ID of the memory to generate invite for
 * - expiresInHours: (optional) hours until link expires
 * - maxUses: (optional) maximum number of uses
 */
public class GenerateInviteLinkServlet extends HttpServlet {

    private memoryDAO memoryDao;
    private InviteLinkDAO inviteLinkDao;
    private MemoryMemberDAO memberDao;

    @Override
    public void init() throws ServletException {
        memoryDao = new memoryDAO();
        inviteLinkDao = new InviteLinkDAO();
        memberDao = new MemoryMemberDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        // Check authentication
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.write("{\"error\": \"Not logged in\"}");
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");

        try {
            // Parse parameters
            String memoryIdParam = request.getParameter("memoryId");
            if (memoryIdParam == null || memoryIdParam.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.write("{\"error\": \"Memory ID is required\"}");
                return;
            }

            int memoryId = Integer.parseInt(memoryIdParam);

            // Get the memory
            Memory memory = memoryDao.getMemoryById(memoryId);
            if (memory == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.write("{\"error\": \"Memory not found\"}");
                return;
            }

            // Check if the user owns this memory
            if (memory.getUserId() != userId) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                out.write("{\"error\": \"You don't have permission to share this memory\"}");
                return;
            }

            // Generate a simple token
            String token = generateSimpleToken();

            // If memory is not yet collaborative, make it collaborative
            if (!memory.isCollaborative()) {
                // Add owner as the first member (simple - no encryption)
                memberDao.addMemberSimple(memoryId, userId, "owner");

                // Mark memory as collaborative
                memoryDao.setMemoryCollaborative(memoryId, true);

                System.out.println("Memory " + memoryId + " is now collaborative");
            }

            // Parse optional expiration time
            Timestamp expiresAt = null;
            String expiresInHoursParam = request.getParameter("expiresInHours");
            if (expiresInHoursParam != null && !expiresInHoursParam.isEmpty()) {
                int hours = Integer.parseInt(expiresInHoursParam);
                expiresAt = new Timestamp(System.currentTimeMillis() + (hours * 60L * 60L * 1000L));
            }

            // Parse optional max uses
            Integer maxUses = null;
            String maxUsesParam = request.getParameter("maxUses");
            if (maxUsesParam != null && !maxUsesParam.isEmpty()) {
                maxUses = Integer.parseInt(maxUsesParam);
            }

            // Create the invite link with the token
            inviteLinkDao.createInviteLinkWithToken(memoryId, userId, token, expiresAt, maxUses);

            // Build the full invite URL
            String baseUrl = request.getScheme() + "://" + request.getServerName();
            if (request.getServerPort() != 80 && request.getServerPort() != 443) {
                baseUrl += ":" + request.getServerPort();
            }
            baseUrl += request.getContextPath();
            String inviteUrl = baseUrl + "/invite/" + token;

            // Return success response
            response.setStatus(HttpServletResponse.SC_OK);
            out.write("{\"success\": true, \"token\": \"" + token + "\", \"inviteUrl\": \"" + inviteUrl + "\"}");

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write("{\"error\": \"Invalid parameter format\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("{\"error\": \"Failed to generate invite link: " + e.getMessage().replace("\"", "'") + "\"}");
        }
    }

    /**
     * Generate a simple unique token for invite links
     */
    private String generateSimpleToken() {
        return UUID.randomUUID().toString().replace("-", "");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // GET is not supported, return method not allowed
        response.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write("{\"error\": \"Use POST to generate invite links\"}");
    }
}
