-- 5. Validation of the Reconstructed Snapshot
-- -----------------------------------------------------------------------------------------------------------------
-- Run after steps 1-4.3. This script only reads data and produces explicit PASS/FAIL results.
-- Expected values refer to the supplied CSV and the published report checked on 2026-10-24.
-- The exact revenue is recalculated from CSV after the original 198 -> 99 correction;
-- the live overview displays a rounded total. Cohort percentages below come from the live UI.
-- Review all result sets; do not refresh Power BI if a check fails.
-- -----------------------------------------------------------------------------------------------------------------

USE KDS_Transactions;

-- 5.01. Snapshot, Enrichment and Aggregation Controls
WITH checks AS (
    SELECT 'Raw rows' AS CHECK_NAME, 4227.00 AS EXPECTED_VALUE, COUNT(*) AS ACTUAL_VALUE FROM transactions_raw
    UNION ALL SELECT 'Reporting rows', 4227, COUNT(*) FROM transactions
    UNION ALL SELECT 'Customers', 1057, COUNT(DISTINCT CLIENT_ID) FROM transactions
    UNION ALL SELECT 'Raw amount sum', 1042515.27, SUM(ORIGINAL_TRANSACTION_VALUE) FROM transactions
    UNION ALL SELECT 'Corrected revenue', 1042416.27, SUM(TRANSACTION_VALUE) FROM transactions
    UNION ALL SELECT 'Corrected records', 1, SUM(CORRECTION_APPLIED) FROM transactions
    UNION ALL SELECT 'Correction amount', 99, SUM(ORIGINAL_TRANSACTION_VALUE - TRANSACTION_VALUE) FROM transactions
    UNION ALL SELECT 'Monthly transactions', 3833, COUNT(*) FROM transactions WHERE TRANSACTION_TYPE = 'MONTHLY'
    UNION ALL SELECT 'Semi-annual transactions', 49, COUNT(*) FROM transactions WHERE TRANSACTION_TYPE = 'SEMI-ANNUAL'
    UNION ALL SELECT 'Annual transactions', 345, COUNT(*) FROM transactions WHERE TRANSACTION_TYPE = 'ANNUAL'
    UNION ALL SELECT 'Unclassified types', 0, COUNT(*) FROM transactions WHERE TRANSACTION_TYPE IS NULL
    UNION ALL SELECT 'Missing renewal dates', 0, COUNT(*) FROM transactions WHERE EXPECTED_RENEWAL_DATE IS NULL
    UNION ALL SELECT 'Regular prices', 1215, COUNT(*) FROM transactions WHERE PROMOTION_PRICE = 'NO'
    UNION ALL SELECT 'Other prices', 3012, COUNT(*) FROM transactions WHERE PROMOTION_PRICE = 'YES'
    UNION ALL SELECT 'Active customers at last source date', 393, ACTIVE_CUSTOMERS FROM vw_5_data_config_2
    UNION ALL SELECT 'Average price rounded', 246.61, ROUND(AVG_PRICE, 2) FROM vw_5_data_config_2
    UNION ALL SELECT 'Median price', 169, MEDIAN_PRICE FROM vw_5_data_config_2
    UNION ALL SELECT 'Minimum price', 35.60, MIN_PRICE FROM vw_5_data_config_2
    UNION ALL SELECT 'Maximum price', 2089.05, MAX_PRICE FROM vw_5_data_config_2
    UNION ALL SELECT 'New-customer flags', 1057, SUM(NEW_CLIENT) FROM vw_3
    UNION ALL SELECT 'Customer summary rows', 1057, COUNT(*) FROM vw_2_customer_value
    UNION ALL SELECT 'Repeat customers', 595, COUNT(*) FROM vw_2_customer_value WHERE TRANSACTION_COUNT > 1
    UNION ALL SELECT 'First-purchase revenue', 502442.98, SUM(TRANSACTION_VALUE) FROM vw_3 WHERE NEW_CLIENT = 1
    UNION ALL SELECT 'Repeat-purchase revenue', 539973.29, SUM(TRANSACTION_VALUE) FROM vw_3 WHERE NEW_CLIENT = 0
    UNION ALL SELECT 'Aggregated revenue', 1042416.27, SUM(TOTAL_REVENUE) FROM vw_1
    UNION ALL SELECT 'Aggregated transactions', 4227, SUM(NUMBER_OF_TRANSACTIONS) FROM vw_1
    UNION ALL SELECT 'Customer-value total', 1042416.27, SUM(LTV) FROM vw_2_customer_value
    UNION ALL SELECT 'Calendar days', 878, COUNT(*) FROM vw_dim_transaction_date_2
    UNION ALL SELECT 'Calendar duplicate dates', 0, COUNT(*) - COUNT(DISTINCT TRANSACTION_DATE) FROM vw_dim_transaction_date_2
    UNION ALL SELECT 'Cohort periods', 29, COUNT(*) FROM vw_dim_cohort_period
    UNION ALL SELECT 'Retention matrix cells', 783, COUNT(*) FROM vw_4_monthly_cohort_retention
    UNION ALL SELECT 'Negative cohort periods', 0, COUNT(*) FROM vw_4_retention WHERE COHORT_PERIOD < 0
)
SELECT
    CHECK_NAME,
    EXPECTED_VALUE,
    ACTUAL_VALUE,
    CASE WHEN ACTUAL_VALUE = EXPECTED_VALUE THEN 'PASS' ELSE 'FAIL' END AS STATUS
