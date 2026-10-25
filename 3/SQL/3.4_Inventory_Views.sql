-- 3.4. Creation of Inventory Views
-- -----------------------------------------------------------------------------------------------------------------
-- Creates vw_level and vw_value from the inventory snapshot. Each source store/product pair
-- remains one output row. The existing column lists omit STORE_ID, so rows with the same
-- product and location type can belong to different stores. They must not be deduplicated.
--
-- vw_level retains stock on hand and estimates DAYS_OF_INVENTORY. For each store/product
-- pair, average daily units equal total units sold divided by the number of distinct dates
-- with sales. Days without sales are excluded. The calculation uses the complete available
-- sales history, not a recent period or every calendar day.
--
-- Calculations assume the default MySQL div_precision_increment of 4. Integer division using
-- / gives a decimal result; the grouped daily average is stored with four fractional digits
-- before the outer calculation. Keep the existing expression and numeric types, because
-- changing intermediate precision can change the final rounded coverage.
--
-- Stock is divided by that daily average and rounded to one decimal place. A zero stock value
-- produces zero days when sales history exists. No sales history, or a zero daily average,
-- produces NULL. Keep this distinction rather than replacing missing coverage with zero. An
-- average of DAYS_OF_INVENTORY averages these already rounded pair-level values and ignores
-- NULL. It is not a ratio of combined stock to combined demand.
--
-- vw_value multiplies each stock quantity by its catalog selling price. Sum INVENTORY_VALUE
-- to obtain the retail value of the recorded stock. Neither inventory view has a stock date
-- or replenishment history. Their calculations do not establish lost sales or forecast the
-- exact date a product will run out.
-- -----------------------------------------------------------------------------------------------------------------

USE toys_in_mexico;


-- Stock and Estimated Coverage
-- -----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_level AS
WITH sales_by_product AS (
    SELECT
        PRODUCT_ID,
        STORE_ID,
        SUM(UNITS) / COUNT(DISTINCT D_DATE) AS AVG_DAILY_UNITS_SOLD  -- Counts only distinct dates with recorded sales for this pair.
    FROM sales
    GROUP BY
        PRODUCT_ID,
        STORE_ID
)
SELECT
    p.PRODUCT_CATEGORY,
    p.PRODUCT_NAME,
    st.STORE_LOCATION,
    i.STOCK_ON_HAND,
    ROUND(
        i.STOCK_ON_HAND / NULLIF(s.AVG_DAILY_UNITS_SOLD, 0),
        1
    ) AS DAYS_OF_INVENTORY
FROM inventory i
JOIN products p
    ON i.PRODUCT_ID = p.PRODUCT_ID
JOIN stores st
    ON i.STORE_ID = st.STORE_ID
LEFT JOIN sales_by_product s
    ON i.PRODUCT_ID = s.PRODUCT_ID
    AND i.STORE_ID = s.STORE_ID;


-- Retail Inventory Value
-- -----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_value AS
SELECT
    p.PRODUCT_CATEGORY,
    p.PRODUCT_NAME,
    st.STORE_LOCATION,
    i.STOCK_ON_HAND * p.PRODUCT_PRICE AS INVENTORY_VALUE
FROM inventory i
JOIN products p
    ON i.PRODUCT_ID = p.PRODUCT_ID
JOIN stores st
    ON i.STORE_ID = st.STORE_ID;
