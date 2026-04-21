package com.demo.web.controller.Events;

import com.demo.web.service.EventService;
import com.demo.web.dto.Events.EventCreateRequest;
import com.demo.web.dto.Events.EventCreateResponse;
import com.demo.web.util.ControllerSessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
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

    Integer userId = ControllerSessionUtil.requireUserId(request, response);
    if (userId == null) {
      return;
    }

    HttpSession session = request.getSession(false);

    try {
      EventCreateRequest eventCreateRequest = new EventCreateRequest();

      // 1. Session Data
      eventCreateRequest.setUserId(userId);

      // 2. Normal Text Fields (Replaced getPartValue with getParameter)
      eventCreateRequest.setTitle(request.getParameter("e_title"));
      eventCreateRequest.setDescription(request.getParameter("e_description"));
      eventCreateRequest.setDateStr(request.getParameter("e_date"));
      //eventCreateRequest.setTimeStr(request.getParameter("e_time"));


      // 3. Handling Arrays/Multiple values (Replaced the manual Part loop)
      List<Integer> selectedGroupIds = new ArrayList<>();
      String[] groupIdsStr = request.getParameterValues("group_ids");
//      [" 1","   23  ",4,5,56,6]
      if (groupIdsStr != null) {
        for (String val : groupIdsStr) {
          if (!val.trim().isEmpty()) {
            selectedGroupIds.add(Integer.parseInt(val.trim()));
          }
        }
      }
      eventCreateRequest.setSelectedGroupIds(selectedGroupIds);

      // 4. Handling the actual File Part
      Part filePart = request.getPart("event_pic");
      eventCreateRequest.setFilePart(filePart);

      String uploadPath = getServletContext().getRealPath("") + File.separator + "media_uploads";
      eventCreateRequest.setUploadPath(uploadPath);

      // 5. Service Call using your Result Pattern (.isSuccess)
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

  // Notice: getPartValue() has been completely deleted!
}
