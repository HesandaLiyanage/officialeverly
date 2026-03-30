package com.demo.web.controller.Vault;

import com.demo.web.service.VaultService;
import com.demo.web.dto.Vault.*;
import com.google.gson.JsonObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/moveToVault")
public class VaultMoveItem extends HttpServlet {

    private VaultService vaultService;

    @Override
    public void init() throws ServletException {
        vaultService = new VaultService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("error", "Not authenticated");
            out.print(jsonResponse.toString());
            return;
        }

        VaultMoveItemRequest req = new VaultMoveItemRequest(
            (Integer) session.getAttribute("user_id"),
            request.getParameter("type"),
            request.getParameter("id"),
            request.getParameter("action"),
            request.getParameter("vaultPassword")
        );

        VaultMoveItemResponse res = vaultService.moveItem(req);

        jsonResponse.addProperty("success", res.isSuccess());
        
        if (res.isSuccess()) {
            jsonResponse.addProperty("message", res.getSuccessMessage());
        } else {
            jsonResponse.addProperty("error", res.getErrorMessage());
            if (res.isRedirectToSetup()) {
                jsonResponse.addProperty("redirectToSetup", true);
            }
            if (res.isRequiresPassword()) {
                jsonResponse.addProperty("requiresPassword", true);
            }
        }

        out.print(jsonResponse.toString());
    }
}
