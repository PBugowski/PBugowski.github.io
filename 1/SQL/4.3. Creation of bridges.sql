-- 4.3. Creation of Vehicle Bridge Views
-- -----------------------------------------------------------------------------------------------------------------
-- Creates eight views that associate collision identifiers with vehicle
-- types from the five VEHICLE_TYPE_CODE fields in accidents.
-- Each view returns two columns: COLLISION_ID and VEHICLE_TYPE.
--
-- Separate view names are provided for the following analytical datasets:
--   - P1_VW, P2_VW and P3_VW,
--   - P4P5P6_FACTOR_VW and P4P5P6_HEAT_VW,
--   - P4P5P6_MAP_VW and P4P5P6_STREET_VW,
--   - P4P5P6_VEHICLE_VW.
--
-- All eight definitions read accidents directly and return the same logical
-- mapping. Their names distinguish the intended point of use; the scripts
-- do not join the corresponding analytical views or create constraints.
-- There is no separate bridge for P4P5P6_RATE_VW in this set.
--
-- NO TYPE entries are excluded from each source field. Other categories,
-- including OTHER, remain. An accident can contribute up to five rows.
-- If the same type appears in several slots, the collision/type pair is
-- repeated rather than deduplicated. Counting bridge rows therefore counts
-- vehicle-slot associations, not distinct accidents.
--
-- Use COLLISION_ID when relating the mapping to accident-level records.
-- A direct join can multiply those records, so collision counts must account
-- for repeated matches. Repeated slot values do not become additional
-- collisions. These views read current table contents without storing copies.
--
-- Run this script after vehicle normalization in the intended database.
-- No source records are updated by these view definitions.
-- -----------------------------------------------------------------------------------------------------------------


-- Active database choice
-- -----------------------------------------------------------------------------------------------------------------
USE NYC_ACCIDENTS;                                                          		 -- Selects the active database for subsequent statements.


-- Vehicle Mapping for P1_VW
-- -----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW BRIDGE_VEHICLE_P1_VW AS
SELECT COLLISION_ID, VEHICLE_TYPE_CODE_1 AS VEHICLE_TYPE                             -- COLLISION_ID links each vehicle association back to the original accident record.
FROM accidents
WHERE LOWER(VEHICLE_TYPE_CODE_1) <> 'no type'
UNION ALL
SELECT COLLISION_ID, VEHICLE_TYPE_CODE_2
FROM accidents
WHERE LOWER(VEHICLE_TYPE_CODE_2) <> 'no type'
UNION ALL
SELECT COLLISION_ID, VEHICLE_TYPE_CODE_3
FROM accidents
WHERE LOWER(VEHICLE_TYPE_CODE_3) <> 'no type'
UNION ALL
SELECT COLLISION_ID, VEHICLE_TYPE_CODE_4
FROM accidents
WHERE LOWER(VEHICLE_TYPE_CODE_4) <> 'no type'
UNION ALL
SELECT COLLISION_ID, VEHICLE_TYPE_CODE_5
FROM accidents
WHERE LOWER(VEHICLE_TYPE_CODE_5) <> 'no type';


-- Vehicle Mapping for P2_VW
-- -----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW BRIDGE_VEHICLE_P2_VW AS
SELECT COLLISION_ID, VEHICLE_TYPE_CODE_1 AS VEHICLE_TYPE
FROM accidents
WHERE LOWER(VEHICLE_TYPE_CODE_1) <> 'no type'
UNION ALL
SELECT COLLISION_ID, VEHICLE_TYPE_CODE_2
FROM accidents
WHERE LOWER(VEHICLE_TYPE_CODE_2) <> 'no type'
UNION ALL
SELECT COLLISION_ID, VEHICLE_TYPE_CODE_3
FROM accidents
WHERE LOWER(VEHICLE_TYPE_CODE_3) <> 'no type'
UNION ALL
SELECT COLLISION_ID, VEHICLE_TYPE_CODE_4
FROM accidents
WHERE LOWER(VEHICLE_TYPE_CODE_4) <> 'no type'
UNION ALL
SELECT COLLISION_ID, VEHICLE_TYPE_CODE_5
FROM accidents
WHERE LOWER(VEHICLE_TYPE_CODE_5) <> 'no type';


-- Vehicle Mapping for P3_VW
-- -----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW BRIDGE_VEHICLE_P3_VW AS
SELECT COLLISION_ID, VEHICLE_TYPE_CODE_1 AS VEHICLE_TYPE
FROM accidents
WHERE LOWER(VEHICLE_TYPE_CODE_1) <> 'no type'
UNION ALL
SELECT COLLISION_ID, VEHICLE_TYPE_CODE_2
FROM accidents
WHERE LOWER(VEHICLE_TYPE_CODE_2) <> 'no type'
UNION ALL
SELECT COLLISION_ID, VEHICLE_TYPE_CODE_3
FROM accidents
WHERE LOWER(VEHICLE_TYPE_CODE_3) <> 'no type'
UNION ALL
SELECT COLLISION_ID, VEHICLE_TYPE_CODE_4
FROM accidents
WHERE LOWER(VEHICLE_TYPE_CODE_4) <> 'no type'
UNION ALL
SELECT COLLISION_ID, VEHICLE_TYPE_CODE_5
FROM accidents
WHERE LOWER(VEHICLE_TYPE_CODE_5) <> 'no type';


