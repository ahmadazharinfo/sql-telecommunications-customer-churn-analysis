/* ============================================================
   Telco Customer Churn - Database and Schema Creation
   Schema name: telco
   Target: SQL Server / T-SQL
   ============================================================ */

-- 1. Create the database
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'TelcoChurnDB')
BEGIN
    CREATE DATABASE TelcoChurnDB;
END
GO

USE TelcoChurnDB;
GO

-- 2. Create the schema
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'telco')
BEGIN
    EXEC('CREATE SCHEMA telco');
END
GO

-- 3. Drop tables if they already exist (children first, then parent)
IF OBJECT_ID('telco.accounts', 'U') IS NOT NULL DROP TABLE telco.accounts;
IF OBJECT_ID('telco.internet_services', 'U') IS NOT NULL DROP TABLE telco.internet_services;
IF OBJECT_ID('telco.phone_services', 'U') IS NOT NULL DROP TABLE telco.phone_services;
IF OBJECT_ID('telco.customers', 'U') IS NOT NULL DROP TABLE telco.customers;
GO

-- 4. customers: core demographic dimension (parent table)
CREATE TABLE telco.customers (
    customerID      VARCHAR(10)  NOT NULL PRIMARY KEY,
    gender          VARCHAR(10)  NOT NULL,
    SeniorCitizen   TINYINT      NOT NULL,   -- 0 or 1
    Partner         VARCHAR(3)   NOT NULL,   -- Yes/No
    Dependents      VARCHAR(3)   NOT NULL    -- Yes/No
);
GO

-- 5. phone_services: phone plan details
CREATE TABLE telco.phone_services (
    customerID      VARCHAR(10)  NOT NULL PRIMARY KEY,
    PhoneService    VARCHAR(3)   NOT NULL,
    MultipleLines   VARCHAR(20)  NOT NULL,
    CONSTRAINT FK_phone_services_customers
        FOREIGN KEY (customerID) REFERENCES telco.customers(customerID)
);
GO

-- 6. internet_services: internet plan and add-ons
CREATE TABLE telco.internet_services (
    customerID       VARCHAR(10)  NOT NULL PRIMARY KEY,
    InternetService  VARCHAR(20)  NOT NULL,
    OnlineSecurity   VARCHAR(20)  NOT NULL,
    OnlineBackup     VARCHAR(20)  NOT NULL,
    DeviceProtection VARCHAR(20)  NOT NULL,
    TechSupport      VARCHAR(20)  NOT NULL,
    StreamingTV      VARCHAR(20)  NOT NULL,
    StreamingMovies  VARCHAR(20)  NOT NULL,
    CONSTRAINT FK_internet_services_customers
        FOREIGN KEY (customerID) REFERENCES telco.customers(customerID)
);
GO

-- 7. accounts: billing, contract, tenure, churn (fact table)
CREATE TABLE telco.accounts (
    customerID        VARCHAR(10)    NOT NULL PRIMARY KEY,
    tenure            INT            NOT NULL,
    Contract          VARCHAR(20)    NOT NULL,
    PaperlessBilling  VARCHAR(3)     NOT NULL,
    PaymentMethod     VARCHAR(30)    NOT NULL,
    MonthlyCharges    DECIMAL(10,2)  NOT NULL,
    TotalCharges      DECIMAL(10,2)  NULL,        -- NULL for 11 new customers (tenure = 0)
    Churn             VARCHAR(3)     NOT NULL,
    CONSTRAINT FK_accounts_customers
        FOREIGN KEY (customerID) REFERENCES telco.customers(customerID)
);
GO

PRINT 'Database, schema, and tables created successfully.';
