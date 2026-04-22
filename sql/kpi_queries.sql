-- Query 1 — Overall On-Time Rate by Airline
SELECT
    airline_name,
    COUNT(*) AS total_flights,
    SUM(CASE WHEN on_time = TRUE THEN 1 ELSE 0 END) AS on_time_flights,
    ROUND(CAST(AVG(CASE WHEN on_time = TRUE THEN 1.0 ELSE 0 END) * 100 AS numeric), 2) AS on_time_rate_pct,
    ROUND(CAST(AVG("ARR_DELAY") AS numeric), 2) AS avg_arr_delay_mins,
    ROUND(CAST(AVG("DEP_DELAY") AS numeric), 2) AS avg_dep_delay_mins
FROM flights
WHERE "CANCELLED" = 0.0
GROUP BY airline_name
ORDER BY on_time_rate_pct DESC;

-- Query 2 — Top 10 Worst Airports for Delays
SELECT
    "ORIGIN",
    COUNT(*) AS total_departures,
    ROUND(CAST(AVG("DEP_DELAY") AS numeric), 2) AS avg_dep_delay,
    ROUND(CAST(AVG(CASE WHEN on_time = TRUE THEN 1.0 ELSE 0 END)*100 AS numeric), 2) AS on_time_pct
FROM flights
WHERE "CANCELLED" = 0.0
GROUP BY "ORIGIN"
HAVING COUNT(*) > 10000
ORDER BY avg_dep_delay DESC
LIMIT 10;

-- Query 3 — Delay Causes Breakdown
SELECT
    primary_delay_cause,
    COUNT(*) AS delayed_flights,
    ROUND(CAST(AVG("ARR_DELAY") AS numeric), 1) AS avg_delay_mins,
    ROUND(CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS numeric), 2) AS pct_of_delays
FROM flights
WHERE on_time = FALSE AND "CANCELLED" = 0.0
    AND primary_delay_cause != 'No Delay'
GROUP BY primary_delay_cause
ORDER BY delayed_flights DESC;

-- Query 4 — Monthly On-Time Rate Trend
SELECT
    month,
    month_name,
    COUNT(*) AS total_flights,
    ROUND(CAST(AVG(CASE WHEN on_time = TRUE THEN 1.0 ELSE 0 END) * 100 AS numeric), 2) AS on_time_rate,
    ROUND(CAST(AVG("ARR_DELAY") AS numeric), 2) AS avg_arr_delay
FROM flights
WHERE "CANCELLED" = 0.0
GROUP BY month, month_name
ORDER BY month;

-- Query 5 — Airline Ranking by Route Distance Tier
SELECT
    airline_name,
    distance_tier,
    COUNT(*) AS flights,
    ROUND(CAST(AVG(CASE WHEN on_time = TRUE THEN 1.0 ELSE 0 END) * 100 AS numeric), 2) AS on_time_rate,
    RANK() OVER (
        PARTITION BY distance_tier
        ORDER BY AVG(CASE WHEN on_time = TRUE THEN 1.0 ELSE 0 END) DESC
    ) AS rank_in_tier
FROM flights
WHERE "CANCELLED" = 0.0
GROUP BY airline_name, distance_tier
ORDER BY distance_tier, rank_in_tier;

-- Query 6 — Day of Week Performance
SELECT
    day_of_week,
    COUNT(*) AS total_flights,
    ROUND(CAST(AVG(CASE WHEN on_time = TRUE THEN 1.0 ELSE 0 END) * 100 AS numeric), 2) AS on_time_rate,
    ROUND(CAST(AVG("ARR_DELAY") AS numeric), 2) AS avg_arr_delay,
    SUM(CASE WHEN "CANCELLED" = 1.0 THEN 1 ELSE 0 END) AS cancellations
FROM flights
GROUP BY day_of_week
ORDER BY on_time_rate ASC;

-- Query 7 — Rolling 3 Month On-Time Trend per Airline
WITH monthly_perf AS (
    SELECT
        airline_name,
        month,
        month_name,
        COUNT(*) AS flights,
        ROUND(CAST(AVG(CASE WHEN on_time = TRUE THEN 1.0 ELSE 0 END) * 100 AS numeric), 2) AS on_time_rate
    FROM flights
    WHERE "CANCELLED" = 0.0
    GROUP BY airline_name, month, month_name
)
SELECT
    airline_name,
    month,
    month_name,
    on_time_rate,
    ROUND(CAST(AVG(on_time_rate) OVER (
        PARTITION BY airline_name
        ORDER BY month
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS numeric), 2) AS rolling_3mo_avg
FROM monthly_perf
ORDER BY airline_name, month;

-- Query 8 — Busiest Delay Prone Routes
SELECT
    "ORIGIN" || ' → ' || "DEST" AS route,
    COUNT(*) AS total_flights,
    ROUND(CAST(AVG("ARR_DELAY") AS numeric), 1) AS avg_arr_delay,
    ROUND(CAST(AVG(CASE WHEN on_time = TRUE THEN 1.0 ELSE 0 END)*100 AS numeric), 2) AS on_time_rate
FROM flights
WHERE "CANCELLED" = 0.0
GROUP BY "ORIGIN", "DEST"
HAVING COUNT(*) > 500
ORDER BY avg_arr_delay DESC
LIMIT 20;