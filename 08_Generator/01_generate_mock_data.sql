USE Hospital_Source;
GO

-- 1. Sinh 30 bệnh nhân
DECLARE @i INT = 1;
WHILE @i <= 30
BEGIN
    INSERT INTO dbo.Patients (PatientID, FullName, DOB, Gender, NationalID, InsuranceNo, InsuranceType)
    VALUES (
        @i, N'Bệnh nhân ' + CAST(@i AS NVARCHAR),
        DATEADD(YEAR, -20 - (@i % 40), '2025-01-01'),
        CASE WHEN @i % 2 = 0 THEN 'M' ELSE 'F' END,
        '0' + RIGHT('00000000' + CAST(@i AS VARCHAR), 8),
        CASE WHEN @i % 3 = 0 THEN NULL ELSE 'BHYT-' + RIGHT('0000' + CAST(@i AS VARCHAR), 4) END,
        CASE WHEN @i % 3 = 0 THEN 'Khong' WHEN @i % 3 = 1 THEN 'BHYT' ELSE 'BHNT' END
    );
    SET @i = @i + 1;
END;

-- 2. Sinh 50 đợt điều trị + chẩn đoán + phân giường + viện phí
DELETE FROM dbo.ServiceLines;
DELETE FROM dbo.BedAssignments;
DELETE FROM dbo.Diagnoses;
DELETE FROM dbo.Admissions;

DECLARE @a INT = 1;
DECLARE @PatientID INT, @Dept VARCHAR(10), @DocID INT, @BedID INT;
DECLARE @AdmitDate DATETIME, @DischargeDate DATETIME, @LOS INT;
DECLARE @ICD VARCHAR(20), @Outcome VARCHAR(10);

WHILE @a <= 50
BEGIN
    SET @PatientID = (ABS(CHECKSUM(NEWID())) % 30) + 1;
    SELECT TOP 1 @Dept = DeptCode FROM dbo.Departments ORDER BY NEWID();
    SELECT TOP 1 @DocID = StaffID FROM dbo.Staff ORDER BY NEWID();
    SELECT TOP 1 @ICD = ICDCode FROM dbo.ICD10 ORDER BY NEWID();
    SELECT TOP 1 @BedID = BedID FROM dbo.Beds ORDER BY NEWID();
    
    SET @Outcome = CASE (ABS(CHECKSUM(NEWID())) % 4)
        WHEN 0 THEN 'Khoi' WHEN 1 THEN 'Do' WHEN 2 THEN 'KDoi' ELSE 'Nang' END;

    SET @AdmitDate = DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 365, '2024-01-01');
    SET @LOS = (ABS(CHECKSUM(NEWID())) % 12) + 3;
    SET @DischargeDate = DATEADD(DAY, @LOS, @AdmitDate);

    INSERT INTO dbo.Admissions VALUES (
        @a, @PatientID, @AdmitDate, @DischargeDate, @Dept, @Dept, @DocID, @ICD, @ICD, @Outcome, 'Discharged'
    );

    INSERT INTO dbo.Diagnoses (AdmissionID, ICDCode, DiagType, DiagDate, IsCurrent, ReplacedBy)
    VALUES (@a, @ICD, 'Chinh', @AdmitDate, 1, NULL);

    INSERT INTO dbo.BedAssignments (AdmissionID, BedID, AssignDate, ReleaseDate)
    VALUES (@a, @BedID, @AdmitDate, @DischargeDate);

    INSERT INTO dbo.ServiceLines (AdmissionID, ServiceDate, ServiceCode, ServiceName, Category, Quantity, UnitPrice, Amount, DeptCode, CreatedAt)
    VALUES 
    (@a, CAST(@AdmitDate AS DATE), 'DV001', N'Khám bệnh nội khoa', 'Kham', 1, 150000, 150000, @Dept, @AdmitDate),
    (@a, CAST(@AdmitDate AS DATE), 'DV002', N'Xét nghiệm máu tổng quát', 'XetNghiem', 1, 350000, 350000, @Dept, @AdmitDate),
    (@a, CAST(@AdmitDate AS DATE), 'TH001', N'Thuốc điều trị chính', 'Thuoc', @LOS, 80000, @LOS * 80000, @Dept, @AdmitDate);

    SET @a = @a + 1;
END;
GO