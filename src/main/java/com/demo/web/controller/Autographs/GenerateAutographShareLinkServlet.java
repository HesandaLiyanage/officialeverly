package com.demo.web.controller.Autographs;

import com.demo.web.dao.autographDAO;
import com.demo.web.model.autograph;
import com.demo.web.service.AuthService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * Generates a share link for an autograph book.
 * Mapped to /generateShareLink in web.xml.
 * Returns JSON: { "success": true, "shareUrl": "..." } or { "success": false,
 * "error": "..." }
 */
public class GenerateAutographShareLinkServlet extends HttpServlet {

    private AuthService authService;

    @Override
    public void init() throws ServletException {
        super.init();
        authService = new AuthService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        // Validate session
        if (!authService.isValidSession(request)) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.write("{\"success\": false, \"error\": \"Not logged in\"}");
            return;
        }

        String autographIdParam = request.getParameter("autographId");
        if (autographIdParam == null || autographIdParam.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write("{\"success\": false, \"error\": \"Missing autographId parameter\"}");
            return;
        }

        try {
            int autographId = Integer.parseInt(autographIdParam);
            int userId = authService.getUserId(request);

            autographDAO dao = new autographDAO();

            // Verify ownership - only the owner can generate a share link
            autograph ag = dao.findById(autographId);
            if (ag == null) {
                out.write("{\"success\": false, \"error\": \"Autograph not found\"}");
                return;
            }
            if (ag.getUserId() != userId) {
                out.write("{\"success\": false, \"error\": \"You don't own this autograph\"}");
                return;
            }

            // Get or create the share token
            String token = dao.getOrCreateShareToken(autographId);

            // Build the full share URL
            String baseUrl = request.getScheme() + "://" + request.getServerName();
            int port = request.getServerPort();
            if ((request.getScheme().equals("http") && port != 80) ||
                    (request.getScheme().equals("https") && port != 443)) {
                baseUrl += ":" + port;
            }
            baseUrl += request.getContextPath();

            String shareUrl = baseUrl + "/write-autograph?token=" + token;

            out.write("{\"success\": true, \"shareUrl\": \"" + shareUrl + "\"}");

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write("{\"success\": false, \"error\": \"Invalid autograph ID\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("{\"success\": false, \"error\": \"Server error: " + e.getMessage() + "\"}");
        }
    }
}
