-- 4.2. Creation of Dimension Views for Power BI Data Modeling
-- -----------------------------------------------------------------------------------------------------------------
-- Creates dimension views for vehicle types, boroughs, and dates to support
-- filtering, relationships, and time-based analysis in Power BI.
--
-- DIM_VEHICLE_VW contains unique vehicle types from all five vehicle columns,
-- excluding records classified as 'NO TYPE'. The view is used as a vehicle
-- dimension for filtering and vehicle-related analysis.
--
-- DIM_BOROUGH_VW contains unique non-null borough names and provides a
-- separate dimension for borough-level filtering and analysis.
--
-- DIM_DATE_VW generates a continuous date range from the earliest to the
-- latest recorded CRASH_DATETIME. It provides date attributes including
-- year, quarter, month, day, and year-month, which support time-based
-- analysis and date filtering in Power BI.
--
-- The dimension views provide a structured supporting layer for the Power BI
-- data model and allow consistent filtering and analysis across the reporting
-- views.
-- -----------------------------------------------------------------------------------------------------------------

-- Selects the NYC_ACCIDENTS database as the active database.
USE NYC_ACCIDENTS;

-- -----------------------------------------------------------------------------------------------------------------
-- DIM_VEHICLE_VW
-- -----------------------------------------------------------------------------------------------------------------
-- Creates a dimension view containing unique vehicle types used in the accidents.
CREATE OR REPLACE VIEW DIM_VEHICLE_VW AS
SELECT DISTINCT VEHICLE_TYPE_CODE_1 AS VEHICLE_TYPE
FROM accidents
WHERE LOWER(VEHICLE_TYPE_CODE_1) <> 'no type'
UNION
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

-- -----------------------------------------------------------------------------------------------------------------
-- DIM_BOROUGH_VW
-- -----------------------------------------------------------------------------------------------------------------
-- Creates a dimension view containing unique borough names.
CREATE OR REPLACE VIEW DIM_BOROUGH_VW AS
SELECT DISTINCT
    BOROUGH
FROM accidents
WHERE BOROUGH IS NOT NULL;

-- -----------------------------------------------------------------------------------------------------------------
-- DIM_DATE_VW
-- -----------------------------------------------------------------------------------------------------------------
-- Adds a combined date and time column for each accident.
ALTER TABLE accidents
ADD COLUMN CRASH_DATETIME DATETIME;

-- Combines the crash date and crash time into a single DATETIME value.
UPDATE accidents
SET CRASH_DATETIME = TIMESTAMP(CRASH_DATE, CRASH_TIME);

-- Creates a date dimension containing all dates between the first and last accident.
CREATE OR REPLACE VIEW DIM_DATE_VW AS
WITH RECURSIVE DATE_RANGE AS ( 							-- Generates a continuous sequence of dates using a recursive common table expression.
    SELECT
        DATE(MIN(CRASH_DATETIME)) AS 'DATE'     		-- Selects the first date based on the earliest recorded accident.
    FROM accidents
    WHERE CRASH_DATETIME IS NOT NULL
    UNION ALL
    SELECT
        DATE + INTERVAL 1 DAY 							-- Adds one day to the previously generated date.
    FROM DATE_RANGE
    WHERE DATE < (
        SELECT DATE(MAX(CRASH_DATETIME)) 				-- Continues generating dates until the date of the latest accident.
        FROM accidents
        WHERE CRASH_DATETIME IS NOT NULL
    )
)
SELECT 													-- Selects the date attributes used for date-based analysis in Power BI.
    DATE,
    YEAR(DATE) AS 'YEAR',
    QUARTER(DATE) AS 'QUARTER',
    MONTH(DATE) AS 'MONTH',
    DAY(DATE) AS 'DAY',
    DATE_FORMAT(DATE, '%Y-%m') AS 'YEAR_MONTH'
FROM DATE_RANGE;
