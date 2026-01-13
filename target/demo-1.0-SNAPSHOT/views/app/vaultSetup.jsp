<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <title>Set up your Vault</title>
        <link rel="stylesheet" type="text/css" href="resources/css/vault.css">
    </head>

    <body>
        <jsp:include page="../public/header2.jsp" />
        <div class="vault-container">
            <div class="vault-box">
                <div class="vault-icon">
                    🔒
                </div>
                <h1>Set up your Vault</h1>
                <p>Your Vault is a secure system where your data will be stored. Choose a strong password.</p>

                <% String errorMessage=(String) request.getAttribute("errorMessage"); %>
                    <% if (errorMessage !=null) { %>
                        <div class="error"
                            style="color: #ef4444; background: #fef2f2; padding: 10px; border-radius: 8px; margin-bottom: 15px;">
                            <%= errorMessage %>
                        </div>
                        <% } %>

                            <form action="${pageContext.request.contextPath}/vaultSetup" method="post">
                                <div class="form-group">
                                    <label for="password">Password</label>
                                    <input type="password" id="password" name="password"
                                        placeholder="Enter a strong password" required>
                                </div>

                                <div class="form-group">
                                    <label for="confirm-password">Confirm Password</label>
                                    <input type="password" id="confirm-password" name="confirm-password"
                                        placeholder="Re-enter your password" required>
                                </div>

                                <button type="submit" class="btn-save">Save</button>
                            </form>
            </div>
        </div>
        <jsp:include page="../public/footer.jsp" />
    </body>

    </html>