-- 1. Creation of Database and Tables with Appropriate Data Types ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


CREATE DATABASE KDS_Transactions
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE KDS_Transactions;

CREATE TABLE transactions(
TRANSACTION_ID INT PRIMARY KEY AUTO_INCREMENT,
TRANSACTION_DATE DATE,
CLIENT_ID INT,
TRANSACTION_VALUE DECIMAL (10,2),
TRANSACTION_TYPE VARCHAR(20),
EXPECTED_RENEWAL_DATE DATE,
PROMOTION_PRICE VARCHAR(3),
TRANSACTION_YEAR INT,
TRANSACTION_MONTH_NUMBER INT
);


-- 2. Population of tables from CSV files ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 'C:/Users/pbugo/Desktop/Portfolio Projects/Project 08 - [PBI] - KajoDataSpace transactions for 2023-2026/KDS.csv'
INTO TABLE transactions
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@TRANSACTION_DATE, @CLIENT_ID, @TRANSACTION_VALUE)
SET
    TRANSACTION_DATE = STR_TO_DATE(TRIM(@TRANSACTION_DATE), '%m/%d/%Y'),
    CLIENT_ID = NULLIF(@CLIENT_ID, ''),
    TRANSACTION_VALUE = NULLIF(@TRANSACTION_VALUE, '');


-- 3. Modification of tables for analysis purposes -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 3.01. Addition of TRANSACTION_TYPE column representing the type of subscribtion
UPDATE transactions
SET TRANSACTION_TYPE =
    CASE
        WHEN TRANSACTION_VALUE < 260
            THEN 'MONTHLY'
        WHEN TRANSACTION_VALUE > 260
             AND TRANSACTION_VALUE < 600
            THEN 'SEMI-ANNUAL'
        WHEN TRANSACTION_VALUE > 600
            THEN 'ANNUAL'
    END;

-- 3.02. Addition of EXPECTED_RENEWAL_DATE column representing the date when client is expected to repurchase the subscribtion
UPDATE transactions
SET EXPECTED_RENEWAL_DATE =
    CASE
        WHEN TRANSACTION_TYPE = 'MONTHLY'
            THEN DATE_ADD(TRANSACTION_DATE, INTERVAL 1 MONTH)
        WHEN TRANSACTION_TYPE = 'SEMI-ANNUAL'
            THEN DATE_ADD(TRANSACTION_DATE, INTERVAL 6 MONTH)
        WHEN TRANSACTION_TYPE = 'ANNUAL'
            THEN DATE_ADD(TRANSACTION_DATE, INTERVAL 12 MONTH)
        ELSE NULL
    END;

-- 3.03. Manipulation of single extreme value record
UPDATE transactions
SET TRANSACTION_VALUE = 99
WHERE TRANSACTION_ID = 299;

-- 3.04. Addition of PROMOTION_PRICE column representing wheter transaction got fulfilled on standard or discounted price
UPDATE transactions
SET PROMOTION_PRICE =
    CASE
        -- Do 10.09.2024
        WHEN TRANSACTION_DATE < '2024-09-10'
             AND TRANSACTION_VALUE IN (99, 495, 990)
            THEN 'NO'
        -- Od 10.09.2024 do 12.09.2025
        WHEN TRANSACTION_DATE >= '2024-09-10'
             AND TRANSACTION_DATE < '2025-09-12'
             AND TRANSACTION_VALUE IN (199, 1799)
            THEN 'NO'
        -- Od 12.09.2025
        WHEN TRANSACTION_DATE >= '2025-09-12'
             AND TRANSACTION_VALUE IN (249, 1999)
            THEN 'NO'
        -- Wszystkie pozostałe przypadki
        ELSE 'YES'
    END;

-- 3.05. Addition of TRANSACTION_YEAR and TRANSACTION_MONTH_NUMBER columns for connecting the data with dimensional tables
UPDATE transactions
SET
    TRANSACTION_YEAR = YEAR(TRANSACTION_DATE),
    TRANSACTION_MONTH_NUMBER = MONTH(TRANSACTION_DATE);

SHOW WARNINGS;
SELECT * FROM transactions;


-- 4. Creating dimensional views for star schema ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- Dimensional table for filtering by subscribtion type
CREATE OR REPLACE VIEW vw_dim_transaction_type AS
SELECT DISTINCT TRANSACTION_TYPE
FROM transactions
WHERE TRANSACTION_TYPE IS NOT NULL
ORDER BY TRANSACTION_TYPE;

-- Dimensional table for filtering by year
CREATE OR REPLACE VIEW vw_dim_date_year AS
SELECT DISTINCT YEAR(TRANSACTION_DATE) AS TRANSACTION_YEAR
FROM transactions
WHERE TRANSACTION_DATE IS NOT NULL
ORDER BY TRANSACTION_YEAR;

-- Dimensional table for filtering by month
CREATE OR REPLACE VIEW vw_dim_date_month AS
SELECT DISTINCT
    MONTH(TRANSACTION_DATE) AS TRANSACTION_MONTH_NUMBER,
    MONTHNAME(TRANSACTION_DATE) AS TRANSACTION_MONTH_NAME
FROM transactions
WHERE TRANSACTION_DATE IS NOT NULL
ORDER BY TRANSACTION_MONTH_NUMBER;

-- Dimensional table for filtering by type of price: standard and discounted
CREATE OR REPLACE VIEW vw_dim_promotion AS
SELECT DISTINCT PROMOTION_PRICE
FROM transactions
WHERE PROMOTION_PRICE IS NOT NULL;


-- 5. Creating data views for pbi visualizations ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE VIEW vw_5_data_config_2 AS
WITH last_date AS (
    SELECT MAX(TRANSACTION_DATE) AS MAX_DATE
    FROM transactions
),

ranked_prices AS (
    SELECT
        TRANSACTION_VALUE,
        ROW_NUMBER() OVER (
            ORDER BY TRANSACTION_VALUE
        ) AS RN,
        COUNT(*) OVER () AS TOTAL_ROWS
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
        SELECT
            AVG(TRANSACTION_VALUE)
        FROM ranked_prices
        WHERE RN IN (
            FLOOR((TOTAL_ROWS + 1) / 2),
            CEIL((TOTAL_ROWS + 1) / 2)
        )
    ) AS MEDIAN_PRICE
FROM transactions t
CROSS JOIN last_date d;

CREATE OR REPLACE VIEW vw_dim_transaction_date_2 AS
SELECT DISTINCT
    TRANSACTION_DATE,
    YEAR(TRANSACTION_DATE) AS YEAR,
    MONTH(TRANSACTION_DATE) AS MONTH_NUMBER,
    MONTHNAME(TRANSACTION_DATE) AS MONTH_NAME

FROM transactions

ORDER BY
    TRANSACTION_DATE;

CREATE OR REPLACE VIEW vw_4_cohort_date AS
SELECT
    CLIENT_ID,
    MIN(TRANSACTION_DATE) AS FIRST_PURCHASE_DATE,
    MONTH(MIN(TRANSACTION_DATE)) AS `MONTH`,
    YEAR(MIN(TRANSACTION_DATE)) AS `YEAR`
FROM transactions
GROUP BY CLIENT_ID;