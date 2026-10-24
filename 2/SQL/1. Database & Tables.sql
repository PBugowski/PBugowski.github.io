-- 1. Creation of Database and Tables
-- -----------------------------------------------------------------------------------------------------------------
-- Creates the MySQL 8.0+ structures for the supplied transaction snapshot.
-- Raw strings are retained separately from typed and enriched reporting data.
-- Money uses DECIMAL; the original timestamp keeps microseconds for stable ordering.
-- TRANSACTION_ID is the CSV row number assigned during import, not a source-system ID.
-- Re-running this file preserves existing data. It is not a schema migration script.
-- -----------------------------------------------------------------------------------------------------------------

CREATE DATABASE IF NOT EXISTS KDS_Transactions
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE KDS_Transactions;

CREATE TABLE IF NOT EXISTS transactions_raw (
    SOURCE_ROW_ID INT UNSIGNED NOT NULL AUTO_INCREMENT,
    TRANSACTION_TIMESTAMP_TEXT VARCHAR(128),
    CLIENT_ID_TEXT VARCHAR(128),
    TRANSACTION_VALUE_TEXT VARCHAR(128),
    PRIMARY KEY (SOURCE_ROW_ID)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS transactions (
    TRANSACTION_ID INT UNSIGNED NOT NULL,
    TRANSACTION_TIMESTAMP DATETIME(6) NOT NULL,
    TRANSACTION_DATE DATE NOT NULL,
    CLIENT_ID INT UNSIGNED NOT NULL,
    ORIGINAL_TRANSACTION_VALUE DECIMAL(12,2) NOT NULL,
    TRANSACTION_VALUE DECIMAL(12,2) NOT NULL,
    CORRECTION_APPLIED TINYINT UNSIGNED NOT NULL DEFAULT 0,
    TRANSACTION_TYPE VARCHAR(20),
    EXPECTED_RENEWAL_DATE DATE,
    PROMOTION_PRICE VARCHAR(3) NOT NULL,
    TRANSACTION_YEAR SMALLINT UNSIGNED NOT NULL,
    TRANSACTION_MONTH_NUMBER TINYINT UNSIGNED NOT NULL,
    PRIMARY KEY (TRANSACTION_ID),
    INDEX IX_CLIENT_TIMESTAMP (CLIENT_ID, TRANSACTION_TIMESTAMP, TRANSACTION_ID),
    INDEX IX_TRANSACTION_DATE (TRANSACTION_DATE),
    INDEX IX_TRANSACTION_TYPE (TRANSACTION_TYPE)
) ENGINE = InnoDB;
