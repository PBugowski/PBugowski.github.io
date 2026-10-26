-- 4.1. Creation of Dimension Views
-- -----------------------------------------------------------------------------------------------------------------
-- Creates four dimension views from the prepared transactions table:
--   - vw_dim_transaction_type: subscription types,
--   - vw_dim_date_year: years containing transactions,
--   - vw_dim_date_month: month numbers and month names,
--   - vw_dim_promotion: regular and non-standard price flags.
--
-- Each view returns unique values from its selected source attributes and
-- excludes NULL categories or dates. The views can be used as lookup datasets
-- when filtering or joining transaction summaries.
--
-- The year and month views contain values present in the source data.
-- They do not generate a continuous calendar or a combined year-month key.
-- The month dimension contains one row per month number, shared across years.
--
-- TRANSACTION_MONTH_NUMBER provides chronological month ordering.
-- MONTHNAME follows the MySQL session's lc_time_names setting; an English
-- locale such as en_US returns English month names. Queries requiring a
-- specific row order should include their own ORDER BY clause.
--
-- Run this script after the preparation script has populated subscription
-- types and price categories. The views read the current table contents
-- rather than storing separate copies of the lookup values.
-- -----------------------------------------------------------------------------------------------------------------


-- Active database choice
-- -----------------------------------------------------------------------------------------------------------------
USE KDS_Transactions;																-- Selects the active database for subsequent statements.	


-- Subscription Type Dimension
-- -----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_dim_transaction_type AS                                   -- Creates the view or replaces its existing definition.
SELECT DISTINCT TRANSACTION_TYPE                                                    -- DISTINCT keeps one row for each different combination of selected values.
FROM transactions
WHERE TRANSACTION_TYPE IS NOT NULL                                                  -- Excludes missing subscription categories.
ORDER BY TRANSACTION_TYPE;


-- Transaction Year Dimension
-- -----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_dim_date_year AS
SELECT DISTINCT YEAR(TRANSACTION_DATE) AS TRANSACTION_YEAR
FROM transactions
WHERE TRANSACTION_DATE IS NOT NULL
ORDER BY TRANSACTION_YEAR;


-- Transaction Month Dimension
-- -----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_dim_date_month AS
SELECT DISTINCT
    MONTH(TRANSACTION_DATE) AS TRANSACTION_MONTH_NUMBER,
    MONTHNAME(TRANSACTION_DATE) AS TRANSACTION_MONTH_NAME                           -- Returns the month name in the current MySQL session language.
FROM transactions
WHERE TRANSACTION_DATE IS NOT NULL
ORDER BY TRANSACTION_MONTH_NUMBER;


-- Price Category Dimension
-- -----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_dim_promotion AS
SELECT DISTINCT PROMOTION_PRICE
FROM transactions
WHERE PROMOTION_PRICE IS NOT NULL;
