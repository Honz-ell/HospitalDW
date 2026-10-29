USE Hospital_Mart;
GO

-- =================================================================
-- TEST 1: CHỨNG MINH QUẢN LÝ LỊCH SỬ BÁC SĨ CHUYỂN KHOA (SCD TYPE 2)
-- Bác sĩ Lê Hoàng Cường (StaffID = 3) chuyển từ khoa NOI sang HSCC
-- =================================================================
SELECT 
    StaffSK,
    StaffID,
    FullName AS TenBacSi,
    DeptCode AS KhoaCongTac,
    Title AS ChucDanh,
    ValidFrom AS NgayBatDau,
    ValidTo AS NgayKetThuc,
    IsCurrent AS DangHieuLuc
FROM dbo.Dim_Staff
WHERE StaffID = 3;


-- =================================================================
-- TEST 2: CHỨNG MINH BẢNG BRIDGE TRÁNH LỖI NHÂN ĐÔI TỔNG TIỀN VIỆN PHÍ
-- (So sánh 2 cách JOIN: JOIN trực tiếp qua Bridge vs JOIN qua Fact chuẩn)
-- =================================================================

-- Cách A (ĐÚNG): Lấy tổng tiền từ Fact_Medical_Treatment (Không bị nhân trùng)
SELECT 
    'Fact Chuẩn (ĐÚNG)' AS PhuongPhap,
    COUNT(TreatmentFactKey) AS TongSoDot,
    SUM(TotalCost) AS TongTienChinhXac
FROM dbo.Fact_Medical_Treatment;

-- Cách B (SAI NẾU KHÔNG DÙNG BRIDGE TRỌNG SỐ):
-- Khi JOIN đợt điều trị với bảng Bridge nhiều chẩn đoán, nếu SUM(TotalCost) trực tiếp sẽ bị nhân bản số tiền!
SELECT 
    'Nối Bridge (Nếu đếm trùng)' AS PhuongPhap,
    COUNT(f.TreatmentFactKey) AS TongSoDongSauJoin,
    SUM(f.TotalCost) AS TongTienBiNhanTrung
FROM dbo.Fact_Medical_Treatment f
JOIN dbo.Bridge_Episode_Diagnosis b ON f.EpisodeID = b.EpisodeID;
GO