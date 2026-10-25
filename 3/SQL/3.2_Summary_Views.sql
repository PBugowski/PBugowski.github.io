-- 3.2. Creation of Summary Views
-- -----------------------------------------------------------------------------------------------------------------
-- Creates vw_kpi, vw_landing and vw_data with their existing names and output columns.
--
-- vw_kpi contains one row per store and product category. Sales and inventory are aggregated
-- independently before joining at that level. Joining raw inventory directly to sales would
-- repeat stock values for every transaction. The sales summary is the starting point, so
-- inventory-only store/category groups do not enter this view. The inventory views retain all
-- recorded stock combinations.
--
-- REVENUE equals units multiplied by the catalog selling price. PROFIT equals units
-- multiplied by the difference between catalog price and cost. These are historical estimates
-- using the supplied catalog values, without transaction-specific prices or operating
-- expenses. INVENTORY_VALUE is the stock valued at selling price, not purchase cost. These
-- definitions apply to the remaining scripts.
--
-- vw_landing groups revenue and profit by category, product, location type and month number.
-- It deliberately combines the same month across years. January to September contain
-- observations from 2022 and 2023; October to December contain 2022 only. Use the YEAR field
-- in the monthly sales views when years must be separated.
--
-- vw_data retains one row per sale, with category, location, store and product names. Count
-- SALE_ID for sales records and count distinct names for active products and stores. No
-- ranking or row limit is applied to these views. Sort the final SELECT when an ordered
-- result is needed.
--
-- MONTHNAME follows the connection's lc_time_names setting. The session setting below selects
-- English names. Use the same setting for connections that later query views containing
-- MONTHNAME.
-- -----------------------------------------------------------------------------------------------------------------

USE toys_in_mexico;


SET SESSION lc_time_names = 'en_US';  -- Selects the language used by month names in this connection.


-- Store and Category Totals
-- -----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_kpi AS
WITH sales_by_store AS (                            -- WITH names intermediate results within this statement.
    SELECT
        st.STORE_ID,
        st.STORE_NAME,
        st.STORE_CITY,
        st.STORE_LOCATION,
        p.PRODUCT_CATEGORY,
        SUM(s.UNITS * p.PRODUCT_PRICE) AS REVENUE,
        SUM(s.UNITS * (p.PRODUCT_PRICE - p.PRODUCT_COST)) AS PROFIT,
        SUM(s.UNITS) AS UNITS_SOLD
    FROM sales s
    JOIN stores st                                 -- JOIN attaches the matching catalog and directory records.
        ON s.STORE_ID = st.STORE_ID
    JOIN products p
        ON s.PRODUCT_ID = p.PRODUCT_ID
    GROUP BY                                       -- Produces one sales summary per store and category.
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
    COALESCE(i.INVENTORY, 0) AS INVENTORY,           -- COALESCE returns zero when the joined inventory summary is missing.
    COALESCE(i.INVENTORY_VALUE, 0) AS INVENTORY_VALUE
FROM sales_by_store s
LEFT JOIN inventory_by_store i                     -- Retains every sales group, including groups without inventory records.
    ON s.STORE_ID = i.STORE_ID
    AND s.PRODUCT_CATEGORY = i.PRODUCT_CATEGORY;


-- Monthly Totals Across Years
-- -----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_landing AS
SELECT
    p.PRODUCT_CATEGORY,
    p.PRODUCT_NAME,
    st.STORE_LOCATION,
    MONTHNAME(s.D_DATE) AS MONTH_NAME,             -- Returns the month label; MONTH supplies its chronological sort number.
    MONTH(s.D_DATE) AS MONTH_NUMBER,
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
    s.SALE_ID
FROM sales s
JOIN products p
    ON s.PRODUCT_ID = p.PRODUCT_ID
JOIN stores st
    ON s.STORE_ID = st.STORE_ID;
