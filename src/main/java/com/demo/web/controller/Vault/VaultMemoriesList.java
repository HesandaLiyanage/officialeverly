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

@WebServlet("/vaultmemories")
public class VaultMemoriesList extends HttpServlet {

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

        VaultMemoriesRequest req = new VaultMemoriesRequest(
            (Integer) session.getAttribute("user_id"),
            null, // No password for GET
            (Boolean) session.getAttribute("vault_unlocked")
        );

        VaultMemoriesResponse res = vaultService.getVaultMemories(req, request.getContextPath());

        if (!res.isHasSetup()) {
            response.sendRedirect(request.getContextPath() + "/vaultSetup");
            return;
        }

        if (!res.isAccessGranted()) {
            response.sendRedirect(request.getContextPath() + "/vaultentries");
            return;
        }

        if (res.getErrorMessage() != null) {
            request.setAttribute("errorMessage", res.getErrorMessage());
            request.getRequestDispatcher("/WEB-INF/views/app/Vault/vaultentries.jsp").forward(request, response);
            return;
        }

        request.setAttribute("memories", res.getMemories());
        request.setAttribute("memoriesCount", res.getMemoriesCount());
        request.getRequestDispatcher("/WEB-INF/views/app/Vault/vaultMemories.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        VaultMemoriesRequest req = new VaultMemoriesRequest(
            (Integer) session.getAttribute("user_id"),
            request.getParameter("vaultPassword"),
            null
        );

        VaultMemoriesResponse res = vaultService.getVaultMemories(req, request.getContextPath());

        if (!res.isHasSetup()) {
            response.sendRedirect(request.getContextPath() + "/vaultSetup");
            return;
        }

        if (!res.isAccessGranted()) {
            request.setAttribute("errorMessage", res.getErrorMessage());
            request.getRequestDispatcher("/WEB-INF/views/app/Vault/vaultentries.jsp").forward(request, response);
            return;
        }

        if (res.getErrorMessage() != null) {
            request.setAttribute("errorMessage", res.getErrorMessage());
            request.getRequestDispatcher("/WEB-INF/views/app/Vault/vaultentries.jsp").forward(request, response);
            return;
        }

        request.setAttribute("memories", res.getMemories());
        request.setAttribute("memoriesCount", res.getMemoriesCount());
        request.getRequestDispatcher("/WEB-INF/views/app/Vault/vaultMemories.jsp").forward(request, response);
    }
}
