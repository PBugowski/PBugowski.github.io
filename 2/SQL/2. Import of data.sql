-- 2. Import of Raw CSV Data
-- -----------------------------------------------------------------------------------------------------------------
-- Source: Raw Data/transactions.csv, UTF-8, comma separator, one header row.
-- Source columns: Data transakcji, Klient, Kwota.
-- The timestamp is ISO 8601 with microseconds; it is NOT MM/DD/YYYY.
-- Imports text first. Conversion and validation belong to step 3.1.
--
-- Run the mysql client from the repository root with --local-infile=1.
-- The server must also permit local_infile. This script does not change global settings.
-- If using a GUI, replace the path below with the absolute path to this project's CSV.
-- This is a snapshot reload: TRUNCATE clears ONLY the raw staging table and resets row IDs.
-- The existing reporting table remains unchanged until step 3.1 succeeds.
-- Inspect warnings immediately after LOAD DATA; do not continue after import warnings.
-- -----------------------------------------------------------------------------------------------------------------

USE KDS_Transactions;

TRUNCATE TABLE transactions_raw;

LOAD DATA LOCAL INFILE 'Raw Data/transactions.csv'
INTO TABLE transactions_raw
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@TRANSACTION_TIMESTAMP, @CLIENT_ID, @TRANSACTION_VALUE)
SET
    TRANSACTION_TIMESTAMP_TEXT = NULLIF(TRIM(@TRANSACTION_TIMESTAMP), ''),
    CLIENT_ID_TEXT = NULLIF(TRIM(@CLIENT_ID), ''),
    TRANSACTION_VALUE_TEXT = NULLIF(TRIM(TRAILING '\r' FROM TRIM(@TRANSACTION_VALUE)), '');

SHOW WARNINGS;

-- Expected source snapshot: 4,227 rows. Raw values have not been corrected yet.
SELECT COUNT(*) AS RAW_ROWS
FROM transactions_raw;
