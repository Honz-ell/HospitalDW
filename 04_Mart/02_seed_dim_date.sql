USE Hospital_Mart;
GO

TRUNCATE TABLE dbo.Dim_Date;

DECLARE @StartDate DATE = '2023-01-01';
DECLARE @EndDate DATE = '2026-12-31';

WHILE @StartDate <= @EndDate
BEGIN
    INSERT INTO dbo.Dim_Date (DateKey, FullDate, Day, Month, Quarter, Year, MonthName, DayOfWeekName)
    VALUES (
        CAST(CONVERT(VARCHAR(8), @StartDate, 112) AS INT),
        @StartDate, DAY(@StartDate), MONTH(@StartDate),
        DATEPART(QUARTER, @StartDate), YEAR(@StartDate),
        DATENAME(MONTH, @StartDate), DATENAME(WEEKDAY, @StartDate)
    );
    SET @StartDate = DATEADD(DAY, 1, @StartDate);
END;
GO