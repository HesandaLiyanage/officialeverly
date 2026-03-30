package com.demo.web.controller.Autographs;

import com.demo.web.dto.Autographs.AutographShareRequest;
import com.demo.web.dto.Autographs.AutographShareResponse;
import com.demo.web.service.AutographService;
import com.demo.web.service.AuthService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

public class AutographShareLink extends HttpServlet {

    private AuthService authService;
    private AutographService autographService;

    @Override
    public void init() throws ServletException {
        super.init();
        authService = new AuthService();
        autographService = new AutographService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        if (!authService.isValidSession(request)) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.write("{\"success\": false, \"error\": \"Not logged in\"}");
            return;
        }

        AutographShareRequest req = new AutographShareRequest(authService.getUserId(request), request.getParameter("autographId"));
        AutographShareResponse res = autographService.generateShareLink(req);

        if (res.isSuccess()) {
            // Parse token from internal JSON response, construct full URL
            String jsonOutput = res.getJsonOutput();
            String token = jsonOutput.substring(jsonOutput.indexOf("token\": \"") + 9, jsonOutput.lastIndexOf("\""));
            
            String baseUrl = request.getScheme() + "://" + request.getServerName();
            int port = request.getServerPort();
            if ((request.getScheme().equals("http") && port != 80) || (request.getScheme().equals("https") && port != 443)) {
                baseUrl += ":" + port;
            }
            baseUrl += request.getContextPath();

            String shareUrl = baseUrl + "/write-autograph?token=" + token;
            out.write("{\"success\": true, \"shareUrl\": \"" + shareUrl + "\"}");
        } else {
            out.write(res.getJsonOutput());
        }
    }
}
