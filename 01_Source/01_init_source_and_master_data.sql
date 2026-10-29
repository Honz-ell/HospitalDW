USE master;
GO

IF DB_ID('Hospital_Source') IS NULL CREATE DATABASE Hospital_Source;
GO

USE Hospital_Source;
GO

-- 1. Tạo bảng Patients
IF OBJECT_ID('dbo.Patients','U') IS NOT NULL DROP TABLE dbo.Patients;
CREATE TABLE dbo.Patients (
    PatientID       INT PRIMARY KEY,
    FullName        NVARCHAR(100) NOT NULL,
    DOB             DATE NOT NULL,
    Gender          CHAR(1) NOT NULL,
    NationalID      VARCHAR(12) NULL,
    InsuranceNo     VARCHAR(20) NULL,
    InsuranceType   VARCHAR(10) NULL
);

-- 2. Tạo bảng Departments
IF OBJECT_ID('dbo.Departments','U') IS NOT NULL DROP TABLE dbo.Departments;
CREATE TABLE dbo.Departments (
    DeptCode        VARCHAR(10) PRIMARY KEY,
    DeptName        NVARCHAR(100) NOT NULL,
    Floor           INT NULL
);

-- 3. Tạo bảng Staff
IF OBJECT_ID('dbo.Staff','U') IS NOT NULL DROP TABLE dbo.Staff;
CREATE TABLE dbo.Staff (
    StaffID         INT NOT NULL,
    FullName        NVARCHAR(100) NOT NULL,
    DeptCode        VARCHAR(10) NULL,
    Title           VARCHAR(50) NULL,
    EffectiveFrom   DATE NULL,
    EffectiveTo     DATE NULL
);

-- 4. Tạo bảng Beds
IF OBJECT_ID('dbo.Beds','U') IS NOT NULL DROP TABLE dbo.Beds;
CREATE TABLE dbo.Beds (
    BedID           INT PRIMARY KEY,
    BedCode         VARCHAR(20) NOT NULL,
    DeptCode        VARCHAR(10) NOT NULL,
    BedType         VARCHAR(20) NULL,
    Status          VARCHAR(20) NULL
);

-- 5. Tạo bảng ICD10
IF OBJECT_ID('dbo.ICD10','U') IS NOT NULL DROP TABLE dbo.ICD10;
CREATE TABLE dbo.ICD10 (
    ICDCode         VARCHAR(20) PRIMARY KEY,
    ICDName         NVARCHAR(200) NOT NULL,
    Chapter         VARCHAR(10) NULL,
    GroupCode       VARCHAR(20) NULL
);

-- 6. Tạo bảng Admissions
IF OBJECT_ID('dbo.Admissions','U') IS NOT NULL DROP TABLE dbo.Admissions;
CREATE TABLE dbo.Admissions (
    AdmissionID     INT PRIMARY KEY,
    PatientID       INT NOT NULL,
    AdmitDate       DATETIME NOT NULL,
    DischargeDate   DATETIME NULL,
    AdmitDept       VARCHAR(10) NULL,
    DischargeDept   VARCHAR(10) NULL,
    AttendingDocID  INT NULL,
    AdmitDiagnosis  VARCHAR(20) NULL,
    DischargeDiag   VARCHAR(20) NULL,
    Outcome         VARCHAR(10) NULL,
    Status          VARCHAR(20) NULL
);

-- 7. Tạo bảng Diagnoses
IF OBJECT_ID('dbo.Diagnoses','U') IS NOT NULL DROP TABLE dbo.Diagnoses;
CREATE TABLE dbo.Diagnoses (
    DiagnosisID     INT IDENTITY(1,1) PRIMARY KEY,
    AdmissionID     INT NOT NULL,
    ICDCode         VARCHAR(20) NOT NULL,
    DiagType        VARCHAR(10) NULL,
    DiagDate        DATETIME NULL,
    IsCurrent       BIT DEFAULT 1,
    ReplacedBy      INT NULL
);

