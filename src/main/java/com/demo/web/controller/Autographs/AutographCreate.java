package com.demo.web.controller.Autographs;

import com.demo.web.dto.Autographs.AutographCreateRequest;
import com.demo.web.dto.Autographs.AutographCreateResponse;
import com.demo.web.service.AutographService;

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
public class AutographCreate extends HttpServlet {

    private AutographService autographService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.autographService = new AutographService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");

        Part filePart = request.getPart("coverImage");
        String picUrl = null;

        if (filePart != null && filePart.getSize() > 0) {
            String fileName = extractFileName(filePart);
            String uploadPath = getServletContext().getRealPath("") + File.separator + "dbimages";

            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
            try {
                filePart.write(uploadPath + File.separator + uniqueFileName);
                picUrl = uniqueFileName;
            } catch (IOException e) {
                request.setAttribute("error", "Error uploading image.");
                request.getRequestDispatcher("/addautograph").forward(request, response);
                return;
            }
        }

        AutographCreateRequest req = new AutographCreateRequest(
            userId,
            request.getParameter("bookTitle"),
            request.getParameter("description"),
            picUrl
        );

        AutographCreateResponse res = autographService.createAutograph(req);

        if (!res.isSuccess()) {
            request.setAttribute("error", res.getErrorMessage());
            if (res.getRedirectUrl().contains("addautograph")) {
                request.getRequestDispatcher("/addautograph").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + res.getRedirectUrl());
            }
            return;
        }

        response.sendRedirect(request.getContextPath() + res.getRedirectUrl());
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