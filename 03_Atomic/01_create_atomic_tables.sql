USE master;
GO

IF DB_ID('Hospital_Atomic') IS NULL CREATE DATABASE Hospital_Atomic;
GO

USE Hospital_Atomic;
GO

IF OBJECT_ID('dbo.atm_Patients', 'U') IS NOT NULL DROP TABLE dbo.atm_Patients;
CREATE TABLE dbo.atm_Patients (
    PatientSK INT IDENTITY(1,1) PRIMARY KEY, SourcePatientID INT NOT NULL, FullName NVARCHAR(100),
    DOB DATE, Gender CHAR(1), NationalID VARCHAR(12), InsuranceNo VARCHAR(20), InsuranceType VARCHAR(10),
    ValidFrom DATETIME NOT NULL DEFAULT GETDATE(), ValidTo DATETIME NULL, IsCurrent BIT NOT NULL DEFAULT 1
);

IF OBJECT_ID('dbo.atm_Departments', 'U') IS NOT NULL DROP TABLE dbo.atm_Departments;
CREATE TABLE dbo.atm_Departments (
    DeptSK INT IDENTITY(1,1) PRIMARY KEY, DeptCode VARCHAR(10) NOT NULL, DeptName NVARCHAR(100), Floor INT
);

IF OBJECT_ID('dbo.atm_Staff', 'U') IS NOT NULL DROP TABLE dbo.atm_Staff;
CREATE TABLE dbo.atm_Staff (
    StaffSK INT IDENTITY(1,1) PRIMARY KEY, SourceStaffID INT NOT NULL, FullName NVARCHAR(100),
    DeptCode VARCHAR(10), Title VARCHAR(50), ValidFrom DATE NOT NULL, ValidTo DATE NULL, IsCurrent BIT NOT NULL DEFAULT 1
);

IF OBJECT_ID('dbo.atm_Beds', 'U') IS NOT NULL DROP TABLE dbo.atm_Beds;
CREATE TABLE dbo.atm_Beds (
    BedSK INT IDENTITY(1,1) PRIMARY KEY, SourceBedID INT NOT NULL, BedCode VARCHAR(20), DeptCode VARCHAR(10), BedType VARCHAR(20), Status VARCHAR(20)
);

IF OBJECT_ID('dbo.atm_Episodes', 'U') IS NOT NULL DROP TABLE dbo.atm_Episodes;
CREATE TABLE dbo.atm_Episodes (
    EpisodeSK INT IDENTITY(1,1) PRIMARY KEY, SourceAdmissionID INT NOT NULL, SourcePatientID INT NOT NULL,
    AdmitDate DATETIME, DischargeDate DATETIME, AdmitDeptCode VARCHAR(10), DischargeDeptCode VARCHAR(10),
    AttendingDocID INT, AdmitDiagnosis VARCHAR(20), DischargeDiag VARCHAR(20), Outcome VARCHAR(10), Status VARCHAR(20), LengthOfStay INT, DW_LoadedAt DATETIME DEFAULT GETDATE()
);

IF OBJECT_ID('dbo.atm_DiagnosisEvents', 'U') IS NOT NULL DROP TABLE dbo.atm_DiagnosisEvents;
CREATE TABLE dbo.atm_DiagnosisEvents (
    DiagEventSK INT IDENTITY(1,1) PRIMARY KEY, SourceDiagnosisID INT NOT NULL, SourceAdmissionID INT NOT NULL,
    ICDCode VARCHAR(20), DiagType VARCHAR(10), DiagDate DATETIME, IsCurrent BIT, ReplacedByID INT, DW_LoadedAt DATETIME DEFAULT GETDATE()
);

IF OBJECT_ID('dbo.atm_BedAssignments', 'U') IS NOT NULL DROP TABLE dbo.atm_BedAssignments;
CREATE TABLE dbo.atm_BedAssignments (
    AssignmentSK INT IDENTITY(1,1) PRIMARY KEY, SourceAssignID INT NOT NULL, SourceAdmissionID INT NOT NULL,
    SourceBedID INT NOT NULL, AssignDate DATETIME, ReleaseDate DATETIME, OccupiedMinutes INT, DW_LoadedAt DATETIME DEFAULT GETDATE()
);

IF OBJECT_ID('dbo.atm_ServiceLines', 'U') IS NOT NULL DROP TABLE dbo.atm_ServiceLines;
CREATE TABLE dbo.atm_ServiceLines (
    ServiceLineSK INT IDENTITY(1,1) PRIMARY KEY, SourceServiceLineID INT NOT NULL, SourceAdmissionID INT NOT NULL,
    ServiceDate DATE, ServiceCode VARCHAR(20), ServiceName NVARCHAR(100), Category VARCHAR(20), Quantity DECIMAL(18,2), UnitPrice DECIMAL(18,2), Amount DECIMAL(18,2), DeptCode VARCHAR(10), DW_LoadedAt DATETIME DEFAULT GETDATE()
);

IF OBJECT_ID('dbo.atm_ICD10', 'U') IS NOT NULL DROP TABLE dbo.atm_ICD10;
CREATE TABLE dbo.atm_ICD10 (
    ICDSK INT IDENTITY(1,1) PRIMARY KEY, ICDCode VARCHAR(20) NOT NULL, ICDName NVARCHAR(200), Chapter VARCHAR(10), GroupCode VARCHAR(20)
);
GO