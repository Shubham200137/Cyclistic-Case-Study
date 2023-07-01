INSERT INTO Q1
SELECT *
FROM (
    SELECT * FROM dbo.Q2
    UNION ALL
    SELECT * FROM dbo.Q3
    UNION ALL
    SELECT * FROM dbo.Q4
) AS TripData;

SELECT *
INTO backup_data
FROM Q1;

ALTER TABLE Q1
ALTER COLUMN start_station_id nvarchar(255);

ALTER TABLE TripData
DROP COLUMN start_lat;
ALTER TABLE TripData
DROP COLUMN end_lat;
ALTER TABLE TripData
DROP COLUMN end_lng;
ALTER TABLE TripData
DROP COLUMN DateColumn;


SELECT 
    started_at,
    ended_at,
    CAST(DATEADD(SECOND, DATEDIFF(SECOND, started_at, ended_at), 0) AS time) AS TimeDifference
FROM Tripdata;


ALTER TABLE TripData
ADD Ride_Duration AS CAST(DATEADD(SECOND, DATEDIFF(SECOND, started_at, ended_at), 0) AS time);

ALTER TABLE TripData
ADD Ride_Date AS CAST(CAST(started_at AS DATE) AS DATE);

ALTER TABLE TripData
ADD Ride_Year AS YEAR(started_at);

ALTER TABLE TripData
ADD Ride_Month AS month(started_at);

ALTER TABLE TripData
ADD Ride_Day AS day(started_at);

ALTER TABLE TripData
ADD WeekDay AS DATEPART(weekday, started_at);

ALTER TABLE TripData
ADD WeekDayName AS DATENAME(weekday, started_at);

ALTER TABLE TripData
ADD Month_Name AS DATENAME(month, started_at);

SELECT COUNT(*) AS TotalRows
FROM TripData;

SELECT usertype,COUNT(*) AS TotalNumber
FROM TripData 
where usertype IS NOT NULL
group by usertype;

EXEC sp_rename 'TripData.member_casual', 'usertype'

SELECT COUNT(DISTINCT usertype) AS DistinctValues
FROM TripData;

SELECT MAX(Ride_Duration) AS MaxValue
FROM TripData;

SELECT MIN(Ride_Duration) AS MaxValue
FROM TripData;




SELECT CONVERT(TIME, DATEADD(SECOND, CAST(AVG(DATEDIFF_BIG(SECOND, '00:00:00', CONVERT(TIME, Ride_Duration))) AS BIGINT), '00:00:00')) AS MeanTime
FROM TripData;

SELECT Month_Name,usertype,rideable_type,COUNT(*) AS totalnumber,CONVERT(TIME, DATEADD(SECOND, CAST(AVG(DATEDIFF_BIG(SECOND, '00:00:00', CONVERT(TIME, Ride_Duration))) AS BIGINT), '00:00:00')) AS MeanTime
FROM TripData
WHERE
    Month_Name IS NOT NULL
group by Month_Name,usertype,rideable_type
order by MeanTime desc;

SELECT Month_Name,usertype,rideable_type,COUNT(*) AS totalnumber,CONVERT(TIME, DATEADD(SECOND, CAST(SUM(DATEDIFF_BIG(SECOND, '00:00:00', CONVERT(TIME, Ride_Duration))) AS BIGINT), '00:00:00')) AS totalTime
FROM TripData
WHERE
    Month_Name IS NOT NULL
group by Month_Name,usertype,rideable_type
order by totalTime desc;

SELECT season,usertype,rideable_type,COUNT(*) AS totalnumber,CONVERT(TIME, DATEADD(SECOND, CAST(AVG(DATEDIFF_BIG(SECOND, '00:00:00', CONVERT(TIME, Ride_Duration))) AS BIGINT), '00:00:00')) AS MeanTime
FROM TripData
WHERE
    season IS NOT NULL
group by season,usertype,rideable_type
order by MeanTime desc;

SELECT season,usertype,rideable_type,COUNT(*) AS totalnumber,CONVERT(TIME, DATEADD(SECOND, CAST(SUM(DATEDIFF_BIG(SECOND, '00:00:00', CONVERT(TIME, Ride_Duration))) AS BIGINT), '00:00:00')) AS totalTime
FROM TripData
WHERE
    season IS NOT NULL
group by season,usertype,rideable_type
order by totalTime desc;


