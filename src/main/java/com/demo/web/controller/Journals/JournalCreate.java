package com.demo.web.controller.Journals;

import com.demo.web.dto.Journals.JournalCreateRequest;
import com.demo.web.dto.Journals.JournalCreateResponse;
import com.demo.web.service.JournalService;
import com.demo.web.util.ControllerSessionUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class JournalCreate extends HttpServlet {

    private JournalService journalService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.journalService = new JournalService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        Integer userId = ControllerSessionUtil.requireUserId(request, response);
        if (userId == null) {
            return;
        }

        JournalCreateRequest req = new JournalCreateRequest(
            userId,
            request.getParameter("content"),
            request.getParameter("decorations"),
            request.getParameter("backgroundTheme")
        );

        JournalCreateResponse res = journalService.createJournal(req);

        if (!res.isSuccess()) {
            request.setAttribute("error", res.getErrorMessage());
            request.getRequestDispatcher(res.getRedirectUrl()).forward(request, response);
            return;
        }

        response.sendRedirect(request.getContextPath() + res.getRedirectUrl());
    }
}
