package com.demo.web.filter;

import com.demo.web.testsupport.ServletTestSupport;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

class CsrfProtectionFilterTest {

    @Test
    void unsafeAuthenticatedRequestWithValidTokenPasses() throws Exception {
        CsrfProtectionFilter filter = new CsrfProtectionFilter();
        filter.init(null);

        ServletTestSupport.MockSessionState sessionState = ServletTestSupport.newSession("session-1");
        sessionState.proxy().setAttribute("user_id", 99);
        sessionState.proxy().setAttribute("csrf_token", "token-123");

        ServletTestSupport.MockRequestState requestState =
                ServletTestSupport.newRequest("POST", "/app/settings", "/app")
                        .withSession(sessionState)
                        .withParameter("csrfToken", "token-123");
        ServletTestSupport.MockChainState chainState = ServletTestSupport.newChain();

        filter.doFilter(requestState.proxy(), ServletTestSupport.newResponse().proxy(), chainState.proxy());

        assertTrue(chainState.wasInvoked());
        assertEquals("token-123", requestState.getAttribute("csrfToken"));
    }

    @Test
    void crossSiteAuthenticatedRequestWithoutTokenIsRejected() throws Exception {
        CsrfProtectionFilter filter = new CsrfProtectionFilter();
        filter.init(null);

        ServletTestSupport.MockSessionState sessionState = ServletTestSupport.newSession("session-2");
        sessionState.proxy().setAttribute("user_id", 42);
        sessionState.proxy().setAttribute("csrf_token", "expected-token");

        ServletTestSupport.MockRequestState requestState =
                ServletTestSupport.newRequest("POST", "/app/settingsprivacy", "/app")
                        .withSession(sessionState)
                        .withHeader("Sec-Fetch-Site", "cross-site");
        ServletTestSupport.MockResponseState responseState = ServletTestSupport.newResponse();

        filter.doFilter(requestState.proxy(), responseState.proxy(), ServletTestSupport.newChain().proxy());

        assertEquals(403, responseState.getErrorCode());
        assertEquals("CSRF validation failed", responseState.getErrorMessage());
    }
}