SELECT WeekDayName,usertype,rideable_type,COUNT(*) AS totalnumber,CONVERT(TIME, DATEADD(SECOND, CAST(AVG(DATEDIFF_BIG(SECOND, '00:00:00', CONVERT(TIME, Ride_Duration))) AS BIGINT), '00:00:00')) AS MeanTime
FROM TripData
WHERE
    WeekDayName IS NOT NULL
group by WeekDayName,usertype,rideable_type
order by MeanTime desc;

SELECT WeekDayName,usertype,rideable_type,COUNT(*) AS totalnumber,CONVERT(TIME, DATEADD(SECOND, CAST(SUM(DATEDIFF_BIG(SECOND, '00:00:00', CONVERT(TIME, Ride_Duration))) AS BIGINT), '00:00:00')) AS totalTime
FROM TripData
WHERE
    WeekDayName IS NOT NULL
group by WeekDayName,usertype,rideable_type
order by totalTime desc;


SELECT rideable_type,COUNT(*) AS totalnumber
FROM TripData 
where rideable_type IS NOT NULL
group by rideable_type
order by totalnumber desc;


SELECT rideable_type,usertype,COUNT(*) totalRides,CONVERT(TIME, DATEADD(SECOND, CAST(AVG(DATEDIFF_BIG(SECOND, '00:00:00', CONVERT(TIME, Ride_Duration))) AS BIGINT), '00:00:00')) AS MeanTime
FROM TripData
WHERE
    rideable_type IS NOT NULL
group by rideable_type,usertype
order by rideable_type desc,usertype desc;


SELECT rideable_type,usertype,Month_Name,COUNT(*) totalRides,CONVERT(TIME, DATEADD(SECOND, CAST(AVG(DATEDIFF_BIG(SECOND, '00:00:00', CONVERT(TIME, Ride_Duration))) AS BIGINT), '00:00:00')) AS MeanTime
FROM TripData
WHERE
    rideable_type IS NOT NULL
group by rideable_type,usertype,Month_Name
order by rideable_type desc,usertype desc,Month_Name desc;

SELECT rideable_type,usertype,Month_Name,COUNT(*) totalRides,CONVERT(TIME, DATEADD(SECOND, CAST(SUM(DATEDIFF_BIG(SECOND, '00:00:00', CONVERT(TIME, Ride_Duration))) AS BIGINT), '00:00:00')) AS totalTime
FROM TripData
WHERE
    rideable_type IS NOT NULL
group by rideable_type,usertype,Month_Name
order by rideable_type desc,usertype desc,Month_Name desc;

SELECT usertype,COUNT(*) AS totalnumber,CONVERT(TIME, DATEADD(SECOND, CAST(AVG(DATEDIFF_BIG(SECOND, '00:00:00', CONVERT(TIME, Ride_Duration))) AS BIGINT), '00:00:00')) AS MeanTime
FROM TripData 
where rideable_type IS NOT NULL
group by usertype
order by totalnumber desc;


ALTER TABLE TripData
ADD MonthYear AS FORMAT(started_at, 'MMMM yyyy')

SELECT rideable_type,usertype,MonthYear,COUNT(*) totalRides,CONVERT(TIME, DATEADD(SECOND, CAST(AVG(DATEDIFF_BIG(SECOND, '00:00:00', CONVERT(TIME, Ride_Duration))) AS BIGINT), '00:00:00')) AS MeanTime
FROM TripData
WHERE
    rideable_type IS NOT NULL
group by rideable_type,usertype,MonthYear
order by rideable_type desc,usertype desc,MonthYear desc;



SELECT rideable_type,usertype,MonthYear,COUNT(*) totalRides,CONVERT(TIME, DATEADD(SECOND, CAST(SUM(DATEDIFF_BIG(SECOND, '00:00:00', CONVERT(TIME, Ride_Duration))) AS BIGINT), '00:00:00')) AS totalTime
FROM TripData
WHERE
    rideable_type IS NOT NULL
group by rideable_type,usertype,MonthYear
order by rideable_type desc,usertype desc,MonthYear desc;












