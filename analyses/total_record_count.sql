SELECT 
    COUNT(*) AS total_records
FROM {{ ref('fct_monthly_zone_revenue') }}
