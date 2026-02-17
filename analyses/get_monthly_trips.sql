SELECT
    service_type,
    revenue_year,
    revenue_month,
    sum(total_monthly_trips) as monthly_trips
FROM {{ ref('fct_monthly_zone_revenue') }}
WHERE
    service_type = 'Green'
    AND revenue_year = 2019
    AND revenue_month = 10
GROUP BY 1, 2, 3