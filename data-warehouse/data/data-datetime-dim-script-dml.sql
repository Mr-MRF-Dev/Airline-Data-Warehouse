-- in this file having a proc to add data into DATETIME_DIM
-- just one time call the proc and if need it again call it without truncate table
-- also having a function to Convert datetime into Persian datetime
GO
USE [master];
IF DB_ID('AirlineDWH') IS NULL
BEGIN
    RAISERROR('Database AirlineDWH does not exist.', 16, 1);
    RETURN;
END
GO
USE AirlineDWH;
GO



CREATE OR ALTER FUNCTION dbo.fn_GetPersianDateParts (@gregorian_date DATETIME)
RETURNS TABLE
AS
/*****************************************************************************************************************
Name:     fn_GetPersianDateParts
   Purpose:  Converts a single Gregorian DATETIME value into its corresponding Persian (Jalali / Shamsi)
   calendar components. It is implemented as an inline Table-Valued Function for high performance.

Parameters:
    @gregorian_date DATETIME - The Gregorian date and time to be converted.

Returns:  TABLE
    A single-row table containing the following Persian date parts:
    - PersianYear (INT), PersianMonth (INT), PersianDay (INT), PersianDayOfYear (INT),
    PersianMonthName (NVARCHAR), PersianFullDate (VARCHAR(10)) in 'YYYY/MM/DD' format.

Usage Example:
    SELECT p.* FROM dbo.fn_GetPersianDateParts('2025-06-25') AS p;
******************************************************************************************************************/
RETURN
(
    WITH
    PersianDateParts
    AS
    (
        SELECT
            gy AS GregorianYear, gm AS GregorianMonth, gd AS GregorianDay,
            g_day_no = CASE gm WHEN 1 THEN 0 WHEN 2 THEN 31 WHEN 3 THEN 59 WHEN 4 THEN 90 WHEN 5 THEN 120 WHEN 6 THEN 151 WHEN 7 THEN 181 WHEN 8 THEN 212 WHEN 9 THEN 243 WHEN 10 THEN 273 WHEN 11 THEN 304 ELSE 334 END + gd,
            leap = CASE WHEN (gy % 4 = 0 AND gy % 100 <> 0) OR (gy % 400 = 0) THEN 1 ELSE 0 END
        FROM (SELECT YEAR(@gregorian_date) AS gy, MONTH(@gregorian_date) AS gm, DAY(@gregorian_date) AS gd) AS GregorianParts
    ),
    JulianDay
    AS
    (
        SELECT GregorianYear, julian_day_no = (GregorianYear - 1) * 365 + CAST((GregorianYear - 1) / 4 AS INT) - CAST((GregorianYear - 1) / 100 AS INT) + CAST((GregorianYear - 1) / 400 AS INT) + g_day_no + CASE WHEN leap = 1 AND GregorianMonth > 2 THEN 1 ELSE 0 END
        FROM PersianDateParts
    ),
    PersianEpoch
    AS
    (
        SELECT days = julian_day_no - 226894
        FROM JulianDay
    ),
    PersianYearCalc
    AS
    (
        SELECT days, PersianYear = 1 + CAST((days / 365.2425) AS INT)
        FROM PersianEpoch
    ),
    PersianDayOfYearCalc
    AS
    (
        SELECT PersianYear, DayOfYear = days - ((PersianYear - 1) * 365 + CAST(((PersianYear - 1) * 8 + 5) / 33 AS INT))
        FROM PersianYearCalc
    ),
    FinalPersianParts
    AS
    (
        SELECT
            PersianYear,
            PersianMonth = CASE WHEN DayOfYear <= 186 THEN (CAST((DayOfYear - 1) / 31 AS INT) + 1) ELSE (CAST((DayOfYear - 187) / 30 AS INT) + 7) END,
            PersianDay = CASE WHEN DayOfYear <= 186 THEN (DayOfYear % 31) WHEN DayOfYear % 31 = 0 THEN 31 ELSE (DayOfYear - 186) % 30 END,
            PersianDayOfYear = DayOfYear
        FROM PersianDayOfYearCalc
    )
    SELECT
    p.PersianYear, p.PersianMonth, p.PersianDay, p.PersianDayOfYear,
    PersianMonthName = CASE p.PersianMonth
            WHEN 1 THEN N'فروردین' WHEN 2 THEN N'اردیبهشت' WHEN 3 THEN N'خرداد'
            WHEN 4 THEN N'تیر' WHEN 5 THEN N'مرداد' WHEN 6 THEN N'شهریور'
            WHEN 7 THEN N'مهر' WHEN 8 THEN N'آبان' WHEN 9 THEN N'آذر'
            WHEN 10 THEN N'دی' WHEN 11 THEN N'بهمن' WHEN 12 THEN N'اسفند'
        END,
    PersianFullDate = FORMAT(p.PersianYear, '0000') + '/' + FORMAT(p.PersianMonth, '00') + '/' + FORMAT(p.PersianDay, '00')
FROM FinalPersianParts p
);
GO



