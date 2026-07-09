# Key Findings

## Churn overview
- Overall churn rate: **26.5%** (1,869 of 7,043 customers churned)
- Highest-churn contract type: **Month-to-month at 42.7%**, versus 11.3% for one-year and just 2.8% for two-year contracts. Contract length is the single strongest churn predictor in this dataset.
- Highest-churn payment method: **Electronic check at 45.3%**, nearly 3x higher than credit card or bank transfer (automatic) customers, both around 15-17%.

## Revenue impact
- Total monthly recurring revenue: **$456,116.60**
- Monthly revenue lost to churn: **$139,130.85** (about 30% of total MRR)
- Projected annual revenue loss: **$1,669,570.20**
- Interesting twist: churned customers actually had a higher average monthly charge ($74.44 vs $61.27 for retained customers), but a much lower average total charge ($1,531.80 vs $2,555.34). This means the company is losing customers who pay more per month but leave before their lifetime value builds up, tenure is cut short before the higher monthly rate pays off.

## Segmentation
- Tenure segment with highest churn: **0-12 months (New) at 47.4%**, dropping steadily to 9.5% for customers at 49-72 months. Nearly half of new customers churn within their first year.
- Effect of service count on churn: **Non-linear**. Customers with 0 services churn at 43.8%, but churn actually rises again at 2 services (43.5%) before declining steadily as service count increases, reaching just 5.8% at 7 services. The safest customers are the ones most deeply embedded across the product line, not the ones just starting out with a couple of add-ons.

## Service impact
- Tech Support reduces churn significantly: **15.2% with Tech Support vs 41.6% without**, a 26.4 point gap.
- Online Security has a similar effect: **14.6% with vs 41.8% without**, a 27.2 point gap. These are the two strongest churn-reducing add-ons in the dataset, both roughly cutting churn to a third of the no-add-on rate.

## Risk scoring
- Active customers in the highest-risk quartile (Quartile 1): **1,294 customers**
- Monthly revenue concentrated in that quartile: **$85,218.65**, meaning if even a fraction of this group leaves, the company loses a similar amount to what it already loses monthly to churn today.

## Recommendation
The clearest, highest-leverage retention target is new customers (under 12 months tenure) on month-to-month contracts paying by electronic check, especially those without Tech Support or Online Security. This segment combines the four strongest churn signals found in the data. A retention offer bundling a discounted Tech Support or Online Security add-on for the first year, paired with an incentive to switch off electronic check payment, would directly address the two behavioral levers (contract length and payment method) alongside the two product levers (support and security add-ons) shown to have the largest impact on churn.
