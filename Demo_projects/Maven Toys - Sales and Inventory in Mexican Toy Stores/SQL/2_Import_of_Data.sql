-- 2. Importing Source Data from CSV
-- -----------------------------------------------------------------------------------------------------------------
-- Imports products, stores, sales, inventory and calendar from Raw Data into
-- the tables created by the database script. The import process:
--   - reads comma-separated values with optional double quotation marks,
--   - skips each CSV header,
--   - temporarily stores source text in user variables,
--   - removes surrounding spaces and converts empty text to NULL,
--   - removes currency symbols from product costs and prices,
--   - parses source dates and removes a trailing carriage return.
--
-- The variable lists follow the original column order in each CSV. Sales
-- and store opening dates use YYYY-MM-DD; calendar dates use M/D/YYYY.
-- Product amounts contain a dollar sign and may include trailing spaces.
-- The final field of each row is cleaned for files using CRLF line endings.
-- The script does not correct quantities, update prices or deduplicate rows.
--
-- The relative paths are resolved by the MySQL client. Its working directory
-- must contain Raw Data, or the paths must be adjusted to the source files.
-- Local loading must be enabled on both the server and the client. The
-- commented server setting is optional and requires administrative privileges.
-- -----------------------------------------------------------------------------------------------------------------


-- Active database choice
-- -----------------------------------------------------------------------------------------------------------------
USE TOYS_IN_MEXICO;                                                          		 		-- Selects the active database for subsequent statements.


-- Local File Loading
-- -----------------------------------------------------------------------------------------------------------------
SET GLOBAL local_infile = 1;                                                         		-- Enables local file loading on the server.


-- Products Import
-- -----------------------------------------------------------------------------------------------------------------
LOAD DATA LOCAL INFILE 'Raw Data/products.csv'                                       		-- Reads the CSV from the client computer.
INTO TABLE products                                                                  		-- Specifies the destination table.
FIELDS TERMINATED BY ','                                                             		-- Uses commas to separate source columns.
OPTIONALLY ENCLOSED BY '"'                                                           		-- Allows field values to be enclosed in double quotation marks.
LINES TERMINATED BY '\n'                                                             		-- Uses newline characters to separate source records.
IGNORE 1 ROWS                                                                        		-- Skips the column names in the first row.
(@PRODUCT_ID, @PRODUCT_NAME, @PRODUCT_CATEGORY, @PRODUCT_COST, @PRODUCT_PRICE)       		-- Reads source text into variables before assigning table columns.
SET
    PRODUCT_ID = NULLIF(TRIM(@PRODUCT_ID), ''),                                      		-- TRIM removes surrounding spaces; NULLIF returns NULL when its two arguments are equal.
    PRODUCT_NAME = NULLIF(TRIM(@PRODUCT_NAME), ''),
    PRODUCT_CATEGORY = NULLIF(TRIM(@PRODUCT_CATEGORY), ''),
    PRODUCT_COST = NULLIF(TRIM(REPLACE(@PRODUCT_COST, '$', '')), ''),                		-- REPLACE substitutes matching text; an empty replacement removes the currency symbol.
    PRODUCT_PRICE = NULLIF(TRIM(REPLACE(REPLACE(@PRODUCT_PRICE, '\r', ''), '$', '')), ''); 	-- Also removes a trailing carriage return from the final field of a CRLF record.


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
    STORE_OPEN_DATE = STR_TO_DATE(NULLIF(TRIM(REPLACE(@STORE_OPEN_DATE, '\r', '')), ''), '%Y-%m-%d'); -- STR_TO_DATE parses the text according to the specified year-month-day format.


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
    D_DATE = STR_TO_DATE(NULLIF(TRIM(REPLACE(@D_DATE, '\r', '')), ''), '%m/%d/%Y');  -- The calendar file supplies month/day/year dates, unlike the other date sources.