--1.NO. OF RIDES BY MONTH BY EACH MEMBER TYPE--
SELECT
    DATENAME(MONTH, started_at) AS Month,
    SUM(CASE WHEN usertype = 'member' THEN 1 ELSE 0 END) AS member_count,
    SUM(CASE WHEN usertype = 'casual' THEN 1 ELSE 0 END) AS casual_count,
	SUM(CASE WHEN usertype IN ('member', 'casual') THEN 1 ELSE 0 END) AS total_count,
	CONVERT(TIME, DATEADD(SECOND, CAST(AVG(DATEDIFF_BIG(SECOND, '00:00:00', CONVERT(TIME, Ride_Duration))) AS BIGINT), '00:00:00')) AS AvgTime,
	CONVERT(TIME, DATEADD(SECOND, CAST(SUM(DATEDIFF_BIG(SECOND, '00:00:00', CONVERT(TIME, Ride_Duration))) AS BIGINT), '00:00:00')) AS totalTime
FROM
    TripData
WHERE
    usertype IN ('member', 'casual')
GROUP BY
    DATENAME(MONTH, started_at)
ORDER BY
    total_count desc;


--2.AVERAGE RIDE DURATION BY MEMBER TYPE--
SELECT
    usertype,
    COUNT(*) AS totalRides,
    CONVERT(TIME, DATEADD(SECOND, CAST(AVG(DATEDIFF_BIG(SECOND, '00:00:00', CONVERT(TIME, Ride_Duration))) AS BIGINT), '00:00:00')) AS AvgTime
FROM
    TripData
WHERE
    usertype IN ('member', 'casual')
GROUP BY
    usertype;

SELECT
    rideable_type,
    COUNT(*) AS totalRides,
    CONVERT(TIME, DATEADD(SECOND, CAST(AVG(DATEDIFF_BIG(SECOND, '00:00:00', CONVERT(TIME, Ride_Duration))) AS BIGINT), '00:00:00')) AS AvgTime
FROM
    TripData
WHERE
    rideable_type is not null
GROUP BY
    rideable_type;




--3. No. of rides in weekday by member type--
SELECT
    DATENAME(WEEKDAY, started_at) AS weekday_name,
    SUM(CASE WHEN usertype = 'member' THEN 1 ELSE 0 END) AS member_count,
    SUM(CASE WHEN usertype = 'casual' THEN 1 ELSE 0 END) AS casual_count,
    SUM(CASE WHEN usertype IN ('member', 'casual') THEN 1 ELSE 0 END) AS total_count
FROM
    TripData
WHERE
    usertype IN ('member', 'casual')
GROUP BY
    DATENAME(WEEKDAY, started_at)
ORDER BY
    total_count DESC;

--4.AVERAGE RIDE DURATION BY WEEKDAY--
SELECT
    DATENAME(WEEKDAY, started_at) AS weekday_name,
    SUM(CASE WHEN usertype = 'member' THEN 1 ELSE 0 END) AS member_count,
    SUM(CASE WHEN usertype = 'casual' THEN 1 ELSE 0 END) AS casual_count,
    SUM(CASE WHEN usertype IN ('member', 'casual') THEN 1 ELSE 0 END) AS total_count,
    CONVERT(TIME, DATEADD(SECOND, CAST(AVG(DATEDIFF_BIG(SECOND, '00:00:00', CONVERT(TIME, Ride_Duration))) AS BIGINT), '00:00:00')) AS AvgTime,
	CONVERT(TIME, DATEADD(SECOND, CAST(SUM(DATEDIFF_BIG(SECOND, '00:00:00', CONVERT(TIME, Ride_Duration))) AS BIGINT), '00:00:00')) AS totalTime
FROM
    TripData
WHERE
    usertype IN ('member', 'casual')
GROUP BY
    DATENAME(WEEKDAY, started_at);


--5. No. of rides in Season by member type--
SELECT
    season,
    SUM(CASE WHEN usertype = 'member' THEN 1 ELSE 0 END) AS member_count,
    SUM(CASE WHEN usertype = 'casual' THEN 1 ELSE 0 END) AS casual_count,
    SUM(CASE WHEN usertype IN ('member', 'casual') THEN 1 ELSE 0 END) AS total_count
FROM
    TripData
WHERE
    usertype IN ('member', 'casual')
GROUP BY
    season
ORDER BY
    total_count DESC;


--6.AVERAGE RIDE DURATION BY Season--
SELECT
    season,
    SUM(CASE WHEN usertype = 'member' THEN 1 ELSE 0 END) AS member_count,
    SUM(CASE WHEN usertype = 'casual' THEN 1 ELSE 0 END) AS casual_count,
    SUM(CASE WHEN usertype IN ('member', 'casual') THEN 1 ELSE 0 END) AS total_count,
    CONVERT(TIME, DATEADD(SECOND, CAST(AVG(DATEDIFF_BIG(SECOND, '00:00:00', CONVERT(TIME, Ride_Duration))) AS BIGINT), '00:00:00')) AS AvgTime
