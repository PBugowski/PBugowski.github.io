-- 4. Data Validation and Reconciliation
-- -----------------------------------------------------------------------------------------------------------------
-- Runs nine read-only queries after the source import and view creation.
-- The checks cover:
--   - source row counts and the observed sales period,
--   - sales and inventory totals calculated from the base tables,
--   - missing product, store and calendar references,
--   - missing or invalid quantities, costs and prices,
--   - reconciliation of summary and individual analytical views,
--   - sales record counts and distinct products, stores and categories,
--   - average group margins and product stock coverage.
--
-- Reference row counts for the supplied CSV files are products 35, stores 50,
-- sales 829262, inventory 1593 and calendar 638. Sales cover 2022-01-01
-- through 2023-09-30. The expected totals are:
--   - 1090565 units sold,
--   - 14444572.35 revenue and 4014029.00 profit,
--   - 29742 units in stock and 410240.58 retail inventory value.
-- Missing-reference and invalid-value counts should be zero.
--
-- Expected average margin percentages are Art & Crafts 29.68, Electronics
-- 34.25, Games 35.77, Sports & Outdoors 27.61 and Toys 27.98. These average
-- the rounded ratios in vw_profit rather than weighting them by revenue.
-- The stock coverage query also reports how many inventory pairs have a
-- non-null coverage estimate, making the average's population explicit.
--
-- The queries display results for comparison; they do not automatically
-- raise an error when a value differs. Reference values describe the supplied
-- dataset and do not overwrite data or alter calculations. A different source
-- dataset can legitimately produce different totals. No table or view is
-- modified by this script.
-- -----------------------------------------------------------------------------------------------------------------


-- Active database choice
-- -----------------------------------------------------------------------------------------------------------------
USE TOYS_IN_MEXICO;                                                          		 -- Selects the active database for subsequent statements.


-- Source Row Counts
-- -----------------------------------------------------------------------------------------------------------------
SELECT 'products' AS SOURCE_TABLE, COUNT(*) AS ROW_COUNT FROM products
UNION ALL                                                                            -- Combines the separate check results without removing repeated rows.
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
    MIN(s.D_DATE) AS FIRST_SALE_DATE,                                                -- MIN returns the earliest non-NULL date in the sales records.
    MAX(s.D_DATE) AS LAST_SALE_DATE,                                                 -- MAX returns the latest non-NULL date in the sales records.
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
WHERE p.PRODUCT_ID IS NULL                                                           -- IS NULL identifies sales rows with no matching catalog product after the join.
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
FROM sales WHERE UNITS IS NULL OR UNITS <= 0                                         -- Flags missing quantities and quantities that are not positive.
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
    (SELECT SUM(UNITS_SOLD) FROM vw_volume),                                         -- A scalar subquery supplies one total from an individual view for comparison with vw_kpi.
    (SELECT SUM(REVENUE) FROM vw_revenue),
    (SELECT SUM(PROFIT) FROM vw_profit),
    (SELECT SUM(STOCK_ON_HAND) FROM vw_level),
    (SELECT SUM(INVENTORY_VALUE) FROM vw_value);


-- Sales Detail Counts
-- -----------------------------------------------------------------------------------------------------------------
SELECT
    COUNT(*) AS SALES_RECORDS,
    COUNT(DISTINCT PRODUCT_NAME) AS ACTIVE_PRODUCTS,
    COUNT(DISTINCT STORE_NAME) AS ACTIVE_STORES,
    COUNT(DISTINCT PRODUCT_CATEGORY) AS PRODUCT_CATEGORIES
FROM vw_data;


-- Monthly Summary Totals
-- -----------------------------------------------------------------------------------------------------------------
SELECT
    SUM(REVENUE) AS REVENUE,
    SUM(PROFIT) AS PROFIT
FROM vw_landing;


-- Average of Rounded Group Margins
-- -----------------------------------------------------------------------------------------------------------------
SELECT
    PRODUCT_CATEGORY,
    ROUND(AVG(PROFIT_MARGIN) * 100, 2) AS AVG_PROFIT_MARGIN_PERCENT                  -- AVG calculates the arithmetic mean of non-NULL margins; multiplying by 100 expresses it as a percentage.
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
ORDER BY AVG_DAYS_OF_INVENTORY DESC, PRODUCT_NAME;                                   -- ORDER BY sorts coverage in descending order (DESC), with product name ascending to resolve ties.
