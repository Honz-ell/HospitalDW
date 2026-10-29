USE Hospital_Atomic;
GO

TRUNCATE TABLE dbo.atm_Patients;
TRUNCATE TABLE dbo.atm_Departments;
TRUNCATE TABLE dbo.atm_Staff;
TRUNCATE TABLE dbo.atm_Beds;
TRUNCATE TABLE dbo.atm_Episodes;
TRUNCATE TABLE dbo.atm_DiagnosisEvents;
TRUNCATE TABLE dbo.atm_BedAssignments;
TRUNCATE TABLE dbo.atm_ServiceLines;
TRUNCATE TABLE dbo.atm_ICD10;

INSERT INTO dbo.atm_Patients (SourcePatientID, FullName, DOB, Gender, NationalID, InsuranceNo, InsuranceType, ValidFrom, IsCurrent)
SELECT PatientID, FullName, DOB, Gender, NationalID, InsuranceNo, InsuranceType, '2024-01-01', 1 FROM Hospital_Staging.dbo.stg_Patients;

INSERT INTO dbo.atm_Departments (DeptCode, DeptName, Floor)
SELECT DeptCode, DeptName, Floor FROM Hospital_Staging.dbo.stg_Departments;

INSERT INTO dbo.atm_Staff (SourceStaffID, FullName, DeptCode, Title, ValidFrom, ValidTo, IsCurrent)
SELECT StaffID, FullName, DeptCode, Title, ISNULL(EffectiveFrom, '2023-01-01'), EffectiveTo, CASE WHEN EffectiveTo IS NULL THEN 1 ELSE 0 END FROM Hospital_Staging.dbo.stg_Staff;

INSERT INTO dbo.atm_Beds (SourceBedID, BedCode, DeptCode, BedType, Status)
SELECT BedID, BedCode, DeptCode, BedType, Status FROM Hospital_Staging.dbo.stg_Beds;

INSERT INTO dbo.atm_Episodes (SourceAdmissionID, SourcePatientID, AdmitDate, DischargeDate, AdmitDeptCode, DischargeDeptCode, AttendingDocID, AdmitDiagnosis, DischargeDiag, Outcome, Status, LengthOfStay)
SELECT AdmissionID, PatientID, AdmitDate, DischargeDate, AdmitDept, DischargeDept, AttendingDocID, AdmitDiagnosis, DischargeDiag, Outcome, Status, DATEDIFF(DAY, AdmitDate, DischargeDate) FROM Hospital_Staging.dbo.stg_Admissions;

INSERT INTO dbo.atm_DiagnosisEvents (SourceDiagnosisID, SourceAdmissionID, ICDCode, DiagType, DiagDate, IsCurrent, ReplacedByID)
SELECT DiagnosisID, AdmissionID, ICDCode, DiagType, DiagDate, IsCurrent, ReplacedBy FROM Hospital_Staging.dbo.stg_Diagnoses;

INSERT INTO dbo.atm_BedAssignments (SourceAssignID, SourceAdmissionID, SourceBedID, AssignDate, ReleaseDate, OccupiedMinutes)
SELECT AssignmentID, AdmissionID, BedID, AssignDate, ReleaseDate, DATEDIFF(MINUTE, AssignDate, ReleaseDate) FROM Hospital_Staging.dbo.stg_BedAssignments;

INSERT INTO dbo.atm_ServiceLines (SourceServiceLineID, SourceAdmissionID, ServiceDate, ServiceCode, ServiceName, Category, Quantity, UnitPrice, Amount, DeptCode)
SELECT ServiceLineID, AdmissionID, ServiceDate, ServiceCode, ServiceName, Category, Quantity, UnitPrice, Amount, DeptCode FROM Hospital_Staging.dbo.stg_ServiceLines;

INSERT INTO dbo.atm_ICD10 (ICDCode, ICDName, Chapter, GroupCode)
SELECT ICDCode, ICDName, Chapter, GroupCode FROM Hospital_Staging.dbo.stg_ICD10;
GO