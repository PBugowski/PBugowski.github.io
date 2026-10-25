-- 4.4. Creation of the Cohort Retention Source View
-- -----------------------------------------------------------------------------------------------------------------
-- Creates vw_4_retention from the prepared transactions table.
-- Each row represents a unique combination of:
--   - CLIENT_ID,
--   - TRANSACTION_DATE,
--   - TRANSACTION_TYPE,
--   - PROMOTION_PRICE.
--
-- Repeated transactions sharing all four attributes are represented once.
-- The view does not include transaction identifiers, transaction values,
-- purchase counts or total revenue. Multiple rows for a customer on the same
-- date remain possible when subscription type or price category differs.
--
-- All subscription types are retained. This makes the full observed customer
-- history available to subsequent queries that identify first purchases or
-- compare activity across calendar months. Filtering to one subscription
-- type before identifying first purchases would restrict that history.
--
-- The view provides activity detail only. It does not calculate first-purchase
-- dates, cohort membership, elapsed periods or retention percentages. Those
-- calculations require additional queries against the returned records.
-- Distinct customer counts across a period must be calculated explicitly;
-- counting view rows is not equivalent to counting unique customers.
-- -----------------------------------------------------------------------------------------------------------------

USE KDS_Transactions;


-- Cohort Activity Detail
-- -----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_4_retention AS
SELECT DISTINCT
    CLIENT_ID,
    TRANSACTION_DATE,
    TRANSACTION_TYPE,
    PROMOTION_PRICE
FROM transactions;                                                                    -- Retains activity across all plans for the first-purchase calculation.
