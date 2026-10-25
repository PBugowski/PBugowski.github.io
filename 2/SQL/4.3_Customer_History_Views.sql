-- 4.3. Creation of Customer History Views
-- -----------------------------------------------------------------------------------------------------------------
-- Creates customer summaries and transaction detail with a first-purchase flag.
--
-- vw_2_kpi contains one row per customer. It combines:
--   - TRANSACTION_COUNT: the number of observed transactions,
--   - LTV: the sum of observed payments,
--   - avg_LT: the days between the first and last observed purchase,
--   - transaction_type: the latest observed subscription type.
-- Despite its name, avg_LT is an observed time span rather than an average
-- lifetime. A customer with one purchase has a time span of zero days.
-- LTV describes payments present in the dataset rather than future revenue.
--
-- The customer_value expression groups transactions by customer and
-- calculates the summary values. latest_transaction orders each customer's
-- purchases from latest to earliest. The final join retains the first row
-- of that sequence to attach one subscription type to each customer summary.
--
-- vw_3 contains one row per transaction. numbered_transactions establishes
-- purchase order across each customer's complete observed history, including
-- all subscription types. NEW_CLIENT equals 1 for the earliest purchase and
-- 0 for subsequent purchases. Filtering the resulting view does not change
-- which transaction was originally assigned the first position.
--
-- The first observed purchase may not be the customer's first purchase
-- outside the available dataset. Transactions on the same date are ordered
-- by TRANSACTION_ID because the import retains dates without times. The
-- identifier resolves ties according to the original CSV row order.
-- -----------------------------------------------------------------------------------------------------------------

USE KDS_Transactions;


-- Customer Value and Observed Lifetime
-- -----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_2_kpi AS
WITH customer_value AS (                                                              -- WITH defines named intermediate query results used by this view.
    SELECT
        CLIENT_ID,
        COUNT(*) AS TRANSACTION_COUNT,
        SUM(TRANSACTION_VALUE) AS LTV,
        DATEDIFF(MAX(TRANSACTION_DATE), MIN(TRANSACTION_DATE)) AS OBSERVED_LIFETIME_DAYS  -- DATEDIFF returns the number of days between the latest and earliest purchase dates.
    FROM transactions
    GROUP BY CLIENT_ID
),
latest_transaction AS (
    SELECT
        CLIENT_ID,
        TRANSACTION_TYPE,
        ROW_NUMBER() OVER (                                                           -- Assigns consecutive positions to transactions in each customer partition.
            PARTITION BY CLIENT_ID                                                    -- Restarts the purchase numbering for each customer.
            ORDER BY TRANSACTION_DATE DESC, TRANSACTION_ID DESC                       -- Places the latest date first and resolves same-day ties by transaction ID.
        ) AS RN
    FROM transactions
)
SELECT
    c.CLIENT_ID AS client_id,
    c.TRANSACTION_COUNT,
    c.LTV,
    c.OBSERVED_LIFETIME_DAYS AS avg_LT,
    t.TRANSACTION_TYPE AS transaction_type
FROM customer_value c
JOIN latest_transaction t                                                             -- Connects each customer summary with that customer's transaction sequence.
    ON c.CLIENT_ID = t.CLIENT_ID
WHERE t.RN = 1;                                                                       -- Keeps the subscription type from the latest observed transaction.


-- Transactions with First-Purchase Identification
-- -----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_3 AS
WITH numbered_transactions AS (
    SELECT
        TRANSACTION_ID,
        TRANSACTION_DATE,
        CLIENT_ID,
        TRANSACTION_VALUE,
        TRANSACTION_TYPE,
        PROMOTION_PRICE,
        ROW_NUMBER() OVER (
            PARTITION BY CLIENT_ID
            ORDER BY TRANSACTION_DATE, TRANSACTION_ID                                 -- Places the earliest observed purchase first, with ID resolving same-day ties.
        ) AS PURCHASE_NUMBER
    FROM transactions
)
SELECT
    TRANSACTION_ID,
    TRANSACTION_DATE,
    CLIENT_ID,
    TRANSACTION_VALUE,
    TRANSACTION_TYPE,
    PROMOTION_PRICE,
    CASE
        WHEN PURCHASE_NUMBER = 1 THEN 1                                               -- Flags only the first observed purchase as a new customer.
        ELSE 0
    END AS NEW_CLIENT
FROM numbered_transactions;
