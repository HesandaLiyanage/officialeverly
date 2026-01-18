// File: com/demo/web/controller/UpdateAutographServlet.java (FIXED - Added @MultipartConfig)
package com.demo.web.controller.autographs;

import com.demo.web.dao.autographDAO;
import com.demo.web.model.autograph;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.util.logging.Logger;

// CRITICAL: This annotation is REQUIRED for multipart/form-data forms
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class UpdateAutographServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(UpdateAutographServlet.class.getName());
    private autographDAO autographDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.autographDAO = new autographDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("[DEBUG UpdateAutographServlet] Received POST request");

        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            System.out.println("[DEBUG UpdateAutographServlet] User not logged in.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get user ID from session
        Integer userId = (Integer) session.getAttribute("user_id");
        System.out.println("[DEBUG UpdateAutographServlet] User ID from session: " + userId);

        try {
            // Get the autograph ID to update from the hidden form field
            String autographIdStr = request.getParameter("autographId");
            System.out.println("[DEBUG UpdateAutographServlet] Raw autographId parameter: '" + autographIdStr + "'");

            if (autographIdStr == null || autographIdStr.trim().isEmpty()) {
                System.out.println("[DEBUG UpdateAutographServlet] Missing or empty autographId parameter.");
                response.sendRedirect(request.getContextPath() + "/autographs");
                return;
            }

            int autographId = Integer.parseInt(autographIdStr.trim());
            System.out.println("[DEBUG UpdateAutographServlet] Parsed autographId: " + autographId);

            // Get updated title and description from the form
            String newTitle = request.getParameter("bookTitle");
            String newDescription = request.getParameter("description");
            System.out.println("[DEBUG UpdateAutographServlet] Received new Title: '" + newTitle + "'");
            System.out.println("[DEBUG UpdateAutographServlet] Received new Description: '" + newDescription + "'");

            // Verify the autograph belongs to the current user for security
            autograph existingAutograph = autographDAO.findById(autographId);
            if (existingAutograph == null) {
                System.out.println(
                        "[DEBUG UpdateAutographServlet] Autograph ID " + autographId + " does not exist in DB.");
                response.sendRedirect(request.getContextPath() + "/autographs");
                return;
            }
            if (existingAutograph.getUserId() != userId) {
                System.out.println("[DEBUG UpdateAutographServlet] User " + userId + " attempted to update autograph "
                        + autographId + " which does not belong to them.");
                response.sendRedirect(request.getContextPath() + "/autographs");
                return;
            }
            System.out.println("[DEBUG UpdateAutographServlet] Autograph ID " + autographId + " belongs to user ID "
                    + userId + ". Existing autograph: " + existingAutograph);

            // Get the existing picture URL as a fallback
            String existingPicUrl = existingAutograph.getAutographPicUrl();
            System.out.println("[DEBUG UpdateAutographServlet] Existing Pic URL from DB: '" + existingPicUrl + "'");

            // Get the uploaded file part (cover image)
            Part filePart = request.getPart("coverImage");
            String newPicUrl = existingPicUrl; // Default to the existing URL

            if (filePart != null && filePart.getSize() > 0) {
                System.out.println("[DEBUG UpdateAutographServlet] New file uploaded. Size: " + filePart.getSize());

                // Extract filename using helper method
                String fileName = extractFileName(filePart);
                String uploadPath = getServletContext().getRealPath("") + File.separator + "dbimages";

                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                // Generate a unique filename to avoid conflicts
                String uniqueFileName = "autograph_" + autographId + "_" + System.currentTimeMillis() + "_" + fileName;
                String filePath = uploadPath + File.separator + uniqueFileName;

                try {
                    filePart.write(filePath);
                    newPicUrl = uniqueFileName; // Store only the filename for the database
                    System.out.println("[DEBUG UpdateAutographServlet] New Pic URL set to: '" + newPicUrl + "'");
                } catch (IOException e) {
                    System.out.println("[DEBUG UpdateAutographServlet] Error writing file: " + e.getMessage());
                    e.printStackTrace();
                }
            } else {
                System.out.println("[DEBUG UpdateAutographServlet] No new file uploaded, keeping existing Pic URL: '"
                        + newPicUrl + "'");
            }

            // Create an autograph object with the updated data
            autograph updatedAutograph = new autograph();
            updatedAutograph.setAutographId(autographId);
            updatedAutograph.setTitle(newTitle);
            updatedAutograph.setDescription(newDescription);
            updatedAutograph.setAutographPicUrl(newPicUrl);
            updatedAutograph.setUserId(userId);

            System.out.println(
                    "[DEBUG UpdateAutographServlet] Prepared autograph object for update: " + updatedAutograph);

            // Attempt to update the autograph
            boolean success = autographDAO.updateAutograph(updatedAutograph);
            System.out.println("[DEBUG UpdateAutographServlet] DAO updateAutograph returned: " + success);

            if (success) {
                System.out.println("[DEBUG UpdateAutographServlet] Successfully updated autograph ID: " + autographId
                        + " by user ID: " + userId);
                // Redirect to the view page for the updated autograph on success
                response.sendRedirect(request.getContextPath() + "/autographview?id=" + autographId);
            } else {
                System.out.println("[DEBUG UpdateAutographServlet] Failed to update autograph ID: " + autographId
                        + " by user ID: " + userId);
                response.sendRedirect(request.getContextPath() + "/autographs?error=update_failed");
            }

        } catch (NumberFormatException e) {
            System.out.println("[DEBUG UpdateAutographServlet] Invalid autograph ID format: '"
                    + request.getParameter("autographId") + "'");
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/autographs");
        } catch (Exception e) {
            System.out.println(
                    "[DEBUG UpdateAutographServlet] Unexpected error while updating autograph: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/autographs?error=unexpected_error");
        }
    }

    // Helper method to extract filename from Part
    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        for (String s : items) {
            if (s.trim().startsWith("filename")) {
                return s.substring(s.indexOf("=") + 2, s.length() - 1);
            }
        }
        return "";
    }
}