-- 4.1. Creation of reporting views for Power Bi Analysis
-- -----------------------------------------------------------------------------------------------------------------
-- Extends the accidents table with additional fields and creates a set of
-- reporting views used to prepare the data for Power BI analysis.



-- P1 Reporting View
-- -----------------------------------------------------------------------------------------------------------------
-- Adds additional columns to the accidents table to support the analysis
-- of accident severity, injuries, and fatalities.
--
-- ACC_W_INJURED identifies accidents resulting in injuries but no fatalities.
-- ACC_W_KILLED identifies accidents resulting in at least one fatality.
-- ACC_WO identifies accidents resulting in no reported injuries or fatalities.
-- These indicators are stored as binary values (1/0) and are used to
-- distinguish accidents according to their outcome.
--
-- The P1_VW view contains the collision identifier, accident date, severity
-- indicators, and detailed injury and fatality counts by road user type.
-- The view provides the data required for the first Power BI analysis
-- dashboard.
--
-- P1_VW is used to create the following Power BI visualizations:
--   - Distribution of Injuries by Road User Type (bar chart)
--   - Distribution of Fatalities by Road User Type (bar chart)
--   - Number of Accidents Resulting in Injury (line chart)
--   - Number of Accidents Resulting in Fatalities (line chart)
--
-- The view is also used to create the following KPI indicators:
--   - Total Accidents
--   - Accidents Resulting in No Injuries or Fatalities
--   - Accidents Resulting in Injuries
--   - Total Number of Injuries
--   - Accidents Resulting in Fatalities
--   - Total Number of Fatalities
--
-- The resulting P1_VW provides a structured dataset for analyzing accident
-- outcomes and comparing injuries and fatalities across different road user
-- types and over time.
-- -----------------------------------------------------------------------------------------------------------------

-- Adds a binary flag identifying crashes involving injuries but no fatalities.
ALTER TABLE accidents
ADD COLUMN ACC_W_INJURED INT;

-- Sets ACC_W_INJURED to 1 when at least one injury is reported and no fatality is reported.
UPDATE accidents
SET ACC_W_INJURED = CASE
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

-- Adds a binary flag identifying crashes involving at least one fatality.
ALTER TABLE accidents
ADD COLUMN ACC_W_KILLED INT;

-- Sets ACC_W_KILLED to 1 when at least one death is reported.
UPDATE accidents
SET ACC_W_KILLED = CASE
    WHEN COALESCE(NUMBER_OF_PERSONS_KILLED, 0) > 0
      OR COALESCE(NUMBER_OF_PEDESTRIANS_KILLED, 0) > 0
      OR COALESCE(NUMBER_OF_CYCLIST_KILLED, 0) > 0
      OR COALESCE(NUMBER_OF_MOTORIST_KILLED, 0) > 0
    THEN 1
    ELSE 0
END;

-- Adds a binary flag identifying crashes with no reported injuries or fatalities.
ALTER TABLE accidents
ADD COLUMN ACC_WO INT;

-- Sets ACC_WO to 1 when no injuries or fatalities are reported.
UPDATE accidents
SET ACC_WO = CASE
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

-- Creates P1_VW containing accident records and the injury and fatality indicators.
CREATE OR REPLACE VIEW P1_VW AS
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



-- P2 Reporting View
-- -----------------------------------------------------------------------------------------------------------------
-- Adds time-based fields to the accidents table to support the analysis
-- of when accidents occur throughout the day and across different days
-- of the week.
--
-- TIME_BUCKET divides the 24-hour day into twelve two-hour intervals,
-- while TIME_BUCKET_NUMBER assigns a sequential number to each interval.
-- The numeric field allows the time buckets to be displayed in chronological
-- order in Power BI.
--
-- DAY_OF_WEEK_NUMBER and DAY_OF_WEEK provide both the numeric and textual
-- representation of the day on which each accident occurred.
--
-- The P2_VW view combines accident severity indicators, day-of-week
-- information, crash time, time buckets, collision identifiers, crash dates,
-- and borough information into a dataset prepared for Power BI analysis.
--
-- P2_VW is used to create the following Power BI visualizations:
--   - Number of Accidents Over Time (line chart)
--   - Number of Accidents by Day of the Week (column chart)
--   - Number of Accidents by Time of Day (column chart)
--   - Number of Accidents Heatmap
--
-- The resulting P2_VW provides a structured dataset for analyzing when
-- accidents occur, including their distribution across dates, days of the
-- week, and two-hour time intervals throughout the day.
-- -----------------------------------------------------------------------------------------------------------------

