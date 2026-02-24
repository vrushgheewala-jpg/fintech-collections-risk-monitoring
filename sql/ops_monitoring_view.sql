SELECT
    c.customer_id,
    c.company_name,
    r.total_invoices,
    r.unpaid_invoices,
    ROUND(r.avg_days_late,2) AS avg_days_late,
    r.high_risk_invoices,
    ROUND(r.risk_score,2) AS risk_score,

    CASE
        WHEN r.risk_score > 50 THEN "URGENT"
        WHEN r.risk_score > 25 THEN "FOLLOW UP"
        ELSE "STABLE"
    END AS action_priority

FROM `my-first-project-485906.fintech_project.customer_risk_view` r
JOIN `my-first-project-485906.fintech_project.customers` c
ON r.customer_id = c.customer_id