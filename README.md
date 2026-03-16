# NYC Taxi Data Transformation Pipeline 🚖

An end-to-end Analytics Engineering project using **dbt (data build tool)** and **Google BigQuery** to transform raw New York City Taxi data into a structured, production-ready data warehouse.

This repository demonstrates modern data modeling best practices, including modular SQL architecture, DRY code principles using Jinja macros, data deduplication, and dimensional modeling (Kimball methodology).

## 🛠️ Tech Stack
* **Data Transformation & Modeling:** dbt (Core)
* **Data Warehouse:** Google BigQuery
* **Language:** SQL (Standard BigQuery Dialect), Jinja
* **Source Data:** NYC Taxi & Limousine Commission (TLC) Trip Record Data (Yellow, Green, and FHV)

## 🏗️ Project Architecture & Data Lineage

The pipeline is structured using dbt's recommended multi-layer architecture to ensure modularity, scalability, and reusability:

### 1. Staging Layer (`models/staging/`)
Serves as the entry point from raw BigQuery sources. 
* Performs essential data type casting (e.g., `STRING` to `TIMESTAMP`, `NUMERIC`).
* Standardizes column names and filters out corrupted/invalid records (e.g., `VendorID IS NOT NULL`).
* Models: `stg_yellow_tripdata`, `stg_green_tripdata`, `stg_fhv_tripdata`.

### 2. Intermediate Layer (`models/intermediate/`)
Handles the complex joining and unioning of data before it hits the business logic layer.
* Unifies schema definitions between Green and Yellow taxi datasets into a single cohesive stream.
* Models: `int_trips_unioned`.

### 3. Marts Layer (`models/marts/`)
Contains the final, analytics-ready dimensional models exposing business metrics to BI tools.
* **Dimensions:** 
  * `dim_vendors`: Unique vendor descriptions.
  * `dim_zones`: Geospatial lookup data enriched via dbt seeds (`taxi_zone_lookup.csv`).
* **Facts:** 
  * `fct_trips`: Granular trip-level data. Handles duplicate resolution using window functions (`ROW_NUMBER()` partitioned by pickup/dropoff metrics) and generates unique `trip_id`s.
  * `fct_monthly_zone_revenue`: Heavily aggregated table calculating monthly revenue, tax rollups, average passenger counts, and distances by service type and zone.

## 🔑 Key Engineering Highlights

* **DRY Code via Macros:** Implemented custom Jinja macros (`get_payment_type_desc.sql`, `get_vendor_names.sql`) to translate raw integer IDs into human-readable categories across multiple models without duplicating `CASE WHEN` logic.
* **Data Deduplication:** Ensured data integrity by writing partitioned window functions in `fct_trips` to systematically identify and remove overlapping trip records.
* **Seed Integration:** Managed static reference data (taxi zones) using dbt seeds, treating CSVs as version-controlled data sources natively queryable via `ref()`.
* **Ad-Hoc Analysis:** Includes an `analyses/` directory containing queries to validate business questions (e.g., calculating the top revenue-generating zones or verifying total row counts post-transformation).

## 📂 Repository Structure

```text
├── analyses/                # Ad-hoc SQL queries answering specific business questions
├── macros/                  # Reusable Jinja functions for business logic
├── models/
│   ├── intermediate/        # Unification of staging models
│   ├── marts/               # Final Fact and Dimension tables for BI
│   └── staging/             # Base views mapped directly to raw source tables
├── seeds/                   # Static CSV lookup tables
├── dbt_project.yml          # Core dbt configuration and materialization settings
└── README.md
```