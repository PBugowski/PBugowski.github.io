-- 4.3. Monthly Purchase Cohorts and Retention
-- -----------------------------------------------------------------------------------------------------------------
-- Requires steps 3.2 and 4.2. The detailed view supports dynamic PBI DISTINCTCOUNT measures.
-- The summary view reproduces the default monthly-subscription matrix without slicers.
-- This project needs no many-to-many bridge; this step contains the distinct cohort logic.
--
-- Cohort origin: first observed purchase across ALL subscription types.
-- Period: calendar month difference, not elapsed 30-day intervals.
-- Numerator: customers with a MONTHLY transaction in that cohort and period.
-- Denominator: customers with a MONTHLY transaction in period 0 of the same cohort.
-- Customers can change subscription type; later numerators are NOT restricted to the
-- period-0 monthly membership. This reproduces the published matrix, but is not a closed
-- monthly-customer survival cohort. It can theoretically exceed 100%; do not cap it.
-- -----------------------------------------------------------------------------------------------------------------

USE KDS_Transactions;

CREATE OR REPLACE VIEW vw_4_retention AS
SELECT DISTINCT
    CLIENT_ID,
    TRANSACTION_DATE,
    TRANSACTION_TYPE,
    PROMOTION_PRICE,
    FIRST_PURCHASE_DATE,
    COHORT_MONTH,
    COHORT_PERIOD,
    MONTH(TRANSACTION_DATE) AS `MONTH`
FROM vw_transaction_history;

-- Grain: one cohort month / offset (0..last overall offset).
-- RETENTION_RATE distinguishes observed zero from future/unobserved NULL.
-- DISPLAY_RETENTION_RATE additionally blanks observed zero to match the original visual.
-- The final observed month is included; its completeness depends on source coverage.
CREATE OR REPLACE VIEW vw_4_monthly_cohort_retention AS
WITH monthly_counts AS (
    SELECT
        COHORT_MONTH,
        COHORT_PERIOD,
        COUNT(DISTINCT CLIENT_ID) AS ACTIVE_CUSTOMERS
    FROM vw_4_retention
    WHERE TRANSACTION_TYPE = 'MONTHLY'
    GROUP BY COHORT_MONTH, COHORT_PERIOD
),
cohort_sizes AS (
    SELECT COHORT_MONTH, ACTIVE_CUSTOMERS AS COHORT_SIZE
    FROM monthly_counts
    WHERE COHORT_PERIOD = 0
),
observation AS (
    SELECT CAST(DATE_FORMAT(MAX(TRANSACTION_DATE), '%Y-%m-01') AS DATE) AS LAST_MONTH
    FROM transactions
)
SELECT
    s.COHORT_MONTH,
    p.COHORT_PERIOD,
    s.COHORT_SIZE,
    CASE WHEN DATE_ADD(s.COHORT_MONTH, INTERVAL p.COHORT_PERIOD MONTH) <= o.LAST_MONTH
        THEN 1 ELSE 0 END AS IS_OBSERVED,
    CASE WHEN DATE_ADD(s.COHORT_MONTH, INTERVAL p.COHORT_PERIOD MONTH) <= o.LAST_MONTH
        THEN COALESCE(c.ACTIVE_CUSTOMERS, 0) ELSE NULL END AS ACTIVE_CUSTOMERS,
    CASE WHEN DATE_ADD(s.COHORT_MONTH, INTERVAL p.COHORT_PERIOD MONTH) <= o.LAST_MONTH
        THEN 1.0 * COALESCE(c.ACTIVE_CUSTOMERS, 0) / s.COHORT_SIZE ELSE NULL END AS RETENTION_RATE,
    1.0 * c.ACTIVE_CUSTOMERS / s.COHORT_SIZE AS DISPLAY_RETENTION_RATE
FROM cohort_sizes s
CROSS JOIN vw_dim_cohort_period p
CROSS JOIN observation o
LEFT JOIN monthly_counts c
    ON c.COHORT_MONTH = s.COHORT_MONTH
    AND c.COHORT_PERIOD = p.COHORT_PERIOD;
