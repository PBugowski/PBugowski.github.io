-- 4.2. Creation of Dimension Views
-- -----------------------------------------------------------------------------------------------------------------
-- Creates date, price-category, subscription-type and cohort dimensions.
-- Each dimension key is unique and belongs on the 1 side of a single-direction PBI relation.
-- The calendar now includes all days between the first and last transaction, including
-- days without purchases. English month names are explicit and independent of server locale.
-- A 0-99,999 number generator avoids the default recursive CTE depth limit.
-- No row order is promised by a view; configure sort columns explicitly in Power BI.
-- -----------------------------------------------------------------------------------------------------------------

USE KDS_Transactions;

-- Helper only: do not import into Power BI.
CREATE OR REPLACE VIEW vw_numbers AS
WITH digits AS (
    SELECT 0 AS N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
    UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9
)
SELECT a.N + 10 * b.N + 100 * c.N + 1000 * d.N + 10000 * e.N AS N
FROM digits a CROSS JOIN digits b CROSS JOIN digits c CROSS JOIN digits d CROSS JOIN digits e;

CREATE OR REPLACE VIEW vw_dim_transaction_date_2 AS
SELECT
    TRANSACTION_DATE,
    YEAR(TRANSACTION_DATE) AS `YEAR`,
    MONTH(TRANSACTION_DATE) AS MONTH_NUMBER,
    ELT(MONTH(TRANSACTION_DATE), 'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December') AS MONTH_NAME,
    CAST(DATE_FORMAT(TRANSACTION_DATE, '%Y-%m-01') AS DATE) AS MONTH_START,
    DATE_FORMAT(TRANSACTION_DATE, '%Y-%m') AS YEAR_MONTH,
    YEAR(TRANSACTION_DATE) * 100 + MONTH(TRANSACTION_DATE) AS YEAR_MONTH_SORT
FROM (
    SELECT DATE_ADD(b.FIRST_DATE, INTERVAL n.N DAY) AS TRANSACTION_DATE
    FROM vw_numbers n
    CROSS JOIN (
        SELECT MIN(TRANSACTION_DATE) AS FIRST_DATE, MAX(TRANSACTION_DATE) AS LAST_DATE
        FROM transactions
    ) b
    WHERE n.N <= DATEDIFF(b.LAST_DATE, b.FIRST_DATE)
) calendar_days;

-- Preserves the separate one-column date dimension visible in the original screenshot.
-- The recommended reconstructed model uses only date_2 as its active report calendar.
CREATE OR REPLACE VIEW vw_dim_transaction_date AS
SELECT TRANSACTION_DATE
FROM vw_dim_transaction_date_2;

CREATE OR REPLACE VIEW vw_dim_date_year AS
SELECT DISTINCT `YEAR` AS TRANSACTION_YEAR
FROM vw_dim_transaction_date_2;

CREATE OR REPLACE VIEW vw_dim_date_month AS
SELECT DISTINCT
    MONTH_NUMBER AS TRANSACTION_MONTH_NUMBER,
    MONTH_NAME AS TRANSACTION_MONTH_NAME
FROM vw_dim_transaction_date_2;

CREATE OR REPLACE VIEW vw_dim_promotion AS
SELECT 'NO' AS PROMOTION_PRICE, 'REGULAR PRICE' AS PRICE_TYPE
UNION ALL
SELECT 'YES', 'DISCOUNTED PRICE';

CREATE OR REPLACE VIEW vw_dim_transaction_type AS
SELECT 'MONTHLY' AS TRANSACTION_TYPE, 1 AS TRANSACTION_TYPE_ORDER
UNION ALL SELECT 'SEMI-ANNUAL', 2
UNION ALL SELECT 'ANNUAL', 3;

-- Dimension alias in Power BI: FIRST_PURCHASE_DATE.
-- Key: the actual first observed purchase date, not the first day of a calendar month.
-- Use YEAR_MONTH to display monthly cohorts; it groups multiple dates into the same cohort.
CREATE OR REPLACE VIEW vw_dim_first_purchase_date AS
SELECT DISTINCT
    FIRST_PURCHASE_DATE,
    DATE_FORMAT(FIRST_PURCHASE_DATE, '%Y-%m') AS YEAR_MONTH,
    YEAR(FIRST_PURCHASE_DATE) * 100 + MONTH(FIRST_PURCHASE_DATE) AS YEAR_MONTH_SORT
FROM vw_4_cohort_date;

-- Dimension alias in Power BI: COHORT_PERIOD. 0 is the first observed purchase month.
CREATE OR REPLACE VIEW vw_dim_cohort_period AS
SELECT n.N AS COHORT_PERIOD
FROM vw_numbers n
CROSS JOIN (
    SELECT
        (YEAR(MAX(TRANSACTION_DATE)) - YEAR(MIN(TRANSACTION_DATE))) * 12
        + MONTH(MAX(TRANSACTION_DATE)) - MONTH(MIN(TRANSACTION_DATE)) AS MAX_PERIOD
    FROM transactions
) b
WHERE n.N <= b.MAX_PERIOD;
