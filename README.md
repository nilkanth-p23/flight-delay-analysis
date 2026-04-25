# Flight Delay & Airline Performance Analysis
 
## Business Question
Which U.S. airlines, routes, and airports have the worst delay performance
in 2023, and what operational factors — carrier issues, weather, NAS,
or late aircraft — are driving the most disruption?
 
## Live Dashboard
[View Interactive Dashboard on Tableau Public](https://public.tableau.com/app/profile/nilkanth.patel4075/viz/FlightDelayAnalysis2025/1-ExecutiveOverview)
 
## Data Sources
| Source | Description | Scale |
|--------|-------------|-------|
| Bureau of Transportation Statistics (BTS) | Official U.S. airline on-time reporting data | 7M+ flights |
| AviationStack API | Real-time flight status, airline & airport reference data | Live |
| OpenSky Network API | Open-source aircraft tracking from ADS-B receivers | Live |
 
**Airlines covered:** United Airlines, Delta Air Lines, American Airlines,
Southwest Airlines, Alaska Airlines, JetBlue Airways
 
## Tech Stack
| Tool | Purpose |
|------|---------|
| Python + Pandas | Data ingestion, cleaning, and feature engineering |
| OpenSky Network API | Real-time aircraft tracking and arrival data |
| PostgreSQL | Relational database — airlines, airports, flights, delay_causes tables |
| SQL | 8 KPI queries including window functions, CTEs, and multi-table JOINs |
| Matplotlib + Seaborn | Static exploratory visualizations (7 charts) |
| Plotly | Interactive delay cause chart |
| Tableau | 3-page operational dashboard published to Tableau Public |
 
## Key Findings
1. Overall 2025 on-time rate: XX% — down from XX% in 2022
2. [Airline X] ranked last with only XX% on-time arrivals
3. Late Aircraft cascading delays accounted for XX% of all delay minutes
4. July and December had the worst on-time performance — summer travel + holiday peaks
5. Flights departing Chicago O'Hare averaged XX minutes late — the worst major hub
6. Long-haul routes (1000+ miles) had a XX% lower on-time rate than short-haul
 
## Project Structure
notebooks/   - Jupyter notebooks for each project phase (01-04)
sql/         - Schema definitions and 8 KPI analysis queries
data/        - Raw, cleaned, and exported datasets
visuals/     - Exported charts (PNG + interactive HTML)
 
## How to Run
1. Clone this repository
2. pip3 install -r requirements.txt
3. Download BTS 2025 data: transtats.bts.gov/DL_SelectFields.aspx
4. Save to data/raw/bts_flights_2025.csv
5. Add your AviationStack API key to a .env file
6. Run notebooks in order: 01 → 02 → 03 → 04
7. Run sql/schema.sql in PostgreSQL, then sql/kpi_queries.sql

