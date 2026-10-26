-- 4.2. Creation of Vehicle, Borough and Date Dimensions
-- -----------------------------------------------------------------------------------------------------------------
-- Creates three dimension views and adds CRASH_DATETIME to accidents.
-- The dimensions provide the following lookup values:
--   - DIM_VEHICLE_VW: unique vehicle types across all five source fields,
--   - DIM_BOROUGH_VW: unique non-null borough names,
--   - DIM_DATE_VW: consecutive dates and their calendar attributes.
--
-- The vehicle dimension excludes NO TYPE but retains other categories,
-- including OTHER. The borough dimension does not exclude the NO BOROUGH
-- placeholder. Both dimensions reflect values present in accidents rather
-- than a separate list of allowed categories.
--
-- CRASH_DATETIME combines the stored crash date and time. The recursive
-- date range starts at the earliest non-null combined timestamp and adds
-- one day at a time through the latest such date. Days without accidents
-- between these endpoints are included. Missing combined timestamps do
-- not establish the range endpoints.
--
-- The final date view exposes DATE, YEAR, QUARTER, MONTH, DAY and YEAR_MONTH.
-- If no non-null combined timestamp exists, the anchor aggregate produces
-- a NULL date rather than a populated calendar. Longer date spans must fit
-- within the MySQL session's recursive execution limit.
--
-- Run this script after normalization. Adding CRASH_DATETIME is an initial
-- setup operation; it cannot be repeated while the column already exists.
-- Queries requiring a particular row order should specify ORDER BY.
-- -----------------------------------------------------------------------------------------------------------------


-- Active database choice
-- -----------------------------------------------------------------------------------------------------------------
USE NYC_ACCIDENTS;                                                          		 -- Selects the active database for subsequent statements.


-- Vehicle Type Dimension
-- -----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW DIM_VEHICLE_VW AS
SELECT DISTINCT VEHICLE_TYPE_CODE_1 AS VEHICLE_TYPE                                  -- DISTINCT keeps one row for each different selected value.
FROM accidents
WHERE LOWER(VEHICLE_TYPE_CODE_1) <> 'no type'                                        -- Excludes the unspecified-type category from the vehicle lookup.
UNION                                                                                -- Combines the vehicle lists and removes duplicates across the combined result.
SELECT DISTINCT VEHICLE_TYPE_CODE_2
FROM accidents
WHERE LOWER(VEHICLE_TYPE_CODE_2) <> 'no type'
UNION
SELECT DISTINCT VEHICLE_TYPE_CODE_3
FROM accidents
WHERE LOWER(VEHICLE_TYPE_CODE_3) <> 'no type'
UNION
SELECT DISTINCT VEHICLE_TYPE_CODE_4
FROM accidents
WHERE LOWER(VEHICLE_TYPE_CODE_4) <> 'no type'
UNION
SELECT DISTINCT VEHICLE_TYPE_CODE_5
FROM accidents
WHERE LOWER(VEHICLE_TYPE_CODE_5) <> 'no type';


-- Borough Dimension
-- -----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW DIM_BOROUGH_VW AS
SELECT DISTINCT
    BOROUGH
FROM accidents
WHERE BOROUGH IS NOT NULL;


-- Combined Crash Timestamp
-- -----------------------------------------------------------------------------------------------------------------
ALTER TABLE accidents
ADD COLUMN CRASH_DATETIME DATETIME;


UPDATE accidents
SET CRASH_DATETIME = TIMESTAMP(CRASH_DATE, CRASH_TIME);                              -- TIMESTAMP combines the stored date and time into one datetime value.


-- Continuous Date Dimension
-- -----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW DIM_DATE_VW AS
WITH RECURSIVE DATE_RANGE AS (                                                       -- Defines a named result that generates further rows by referring to its previous date.
    SELECT
        DATE(MIN(CRASH_DATETIME)) AS 'DATE'                                          -- MIN selects the earliest timestamp; DATE removes its time component for the starting row.
    FROM accidents
    WHERE CRASH_DATETIME IS NOT NULL
    UNION ALL
    SELECT
        DATE + INTERVAL 1 DAY                                                        -- Advances the previously generated date by one calendar day.
    FROM DATE_RANGE
    WHERE DATE < (
        SELECT DATE(MAX(CRASH_DATETIME))                                             -- MAX supplies the latest timestamp used as the end of the date range.
        FROM accidents
        WHERE CRASH_DATETIME IS NOT NULL
    )
)
SELECT
    DATE,
    YEAR(DATE) AS 'YEAR',
    QUARTER(DATE) AS 'QUARTER',                                                      -- QUARTER returns the calendar quarter from 1 to 4.
    MONTH(DATE) AS 'MONTH',
    DAY(DATE) AS 'DAY',                                                              -- DAY returns the day of the month.
    DATE_FORMAT(DATE, '%Y-%m') AS 'YEAR_MONTH'                                       -- DATE_FORMAT produces a year-month label that distinguishes the same month across years.
FROM DATE_RANGE;
