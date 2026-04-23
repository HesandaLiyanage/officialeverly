package com.demo.web.util;

import org.junit.jupiter.api.Test;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.Base64;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

class PasswordUtilTest {

    @Test
    void hashesAndVerifiesNewPasswords() {
        String salt = PasswordUtil.generateSalt();
        String hash = PasswordUtil.hashPassword("Str0ng!Pass", salt);

        assertTrue(PasswordUtil.verifyPassword("Str0ng!Pass", salt, hash));
        assertFalse(PasswordUtil.verifyPassword("WrongPass1!", salt, hash));
        assertFalse(PasswordUtil.needsRehash(hash));
    }

    @Test
    void verifiesLegacySha256PasswordsAndMarksThemForRehash() throws Exception {
        String salt = PasswordUtil.generateSalt();
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        String legacyHash = Base64.getEncoder().encodeToString(
                md.digest(("Str0ng!Pass" + salt).getBytes(StandardCharsets.UTF_8))
        );

        assertTrue(PasswordUtil.verifyPassword("Str0ng!Pass", salt, legacyHash));
        assertTrue(PasswordUtil.needsRehash(legacyHash));
    }
}
