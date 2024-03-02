CREATE TABLE dbo.BiegChomiczowkiZones
(
	Strefa INT,
	Pace_ranges varchar(50)
	HR_ranges varchar(50)
)

INSERT INTO dbo.BiegChomiczowkiZones
VALUES (1),(2),(3),(4),(5)

select *
from dbo.BiegChomiczowkiZones

UPDATE dbo.BiegChomiczowkiZones
SET 
    Pace_ranges = CASE 
                    WHEN Strefa = 1 THEN '<04:30'
                    WHEN Strefa = 2 THEN '04:30-04:20'
                    WHEN Strefa = 3 THEN '04:20-04:10'
                    WHEN Strefa = 4 THEN '04:10-04:00'
                    WHEN Strefa = 5 THEN '>04:00'
                 END,
    HR_ranges = CASE 
                    WHEN Strefa = 1 THEN '<100'
                    WHEN Strefa = 2 THEN '100-120'
                    WHEN Strefa = 3 THEN '120-140'
                    WHEN Strefa = 4 THEN '140-160'
                    WHEN Strefa = 5 THEN '>160'
                 END
WHERE 
    Pace_ranges IS NULL OR HR_ranges IS NULL;
