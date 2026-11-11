-- 3. Preparing Transactions for Analysis
-- -----------------------------------------------------------------------------------------------------------------
-- Populates the derived attributes in the transactions table after import.
-- The preparation process:
--   - assigns a subscription type according to the transaction amount,
--   - calculates the expected renewal date for each subscription,
--   - applies the source correction to transaction ID 299,
--   - identifies prices matching the regular-price rules,
--   - extracts transaction year and month number.
--
-- Amounts below 260 are classified as monthly subscriptions. Amounts above
-- 260 and below 600 are classified as semi-annual subscriptions. Amounts
-- above 600 are classified as annual subscriptions. The supplied rules leave
-- amounts exactly equal to 260 or 600 unclassified; neither occurs in the
-- provided dataset.
--
-- Transaction ID 299 is changed from 198 to 99. In the supplied CSV this is
-- the payment by customer 140 on 2024-03-24. Both amounts belong to the monthly
-- category, so the preceding subscription and renewal calculations remain
-- consistent. The ID refers to the initial import into an empty table.
--
-- PROMOTION_PRICE uses the following classification:
--   - NO: the amount matches a regular price for the transaction date,
--   - YES: the amount does not match any of those regular-price rules.
-- The regular-price periods begin before 2024-09-10, on 2024-09-10, and on
-- 2025-09-12. YES includes all other amounts, including amounts above the
-- listed prices; the expression does not test whether a discount was applied.
--
-- The expected renewal date is inferred by adding one, six or twelve calendar
-- months to the transaction date. It does not establish that a renewal
-- actually took place.
-- -----------------------------------------------------------------------------------------------------------------


-- Active database choice
-- -----------------------------------------------------------------------------------------------------------------
USE KDS_Transactions;																	-- Selects the active database for subsequent statements.	


-- Subscription Types
-- -----------------------------------------------------------------------------------------------------------------
UPDATE transactions
SET TRANSACTION_TYPE =
    CASE                                                                           		-- Evaluates the amount against the subscription rules; unmatched values remain NULL.
        WHEN TRANSACTION_VALUE < 260
            THEN 'MONTHLY'
        WHEN TRANSACTION_VALUE > 260
             AND TRANSACTION_VALUE < 600
            THEN 'SEMI-ANNUAL'
        WHEN TRANSACTION_VALUE > 600
            THEN 'ANNUAL'
    END;


-- Expected Renewal Dates
-- -----------------------------------------------------------------------------------------------------------------
UPDATE transactions
SET EXPECTED_RENEWAL_DATE =
    CASE
        WHEN TRANSACTION_TYPE = 'MONTHLY'
            THEN DATE_ADD(TRANSACTION_DATE, INTERVAL 1 MONTH)                       	-- DATE_ADD advances the date by the specified number of calendar months.
        WHEN TRANSACTION_TYPE = 'SEMI-ANNUAL'
            THEN DATE_ADD(TRANSACTION_DATE, INTERVAL 6 MONTH)
        WHEN TRANSACTION_TYPE = 'ANNUAL'
            THEN DATE_ADD(TRANSACTION_DATE, INTERVAL 12 MONTH)
        ELSE NULL
    END;


-- Transaction Value Correction
-- -----------------------------------------------------------------------------------------------------------------
UPDATE transactions
SET TRANSACTION_VALUE = 99
WHERE TRANSACTION_ID = 299;                                                          	-- Applies the existing correction to this specific imported transaction.


-- Regular and Non-Standard Prices
-- -----------------------------------------------------------------------------------------------------------------
UPDATE transactions
SET PROMOTION_PRICE =
    CASE
        WHEN TRANSACTION_DATE < '2024-09-10'
             AND TRANSACTION_VALUE IN (99, 495, 990)                                	-- IN tests whether the amount matches one of the regular prices before 2024-09-10.
            THEN 'NO'
        WHEN TRANSACTION_DATE >= '2024-09-10'                                         	-- Starts the next price period, ending before 2025-09-12.
             AND TRANSACTION_DATE < '2025-09-12'
             AND TRANSACTION_VALUE IN (199, 1799)
            THEN 'NO'
        WHEN TRANSACTION_DATE >= '2025-09-12'                                       	-- Applies the latest regular-price period.
             AND TRANSACTION_VALUE IN (249, 1999)
            THEN 'NO'
        ELSE 'YES'                                                                    	-- Labels every remaining amount as a non-standard price.
    END;


-- Transaction Date Attributes
-- -----------------------------------------------------------------------------------------------------------------
UPDATE transactions
SET
    TRANSACTION_YEAR = YEAR(TRANSACTION_DATE),                                       	-- YEAR extracts the calendar year.
    TRANSACTION_MONTH_NUMBER = MONTH(TRANSACTION_DATE);									-- MONTH extracts the calendar month number from 1 to 12.
