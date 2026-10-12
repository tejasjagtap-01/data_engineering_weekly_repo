SELECT * FROM API_race_results 
LIMIT 10

SELECT * FROM race_results 
LIMIT 10

SELECT * FROM lap_times 
LIMIT 10

--BAsed on race_results
--Easy — SELECT & WHERE

--1. Get all race results for a single driver (pick any driverRef you remember from earlier output, e.g. 'max_verstappen').
SELECT * FROM race_results
WHERE driver_full_name = 'Lewis Hamilton'


--2. Get all results where points is greater than 0 — i.e., every result that scored points.
SELECT * FROM race_results
WHERE points > 0


--3. Get all results from a specific year (if your table has one) or raceId — just a straightforward filter.
SELECT * FROM race_results
WHERE year = 2024


--4. Get only 5 specific columns (not SELECT *) — e.g. driver_full_name, points, positionn name, name_team.
SELECT driver_full_name, points, position, name, name_team
FROM race_results
WHERE "positionOrder" <= 3
AND year = 2024


--5. Get only 3 specific columns (not SELECT *) — e.g. driverRef, points, position — for one race.
SELECT "driverRef", points, position
FROM race_results
WHERE "raceId" = 1120


--Medium — GROUP BY


--6. Count how many race results exist per driverRef — who has the most entries in your table?
--Easy Approach
SELECT 
    "driverRef",
    COUNT(*) AS entries
FROM race_results
GROUP BY "driverRef"
ORDER BY entries DESC;


--Complicated Approach
WITH cte AS 
(SELECT 
	driver_full_name,
	COUNT(*) AS entries
FROM race_results
GROUP BY driver_full_name
)
SELECT 
driver_full_name,
entries	
FROM cte
ORDER BY entries DESC


--7. Find the total points scored by each constructorRef — basically a season standings calculation.
SELECT 
    "constructorRef",
    SUM(points) AS total_points
FROM race_results
GROUP BY "constructorRef"
ORDER BY total_points DESC;


--8. Find the average points per driverRef — who scores highest on average, not just total?
SELECT 
    "driverRef",
    ROUND(AVG(points)::numeric, 2) AS avg_points
FROM race_results
GROUP BY "driverRef"
ORDER BY avg_points DESC
LIMIT 10;


--9. Count how many results have status = 'Finished' vs. other statuses, grouped by status.
SELECT 
    status,
    COUNT(*) AS total_count
FROM race_results
--WHERE status = 'Finished'
GROUP BY status


--Slightly harder — combining WHERE + GROUP BY


--10. Among only results where points > 0, count how many point-scoring finishes each driver has.
--More Optimized Approach
SELECT 
    driver_full_name,
    COUNT(*) AS point_finishes
FROM race_results
WHERE points > 0
GROUP BY driver_full_name
ORDER BY point_finishes DESC;

--Another approach
SELECT driver_full_name,COUNT("driverId") FROM race_results
WHERE points > 0
GROUP BY driver_full_name
ORDER BY COUNT("driverId") DESC


--11. Find constructors whose total points exceed some threshold you pick (e.g., HAVING SUM(points) > 100) — this introduces HAVING, which filters after grouping, different from WHERE.
SELECT name_team,SUM(points) FROM race_results
GROUP BY name_team
HAVING SUM(points) > 500

# Week 4, Day 1 — My Notes

## Mistakes I made (the ones worth remembering)

1. COUNT() vs SUM() — easy to mix up because both return a number and the
   query runs fine either way, no error. COUNT(points) = how many rows have
   a points value. SUM(points) = the actual total. Always sanity-check: does
   this number look like a real total, or suspiciously like a row count?

2. Don't GROUP BY something that's already uniquely grouped one query up.
   If a CTE already produces one row per driver, grouping by that same
   column again in the outer query does nothing — it's a sign the extra
   layer isn't needed.

3. CTEs aren't always necessary. A CTE earns its place when a query has
   multiple layers that genuinely benefit from being named/reused. A single
   GROUP BY doesn't need one — just write the plain query.

## Things to remember going forward

- Columns with capital letters in my tables (driverRef, raceId) need double
  quotes in Postgres: "driverRef". Lowercase columns don't.
- WHERE filters rows before grouping. HAVING filters groups after grouping.
  Can't use WHERE on an aggregate like SUM(points) — it doesn't exist yet
  at that point in the query.
- When practicing a specific skill (e.g. "pick exactly 3 columns"), stick to
  what's actually being tested instead of adding extra filters/columns —
  otherwise I don't know if I actually nailed the specific skill or not.

## What I got right without needing the video
SELECT, WHERE, GROUP BY, ORDER BY, HAVING, basic CTE syntax — 8 out of 10
tasks were clean on the first attempt. SQL fundamentals are solid.