import com.demo.web.dao.autographDAO;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import javax.servlet.annotation.WebServlet;
import com.demo.web.dao.autographDAO;
import com.demo.web.model.autograph;

@WebServlet("/submit-autograph")
public class SubmitAutographEntryServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String token = request.getParameter("token");
        String content = request.getParameter("content");
        String author = request.getParameter("author");
        String decorations = request.getParameter("decorations");

        autographDAO dao = new autographDAO();

        try {
            autograph ag = dao.getAutographByShareToken(token);
            if (ag == null) {
                response.sendError(404);
                return;
            }

            // Save entry (you may already have an autograph_entry table)
            // Use ag.getAutographId() internally ONLY

            response.sendRedirect(
                    request.getContextPath() + "/thank-you"
            );

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
