# Telecommunications Customer Churn: SQL Analysis

A SQL-only analysis of customer churn and revenue risk for a telecom provider, built on a normalized relational schema derived from the IBM Telco Customer Churn dataset.

## Business problem

The company wants to know: why are customers churning, how much revenue is at risk, and which currently active customers are most likely to leave next, so retention efforts can be prioritized before it happens rather than after.

## Tech stack

SQL Server (T-SQL). No BI tool, no Python, the entire analysis is pure SQL by design, to demonstrate depth in query writing: window functions, CTEs, rule-based scoring, and schema design.

## Schema

Normalized into 4 tables under the `telco` schema, joined on `customerID`:

| Table | Description |
|---|---|
| `customers` | Demographic dimension: gender, senior citizen flag, partner, dependents |
| `phone_services` | Phone plan details |
| `internet_services` | Internet plan and add-ons (security, backup, support, streaming) |
| `accounts` | Fact table: tenure, contract, billing, payment method, churn flag |

See `docs/data_catalog.md` for full column definitions and `docs/schema_notes.md` for design decisions.

## Project structure

```
sql-telecommunications-customer-churn-analysis/
├── README.md
├── LICENSE
├── .gitignore
├── data/
│   ├── customers.csv
│   ├── phone_services.csv
│   ├── internet_services.csv
│   ├── accounts.csv
│   └── source.md
├── scripts/
│   ├── 01_create_database_and_schema.sql
│   ├── 02_load_data.sql
│   └── 03_churn_revenue_analysis.sql
└── docs/
    ├── business_brief.md
    ├── data_catalog.md
    ├── schema_notes.md
    └── findings.md
```

## How to run

1. Create a local folder (e.g. `C:\telco_data\`) and place the 4 CSVs from `/data` in it.
2. Run `scripts/01_create_database_and_schema.sql` to create the database, schema, and tables.
3. Update the file paths in `scripts/02_load_data.sql` to match your folder, then run it. It loads all 4 tables and verifies row counts.
4. Run `sscripts/03_churn_revenue_analysis.sql` section by section. It's organized into 6 parts: churn overview, revenue analysis, segmentation, service/add-on impact, tenure cohorts, and a rule-based risk score for active customers.

## Key findings

See `docs/findings.md` for the write-up after running the analysis, this section gets filled in with the top 5-6 numbers once the queries are executed against the loaded data.

## Data source

IBM Telco Customer Churn dataset, originally published on Kaggle: https://www.kaggle.com/datasets/blastchar/telco-customer-churn. The flat file was normalized into 4 relational tables as part of this project; see `docs/schema_notes.md` for the transformation logic and a data quality fix applied to the `TotalCharges` column.

## Author

Ahmad Azhar Almansoor
[GitHub](https://github.com/ahmadazharinfo)
