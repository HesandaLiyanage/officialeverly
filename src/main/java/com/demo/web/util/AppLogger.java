package com.demo.web.util;

import java.util.logging.Level;
import java.util.logging.Logger;

public final class AppLogger {

    private AppLogger() {
    }

    public static Logger getLogger(Class<?> type) {
        return Logger.getLogger(type.getName());
    }

    public static void warn(Logger logger, String message, Exception exception) {
        logger.log(Level.WARNING, message, exception);
    }

    public static void error(Logger logger, String message, Exception exception) {
        logger.log(Level.SEVERE, message, exception);
    }
}
