USE master;
GO

IF DB_ID('Hospital_Staging') IS NULL CREATE DATABASE Hospital_Staging;
GO

USE Hospital_Staging;
GO

IF OBJECT_ID('dbo.stg_Patients', 'U') IS NOT NULL DROP TABLE dbo.stg_Patients;
CREATE TABLE dbo.stg_Patients (
    PatientID INT, FullName NVARCHAR(100), DOB DATE, Gender CHAR(1),
    NationalID VARCHAR(12), InsuranceNo VARCHAR(20), InsuranceType VARCHAR(10), LoadedAt DATETIME DEFAULT GETDATE()
);

IF OBJECT_ID('dbo.stg_Departments', 'U') IS NOT NULL DROP TABLE dbo.stg_Departments;
CREATE TABLE dbo.stg_Departments (
    DeptCode VARCHAR(10), DeptName NVARCHAR(100), Floor INT, LoadedAt DATETIME DEFAULT GETDATE()
);

IF OBJECT_ID('dbo.stg_Staff', 'U') IS NOT NULL DROP TABLE dbo.stg_Staff;
CREATE TABLE dbo.stg_Staff (
    StaffID INT, FullName NVARCHAR(100), DeptCode VARCHAR(10), Title VARCHAR(50),
    EffectiveFrom DATE, EffectiveTo DATE, LoadedAt DATETIME DEFAULT GETDATE()
);

IF OBJECT_ID('dbo.stg_Beds', 'U') IS NOT NULL DROP TABLE dbo.stg_Beds;
CREATE TABLE dbo.stg_Beds (
    BedID INT, BedCode VARCHAR(20), DeptCode VARCHAR(10), BedType VARCHAR(20), Status VARCHAR(20), LoadedAt DATETIME DEFAULT GETDATE()
);

IF OBJECT_ID('dbo.stg_Admissions', 'U') IS NOT NULL DROP TABLE dbo.stg_Admissions;
CREATE TABLE dbo.stg_Admissions (
    AdmissionID INT, PatientID INT, AdmitDate DATETIME, DischargeDate DATETIME,
    AdmitDept VARCHAR(10), DischargeDept VARCHAR(10), AttendingDocID INT, AdmitDiagnosis VARCHAR(20),
    DischargeDiag VARCHAR(20), Outcome VARCHAR(10), Status VARCHAR(20), LoadedAt DATETIME DEFAULT GETDATE()
);

IF OBJECT_ID('dbo.stg_Diagnoses', 'U') IS NOT NULL DROP TABLE dbo.stg_Diagnoses;
CREATE TABLE dbo.stg_Diagnoses (
    DiagnosisID INT, AdmissionID INT, ICDCode VARCHAR(20), DiagType VARCHAR(10),
    DiagDate DATETIME, IsCurrent BIT, ReplacedBy INT, LoadedAt DATETIME DEFAULT GETDATE()
);

IF OBJECT_ID('dbo.stg_BedAssignments', 'U') IS NOT NULL DROP TABLE dbo.stg_BedAssignments;
CREATE TABLE dbo.stg_BedAssignments (
    AssignmentID INT, AdmissionID INT, BedID INT, AssignDate DATETIME, ReleaseDate DATETIME, LoadedAt DATETIME DEFAULT GETDATE()
);

IF OBJECT_ID('dbo.stg_ServiceLines', 'U') IS NOT NULL DROP TABLE dbo.stg_ServiceLines;
CREATE TABLE dbo.stg_ServiceLines (
    ServiceLineID INT, AdmissionID INT, ServiceDate DATE, ServiceCode VARCHAR(20), ServiceName NVARCHAR(100),
    Category VARCHAR(20), Quantity DECIMAL(18,2), UnitPrice DECIMAL(18,2), Amount DECIMAL(18,2), DeptCode VARCHAR(10), CreatedAt DATETIME, LoadedAt DATETIME DEFAULT GETDATE()
);

IF OBJECT_ID('dbo.stg_ICD10', 'U') IS NOT NULL DROP TABLE dbo.stg_ICD10;
CREATE TABLE dbo.stg_ICD10 (
    ICDCode VARCHAR(20), ICDName NVARCHAR(200), Chapter VARCHAR(10), GroupCode VARCHAR(20), LoadedAt DATETIME DEFAULT GETDATE()
);
GO