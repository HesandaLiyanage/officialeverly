package com.demo.web.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;

@WebServlet("/login") // Maps this servlet to /login URL
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
            response.sendRedirect("fragments/dashboard.jsp");
        } else {
            // 5. Invalid login → send back to login page with error
            request.setAttribute("errorMessage", "Invalid username or password");
            RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
            rd.forward(request, response);
        }
    }
}
