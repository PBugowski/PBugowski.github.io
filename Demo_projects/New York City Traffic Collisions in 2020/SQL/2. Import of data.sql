-- 2. Importing Accident Data from CSV
-- -----------------------------------------------------------------------------------------------------------------
-- Imports the 29 source columns from the specified NYC.csv file into the
-- accidents table in the active database. The import process:
--   - enables local file loading on the server,
--   - reads comma-separated values with optional double quotation marks,
--   - skips the CSV header,
--   - holds source text in user variables before assigning table columns,
--   - converts empty strings into NULL values,
--   - trims the date and time and parses the time explicitly.
--
-- The variable list follows the source CSV column order. CRASH_DATE is
-- assigned from trimmed text and relies on conversion to the DATE column;
-- there is no explicit date-format parser for that field. CRASH_TIME uses
-- the %H:%i:%s format. Other fields are not trimmed, so whitespace-only
-- values are not handled as empty strings by those assignments.
--
-- The file path is a relative path within the repository. Adjust
-- it to the actual source location before running the import. Local loading
-- must also be enabled by the client, and changing the global server setting
-- requires the corresponding MySQL privileges.
--
-- Run the import once into the empty accidents table created by script 1.
-- The table has no uniqueness constraint, so another import can append the
-- same records again. 
-- -----------------------------------------------------------------------------------------------------------------


-- Active database choice
-- -----------------------------------------------------------------------------------------------------------------
USE NYC_ACCIDENTS;                                                          		 -- Selects the active database for subsequent statements.


-- Local File Loading
-- -----------------------------------------------------------------------------------------------------------------
SET GLOBAL local_infile = 1;                                                         -- Enables local file loading on the server.


-- Accident Data Import
-- -----------------------------------------------------------------------------------------------------------------
LOAD DATA LOCAL INFILE 'Raw Data/NYC.csv'                      										-- Reads the CSV from the specified path on the client computer.
INTO TABLE accidents                                                                 				-- Specifies the destination table.
FIELDS TERMINATED BY ','                                                             				-- Uses commas to separate source columns.
OPTIONALLY ENCLOSED BY '"'                                                           				-- Allows field values to be enclosed in double quotation marks.
LINES TERMINATED BY '\n'                                                            			 	-- Uses newline characters to separate source records.
IGNORE 1 ROWS                                                                        				-- Skips the column names in the first row.
(@CRASH_DATE, @CRASH_TIME, @BOROUGH, @ZIP_CODE, @LATITUDE, @LONGITUDE, @LOCATION, @ON_STREET_NAME,	-- Reads source fields into variables before assigning table columns.
@CROSS_STREET_NAME, @OFF_STREET_NAME, @NUMBER_OF_PERSONS_INJURED, @NUMBER_OF_PERSONS_KILLED,
@NUMBER_OF_PEDESTRIANS_INJURED, @NUMBER_OF_PEDESTRIANS_KILLED, @NUMBER_OF_CYCLIST_INJURED, @NUMBER_OF_CYCLIST_KILLED,
@NUMBER_OF_MOTORIST_INJURED, @NUMBER_OF_MOTORIST_KILLED, @CONTRIBUTING_FACTOR_VEHICLE_1, @CONTRIBUTING_FACTOR_VEHICLE_2,
@CONTRIBUTING_FACTOR_VEHICLE_3, @CONTRIBUTING_FACTOR_VEHICLE_4, @CONTRIBUTING_FACTOR_VEHICLE_5, @COLLISION_ID,
@VEHICLE_TYPE_CODE_1, @VEHICLE_TYPE_CODE_2, @VEHICLE_TYPE_CODE_3, @VEHICLE_TYPE_CODE_4, @VEHICLE_TYPE_CODE_5)
SET
    CRASH_DATE = NULLIF(TRIM(@CRASH_DATE), ''),                                     				-- TRIM removes surrounding spaces; NULLIF converts empty text to NULL before DATE conversion.
    CRASH_TIME = STR_TO_DATE(NULLIF(TRIM(@CRASH_TIME), ''), '%H:%i:%s'),             				-- STR_TO_DATE parses the time using hours, minutes and seconds.
    BOROUGH = NULLIF(@BOROUGH, ''),
    ZIP_CODE = NULLIF(@ZIP_CODE, ''),
    LATITUDE = NULLIF(@LATITUDE, ''),
    LONGITUDE = NULLIF(@LONGITUDE, ''),
    LOCATION = NULLIF(@LOCATION, ''),
    ON_STREET_NAME = NULLIF(@ON_STREET_NAME, ''),
    CROSS_STREET_NAME = NULLIF(@CROSS_STREET_NAME, ''),
    OFF_STREET_NAME = NULLIF(@OFF_STREET_NAME, ''),
    NUMBER_OF_PERSONS_INJURED = NULLIF(@NUMBER_OF_PERSONS_INJURED, ''),
    NUMBER_OF_PERSONS_KILLED = NULLIF(@NUMBER_OF_PERSONS_KILLED, ''),
    NUMBER_OF_PEDESTRIANS_INJURED = NULLIF(@NUMBER_OF_PEDESTRIANS_INJURED, ''),
    NUMBER_OF_PEDESTRIANS_KILLED = NULLIF(@NUMBER_OF_PEDESTRIANS_KILLED, ''),
    NUMBER_OF_CYCLIST_INJURED = NULLIF(@NUMBER_OF_CYCLIST_INJURED, ''),
    NUMBER_OF_CYCLIST_KILLED = NULLIF(@NUMBER_OF_CYCLIST_KILLED, ''),
    NUMBER_OF_MOTORIST_INJURED = NULLIF(@NUMBER_OF_MOTORIST_INJURED, ''),
    NUMBER_OF_MOTORIST_KILLED = NULLIF(@NUMBER_OF_MOTORIST_KILLED, ''),
    CONTRIBUTING_FACTOR_VEHICLE_1 = NULLIF(@CONTRIBUTING_FACTOR_VEHICLE_1, ''),
    CONTRIBUTING_FACTOR_VEHICLE_2 = NULLIF(@CONTRIBUTING_FACTOR_VEHICLE_2, ''),
    CONTRIBUTING_FACTOR_VEHICLE_3 = NULLIF(@CONTRIBUTING_FACTOR_VEHICLE_3, ''),
    CONTRIBUTING_FACTOR_VEHICLE_4 = NULLIF(@CONTRIBUTING_FACTOR_VEHICLE_4, ''),
    CONTRIBUTING_FACTOR_VEHICLE_5 = NULLIF(@CONTRIBUTING_FACTOR_VEHICLE_5, ''),
    COLLISION_ID = NULLIF(@COLLISION_ID, ''),
    VEHICLE_TYPE_CODE_1 = NULLIF(@VEHICLE_TYPE_CODE_1, ''),
    VEHICLE_TYPE_CODE_2 = NULLIF(@VEHICLE_TYPE_CODE_2, ''),
    VEHICLE_TYPE_CODE_3 = NULLIF(@VEHICLE_TYPE_CODE_3, ''),
    VEHICLE_TYPE_CODE_4 = NULLIF(@VEHICLE_TYPE_CODE_4, ''),
    VEHICLE_TYPE_CODE_5 = NULLIF(@VEHICLE_TYPE_CODE_5, '');
