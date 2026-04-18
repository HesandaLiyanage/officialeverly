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
        Integer userId = ControllerSessionUtil.requireUserId(request, response);
        if (userId == null) {
            return;
        }

        VaultMemoriesRequest req = new VaultMemoriesRequest(
            userId,
            null,
            (Boolean) request.getSession().getAttribute("vault_unlocked")
        );

        showVaultMemories(request, response, req, true);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Integer userId = ControllerSessionUtil.requireUserId(request, response);
        if (userId == null) {
            return;
        }

        VaultMemoriesRequest req = new VaultMemoriesRequest(
            userId,
            request.getParameter("vaultPassword"),
            null
        );

        showVaultMemories(request, response, req, false);
    }

    private void showVaultMemories(HttpServletRequest request, HttpServletResponse response, VaultMemoriesRequest req,
                                   boolean redirectWhenLocked)
            throws ServletException, IOException {
        VaultMemoriesResponse res = vaultService.getVaultMemories(req, request.getContextPath());

        if (!res.isHasSetup()) {
            response.sendRedirect(request.getContextPath() + "/vaultSetup");
            return;
        }

        if (!res.isAccessGranted()) {
            if (redirectWhenLocked) {
                response.sendRedirect(request.getContextPath() + "/vaultentries");
            } else {
                request.setAttribute("errorMessage", res.getErrorMessage());
                request.getRequestDispatcher("/WEB-INF/views/app/Vault/vaultentries.jsp").forward(request, response);
            }
            return;
        }

        request.setAttribute("memories", res.getMemories());
        request.setAttribute("memoriesCount", res.getMemoriesCount());
        request.setAttribute("storagePercentage", res.getStoragePercentage());
        request.setAttribute("storageUsedFormatted", res.getStorageUsedFormatted());
        request.setAttribute("storageTotalFormatted", res.getStorageTotalFormatted());
        request.getRequestDispatcher("/WEB-INF/views/app/Vault/vaultMemories.jsp").forward(request, response);
    }
}
