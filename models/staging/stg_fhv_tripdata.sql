select
    dispatching_base_num,
    pickup_datetime,
    dropoff_datetime,
    PUlocationID as pickup_location_id,
    DOlocationID as dropoff_location_id,
    SR_Flag as sr_flag
from {{ source('raw_data', 'fhv_tripdata_2019') }}
where dispatching_base_num is not null