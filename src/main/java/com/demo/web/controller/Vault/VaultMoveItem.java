package com.demo.web.controller.Vault;

import com.demo.web.service.VaultService;
import com.demo.web.dto.Vault.*;
import com.google.gson.JsonObject;
import com.demo.web.util.ControllerSessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
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

        Integer userId = ControllerSessionUtil.requireUserId(request, response);
        if (userId == null) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("error", "Not authenticated");
            out.print(jsonResponse.toString());
            return;
        }

        String type = firstNonBlank(request.getParameter("type"), request.getParameter("itemType"));
        String id = firstNonBlank(request.getParameter("id"), request.getParameter("itemId"), request.getParameter("idStr"));
        String action = request.getParameter("action");
        String vaultPassword = request.getParameter("vaultPassword");

        VaultMoveItemRequest req = new VaultMoveItemRequest(
            userId,
            type,
            id,
            action,
            vaultPassword
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

    private String firstNonBlank(String... values) {
        for (String value : values) {
            if (value != null && !value.trim().isEmpty()) {
                return value;
            }
        }
        return null;
    }
}
