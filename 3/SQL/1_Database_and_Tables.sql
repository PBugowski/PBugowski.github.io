-- 1. Creation of Database and Tables
-- -----------------------------------------------------------------------------------------------------------------
-- Creates the toys_in_mexico database and five tables for the source CSV files.
-- Run this script in a new database before the import and view scripts.
-- The scripts use MySQL 8.0 or later and follow their filename order.
--
-- products stores one catalog row per product, including its cost and price.
-- stores stores one row per store. sales stores one row per SALE_ID, with the
-- number of units sold for one product at one store on a given date.
-- inventory contains one stock snapshot per store and product. calendar
-- contains one row per date and preserves the supplied date coverage.
--
-- Monetary values use DECIMAL to retain two decimal places. Identifiers and
-- unit counts use INT. Dates are stored without time components.
-- Product and store identifiers connect the tables. Source completeness is
-- checked separately by the validation script rather than foreign keys.
--
-- The database and tables are deliberately created without dropping existing
-- objects. Run the import once into empty tables. Recreating the views does
-- not require importing the source data again.
-- -----------------------------------------------------------------------------------------------------------------

CREATE DATABASE toys_in_mexico
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE toys_in_mexico;


-- Product Catalog
-- -----------------------------------------------------------------------------------------------------------------
CREATE TABLE products (
    PRODUCT_ID INT PRIMARY KEY,                    -- PRIMARY KEY identifies each row and prevents duplicate identifiers.
    PRODUCT_NAME VARCHAR(255),
    PRODUCT_CATEGORY VARCHAR(255),
    PRODUCT_COST DECIMAL(10,2),
    PRODUCT_PRICE DECIMAL(10,2)
);


-- Store Directory
-- -----------------------------------------------------------------------------------------------------------------
CREATE TABLE stores (
    STORE_ID INT PRIMARY KEY,
    STORE_NAME VARCHAR(255),
    STORE_CITY VARCHAR(255),
    STORE_LOCATION VARCHAR(255),
    STORE_OPEN_DATE DATE
);


-- Sales Transactions
-- -----------------------------------------------------------------------------------------------------------------
CREATE TABLE sales (
    SALE_ID INT PRIMARY KEY,
    D_DATE DATE,
    STORE_ID INT,
    PRODUCT_ID INT,
    UNITS INT,
    INDEX idx_sales_product_store_date (PRODUCT_ID, STORE_ID, D_DATE)  -- Supports product/store grouping and distinct sales-date counts.
);


-- Inventory Snapshot
-- -----------------------------------------------------------------------------------------------------------------
CREATE TABLE inventory (
    STORE_ID INT,
    PRODUCT_ID INT,
    STOCK_ON_HAND INT,
    PRIMARY KEY (STORE_ID, PRODUCT_ID)              -- The combination identifies one inventory record for a product at a store.
);


-- Source Calendar
-- -----------------------------------------------------------------------------------------------------------------
CREATE TABLE calendar (
    D_DATE DATE PRIMARY KEY
);
