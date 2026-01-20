package com.demo.web.controller.Autographs;

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

@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class AddAutographServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(AddAutographServlet.class.getName());
    private autographDAO autographDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.autographDAO = new autographDAO(); // Initialize the DAO
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is logged in (you might want to centralize this check too)
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            // Should ideally not happen if AuthenticationFilter works correctly, but good
            // to check
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get user ID from the request session
        Integer userId = (Integer) session.getAttribute("user_id");

        // Get form data
        String title = request.getParameter("bookTitle");
        String description = request.getParameter("description");

        // Validate required fields
        if (title == null || title.trim().isEmpty()) {
            // Set error message and forward back to the form
            request.setAttribute("error", "Book Title is required.");
            request.getRequestDispatcher("/addautograph").forward(request, response);
            return;
        }

        // Handle cover image upload
        Part filePart = request.getPart("coverImage");
        String picUrl = null; // Will store the filename

        if (filePart != null && filePart.getSize() > 0) {
            String fileName = extractFileName(filePart);
            String uploadPath = getServletContext().getRealPath("") + File.separator + "dbimages";

            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs(); // Create directory if it doesn't exist
            }

            // Generate a unique filename to avoid conflicts
            String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
            String filePath = uploadPath + File.separator + uniqueFileName;

            try {
                filePart.write(filePath);
                picUrl = uniqueFileName; // Store only the filename for the database
            } catch (IOException e) {
                logger.severe("Error writing file: " + e.getMessage());
                request.setAttribute("error", "Error uploading image: " + e.getMessage());
                request.getRequestDispatcher("/addautograph").forward(request, response);
                return;
            }
        }

        // Create a new autograph object
        autograph newAutograph = new autograph();
        newAutograph.setTitle(title);
        newAutograph.setDescription(description);
        newAutograph.setUserId(userId); // Set the user who created it
        newAutograph.setAutographPicUrl(picUrl); // Set the picture URL

        // Save the autograph to the database
        try {
            boolean success = autographDAO.createAutograph(newAutograph);

            if (success) {
                // Redirect to the autographs list page on success
                response.sendRedirect(request.getContextPath() + "/autographs");
            } else {
                // Set error message and forward back to the form
                request.setAttribute("error", "Failed to create autograph book.");
                request.getRequestDispatcher("/addautograph").forward(request, response);
            }

        } catch (Exception e) {
            logger.severe("Database error while creating autograph: " + e.getMessage());
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/addautograph").forward(request, response);
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