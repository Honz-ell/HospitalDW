HospitalDW/
├── 01_Source/          -- DDL + data source
├── 02_Staging/         -- ETL staging
├── 03_Atomic/          -- Tầng tích hợp
├── 04_Mart/            -- Star schema
├── 05_Summary/         -- Aggregation
├── 06_SSAS/            -- Cube project
├── 07_Tests/           -- Test scripts + logs
├── 08_Generator/       -- Script sinh dữ liệu
├── 09_Docs/            -- Báo cáo, slide
└── README.md


# HƯỚNG DẪN TÁI TẠO HỆ THỐNG KHO DỮ LIỆU BỆNH VIỆN (HOSPITAL DW)

Để dựng lại toàn bộ CSDL trên SQL Server cá nhân, chạy lần lượt các file SQL theo thứ tự:

1. `01_Source/01_init_source_and_master_data.sql` (Khởi tạo DB Nguồn + Master Data)
2. `08_Generator/01_generate_mock_data.sql` (Sinh dữ liệu giao dịch mô phỏng)
3. `02_Staging/01_create_staging_tables.sql` (Khởi tạo DB Staging)
4. `02_Staging/02_etl_source_to_staging.sql` (ETL Nguồn -> Staging)
5. `03_Atomic/01_create_atomic_tables.sql` (Khởi tạo DB Atomic)
6. `03_Atomic/02_etl_staging_to_atomic.sql` (ETL Staging -> Atomic)
7. `04_Mart/01_create_mart_tables.sql` (Khởi tạo DB Mart)
8. `04_Mart/02_seed_dim_date.sql` (Sinh dữ liệu ngày Dim_Date)