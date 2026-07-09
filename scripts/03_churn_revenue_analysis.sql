/* ============================================================
   Telco Customer Churn - Full Data Analysis
   Database: TelcoChurnDB | Schema: telco
   Tables: customers, phone_services, internet_services, accounts

   Structure:
     Section 1: Churn Overview
     Section 2: Revenue Analysis
     Section 3: Customer Segmentation
     Section 4: Service & Add-on Impact on Churn
     Section 5: Tenure Cohort Analysis
     Section 6: Customer Risk Scoring
   ============================================================ */

USE TelcoChurnDB;
GO

/* ============================================================
   SECTION 1: CHURN OVERVIEW
   ============================================================ */

-- 1.1 Overall churn rate
SELECT
    COUNT(*) AS TotalCustomers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomers,
    CAST(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS DECIMAL(10,2))
        / COUNT(*) * 100 AS ChurnRatePct
FROM telco.accounts;
GO

-- 1.2 Churn rate by contract type
SELECT
    Contract,
    COUNT(*) AS TotalCustomers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomers,
    CAST(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS DECIMAL(10,2))
        / COUNT(*) * 100 AS ChurnRatePct
FROM telco.accounts
GROUP BY Contract
ORDER BY ChurnRatePct DESC;
GO

-- 1.3 Churn rate by payment method
SELECT
    PaymentMethod,
    COUNT(*) AS TotalCustomers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomers,
    CAST(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS DECIMAL(10,2))
        / COUNT(*) * 100 AS ChurnRatePct
FROM telco.accounts
GROUP BY PaymentMethod
ORDER BY ChurnRatePct DESC;
GO

-- 1.4 Churn rate by internet service type
SELECT
    i.InternetService,
    COUNT(*) AS TotalCustomers,
    SUM(CASE WHEN a.Churn = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomers,
    CAST(SUM(CASE WHEN a.Churn = 'Yes' THEN 1 ELSE 0 END) AS DECIMAL(10,2))
        / COUNT(*) * 100 AS ChurnRatePct
FROM telco.accounts a
INNER JOIN telco.internet_services i ON a.customerID = i.customerID
GROUP BY i.InternetService
ORDER BY ChurnRatePct DESC;
GO

-- 1.5 Churn rate by demographic (senior citizen, partner, dependents)
SELECT
    c.SeniorCitizen,
    c.Partner,
    c.Dependents,
    COUNT(*) AS TotalCustomers,
    SUM(CASE WHEN a.Churn = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomers,
    CAST(SUM(CASE WHEN a.Churn = 'Yes' THEN 1 ELSE 0 END) AS DECIMAL(10,2))
        / COUNT(*) * 100 AS ChurnRatePct
FROM telco.customers c
INNER JOIN telco.accounts a ON c.customerID = a.customerID
GROUP BY c.SeniorCitizen, c.Partner, c.Dependents
ORDER BY ChurnRatePct DESC;
GO

/* ============================================================
   SECTION 2: REVENUE ANALYSIS
   ============================================================ */

-- 2.1 Total monthly recurring revenue (MRR) and revenue at risk from churned customers
SELECT
    SUM(MonthlyCharges) AS TotalMonthlyRevenue,
    SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END) AS MonthlyRevenueLostToChurn,
    SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END) * 12 AS ProjectedAnnualRevenueLoss
FROM telco.accounts;
GO

-- 2.2 Average revenue per user (ARPU) by churn status
SELECT
    Churn,
    COUNT(*) AS CustomerCount,
    AVG(MonthlyCharges) AS AvgMonthlyCharges,
    AVG(TotalCharges) AS AvgTotalCharges
FROM telco.accounts
GROUP BY Churn;
GO

-- 2.3 Revenue by contract type (which contracts generate the most, and how much of that is at risk)
SELECT
    Contract,
    COUNT(*) AS CustomerCount,
    SUM(MonthlyCharges) AS TotalMonthlyRevenue,
    SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END) AS MonthlyRevenueAtRisk,
    CAST(SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END) AS DECIMAL(10,2))
        / SUM(MonthlyCharges) * 100 AS PctRevenueAtRisk
FROM telco.accounts
GROUP BY Contract
ORDER BY TotalMonthlyRevenue DESC;
GO

-- 2.4 Top 20 highest-value customers who churned (biggest single losses)
SELECT TOP 20
    a.customerID,
    a.tenure,
    a.Contract,
    a.MonthlyCharges,
    a.TotalCharges,
    a.Churn
FROM telco.accounts a
WHERE a.Churn = 'Yes'
ORDER BY a.MonthlyCharges DESC;
GO

