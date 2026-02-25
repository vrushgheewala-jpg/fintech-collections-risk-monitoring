SELECT
    i.invoice_id,
    i.customer_id,
    i.amount,
    i.issue_date,
    i.due_date,
    p.payment_date,

    -- payment delay
    CASE
        WHEN p.payment_date IS NULL
            THEN DATE_DIFF(CURRENT_DATE(), i.due_date, DAY)
        ELSE DATE_DIFF(DATE(p.payment_date), i.due_date, DAY)
    END AS days_late,

    -- payment category
    CASE
        WHEN p.payment_date IS NULL
             AND DATE_DIFF(CURRENT_DATE(), i.due_date, DAY) > 30
            THEN "HIGH RISK - UNPAID"

        WHEN p.payment_date IS NULL
            THEN "UNPAID"

        WHEN DATE_DIFF(DATE(p.payment_date), i.due_date, DAY) > 30
            THEN "PAID VERY LATE"

        WHEN DATE_DIFF(DATE(p.payment_date), i.due_date, DAY) > 0
            THEN "PAID LATE"

        ELSE "ON TIME / EARLY"
    END AS payment_category

FROM `my-first-project-485906.fintech_project.invoices` i
LEFT JOIN `my-first-project-485906.fintech_project.payments` p
ON i.invoice_id = p.invoice_id
