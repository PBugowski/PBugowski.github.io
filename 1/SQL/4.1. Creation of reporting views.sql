-- 4.1. Creation of Accident Analysis Views
-- -----------------------------------------------------------------------------------------------------------------
-- Adds outcome and time-bucket attributes to accidents and creates nine views.
-- The preparation step adds five columns:
--   - ACC_W_INJURED: an injury is reported in any injury count and the total
--     NUMBER_OF_PERSONS_KILLED is zero after substituting missing values,
--   - ACC_W_KILLED: at least one total or road-user fatality count is positive,
--   - ACC_WO: none of the eight injury or fatality counts is positive,
--   - TIME_BUCKET: one of twelve two-hour interval labels,
--   - TIME_BUCKET_NUMBER: the corresponding chronological position, 1 to 12.
--
-- Missing casualty counts are treated as zero in the flag expressions.
-- The injury flag checks only the total fatality field, whereas the fatality
-- flag also checks the road-user fields. Inconsistent totals can therefore
-- produce overlapping flags. ACC_WO is based on the absence of positive
-- counts; it does not establish that all source counts were complete.
-- Time intervals include their lower bound and exclude their upper bound.
-- Missing or unmatched times receive NULL bucket values.
--
-- P1_VW contains identifiers, dates, boroughs, outcome flags and casualty
-- counts. P2_VW adds weekday and time attributes. P3_VW retains coordinates
-- and the on-street name together with the collision identifier and date.
--
-- P4P5P6_FACTOR_VW and P4P5P6_VEHICLE_VW expose the five source slots as
-- rows in a common category column. Each source record contributes five
-- rows, including repeated categories and placeholder values. Counting
-- these rows is not equivalent to counting distinct collisions.
--
-- P4P5P6_RATE_VW retains dated accident rows and attaches monthly outcome
-- ratios. Each ratio uses all dated source rows in the same year and month
-- and is repeated for every row in that month. Ratios are fractions rather
-- than percentages multiplied by 100; they must not be summed across rows.
--
-- P4P5P6_MAP_VW provides identifiers, dates, boroughs and outcome flags but
-- no coordinates. P4P5P6_HEAT_VW adds weekday and time-bucket attributes.
-- P4P5P6_STREET_VW adds the on-street name. None of these views filters to
-- only one outcome; subsequent queries select the relevant flag.
--
-- Run this script after import and normalization in the intended database.
-- The column additions are intended for the initial setup and fail if those
-- columns already exist. Replacing a view does not duplicate source rows.
-- -----------------------------------------------------------------------------------------------------------------


-- Active database choice
-- -----------------------------------------------------------------------------------------------------------------
USE NYC_ACCIDENTS;                                                          		 -- Selects the active database for subsequent statements.


-- Outcome Flags and Accident Detail
-- -----------------------------------------------------------------------------------------------------------------
ALTER TABLE accidents
ADD COLUMN ACC_W_INJURED INT;                                                        -- ALTER TABLE adds an integer column to the existing table.


UPDATE accidents
SET ACC_W_INJURED = CASE                                                             -- Flags any positive injury count only when the total persons-killed count is zero.
    WHEN (
        COALESCE(NUMBER_OF_PERSONS_INJURED, 0) > 0
        OR COALESCE(NUMBER_OF_PEDESTRIANS_INJURED, 0) > 0
        OR COALESCE(NUMBER_OF_CYCLIST_INJURED, 0) > 0
        OR COALESCE(NUMBER_OF_MOTORIST_INJURED, 0) > 0
    )
    AND COALESCE(NUMBER_OF_PERSONS_KILLED, 0) = 0
    THEN 1
    ELSE 0
END;


ALTER TABLE accidents
ADD COLUMN ACC_W_KILLED INT;


