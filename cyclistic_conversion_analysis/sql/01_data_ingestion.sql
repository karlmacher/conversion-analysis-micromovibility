-- ==========================================================
-- PROYECT: Cyclistic Data Analysis
-- FILE: 01_data_ingestion.sql
-- DESCRIPTION: ingestión and creation cyclistic_12_months_raw table
-- ==========================================================

-- Ingesting quarterly datasets into raw staging tables
LOAD DATA OVERWRITE `project-941e89dd-df86-4a8c-ba4.Cyclistic.q1_2019`
FROM FILES (
  format = 'CSV',
  uris = ['gs://bucket-cyclistic/cyclistic_folder/divvy_trips_2019_q1.csv'],
  skip_leading_rows = 1,
  allow_quoted_newlines = TRUE
);

-- Note: Repeat LOAD DATA command for Q2 2019, Q3 2019, and Q4 2019 tables

CREATE OR REPLACE TABLE `project-941e89dd-df86-4a8c-ba4.Cyclistic.cyclistic_12_months_raw` AS

-- 1. Trimestre 2 2019 (Q2)
SELECT 
  CAST(`01 - Rental Details Rental Id` AS STRING) AS ride_id,
  CAST(`01 - Rental Details Local Start Time` AS TIMESTAMP) AS started_at,
  CAST(`01 - Rental Details Local End Time` AS TIMESTAMP) AS ended_at,
  `03 - Rental Start Station Name` AS start_station_name,
  `02 - Rental End Station Name` AS end_station_name,
  `User Type` AS member_casual
FROM `project-941e89dd-df86-4a8c-ba4.Cyclistic.q2_2019`

UNION ALL

-- 2. Trimestre 3 2019 (Q3)
SELECT 
  CAST(trip_id AS STRING) AS ride_id,
  CAST(start_time AS TIMESTAMP) AS started_at,
  CAST(end_time AS TIMESTAMP) AS ended_at,
  from_station_name AS start_station_name,
  to_station_name AS end_station_name,
  usertype AS member_casual
FROM `project-941e89dd-df86-4a8c-ba4.Cyclistic.q3_2019`

UNION ALL

-- 3. Trimestre 4 2019 (Q4)
SELECT 
  CAST(trip_id AS STRING) AS ride_id,
  CAST(start_time AS TIMESTAMP) AS started_at,
  CAST(end_time AS TIMESTAMP) AS ended_at,
  from_station_name AS start_station_name,
  to_station_name AS end_station_name,
  usertype AS member_casual
FROM `project-941e89dd-df86-4a8c-ba4.Cyclistic.q4_2019`

UNION ALL

-- 4. Trimestre 1 2020 (Q1 2020)
SELECT 
  CAST(ride_id AS STRING) AS ride_id,
  CAST(started_at AS TIMESTAMP) AS started_at,
  CAST(ended_at AS TIMESTAMP) AS ended_at,
  start_station_name,
  end_station_name,
  member_casual
FROM `project-941e89dd-df86-4a8c-ba4.Cyclistic.q1_2020`;