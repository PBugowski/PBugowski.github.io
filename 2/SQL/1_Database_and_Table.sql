-- 1. Creation of Database and Table with Appropriate Data Types
-- -----------------------------------------------------------------------------------------------------------------
-- Creates the KDS_Transactions database and the main transactions table.
-- Each row represents one payment recorded in the source CSV file.
-- The table stores:
--   - transaction identifier and date,
--   - customer identifier and transaction value,
--   - subscription type and expected renewal date,
--   - price category and calendar attributes used for analysis.
--
-- The CSV provides the transaction date, customer identifier and amount.
-- TRANSACTION_ID is generated during import. The remaining attributes are
-- populated by the data preparation script.
--
-- DATE stores a calendar date without a time component. INT is used for
-- identifiers and numeric date attributes. DECIMAL(10,2) stores transaction
-- amounts with two decimal places, while VARCHAR stores category labels.
--
-- The scripts use MySQL 8.0 syntax, including common table expressions and
-- window functions. Execute them in the following order:
--   1. Database and Table
--   2. Import of Data
--   3. Preparation of Data
--   4.1. Dimension Views
--   4.2. Transaction Activity Views
--   4.3. Customer History Views
--   4.4. Cohort Retention View
--   4.5. Overall Statistics View
--
-- This script initializes a new database. Each subsequent script selects
-- KDS_Transactions explicitly before accessing its tables or views.
-- -----------------------------------------------------------------------------------------------------------------

CREATE DATABASE KDS_Transactions                                                      -- Creates the database used by the transaction analysis.
CHARACTER SET utf8mb4                                                                 -- Sets UTF-8 character encoding.
COLLATE utf8mb4_unicode_ci;                                                           -- Defines case-insensitive Unicode text comparison and sorting.


USE KDS_Transactions;                                                                 -- Selects the active database.


CREATE TABLE transactions(
TRANSACTION_ID INT PRIMARY KEY AUTO_INCREMENT,                                        -- Assigns a unique, automatically incremented identifier to each imported row.
TRANSACTION_DATE DATE,                                                                -- Stores the calendar date without the source timestamp.
CLIENT_ID INT,
TRANSACTION_VALUE DECIMAL (10,2),                                                     -- Stores monetary amounts with two decimal places.
TRANSACTION_TYPE VARCHAR(20),
EXPECTED_RENEWAL_DATE DATE,
PROMOTION_PRICE VARCHAR(3),
TRANSACTION_YEAR INT,
TRANSACTION_MONTH_NUMBER INT
);
