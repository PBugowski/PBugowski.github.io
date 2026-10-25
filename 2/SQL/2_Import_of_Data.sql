-- 2. Importing Transaction Data from CSV
-- -----------------------------------------------------------------------------------------------------------------
-- Imports the three source columns from Raw Data/transactions.csv into the
-- transactions table created by the database script.
-- The import process:
--   - enables local file loading,
--   - reads comma-separated values with optional double quotation marks,
--   - skips the CSV header,
--   - temporarily stores the source values in user variables,
--   - extracts the date from the ISO timestamp,
--   - converts empty customer identifiers and amounts into NULL values.
--
-- The source columns must appear in this order: transaction date, customer
-- identifier and transaction amount. Only the first ten characters of the
-- trimmed timestamp, in YYYY-MM-DD format, are retained for the DATE column.
-- TRANSACTION_ID is generated automatically; the derived attributes remain
-- NULL until the preparation script populates them.
--
-- Run the import once into the newly created, empty table. The subsequent
-- correction relies on the original row order and transaction ID 299.
-- The relative CSV path is resolved by the MySQL client. Its working directory
-- must contain the Raw Data folder, or the path must be adjusted accordingly.
-- Local loading must also be enabled by the client. Changing the global server
-- setting requires the corresponding MySQL privileges.
-- -----------------------------------------------------------------------------------------------------------------

USE KDS_Transactions;


SET GLOBAL local_infile = 1;                                                          -- Enables local file loading on the server.


LOAD DATA LOCAL INFILE 'Raw Data/transactions.csv'                                    -- Reads the CSV from the client computer.
INTO TABLE transactions                                                               -- Specifies the destination table.
FIELDS TERMINATED BY ','                                                              -- Uses commas to separate source columns.
OPTIONALLY ENCLOSED BY '"'                                                            -- Allows field values to be enclosed in double quotation marks.
LINES TERMINATED BY '\n'                                                              -- Uses newline characters to separate source records.
IGNORE 1 ROWS                                                                         -- Skips the column names in the first row.
(@TRANSACTION_DATE, @CLIENT_ID, @TRANSACTION_VALUE)                                   -- Reads each source row into variables before assigning table columns.
SET
    TRANSACTION_DATE = STR_TO_DATE(LEFT(TRIM(@TRANSACTION_DATE), 10), '%Y-%m-%d'),    -- TRIM removes surrounding spaces, LEFT keeps the date, and STR_TO_DATE parses YYYY-MM-DD.
    CLIENT_ID = NULLIF(@CLIENT_ID, ''),                                               -- NULLIF converts an empty string into NULL; the same rule applies to the amount.
    TRANSACTION_VALUE = NULLIF(@TRANSACTION_VALUE, '');
