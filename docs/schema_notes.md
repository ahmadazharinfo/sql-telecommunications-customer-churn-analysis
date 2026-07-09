# Telco Churn - Normalized Schema

Split from the original flat file (7,043 rows, 21 columns) into 4 tables joined on `customerID`.

## Tables

**customers** (dimension, 5 cols)
customerID (PK), gender, SeniorCitizen, Partner, Dependents

**phone_services** (dimension, 3 cols)
customerID (PK/FK), PhoneService, MultipleLines

**internet_services** (dimension, 8 cols)
customerID (PK/FK), InternetService, OnlineSecurity, OnlineBackup, DeviceProtection, TechSupport, StreamingTV, StreamingMovies

**accounts** (fact table, 8 cols)
customerID (PK/FK), tenure, Contract, PaperlessBilling, PaymentMethod, MonthlyCharges, TotalCharges, Churn

## Notes

- customerID is the shared key across all four tables, so every table joins back to customers with a simple `INNER JOIN ... ON customerID`.
- TotalCharges had 11 blank values in the original file, all belonging to customers with tenure = 0 (brand new customers who haven't been billed yet). These were converted to NULL rather than 0, since 0 would incorrectly suggest a billed amount. Worth mentioning this data quality fix in your documentation, it's exactly the kind of judgment call interviewers ask about.
- This split is intentionally shallow (4 tables) to keep joins learnable. If you want to go deeper for the portfolio version, you could split internet_services further into internet_plans and internet_addons (a proper many-to-one addon table), which would let you practice more complex joins and would look more like a real schema.

## Suggested next step

Load these 4 CSVs into SQL Server as tables, then write the CREATE TABLE statements with proper PK/FK constraints and data types before importing. That constraint definition step is itself good practice and something you'd want to document (like your naming conventions doc on the Medallion project).