FROM
    TripData
WHERE
    usertype IN ('member', 'casual')
GROUP BY
    season

--7.NO. OF RIDES BY MONTH BY BIKE TYPE--
SELECT
    DATENAME(MONTH, started_at) AS Month,
    SUM(CASE WHEN rideable_type = 'docked_bike' THEN 1 ELSE 0 END) AS Docked_Bike,
    SUM(CASE WHEN rideable_type = 'electric_bike' THEN 1 ELSE 0 END) AS Electric_Bike,
	SUM(CASE WHEN rideable_type = 'classic_bike' THEN 1 ELSE 0 END) AS Classic_Bike,
	SUM(CASE WHEN rideable_type IN ('docked_bike', 'electric_bike','classic_bike') THEN 1 ELSE 0 END) AS total_count,
	CONVERT(TIME, DATEADD(SECOND, CAST(AVG(DATEDIFF_BIG(SECOND, '00:00:00', CONVERT(TIME, Ride_Duration))) AS BIGINT), '00:00:00')) AS AvgTime,
	CONVERT(TIME, DATEADD(SECOND, CAST(SUM(DATEDIFF_BIG(SECOND, '00:00:00', CONVERT(TIME, Ride_Duration))) AS BIGINT), '00:00:00')) AS totalTime
FROM
    TripData
WHERE
    rideable_type IN ('docked_bike','electric_bike','classic_bike')
GROUP BY
    DATENAME(MONTH, started_at)
ORDER BY
    total_count desc;


--8.NO. OF RIDES BY WEEKDAY BY BIKE TYPE--
SELECT
	DATENAME(WEEKDAY, started_at) AS weekday_name,
    SUM(CASE WHEN rideable_type = 'docked_bike' THEN 1 ELSE 0 END) AS Docked_Bike,
    SUM(CASE WHEN rideable_type = 'electric_bike' THEN 1 ELSE 0 END) AS Electric_Bike,
	SUM(CASE WHEN rideable_type = 'classic_bike' THEN 1 ELSE 0 END) AS Classic_Bike,
	SUM(CASE WHEN rideable_type IN ('docked_bike', 'electric_bike','classic_bike') THEN 1 ELSE 0 END) AS total_count,
	CONVERT(TIME, DATEADD(SECOND, CAST(AVG(DATEDIFF_BIG(SECOND, '00:00:00', CONVERT(TIME, Ride_Duration))) AS BIGINT), '00:00:00')) AS AvgTime,
	CONVERT(TIME, DATEADD(SECOND, CAST(SUM(DATEDIFF_BIG(SECOND, '00:00:00', CONVERT(TIME, Ride_Duration))) AS BIGINT), '00:00:00')) AS totalTime
FROM
    TripData
WHERE
    rideable_type IN ('docked_bike','electric_bike','classic_bike')
GROUP BY
    DATENAME(WEEKDAY, started_at)
ORDER BY
    total_count desc;

--9.NO. OF RIDES BY Season BY BIKE TYPE--
SELECT
    season,
    SUM(CASE WHEN rideable_type = 'docked_bike' THEN 1 ELSE 0 END) AS Docked_Bike,
    SUM(CASE WHEN rideable_type = 'electric_bike' THEN 1 ELSE 0 END) AS Electric_Bike,
	SUM(CASE WHEN rideable_type = 'classic_bike' THEN 1 ELSE 0 END) AS Classic_Bike,
	SUM(CASE WHEN rideable_type IN ('docked_bike', 'electric_bike','classic_bike') THEN 1 ELSE 0 END) AS total_count,
	CONVERT(TIME, DATEADD(SECOND, CAST(AVG(DATEDIFF_BIG(SECOND, '00:00:00', CONVERT(TIME, Ride_Duration))) AS BIGINT), '00:00:00')) AS AvgTime
FROM
    TripData
WHERE
    rideable_type IN ('docked_bike','electric_bike','classic_bike')
GROUP BY
    season
ORDER BY
    total_count desc;

