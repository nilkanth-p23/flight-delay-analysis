-- sql/schema.sql
-- Create lookup tables FIRST, then tables that reference them

CREATE TABLE airlines (
	airline_id		SERIAL PRIMARY KEY,
	iata_code		VARCHAR(3) UNIQUE NOT NULL, -- e.g. UA, DL, DA
	airline_name	VARCHAR(100) NOT NULL,
	country			VARCHAR(100)
);

CREATE TABLE airports (
    airport_id    SERIAL PRIMARY KEY,
    iata_code     VARCHAR(4) UNIQUE NOT NULL,   -- e.g. ORD, ATL, LAX
    airport_name  VARCHAR(150),
    city          VARCHAR(100),
    state         VARCHAR(50),
    latitude      NUMERIC(9,6),
    longitude     NUMERIC(9,6)
);
 
CREATE TABLE flights (
    flight_id             SERIAL PRIMARY KEY,
    flight_date           DATE NOT NULL,
    airline_id            INT REFERENCES airlines(airline_id),
    flight_number         VARCHAR(10),
    origin_airport_id     INT REFERENCES airports(airport_id),
    dest_airport_id       INT REFERENCES airports(airport_id),
    dep_delay_mins        NUMERIC(8,2),
    arr_delay_mins        NUMERIC(8,2),
    distance_miles        INT,
    air_time_mins         NUMERIC(8,2),
    on_time               BOOLEAN,
    cancelled             BOOLEAN,
    delay_severity        VARCHAR(50),
    primary_delay_cause   VARCHAR(50),
    distance_tier         VARCHAR(50),
    month                 INT,
    month_name            VARCHAR(20),
    day_of_week           VARCHAR(20),
    quarter               INT
);
 
CREATE TABLE delay_causes (
    cause_id           SERIAL PRIMARY KEY,
    flight_id          INT REFERENCES flights(flight_id),
    carrier_delay      NUMERIC(8,2),
    weather_delay      NUMERIC(8,2),
    nas_delay          NUMERIC(8,2),
    security_delay     NUMERIC(8,2),
    late_aircraft_delay NUMERIC(8,2)
);