/* ============================================================
   SECTION 3: CUSTOMER SEGMENTATION
   ============================================================ */

-- 3.1 Segment customers by tenure bucket
SELECT
    CASE
        WHEN tenure <= 12 THEN '0-12 months (New)'
        WHEN tenure <= 24 THEN '13-24 months'
        WHEN tenure <= 48 THEN '25-48 months'
        ELSE '49-72 months (Loyal)'
    END AS TenureSegment,
    COUNT(*) AS CustomerCount,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCount,
    CAST(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS DECIMAL(10,2))
        / COUNT(*) * 100 AS ChurnRatePct,
    AVG(MonthlyCharges) AS AvgMonthlyCharges
FROM telco.accounts
GROUP BY
    CASE
        WHEN tenure <= 12 THEN '0-12 months (New)'
        WHEN tenure <= 24 THEN '13-24 months'
        WHEN tenure <= 48 THEN '25-48 months'
        ELSE '49-72 months (Loyal)'
    END
ORDER BY MIN(tenure);
GO

-- 3.2 Segment by number of services subscribed (phone + internet add-ons)
WITH ServiceCounts AS (
    SELECT
        a.customerID,
        a.Churn,
        a.MonthlyCharges,
        (CASE WHEN p.PhoneService = 'Yes' THEN 1 ELSE 0 END
       + CASE WHEN i.OnlineSecurity = 'Yes' THEN 1 ELSE 0 END
       + CASE WHEN i.OnlineBackup = 'Yes' THEN 1 ELSE 0 END
       + CASE WHEN i.DeviceProtection = 'Yes' THEN 1 ELSE 0 END
       + CASE WHEN i.TechSupport = 'Yes' THEN 1 ELSE 0 END
       + CASE WHEN i.StreamingTV = 'Yes' THEN 1 ELSE 0 END
       + CASE WHEN i.StreamingMovies = 'Yes' THEN 1 ELSE 0 END) AS ServiceCount
    FROM telco.accounts a
    INNER JOIN telco.phone_services p ON a.customerID = p.customerID
    INNER JOIN telco.internet_services i ON a.customerID = i.customerID
)
SELECT
    ServiceCount,
    COUNT(*) AS CustomerCount,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCount,
    CAST(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS DECIMAL(10,2))
        / COUNT(*) * 100 AS ChurnRatePct,
    AVG(MonthlyCharges) AS AvgMonthlyCharges
FROM ServiceCounts
GROUP BY ServiceCount
ORDER BY ServiceCount;
GO

-- 3.3 Cross-tab: Contract type x Internet Service x Churn rate
SELECT
    a.Contract,
    i.InternetService,
    COUNT(*) AS CustomerCount,
    CAST(SUM(CASE WHEN a.Churn = 'Yes' THEN 1 ELSE 0 END) AS DECIMAL(10,2))
        / COUNT(*) * 100 AS ChurnRatePct
FROM telco.accounts a
INNER JOIN telco.internet_services i ON a.customerID = i.customerID
GROUP BY a.Contract, i.InternetService
ORDER BY a.Contract, ChurnRatePct DESC;
GO

/* ============================================================
   SECTION 4: SERVICE & ADD-ON IMPACT ON CHURN
   ============================================================ */

-- 4.1 Does having Tech Support reduce churn?
SELECT
    TechSupport,
    COUNT(*) AS CustomerCount,
    CAST(SUM(CASE WHEN a.Churn = 'Yes' THEN 1 ELSE 0 END) AS DECIMAL(10,2))
        / COUNT(*) * 100 AS ChurnRatePct
FROM telco.internet_services i
INNER JOIN telco.accounts a ON i.customerID = a.customerID
GROUP BY TechSupport
ORDER BY ChurnRatePct DESC;
GO

-- 4.2 Does Online Security reduce churn?
SELECT
    OnlineSecurity,
    COUNT(*) AS CustomerCount,
    CAST(SUM(CASE WHEN a.Churn = 'Yes' THEN 1 ELSE 0 END) AS DECIMAL(10,2))
        / COUNT(*) * 100 AS ChurnRatePct
FROM telco.internet_services i
INNER JOIN telco.accounts a ON i.customerID = a.customerID
GROUP BY OnlineSecurity
ORDER BY ChurnRatePct DESC;
GO

-- 4.3 Streaming services: do they increase or decrease churn?
SELECT
    StreamingTV,
    StreamingMovies,
    COUNT(*) AS CustomerCount,
    CAST(SUM(CASE WHEN a.Churn = 'Yes' THEN 1 ELSE 0 END) AS DECIMAL(10,2))
        / COUNT(*) * 100 AS ChurnRatePct
