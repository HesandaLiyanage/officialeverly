import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import javax.servlet.annotation.WebServlet;
import com.demo.web.dao.autographDAO;
import com.demo.web.model.autograph;

@WebServlet("/write-autograph")
public class WriteAutographServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String token = request.getParameter("token");

        if (token == null || token.isEmpty()) {
            response.sendError(404);
            return;
        }

        autographDAO dao = new autographDAO();
        try {
            autograph ag = dao.getAutographByShareToken(token);

            if (ag == null) {
                response.sendError(404);
                return;
            }

            request.setAttribute("autograph", ag);
            request.setAttribute("shareToken", token);

            request.getRequestDispatcher(
                    "/WEB-INF/views/autograph/writeautograph.jsp"
            ).forward(request, response);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
