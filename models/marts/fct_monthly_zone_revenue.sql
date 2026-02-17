with trips_data as (
    select *, 'Green' as service_type 
    from {{ ref('stg_green_tripdata') }}
    union all 
    select *, 'Yellow' as service_type 
    from {{ ref('stg_yellow_tripdata') }}
)
select 
    -- Grouping fields
    pickup_location_id,
    service_type,
    EXTRACT(MONTH FROM pickup_datetime) as revenue_month,
    EXTRACT(YEAR FROM pickup_datetime) as revenue_year,

    -- Aggregated Metrics
    count(*) as total_monthly_trips,
    sum(fare_amount) as revenue_monthly_fare,
    sum(extra) as revenue_monthly_extra,
    sum(mta_tax) as revenue_monthly_mta_tax,
    sum(tip_amount) as revenue_monthly_tip_amount,
    sum(tolls_amount) as revenue_monthly_tolls_amount,
    sum(ehail_fee) as revenue_monthly_ehail_fee,
    sum(improvement_surcharge) as revenue_monthly_improvement_surcharge,
    sum(total_amount) as revenue_monthly_total_amount,

    -- Averages
    avg(passenger_count) as avg_monthly_passenger_count,
    avg(trip_distance) as avg_monthly_trip_distance

from trips_data
group by 1, 2, 3, 4