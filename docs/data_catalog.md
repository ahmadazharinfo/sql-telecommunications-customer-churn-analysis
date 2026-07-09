# Data Catalog

## telco.customers

| Column | Type | Description | Sample values |
|---|---|---|---|
| customerID | VARCHAR(10) | Primary key, unique customer identifier | 7590-VHVEG |
| gender | VARCHAR(10) | Customer gender | Male, Female |
| SeniorCitizen | TINYINT | 1 if customer is a senior citizen, else 0 | 0, 1 |
| Partner | VARCHAR(3) | Whether the customer has a partner | Yes, No |
| Dependents | VARCHAR(3) | Whether the customer has dependents | Yes, No |

## telco.phone_services

| Column | Type | Description | Sample values |
|---|---|---|---|
| customerID | VARCHAR(10) | PK / FK to customers | 7590-VHVEG |
| PhoneService | VARCHAR(3) | Whether the customer has phone service | Yes, No |
| MultipleLines | VARCHAR(20) | Whether the customer has multiple lines | Yes, No, No phone service |

## telco.internet_services

| Column | Type | Description | Sample values |
|---|---|---|---|
| customerID | VARCHAR(10) | PK / FK to customers | 7590-VHVEG |
| InternetService | VARCHAR(20) | Type of internet service | DSL, Fiber optic, No |
| OnlineSecurity | VARCHAR(20) | Online security add-on subscribed | Yes, No, No internet service |
| OnlineBackup | VARCHAR(20) | Online backup add-on subscribed | Yes, No, No internet service |
| DeviceProtection | VARCHAR(20) | Device protection add-on subscribed | Yes, No, No internet service |
| TechSupport | VARCHAR(20) | Tech support add-on subscribed | Yes, No, No internet service |
| StreamingTV | VARCHAR(20) | Streaming TV add-on subscribed | Yes, No, No internet service |
| StreamingMovies | VARCHAR(20) | Streaming movies add-on subscribed | Yes, No, No internet service |

## telco.accounts

| Column | Type | Description | Sample values |
|---|---|---|---|
| customerID | VARCHAR(10) | PK / FK to customers | 7590-VHVEG |
| tenure | INT | Number of months the customer has stayed | 0-72 |
| Contract | VARCHAR(20) | Contract term | Month-to-month, One year, Two year |
| PaperlessBilling | VARCHAR(3) | Whether billing is paperless | Yes, No |
| PaymentMethod | VARCHAR(30) | Payment method | Electronic check, Mailed check, Bank transfer (automatic), Credit card (automatic) |
| MonthlyCharges | DECIMAL(10,2) | Current monthly charge amount | 18.95-118.75 |
| TotalCharges | DECIMAL(10,2) | Total amount charged to date; NULL for 11 brand-new customers with tenure = 0 | 0-8684.80 |
| Churn | VARCHAR(3) | Whether the customer churned | Yes, No |

## Relationships

All 3 satellite tables (phone_services, internet_services, accounts) share a 1:1 relationship with customers via customerID. This is a denormalized-by-domain design rather than strict 3NF, chosen to keep joins learnable while still demonstrating relational thinking. See `schema_notes.md` for the reasoning and a deeper-normalization option.
