-- 1. Creation of Database and Tables with Appropriate Data Types
-- -----------------------------------------------------------------------------------------------------------------
-- Creates the TOYS_IN_MEXICO database and five tables for the source CSV files.
-- The tables store:
--   - products: one catalog row per product, with its category, cost and price,
--   - stores: one row per store, with its city, location type and opening date,
--   - sales: one record per SALE_ID, with units sold for a product, store and date,
--   - inventory: one stock snapshot per store and product,
--   - calendar: one row per date in the supplied calendar.
--
-- DECIMAL(10,2) stores costs and prices with two decimal places. INT is used
-- for identifiers and unit counts. DATE stores calendar dates without time
-- components, while VARCHAR stores names and category labels.
--
-- Product, store, sales and calendar rows have individual primary keys.
-- Inventory uses the combination of STORE_ID and PRODUCT_ID. The sales
-- index follows product, store and date to support analysis at that level.
-- References between tables are checked by the validation script rather
-- than enforced through foreign keys.
--
-- The scripts use MySQL 8.0 syntax, including common table expressions.
-- Execute them in the following order:
--   1. Database and Tables
--   2. Import of Data
--   3.1. Dimension Views
--   3.2. Summary Views
--   3.3. Sales Views
--   3.4. Inventory Views
--   4. Data Validation
--
-- This script initializes a new database without dropping existing objects.
-- Each subsequent script selects toys_in_mexico explicitly. Import the source
-- files once into empty tables; recreating views does not require reimporting.
-- -----------------------------------------------------------------------------------------------------------------


-- Database Setup
-- -----------------------------------------------------------------------------------------------------------------
CREATE DATABASE toys_in_mexico                                                       -- Creates the database used by the sales and inventory analysis.
CHARACTER SET utf8mb4                                                                -- Sets UTF-8 character encoding.
COLLATE utf8mb4_unicode_ci;                                                          -- Defines case-insensitive Unicode text comparison and sorting.


USE TOYS_IN_MEXICO;                                                                  -- Selects the active database.


-- Product Catalog
-- -----------------------------------------------------------------------------------------------------------------
CREATE TABLE products (
    PRODUCT_ID INT PRIMARY KEY,                                                      -- PRIMARY KEY identifies each row and prevents duplicate or missing identifiers.
    PRODUCT_NAME VARCHAR(255),
    PRODUCT_CATEGORY VARCHAR(255),
    PRODUCT_COST DECIMAL(10,2),                                                      -- Stores monetary amounts with two decimal places.
    PRODUCT_PRICE DECIMAL(10,2)
);


-- Store Directory
-- -----------------------------------------------------------------------------------------------------------------
CREATE TABLE stores (
    STORE_ID INT PRIMARY KEY,
    STORE_NAME VARCHAR(255),
    STORE_CITY VARCHAR(255),
    STORE_LOCATION VARCHAR(255),
    STORE_OPEN_DATE DATE                                                             -- Stores the calendar date without a time component.
);


-- Sales Records
-- -----------------------------------------------------------------------------------------------------------------
CREATE TABLE sales (
    SALE_ID INT PRIMARY KEY,
    D_DATE DATE,
    STORE_ID INT,
    PRODUCT_ID INT,
    UNITS INT,
    INDEX idx_sales_product_store_date (PRODUCT_ID, STORE_ID, D_DATE)                -- Creates an index ordered by product, store and date to support access using these fields.
);


-- Inventory Snapshot
-- -----------------------------------------------------------------------------------------------------------------
CREATE TABLE inventory (
    STORE_ID INT,
    PRODUCT_ID INT,
    STOCK_ON_HAND INT,
    PRIMARY KEY (STORE_ID, PRODUCT_ID)                                               -- The two-column key makes each store/product combination unique.
);


-- Source Calendar
-- -----------------------------------------------------------------------------------------------------------------
CREATE TABLE calendar (
    D_DATE DATE PRIMARY KEY
);
