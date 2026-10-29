USE master;
GO

IF DB_ID('Hospital_Mart') IS NULL CREATE DATABASE Hospital_Mart;
GO

USE Hospital_Mart;
GO

IF OBJECT_ID('dbo.Dim_Date', 'U') IS NOT NULL DROP TABLE dbo.Dim_Date;
CREATE TABLE dbo.Dim_Date (
    DateKey INT PRIMARY KEY, FullDate DATE NOT NULL, Day INT, Month INT, Quarter INT, Year INT, MonthName VARCHAR(20), DayOfWeekName VARCHAR(20)
);

IF OBJECT_ID('dbo.Dim_Patient', 'U') IS NOT NULL DROP TABLE dbo.Dim_Patient;
CREATE TABLE dbo.Dim_Patient (
    PatientSK INT IDENTITY(1,1) PRIMARY KEY, PatientID INT NOT NULL, FullName NVARCHAR(100), Gender CHAR(1), DOB DATE, InsuranceNo VARCHAR(20), InsuranceType VARCHAR(10), ValidFrom DATETIME, ValidTo DATETIME, IsCurrent BIT DEFAULT 1
);

IF OBJECT_ID('dbo.Dim_Payer', 'U') IS NOT NULL DROP TABLE dbo.Dim_Payer;
CREATE TABLE dbo.Dim_Payer (
    PayerSK INT IDENTITY(1,1) PRIMARY KEY, PayerCode VARCHAR(20) NOT NULL, PayerName NVARCHAR(100)
);

IF OBJECT_ID('dbo.Dim_Resource', 'U') IS NOT NULL DROP TABLE dbo.Dim_Resource;
CREATE TABLE dbo.Dim_Resource (
    ResourceSK INT IDENTITY(1,1) PRIMARY KEY, DeptCode VARCHAR(10) NOT NULL, DeptName NVARCHAR(100), Floor INT
);

IF OBJECT_ID('dbo.Dim_Staff', 'U') IS NOT NULL DROP TABLE dbo.Dim_Staff;
CREATE TABLE dbo.Dim_Staff (
    StaffSK INT IDENTITY(1,1) PRIMARY KEY, StaffID INT NOT NULL, FullName NVARCHAR(100), DeptCode VARCHAR(10), Title VARCHAR(50), ValidFrom DATE, ValidTo DATE, IsCurrent BIT DEFAULT 1
);

IF OBJECT_ID('dbo.Dim_Diagnosis', 'U') IS NOT NULL DROP TABLE dbo.Dim_Diagnosis;
CREATE TABLE dbo.Dim_Diagnosis (
    DiagnosisSK INT IDENTITY(1,1) PRIMARY KEY, ICDCode VARCHAR(20) NOT NULL, ICDName NVARCHAR(200), Chapter VARCHAR(10), GroupCode VARCHAR(20)
);

IF OBJECT_ID('dbo.Dim_Outcome', 'U') IS NOT NULL DROP TABLE dbo.Dim_Outcome;
CREATE TABLE dbo.Dim_Outcome (
    OutcomeSK INT IDENTITY(1,1) PRIMARY KEY, OutcomeCode VARCHAR(10) NOT NULL, OutcomeName NVARCHAR(50)
);

IF OBJECT_ID('dbo.Dim_Bed', 'U') IS NOT NULL DROP TABLE dbo.Dim_Bed;
CREATE TABLE dbo.Dim_Bed (
    BedSK INT IDENTITY(1,1) PRIMARY KEY, BedID INT NOT NULL, BedCode VARCHAR(20), DeptCode VARCHAR(10), BedType VARCHAR(20), Status VARCHAR(20)
);

IF OBJECT_ID('dbo.Bridge_Episode_Diagnosis', 'U') IS NOT NULL DROP TABLE dbo.Bridge_Episode_Diagnosis;
CREATE TABLE dbo.Bridge_Episode_Diagnosis (
    EpisodeID INT NOT NULL, DiagnosisSK INT NOT NULL, DiagType VARCHAR(10), Weight DECIMAL(3,2) DEFAULT 1.0
);

IF OBJECT_ID('dbo.Fact_Medical_Treatment', 'U') IS NOT NULL DROP TABLE dbo.Fact_Medical_Treatment;
CREATE TABLE dbo.Fact_Medical_Treatment (
    TreatmentFactKey INT IDENTITY(1,1) PRIMARY KEY, EpisodeID INT NOT NULL, PatientSK INT NOT NULL,
    AdmissionDateKey INT NOT NULL, DischargeDateKey INT NOT NULL, DischargeDeptSK INT NOT NULL,
    AttendingStaffSK INT NOT NULL, PrimaryDiagnosisSK INT NOT NULL, OutcomeSK INT NOT NULL, PayerSK INT NOT NULL,
    LengthOfStayDays INT, TotalCost DECIMAL(18,2), DrugCost DECIMAL(18,2), ExamCost DECIMAL(18,2), LabCost DECIMAL(18,2), DischargeCount INT DEFAULT 1
);

IF OBJECT_ID('dbo.Fact_Bed_Daily', 'U') IS NOT NULL DROP TABLE dbo.Fact_Bed_Daily;
CREATE TABLE dbo.Fact_Bed_Daily (
    BedDailyFactKey INT IDENTITY(1,1) PRIMARY KEY, BedSK INT NOT NULL, DateKey INT NOT NULL, ResourceSK INT NOT NULL,
    AvailableMinutes INT DEFAULT 1440, OccupiedMinutes INT DEFAULT 0, IsOccupiedFlag INT DEFAULT 0
);
GO