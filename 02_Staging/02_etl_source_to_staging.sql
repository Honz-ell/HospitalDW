USE Hospital_Staging;
GO

TRUNCATE TABLE dbo.stg_Patients;
TRUNCATE TABLE dbo.stg_Departments;
TRUNCATE TABLE dbo.stg_Staff;
TRUNCATE TABLE dbo.stg_Beds;
TRUNCATE TABLE dbo.stg_Admissions;
TRUNCATE TABLE dbo.stg_Diagnoses;
TRUNCATE TABLE dbo.stg_BedAssignments;
TRUNCATE TABLE dbo.stg_ServiceLines;
TRUNCATE TABLE dbo.stg_ICD10;

INSERT INTO dbo.stg_Patients (PatientID, FullName, DOB, Gender, NationalID, InsuranceNo, InsuranceType)
SELECT PatientID, LTRIM(RTRIM(FullName)), DOB, Gender, NationalID, InsuranceNo, InsuranceType FROM Hospital_Source.dbo.Patients;

INSERT INTO dbo.stg_Departments (DeptCode, DeptName, Floor)
SELECT DeptCode, DeptName, Floor FROM Hospital_Source.dbo.Departments;

INSERT INTO dbo.stg_Staff (StaffID, FullName, DeptCode, Title, EffectiveFrom, EffectiveTo)
SELECT StaffID, FullName, DeptCode, Title, EffectiveFrom, EffectiveTo FROM Hospital_Source.dbo.Staff;

INSERT INTO dbo.stg_Beds (BedID, BedCode, DeptCode, BedType, Status)
SELECT BedID, BedCode, DeptCode, BedType, Status FROM Hospital_Source.dbo.Beds;

INSERT INTO dbo.stg_Admissions (AdmissionID, PatientID, AdmitDate, DischargeDate, AdmitDept, DischargeDept, AttendingDocID, AdmitDiagnosis, DischargeDiag, Outcome, Status)
SELECT AdmissionID, PatientID, AdmitDate, DischargeDate, AdmitDept, DischargeDept, AttendingDocID, AdmitDiagnosis, DischargeDiag, Outcome, Status FROM Hospital_Source.dbo.Admissions;

INSERT INTO dbo.stg_Diagnoses (DiagnosisID, AdmissionID, ICDCode, DiagType, DiagDate, IsCurrent, ReplacedBy)
SELECT DiagnosisID, AdmissionID, ICDCode, DiagType, DiagDate, IsCurrent, ReplacedBy FROM Hospital_Source.dbo.Diagnoses;

INSERT INTO dbo.stg_BedAssignments (AssignmentID, AdmissionID, BedID, AssignDate, ReleaseDate)
SELECT AssignmentID, AdmissionID, BedID, AssignDate, ReleaseDate FROM Hospital_Source.dbo.BedAssignments;

INSERT INTO dbo.stg_ServiceLines (ServiceLineID, AdmissionID, ServiceDate, ServiceCode, ServiceName, Category, Quantity, UnitPrice, Amount, DeptCode, CreatedAt)
SELECT ServiceLineID, AdmissionID, ServiceDate, ServiceCode, ServiceName, Category, Quantity, UnitPrice, Amount, DeptCode, CreatedAt FROM Hospital_Source.dbo.ServiceLines;

INSERT INTO dbo.stg_ICD10 (ICDCode, ICDName, Chapter, GroupCode)
SELECT ICDCode, ICDName, Chapter, GroupCode FROM Hospital_Source.dbo.ICD10;
GO