UPDATE accidents
SET ACC_W_KILLED = CASE                                                              -- Flags a positive fatality count in either the total or a road-user field.
    WHEN COALESCE(NUMBER_OF_PERSONS_KILLED, 0) > 0
      OR COALESCE(NUMBER_OF_PEDESTRIANS_KILLED, 0) > 0
      OR COALESCE(NUMBER_OF_CYCLIST_KILLED, 0) > 0
      OR COALESCE(NUMBER_OF_MOTORIST_KILLED, 0) > 0
    THEN 1
    ELSE 0
END;


ALTER TABLE accidents
ADD COLUMN ACC_WO INT;


UPDATE accidents
SET ACC_WO = CASE                                                                    -- Flags rows with no positive injury or fatality count after NULL substitution.
    WHEN COALESCE(NUMBER_OF_PERSONS_KILLED, 0) > 0
      OR COALESCE(NUMBER_OF_PEDESTRIANS_KILLED, 0) > 0
      OR COALESCE(NUMBER_OF_CYCLIST_KILLED, 0) > 0
      OR COALESCE(NUMBER_OF_MOTORIST_KILLED, 0) > 0
      OR COALESCE(NUMBER_OF_PERSONS_INJURED, 0) > 0
      OR COALESCE(NUMBER_OF_PEDESTRIANS_INJURED, 0) > 0
      OR COALESCE(NUMBER_OF_CYCLIST_INJURED, 0) > 0
      OR COALESCE(NUMBER_OF_MOTORIST_INJURED, 0) > 0
    THEN 0
    ELSE 1
END;


CREATE OR REPLACE VIEW P1_VW AS                                                      -- Creates the view or replaces its existing query definition.
SELECT
    COLLISION_ID,
    CRASH_DATE,
    BOROUGH,
    ACC_WO,
    ACC_W_INJURED,
    ACC_W_KILLED,
    NUMBER_OF_PERSONS_INJURED,
    NUMBER_OF_PERSONS_KILLED,
    NUMBER_OF_PEDESTRIANS_INJURED,
    NUMBER_OF_PEDESTRIANS_KILLED,
    NUMBER_OF_CYCLIST_INJURED,
    NUMBER_OF_CYCLIST_KILLED,
    NUMBER_OF_MOTORIST_INJURED,
    NUMBER_OF_MOTORIST_KILLED
FROM accidents;


-- Time Intervals and Weekday Detail
-- -----------------------------------------------------------------------------------------------------------------
ALTER TABLE accidents
ADD COLUMN TIME_BUCKET VARCHAR(20);


UPDATE accidents
SET TIME_BUCKET = CASE
    WHEN CRASH_TIME >= '00:00:00' AND CRASH_TIME < '02:00:00' THEN '00 - 02 AM'      -- Includes the lower time bound and excludes the upper bound for each two-hour interval.
    WHEN CRASH_TIME >= '02:00:00' AND CRASH_TIME < '04:00:00' THEN '02 - 04 AM'
    WHEN CRASH_TIME >= '04:00:00' AND CRASH_TIME < '06:00:00' THEN '04 - 06 AM'
    WHEN CRASH_TIME >= '06:00:00' AND CRASH_TIME < '08:00:00' THEN '06 - 08 AM'
    WHEN CRASH_TIME >= '08:00:00' AND CRASH_TIME < '10:00:00' THEN '08 - 10 AM'
    WHEN CRASH_TIME >= '10:00:00' AND CRASH_TIME < '12:00:00' THEN '10 - 12 AM'
    WHEN CRASH_TIME >= '12:00:00' AND CRASH_TIME < '14:00:00' THEN '00 - 02 PM'
    WHEN CRASH_TIME >= '14:00:00' AND CRASH_TIME < '16:00:00' THEN '02 - 04 PM'
    WHEN CRASH_TIME >= '16:00:00' AND CRASH_TIME < '18:00:00' THEN '04 - 06 PM'
    WHEN CRASH_TIME >= '18:00:00' AND CRASH_TIME < '20:00:00' THEN '06 - 08 PM'
    WHEN CRASH_TIME >= '20:00:00' AND CRASH_TIME < '22:00:00' THEN '08 - 10 PM'
    WHEN CRASH_TIME >= '22:00:00' AND CRASH_TIME < '24:00:00' THEN '10 - 12 PM'
