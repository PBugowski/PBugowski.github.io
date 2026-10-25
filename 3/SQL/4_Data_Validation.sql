-- 5. Data Validation and Reconciliation
-- -----------------------------------------------------------------------------------------------------------------
-- Runs read-only checks after importing the source files and creating the views. The queries
-- compare independent base-table totals with the analytical views, check missing references
-- and quantities, and expose the aggregation used for margins and stock coverage.
--
-- For the supplied files, expected row counts are: products 35, stores 50, sales 829262,
-- inventory 1593 and calendar 638. Sales cover 2022-01-01 through 2023-09-30. The five main
-- totals are 1090565 units sold, 14444572.35 revenue, 4014029.00 profit, 29742 units in stock
-- and 410240.58 retail inventory value. Missing-reference and invalid-quantity counts should
-- be zero.
--
-- Expected average margin percentages, in category order, are Art & Crafts 29.68, Electronics
-- 34.25, Games 35.77, Sports & Outdoors 27.61 and Toys 27.98. These are averages of the
-- rounded ratios returned by vw_profit, not weighted overall margins.
--
-- These control values describe the supplied dataset. They are comparison references, not
-- constants used to alter any calculation. New source files can legitimately produce
-- different totals. This script does not modify source data or remove records.
-- -----------------------------------------------------------------------------------------------------------------

USE toys_in_mexico;


-- Source Row Counts
-- -----------------------------------------------------------------------------------------------------------------
SELECT 'products' AS SOURCE_TABLE, COUNT(*) AS ROW_COUNT FROM products
UNION ALL
SELECT 'stores', COUNT(*) FROM stores
UNION ALL
SELECT 'sales', COUNT(*) FROM sales
UNION ALL
SELECT 'inventory', COUNT(*) FROM inventory
UNION ALL
SELECT 'calendar', COUNT(*) FROM calendar;


-- Sales Period and Independent Totals
-- -----------------------------------------------------------------------------------------------------------------
SELECT
    MIN(s.D_DATE) AS FIRST_SALE_DATE,
    MAX(s.D_DATE) AS LAST_SALE_DATE,
    COUNT(*) AS SALES_RECORDS,
    SUM(s.UNITS) AS UNITS_SOLD,
    SUM(s.UNITS * p.PRODUCT_PRICE) AS REVENUE,
    SUM(s.UNITS * (p.PRODUCT_PRICE - p.PRODUCT_COST)) AS PROFIT
FROM sales s
JOIN products p
    ON s.PRODUCT_ID = p.PRODUCT_ID;

SELECT
    SUM(i.STOCK_ON_HAND) AS INVENTORY,
    SUM(i.STOCK_ON_HAND * p.PRODUCT_PRICE) AS INVENTORY_VALUE
FROM inventory i
JOIN products p
    ON i.PRODUCT_ID = p.PRODUCT_ID;


-- Missing References and Invalid Quantities
-- -----------------------------------------------------------------------------------------------------------------
SELECT 'sales: unknown product' AS CHECK_NAME, COUNT(*) AS ISSUE_COUNT
FROM sales s LEFT JOIN products p ON s.PRODUCT_ID = p.PRODUCT_ID
WHERE p.PRODUCT_ID IS NULL
UNION ALL
SELECT 'sales: unknown store', COUNT(*)
FROM sales s LEFT JOIN stores st ON s.STORE_ID = st.STORE_ID
WHERE st.STORE_ID IS NULL
UNION ALL
SELECT 'sales: date missing from calendar', COUNT(*)
FROM sales s LEFT JOIN calendar c ON s.D_DATE = c.D_DATE
WHERE c.D_DATE IS NULL
UNION ALL
SELECT 'inventory: unknown product', COUNT(*)
FROM inventory i LEFT JOIN products p ON i.PRODUCT_ID = p.PRODUCT_ID
WHERE p.PRODUCT_ID IS NULL
UNION ALL
SELECT 'inventory: unknown store', COUNT(*)
FROM inventory i LEFT JOIN stores st ON i.STORE_ID = st.STORE_ID
WHERE st.STORE_ID IS NULL
UNION ALL
SELECT 'sales: missing or nonpositive units', COUNT(*)
FROM sales WHERE UNITS IS NULL OR UNITS <= 0
UNION ALL
SELECT 'inventory: missing or negative stock', COUNT(*)
FROM inventory WHERE STOCK_ON_HAND IS NULL OR STOCK_ON_HAND < 0
UNION ALL
SELECT 'products: missing or negative cost/price', COUNT(*)
FROM products
WHERE PRODUCT_COST IS NULL OR PRODUCT_PRICE IS NULL OR PRODUCT_COST < 0 OR PRODUCT_PRICE < 0;


-- Reconciliation of Core Views
-- -----------------------------------------------------------------------------------------------------------------
SELECT 'vw_kpi' AS SOURCE_VIEW,
    SUM(UNITS_SOLD) AS UNITS_SOLD, SUM(REVENUE) AS REVENUE, SUM(PROFIT) AS PROFIT,
    SUM(INVENTORY) AS INVENTORY, SUM(INVENTORY_VALUE) AS INVENTORY_VALUE
FROM vw_kpi
UNION ALL
SELECT 'individual views',
    (SELECT SUM(UNITS_SOLD) FROM vw_volume),
    (SELECT SUM(REVENUE) FROM vw_revenue),
    (SELECT SUM(PROFIT) FROM vw_profit),
    (SELECT SUM(STOCK_ON_HAND) FROM vw_level),
    (SELECT SUM(INVENTORY_VALUE) FROM vw_value);

SELECT
    COUNT(*) AS SALES_RECORDS,
    COUNT(DISTINCT PRODUCT_NAME) AS ACTIVE_PRODUCTS,
    COUNT(DISTINCT STORE_NAME) AS ACTIVE_STORES,
    COUNT(DISTINCT PRODUCT_CATEGORY) AS PRODUCT_CATEGORIES
FROM vw_data;

SELECT
    SUM(REVENUE) AS REVENUE,
    SUM(PROFIT) AS PROFIT
FROM vw_landing;


-- Average of Rounded Group Margins
-- -----------------------------------------------------------------------------------------------------------------
SELECT
    PRODUCT_CATEGORY,
    ROUND(AVG(PROFIT_MARGIN) * 100, 2) AS AVG_PROFIT_MARGIN_PERCENT
FROM vw_profit
GROUP BY PRODUCT_CATEGORY
ORDER BY PRODUCT_CATEGORY;


-- Product Stock Coverage
-- -----------------------------------------------------------------------------------------------------------------
SELECT
    PRODUCT_NAME,
    SUM(STOCK_ON_HAND) AS STOCK_ON_HAND,
    COUNT(DAYS_OF_INVENTORY) AS PAIRS_WITH_COVERAGE,
    AVG(DAYS_OF_INVENTORY) AS AVG_DAYS_OF_INVENTORY
FROM vw_level
GROUP BY PRODUCT_NAME
ORDER BY AVG_DAYS_OF_INVENTORY DESC, PRODUCT_NAME;
