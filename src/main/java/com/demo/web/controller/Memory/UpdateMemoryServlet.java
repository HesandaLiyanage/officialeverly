package com.demo.web.controller.Memory;

import com.demo.web.dao.memoryDAO;
import com.demo.web.model.Memory;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet for updating memory details
 */
public class UpdateMemoryServlet extends HttpServlet {

    private memoryDAO memoryDao;

    @Override
    public void init() throws ServletException {
        memoryDao = new memoryDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("/login");
            return;
        }

        int userId = (int) session.getAttribute("user_id");

        try {
            // Get form parameters
            String memoryIdParam = request.getParameter("memoryId");
            String title = request.getParameter("memoryName");
            String description = request.getParameter("memoryDescription");
            String[] removedMediaIds = request.getParameterValues("removedFileIds[]");

            // Debug logging
            System.out.println("=== UpdateMemoryServlet Debug ===");
            System.out.println("memoryId param: " + memoryIdParam);
            System.out.println("memoryName param: " + title);
            System.out.println("memoryDescription param: " + description);
            System.out.println("userId from session: " + userId);

            if (memoryIdParam == null || memoryIdParam.isEmpty()) {
                System.out.println("ERROR: memoryId is null or empty!");
                response.sendRedirect("/memories");
                return;
            }

            int memoryId = Integer.parseInt(memoryIdParam);

            // Fetch existing memory
            Memory memory = memoryDao.getMemoryById(memoryId);

            if (memory == null) {
                System.out.println("ERROR: Memory not found for id: " + memoryId);
                request.setAttribute("errorMessage", "Memory not found");
                response.sendRedirect("/memories");
                return;
            }

            // Check ownership
            if (memory.getUserId() != userId) {
                System.out.println("ERROR: User " + userId + " doesn't own memory " + memoryId + " (owned by "
                        + memory.getUserId() + ")");
                request.setAttribute("errorMessage", "You don't have permission to edit this memory");
                response.sendRedirect("/memories");
                return;
            }

            // Debug: print current values
            System.out.println("Current title: " + memory.getTitle());
            System.out.println("New title: " + title);

            // Update memory fields
            if (title != null && !title.trim().isEmpty()) {
                memory.setTitle(title.trim());
            }
            if (description != null) {
                memory.setDescription(description.trim());
            }

            // Save updates
            System.out.println("Attempting to update memory...");
            boolean updated = memoryDao.updateMemory(memory);
            System.out.println("Update result: " + updated);

            if (!updated) {
                System.out.println("ERROR: Update returned false!");
                request.setAttribute("errorMessage", "Failed to update memory");
                request.getRequestDispatcher("/views/app/editmemory.jsp").forward(request, response);
                return;
            }
            System.out.println("Memory updated successfully!");

            // Handle removed media items (TODO: implement unlinkMediaFromMemory in DAO)
            // For now, media removal is not implemented
            if (removedMediaIds != null && removedMediaIds.length > 0) {
                System.out.println(
                        "Note: Media removal requested for " + removedMediaIds.length + " items - not yet implemented");
            }

            // Redirect to memory view
            response.sendRedirect("/memoryview?id=" + memoryId);

        } catch (NumberFormatException e) {
            response.sendRedirect("/memories");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error updating memory: " + e.getMessage());
            response.sendRedirect("/memories");
        }
    }
}
