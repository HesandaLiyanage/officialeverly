-- Migration: Alter journal j_content column from VARCHAR to TEXT
-- The j_content column stores JSON with htmlContent, decorations, and backgroundTheme
-- which can easily exceed VARCHAR(100) limits, especially with emoji decorations.

ALTER TABLE journal ALTER COLUMN j_content TYPE TEXT;
