package com.demo.web.controller.Events;

import com.demo.web.service.EventService;
import com.demo.web.dto.Events.EventUpdateRequest;
import com.demo.web.dto.Events.EventUpdateResponse;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
public class EventUpdate extends HttpServlet {

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

    // 1. Grab the event ID early so it is safely available for the catch block
    String eventIdRedirect = request.getParameter("event_id");

    try {
      EventUpdateRequest updateRequest = new EventUpdateRequest();

      // 2. Session Data
      updateRequest.setUserId((Integer) session.getAttribute("user_id"));

      // 3. Normal Text Fields (Clean and easy)
      updateRequest.setEventIdStr(eventIdRedirect);
      updateRequest.setTitle(request.getParameter("e_title"));
      updateRequest.setDescription(request.getParameter("e_description"));
      updateRequest.setDateStr(request.getParameter("e_date"));

      // 4. Handling Array values for checkboxes/multi-select
      List<Integer> selectedGroupIds = new ArrayList<>();
      String[] groupIdsStr = request.getParameterValues("group_ids");

      if (groupIdsStr != null) {
        for (String val : groupIdsStr) {
          if (!val.trim().isEmpty()) {
            selectedGroupIds.add(Integer.parseInt(val.trim()));
          }
        }
      }
      updateRequest.setSelectedGroupIds(selectedGroupIds);

      // 5. Handling ONLY the actual File
      Part filePart = request.getPart("event_pic");
      updateRequest.setFilePart(filePart);

      String uploadPath = getServletContext().getRealPath("") + File.separator + "media_uploads";
      updateRequest.setUploadPath(uploadPath);
      updateRequest.setRealPathBase(getServletContext().getRealPath(""));

      // 6. Service call
      EventUpdateResponse res = eventService.updateEvent(updateRequest);

      if (res.isSuccess()) {
        session.setAttribute("successMessage", "Event updated successfully!");
        response.sendRedirect(request.getContextPath() + "/events");
      } else {
        session.setAttribute("errorMessage", res.getErrorMessage());
        response.sendRedirect(request.getContextPath() + "/editevent?event_id=" + eventIdRedirect);
      }
    } catch (Exception e) {
      session.setAttribute("errorMessage", "An error occurred while updating the event: " + e.getMessage());
      response.sendRedirect(request.getContextPath() + "/editevent?event_id=" + eventIdRedirect);
    }
  }
}
