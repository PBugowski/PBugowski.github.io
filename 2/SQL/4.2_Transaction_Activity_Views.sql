-- 4.2. Creation of Transaction and Customer Activity Views
-- -----------------------------------------------------------------------------------------------------------------
-- Creates three views for revenue and purchasing activity analysis.
--
-- vw_1 contains one row per transaction date, subscription type and price
-- category. NUMBER_OF_TRANSACTIONS stores the transaction count, while
-- TOTAL_REVENUE stores the sum of transaction amounts within that group.
-- All subscription types and price categories are retained.
--
-- vw_1_active_users contains distinct customer, date, subscription type and
-- price category combinations. It preserves customer identifiers for queries
-- that need to count customers across a selected period.
--
-- vw_2 uses the same grouping as vw_1 and adds ACTIVE_USERS, the number of
-- distinct purchasing customers within each date, type and price group.
-- This measures purchasing activity within the group, not subscription
-- validity or expected renewal status.
-- -----------------------------------------------------------------------------------------------------------------

USE KDS_Transactions;


-- Daily Revenue and Transaction Counts
-- -----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_1 AS
SELECT
    TRANSACTION_DATE,
    TRANSACTION_TYPE,
    PROMOTION_PRICE,
    COUNT(*) AS NUMBER_OF_TRANSACTIONS,                                               -- Counts all transaction rows within the group.
    SUM(TRANSACTION_VALUE) AS TOTAL_REVENUE                                           -- Adds the transaction amounts within the group.
FROM transactions
GROUP BY                                                                              -- Produces a separate summary for each date, subscription type and price category.
    TRANSACTION_DATE,
    TRANSACTION_TYPE,
    PROMOTION_PRICE;


-- Customer Activity Detail
-- -----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_1_active_users AS
SELECT DISTINCT
    CLIENT_ID,
    TRANSACTION_DATE,
    TRANSACTION_TYPE,
    PROMOTION_PRICE
FROM transactions;


-- Daily Customer Activity Summary
-- -----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_2 AS
SELECT
    TRANSACTION_DATE,
    TRANSACTION_TYPE,
    PROMOTION_PRICE,
    COUNT(DISTINCT CLIENT_ID) AS ACTIVE_USERS,                                        -- Counts each customer once within the current group.
    COUNT(*) AS NUMBER_OF_TRANSACTIONS,
    SUM(TRANSACTION_VALUE) AS TOTAL_REVENUE
FROM transactions
GROUP BY
    TRANSACTION_DATE,
    TRANSACTION_TYPE,
    PROMOTION_PRICE;
