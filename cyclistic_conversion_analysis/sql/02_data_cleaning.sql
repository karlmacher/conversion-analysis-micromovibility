-- ==========================================================
-- PROYECT: Cyclistic Data Analysis
-- FILE: 02_data_cleaning.sql
-- DESCRIPTION: standarize user type, formating temporal fields and filtering data quality
-- ==========================================================

CREATE OR REPLACE TABLE `project-941e89dd-df86-4a8c-ba4.Cyclistic.cyclistic_12_months_clean` AS
SELECT 
  ride_id,
  -- 1. Standardize user type
  CASE 
    WHEN LOWER(member_casual) IN ('subscriber', 'member') THEN 'member'
    WHEN LOWER(member_casual) IN ('customer', 'casual') THEN 'casual'
    ELSE member_casual
  END AS member_casual,
  started_at,
  ended_at,
  -- 2. Derive ride length duration
  TIMESTAMP_DIFF(ended_at, started_at, MINUTE) AS ride_length_minutes,
  TIMESTAMP_DIFF(ended_at, started_at, SECOND) AS ride_length_seconds,
  -- 3. Extract temporal fields
  EXTRACT(DAYOFWEEK FROM started_at) AS day_of_week, -- 1=Sunday, 7=Saturday
  FORMAT_TIMESTAMP('%A', started_at) AS day_name,
  EXTRACT(MONTH FROM started_at) AS month,
  FORMAT_TIMESTAMP('%B', started_at) AS month_name,
  EXTRACT(YEAR FROM started_at) AS year,
  -- 4. Station details
  start_station_name,
  end_station_name
FROM `project-941e89dd-df86-4a8c-ba4.Cyclistic.cyclistic_12_months_raw`
-- 5. Data quality filters
WHERE 
  started_at IS NOT NULL 
  AND ended_at IS NOT NULL
  AND ended_at > started_at
  AND TIMESTAMP_DIFF(ended_at, started_at, MINUTE) >= 1   -- Exclude < 1 min (false starts)
  AND TIMESTAMP_DIFF(ended_at, started_at, HOUR) < 24    -- Exclude >= 24 hrs (maintenance/loss)
  AND start_station_name IS NOT NULL
  AND end_station_name IS NOT NULL;

--6. Verfication
SELECT 
  member_casual,
  COUNT(*) AS total_trips,
  ROUND(AVG(ride_length_minutes), 2) AS avg_duration_min
FROM `project-941e89dd-df86-4a8c-ba4.Cyclistic.cyclistic_12_months_clean`
GROUP BY member_casual;