package com.demo.web.middleware;

import org.junit.jupiter.api.Test;

import java.lang.reflect.Field;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

class FrontControllerServletTest {

    @Test
    @SuppressWarnings("unchecked")
    void routeMapsPreferControllerForGroupsAndExposeCoreRoutes() throws Exception {
        FrontControllerServlet servlet = new FrontControllerServlet();
        servlet.init();

        Field jspField = FrontControllerServlet.class.getDeclaredField("routeToJsp");
        jspField.setAccessible(true);
        Map<String, String> routeToJsp = (Map<String, String>) jspField.get(servlet);

        Field controllerField = FrontControllerServlet.class.getDeclaredField("routeToController");
        controllerField.setAccessible(true);
        Map<String, String> routeToController = (Map<String, String>) controllerField.get(servlet);

        assertFalse(routeToJsp.containsKey("/groups"));
        assertEquals("/groupsview", routeToController.get("/groups"));
        assertTrue(routeToController.containsKey("/feed"));
        assertTrue(routeToJsp.containsKey("/creategroup"));
    }
}
