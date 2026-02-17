WITH green_trips AS (
    SELECT *  -- already casted in stg_green_tripdata
    FROM {{ ref('stg_green_tripdata') }}
),

yellow_trips AS (
    SELECT *  -- already casted in stg_yellow_tripdata
    FROM {{ ref('stg_yellow_tripdata') }}
),

all_trips AS (
    SELECT * FROM green_trips
    UNION ALL
    SELECT * FROM yellow_trips
),

deduped_trips AS (
    SELECT
        GENERATE_UUID() AS trip_id,
        *,
        {{ get_payment_type_desc('payment_type') }} AS payment_type_desc,
        ROW_NUMBER() OVER(
            PARTITION BY pickup_datetime, dropoff_datetime, pickup_location_id, dropoff_location_id, vendor_id
            ORDER BY total_amount DESC
        ) AS rn
    FROM all_trips
)

SELECT *
FROM deduped_trips
WHERE rn = 1
