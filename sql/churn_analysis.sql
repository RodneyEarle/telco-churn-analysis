/* =====================================================
   TELCO CUSTOMER CHURN ANALYSIS
   Author: Rodney Earle
   Tools: PostgreSQL
   Dataset: Telco Customers
===================================================== */


/* ---------------------------------------------
   1. Overall Customer Churn Percentage
--------------------------------------------- */

SELECT
    churn,
    COUNT(*) AS customers,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER(),
        2
    ) AS churn_percentage
FROM telco_customers
GROUP BY churn;


/* ---------------------------------------------
   2. Churn Rate by Contract Type
--------------------------------------------- */

SELECT
    contract,
    COUNT(*) AS customers,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(
        100.0 * SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS churn_rate
FROM telco_customers
GROUP BY contract
ORDER BY churn_rate DESC;


/* ---------------------------------------------
   3. Churn Rate by Tenure Group
--------------------------------------------- */

SELECT
    CASE
        WHEN tenure::INT <= 12 THEN '0-12 months'
        WHEN tenure::INT <= 24 THEN '13-24 months'
        WHEN tenure::INT <= 48 THEN '25-48 months'
        ELSE '48+ months'
    END AS tenure_group,

    COUNT(*) AS customers,

    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned,

    ROUND(
        100.0 * SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS churn_rate

FROM telco_customers
GROUP BY tenure_group
ORDER BY tenure_group;


/* ---------------------------------------------
   4. Average Monthly Charges by Churn Status
--------------------------------------------- */

SELECT
    churn,
    COUNT(*) AS customers,
    ROUND(
        AVG(monthlycharges::numeric),
        2
    ) AS avg_monthly_charge
FROM telco_customers
GROUP BY churn
ORDER BY avg_monthly_charge DESC;


/* ---------------------------------------------
   5. Churn Rate by Internet Service
--------------------------------------------- */

SELECT
    internetservice,
    COUNT(*) AS customers,

    SUM(
        CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END
    ) AS churned,

    ROUND(
        100.0 *
        SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS churn_rate

FROM telco_customers
GROUP BY internetservice
ORDER BY churn_rate DESC;
