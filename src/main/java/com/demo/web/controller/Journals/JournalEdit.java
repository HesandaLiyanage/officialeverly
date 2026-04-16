package com.demo.web.controller.Journals;

import com.demo.web.dto.Journals.JournalEditRequest;
import com.demo.web.dto.Journals.JournalEditResponse;
import com.demo.web.service.JournalService;
import com.demo.web.util.ControllerSessionUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class JournalEdit extends HttpServlet {

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

        JournalEditRequest req = new JournalEditRequest(
            userId,
            request.getParameter("journalId"),
            request.getParameter("title"),
            request.getParameter("content"),
            request.getParameter("decorations"),
            request.getParameter("backgroundTheme")
        );

        JournalEditResponse res = journalService.editJournal(req);

        if (!res.isSuccess()) {
            request.setAttribute("error", res.getErrorMessage());
            if (res.getJournal() != null) {
                request.setAttribute("journal", res.getJournal());
            }
            if (res.getRedirectUrl().contains("WEB-INF")) {
                request.getRequestDispatcher(res.getRedirectUrl()).forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + res.getRedirectUrl());
            }
            return;
        }

        response.sendRedirect(request.getContextPath() + res.getRedirectUrl());
    }
}
