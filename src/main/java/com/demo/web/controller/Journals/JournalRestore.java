package com.demo.web.controller.Journals;

import com.demo.web.dto.Journals.JournalTrashRequest;
import com.demo.web.dto.Journals.JournalTrashResponse;
import com.demo.web.service.JournalService;
import com.demo.web.util.ControllerSessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/journal/restore")
public class JournalRestore extends HttpServlet {

    private JournalService journalService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.journalService = new JournalService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = ControllerSessionUtil.requireUserId(request, response);
        if (userId == null) {
            return;
        }

        JournalTrashRequest req = new JournalTrashRequest(userId, "restore", request.getParameter("recycleBinId"));
        JournalTrashResponse res = journalService.handleTrashAction(req);

        response.sendRedirect(request.getContextPath() + res.getRedirectUrl());
    }
}
