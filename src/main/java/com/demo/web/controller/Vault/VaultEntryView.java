package com.demo.web.controller.Vault;

import com.demo.web.service.VaultService;
import com.demo.web.dto.Vault.*;
import com.demo.web.util.ControllerSessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
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
        Integer userId = ControllerSessionUtil.requireUserId(request, response);
        if (userId == null) {
            return;
        }

        Boolean vaultUnlocked = (Boolean) request.getSession().getAttribute("vault_unlocked");
        if (Boolean.TRUE.equals(vaultUnlocked)) {
            response.sendRedirect(request.getContextPath() + "/vaultmemories");
            return;
        }

        VaultSetupGetRequest req = new VaultSetupGetRequest(userId);
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
        Integer userId = ControllerSessionUtil.requireUserId(request, response);
        if (userId == null) {
            return;
        }

        VaultEntryPostRequest req = new VaultEntryPostRequest(
            userId,
            request.getParameter("vaultPassword")
        );

        VaultEntryPostResponse res = vaultService.verifyEntry(req);

        if (res.isValid()) {
            request.getSession().setAttribute("vault_unlocked", true);
            response.sendRedirect(request.getContextPath() + "/vaultmemories");
            return;
        } else {
            request.setAttribute("errorMessage", res.getErrorMessage());
        }
        
        request.getRequestDispatcher("/WEB-INF/views/app/Vault/vaultentries.jsp").forward(request, response);
    }
}
