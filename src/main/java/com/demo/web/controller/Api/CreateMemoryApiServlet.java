package com.demo.web.controller.Api;

import com.demo.web.dto.Memory.MemoryCreatePageRequest;
import com.demo.web.dto.Memory.MemoryCreatePageResponse;
import com.demo.web.dto.Memory.MemoryCreateRequest;
import com.demo.web.dto.Memory.MemoryCreateResponse;
import com.demo.web.service.MemoryService;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/api/memory/create")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
        maxFileSize = 1024 * 1024 * 50,       // 50MB per file
        maxRequestSize = 1024 * 1024 * 100    // 100MB total request
)
public class CreateMemoryApiServlet extends HttpServlet {

    private MemoryService memoryService;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        super.init();
        memoryService = new MemoryService();
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

        Integer userId = (Integer) session.getAttribute("user_id");

        try {
            MemoryCreatePageRequest createPageRequest = new MemoryCreatePageRequest(userId);
            MemoryCreatePageResponse createPageResponse = memoryService.getCreatePageData(createPageRequest);

            if (createPageResponse.isLimitReached()) {
                response.setStatus(HttpServletResponse.SC_PAYMENT_REQUIRED);
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("error", createPageResponse.getErrorMessage());
                response.getWriter().write(gson.toJson(jsonResponse));
                return;
            }

            if (!createPageResponse.isAllowed()) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("error", createPageResponse.getErrorMessage());
                response.getWriter().write(gson.toJson(jsonResponse));
                return;
            }

            MemoryCreateRequest createRequest = new MemoryCreateRequest();
            createRequest.setUserId(userId);
            // Android sends "title", web sends "memoryName"
            String title = request.getParameter("title");
            if(title == null) title = request.getParameter("memoryName");
            createRequest.setMemoryName(title);
            
            // Android sends "date", web sends "memoryDate"
            String date = request.getParameter("date");
            if(date == null) date = request.getParameter("memoryDate");
            createRequest.setMemoryDate(date);
            
            // Android might send description, but web Memory table schema maps description slightly differently.
            // Wait, does Memory model have description? Yes. Wait, the MemoryCreateRequest doesn't easily set description
            // unless we do. Let's assume title and date are minimum required.
            
            createRequest.setCollaborative(false); // Mobile app doesn't support collab yet
            createRequest.setMediaFiles(request.getParts());

            MemoryCreateResponse createResponse = memoryService.createMemory(createRequest);

            if (!createResponse.isSuccess()) {
                response.setStatus(createResponse.getStatusCode());
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("error", createResponse.getErrorMessage());
                response.getWriter().write(gson.toJson(jsonResponse));
                return;
            }

            jsonResponse.addProperty("success", true);
            jsonResponse.addProperty("memoryId", createResponse.getMemoryId());
            jsonResponse.addProperty("filesUploaded", createResponse.getFilesUploaded());
            response.getWriter().write(gson.toJson(jsonResponse));

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("error", e.getMessage());
            response.getWriter().write(gson.toJson(jsonResponse));
        }
    }
}
