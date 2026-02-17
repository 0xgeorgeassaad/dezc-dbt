-- This query finds the zone with the highest total revenue for Green taxis in 2020
SELECT 
    t.zone,
    SUM(f.revenue_monthly_total_amount) AS total_revenue
FROM {{ ref('fct_monthly_zone_revenue') }} f
JOIN {{ ref('dim_zones') }} t
    ON f.pickup_location_id = t.location_id
WHERE 
    f.service_type = 'Green' 
    AND f.revenue_year = 2020
GROUP BY 1
ORDER BY total_revenue DESC