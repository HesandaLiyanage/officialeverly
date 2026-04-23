package com.demo.web.util;

import com.demo.web.model.Auth.user;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

class AdminAccessUtilTest {

    @Test
    void fallbackAdminUsernameStillWorksWhenNoExplicitConfigExists() {
        user adminUser = new user();
        adminUser.setUsername("admin");
        adminUser.setEmail("admin@example.com");

        user regularUser = new user();
        regularUser.setUsername("member");
        regularUser.setEmail("member@example.com");

        assertTrue(AdminAccessUtil.isAdminUser(adminUser));
        assertFalse(AdminAccessUtil.isAdminUser(regularUser));
    }
}