--10.Average ride length for member type during different times of a day--
SELECT
	SUM(CASE WHEN rideable_type = 'docked_bike' THEN 1 ELSE 0 END) AS Docked_Bike,
    SUM(CASE WHEN rideable_type = 'electric_bike' THEN 1 ELSE 0 END) AS Electric_Bike,
	SUM(CASE WHEN rideable_type = 'classic_bike' THEN 1 ELSE 0 END) AS Classic_Bike,
	SUM(CASE WHEN usertype = 'member' THEN 1 ELSE 0 END) AS member_count,
	SUM(CASE WHEN usertype = 'casual' THEN 1 ELSE 0 END) AS casual_count,
	count(*) No_of_Rides,
    (CASE 
    WHEN cast(started_at as time) >= '05:00:00' and cast(started_at as time) < '12:00:00' THEN 'Morning'
    WHEN cast(started_at as time) >= '12:00:00' and cast(started_at as time) < '17:00:00' THEN 'Afternoon'
    WHEN cast(started_at as time) >= '17:00:00' and cast(started_at as time) < '20:00:00' THEN 'Evening'
    ELSE 'Night'
    END) AS part_of_day,
	CONVERT(TIME, DATEADD(SECOND, CAST(AVG(DATEDIFF_BIG(SECOND, '00:00:00', CONVERT(TIME, Ride_Duration))) AS BIGINT), '00:00:00')) AS AvgTime,
	CONVERT(TIME, DATEADD(SECOND, CAST(SUM(DATEDIFF_BIG(SECOND, '00:00:00', CONVERT(TIME, Ride_Duration))) AS BIGINT), '00:00:00')) AS TotalTime
FROM TripData
where usertype IN ('member','casual')
GROUP BY  (CASE 
    WHEN cast(started_at as time) >= '05:00:00' and cast(started_at as time) < '12:00:00' THEN 'Morning'
    WHEN cast(started_at as time) >= '12:00:00' and cast(started_at as time) < '17:00:00' THEN 'Afternoon'
    WHEN cast(started_at as time) >= '17:00:00' and cast(started_at as time) < '20:00:00' THEN 'Evening'
    ELSE 'Night'
    END)





SELECT
	season,--extra
	SUM(CASE WHEN rideable_type = 'docked_bike' THEN 1 ELSE 0 END) AS Docked_Bike,
    SUM(CASE WHEN rideable_type = 'electric_bike' THEN 1 ELSE 0 END) AS Electric_Bike,
	SUM(CASE WHEN rideable_type = 'classic_bike' THEN 1 ELSE 0 END) AS Classic_Bike,
	SUM(CASE WHEN usertype = 'member' THEN 1 ELSE 0 END) AS member_count,
	SUM(CASE WHEN usertype = 'casual' THEN 1 ELSE 0 END) AS casual_count,
	count(*) No_of_Rides,
    (CASE 
    WHEN cast(started_at as time) >= '05:00:00' and cast(started_at as time) < '12:00:00' THEN 'Morning'
    WHEN cast(started_at as time) >= '12:00:00' and cast(started_at as time) < '17:00:00' THEN 'Afternoon'
    WHEN cast(started_at as time) >= '17:00:00' and cast(started_at as time) < '20:00:00' THEN 'Evening'
    ELSE 'Night'
    END) AS part_of_day,
	CONVERT(TIME, DATEADD(SECOND, CAST(AVG(DATEDIFF_BIG(SECOND, '00:00:00', CONVERT(TIME, Ride_Duration))) AS BIGINT), '00:00:00')) AS AvgTime,
	CONVERT(TIME, DATEADD(SECOND, CAST(SUM(DATEDIFF_BIG(SECOND, '00:00:00', CONVERT(TIME, Ride_Duration))) AS BIGINT), '00:00:00')) AS TotalTime
FROM TripData
where usertype IN ('member','casual')
GROUP BY  (CASE 
    WHEN cast(started_at as time) >= '05:00:00' and cast(started_at as time) < '12:00:00' THEN 'Morning'
    WHEN cast(started_at as time) >= '12:00:00' and cast(started_at as time) < '17:00:00' THEN 'Afternoon'
    WHEN cast(started_at as time) >= '17:00:00' and cast(started_at as time) < '20:00:00' THEN 'Evening'
    ELSE 'Night'
    END),season
order by season desc





