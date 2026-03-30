package com.demo.web.controller.Journals;

import com.demo.web.dto.Journals.JournalDeleteRequest;
import com.demo.web.dto.Journals.JournalDeleteResponse;
import com.demo.web.service.JournalService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/journal/delete")
public class JournalDelete extends HttpServlet {

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

        JournalDeleteRequest req = new JournalDeleteRequest(userId, request.getParameter("journalId"));
        JournalDeleteResponse res = journalService.deleteJournal(req);

        response.sendRedirect(request.getContextPath() + res.getRedirectUrl());
    }
}