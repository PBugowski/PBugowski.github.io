-- 2. Importing and Preprocessing Accident Data from CSV
-- -----------------------------------------------------------------------------------------------------------------
-- Imports the NYC accident dataset from a local CSV file into the accidents table.
-- The import process:
--   - enables local file loading,
--   - reads data from the NYC.csv file,
--   - uses comma-separated values with optional double-quote delimiters,
--   - skips the CSV header row,
--   - temporarily stores imported values in user variables,
--   - converts date and time values into appropriate MySQL formats,
--   - converts empty strings into NULL values.
-- Data is cleaned and transformed during the import before being inserted into
-- the accidents table.
-- -----------------------------------------------------------------------------------------------------------------

SET GLOBAL local_infile = 1; 															-- Enables loading local files into MySQL.

LOAD DATA LOCAL INFILE 'C:/Users/pbugo/Desktop/Webinar/NYC.csv' 						-- Specifies the local CSV file containing the NYC accident data.
INTO TABLE accidents 																	-- Specifies the accidents table as the destination for the imported data.
FIELDS TERMINATED BY ',' 																-- Specifies that columns in the CSV file are separated by commas.
OPTIONALLY ENCLOSED BY '"' 																-- Specifies that text fields may optionally be enclosed in double quotation marks.
LINES TERMINATED BY '\n' 																-- Specifies that individual records in the CSV file are separated by newline characters.
IGNORE 1 ROWS 																			-- Skips the first row of the CSV file because it contains column headers.
(@CRASH_DATE, @CRASH_TIME, @BOROUGH, @ZIP_CODE, @LATITUDE, @LONGITUDE, @LOCATION, @ON_STREET_NAME, 							-- Stores the imported CSV values in user-defined variables before they are assigned to table columns.
@CROSS_STREET_NAME, @OFF_STREET_NAME, @NUMBER_OF_PERSONS_INJURED, @NUMBER_OF_PERSONS_KILLED, 								-- The variables correspond to the columns in the source CSV file.
@NUMBER_OF_PEDESTRIANS_INJURED, @NUMBER_OF_PEDESTRIANS_KILLED, @NUMBER_OF_CYCLIST_INJURED, @NUMBER_OF_CYCLIST_KILLED, 
@NUMBER_OF_MOTORIST_INJURED, @NUMBER_OF_MOTORIST_KILLED, @CONTRIBUTING_FACTOR_VEHICLE_1, @CONTRIBUTING_FACTOR_VEHICLE_2, 
@CONTRIBUTING_FACTOR_VEHICLE_3, @CONTRIBUTING_FACTOR_VEHICLE_4, @CONTRIBUTING_FACTOR_VEHICLE_5, @COLLISION_ID, 
@VEHICLE_TYPE_CODE_1, @VEHICLE_TYPE_CODE_2, @VEHICLE_TYPE_CODE_3, @VEHICLE_TYPE_CODE_4, @VEHICLE_TYPE_CODE_5)
SET																						-- Defines how the imported variables are transformed and assigned to the corresponding table columns.
    CRASH_DATE = NULLIF(TRIM(@CRASH_DATE), ''),											-- STR_TO_DATE converts the date from the CSV text format into the MySQL DATE format. 
	CRASH_TIME = STR_TO_DATE(NULLIF(TRIM(@CRASH_TIME), ''), '%H:%i:%s'),				-- TRIM removes unnecessary spaces
	BOROUGH = NULLIF(@BOROUGH, ''),														-- NULLIF converts empty strings into NULL values.
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