SELECT
	Month_Name,--extra
	Ride_Month,
	SUM(CASE WHEN rideable_type = 'docked_bike' THEN 1 ELSE 0 END) AS Docked_Bike,
    SUM(CASE WHEN rideable_type = 'electric_bike' THEN 1 ELSE 0 END) AS Electric_Bike,
	SUM(CASE WHEN rideable_type = 'classic_bike' THEN 1 ELSE 0 END) AS Classic_Bike,
	SUM(CASE WHEN usertype = 'member' THEN 1 ELSE 0 END) AS member_count,
	SUM(CASE WHEN usertype = 'casual' THEN 1 ELSE 0 END) AS casual_count,
	count(*) No_of_Rides,
    (CASE 
    WHEN cast(started_at as time) >= '05:00:00' and cast(started_at as time) < '12:00:00' THEN 'Morning'
    WHEN cast(started_at as time) >= '12:00:00' and cast(started_at as time) < '17:00:00' THEN 'Afternoon'
    WHEN cast(started_at as time) >= '17:00:00' and cast(started_at as time) < '20:00:00' THEN 'Evening'
    ELSE 'Night'
    END) AS part_of_day,
	CONVERT(TIME, DATEADD(SECOND, CAST(AVG(DATEDIFF_BIG(SECOND, '00:00:00', CONVERT(TIME, Ride_Duration))) AS BIGINT), '00:00:00')) AS AvgTime,
	CONVERT(TIME, DATEADD(SECOND, CAST(SUM(DATEDIFF_BIG(SECOND, '00:00:00', CONVERT(TIME, Ride_Duration))) AS BIGINT), '00:00:00')) AS TotalTime
FROM TripData
where usertype IN ('member','casual')
GROUP BY  (CASE 
    WHEN cast(started_at as time) >= '05:00:00' and cast(started_at as time) < '12:00:00' THEN 'Morning'
    WHEN cast(started_at as time) >= '12:00:00' and cast(started_at as time) < '17:00:00' THEN 'Afternoon'
    WHEN cast(started_at as time) >= '17:00:00' and cast(started_at as time) < '20:00:00' THEN 'Evening'
    ELSE 'Night'
    END),Month_Name,Ride_Month
order by Month_Name desc

SELECT
	WeekDayName,--extra
	SUM(CASE WHEN rideable_type = 'docked_bike' THEN 1 ELSE 0 END) AS Docked_Bike,
    SUM(CASE WHEN rideable_type = 'electric_bike' THEN 1 ELSE 0 END) AS Electric_Bike,
	SUM(CASE WHEN rideable_type = 'classic_bike' THEN 1 ELSE 0 END) AS Classic_Bike,
	SUM(CASE WHEN usertype = 'member' THEN 1 ELSE 0 END) AS member_count,
	SUM(CASE WHEN usertype = 'casual' THEN 1 ELSE 0 END) AS casual_count,
	count(*) No_of_Rides,
    (CASE 
    WHEN cast(started_at as time) >= '05:00:00' and cast(started_at as time) < '12:00:00' THEN 'Morning'
    WHEN cast(started_at as time) >= '12:00:00' and cast(started_at as time) < '17:00:00' THEN 'Afternoon'
    WHEN cast(started_at as time) >= '17:00:00' and cast(started_at as time) < '20:00:00' THEN 'Evening'
    ELSE 'Night'
    END) AS part_of_day,
	CONVERT(TIME, DATEADD(SECOND, CAST(AVG(DATEDIFF_BIG(SECOND, '00:00:00', CONVERT(TIME, Ride_Duration))) AS BIGINT), '00:00:00')) AS AvgTime,
	CONVERT(TIME, DATEADD(SECOND, CAST(SUM(DATEDIFF_BIG(SECOND, '00:00:00', CONVERT(TIME, Ride_Duration))) AS BIGINT), '00:00:00')) AS TotalTime
FROM TripData
where usertype IN ('member','casual')
GROUP BY  (CASE 
    WHEN cast(started_at as time) >= '05:00:00' and cast(started_at as time) < '12:00:00' THEN 'Morning'
    WHEN cast(started_at as time) >= '12:00:00' and cast(started_at as time) < '17:00:00' THEN 'Afternoon'
    WHEN cast(started_at as time) >= '17:00:00' and cast(started_at as time) < '20:00:00' THEN 'Evening'
    ELSE 'Night'
    END),WeekDayName
order by WeekDayName desc



SELECT TOP (400) * FROM TripData;

SELECT * FROM TripData;



