package com.demo.web.controller.Events;

import com.demo.web.service.EventService;
import com.demo.web.dto.Events.EventCreateRequest;
import com.demo.web.dto.Events.EventCreateResponse;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
public class EventCreate extends HttpServlet {

    private EventService eventService;

    @Override
    public void init() throws ServletException {
        this.eventService = new EventService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            EventCreateRequest eventCreateRequest = new EventCreateRequest();
            eventCreateRequest.setUserId((Integer) session.getAttribute("user_id"));
            eventCreateRequest.setTitle(getPartValue(request.getPart("e_title")));
            eventCreateRequest.setDescription(getPartValue(request.getPart("e_description")));
            eventCreateRequest.setDateStr(getPartValue(request.getPart("e_date")));
            
            List<Integer> selectedGroupIds = new ArrayList<>();
            for (Part part : request.getParts()) {
                if ("group_ids".equals(part.getName())) {
                    String val = getPartValue(part);
                    if (val != null && !val.trim().isEmpty()) {
                        selectedGroupIds.add(Integer.parseInt(val.trim()));
                    }
                }
            }
            eventCreateRequest.setSelectedGroupIds(selectedGroupIds);
            
            Part filePart = request.getPart("event_pic");
            eventCreateRequest.setFilePart(filePart);
            
            String uploadPath = getServletContext().getRealPath("") + File.separator + "media_uploads";
            eventCreateRequest.setUploadPath(uploadPath);

            EventCreateResponse res = eventService.createEvent(eventCreateRequest);

            if (res.isSuccess()) {
                session.setAttribute("successMessage", "Event created successfully!");
                response.sendRedirect(request.getContextPath() + "/events");
            } else {
                session.setAttribute("errorMessage", res.getErrorMessage());
                response.sendRedirect(request.getContextPath() + "/createevent");
            }
        } catch (Exception e) {
            session.setAttribute("errorMessage", "An error occurred while creating the event: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/createevent");
        }
    }

    private String getPartValue(Part part) throws IOException {
        if (part == null) return null;
        java.io.BufferedReader reader = new java.io.BufferedReader(new java.io.InputStreamReader(part.getInputStream(), "UTF-8"));
        StringBuilder value = new StringBuilder();
        char[] buffer = new char[1024];
        int length;
        while ((length = reader.read(buffer)) > 0) {
            value.append(buffer, 0, length);
        }
        return value.toString();
    }
}