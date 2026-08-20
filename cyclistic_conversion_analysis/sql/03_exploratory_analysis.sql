-- ==========================================================
-- PROYECT: Cyclistic Data Analysis
-- FILE: 03_exploratory_analysis.sql
-- DESCRIPTION: Analyze AVG Metrics, volume by month, volume by day and top 10 departure stations
-- ==========================================================

-- Query 1: statistical summary of ride duration

SELECT 
  member_casual,
  ROUND(AVG(ride_length_minutes), 2) AS avg_duration_min,
  APPROX_QUANTILES(ride_length_minutes, 100)[OFFSET(50)] AS median_duration_min,
  MAX(ride_length_minutes) AS max_duration_min,
  MIN(ride_length_minutes) AS min_duration_min
FROM `project-941e89dd-df86-4a8c-ba4.Cyclistic.cyclistic_12_months_clean`
GROUP BY member_casual;

-- Query 2: day-of-week behavior workday vs. weekend

SELECT 
  member_casual,
  day_of_week,
  day_name,
  COUNT(*) AS total_trips,
  ROUND(AVG(ride_length_minutes), 2) AS avg_duration_min
FROM `project-941e89dd-df86-4a8c-ba4.Cyclistic.cyclistic_12_months_clean`
GROUP BY member_casual, day_of_week, day_name
ORDER BY member_casual, day_of_week;

-- Query 3: monthly analysis

SELECT 
  member_casual,
  year,
  month,
  month_name,
  COUNT(*) AS total_trips,
  ROUND(AVG(ride_length_minutes), 2) AS avg_duration_min
FROM `project-941e89dd-df86-4a8c-ba4.Cyclistic.cyclistic_12_months_clean`
GROUP BY member_casual, year, month, month_name
ORDER BY year, month, member_casual;

-- Query 4: top 10 departure stations for casual riders

SELECT 
  member_casual,
  start_station_name,
  COUNT(*) AS total_departures
FROM `project-941e89dd-df86-4a8c-ba4.Cyclistic.cyclistic_12_months_clean`
WHERE member_casual = 'casual'
GROUP BY member_casual, start_station_name
ORDER BY total_departures DESC
LIMIT 10;