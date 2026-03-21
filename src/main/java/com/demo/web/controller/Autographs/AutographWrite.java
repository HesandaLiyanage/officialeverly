package com.demo.web.controller.Autographs;

import com.demo.web.dto.Autographs.AutographWriteRequest;
import com.demo.web.dto.Autographs.AutographWriteResponse;
import com.demo.web.service.AutographService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/write-autograph")
public class AutographWrite extends HttpServlet {

    private AutographService autographService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.autographService = new AutographService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        AutographWriteRequest req = new AutographWriteRequest(request.getParameter("token"));
        AutographWriteResponse res = autographService.getWriteView(req);

        if (!res.isSuccess()) {
            response.sendError(res.getErrorCode());
            return;
        }

        request.setAttribute("autograph", res.getAutograph());
        request.setAttribute("shareToken", res.getShareToken());
        request.setAttribute("displayTitle", res.getDisplayTitle());
        request.getRequestDispatcher(res.getRedirectUrl()).forward(request, response);
    }
}
