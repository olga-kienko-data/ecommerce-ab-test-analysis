#  E-commerce A/B Test: Statistical & Segment Analysis

##  Project Overview
This project analyzes the results of an A/B test for an e-commerce platform using statistical methods and segment-level analysis.

The goal is to evaluate the impact of product changes on key conversion funnel steps and identify statistically significant improvements.

---

##  Project Structure

### Data Preparation (SQL)
- Aggregation of sessions (denominators)
- Aggregation of events (numerators)
- Segment-level breakdown (continent, device, channel, OS)

### Statistical Analysis (Python)
- Z-test for proportions
- p-value calculation
- Conversion rate and uplift calculation

---

##  Metrics
- add_payment_info / session
- add_shipping_info / session
- begin_checkout / session
- new_accounts / session

---

##  Files in Repository
- queries.sql — SQL data preparation
- ab_test_analysis.ipynb — statistical analysis
- AB_Test_Results_Final.xlsx — final dataset

---

##  Dashboard
 https://public.tableau.com/views/Book9_17721025986300/E-commerceABTestStatisticalSignificanceSegmentAnalysis

---

##  Key Insights
- Traffic split is balanced (~50/50)
- Significant improvements in mid-funnel steps
- No significant impact on purchase rate
- Results vary across segments

---

##  Conclusion
The experiment shows a partial positive impact, with strong dependency on user segments.

---

##  Recommendations
- Roll out in high-performing segments
- Investigate negative segments
- Continue monitoring purchase conversion

---

##  Tech Stack
- SQL (BigQuery)
- Python (pandas, statsmodels)
- Tableau
