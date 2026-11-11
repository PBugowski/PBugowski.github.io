-- 3.1. Creation of Category and Location Dimension Views
-- -----------------------------------------------------------------------------------------------------------------
-- Creates two dimension views from the product catalog and store directory:
--   - vw_dim_category: product categories,
--   - vw_dim_location: store location types.
--
-- Each view returns unique values from one source attribute. In the supplied
-- data, the category view contains five rows and the location view contains
-- four rows. A location type can describe several stores in different cities;
-- it is not a store identifier or city name.
--
-- The dimensions use catalog values rather than sales activity. A category
-- or location does not need a sales record to appear in its corresponding
-- view. No condition excludes NULL, so a missing source value can produce
-- a NULL entry in the result.
--
-- Run this script after importing products and stores. The views read the
-- current source tables rather than storing separate copies of the values.
-- Queries requiring a specific row order should include ORDER BY.
-- -----------------------------------------------------------------------------------------------------------------


-- Active database choice
-- -----------------------------------------------------------------------------------------------------------------
USE TOYS_IN_MEXICO;                                                          		 -- Selects the active database for subsequent statements.


-- Product Category Dimension
-- -----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_dim_category AS                                            -- Creates the view or replaces its existing query definition.
SELECT DISTINCT PRODUCT_CATEGORY                                                     -- DISTINCT keeps one row for each different selected value.
FROM products;


-- Store Location Dimension
-- -----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_dim_location AS
SELECT DISTINCT STORE_LOCATION
FROM stores;
