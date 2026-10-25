-- 3.3. Creation of Monthly Sales Views
-- -----------------------------------------------------------------------------------------------------------------
-- Creates vw_volume, vw_revenue and vw_profit. Each row represents one product, category,
-- store location type, year and month. Store locations are grouped across all stores of that
-- type. The views retain all products, allowing rankings to be calculated after selecting the
-- required categories and locations.
--
-- vw_volume contains units sold, vw_revenue contains revenue, and vw_profit contains profit
-- and PROFIT_MARGIN. Revenue and profit use the catalog assumptions defined in the summary
-- script.
--
-- PROFIT_MARGIN is calculated for each grouped row as profit divided by revenue, then rounded
-- to two decimal places as a ratio. A value of 0.30 represents 30%. This rounding is retained
-- before any subsequent averaging. AVG(PROFIT_MARGIN) gives equal weight to the returned
-- product/location/year/month rows. It is not the same calculation as SUM(PROFIT) /
-- SUM(REVENUE), which weights results by revenue.
--
-- YEAR keeps the source years separate. Grouping only by MONTH_NUMBER or MONTH_NAME in a
-- later query combines those years. The same English month-name session setting is required
-- as in the summary script.
-- -----------------------------------------------------------------------------------------------------------------

USE toys_in_mexico;


-- Monthly Units Sold
-- -----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_volume AS
SELECT
    p.PRODUCT_CATEGORY,
    p.PRODUCT_NAME,
    st.STORE_LOCATION,
    YEAR(s.D_DATE) AS YEAR,                    -- Extracts the calendar year so identical months remain separate.
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
    ROUND(
        (
            SUM(s.UNITS * (p.PRODUCT_PRICE - p.PRODUCT_COST))
            / NULLIF(SUM(s.UNITS * p.PRODUCT_PRICE), 0)  -- A zero denominator becomes NULL, avoiding division by zero.
        ),
        2
    ) AS PROFIT_MARGIN                        -- ROUND retains the original two-decimal ratio before later averaging.
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
