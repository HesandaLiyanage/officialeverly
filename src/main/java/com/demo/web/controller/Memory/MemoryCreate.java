package com.demo.web.controller.Memory;

import com.demo.web.dto.Memory.MemoryCreatePageRequest;
import com.demo.web.dto.Memory.MemoryCreatePageResponse;
import com.demo.web.dto.Memory.MemoryCreateRequest;
import com.demo.web.dto.Memory.MemoryCreateResponse;
import com.demo.web.service.MemoryService;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
        maxFileSize = 1024 * 1024 * 50,       // 50MB per file
        maxRequestSize = 1024 * 1024 * 100    // 100MB total request
)
public class MemoryCreate extends HttpServlet {

    private MemoryService memoryService;

    @Override
    public void init() throws ServletException {
        super.init();
        memoryService = new MemoryService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");

        MemoryCreatePageRequest createPageRequest = new MemoryCreatePageRequest(userId);
        MemoryCreatePageResponse createPageResponse = memoryService.getCreatePageData(createPageRequest);

        if (createPageResponse.isLimitReached()) {
            response.sendRedirect(request.getContextPath() + "/changeplan?reason=limit");
            return;
        }

        if (!createPageResponse.isAllowed()) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, createPageResponse.getErrorMessage());
            return;
        }

        String type = request.getParameter("type");
        request.setAttribute("isCollaborative", "collab".equals(type));

        request.getRequestDispatcher("/WEB-INF/views/memories/createMemory.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            sendJsonResponse(response, HttpServletResponse.SC_UNAUTHORIZED, "{\"error\": \"Not logged in\"}");
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");

        try {
            MemoryCreateRequest createRequest = new MemoryCreateRequest();
            createRequest.setUserId(userId);
            createRequest.setMemoryName(request.getParameter("memoryName"));
            createRequest.setMemoryDate(request.getParameter("memoryDate"));
            createRequest.setUserName(request.getParameter("userName"));

            String isCollabParam = request.getParameter("isCollaborative");
            createRequest.setCollaborative("true".equalsIgnoreCase(isCollabParam) || "on".equalsIgnoreCase(isCollabParam));

            String groupIdParam = request.getParameter("groupId");
            if (groupIdParam != null && !groupIdParam.trim().isEmpty()) {
                try {
                    createRequest.setGroupId(Integer.parseInt(groupIdParam.trim()));
                } catch (NumberFormatException e) {
                    createRequest.setGroupId(null);
                }
            }

            createRequest.setMediaFiles(request.getParts());
            createRequest.setApplicationPath(request.getServletContext().getRealPath(""));

            MemoryCreateResponse createResponse = memoryService.createMemory(createRequest);

            if (!createResponse.isSuccess()) {
                sendJsonResponse(response, createResponse.getStatusCode(),
                    "{\"error\": \"" + createResponse.getErrorMessage().replace("\"", "'") + "\"}");
                return;
            }

            // Success
            String successJson = String.format(
                    "{\"success\": true, \"memoryId\": %d, \"filesUploaded\": %d, \"isCollaborative\": %s, \"groupId\": %s}",
                    createResponse.getMemoryId(),
                    createResponse.getFilesUploaded(),
                    createResponse.isCollaborative(),
                    createResponse.getGroupId() != null ? createResponse.getGroupId() : "null"
            );
            sendJsonResponse(response, HttpServletResponse.SC_OK, successJson);

        } catch (Exception e) {
            e.printStackTrace();
            sendJsonResponse(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                "{\"error\": \"Failed: " + e.getMessage().replace("\"", "'") + "\"}");
        }
    }

    private void sendJsonResponse(HttpServletResponse response, int statusCode, String jsonContent) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        response.setStatus(statusCode);
        try (PrintWriter out = response.getWriter()) {
            out.write(jsonContent);
        }
    }
}