FROM telco.internet_services i
INNER JOIN telco.accounts a ON i.customerID = a.customerID
GROUP BY StreamingTV, StreamingMovies
ORDER BY ChurnRatePct DESC;
GO

-- 4.4 Multiple lines impact on churn
SELECT
    MultipleLines,
    COUNT(*) AS CustomerCount,
    CAST(SUM(CASE WHEN a.Churn = 'Yes' THEN 1 ELSE 0 END) AS DECIMAL(10,2))
        / COUNT(*) * 100 AS ChurnRatePct
FROM telco.phone_services p
INNER JOIN telco.accounts a ON p.customerID = a.customerID
GROUP BY MultipleLines
ORDER BY ChurnRatePct DESC;
GO

/* ============================================================
   SECTION 5: TENURE COHORT ANALYSIS
   ============================================================ */

-- 5.1 Churn rate and revenue by exact tenure month (early-lifecycle drop-off pattern)
SELECT
    tenure,
    COUNT(*) AS CustomerCount,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCount,
    CAST(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS DECIMAL(10,2))
        / COUNT(*) * 100 AS ChurnRatePct
FROM telco.accounts
GROUP BY tenure
ORDER BY tenure;
GO

-- 5.2 Running cumulative retained customers by tenure month (using a window function)
SELECT
    tenure,
    COUNT(*) AS CustomersAtThisTenure,
    SUM(COUNT(*)) OVER (ORDER BY tenure ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS CumulativeCustomers
FROM telco.accounts
GROUP BY tenure
ORDER BY tenure;
GO

/* ============================================================
   SECTION 6: CUSTOMER RISK SCORING
   ============================================================ */

-- 6.1 Build a simple rule-based churn risk score for ACTIVE customers
--     (customers who haven't churned yet, ranked by risk factors)
WITH RiskFactors AS (
    SELECT
        a.customerID,
        a.tenure,
        a.Contract,
        a.PaymentMethod,
        a.MonthlyCharges,
        i.TechSupport,
        i.OnlineSecurity,
        (CASE WHEN a.Contract = 'Month-to-month' THEN 2 ELSE 0 END
       + CASE WHEN a.PaymentMethod = 'Electronic check' THEN 1 ELSE 0 END
       + CASE WHEN i.TechSupport = 'No' THEN 1 ELSE 0 END
       + CASE WHEN i.OnlineSecurity = 'No' THEN 1 ELSE 0 END
       + CASE WHEN a.tenure <= 12 THEN 2 ELSE 0 END
       + CASE WHEN a.PaperlessBilling = 'Yes' THEN 1 ELSE 0 END) AS RiskScore
    FROM telco.accounts a
    INNER JOIN telco.internet_services i ON a.customerID = i.customerID
    WHERE a.Churn = 'No'
)
SELECT
    customerID,
    tenure,
    Contract,
    PaymentMethod,
    MonthlyCharges,
    RiskScore,
    NTILE(4) OVER (ORDER BY RiskScore DESC) AS RiskQuartile
    -- RiskQuartile 1 = highest risk 25% of active customers, prioritize for retention outreach
FROM RiskFactors
ORDER BY RiskScore DESC;
GO

-- 6.2 Summary: how many active customers fall in each risk quartile, and their revenue value
WITH RiskFactors AS (
    SELECT
        a.customerID,
        a.MonthlyCharges,
        (CASE WHEN a.Contract = 'Month-to-month' THEN 2 ELSE 0 END
       + CASE WHEN a.PaymentMethod = 'Electronic check' THEN 1 ELSE 0 END
       + CASE WHEN i.TechSupport = 'No' THEN 1 ELSE 0 END
       + CASE WHEN i.OnlineSecurity = 'No' THEN 1 ELSE 0 END
       + CASE WHEN a.tenure <= 12 THEN 2 ELSE 0 END
       + CASE WHEN a.PaperlessBilling = 'Yes' THEN 1 ELSE 0 END) AS RiskScore
    FROM telco.accounts a
    INNER JOIN telco.internet_services i ON a.customerID = i.customerID
    WHERE a.Churn = 'No'
),
Scored AS (
    SELECT *, NTILE(4) OVER (ORDER BY RiskScore DESC) AS RiskQuartile
    FROM RiskFactors
)
SELECT
    RiskQuartile,
    COUNT(*) AS CustomerCount,
    SUM(MonthlyCharges) AS MonthlyRevenueInQuartile
FROM Scored
GROUP BY RiskQuartile
ORDER BY RiskQuartile;
GO
