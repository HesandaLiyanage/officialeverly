package com.demo.web.controller.Autographs;

import com.demo.web.dto.Journals.JournalTrashRequest;
import com.demo.web.dto.Journals.JournalTrashResponse;
import com.demo.web.service.JournalService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/autograph/restore")
public class AutographRestore extends HttpServlet {

    private JournalService journalService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.journalService = new JournalService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = (Integer) request.getSession().getAttribute("user_id");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        JournalTrashRequest req = new JournalTrashRequest(userId, "restore", request.getParameter("recycleBinId"));
        JournalTrashResponse res = journalService.handleTrashAction(req);

        response.sendRedirect(request.getContextPath() + res.getRedirectUrl());
    }
}
