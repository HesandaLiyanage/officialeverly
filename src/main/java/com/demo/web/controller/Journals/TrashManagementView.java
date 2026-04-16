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

@WebServlet("/trashmgtview")
public class TrashManagementView extends HttpServlet {

    private JournalService journalService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.journalService = new JournalService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = ControllerSessionUtil.requireUserId(request, response);
        if (userId == null) {
            return;
        }

        JournalTrashRequest req = new JournalTrashRequest(userId, null, null);
        JournalTrashResponse res = journalService.getTrash(req);

        request.setAttribute("trashItems", res.getTrashItems());
        request.getRequestDispatcher("/WEB-INF/views/app/Journals/trashmgt.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = ControllerSessionUtil.requireUserId(request, response);
        if (userId == null) {
            return;
        }

        JournalTrashRequest req = new JournalTrashRequest(userId, request.getParameter("action"), request.getParameter("recycleBinId"));
        JournalTrashResponse res = journalService.handleTrashAction(req);

        response.sendRedirect(request.getContextPath() + res.getRedirectUrl());
    }
}
