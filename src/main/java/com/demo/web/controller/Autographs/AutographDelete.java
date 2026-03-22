package com.demo.web.controller.Autographs;

import com.demo.web.dto.Autographs.AutographDeleteRequest;
import com.demo.web.dto.Autographs.AutographDeleteResponse;
import com.demo.web.service.AutographService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/autograph/delete")
public class AutographDelete extends HttpServlet {

    private AutographService autographService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.autographService = new AutographService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = (Integer) request.getSession().getAttribute("user_id");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        AutographDeleteRequest req = new AutographDeleteRequest(userId, request.getParameter("autographId"));
        AutographDeleteResponse res = autographService.deleteAutograph(req);

        response.sendRedirect(request.getContextPath() + res.getRedirectUrl());
    }
}