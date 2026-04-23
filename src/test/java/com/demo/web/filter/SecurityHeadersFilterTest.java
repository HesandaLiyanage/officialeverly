package com.demo.web.filter;

import com.demo.web.testsupport.ServletTestSupport;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

class SecurityHeadersFilterTest {

    @Test
    void setsBaselineSecurityHeaders() throws Exception {
        SecurityHeadersFilter filter = new SecurityHeadersFilter();

        ServletTestSupport.MockRequestState requestState =
                ServletTestSupport.newRequest("GET", "/app/login", "/app").withScheme("https");
        ServletTestSupport.MockResponseState responseState = ServletTestSupport.newResponse();
        ServletTestSupport.MockChainState chainState = ServletTestSupport.newChain();

        filter.doFilter(requestState.proxy(), responseState.proxy(), chainState.proxy());

        assertTrue(chainState.wasInvoked());
        assertEquals("nosniff", responseState.getHeaders().get("X-Content-Type-Options"));
        assertEquals("SAMEORIGIN", responseState.getHeaders().get("X-Frame-Options"));
        assertEquals("strict-origin-when-cross-origin", responseState.getHeaders().get("Referrer-Policy"));
        assertEquals("camera=(), microphone=(), geolocation=()", responseState.getHeaders().get("Permissions-Policy"));
        assertEquals("max-age=31536000; includeSubDomains", responseState.getHeaders().get("Strict-Transport-Security"));
    }
}
