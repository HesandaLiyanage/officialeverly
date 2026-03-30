package com.demo.web.controller.Api;

import com.demo.web.dao.Vault.VaultDAO;
import com.demo.web.dao.Journals.JournalDAO;
import com.demo.web.model.Journals.Journal;
import com.demo.web.dao.Memory.memoryDAO;
import com.demo.web.model.Memory.Memory;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.IOException;
import java.util.List;

@WebServlet("/api/vault/verify")
public class VaultVerifyApiServlet extends HttpServlet {
    private VaultDAO vaultDao;
    private JournalDAO journalDao;
    private memoryDAO memoryDao;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        vaultDao = new VaultDAO();
        journalDao = new JournalDAO();
        memoryDao = new memoryDAO();
        gson = new Gson();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        JsonObject jsonResponse = new JsonObject();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("error", "Not authenticated");
            response.getWriter().write(gson.toJson(jsonResponse));
            return;
        }

        try {
            Integer userId = (Integer) session.getAttribute("user_id");
            
            // Check if vault is set up
            if (!vaultDao.hasVaultSetup(userId)) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("setup_required", true);
                response.getWriter().write(gson.toJson(jsonResponse));
                return;
            }

            BufferedReader reader = request.getReader();
            JsonObject reqBody = gson.fromJson(reader, JsonObject.class);
            
            if (reqBody == null || !reqBody.has("password")) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("error", "Vault password is required");
                response.getWriter().write(gson.toJson(jsonResponse));
                return;
            }
            
            String password = reqBody.get("password").getAsString();

            if (vaultDao.verifyVaultPassword(userId, password)) {
                
                // Fetch secure items dynamically
                List<Journal> vaultJournals = journalDao.getVaultJournalsByUserId(userId);
                
                // Send back the vault payload securely decoded on success
                jsonResponse.addProperty("success", true);
                jsonResponse.add("journals", gson.toJsonTree(vaultJournals));
                response.getWriter().write(gson.toJson(jsonResponse));
                
            } else {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("error", "Invalid vault password");
                response.getWriter().write(gson.toJson(jsonResponse));
            }

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("error", e.getMessage());
            response.getWriter().write(gson.toJson(jsonResponse));
        }
    }
}
