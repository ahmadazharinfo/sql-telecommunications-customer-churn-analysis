# Telco Churn and Revenue Analysis - Business Brief

## Business context

A telecom provider wants to understand why customers churn, how much revenue is at risk, and which active customers are most likely to leave next so retention efforts can be prioritized.

## Scope

Analysis runs on the normalized `telco` schema (customers, phone_services, internet_services, accounts). All queries are in `03_churn_revenue_analysis.sql`, organized into 6 sections.

## Business questions answered

**Churn overview**
1. What is the overall churn rate?
2. Which contract type churns the most?
3. Which payment method correlates with the highest churn?
4. Does internet service type (DSL vs Fiber vs None) affect churn?
5. Do demographics (senior citizen, partner, dependents) affect churn?

**Revenue analysis**
6. What is total monthly recurring revenue, and how much is lost to churn?
7. What is the average revenue per user, churned vs retained?
8. Which contract type generates the most revenue, and how much of it is at risk?
9. Who are the highest-value customers that already churned?

**Segmentation**
10. How does churn vary across tenure segments (new, established, loyal)?
11. Does the number of services a customer subscribes to affect churn?
12. How do contract type and internet service type interact to affect churn?

**Service and add-on impact**
13. Does Tech Support reduce churn?
14. Does Online Security reduce churn?
15. Do streaming add-ons increase or decrease churn?
16. Does having multiple phone lines affect churn?

**Cohort analysis**
17. At which exact tenure month does churn spike (early lifecycle drop-off)?
18. What does the cumulative retained customer curve look like over tenure?

**Risk scoring**
19. Among currently active customers, who is at highest risk of churning next, ranked by a rule-based score?
20. How much monthly revenue sits in the highest-risk quartile of active customers?

## Method note on the risk score (Section 6)

This is a simple, transparent rule-based score, not a machine learning model. It adds points for known churn-correlated factors (month-to-month contract, electronic check payment, no tech support, no online security, short tenure, paperless billing) and ranks active customers into quartiles using `NTILE(4)`. Quartile 1 is the highest-risk 25%. This kind of scoring is exactly what a BI Analyst is expected to produce before a data science team builds a formal model, and it's often good enough to act on immediately.

## Suggested write-up structure for your portfolio README

1. Business problem (one paragraph)
2. Schema diagram (ERD)
3. Key findings, pull the 4-5 most interesting numbers from your query results
4. The risk score methodology and its business use
5. Recommendations (e.g., "month-to-month customers under 12 months tenure without tech support are the top retention target")
