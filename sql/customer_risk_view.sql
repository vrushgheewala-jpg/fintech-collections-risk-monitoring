WITH invoice_risk AS (

SELECT
    i.customer_id,

    CASE
        WHEN p.payment_date IS NULL
            THEN DATE_DIFF(CURRENT_DATE(), i.due_date, DAY)
        ELSE DATE_DIFF(p.payment_date, i.due_date, DAY)
    END AS days_late,

    CASE
        WHEN p.payment_date IS NULL AND DATE_DIFF(CURRENT_DATE(), i.due_date, DAY) > 30
            THEN 1
        ELSE 0
    END AS high_risk_flag,

    CASE
        WHEN p.payment_date IS NULL
            THEN 1
        ELSE 0
    END AS unpaid_flag

FROM `my-first-project-485906.fintech_project.invoices` i
LEFT JOIN `my-first-project-485906.fintech_project.payments` p
ON i.invoice_id = p.invoice_id

)

SELECT
    customer_id,
    COUNT(*) AS total_invoices,
    SUM(unpaid_flag) AS unpaid_invoices,
    AVG(days_late) AS avg_days_late,
    SUM(high_risk_flag) AS high_risk_invoices,
    (SUM(unpaid_flag)*2 + SUM(high_risk_flag)*3 + AVG(days_late)/10) AS risk_score
FROM invoice_risk
GROUP BY customer_id