-- 1. Creation of Database and Table with Appropriate Data Types
-- -----------------------------------------------------------------------------------------------------------------
-- Creates the NYC_ACCIDENTS database and the accidents table.
-- Each imported row stores one collision record, including:
--   - crash date and time,
--   - borough, coordinates and street names,
--   - injury and fatality counts by road-user type,
--   - five contributing-factor fields and five vehicle-type fields,
--   - the source collision identifier.
--
-- DATE and TIME store the calendar date and time separately. Coordinates use
-- DECIMAL(10,7), casualty counts use INT, and COLLISION_ID uses BIGINT.
-- VARCHAR columns retain location and category labels, including ZIP codes.
-- The table does not declare a primary key, a unique constraint or foreign
-- keys, so duplicate collision identifiers are not prevented by its schema.
--
-- The scripts use MySQL 8.0 features, including spatial functions, window
-- functions and a recursive common table expression. Execute them in order:
--   1. Database & Table
--   2. Import of data
--   3.1. Normalization of data
--   3.2. Multipolygons
--   4.1. Creation of reporting views
--   4.2. Creation of dimension views
--   4.3. Creation of bridges
--
-- This script initializes a new database. 
-- -----------------------------------------------------------------------------------------------------------------


-- Database Setup
-- -----------------------------------------------------------------------------------------------------------------
CREATE DATABASE NYC_ACCIDENTS               		                                 -- Creates the database used to store the collision records.
CHARACTER SET utf8mb4                                                                -- Sets UTF-8 character encoding.
COLLATE utf8mb4_unicode_ci;                                                          -- Defines case-insensitive Unicode text comparison and sorting.


USE NYC_ACCIDENTS;                                                          		 -- Selects the active database for subsequent statements.


-- Accident Records
-- -----------------------------------------------------------------------------------------------------------------
CREATE TABLE accidents(                                                              -- Defines the source table and its column types.
CRASH_DATE DATE,
CRASH_TIME TIME,
BOROUGH VARCHAR(255),
ZIP_CODE VARCHAR(255),
LATITUDE DECIMAL(10, 7),                                                             -- Stores coordinates with seven digits after the decimal point.
LONGITUDE DECIMAL(10, 7),
LOCATION VARCHAR(255),
ON_STREET_NAME VARCHAR(255),
CROSS_STREET_NAME VARCHAR(255),
OFF_STREET_NAME VARCHAR(255),
NUMBER_OF_PERSONS_INJURED INT,
NUMBER_OF_PERSONS_KILLED INT,
NUMBER_OF_PEDESTRIANS_INJURED INT,
NUMBER_OF_PEDESTRIANS_KILLED INT,
NUMBER_OF_CYCLIST_INJURED INT,
NUMBER_OF_CYCLIST_KILLED INT,
NUMBER_OF_MOTORIST_INJURED INT,
NUMBER_OF_MOTORIST_KILLED INT,
CONTRIBUTING_FACTOR_VEHICLE_1 VARCHAR(255),
CONTRIBUTING_FACTOR_VEHICLE_2 VARCHAR(255),
CONTRIBUTING_FACTOR_VEHICLE_3 VARCHAR(255),
CONTRIBUTING_FACTOR_VEHICLE_4 VARCHAR(255),
CONTRIBUTING_FACTOR_VEHICLE_5 VARCHAR(255),
COLLISION_ID BIGINT,                                                                 -- Stores the source identifier without enforcing uniqueness.
VEHICLE_TYPE_CODE_1 VARCHAR(255),
VEHICLE_TYPE_CODE_2 VARCHAR(255),
VEHICLE_TYPE_CODE_3 VARCHAR(255),
VEHICLE_TYPE_CODE_4 VARCHAR(255),
VEHICLE_TYPE_CODE_5 VARCHAR(255)
);
