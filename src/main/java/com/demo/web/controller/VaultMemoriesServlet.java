package com.demo.web.controller;

import com.demo.web.dao.VaultDAO;
import com.demo.web.dao.memoryDAO;
import com.demo.web.dao.MediaDAO;
import com.demo.web.model.Memory;
import com.demo.web.model.MediaItem;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * Servlet to display vault memories
 * Requires vault password verification via POST first
 */
@WebServlet("/vaultmemories")
public class VaultMemoriesServlet extends HttpServlet {

    private VaultDAO vaultDAO;
    private memoryDAO memoryDao;
    private MediaDAO mediaDAO;

    @Override
    public void init() throws ServletException {
        vaultDAO = new VaultDAO();
        memoryDao = new memoryDAO();
        mediaDAO = new MediaDAO();
    }

    /**
     * GET - User must come from vault entry page with verified password
     * We require POST from vault entry to access this
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");

        // Check if vault is set up
        if (!vaultDAO.hasVaultSetup(userId)) {
            response.sendRedirect(request.getContextPath() + "/vaultSetup");
            return;
        }

        // Check if vault is unlocked in session
        Boolean vaultUnlocked = (Boolean) session.getAttribute("vault_unlocked");
        if (vaultUnlocked == null || !vaultUnlocked) {
            // Vault not unlocked, redirect to vault entry to verify password first
            response.sendRedirect(request.getContextPath() + "/vaultentries");
            return;
        }

        // Vault is unlocked in session, load vault memories
        try {
            List<Memory> vaultMemories = memoryDao.getVaultMemoriesByUserId(userId);

            // Load cover images for each memory
            for (Memory memory : vaultMemories) {
                if (memory.getCoverMediaId() != null) {
                    try {
                        MediaItem coverMedia = mediaDAO.getMediaById(memory.getCoverMediaId());
                        if (coverMedia != null) {
                            memory.setCoverUrl(request.getContextPath() + "/viewmedia?id=" + coverMedia.getMediaId());
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            }

            request.setAttribute("memories", vaultMemories);
            request.setAttribute("memoriesCount", vaultMemories.size());
            request.getRequestDispatcher("/views/app/vaultMemories.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading vault memories");
            request.getRequestDispatcher("/views/app/vaultentries.jsp").forward(request, response);
        }
    }

    /**
     * POST - Display vault memories after password verification
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");
        String vaultPassword = request.getParameter("vaultPassword");

        // Verify vault password
        if (vaultPassword == null || !vaultDAO.verifyVaultPassword(userId, vaultPassword)) {
            request.setAttribute("errorMessage", "Invalid vault password");
            request.getRequestDispatcher("/views/app/vaultentries.jsp").forward(request, response);
            return;
        }

        // Password verified, get vault memories
        try {
            List<Memory> vaultMemories = memoryDao.getVaultMemoriesByUserId(userId);

            // Load cover images for each memory
            for (Memory memory : vaultMemories) {
                if (memory.getCoverMediaId() != null) {
                    try {
                        MediaItem coverMedia = mediaDAO.getMediaById(memory.getCoverMediaId());
                        if (coverMedia != null) {
                            memory.setCoverUrl(request.getContextPath() + "/viewmedia?id=" + coverMedia.getMediaId());
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            }

            request.setAttribute("memories", vaultMemories);
            request.setAttribute("memoriesCount", vaultMemories.size());
            request.getRequestDispatcher("/views/app/vaultMemories.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading vault memories");
            request.getRequestDispatcher("/views/app/vaultentries.jsp").forward(request, response);
        }
    }
}
