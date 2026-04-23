package com.demo.web.filter;

import com.demo.web.testsupport.ServletTestSupport;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

class AuthenticationFilterTest {

    @Test
    void publicPathSkipsAuthentication() throws Exception {
        AuthenticationFilter filter = new AuthenticationFilter();
        filter.init(null);

        ServletTestSupport.MockRequestState requestState =
                ServletTestSupport.newRequest("GET", "/app/login", "/app");
        ServletTestSupport.MockResponseState responseState = ServletTestSupport.newResponse();
        ServletTestSupport.MockChainState chainState = ServletTestSupport.newChain();

        filter.doFilter(requestState.proxy(), responseState.proxy(), chainState.proxy());

        assertTrue(chainState.wasInvoked());
    }

    @Test
    void protectedPathRedirectsToLoginWithReturnUrl() throws Exception {
        AuthenticationFilter filter = new AuthenticationFilter();
        filter.init(null);

        ServletTestSupport.MockRequestState requestState =
                ServletTestSupport.newRequest("GET", "/app/memories", "/app")
                        .withQueryString("page=2");
        ServletTestSupport.MockResponseState responseState = ServletTestSupport.newResponse();

        filter.doFilter(requestState.proxy(), responseState.proxy(), ServletTestSupport.newChain().proxy());

        assertEquals("/app/login?return=%2Fmemories%3Fpage%3D2", responseState.getRedirectLocation());
    }
}
