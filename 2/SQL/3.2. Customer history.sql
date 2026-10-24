-- 3.2. Customer History and Transaction Sequence
-- -----------------------------------------------------------------------------------------------------------------
-- Source: transactions after step 3.1. Output grain: one row per transaction.
-- Adds a deterministic purchase sequence, the first observed purchase, previous purchase,
-- new-customer flag, and the calendar-month distance from the customer's first purchase.
-- History is calculated BEFORE report filters. Selecting a later year must not relabel
-- an existing customer as new. Same-day transactions are ordered by timestamp and row ID.
-- Reconstructed logic: the original definitions of these missing objects were unavailable.
-- -----------------------------------------------------------------------------------------------------------------

USE KDS_Transactions;

CREATE OR REPLACE VIEW vw_transaction_history AS
SELECT
    h.*,
    CASE WHEN PURCHASE_NUMBER = 1 THEN 1 ELSE 0 END AS NEW_CLIENT,
    DATEDIFF(TRANSACTION_DATE, PREVIOUS_PURCHASE_DATE) AS DAYS_SINCE_PREVIOUS_PURCHASE,
    CAST(DATE_FORMAT(FIRST_PURCHASE_DATE, '%Y-%m-01') AS DATE) AS COHORT_MONTH,
    (YEAR(TRANSACTION_DATE) - YEAR(FIRST_PURCHASE_DATE)) * 12
        + MONTH(TRANSACTION_DATE) - MONTH(FIRST_PURCHASE_DATE) AS COHORT_PERIOD
FROM (
    SELECT
        t.*,
        ROW_NUMBER() OVER (
            PARTITION BY CLIENT_ID
            ORDER BY TRANSACTION_TIMESTAMP, TRANSACTION_ID
        ) AS PURCHASE_NUMBER,
        MIN(TRANSACTION_DATE) OVER (PARTITION BY CLIENT_ID) AS FIRST_PURCHASE_DATE,
        LAG(TRANSACTION_DATE) OVER (
            PARTITION BY CLIENT_ID
            ORDER BY TRANSACTION_TIMESTAMP, TRANSACTION_ID
        ) AS PREVIOUS_PURCHASE_DATE
    FROM transactions t
) h;

-- Preserves the original view name and its customer-level output contract.
CREATE OR REPLACE VIEW vw_4_cohort_date AS
SELECT
    CLIENT_ID,
    MIN(TRANSACTION_DATE) AS FIRST_PURCHASE_DATE,
    MONTH(MIN(TRANSACTION_DATE)) AS `MONTH`,
    YEAR(MIN(TRANSACTION_DATE)) AS `YEAR`
FROM transactions
GROUP BY CLIENT_ID;
