package com.demo.web.util;

import com.demo.web.model.Auth.user;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.InputStream;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashSet;
import java.util.Properties;
import java.util.Set;
import java.util.stream.Collectors;

public final class AdminAccessUtil {

    private static final Set<String> ADMIN_USERNAMES = loadConfiguredSet(
            "EVERLY_ADMIN_USERNAMES",
            "everly.admin.usernames",
            "security.admin.usernames"
    );
    private static final Set<String> ADMIN_EMAILS = loadConfiguredSet(
            "EVERLY_ADMIN_EMAILS",
            "everly.admin.emails",
            "security.admin.emails"
    );

    private AdminAccessUtil() {
    }

    public static boolean requireAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }

        Object sessionFlag = session.getAttribute("is_admin");
        boolean isAdmin = sessionFlag instanceof Boolean && (Boolean) sessionFlag;
        if (!isAdmin) {
            String username = String.valueOf(session.getAttribute("username"));
            String email = String.valueOf(session.getAttribute("email"));
            isAdmin = isConfiguredAdmin(username, email);
            session.setAttribute("is_admin", isAdmin);
        }

        if (!isAdmin) {
            response.sendRedirect(request.getContextPath() + "/youcantaccessthis");
            return false;
        }

        return true;
    }

    public static boolean isAdminUser(user user) {
        if (user == null) {
            return false;
        }
        return isConfiguredAdmin(user.getUsername(), user.getEmail());
    }

    private static boolean isConfiguredAdmin(String username, String email) {
        String normalizedUsername = normalize(username);
        String normalizedEmail = normalize(email);

        if (!ADMIN_USERNAMES.isEmpty() && ADMIN_USERNAMES.contains(normalizedUsername)) {
            return true;
        }

        if (!ADMIN_EMAILS.isEmpty() && ADMIN_EMAILS.contains(normalizedEmail)) {
            return true;
        }

        return ADMIN_USERNAMES.isEmpty() && ADMIN_EMAILS.isEmpty() && "admin".equals(normalizedUsername);
    }

    private static Set<String> loadConfiguredSet(String envKey, String systemKey, String propertiesKey) {
        String configured = System.getenv(envKey);
        if (configured == null || configured.isBlank()) {
            configured = System.getProperty(systemKey);
        }
        if (configured == null || configured.isBlank()) {
            configured = loadFromApplicationProperties(propertiesKey);
        }
        if (configured == null || configured.isBlank()) {
            return Collections.emptySet();
        }

        return Arrays.stream(configured.split(","))
                .map(AdminAccessUtil::normalize)
                .filter(value -> !value.isEmpty())
                .collect(Collectors.toCollection(HashSet::new));
    }

    private static String loadFromApplicationProperties(String key) {
        try (InputStream input = AdminAccessUtil.class.getClassLoader()
                .getResourceAsStream("config/application.properties")) {
            if (input == null) {
                return null;
            }
            Properties properties = new Properties();
            properties.load(input);
            return properties.getProperty(key);
        } catch (IOException ignored) {
            return null;
        }
    }

    private static String normalize(String value) {
        return value == null ? "" : value.trim().toLowerCase();
    }
}
