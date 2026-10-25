-- 3.1. Creation of Dimension Views
-- -----------------------------------------------------------------------------------------------------------------
-- Creates the two lists used to group or filter the analytical views: product category and
-- store location type. Each view contains one row per distinct source value.
--
-- The views use the product catalog and store directory rather than transaction activity.
-- Their names and column names remain unchanged. Subsequent scripts recreate only the
-- analytical views associated with these dimensions.
-- -----------------------------------------------------------------------------------------------------------------

USE toys_in_mexico;


-- Product Categories
-- -----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_dim_category AS
SELECT DISTINCT PRODUCT_CATEGORY
FROM products;


-- Store Location Types
-- -----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_dim_location AS
SELECT DISTINCT STORE_LOCATION
FROM stores;