FROM checks
ORDER BY CHECK_NAME;

-- 5.02. Historical Adjustment Audit (one row expected)
SELECT
    TRANSACTION_ID, TRANSACTION_TIMESTAMP, CLIENT_ID,
    ORIGINAL_TRANSACTION_VALUE, TRANSACTION_VALUE, CORRECTION_APPLIED
FROM transactions
WHERE CORRECTION_APPLIED = 1;

-- 5.03. Potential Exact Duplicates (zero rows expected; never deduplicate automatically)
SELECT
    TRANSACTION_TIMESTAMP, CLIENT_ID, ORIGINAL_TRANSACTION_VALUE, COUNT(*) AS ROW_COUNT
FROM transactions
GROUP BY TRANSACTION_TIMESTAMP, CLIENT_ID, ORIGINAL_TRANSACTION_VALUE
HAVING COUNT(*) > 1;

-- 5.04. Full Published Retention Matrix
-- Each token is one column from 0 to 28: initial size, then rounded percentages.
-- '-' represents a blank visual cell (observed zero or not-yet-observed period).
-- The unrounded analytical RETENTION_RATE keeps these two cases distinct.
WITH expected AS (
    SELECT CAST('2023-11-01' AS DATE) AS COHORT_MONTH, '52 75 63 58 56 48 48 38 33 31 31 35 35 37 37 31 35 31 33 33 29 25 25 25 25 21 21 19 21' AS EXPECTED_MATRIX
    UNION ALL SELECT CAST('2023-12-01' AS DATE), '4 100 50 75 75 100 50 50 50 50 50 25 - - - - - - - - - - - - - - - - -'
    UNION ALL SELECT CAST('2024-01-01' AS DATE), '17 71 47 41 29 35 35 29 35 12 6 6 12 6 12 6 12 6 6 6 6 6 6 6 6 6 6 - -'
    UNION ALL SELECT CAST('2024-02-01' AS DATE), '10 80 60 60 50 50 30 30 30 30 30 30 30 40 30 20 20 20 10 20 20 10 10 10 10 10 - - -'
    UNION ALL SELECT CAST('2024-03-01' AS DATE), '6 50 33 33 50 50 50 50 50 33 33 33 33 17 17 17 17 17 17 17 17 17 17 17 17 - - - -'
    UNION ALL SELECT CAST('2024-04-01' AS DATE), '6 83 67 50 50 33 17 - - - - - - - - - - 17 - - - - - - - - - - -'
    UNION ALL SELECT CAST('2024-05-01' AS DATE), '41 80 80 61 54 51 49 41 39 39 41 44 37 41 39 34 32 32 32 34 34 29 24 - - - - - -'
    UNION ALL SELECT CAST('2024-06-01' AS DATE), '2 100 100 100 100 100 100 100 100 100 100 100 100 100 50 50 50 100 100 100 50 50 - - - - - - -'
    UNION ALL SELECT CAST('2024-09-01' AS DATE), '81 80 75 63 56 47 42 38 33 28 25 22 25 22 21 17 15 12 12 - - - - - - - - - -'
    UNION ALL SELECT CAST('2024-10-01' AS DATE), '19 68 63 53 32 32 26 21 21 21 16 16 21 16 5 11 11 11 - - - - - - - - - - -'
    UNION ALL SELECT CAST('2024-11-01' AS DATE), '26 58 54 50 46 38 31 27 19 15 19 19 19 19 19 19 15 - - - - - - - - - - - -'
    UNION ALL SELECT CAST('2024-12-01' AS DATE), '11 45 45 45 27 27 18 18 27 9 9 9 9 9 9 9 - - - - - - - - - - - - -'
    UNION ALL SELECT CAST('2025-01-01' AS DATE), '24 63 58 38 33 25 17 17 17 17 13 8 8 8 8 - - - - - - - - - - - - - -'
    UNION ALL SELECT CAST('2025-02-01' AS DATE), '18 50 28 28 28 28 17 11 11 11 6 6 6 6 - - - - - - - - - - - - - - -'
    UNION ALL SELECT CAST('2025-03-01' AS DATE), '29 83 72 52 52 34 34 34 28 21 21 17 17 - - - - - - - - - - - - - - - -'
    UNION ALL SELECT CAST('2025-04-01' AS DATE), '14 71 64 50 36 21 21 21 21 14 14 21 - - - - - - - - - - - - - - - - -'
    UNION ALL SELECT CAST('2025-05-01' AS DATE), '31 55 42 39 35 35 35 32 32 29 26 - - - - - - - - - - - - - - - - - -'
    UNION ALL SELECT CAST('2025-06-01' AS DATE), '41 63 44 41 34 24 24 20 7 7 - - - - - - - - - - - - - - - - - - -'
    UNION ALL SELECT CAST('2025-07-01' AS DATE), '25 64 48 28 28 24 16 12 8 - - - - - - - - - - - - - - - - - - - -'
    UNION ALL SELECT CAST('2025-08-01' AS DATE), '29 79 69 55 41 31 34 17 - - - - - - - - - - - - - - - - - - - - -'
    UNION ALL SELECT CAST('2025-09-01' AS DATE), '53 72 58 47 40 30 26 - - - - - - - - - - - - - - - - - - - - - -'
    UNION ALL SELECT CAST('2025-10-01' AS DATE), '35 66 54 46 37 26 - - - - - - - - - - - - - - - - - - - - - - -'
    UNION ALL SELECT CAST('2025-11-01' AS DATE), '41 80 59 46 37 - - - - - - - - - - - - - - - - - - - - - - - -'
    UNION ALL SELECT CAST('2025-12-01' AS DATE), '29 86 66 45 - - - - - - - - - - - - - - - - - - - - - - - - -'
    UNION ALL SELECT CAST('2026-01-01' AS DATE), '34 74 59 - - - - - - - - - - - - - - - - - - - - - - - - - -'
    UNION ALL SELECT CAST('2026-02-01' AS DATE), '26 77 - - - - - - - - - - - - - - - - - - - - - - - - - - -'
    UNION ALL SELECT CAST('2026-03-01' AS DATE), '47 - - - - - - - - - - - - - - - - - - - - - - - - - - - -'
),
actual AS (
    SELECT
        COHORT_MONTH,
        GROUP_CONCAT(
            CASE
                WHEN COHORT_PERIOD = 0 THEN CAST(COHORT_SIZE AS CHAR)
                WHEN DISPLAY_RETENTION_RATE IS NULL THEN '-'
                ELSE CAST(ROUND(100.0 * ACTIVE_CUSTOMERS / COHORT_SIZE, 0) AS CHAR)
            END
            ORDER BY COHORT_PERIOD SEPARATOR ' '
        ) AS ACTUAL_MATRIX
    FROM vw_4_monthly_cohort_retention
    GROUP BY COHORT_MONTH
)
SELECT
    e.COHORT_MONTH,
    e.EXPECTED_MATRIX,
    a.ACTUAL_MATRIX,
    CASE WHEN a.ACTUAL_MATRIX = e.EXPECTED_MATRIX THEN 'PASS' ELSE 'FAIL' END AS STATUS
FROM expected e
LEFT JOIN actual a ON a.COHORT_MONTH = e.COHORT_MONTH
ORDER BY e.COHORT_MONTH;

-- 5.05. Explicit Empty-versus-Future Example
-- December 2023, period 12: observed zero; March 2026, period 1: unobserved NULL.
SELECT *
FROM vw_4_monthly_cohort_retention
WHERE (COHORT_MONTH = '2023-12-01' AND COHORT_PERIOD = 12)
    OR (COHORT_MONTH = '2026-03-01' AND COHORT_PERIOD = 1)
ORDER BY COHORT_MONTH, COHORT_PERIOD;
