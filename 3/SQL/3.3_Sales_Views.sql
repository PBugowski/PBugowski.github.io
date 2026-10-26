-- 3.3. Creation of Monthly Sales Views
-- -----------------------------------------------------------------------------------------------------------------
-- Creates three views for monthly sales analysis:
--   - vw_volume: units sold,
--   - vw_revenue: revenue,
--   - vw_profit: profit and profit margin.
--
-- Each row represents one product, category, store location type, year and
-- month. Stores sharing a location type are grouped together; these are not
-- individual store summaries. The calculations use the catalog prices and
-- costs defined in the summary script.
--
-- PROFIT_MARGIN divides group profit by group revenue and rounds the ratio
-- to two decimal places. A value of 0.30 represents 30%. Zero revenue leaves
-- the margin undefined as NULL rather than causing division by zero.
--
-- A later average of PROFIT_MARGIN gives equal weight to the returned rows
-- and uses values that have already been rounded. It is not equivalent to
-- dividing total profit by total revenue. Preserve the calculation order
-- when comparing category averages with the supplied reference values.
--
-- The YEAR column keeps identical months in different years separate.
-- Aggregating only by month number or name combines those years again.
-- All products remain available; any ranking is applied by a later query
-- after the required category and location filters have been selected.
--
-- Run this script after importing sales, products and stores.
-- -----------------------------------------------------------------------------------------------------------------


-- Active database choice
-- -----------------------------------------------------------------------------------------------------------------
USE TOYS_IN_MEXICO;                                                          		 -- Selects the active database for subsequent statements.


-- Monthly Units Sold
-- -----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_volume AS
SELECT
    p.PRODUCT_CATEGORY,
    p.PRODUCT_NAME,
    st.STORE_LOCATION,
    YEAR(s.D_DATE) AS YEAR,                                                          -- YEAR extracts the calendar year, keeping the same month in different years separate.
    MONTH(s.D_DATE) AS MONTH_NUMBER,
    MONTHNAME(s.D_DATE) AS MONTH_NAME,
    SUM(s.UNITS) AS UNITS_SOLD
FROM sales s
JOIN products p
    ON s.PRODUCT_ID = p.PRODUCT_ID
JOIN stores st
    ON s.STORE_ID = st.STORE_ID
GROUP BY
    p.PRODUCT_CATEGORY,
    p.PRODUCT_NAME,
    st.STORE_LOCATION,
    YEAR(s.D_DATE),
    MONTH(s.D_DATE),
    MONTHNAME(s.D_DATE);


-- Monthly Revenue
-- -----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_revenue AS
SELECT
    p.PRODUCT_CATEGORY,
    p.PRODUCT_NAME,
    st.STORE_LOCATION,
    YEAR(s.D_DATE) AS YEAR,
    MONTH(s.D_DATE) AS MONTH_NUMBER,
    MONTHNAME(s.D_DATE) AS MONTH_NAME,
    SUM(s.UNITS * p.PRODUCT_PRICE) AS REVENUE
FROM sales s
JOIN products p
    ON s.PRODUCT_ID = p.PRODUCT_ID
JOIN stores st
    ON s.STORE_ID = st.STORE_ID
GROUP BY
    p.PRODUCT_CATEGORY,
    p.PRODUCT_NAME,
    st.STORE_LOCATION,
    YEAR(s.D_DATE),
    MONTH(s.D_DATE),
    MONTHNAME(s.D_DATE);


-- Monthly Profit and Margin
-- -----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_profit AS
SELECT
    p.PRODUCT_CATEGORY,
    p.PRODUCT_NAME,
    st.STORE_LOCATION,
    YEAR(s.D_DATE) AS YEAR,
    MONTH(s.D_DATE) AS MONTH_NUMBER,
    MONTHNAME(s.D_DATE) AS MONTH_NAME,
    SUM(s.UNITS * (p.PRODUCT_PRICE - p.PRODUCT_COST)) AS PROFIT,
    ROUND(                                                                           -- ROUND keeps the specified number of decimal places in the group margin ratio.
        (
            SUM(s.UNITS * (p.PRODUCT_PRICE - p.PRODUCT_COST))
            / NULLIF(SUM(s.UNITS * p.PRODUCT_PRICE), 0)                              -- Zero group revenue leaves the margin undefined instead of dividing by zero.
        ),
        2
    ) AS PROFIT_MARGIN
FROM sales s
JOIN products p
    ON s.PRODUCT_ID = p.PRODUCT_ID
JOIN stores st
    ON s.STORE_ID = st.STORE_ID
GROUP BY
    p.PRODUCT_CATEGORY,
    p.PRODUCT_NAME,
    st.STORE_LOCATION,
    YEAR(s.D_DATE),
    MONTH(s.D_DATE),
    MONTHNAME(s.D_DATE);
