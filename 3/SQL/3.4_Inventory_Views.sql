-- 3.4. Creation of Inventory and Stock Coverage Views
-- -----------------------------------------------------------------------------------------------------------------
-- Creates two views from the inventory snapshot:
--   - vw_level: stock on hand and estimated days of inventory,
--   - vw_value: retail inventory value.
--
-- Each source store/product pair remains one output row. STORE_ID is not
-- included in the output, so rows with the same product and location type
-- can belong to different stores. They must not be deduplicated.
--
-- sales_by_product calculates average units sold per sales day for each
-- product and store. Its denominator counts only dates with recorded sales
-- for that pair. The complete sales history is used, rather than a recent
-- period or every calendar day.
--
-- DAYS_OF_INVENTORY divides stock by that daily average and rounds the
-- result to one decimal place. Zero stock produces zero coverage when sales
-- history exists. Missing history or a zero daily average produces NULL.
-- A later average ignores NULL and uses the already rounded pair-level
-- values; it is not combined stock divided by a combined sales rate.
--
-- The calculations assume MySQL div_precision_increment = 4. The grouped
-- daily average has four fractional digits before the outer division.
-- Changing intermediate precision or numeric types can change the final
-- rounded coverage, even when the underlying quantities are unchanged.
--
-- vw_value multiplies each stock quantity by its catalog selling price.
-- Neither view contains a stock date or replenishment history. The coverage
-- indicator does not establish lost sales or predict the exact date a
-- product will run out. Run this script after importing all four source
-- tables used by the views: inventory, sales, products and stores.
-- -----------------------------------------------------------------------------------------------------------------


-- Active database choice
-- -----------------------------------------------------------------------------------------------------------------
USE TOYS_IN_MEXICO;                                                          		 -- Selects the active database for subsequent statements.


-- Stock and Estimated Coverage
-- -----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_level AS
WITH sales_by_product AS (
    SELECT
        PRODUCT_ID,
        STORE_ID,
        SUM(UNITS) / COUNT(DISTINCT D_DATE) AS AVG_DAILY_UNITS_SOLD                  -- COUNT counts non-NULL values, or all rows with *; here it counts sales days per product/store pair.
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
        i.STOCK_ON_HAND / NULLIF(s.AVG_DAILY_UNITS_SOLD, 0),                         -- Compares the recorded stock with the historical daily sales average for the same pair.
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
    i.STOCK_ON_HAND * p.PRODUCT_PRICE AS INVENTORY_VALUE                             -- Values the snapshot at the catalog selling price rather than product cost.
FROM inventory i
JOIN products p
    ON i.PRODUCT_ID = p.PRODUCT_ID
JOIN stores st
    ON i.STORE_ID = st.STORE_ID;