END;


ALTER TABLE accidents
ADD COLUMN TIME_BUCKET_NUMBER INT;


UPDATE accidents
SET TIME_BUCKET_NUMBER = CASE                                                        -- Stores the interval positions used for chronological sorting of the labels.
    WHEN CRASH_TIME >= '00:00:00' AND CRASH_TIME < '02:00:00' THEN '1'
    WHEN CRASH_TIME >= '02:00:00' AND CRASH_TIME < '04:00:00' THEN '2'
    WHEN CRASH_TIME >= '04:00:00' AND CRASH_TIME < '06:00:00' THEN '3'
    WHEN CRASH_TIME >= '06:00:00' AND CRASH_TIME < '08:00:00' THEN '4'
    WHEN CRASH_TIME >= '08:00:00' AND CRASH_TIME < '10:00:00' THEN '5'
    WHEN CRASH_TIME >= '10:00:00' AND CRASH_TIME < '12:00:00' THEN '6'
    WHEN CRASH_TIME >= '12:00:00' AND CRASH_TIME < '14:00:00' THEN '7'
    WHEN CRASH_TIME >= '14:00:00' AND CRASH_TIME < '16:00:00' THEN '8'
    WHEN CRASH_TIME >= '16:00:00' AND CRASH_TIME < '18:00:00' THEN '9'
    WHEN CRASH_TIME >= '18:00:00' AND CRASH_TIME < '20:00:00' THEN '10'
    WHEN CRASH_TIME >= '20:00:00' AND CRASH_TIME < '22:00:00' THEN '11'
    WHEN CRASH_TIME >= '22:00:00' AND CRASH_TIME < '24:00:00' THEN '12'
END;


CREATE OR REPLACE VIEW P2_VW AS
SELECT
    COLLISION_ID,
    CRASH_DATE,
    BOROUGH,
    ACC_WO,
    ACC_W_INJURED,
    ACC_W_KILLED,
    DAYOFWEEK(CRASH_DATE) AS 'DAY_OF_WEEK_NUMBER',                                   -- DAYOFWEEK returns 1 for Sunday through 7 for Saturday.
    DAYNAME(CRASH_DATE) AS 'DAY_OF_WEEK',                                            -- DAYNAME returns the weekday name in the current session language.
    CRASH_TIME,
    TIME_BUCKET,
    TIME_BUCKET_NUMBER
FROM accidents;


-- Coordinates and Street Detail
-- -----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW P3_VW AS
SELECT
    LATITUDE,
    LONGITUDE,
    ON_STREET_NAME,
    COLLISION_ID,
    CRASH_DATE,
    BOROUGH
FROM accidents;


-- Contributing Factor Detail
-- -----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW P4P5P6_FACTOR_VW AS
SELECT COLLISION_ID, CRASH_DATE, BOROUGH, CONTRIBUTING_FACTOR_VEHICLE_1 AS 'FACTOR', ACC_WO, ACC_W_INJURED, ACC_W_KILLED FROM ACCIDENTS
UNION ALL                                                                            -- Combines the source-slot queries without removing repeated rows.
SELECT COLLISION_ID, CRASH_DATE, BOROUGH, CONTRIBUTING_FACTOR_VEHICLE_2, ACC_WO, ACC_W_INJURED, ACC_W_KILLED FROM ACCIDENTS
UNION ALL
SELECT COLLISION_ID, CRASH_DATE, BOROUGH, CONTRIBUTING_FACTOR_VEHICLE_3, ACC_WO, ACC_W_INJURED, ACC_W_KILLED FROM ACCIDENTS
UNION ALL
SELECT COLLISION_ID, CRASH_DATE, BOROUGH, CONTRIBUTING_FACTOR_VEHICLE_4, ACC_WO, ACC_W_INJURED, ACC_W_KILLED FROM ACCIDENTS
UNION ALL
SELECT COLLISION_ID, CRASH_DATE, BOROUGH, CONTRIBUTING_FACTOR_VEHICLE_5, ACC_WO, ACC_W_INJURED, ACC_W_KILLED FROM ACCIDENTS;


