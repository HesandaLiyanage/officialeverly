package com.demo.web.controller;

import com.demo.web.dao.VaultDAO;
import com.demo.web.dao.memoryDAO;
import com.demo.web.dao.JournalDAO;
import com.google.gson.JsonObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

/**
 * Servlet to handle moving items to/from vault
 * Used as an AJAX endpoint from memory and journal views
 */
@WebServlet("/moveToVault")
public class MoveToVaultServlet extends HttpServlet {

    private VaultDAO vaultDAO;
    private memoryDAO memoryDao;
    private JournalDAO journalDAO;

    @Override
    public void init() throws ServletException {
        vaultDAO = new VaultDAO();
        memoryDao = new memoryDAO();
        journalDAO = new JournalDAO();
    }

    /**
     * POST - Move item to or from vault
     * Parameters:
     * - type: "memory" or "journal"
     * - id: item ID
     * - action: "add" (move to vault) or "remove" (restore from vault)
     * - vaultPassword: required for verification
     */
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

        Integer userId = (Integer) session.getAttribute("user_id");

        String type = request.getParameter("type");
        String idStr = request.getParameter("id");
        String action = request.getParameter("action");
        String vaultPassword = request.getParameter("vaultPassword");

        // Validate parameters
        if (type == null || idStr == null || action == null) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("error", "Missing required parameters");
            out.print(jsonResponse.toString());
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("error", "Invalid ID");
            out.print(jsonResponse.toString());
            return;
        }

        // Check if vault is set up
        if (!vaultDAO.hasVaultSetup(userId)) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("error", "Vault not set up");
            jsonResponse.addProperty("redirectToSetup", true);
            out.print(jsonResponse.toString());
            return;
        }

        // For adding to vault, we need to verify the vault password
        if ("add".equals(action)) {
            if (vaultPassword == null || vaultPassword.isEmpty()) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("error", "Vault password required");
                jsonResponse.addProperty("requiresPassword", true);
                out.print(jsonResponse.toString());
                return;
            }

            if (!vaultDAO.verifyVaultPassword(userId, vaultPassword)) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("error", "Incorrect vault password");
                out.print(jsonResponse.toString());
                return;
            }
        }

        // Perform the action
        boolean success = false;
        try {
            if ("memory".equals(type)) {
                if ("add".equals(action)) {
                    success = memoryDao.moveToVault(id, userId);
                } else if ("remove".equals(action)) {
                    success = memoryDao.removeFromVault(id, userId);
                }
            } else if ("journal".equals(type)) {
                if ("add".equals(action)) {
                    success = journalDAO.moveToVault(id, userId);
                } else if ("remove".equals(action)) {
                    success = journalDAO.removeFromVault(id, userId);
                }
            } else {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("error", "Invalid type");
                out.print(jsonResponse.toString());
                return;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("error", "Database error");
            out.print(jsonResponse.toString());
            return;
        }

        if (success) {
            jsonResponse.addProperty("success", true);
            if ("add".equals(action)) {
                jsonResponse.addProperty("message",
                        type.substring(0, 1).toUpperCase() + type.substring(1) + " moved to vault");
            } else {
                jsonResponse.addProperty("message",
                        type.substring(0, 1).toUpperCase() + type.substring(1) + " restored from vault");
            }
        } else {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("error",
                    "Failed to " + (action.equals("add") ? "move to" : "remove from") + " vault");
        }

        out.print(jsonResponse.toString());
    }
}