CREATE OR ALTER PROCEDURE dbo.usp_Populate_Dim_DateTime
    (
    @StartDate DATE,
    @EndDate DATE,
    @TruncateTable BIT = 1
)
AS
/*****************************************************************************************************************
Name:     usp_Populate_Dim_DateTime

Purpose:  Populates the Dim_DateTime dimension table with a record for every minute within a
    specified date range. It calculates all Gregorian and Persian calendar attributes.

Dependencies:
    - Table 'dbo.Dim_DateTime' must exist.
    - Function 'dbo.fn_GetPersianDateParts' must exist.

Parameters:
    @StartDate DATE - The first date to include in the dimension (inclusive).
    @EndDate DATE - The last date to include in the dimension (inclusive).
    @TruncateTable BIT = 1 - If 1 (default), the table is truncated (full load).
    If 0, new data is appended (incremental load).

Usage Examples:
    -- Full load for the year 2025.
    EXEC dbo.usp_Populate_Dim_DateTime @StartDate = '2025-01-01', @EndDate = '2025-12-31';

    -- Incremental load for a new month.
    EXEC dbo.usp_Populate_Dim_DateTime @StartDate = '2026-01-01', @EndDate = '2026-01-31', @TruncateTable = 0;
******************************************************************************************************************/
BEGIN
    SET NOCOUNT ON;
    SET DATEFIRST 7;

    IF @TruncateTable = 1
    BEGIN
        RAISERROR('Truncating Dim_DateTime table...', 10, 1) WITH NOWAIT;
        TRUNCATE TABLE dbo.Dim_DateTime;

        -- Add the 'Unknown Member' row after truncating
        RAISERROR('Adding the Unknown Member row with ID -1...', 10, 1) WITH NOWAIT;
        INSERT INTO dbo.Dim_DateTime
            (
            DateTime_ID,
            Full_DateTime_Alternate_Key, Persian_Full_DateTime_Alternate_Key,
            Full_Date_Alternate_Key, Persian_Full_Date_Alternate_Key,
            Day_Number_Of_Week, Persian_Day_Number_Of_Week, English_Day_Name_Of_Week, Persian_Day_Name_Of_Week,
            Day_Number_Of_Month, Persian_Day_Number_Of_Month, Day_Number_Of_Year, Persian_Day_Number_Of_Year,
            Week_Number_Of_Year, Persian_Week_Number_Of_Year,
            English_Month_Name, Persian_Month_Name, Month_Number_Of_Year, Persian_Month_Number_Of_Year,
            Calendar_Quarter, Persian_Calendar_Quarter, Calendar_Year, Persian_Calendar_Year,
            Calendar_Semester, Persian_Calendar_Semester,
            Full_GMT_Time_Alternate_Key, Full_IR_Time_Alternate_Key,
            GMT_Hour_Of_Time, IR_Hour_Of_Time, GMT_Minute_Of_Time, IR_Minute_Of_Time
            )
        VALUES
            (
                -1,
                null, null,
                null, null,
                0, 0, null, null,
                0, 0, 0, 0,
                0, 0,
                null, null, 0, 0,
                0, 0, 0, 0,
                0, 0,
                '00:00:00', '00:00:00',
                0, 0, 0, 0
        );
    END

    DECLARE @LoopStartDate DATETIME = CAST(@StartDate AS DATETIME);
    DECLARE @LoopEndDate DATETIME = DATEADD(minute, 1439, CAST(@EndDate AS DATETIME));
    DECLARE @CurrentDate DATETIME = @LoopStartDate;

    DECLARE @InfoMsg NVARCHAR(200);
    SET @InfoMsg = 'Starting population of Dim_DateTime from ' + CONVERT(VARCHAR, @StartDate) + ' to ' + CONVERT(VARCHAR, @EndDate) + '...';

    RAISERROR(@InfoMsg, 10, 1) WITH NOWAIT;

    WHILE @CurrentDate <= @LoopEndDate
    BEGIN
        IF (DATEPART(hour, @CurrentDate) = 0 AND DATEPART(minute, @CurrentDate) = 0 AND DAY(@CurrentDate) = 1)
        BEGIN
            SET @InfoMsg = 'Processing month: ' + FORMAT(@CurrentDate, 'yyyy-MM');
            RAISERROR(@InfoMsg, 10, 1) WITH NOWAIT;
        END

        INSERT INTO dbo.Dim_DateTime
            (
            DateTime_ID, Full_DateTime_Alternate_Key, Persian_Full_DateTime_Alternate_Key, Full_Date_Alternate_Key, Persian_Full_Date_Alternate_Key, Day_Number_Of_Week, Persian_Day_Number_Of_Week, English_Day_Name_Of_Week, Persian_Day_Name_Of_Week, Day_Number_Of_Month, Persian_Day_Number_Of_Month, Day_Number_Of_Year, Persian_Day_Number_Of_Year, Week_Number_Of_Year, Persian_Week_Number_Of_Year, English_Month_Name, Persian_Month_Name, Month_Number_Of_Year, Persian_Month_Number_Of_Year, Calendar_Quarter, Persian_Calendar_Quarter, Calendar_Year, Persian_Calendar_Year, Calendar_Semester, Persian_Calendar_Semester, Full_GMT_Time_Alternate_Key, Full_IR_Time_Alternate_Key, GMT_Hour_Of_Time, IR_Hour_Of_Time, GMT_Minute_Of_Time, IR_Minute_Of_Time
            )
        SELECT
            CAST(FORMAT(@CurrentDate, 'yyyyMMddHHmm') AS BIGINT), @CurrentDate, pd.PersianFullDate + ' ' + FORMAT(@CurrentDate, 'HH:mm'), CAST(@CurrentDate AS DATE), pd.PersianFullDate, DATEPART(weekday, @CurrentDate), CASE DATEPART(weekday, @CurrentDate) WHEN 7 THEN 1 ELSE DATEPART(weekday, @CurrentDate) + 1 END, DATENAME(weekday, @CurrentDate), CASE DATENAME(weekday, @CurrentDate) WHEN 'Saturday' THEN N'شنبه' WHEN 'Sunday' THEN N'یکشنبه' WHEN 'Monday' THEN N'دوشنبه' WHEN 'Tuesday' THEN N'سه شنبه' WHEN 'Wednesday' THEN N'چهارشنبه' WHEN 'Thursday' THEN N'پنجشنبه' WHEN 'Friday' THEN N'جمعه' END, DAY(@CurrentDate), pd.PersianDay, DATEPART(dayofyear, @CurrentDate), pd.PersianDayOfYear, DATEPART(iso_week, @CurrentDate), (pd.PersianDayOfYear - 1) / 7 + 1, DATENAME(month, @CurrentDate), pd.PersianMonthName, MONTH(@CurrentDate), pd.PersianMonth, DATEPART(quarter, @CurrentDate), (pd.PersianMonth - 1) / 3 + 1, YEAR(@CurrentDate), pd.PersianYear, CASE WHEN MONTH(@CurrentDate) <= 6 THEN 1 ELSE 2 END, CASE WHEN pd.PersianMonth <= 6 THEN 1 ELSE 2 END, CAST(@CurrentDate AT TIME ZONE 'Iran Standard Time' AT TIME ZONE 'UTC' AS TIME), CAST(@CurrentDate AS TIME), DATEPART(hour, @CurrentDate AT TIME ZONE 'Iran Standard Time' AT TIME ZONE 'UTC'), DATEPART(hour, @CurrentDate), DATEPART(minute, @CurrentDate AT TIME ZONE 'Iran Standard Time' AT TIME ZONE 'UTC'), DATEPART(minute, @CurrentDate)
        FROM dbo.fn_GetPersianDateParts(@CurrentDate) AS pd;

        SET @CurrentDate = DATEADD(minute, 1, @CurrentDate);
    END

    RAISERROR('Dim_DateTime population completed successfully.', 10, 1) WITH NOWAIT;
    SET NOCOUNT OFF;
END
GO



-- insert datetime from 2025 to 2026
EXEC dbo.usp_Populate_Dim_DateTime @StartDate = '2025-01-01', @EndDate = '2026-12-31';
GO
