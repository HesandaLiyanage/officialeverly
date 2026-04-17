package com.demo.web.controller.Memory;

import com.demo.web.dto.Memory.MediaStreamRequest;
import com.demo.web.dto.Memory.MediaStreamResponse;
import com.demo.web.service.MemoryService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.OutputStream;

@WebServlet("/viewMedia")
public class MediaView extends HttpServlet {

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

        // Check if user is logged in
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Not logged in");
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");

        // Get media ID from URL (support both 'id' and 'mediaId' parameters)
        String mediaIdParam = request.getParameter("id");
        if (mediaIdParam == null || mediaIdParam.isEmpty()) {
            mediaIdParam = request.getParameter("mediaId");
        }
        if (mediaIdParam == null || mediaIdParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing id parameter");
            return;
        }

        try {
            int mediaId = Integer.parseInt(mediaIdParam);
            MediaStreamRequest streamRequest = new MediaStreamRequest();
            streamRequest.setUserId(userId);
            streamRequest.setMediaId(mediaId);
            streamRequest.setApplicationPath(request.getServletContext().getRealPath(""));

            MediaStreamResponse streamResponse = memoryService.getMediaStreamData(streamRequest);
            if (!streamResponse.isSuccess()) {
                response.sendError(streamResponse.getStatusCode(), streamResponse.getErrorMessage());
                return;
            }

            serveFile(streamResponse, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid mediaId");
        } catch (Exception e) {
            if (isClientDisconnect(e)) {
                return;
            }
            e.printStackTrace();
            if (!response.isCommitted()) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        "Error serving media: " + e.getMessage());
            }
        }
    }

    private void serveFile(MediaStreamResponse streamResponse, HttpServletResponse response) throws IOException {
        response.setContentType(streamResponse.getMediaItem().getMimeType());
        response.setHeader("Cache-Control", "private, max-age=3600");
        response.setContentLength(streamResponse.getFileData().length);
        try (OutputStream out = response.getOutputStream()) {
            out.write(streamResponse.getFileData());
            out.flush();
        } catch (IOException e) {
            System.out.println("Client disconnected while streaming media "
                    + streamResponse.getMediaItem().getMediaId()
                    + " (" + streamResponse.getMediaItem().getOriginalFilename() + ")");
        }
    }

    /**
     * Check if an exception is caused by the client disconnecting (broken pipe).
     * This is normal for video elements that issue range requests or when users navigate away.
     */
    private boolean isClientDisconnect(Throwable e) {
        Throwable cause = e;
        while (cause != null) {
            String name = cause.getClass().getName();
            if (name.contains("ClientAbortException")) {
                return true;
            }
            if (cause instanceof IOException && "Broken pipe".equals(cause.getMessage())) {
                return true;
            }
            cause = cause.getCause();
        }
        return false;
    }
}
