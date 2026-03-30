package com.demo.web.controller.Autographs;

import com.demo.web.dto.Autographs.AutographEntrySubmitRequest;
import com.demo.web.dto.Autographs.AutographEntrySubmitResponse;
import com.demo.web.service.AutographService;
import com.demo.web.service.AuthService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

public class AutographEntrySubmit extends HttpServlet {

    private AuthService authService;
    private AutographService autographService;

    @Override
    public void init() throws ServletException {
        super.init();
        authService = new AuthService();
        autographService = new AutographService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        if (!authService.isValidSession(request)) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.write("{\"success\": false, \"message\": \"You must be logged in to submit an autograph.\"}");
            return;
        }

        AutographEntrySubmitRequest req = new AutographEntrySubmitRequest(
            authService.getUserId(request),
            request.getParameter("token"),
            request.getParameter("content"),
            request.getParameter("author"),
            request.getParameter("contentPlain")
        );

        AutographEntrySubmitResponse res = autographService.submitEntry(req);

        if (!res.isSuccess()) {
            response.setStatus(res.getStatusCode());
        }
        
        out.write("{\"success\": " + res.isSuccess() + ", \"message\": \"" + res.getMessage() + "\"}");
    }
}
