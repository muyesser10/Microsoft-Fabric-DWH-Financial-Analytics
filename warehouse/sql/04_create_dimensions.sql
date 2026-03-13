--- dimension country
CREATE TABLE dimensions.dim_country (

    country_id BIGINT IDENTITY,
    country_name VARCHAR(100)

);


INSERT INTO dimensions.dim_country (country_name)

SELECT DISTINCT country
FROM staging.exim_authorizations_staging
WHERE country IS NOT NULL;

----- dimension program
CREATE TABLE dimensions.dim_program (

    program_id BIGINT IDENTITY,
    program_name VARCHAR(100)

);

INSERT INTO dimensions.dim_program (program_name)

SELECT DISTINCT program
FROM staging.exim_authorizations_staging
WHERE program IS NOT NULL;

----- dimension exporter
CREATE TABLE dimensions.dim_exporter (

    exporter_id BIGINT IDENTITY,
    exporter_name VARCHAR(200),
    exporter_city VARCHAR(100),
    exporter_state VARCHAR(100)

);


INSERT INTO dimensions.dim_exporter (
    exporter_name,
    exporter_city,
    exporter_state
)

SELECT DISTINCT
    primary_exporter,
    primary_exporter_city,
    primary_exporter_state_name

FROM staging.exim_authorizations_staging;