-- 8. Tạo bảng BedAssignments
IF OBJECT_ID('dbo.BedAssignments','U') IS NOT NULL DROP TABLE dbo.BedAssignments;
CREATE TABLE dbo.BedAssignments (
    AssignmentID    INT IDENTITY(1,1) PRIMARY KEY,
    AdmissionID     INT NOT NULL,
    BedID           INT NOT NULL,
    AssignDate      DATETIME NULL,
    ReleaseDate     DATETIME NULL
);

-- 9. Tạo bảng ServiceLines
IF OBJECT_ID('dbo.ServiceLines','U') IS NOT NULL DROP TABLE dbo.ServiceLines;
CREATE TABLE dbo.ServiceLines (
    ServiceLineID   INT IDENTITY(1,1) PRIMARY KEY,
    AdmissionID     INT NOT NULL,
    ServiceDate     DATE NULL,
    ServiceCode     VARCHAR(20) NULL,
    ServiceName     NVARCHAR(100) NULL,
    Category        VARCHAR(20) NULL,
    Quantity        DECIMAL(18,2) NULL,
    UnitPrice       DECIMAL(18,2) NULL,
    Amount          DECIMAL(18,2) NULL,
    DeptCode        VARCHAR(10) NULL,
    CreatedAt       DATETIME DEFAULT GETDATE()
);

-- NẠP MASTER DATA
INSERT INTO dbo.Departments VALUES
('NOI', N'Nội tổng hợp', 2), ('NGOAI', N'Ngoại tổng hợp', 3), 
('SAN', N'Sản', 4), ('NHI', N'Nhi', 2), ('HSCC', N'Hồi sức cấp cứu', 1);

INSERT INTO dbo.ICD10 VALUES
('J18.9', N'Viêm phổi không xác định', 'X', 'J15-J18'),
('I10',   N'Tăng huyết áp nguyên phát', 'IX', 'I10-I15'),
('E11.9', N'Đái tháo đường type 2', 'IV', 'E10-E14'),
('K29.7', N'Viêm dạ dày', 'XI', 'K29-K31'),
('J06.9', N'Nhiễm trùng hô hấp trên cấp', 'X', 'J00-J06'),
('A09',   N'Tiêu chảy do nhiễm trùng', 'I', 'A00-A09'),
('O80',   N'Sinh thường đơn thai', 'XV', 'O80-O84'),
('S93.4', N'Bong gân mắt cá chân', 'XIX', 'S90-S99'),
('N39.0', N'Nhiễm trùng đường tiểu', 'XIV', 'N30-N39'),
('I50.9', N'Suy tim không xác định', 'IX', 'I50');

INSERT INTO dbo.Staff VALUES
(1, N'Nguyễn Văn An',   'NOI',  'BSCKII', '2023-01-01', NULL),
(2, N'Trần Thị Bình',  'NGOAI','BSCKI',  '2023-01-01', NULL),
(3, N'Lê Hoàng Cường', 'NOI',  'BS',     '2023-01-01', '2025-06-30'),
(4, N'Phạm Minh Đức',  'SAN',  'BSCKII', '2023-01-01', NULL),
(5, N'Võ Thị Hoa',     'NHI',  'BS',     '2023-01-01', NULL);

INSERT INTO dbo.Beds VALUES
(1,'NOI-01','NOI','Thuong','Active'), (2,'NOI-02','NOI','Thuong','Active'),
(3,'NGOAI-01','NGOAI','Thuong','Active'), (4,'NGOAI-02','NGOAI','VIP','Active'),
(5,'SAN-01','SAN','Thuong','Active'), (6,'NHI-01','NHI','Thuong','Active'),
(7,'HSCC-01','HSCC','HSCC','Active'), (8,'HSCC-02','HSCC','HSCC','Active'),
(9,'NOI-03','NOI','Thuong','Inactive'), (10,'NGOAI-03','NGOAI','Thuong','Active');
GO