-- Vehicle Mapping for P4P5P6_FACTOR_VW
-- -----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW BRIDGE_VEHICLE_P4P5P6_FACTOR_VW AS
SELECT COLLISION_ID, VEHICLE_TYPE_CODE_1 AS VEHICLE_TYPE
FROM accidents
WHERE LOWER(VEHICLE_TYPE_CODE_1) <> 'no type'
UNION ALL
SELECT COLLISION_ID, VEHICLE_TYPE_CODE_2
FROM accidents
WHERE LOWER(VEHICLE_TYPE_CODE_2) <> 'no type'
UNION ALL
SELECT COLLISION_ID, VEHICLE_TYPE_CODE_3
FROM accidents
WHERE LOWER(VEHICLE_TYPE_CODE_3) <> 'no type'
UNION ALL
SELECT COLLISION_ID, VEHICLE_TYPE_CODE_4
FROM accidents
WHERE LOWER(VEHICLE_TYPE_CODE_4) <> 'no type'
UNION ALL
SELECT COLLISION_ID, VEHICLE_TYPE_CODE_5
FROM accidents
WHERE LOWER(VEHICLE_TYPE_CODE_5) <> 'no type';


-- Vehicle Mapping for P4P5P6_HEAT_VW
-- -----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW BRIDGE_VEHICLE_P4P5P6_HEAT_VW AS
SELECT COLLISION_ID, VEHICLE_TYPE_CODE_1 AS VEHICLE_TYPE
FROM accidents
WHERE LOWER(VEHICLE_TYPE_CODE_1) <> 'no type'
UNION ALL
SELECT COLLISION_ID, VEHICLE_TYPE_CODE_2
FROM accidents
WHERE LOWER(VEHICLE_TYPE_CODE_2) <> 'no type'
UNION ALL
SELECT COLLISION_ID, VEHICLE_TYPE_CODE_3
FROM accidents
WHERE LOWER(VEHICLE_TYPE_CODE_3) <> 'no type'
UNION ALL
SELECT COLLISION_ID, VEHICLE_TYPE_CODE_4
FROM accidents
WHERE LOWER(VEHICLE_TYPE_CODE_4) <> 'no type'
UNION ALL
SELECT COLLISION_ID, VEHICLE_TYPE_CODE_5
FROM accidents
WHERE LOWER(VEHICLE_TYPE_CODE_5) <> 'no type';


-- Vehicle Mapping for P4P5P6_MAP_VW
-- -----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW BRIDGE_VEHICLE_P4P5P6_MAP_VW AS
SELECT COLLISION_ID, VEHICLE_TYPE_CODE_1 AS VEHICLE_TYPE
FROM accidents
WHERE LOWER(VEHICLE_TYPE_CODE_1) <> 'no type'
UNION ALL
SELECT COLLISION_ID, VEHICLE_TYPE_CODE_2
FROM accidents
WHERE LOWER(VEHICLE_TYPE_CODE_2) <> 'no type'
UNION ALL
SELECT COLLISION_ID, VEHICLE_TYPE_CODE_3
FROM accidents
WHERE LOWER(VEHICLE_TYPE_CODE_3) <> 'no type'
UNION ALL
SELECT COLLISION_ID, VEHICLE_TYPE_CODE_4
FROM accidents
WHERE LOWER(VEHICLE_TYPE_CODE_4) <> 'no type'
UNION ALL
SELECT COLLISION_ID, VEHICLE_TYPE_CODE_5
FROM accidents
WHERE LOWER(VEHICLE_TYPE_CODE_5) <> 'no type';


-- Vehicle Mapping for P4P5P6_STREET_VW
-- -----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW BRIDGE_VEHICLE_P4P5P6_STREET_VW AS
SELECT COLLISION_ID, VEHICLE_TYPE_CODE_1 AS VEHICLE_TYPE
FROM accidents
WHERE LOWER(VEHICLE_TYPE_CODE_1) <> 'no type'
UNION ALL
SELECT COLLISION_ID, VEHICLE_TYPE_CODE_2
FROM accidents
WHERE LOWER(VEHICLE_TYPE_CODE_2) <> 'no type'
UNION ALL
SELECT COLLISION_ID, VEHICLE_TYPE_CODE_3
FROM accidents
WHERE LOWER(VEHICLE_TYPE_CODE_3) <> 'no type'
UNION ALL
SELECT COLLISION_ID, VEHICLE_TYPE_CODE_4
FROM accidents
WHERE LOWER(VEHICLE_TYPE_CODE_4) <> 'no type'
UNION ALL
SELECT COLLISION_ID, VEHICLE_TYPE_CODE_5
FROM accidents
WHERE LOWER(VEHICLE_TYPE_CODE_5) <> 'no type';


-- Vehicle Mapping for P4P5P6_VEHICLE_VW
-- -----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW BRIDGE_VEHICLE_P4P5P6_VEHICLE_VW AS
SELECT COLLISION_ID, VEHICLE_TYPE_CODE_1 AS VEHICLE_TYPE
FROM accidents
WHERE LOWER(VEHICLE_TYPE_CODE_1) <> 'no type'
UNION ALL
SELECT COLLISION_ID, VEHICLE_TYPE_CODE_2
FROM accidents
WHERE LOWER(VEHICLE_TYPE_CODE_2) <> 'no type'
UNION ALL
SELECT COLLISION_ID, VEHICLE_TYPE_CODE_3
FROM accidents
WHERE LOWER(VEHICLE_TYPE_CODE_3) <> 'no type'
UNION ALL
SELECT COLLISION_ID, VEHICLE_TYPE_CODE_4
FROM accidents
WHERE LOWER(VEHICLE_TYPE_CODE_4) <> 'no type'
UNION ALL
SELECT COLLISION_ID, VEHICLE_TYPE_CODE_5
FROM accidents
WHERE LOWER(VEHICLE_TYPE_CODE_5) <> 'no type';
