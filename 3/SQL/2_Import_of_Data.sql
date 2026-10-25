-- 2. Importing Data from CSV
-- -----------------------------------------------------------------------------------------------------------------
-- Imports products, stores, sales, inventory and calendar from the Raw Data folder. The
-- relative paths are resolved by the MySQL client. Start the client from the directory
-- containing Raw Data or replace each path with an absolute path.
--
-- The column lists follow the original CSV order. Product costs and prices contain a dollar
-- sign and trailing spaces. Sales dates and store opening dates use YYYY-MM-DD; calendar
-- dates use M/D/YYYY. The import removes surrounding spaces and a trailing carriage return
-- from the last field, and converts dates explicitly. Empty source values become NULL. No
-- sales, prices or stock quantities are corrected or deduplicated.
--
-- Run the import once into the empty tables created by script 1. Inspect each SHOW WARNINGS
-- result and resolve any skipped rows or conversion warnings before continuing. Local file
-- loading must be enabled by both the server and the client. The commented server setting is
-- only needed when local_infile is disabled and requires administrative privileges.
-- -----------------------------------------------------------------------------------------------------------------

USE toys_in_mexico;


-- SET GLOBAL local_infile = 1;  -- Enable on the server only if local loading is currently disabled.


-- Products Import
-- -----------------------------------------------------------------------------------------------------------------

LOAD DATA LOCAL INFILE 'Raw Data/products.csv'       -- Reads the CSV from the client computer.
INTO TABLE products
FIELDS TERMINATED BY ','                           -- Separates source columns with commas.
OPTIONALLY ENCLOSED BY '"'                         -- Allows quoted field values.
LINES TERMINATED BY '\n'                           -- Reads LF records; The last field is cleaned separately for CRLF files.
IGNORE 1 ROWS                                     -- Skips the header.
(@PRODUCT_ID, @PRODUCT_NAME, @PRODUCT_CATEGORY, @PRODUCT_COST, @PRODUCT_PRICE)  -- User variables hold source text before conversion.
SET
    PRODUCT_ID = NULLIF(TRIM(@PRODUCT_ID), ''),  -- TRIM removes surrounding spaces; NULLIF converts empty text to NULL.
    PRODUCT_NAME = NULLIF(TRIM(@PRODUCT_NAME), ''),
    PRODUCT_CATEGORY = NULLIF(TRIM(@PRODUCT_CATEGORY), ''),
    PRODUCT_COST = NULLIF(TRIM(REPLACE(@PRODUCT_COST, '$', '')), ''),  -- REPLACE removes the currency symbol before the DECIMAL conversion.
    PRODUCT_PRICE = NULLIF(TRIM(REPLACE(REPLACE(@PRODUCT_PRICE, '\r', ''), '$', '')), '');  -- Removes the final CR character when the source uses CRLF records.

SHOW WARNINGS;  -- Check import diagnostics immediately, before running another statement.


-- Stores Import
-- -----------------------------------------------------------------------------------------------------------------

LOAD DATA LOCAL INFILE 'Raw Data/stores.csv'
INTO TABLE stores
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@STORE_ID, @STORE_NAME, @STORE_CITY, @STORE_LOCATION, @STORE_OPEN_DATE)
SET
    STORE_ID = NULLIF(TRIM(@STORE_ID), ''),
    STORE_NAME = NULLIF(TRIM(@STORE_NAME), ''),
    STORE_CITY = NULLIF(TRIM(@STORE_CITY), ''),
    STORE_LOCATION = NULLIF(TRIM(@STORE_LOCATION), ''),
    STORE_OPEN_DATE = STR_TO_DATE(NULLIF(TRIM(REPLACE(@STORE_OPEN_DATE, '\r', '')), ''), '%Y-%m-%d');  -- STR_TO_DATE parses text using the specified source-date format.

SHOW WARNINGS;


-- Sales Import
-- -----------------------------------------------------------------------------------------------------------------

LOAD DATA LOCAL INFILE 'Raw Data/sales.csv'
INTO TABLE sales
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@SALE_ID, @D_DATE, @STORE_ID, @PRODUCT_ID, @UNITS)
SET
    SALE_ID = NULLIF(TRIM(@SALE_ID), ''),
    D_DATE = STR_TO_DATE(NULLIF(TRIM(@D_DATE), ''), '%Y-%m-%d'),
    STORE_ID = NULLIF(TRIM(@STORE_ID), ''),
    PRODUCT_ID = NULLIF(TRIM(@PRODUCT_ID), ''),
    UNITS = NULLIF(TRIM(REPLACE(@UNITS, '\r', '')), '');

SHOW WARNINGS;


-- Inventory Import
-- -----------------------------------------------------------------------------------------------------------------

LOAD DATA LOCAL INFILE 'Raw Data/inventory.csv'
INTO TABLE inventory
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@STORE_ID, @PRODUCT_ID, @STOCK_ON_HAND)
SET
    STORE_ID = NULLIF(TRIM(@STORE_ID), ''),
    PRODUCT_ID = NULLIF(TRIM(@PRODUCT_ID), ''),
    STOCK_ON_HAND = NULLIF(TRIM(REPLACE(@STOCK_ON_HAND, '\r', '')), '');

SHOW WARNINGS;


-- Calendar Import
-- -----------------------------------------------------------------------------------------------------------------

LOAD DATA LOCAL INFILE 'Raw Data/calendar.csv'
INTO TABLE calendar
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@D_DATE)
SET
    D_DATE = STR_TO_DATE(NULLIF(TRIM(REPLACE(@D_DATE, '\r', '')), ''), '%m/%d/%Y');

SHOW WARNINGS;
