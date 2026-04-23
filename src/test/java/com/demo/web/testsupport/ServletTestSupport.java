package com.demo.web.testsupport;

import javax.servlet.FilterChain;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.lang.reflect.Proxy;
import java.util.HashMap;
import java.util.Map;

public final class ServletTestSupport {

    private ServletTestSupport() {
    }

    public static MockSessionState newSession(String id) {
        return new MockSessionState(id);
    }

    public static MockRequestState newRequest(String method, String requestUri, String contextPath) {
        return new MockRequestState(method, requestUri, contextPath);
    }

    public static MockResponseState newResponse() {
        return new MockResponseState();
    }

    public static MockChainState newChain() {
        return new MockChainState();
    }

    public static final class MockSessionState {
        private final String id;
        private final Map<String, Object> attributes = new HashMap<>();
        private boolean invalidated;

        private MockSessionState(String id) {
            this.id = id;
        }

        public HttpSession proxy() {
            return (HttpSession) Proxy.newProxyInstance(
                    HttpSession.class.getClassLoader(),
                    new Class[]{HttpSession.class},
                    (proxy, method, args) -> switch (method.getName()) {
                        case "getId" -> id;
                        case "getAttribute" -> attributes.get((String) args[0]);
                        case "setAttribute" -> {
                            attributes.put((String) args[0], args[1]);
                            yield null;
                        }
                        case "removeAttribute" -> {
                            attributes.remove((String) args[0]);
                            yield null;
                        }
                        case "invalidate" -> {
                            invalidated = true;
                            yield null;
                        }
                        case "isNew" -> false;
                        case "getCreationTime", "getLastAccessedTime" -> 0L;
                        case "getMaxInactiveInterval" -> 0;
                        case "setMaxInactiveInterval" -> null;
                        case "getAttributeNames", "getValueNames", "getSessionContext" -> null;
                        case "putValue", "removeValue" -> null;
                        case "getServletContext" -> null;
                        default -> defaultValue(method.getReturnType());
                    }
            );
        }

        public boolean isInvalidated() {
            return invalidated;
        }
    }

    public static final class MockRequestState {
        private final String method;
        private final String requestUri;
        private final String contextPath;
        private String queryString;
        private String scheme = "https";
        private String serverName = "example.com";
        private int serverPort = 443;
        private String remoteAddr = "127.0.0.1";
        private Cookie[] cookies;
        private MockSessionState sessionState;
        private final Map<String, Object> attributes = new HashMap<>();
        private final Map<String, String> parameters = new HashMap<>();
        private final Map<String, String> headers = new HashMap<>();
        private String forwardedPath;

        private MockRequestState(String method, String requestUri, String contextPath) {
            this.method = method;
            this.requestUri = requestUri;
            this.contextPath = contextPath;
        }

        public MockRequestState withSession(MockSessionState sessionState) {
            this.sessionState = sessionState;
            return this;
        }

        public MockRequestState withHeader(String name, String value) {
            headers.put(name, value);
            return this;
        }

        public MockRequestState withParameter(String name, String value) {
            parameters.put(name, value);
            return this;
        }

        public MockRequestState withQueryString(String value) {
            this.queryString = value;
            return this;
        }

        public MockRequestState withCookies(Cookie... value) {
            this.cookies = value;
            return this;
        }

        public MockRequestState withScheme(String value) {
            this.scheme = value;
            return this;
        }

        public MockRequestState withServer(String name, int port) {
            this.serverName = name;
            this.serverPort = port;
            return this;
        }