-- Vehicle Type Detail
-- -----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW P4P5P6_VEHICLE_VW AS
SELECT COLLISION_ID, CRASH_DATE, BOROUGH, VEHICLE_TYPE_CODE_1 AS 'VEHICLE', ACC_WO, ACC_W_INJURED, ACC_W_KILLED FROM ACCIDENTS
UNION ALL
SELECT COLLISION_ID, CRASH_DATE, BOROUGH, VEHICLE_TYPE_CODE_2, ACC_WO, ACC_W_INJURED, ACC_W_KILLED FROM ACCIDENTS
UNION ALL
SELECT COLLISION_ID, CRASH_DATE, BOROUGH, VEHICLE_TYPE_CODE_3, ACC_WO, ACC_W_INJURED, ACC_W_KILLED FROM ACCIDENTS
UNION ALL
SELECT COLLISION_ID, CRASH_DATE, BOROUGH, VEHICLE_TYPE_CODE_4, ACC_WO, ACC_W_INJURED, ACC_W_KILLED FROM ACCIDENTS
UNION ALL
SELECT COLLISION_ID, CRASH_DATE, BOROUGH, VEHICLE_TYPE_CODE_5, ACC_WO, ACC_W_INJURED, ACC_W_KILLED FROM ACCIDENTS;


-- Monthly Outcome Ratios
-- -----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW P4P5P6_RATE_VW AS
SELECT
    COLLISION_ID,
    CRASH_DATE,
    SUM(ACC_WO) OVER monthly / COUNT(*) OVER monthly AS NOT_INJURED_RATE,            -- SUM totals the flag and COUNT(*) counts rows in the OVER window; division returns the monthly share.
    SUM(ACC_W_INJURED) OVER monthly / COUNT(*) OVER monthly AS INJURED_RATE,
    SUM(ACC_W_KILLED) OVER monthly / COUNT(*) OVER monthly AS KILLED_RATE
FROM accidents
WHERE CRASH_DATE IS NOT NULL                                                         -- IS NOT NULL excludes missing dates from the monthly calculations.
WINDOW monthly AS (                                                                  -- Names the window definition reused by all three outcome ratios.
    PARTITION BY YEAR(CRASH_DATE), MONTH(CRASH_DATE));                               -- PARTITION BY separates year/month groups; YEAR and MONTH extract those calendar attributes.


-- Outcome Detail by Collision
-- -----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW P4P5P6_MAP_VW AS
SELECT
    COLLISION_ID,
    CRASH_DATE,
    BOROUGH,
    ACC_WO,
    ACC_W_INJURED,
    ACC_W_KILLED
FROM accidents;


-- Outcome Detail by Weekday and Time
-- -----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW P4P5P6_HEAT_VW AS
SELECT
    COLLISION_ID,
    CRASH_DATE,
    BOROUGH,
    ACC_WO,
    ACC_W_INJURED,
    ACC_W_KILLED,
    DAYOFWEEK(CRASH_DATE) AS 'DAY_OF_WEEK_NUMBER',
    DAYNAME(CRASH_DATE) AS 'DAY_OF_WEEK',
    TIME_BUCKET,
    TIME_BUCKET_NUMBER
FROM accidents;


-- Outcome Detail by Street
-- -----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW P4P5P6_STREET_VW AS
SELECT
    COLLISION_ID,
    CRASH_DATE,
    BOROUGH,
    ACC_WO,
    ACC_W_INJURED,
    ACC_W_KILLED,
    ON_STREET_NAME
FROM accidents;
