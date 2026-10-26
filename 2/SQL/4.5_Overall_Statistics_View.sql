-- 4.5. Creation of the Overall Statistics View
-- -----------------------------------------------------------------------------------------------------------------
-- Creates vw_5_data_config, a single-row summary of the transactions table.
-- The view calculates:
--   - transaction counts, including counts by subscription type,
--   - observation months and total customers,
--   - active customers at the end of the available data,
--   - regular and non-standard price transaction counts,
--   - minimum, maximum, total, average and median transaction values.
--
-- last_date identifies the latest transaction date. ACTIVE_CUSTOMERS counts
-- customers with at least one expected renewal date on or after that date.
-- For the supplied data the reference date is 2026-03-31, rather than the
-- current date when the query is executed. TOTAL_MONTHS counts distinct
-- calendar months containing transactions, not subscription coverage months.
--
-- ranked_prices orders transaction values and assigns their positions in the
-- complete dataset. The median selects one central value for an odd row count
-- or averages the two central values for an even row count.
--
-- DISCOUNTED counts PROMOTION_PRICE = YES and STANDARD counts NO. These
-- statistics inherit the price rules applied during data preparation; the
-- DISCOUNTED name does not establish that every included amount is a discount.
--
-- The view aggregates the complete table without date or customer filters.
-- To calculate the same statistics for a subset, apply the required filters
-- to the underlying records before performing the aggregations and ranking.
--
-- Reference results for the supplied CSV after the transaction correction:
--   - 4,227 transactions, 1,057 customers and 393 active customers,
--   - 29 observation months and total revenue of 1,042,416.27,
--   - 3,833 monthly, 49 semi-annual and 345 annual transactions,
--   - 1,215 regular and 3,012 non-standard price transactions,
--   - minimum 35.60, maximum 2,089.05, average 246.61 and median 169.00.
-- -----------------------------------------------------------------------------------------------------------------


-- Active database choice
-- -----------------------------------------------------------------------------------------------------------------
USE KDS_Transactions;																						-- Selects the active database for subsequent statements.	


-- Dataset-Wide KPI Summary
-- -----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_5_data_config AS
WITH last_date AS (
    SELECT MAX(TRANSACTION_DATE) AS MAX_DATE                                        						-- Uses the latest transaction date as the activity reference date.
    FROM transactions
),
ranked_prices AS (
    SELECT
        TRANSACTION_VALUE,
        ROW_NUMBER() OVER (
            ORDER BY TRANSACTION_VALUE, TRANSACTION_ID                                						-- Orders amounts from lowest to highest and resolves ties by transaction ID.
        ) AS RN,
        COUNT(*) OVER () AS TOTAL_ROWS                                                						-- Returns the full row count on every row without collapsing the ranked records.
    FROM transactions
)
SELECT
    COUNT(*) AS ALL_TRANSACTIONS,
    COUNT(CASE WHEN TRANSACTION_TYPE = 'MONTHLY' THEN 1 END) AS MONTHLY_TRANSACTIONS,  						-- Counts matching rows; CASE returns NULL for other rows, which COUNT ignores.
    COUNT(CASE WHEN TRANSACTION_TYPE = 'SEMI-ANNUAL' THEN 1 END) AS SEMI_ANNUAL_TRANSACTIONS,
    COUNT(CASE WHEN TRANSACTION_TYPE = 'ANNUAL' THEN 1 END) AS ANNUAL_TRANSACTIONS,
    COUNT(DISTINCT DATE_FORMAT(TRANSACTION_DATE, '%Y-%m')) AS TOTAL_MONTHS,           						-- DATE_FORMAT creates a year-month key so the same month in different years remains distinct.
    COUNT(DISTINCT CLIENT_ID) AS TOTAL_CUSTOMERS,
    -- Includes a customer once if at least one inferred subscription reaches the reference date.
    COUNT(DISTINCT CASE WHEN EXPECTED_RENEWAL_DATE >= d.MAX_DATE THEN CLIENT_ID END) AS ACTIVE_CUSTOMERS,
    COUNT(CASE WHEN PROMOTION_PRICE = 'YES' THEN 1 END) AS DISCOUNTED,
    COUNT(CASE WHEN PROMOTION_PRICE = 'NO' THEN 1 END) AS STANDARD,
    MIN(TRANSACTION_VALUE) AS MIN_PRICE,
    MAX(TRANSACTION_VALUE) AS MAX_PRICE,
    SUM(TRANSACTION_VALUE) AS TOTAL_REVENUE,
    AVG(TRANSACTION_VALUE) AS AVG_PRICE,                                              						-- AVG calculates the arithmetic mean of the transaction amounts.
    (
        SELECT AVG(TRANSACTION_VALUE)
        FROM ranked_prices
        WHERE RN IN (
            FLOOR((TOTAL_ROWS + 1) / 2),                                              						-- FLOOR rounds down to the lower middle position.
            CEIL((TOTAL_ROWS + 1) / 2)                                                						-- CEIL rounds up to the upper middle position; both positions coincide for an odd row count.
        )
    ) AS MEDIAN_PRICE
FROM transactions t
CROSS JOIN last_date d;                                                               						-- Makes the single reference-date row available to the full transaction summary.