-- Adds a column for two-hour time intervals.
ALTER TABLE accidents
ADD COLUMN TIME_BUCKET VARCHAR(20);

-- Assigns each accident to a two-hour time interval based on the crash time.
UPDATE accidents
SET TIME_BUCKET = CASE
	WHEN CRASH_TIME >= '00:00:00' AND CRASH_TIME < '02:00:00' THEN '00 - 02 AM'
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

-- Adds a numeric column used to sort the time buckets chronologically.
ALTER TABLE accidents
ADD COLUMN TIME_BUCKET_NUMBER INT;

-- Assigns a sequential number from 1 to 12 to each two-hour time bucket.
UPDATE accidents
SET TIME_BUCKET_NUMBER = CASE
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

-- Creates the P2_VW containing accident records and information about the time of occurrence.
CREATE OR REPLACE VIEW P2_VW AS
SELECT
	COLLISION_ID,
    CRASH_DATE,
    BOROUGH,
	ACC_WO,
    ACC_W_INJURED,
    ACC_W_KILLED,
	DAYOFWEEK(CRASH_DATE) AS 'DAY_OF_WEEK_NUMBER',
    DAYNAME(CRASH_DATE) AS 'DAY_OF_WEEK',
	CRASH_TIME,
	TIME_BUCKET,
    TIME_BUCKET_NUMBER
FROM accidents;



-- P3 Reporting View
-- -----------------------------------------------------------------------------------------------------------------
-- Creates the P3_VW view containing geographic coordinates, street names,
-- collision identifiers, crash dates, and borough information.
--
-- LATITUDE and LONGITUDE provide the geographic coordinates required for
-- mapping accident locations, while ON_STREET_NAME identifies the road
-- where the accident occurred.
--
-- COLLISION_ID uniquely identifies each accident, CRASH_DATE provides the
-- date of occurrence, and BOROUGH identifies the borough in which the
-- accident occurred.
--
-- P3_VW is used to create the following Power BI visualizations:
--   - Top 10 Roads by Number of Accidents (column chart)
--   - Number of Accidents by Borough (bar chart)
--   - Accident Locations (map)
--
-- The resulting P3_VW provides a structured dataset for analyzing the
-- spatial distribution of accidents by road, borough, and geographic
-- coordinates.
-- -----------------------------------------------------------------------------------------------------------------

-- Creates the P3_VW containing accident location and street information.
CREATE OR REPLACE VIEW P3_VW AS
SELECT
	LATITUDE,
    LONGITUDE,
	ON_STREET_NAME,
	COLLISION_ID,
    CRASH_DATE,
    BOROUGH
FROM accidents;