        public HttpServletRequest proxy() {
            return (HttpServletRequest) Proxy.newProxyInstance(
                    HttpServletRequest.class.getClassLoader(),
                    new Class[]{HttpServletRequest.class},
                    (proxy, methodRef, args) -> {
                        String name = methodRef.getName();
                        return switch (name) {
                            case "getMethod" -> method;
                            case "getRequestURI" -> requestUri;
                            case "getContextPath" -> contextPath;
                            case "getQueryString" -> queryString;
                            case "getScheme" -> scheme;
                            case "getServerName" -> serverName;
                            case "getServerPort" -> serverPort;
                            case "getRemoteAddr" -> remoteAddr;
                            case "isSecure" -> "https".equalsIgnoreCase(scheme);
                            case "getParameter" -> parameters.get((String) args[0]);
                            case "getHeader" -> headers.get((String) args[0]);
                            case "getCookies" -> cookies;
                            case "getAttribute" -> attributes.get((String) args[0]);
                            case "setAttribute" -> {
                                attributes.put((String) args[0], args[1]);
                                yield null;
                            }
                            case "getSession" -> {
                                boolean create = args == null || args.length == 0 || Boolean.TRUE.equals(args[0]);
                                if (sessionState == null && create) {
                                    sessionState = new MockSessionState("generated-session");
                                }
                                yield sessionState == null ? null : sessionState.proxy();
                            }
                            case "getRequestDispatcher" -> dispatcher((String) args[0]);
                            default -> defaultValue(methodRef.getReturnType());
                        };
                    }
            );
        }

        public String getForwardedPath() {
            return forwardedPath;
        }

        public Object getAttribute(String name) {
            return attributes.get(name);
        }

        private RequestDispatcher dispatcher(String path) {
            return (RequestDispatcher) Proxy.newProxyInstance(
                    RequestDispatcher.class.getClassLoader(),
                    new Class[]{RequestDispatcher.class},
                    (proxy, method, args) -> {
                        if ("forward".equals(method.getName())) {
                            forwardedPath = path;
                            return null;
                        }
                        if ("include".equals(method.getName())) {
                            return null;
                        }
                        return defaultValue(method.getReturnType());
                    }
            );
        }
    }

    public static final class MockResponseState {
        private String redirectLocation;
        private int errorCode;
        private String errorMessage;
        private int statusCode = 200;
        private final Map<String, String> headers = new HashMap<>();

        public HttpServletResponse proxy() {
            return (HttpServletResponse) Proxy.newProxyInstance(
                    HttpServletResponse.class.getClassLoader(),
                    new Class[]{HttpServletResponse.class},
                    (proxy, method, args) -> switch (method.getName()) {
                        case "sendRedirect" -> {
                            redirectLocation = (String) args[0];
                            yield null;
                        }
                        case "sendError" -> {
                            errorCode = (Integer) args[0];
                            errorMessage = args.length > 1 ? (String) args[1] : null;
                            yield null;
                        }
                        case "setStatus" -> {
                            statusCode = (Integer) args[0];
                            yield null;
                        }
                        case "setHeader", "addHeader" -> {
                            headers.put((String) args[0], (String) args[1]);
                            yield null;
                        }
                        case "getStatus" -> statusCode;
                        default -> defaultValue(method.getReturnType());
                    }
            );
        }

        public String getRedirectLocation() {
            return redirectLocation;
        }

        public int getErrorCode() {
            return errorCode;
        }

        public String getErrorMessage() {
            return errorMessage;
        }

        public Map<String, String> getHeaders() {
            return headers;
        }
    }

    public static final class MockChainState {
        private boolean invoked;

        public FilterChain proxy() {
            return (FilterChain) Proxy.newProxyInstance(
                    FilterChain.class.getClassLoader(),
                    new Class[]{FilterChain.class},
                    (proxy, method, args) -> {
                        if ("doFilter".equals(method.getName())) {
                            invoked = true;
                            return null;
                        }
                        return defaultValue(method.getReturnType());
                    }
            );
        }

        public boolean wasInvoked() {
            return invoked;
        }
    }

    private static Object defaultValue(Class<?> returnType) throws IOException, ServletException {
        if (returnType == Void.TYPE) {
            return null;
        }
        if (returnType == Boolean.TYPE) {
            return false;
        }
        if (returnType == Integer.TYPE) {
            return 0;
        }
        if (returnType == Long.TYPE) {
            return 0L;
        }
        if (returnType == Double.TYPE) {
            return 0d;
        }
        if (returnType == Float.TYPE) {
            return 0f;
        }
        return null;
    }
}
