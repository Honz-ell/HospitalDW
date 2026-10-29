USE Hospital_Mart;
GO

-- =================================================================
-- KPI 1: BÁO CÁO DOANH THU & SỐ ĐỢT ĐIỀU TRỊ THEO KHOA VÀ THÁNG
-- =================================================================
IF OBJECT_ID('dbo.vw_KPI_Revenue_By_Dept_Month', 'V') IS NOT NULL DROP VIEW dbo.vw_KPI_Revenue_By_Dept_Month;
GO
CREATE VIEW dbo.vw_KPI_Revenue_By_Dept_Month AS
SELECT 
    r.DeptName AS KhoaXuatVien,
    d.Year AS Nam,
    d.Month AS Thang,
    COUNT(f.TreatmentFactKey) AS SoDotDieuTri,
    SUM(f.TotalCost) AS TongDoanhThu,
    SUM(f.DrugCost) AS TongTienThuoc
FROM dbo.Fact_Medical_Treatment f
JOIN dbo.Dim_Resource r ON f.DischargeDeptSK = r.ResourceSK
JOIN dbo.Dim_Date d ON f.DischargeDateKey = d.DateKey
GROUP BY r.DeptName, d.Year, d.Month;
GO

-- =================================================================
-- KPI 2: BÁO CÁO NGÀY NẰM VIỆN TRUNG BÌNH (ALOS) THEO MÃ BỆNH
-- =================================================================
IF OBJECT_ID('dbo.vw_KPI_ALOS_By_Disease', 'V') IS NOT NULL DROP VIEW dbo.vw_KPI_ALOS_By_Disease;
GO
CREATE VIEW dbo.vw_KPI_ALOS_By_Disease AS
SELECT 
    diag.ICDCode AS MaBenh,
    diag.ICDName AS TenBenh,
    COUNT(f.TreatmentFactKey) AS SoCaMac,
    -- Tính ALOS (Average Length Of Stay): Trung bình số ngày nằm viện
    CAST(AVG(CAST(f.LengthOfStayDays AS FLOAT)) AS DECIMAL(5,1)) AS NgayNamVienTrungBinh
FROM dbo.Fact_Medical_Treatment f
JOIN dbo.Dim_Diagnosis diag ON f.PrimaryDiagnosisSK = diag.DiagnosisSK
GROUP BY diag.ICDCode, diag.ICDName;
GO