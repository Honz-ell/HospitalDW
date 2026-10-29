-- Mở tính năng đo thời gian (CPU/Elapsed Time) và số lượt đọc đĩa (Logical Reads)
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
GO

PRINT '==================================================';
PRINT '1. TRUY VẤN TẠI TẦNG ATOMIC (Inmon - Chi tiết 3NF)';
PRINT '==================================================';
SELECT 
    d.DeptName AS KhoaXuatVien,
    COUNT(DISTINCT e.EpisodeSK) AS SoDot,
    SUM(s.Amount) AS TongDoanhThu
FROM Hospital_Atomic.dbo.atm_Episodes e
JOIN Hospital_Atomic.dbo.atm_Departments d ON e.DischargeDeptCode = d.DeptCode
JOIN Hospital_Atomic.dbo.atm_ServiceLines s ON e.SourceAdmissionID = s.SourceAdmissionID
GROUP BY d.DeptName;
GO

PRINT '==================================================';
PRINT '2. TRUY VẤN TẠI TẦNG MART (Kimball - Star Schema)';
PRINT '==================================================';
SELECT 
    r.DeptName AS KhoaXuatVien,
    COUNT(f.TreatmentFactKey) AS SoDot,
    SUM(f.TotalCost) AS TongDoanhThu
FROM Hospital_Mart.dbo.Fact_Medical_Treatment f
JOIN Hospital_Mart.dbo.Dim_Resource r ON f.DischargeDeptSK = r.ResourceSK
GROUP BY r.DeptName;
GO

PRINT '==================================================';
PRINT '3. TRUY VẤN TẠI TẦNG SUMMARY (Aggregated View)';
PRINT '==================================================';
SELECT 
    KhoaXuatVien,
    SUM(SoDotDieuTri) AS SoDot,
    SUM(TongDoanhThu) AS TongDoanhThu
FROM Hospital_Mart.dbo.vw_KPI_Revenue_By_Dept_Month
GROUP BY KhoaXuatVien;
GO

-- Tắt đo hiệu năng
SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO