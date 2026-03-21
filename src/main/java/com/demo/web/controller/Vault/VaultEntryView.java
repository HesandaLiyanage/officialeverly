package com.demo.web.controller.Vault;

import com.demo.web.service.VaultService;
import com.demo.web.dto.Vault.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/vaultentries")
public class VaultEntryView extends HttpServlet {

    private VaultService vaultService;

    @Override
    public void init() throws ServletException {
        vaultService = new VaultService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        VaultSetupGetRequest req = new VaultSetupGetRequest((Integer) session.getAttribute("user_id"));
        VaultSetupGetResponse res = vaultService.getSetupState(req);

        if (!res.isHasSetup()) {
            response.sendRedirect(request.getContextPath() + "/vaultSetup");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/app/Vault/vaultentries.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        VaultEntryPostRequest req = new VaultEntryPostRequest(
            (Integer) session.getAttribute("user_id"), 
            request.getParameter("vaultPassword")
        );

        VaultEntryPostResponse res = vaultService.verifyEntry(req);

        if (res.isValid()) {
            session.setAttribute("vault_unlocked", true);
            request.setAttribute("vaultUnlocked", true);
        } else {
            request.setAttribute("errorMessage", res.getErrorMessage());
        }
        
        request.getRequestDispatcher("/WEB-INF/views/app/Vault/vaultentries.jsp").forward(request, response);
    }
}
