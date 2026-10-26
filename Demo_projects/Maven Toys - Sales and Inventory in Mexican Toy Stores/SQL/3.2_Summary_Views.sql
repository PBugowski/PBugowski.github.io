-- 3.2. Creation of Summary and Sales Detail Views
-- -----------------------------------------------------------------------------------------------------------------
-- Creates three views with different levels of detail:
--   - vw_kpi: one row per store and product category,
--   - vw_landing: one row per product, category, location type and month,
--   - vw_data: one row per sales record with descriptive attributes.
--
-- For vw_kpi, sales_by_store and inventory_by_store aggregate their sources
-- independently before joining on store and category. This prevents stock
-- from being repeated for each sales transaction. Sales groups are retained
-- when no inventory summary is found, with missing stock totals shown as zero.
-- Groups present only in inventory do not enter this view.
--
-- REVENUE is units sold multiplied by the catalog selling price. PROFIT is
-- units sold multiplied by the difference between catalog price and cost.
-- These amounts use the supplied product catalog rather than historical
-- transaction prices and do not include store operating expenses.
-- INVENTORY_VALUE values stock at selling price, not acquisition cost.
-- These definitions also apply to the later analytical views.
--
-- vw_landing combines the same month across years. For the supplied data,
-- January to September include 2022 and 2023, while October to December
-- include 2022 only. The separate monthly sales views retain a YEAR column
-- for queries that need to keep those periods apart.
--
-- vw_data attaches product and store names, category and location type to
-- SALE_ID. Distinct product and store names can be counted from this detail.
-- No ranking or row limit is applied to these views.

-- Run this script after the source import.
-- -----------------------------------------------------------------------------------------------------------------


-- Active database choice
-- -----------------------------------------------------------------------------------------------------------------
USE TOYS_IN_MEXICO;                                                          		 -- Selects the active database for subsequent statements.


-- Store and Category Totals
-- -----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_kpi AS
WITH sales_by_store AS (                                                             -- WITH defines named intermediate query results used by the view.
    SELECT
        st.STORE_ID,
        st.STORE_NAME,
        st.STORE_CITY,
        st.STORE_LOCATION,
        p.PRODUCT_CATEGORY,
        SUM(s.UNITS * p.PRODUCT_PRICE) AS REVENUE,                                   -- SUM adds the row-level amounts within each store/category group.
        SUM(s.UNITS * (p.PRODUCT_PRICE - p.PRODUCT_COST)) AS PROFIT,
        SUM(s.UNITS) AS UNITS_SOLD
    FROM sales s
    JOIN stores st                                                                   -- JOIN attaches matching store records using the identifiers in the ON condition.
        ON s.STORE_ID = st.STORE_ID
    JOIN products p
        ON s.PRODUCT_ID = p.PRODUCT_ID
    GROUP BY                                                                         -- Produces one summary for each distinct combination of the listed grouping attributes.
        st.STORE_ID,
        st.STORE_NAME,
        st.STORE_CITY,
        st.STORE_LOCATION,
        p.PRODUCT_CATEGORY
),
inventory_by_store AS (
    SELECT
        i.STORE_ID,
        p.PRODUCT_CATEGORY,
        SUM(i.STOCK_ON_HAND) AS INVENTORY,
        SUM(i.STOCK_ON_HAND * p.PRODUCT_PRICE) AS INVENTORY_VALUE
    FROM inventory i
    JOIN products p
        ON i.PRODUCT_ID = p.PRODUCT_ID
    GROUP BY
        i.STORE_ID,
        p.PRODUCT_CATEGORY
)
SELECT
    s.STORE_ID,
    s.STORE_NAME,
    s.STORE_CITY,
    s.STORE_LOCATION,
    s.PRODUCT_CATEGORY,
    s.REVENUE,
    s.PROFIT,
    s.UNITS_SOLD,
    COALESCE(i.INVENTORY, 0) AS INVENTORY,                                           -- COALESCE returns the first non-NULL argument, using zero when no inventory total is available.
    COALESCE(i.INVENTORY_VALUE, 0) AS INVENTORY_VALUE
FROM sales_by_store s
LEFT JOIN inventory_by_store i                                                       -- Retains every sales group even when no matching inventory group exists.
    ON s.STORE_ID = i.STORE_ID
    AND s.PRODUCT_CATEGORY = i.PRODUCT_CATEGORY;


-- Monthly Totals Across Years
-- -----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_landing AS
SELECT
    p.PRODUCT_CATEGORY,
    p.PRODUCT_NAME,
    st.STORE_LOCATION,
    MONTHNAME(s.D_DATE) AS MONTH_NAME,                                               -- MONTHNAME returns the month name in the current session language.
    MONTH(s.D_DATE) AS MONTH_NUMBER,                                                 -- MONTH extracts the month number from 1 to 12 for chronological ordering.
    SUM(s.UNITS * p.PRODUCT_PRICE) AS REVENUE,
    SUM(s.UNITS * (p.PRODUCT_PRICE - p.PRODUCT_COST)) AS PROFIT
FROM sales s
JOIN products p
    ON s.PRODUCT_ID = p.PRODUCT_ID
JOIN stores st
    ON s.STORE_ID = st.STORE_ID
GROUP BY
    p.PRODUCT_CATEGORY,
    p.PRODUCT_NAME,
    st.STORE_LOCATION,
    MONTH(s.D_DATE),
    MONTHNAME(s.D_DATE);


-- Sales Record Detail
-- -----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_data AS
SELECT
    p.PRODUCT_CATEGORY,
    st.STORE_LOCATION,
    st.STORE_NAME,
    p.PRODUCT_NAME,
    s.SALE_ID                                                                        -- Keeps the source sales identifier so detail rows can be counted independently of summaries.
FROM sales s
JOIN products p
    ON s.PRODUCT_ID = p.PRODUCT_ID
JOIN stores st
    ON s.STORE_ID = st.STORE_ID;