-- P4, P5 and P6 Reporting Views
-- -----------------------------------------------------------------------------------------------------------------
-- Creates a set of views used to support three identical Power BI dashboards
-- focused on different accident severity categories.
--
-- P4 represents accidents resulting in no injuries or fatalities.
-- P5 represents accidents resulting in injuries.
-- P6 represents accidents resulting in fatalities.
--
-- The P4, P5 and P6 dashboards have the same structure and visualizations,
-- but each dashboard presents the analysis for a different accident outcome.
-- The P4P5P6_FACTOR_VW and P4P5P6_VEHICLE_VW views transform the five
-- contributing factor and vehicle type columns into a single column,
-- allowing factors and vehicle types to be analyzed consistently.
-- P4P5P6_RATE_VW calculates monthly percentages of accidents according to
-- their outcome: no injuries or fatalities, injuries, and fatalities.
-- P4P5P6_MAP_VW provides accident-level information for map visualizations.
-- P4P5P6_HEAT_VW provides day-of-week and time-of-day information required
-- to create accident heatmaps.
-- P4P5P6_STREET_VW provides street-level information for the analysis
-- of accidents by road.
--
-- The P4P5P6 views are used to create the following visualizations for P4:
--   - Percentage of Accidents Resulting in No Injuries or Fatalities Over Time (line chart)
--   - Top 5 Vehicle Types Involved in Accidents Resulting in No Injuries or Fatalities (column chart)
--   - Top 5 Factors Contributing to Accidents Resulting in No Injuries or Fatalities (bar chart)
--   - Accidents Resulting in No Injuries or Fatalities Heatmap
--   - Accident Map
--
-- The same visualizations are used for P5, with the analysis focused on
-- accidents resulting in injuries:
--   - Percentage of Accidents Resulting in Injuries Over Time (line chart)
--   - Top 5 Vehicle Types Involved in Accidents Resulting in Injuries (column chart)
--   - Top 5 Factors Contributing to Accidents Resulting in Injuries (bar chart)
--   - Accidents Resulting in Injuries Heatmap
--   - Accident Map
--
-- The same visualizations are used for P6, with the analysis focused on
-- accidents resulting in fatalities:
--   - Percentage of Accidents Resulting in Fatalities Over Time (line chart)
--   - Top 5 Vehicle Types Involved in Accidents Resulting in Fatalities (column chart)
--   - Top 5 Factors Contributing to Accidents Resulting in Fatalities (bar chart)
--   - Accidents Resulting in Fatalities Heatmap
--   - Accident Map
--
-- The resulting views provide a consistent data structure for comparing
-- accident characteristics across the three severity categories while
-- maintaining the same dashboard layout and analytical approach.
-- -----------------------------------------------------------------------------------------------------------------

-- Creates a view combining all five contributing factor columns into a single FACTOR column.
CREATE OR REPLACE VIEW P4P5P6_FACTOR_VW AS
SELECT COLLISION_ID, CRASH_DATE, BOROUGH, CONTRIBUTING_FACTOR_VEHICLE_1 AS 'FACTOR', ACC_WO, ACC_W_INJURED, ACC_W_KILLED FROM ACCIDENTS
UNION ALL
SELECT COLLISION_ID, CRASH_DATE, BOROUGH, CONTRIBUTING_FACTOR_VEHICLE_2, ACC_WO, ACC_W_INJURED, ACC_W_KILLED FROM ACCIDENTS
UNION ALL
SELECT COLLISION_ID, CRASH_DATE, BOROUGH, CONTRIBUTING_FACTOR_VEHICLE_3, ACC_WO, ACC_W_INJURED, ACC_W_KILLED FROM ACCIDENTS
UNION ALL
SELECT COLLISION_ID, CRASH_DATE, BOROUGH, CONTRIBUTING_FACTOR_VEHICLE_4, ACC_WO, ACC_W_INJURED, ACC_W_KILLED FROM ACCIDENTS
UNION ALL
SELECT COLLISION_ID, CRASH_DATE, BOROUGH, CONTRIBUTING_FACTOR_VEHICLE_5, ACC_WO, ACC_W_INJURED, ACC_W_KILLED FROM ACCIDENTS;

-- Creates a view combining all five vehicle type columns into a single VEHICLE column.
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

-- Creates a view calculating monthly percentages of accidents by outcome.
CREATE OR REPLACE VIEW P4P5P6_RATE_VW AS
SELECT
    COLLISION_ID,
    CRASH_DATE,
    SUM(ACC_WO) OVER monthly / COUNT(*) OVER monthly AS NOT_INJURED_RATE,
    SUM(ACC_W_INJURED) OVER monthly / COUNT(*) OVER monthly AS INJURED_RATE,
    SUM(ACC_W_KILLED) OVER monthly / COUNT(*) OVER monthly AS KILLED_RATE
FROM accidents
WHERE CRASH_DATE IS NOT NULL
WINDOW monthly AS (
    PARTITION BY YEAR(CRASH_DATE), MONTH(CRASH_DATE));

-- Creates a view containing accident severity indicators for map visualizations.
CREATE OR REPLACE VIEW P4P5P6_MAP_VW AS
SELECT
    COLLISION_ID,
    CRASH_DATE,
    BOROUGH,
    ACC_WO, 
    ACC_W_INJURED, 
    ACC_W_KILLED
FROM accidents;

-- Creates a view containing day and time information for the accident heatmap.
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

-- Creates a view containing accident severity indicators and street information.
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