-- 4.1. Reporting Views for Power BI
-- -----------------------------------------------------------------------------------------------------------------
-- Creates transaction, daily aggregate and customer-level data for the report.
-- Requires steps 1-3.2. Missing original views are reconstructed, not recovered verbatim.
-- Known names vw_1, vw_2, vw_3 and vw_5_data_config_2 are retained.
-- Full names of truncated screenshot objects cannot be established from the image;
-- descriptive names are assigned to vw_1_active_customers and vw_2_customer_value.
-- -----------------------------------------------------------------------------------------------------------------

USE KDS_Transactions;

-- 4.1.01. Daily Revenue and Transaction Counts
-- Grain: one date / subscription type / price category.
-- Counts and revenue are additive. Average prices must be calculated as total revenue
-- divided by total transactions, never by averaging averages across daily groups.
CREATE OR REPLACE VIEW vw_1 AS
SELECT
    TRANSACTION_DATE,
    TRANSACTION_TYPE,
    PROMOTION_PRICE,
    COUNT(*) AS NUMBER_OF_TRANSACTIONS,
    SUM(TRANSACTION_VALUE) AS TOTAL_REVENUE,
    MIN(TRANSACTION_VALUE) AS MIN_PRICE,
    MAX(TRANSACTION_VALUE) AS MAX_PRICE
FROM transactions
GROUP BY TRANSACTION_DATE, TRANSACTION_TYPE, PROMOTION_PRICE;

-- 4.1.02. Customers Purchasing on a Given Day
-- Grain: one date / subscription type / price category.
-- ACTIVE_USERS is a DISTINCT customer count within that group. It must NOT be summed
-- across dates or categories. Use DISTINCTCOUNT on vw_3 or vw_1_active_customers instead
-- when calculating monthly, annual or overall customer counts.
CREATE OR REPLACE VIEW vw_2 AS
SELECT
    TRANSACTION_DATE,
    TRANSACTION_TYPE,
    PROMOTION_PRICE,
    COUNT(DISTINCT CLIENT_ID) AS ACTIVE_USERS,
    COUNT(*) AS NUMBER_OF_TRANSACTIONS,
    SUM(TRANSACTION_VALUE) AS TOTAL_REVENUE
FROM transactions
GROUP BY TRANSACTION_DATE, TRANSACTION_TYPE, PROMOTION_PRICE;

CREATE OR REPLACE VIEW vw_1_active_customers AS
SELECT DISTINCT
    CLIENT_ID,
    TRANSACTION_DATE,
    TRANSACTION_TYPE,
    PROMOTION_PRICE
FROM transactions;

-- 4.1.03. Main Transaction Fact
-- Grain: one source transaction. NEW_CLIENT = 1 only on the customer's first observed
-- transaction. PROMOTION_PRICE and TRANSACTION_TYPE describe this transaction, not a
-- permanent customer attribute. This is the recommended fact table for new PBI measures.
CREATE OR REPLACE VIEW vw_3 AS
SELECT
    TRANSACTION_ID,
    TRANSACTION_TIMESTAMP,
    TRANSACTION_DATE,
    CLIENT_ID,
    ORIGINAL_TRANSACTION_VALUE,
    TRANSACTION_VALUE,
    CORRECTION_APPLIED,
    TRANSACTION_TYPE,
    PROMOTION_PRICE,
    EXPECTED_RENEWAL_DATE,
    NEW_CLIENT,
    PURCHASE_NUMBER,
    FIRST_PURCHASE_DATE,
    PREVIOUS_PURCHASE_DATE,
    DAYS_SINCE_PREVIOUS_PURCHASE,
    TRANSACTION_YEAR,
    TRANSACTION_MONTH_NUMBER
FROM vw_transaction_history;

