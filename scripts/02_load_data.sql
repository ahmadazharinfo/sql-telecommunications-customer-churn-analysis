/* ============================================================
   Telco Customer Churn - Data Load Script
   Loads the 4 normalized CSV files into telco schema tables.
   Run 01_create_database_and_schema.sql BEFORE this script.

   IMPORTANT: Update the file paths below to match where you
   saved the CSV files on your machine (or the SQL Server's
   file system if running BULK INSERT server-side).
   ============================================================ */

USE TelcoChurnDB;
GO

-- Update this path to wherever you placed the CSV files
DECLARE @FolderPath NVARCHAR(500) = 'C:\telco_data\';
GO

/* Load order matters: customers first (parent), then the 3 tables
   that reference it via foreign key. */

-- 1. customers
BULK INSERT telco.customers
FROM 'C:\telco_data\customers.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',   -- UTF-8
    TABLOCK
);
GO

-- 2. phone_services
BULK INSERT telco.phone_services
FROM 'C:\telco_data\phone_services.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    TABLOCK
);
GO

-- 3. internet_services
BULK INSERT telco.internet_services
FROM 'C:\telco_data\internet_services.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    TABLOCK
);
GO

-- 4. accounts
BULK INSERT telco.accounts
FROM 'C:\telco_data\accounts.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    TABLOCK
);
GO

/* ============================================================
   Verification: row counts should all be 7043
   ============================================================ */
SELECT 'customers' AS TableName, COUNT(*) AS RecordCount FROM telco.customers
UNION ALL
SELECT 'phone_services', COUNT(*) FROM telco.phone_services
UNION ALL
SELECT 'internet_services', COUNT(*) FROM telco.internet_services
UNION ALL
SELECT 'accounts', COUNT(*) FROM telco.accounts;
GO

-- Spot check: TotalCharges should have exactly 11 NULLs (tenure = 0 customers)
SELECT COUNT(*) AS NullTotalCharges
FROM telco.accounts
WHERE TotalCharges IS NULL;
GO
