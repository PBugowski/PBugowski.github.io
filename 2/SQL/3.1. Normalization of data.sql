-- 3.1. Validation, Conversion and Business Rules
-- -----------------------------------------------------------------------------------------------------------------
-- Converts the staging snapshot and atomically replaces the reporting table.
-- A failed validation leaves the previous reporting snapshot unchanged.
--
-- Preserved rules: price-based subscription types, renewal intervals, historical standard
-- prices and the author's single 198 -> 99 adjustment. The correction is matched on the
-- original timestamp, client and amount, never on the import-generated row ID alone.
-- Its business justification was not supplied; the original amount remains auditable.
--
-- Values of exactly 260 or 600 have no type in the original CASE. They remain NULL and
-- are exposed by validation; this file does not invent a new threshold convention.
-- PROMOTION_PRICE = YES means a price outside the dated standard-price list. It is not
-- independent evidence of an actual promotional campaign or even a lower price.
-- -----------------------------------------------------------------------------------------------------------------

USE KDS_Transactions;

DROP PROCEDURE IF EXISTS rebuild_transactions;

DELIMITER $$
CREATE PROCEDURE rebuild_transactions()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        DROP TEMPORARY TABLE IF EXISTS transactions_typed;
        RESIGNAL;
    END;

    IF NOT EXISTS (SELECT 1 FROM transactions_raw) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Raw snapshot is empty. Run step 2 first.';
    END IF;

    -- Reject malformed strings BEFORE numeric/date conversion can silently coerce them.
    IF EXISTS (
        SELECT 1
        FROM transactions_raw
        WHERE TRANSACTION_TIMESTAMP_TEXT IS NULL
            OR NOT REGEXP_LIKE(TRANSACTION_TIMESTAMP_TEXT,
                '^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}[.][0-9]{6}$')
            OR CLIENT_ID_TEXT IS NULL
            OR NOT REGEXP_LIKE(CLIENT_ID_TEXT, '^[1-9][0-9]{0,8}$')
            OR TRANSACTION_VALUE_TEXT IS NULL
            OR NOT REGEXP_LIKE(TRANSACTION_VALUE_TEXT, '^[0-9]{1,10}([.][0-9]{1,2})?$')
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid raw format. Inspect transactions_raw.';
    END IF;

    DROP TEMPORARY TABLE IF EXISTS transactions_typed;
    CREATE TEMPORARY TABLE transactions_typed AS
    SELECT
        SOURCE_ROW_ID AS TRANSACTION_ID,
        STR_TO_DATE(TRANSACTION_TIMESTAMP_TEXT, '%Y-%m-%dT%H:%i:%s.%f') AS TRANSACTION_TIMESTAMP,
        CAST(CLIENT_ID_TEXT AS UNSIGNED) AS CLIENT_ID,
        CAST(TRANSACTION_VALUE_TEXT AS DECIMAL(12,2)) AS ORIGINAL_TRANSACTION_VALUE
    FROM transactions_raw;

    IF EXISTS (
        SELECT 1
        FROM transactions_typed
        WHERE TRANSACTION_TIMESTAMP IS NULL
            OR YEAR(TRANSACTION_TIMESTAMP) < 1000
            OR MONTH(TRANSACTION_TIMESTAMP) = 0
            OR DAY(TRANSACTION_TIMESTAMP) = 0
            OR LAST_DAY(TRANSACTION_TIMESTAMP) IS NULL
            OR DAY(TRANSACTION_TIMESTAMP) > DAY(LAST_DAY(TRANSACTION_TIMESTAMP))
            OR ORIGINAL_TRANSACTION_VALUE <= 0
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid calendar date or non-positive amount.';
    END IF;

    -- This reconstruction targets the supplied snapshot. A changed source requires reviewing
    -- this explicit historical adjustment instead of silently correcting an unrelated row.
    IF (
        SELECT COUNT(*)
        FROM transactions_typed
        WHERE TRANSACTION_TIMESTAMP = '2024-03-24 13:14:25.756000'
            AND CLIENT_ID = 140
            AND ORIGINAL_TRANSACTION_VALUE = 198.00
    ) <> 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Historical correction must match exactly one source row.';
    END IF;

    START TRANSACTION;

    DELETE FROM transactions;

    INSERT INTO transactions (
        TRANSACTION_ID, TRANSACTION_TIMESTAMP, TRANSACTION_DATE, CLIENT_ID,
        ORIGINAL_TRANSACTION_VALUE, TRANSACTION_VALUE, CORRECTION_APPLIED,
        TRANSACTION_TYPE, EXPECTED_RENEWAL_DATE, PROMOTION_PRICE,
        TRANSACTION_YEAR, TRANSACTION_MONTH_NUMBER
    )
    SELECT
        s.TRANSACTION_ID,
        s.TRANSACTION_TIMESTAMP,
        DATE(s.TRANSACTION_TIMESTAMP),
        s.CLIENT_ID,
        s.ORIGINAL_TRANSACTION_VALUE,
        s.TRANSACTION_VALUE,
        s.CORRECTION_APPLIED,
        s.TRANSACTION_TYPE,
        CASE s.TRANSACTION_TYPE
            WHEN 'MONTHLY' THEN DATE_ADD(DATE(s.TRANSACTION_TIMESTAMP), INTERVAL 1 MONTH)
            WHEN 'SEMI-ANNUAL' THEN DATE_ADD(DATE(s.TRANSACTION_TIMESTAMP), INTERVAL 6 MONTH)
            WHEN 'ANNUAL' THEN DATE_ADD(DATE(s.TRANSACTION_TIMESTAMP), INTERVAL 12 MONTH)
            ELSE NULL
        END,
        CASE
            WHEN DATE(s.TRANSACTION_TIMESTAMP) < '2024-09-10'
                AND s.TRANSACTION_VALUE IN (99, 495, 990) THEN 'NO'
            WHEN DATE(s.TRANSACTION_TIMESTAMP) >= '2024-09-10'
                AND DATE(s.TRANSACTION_TIMESTAMP) < '2025-09-12'
                AND s.TRANSACTION_VALUE IN (199, 1799) THEN 'NO'
            WHEN DATE(s.TRANSACTION_TIMESTAMP) >= '2025-09-12'
                AND s.TRANSACTION_VALUE IN (249, 1999) THEN 'NO'
            ELSE 'YES'
        END,
        YEAR(s.TRANSACTION_TIMESTAMP),
        MONTH(s.TRANSACTION_TIMESTAMP)
    FROM (
        SELECT
            c.*,
            CASE
                WHEN TRANSACTION_VALUE < 260 THEN 'MONTHLY'
                WHEN TRANSACTION_VALUE > 260 AND TRANSACTION_VALUE < 600 THEN 'SEMI-ANNUAL'
                WHEN TRANSACTION_VALUE > 600 THEN 'ANNUAL'
                ELSE NULL
            END AS TRANSACTION_TYPE
        FROM (
            SELECT
                t.*,
                CASE
                    WHEN TRANSACTION_TIMESTAMP = '2024-03-24 13:14:25.756000'
                        AND CLIENT_ID = 140 AND ORIGINAL_TRANSACTION_VALUE = 198.00
                    THEN 99.00
                    ELSE ORIGINAL_TRANSACTION_VALUE
                END AS TRANSACTION_VALUE,
                CASE
                    WHEN TRANSACTION_TIMESTAMP = '2024-03-24 13:14:25.756000'
                        AND CLIENT_ID = 140 AND ORIGINAL_TRANSACTION_VALUE = 198.00
                    THEN 1 ELSE 0
                END AS CORRECTION_APPLIED
            FROM transactions_typed t
        ) c
    ) s;

    COMMIT;
    DROP TEMPORARY TABLE transactions_typed;
END$$
DELIMITER ;

CALL rebuild_transactions();
DROP PROCEDURE rebuild_transactions;