-- 4.1.04. Observed Customer Value
-- Grain: exactly one customer, ensuring CLIENT_ID is unique for the inactive relationship
-- visible in the supplied model. LTV is observed cumulative payments, NOT predicted lifetime
-- value or profit. Subscription type is taken from the latest transaction in the snapshot.
-- The screenshot's avg_LT formula is unknown; explicit descriptive columns replace it.
CREATE OR REPLACE VIEW vw_2_customer_value AS
SELECT
    h.CLIENT_ID,
    SUM(h.TRANSACTION_VALUE) AS LTV,
    COUNT(*) AS TRANSACTION_COUNT,
    MIN(h.TRANSACTION_DATE) AS FIRST_PURCHASE_DATE,
    MAX(h.TRANSACTION_DATE) AS LAST_PURCHASE_DATE,
    DATEDIFF(MAX(h.TRANSACTION_DATE), MIN(h.TRANSACTION_DATE)) AS OBSERVED_LIFETIME_DAYS,
    AVG(h.DAYS_SINCE_PREVIOUS_PURCHASE) AS AVG_DAYS_BETWEEN_TRANSACTIONS,
    MAX(CASE WHEN h.REVERSE_PURCHASE_NUMBER = 1 THEN h.TRANSACTION_TYPE END) AS TRANSACTION_TYPE
FROM (
    SELECT
        t.*,
        ROW_NUMBER() OVER (
            PARTITION BY CLIENT_ID
            ORDER BY TRANSACTION_TIMESTAMP DESC, TRANSACTION_ID DESC
        ) AS REVERSE_PURCHASE_NUMBER
    FROM vw_transaction_history t
) h
GROUP BY h.CLIENT_ID;

-- 4.1.05. Whole-Snapshot Control Statistics
-- Grain: a single row. This table remains disconnected in the supplied model; its values
-- do not respond to slicers. Use measures over vw_3 for interactive KPI cards.
-- ACTIVE_CUSTOMERS follows the original rule: at least one renewal date >= last source date.
-- This is an approximation from purchase dates and inferred terms, not actual account status.
CREATE OR REPLACE VIEW vw_5_data_config_2 AS
WITH ranked_prices AS (
    SELECT
        TRANSACTION_VALUE,
        ROW_NUMBER() OVER (ORDER BY TRANSACTION_VALUE, TRANSACTION_ID) AS RN,
        COUNT(*) OVER () AS TOTAL_ROWS
    FROM transactions
),
last_date AS (
    SELECT MAX(TRANSACTION_DATE) AS MAX_DATE
    FROM transactions
)
SELECT
    COUNT(*) AS ALL_TRANSACTIONS,
    COUNT(CASE WHEN TRANSACTION_TYPE = 'MONTHLY' THEN 1 END) AS MONTHLY_TRANSACTIONS,
    COUNT(CASE WHEN TRANSACTION_TYPE = 'SEMI-ANNUAL' THEN 1 END) AS SEMI_ANNUAL_TRANSACTIONS,
    COUNT(CASE WHEN TRANSACTION_TYPE = 'ANNUAL' THEN 1 END) AS ANNUAL_TRANSACTIONS,
    COUNT(DISTINCT DATE_FORMAT(TRANSACTION_DATE, '%Y-%m')) AS TOTAL_MONTHS,
    COUNT(DISTINCT CLIENT_ID) AS TOTAL_CUSTOMERS,
    COUNT(DISTINCT CASE WHEN EXPECTED_RENEWAL_DATE >= d.MAX_DATE THEN CLIENT_ID END) AS ACTIVE_CUSTOMERS,
    COUNT(CASE WHEN PROMOTION_PRICE = 'YES' THEN 1 END) AS DISCOUNTED,
    COUNT(CASE WHEN PROMOTION_PRICE = 'NO' THEN 1 END) AS STANDARD,
    MIN(TRANSACTION_VALUE) AS MIN_PRICE,
    MAX(TRANSACTION_VALUE) AS MAX_PRICE,
    SUM(TRANSACTION_VALUE) AS TOTAL_REVENUE,
    AVG(TRANSACTION_VALUE) AS AVG_PRICE,
    (
        SELECT AVG(TRANSACTION_VALUE)
        FROM ranked_prices
        WHERE RN IN (FLOOR((TOTAL_ROWS + 1) / 2), CEIL((TOTAL_ROWS + 1) / 2))
    ) AS MEDIAN_PRICE
FROM transactions t
CROSS JOIN last_date d;
