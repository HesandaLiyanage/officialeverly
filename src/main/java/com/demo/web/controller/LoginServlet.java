package com.demo.web.controller;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Get form data
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // 2. Validate credentials (Replace with DB check in real app)
        if ("admin".equals(username) && "1234".equals(password)) {
            // 3. Create session and store user info
            HttpSession session = request.getSession();
            session.setAttribute("username", username);

            // 4. Redirect to dashboard (or protected page)
            response.sendRedirect(request.getContextPath() + "/view?page=memories");
        } else {
            // 5. Invalid login → send back to login page with error
            request.setAttribute("errorMessage", "Invalid username or password");
            RequestDispatcher rd = request.getRequestDispatcher("/view?page=login");
            rd.forward(request, response);
        }
    }
}
