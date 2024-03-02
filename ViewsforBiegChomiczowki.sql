-- [dbo].[vBiegChomiczowki]
CREATE VIEW [dbo].[vBiegChomiczowki] AS
WITH race_facts AS (
	SELECT
	Race_Time,
	DATEDIFF(MI,0, Race_Time) AS Race_minute,
	Distance,
	Distance / 1000 AS Distance_km,
	CEILING(Distance / 1000) AS Distance_km_ceiling,
	HR, 
	CASE 
		WHEN HR > 160 THEN '5'
		WHEN HR > 140 AND HR <= 160 THEN '4'
		WHEN HR > 120 AND HR <= 140 THEN '3'
		WHEN HR > 100 AND HR <= 120 THEN '2' 
		ELSE '1' 
	END AS 'HR_zones',
	Pace_min_km, 
	CASE 
		WHEN [Pace_min_km] < '00:04:00' THEN '5' 
		WHEN [Pace_min_km] < '00:04:10' AND [Pace_min_km] >= '00:04:00' THEN '4' 
		WHEN [Pace_min_km] < '00:04:20' AND [Pace_min_km] >= '00:04:10' THEN '3' 
		WHEN [Pace_min_km] < '00:04:30' AND [Pace_min_km] >= '00:04:20' THEN '2' 
		ELSE '1' 
	END AS 'Pace_zones', 
	Cadence * 2 AS Cadence
	FROM dbo.BiegChomiczowki
)
SELECT 
	Race_Time, 
	Race_minute,
	Distance, 
	Distance_km, 
	Distance_km_ceiling, 
	HR, 
	HR_zones, 
	Pace_min_km, 
	Pace_zones, 
	Cadence
FROM race_facts

--[dbo].[vBiegChomiczowkiAggregatedMinutes]
CREATE VIEW [dbo].[vBiegChomiczowkiAggregatedMinutes] AS
SELECT 
	Race_minute, 
	CONVERT(TIME(0), DATEADD(SECOND, AVG(DATEDIFF(SECOND, '00:00:00', Pace_min_km)), '00:00:00')) AS Average_Pace,
	CONVERT(TIME(0), DATEADD(SECOND, MIN(DATEDIFF(SECOND, '00:00:00', Pace_min_km)), '00:00:00')) AS Minimum_Pace, 
	CONVERT(TIME(0), DATEADD(SECOND, MAX(DATEDIFF(SECOND, '00:00:00', Pace_min_km)), '00:00:00')) AS Maximum_Pace
FROM dbo.vBiegChomiczowki
GROUP BY 
	Race_minute

-- [dbo].[vBiegChomiczowkiAggregatedKilometers]
CREATE VIEW [dbo].[vBiegChomiczowkiAggregatedKilometers] AS
select
	[Distance_km_ceiling] Distance_km,
	CONVERT(TIME(0), DATEADD(SECOND, AVG(DATEDIFF(SECOND, '00:00:00', Pace_min_km)), '00:00:00')) AS Average_Pace,
	CONVERT(TIME(0), DATEADD(SECOND, MIN(DATEDIFF(SECOND, '00:00:00', Pace_min_km)), '00:00:00')) AS Minimum_Pace, 
	CONVERT(TIME(0), DATEADD(SECOND, MAX(DATEDIFF(SECOND, '00:00:00', Pace_min_km)), '00:00:00')) AS Maximum_Pace
FROM [PortfolioProject].[dbo].[vBiegChomiczowki]
GROUP BY
	[Distance_km_ceiling]