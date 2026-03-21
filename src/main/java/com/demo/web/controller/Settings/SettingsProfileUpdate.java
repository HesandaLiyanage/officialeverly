package com.demo.web.controller.Settings;

import com.demo.web.dto.Settings.SettingsProfileRequest;
import com.demo.web.dto.Settings.SettingsProfileResponse;
import com.demo.web.service.SettingsService;
import com.demo.web.service.AuthService;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;

@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
public class SettingsProfileUpdate extends HttpServlet {

    private SettingsService settingsService;
    private AuthService authService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.settingsService = new SettingsService();
        this.authService = new AuthService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!authService.isValidSession(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.getRequestDispatcher("/editprofile").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!authService.isValidSession(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer userId = authService.getUserId(request);
        Part filePart = request.getPart("profilePicture");
        String profilePictureUrl = null;
        boolean fileUploaded = false;

        if (filePart != null && filePart.getSize() > 0) {
            fileUploaded = true;
            String fileName = extractFileName(filePart);
            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";

            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
            try {
                filePart.write(uploadPath + File.separator + uniqueFileName);
                profilePictureUrl = uniqueFileName;
            } catch (IOException e) {}
        }

        SettingsProfileRequest req = new SettingsProfileRequest(
            userId,
            request.getParameter("username"),
            request.getParameter("bio"),
            request.getParameter("currentPassword"),
            request.getParameter("newPassword"),
            request.getParameter("confirmPassword"),
            profilePictureUrl,
            fileUploaded
        );

        SettingsProfileResponse res = settingsService.updateProfile(req);

        if (!res.isSuccess()) {
            request.setAttribute("error", res.getErrorMessage());
        } else {
            request.setAttribute("success", res.getSuccessMessage());
            HttpSession session = request.getSession(false);
            if (session != null && res.getUpdatedUser() != null) {
                session.setAttribute("user", res.getUpdatedUser());
                session.setAttribute("username", res.getUpdatedUser().getUsername());
            }
        }

        request.getRequestDispatcher(res.getRedirectUrl()).forward(request, response);
    }

    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        for (String s : contentDisp.split(";")) {
            if (s.trim().startsWith("filename")) {
                return s.substring(s.indexOf("=") + 2, s.length() - 1);
            }
        }
        return "";
    }
}