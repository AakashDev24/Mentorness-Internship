create database corona;
USE corona;

select * From virus;

ALTER TABLE virus
CHANGE `Country/Region` Region varchar(50);

-- To avoid any errors, check missing value / null value 
-- Q1. Write a code to check NULL values
SELECT * 
FROM virus
where Province IS NULL OR 
      Region IS NULL OR
      latitude IS NULL OR
      Longitude IS NULL OR
      Date IS NULL OR
      Confirmed IS NULL OR
      Deaths IS NULL OR
      Recovered IS NULL ;

-- Q2. If NULL values are present, update them with zeros for all columns. 
-- No Null Values are there in the dataset

-- Q3. Check total number of rows
SELECT count(*) AS Count_of_rows
From virus;


-- Q4. Check what is start_date and end_date
-- Step 1: Add a new date column
ALTER TABLE virus ADD COLUMN Date_ DATE;

-- Step 2: Update the new column with converted date values
SET sql_safe_updates = 0;
UPDATE virus SET Date_ = STR_TO_DATE(date,'%d-%m-%Y');

-- Step 3: Drop the old text column
ALTER TABLE virus DROP COLUMN date;

-- Step 4: Rename the new column to the original column name
ALTER TABLE virus CHANGE COLUMN Date_ Date DATE;
Select min(date) AS Start_date,
       max(date) AS End_date
from virus;

-- Q5. Number of month present in dataset
SELECT YEAR(Date) AS Year, 
		COUNT(DISTINCT MONTH(Date)) AS Number_of_Months
FROM virus
GROUP BY YEAR(Date);        

-- Q6. Find monthly average for confirmed, deaths, recovered
SELECT  YEAR(Date) AS Year, MONTHNAME(Date) AS Month, 
		AVG(confirmed) AS AVG_CONFIMED_CASES, 
        AVG(deaths) AS AVG_DEATHS, 
		AVG(recovered) AS AVG_RECOVERED
FROM virus
GROUP BY MONTHNAME(Date), YEAR(Date);

-- Q7. Find most frequent value for confirmed, deaths, recovered each month 
SELECT 
   MONTH(Date) AS Month,
   YEAR(Date) AS Year,
   MAX(Confirmed) AS Most_frequent_Confirmed,
   MAX(Deaths) AS Most_frequent_Deaths,
   MAX(Recovered) AS Most_frequent_Recovered
FROM virus
GROUP BY MONTH(Date), YEAR(Date);
 
-- Q8. Find minimum values for confirmed, deaths, recovered per year
SELECT YEAR(DATE) AS YEAR, 
       MIN(Confirmed) AS Min_Confirmed, 
       MIN(Deaths) AS Min_Deaths, 
       MIN(Recovered) AS Min_Recovered
FROM virus
GROUP BY YEAR;

-- Q9. Find maximum values of confirmed, deaths, recovered per year
SELECT YEAR(DATE) AS Year, 
	   MAX(Confirmed) AS Max_Cases, 
       MAX(Deaths) AS Max_Deaths, 
       MAX(Recovered) AS Max_Recovered
FROM virus
GROUP BY YEAR;

-- Q10. The total number of case of confirmed, deaths, recovered each month
SELECT YEAR(DATE) AS YEAR,
       MONTH(DATE) AS MONTH, 
       SUM(Confirmed) AS Total_Confirmed, 
       SUM(Deaths) AS Total_Deaths, 
       SUM(Recovered) AS Total_Recovered
FROM virus
GROUP BY YEAR, MONTH;

-- Q11. Check how corona virus spread out with respect to confirmed case
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT  SUM(Confirmed) AS Total_Confirmed, 
        CAST(AVG(Confirmed) AS DECIMAL(10, 2)) AS Avg_Confirmed, 
        CAST(VARIANCE(Confirmed) AS DECIMAL(12, 2)) AS Variance, 
        CAST(STDDEV(Confirmed) AS DECIMAL(10, 2)) AS Standard_deviation
FROM virus;

-- Q12. Check how corona virus spread out with respect to death case per month
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT  YEAR(DATE) AS YEAR,MONTH(DATE) AS MONTH,
        SUM(DEATHS) AS Total_Deaths, 
		CAST(AVG(Deaths) AS DECIMAL(10, 2)) AS Avg_Deaths, 
        CAST(VARIANCE(Deaths) AS DECIMAL(12, 2)) AS Variance, 
		CAST(STDDEV(Deaths) AS DECIMAL(10, 2)) AS Standard_Deviation
FROM virus
GROUP BY YEAR, MONTH;

-- Q13. Check how corona virus spread out with respect to recovered case
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT  SUM(RECOVERED) AS Total_Recovered,
        CAST(AVG(Recovered) AS DECIMAL(10, 2)) AS Avg_Recovered,
        CAST(VARIANCE(Recovered) AS DECIMAL(12, 2))AS Variance, 
        CAST(STDDEV(Recovered) AS DECIMAL(10, 2)) AS Standard_Deviation
FROM virus;

-- Q14. Find Country having highest number of the Confirmed case
SELECT Region, 
       SUM(CONFIRMED) AS Total_cases
FROM virus
GROUP BY Region
ORDER by Total_cases DESC
LIMIT 1;

-- Q15. Find Country having lowest number of the death case
SELECT Region, 
       SUM(Deaths) AS Total_Deaths
FROM virus
GROUP BY Region
ORDER by Total_Deaths 
LIMIT 1;

-- Q16. Find top 5 countries having highest recovered case
SELECT Region, 
       SUM(Recovered) AS Recovered_cases
FROM virus
GROUP BY Region
ORDER by Recovered_cases DESC
LIMIT 5;