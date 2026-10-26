-- 1. Creation of Database and Tables with Appropriate Data Types
-- -----------------------------------------------------------------------------------------------------------------
-- Creates the WEBINAR_NYC_ACCIDENTS database and the main accidents table.
-- The table stores accident-level information including:
--   - date and time of occurrence,
--   - geographic and street-level location,
--   - numbers of injuries and fatalities by road-user type,
--   - reported contributing factors,
--   - vehicle types involved,
--   - unique collision identifier.
-- Appropriate SQL data types are assigned to each column according to the
-- nature of the stored data.
-- -----------------------------------------------------------------------------------------------------------------

CREATE DATABASE NYC_ACCIDENTS 				-- Creates the NYC_ACCIDENTS database.
CHARACTER SET utf8mb4 								-- Sets UTF-8 character encoding for the database.
COLLATE utf8mb4_unicode_ci; 					-- Sets Unicode collation for text comparison and sorting.

USE NYC_ACCIDENTS;						        -- Selects the NYC_ACCIDENTS database as the active database.

CREATE TABLE accidents( 							-- Creates the accidents table.
CRASH_DATE DATE,
CRASH_TIME TIME,
BOROUGH VARCHAR(255),
ZIP_CODE VARCHAR(255),
LATITUDE DECIMAL(10, 7),
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
COLLISION_ID BIGINT,
VEHICLE_TYPE_CODE_1 VARCHAR(255),
VEHICLE_TYPE_CODE_2 VARCHAR(255),
VEHICLE_TYPE_CODE_3 VARCHAR(255),
VEHICLE_TYPE_CODE_4 VARCHAR(255),
VEHICLE_TYPE_CODE_5 VARCHAR(255)
);
