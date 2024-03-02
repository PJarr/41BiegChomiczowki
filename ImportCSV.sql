-- Create dedicated table to store data
CREATE TABLE dbo.BiegChomiczowki
(
	ID INT IDENTITY (1,1),
	Race_Time TIME(0),
	HR INT,
	Speed_km_h decimal(5,2),
	Pace_min_km TIME(0),
	Cadence INT,
	Altitude INT,
	Distance DECIMAL(10,2),
	Temperature DECIMAL(5,2),
	Generated_Power INT
)
drop table dbo.BiegChomiczowki
select *
from dbo.BiegChomiczowki

-- Create temporary table to stora data from bulk insert
DROP TABLE IF EXISTS #tmp
CREATE TABLE #tmp
(
	Sample_rate VARCHAR(MAX) NULL,
	Race_Time VARCHAR(MAX) NULL,
	HR_bpm VARCHAR(MAX) NULL,
	Speed_km_h VARCHAR(MAX) NULL,
	Pace VARCHAR(MAX) NULL,
	Cadence VARCHAR(MAX) NULL,
	Altitude VARCHAR(MAX) NULL,
	Stride_length VARCHAR(MAX) NULL,
	Distances VARCHAR(MAX) NULL,
	Temperatures VARCHAR(MAX) NULL,
	Power_gen VARCHAR(MAX) NULL,
	Empty_col VARCHAR(MAX) NULL
)

-- Insert data from csv file into temporary table
BULK INSERT #tmp
FROM 'I:\Projects\41 Bieg Chomiczowki\BiegChomiczowkiData.CSV'
WITH
(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'

)

-- Converting Pace column into 00:00:00 format
select
	Race_Time,
	HR_bpm,
	Speed_km_h,
	'00:'+Pace Pace,
	Cadence,
	Altitude,
	Distances,
	Temperatures,
	Power_gen
from #tmp

-- Inserting data into dbo.BiegChomiczowki
INSERT INTO dbo.BiegChomiczowki (Race_Time, HR, Speed_km_h, Pace_min_km, Cadence, Altitude, Distance, Temperature, Generated_Power)
select
	Race_Time,
	HR_bpm,
	Speed_km_h,
	'00:'+Pace Pace,
	Cadence,
	Altitude,
	Distances,
	Temperatures,
	Power_gen
from #tmp

select *
from dbo.BiegChomiczowki