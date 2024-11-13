/*
-- Costruzione del database
CREATE DATABASE progetto_sqldb;


-- Costruzione delle tabelle 

--- Tabella global_var
CREATE TABLE global_var(
country_name varchar(255) not null unique PRIMARY KEY,
density int,
abbreviation varchar(5),
agricultural_land_p varchar(255),
land_area float,
armed_forces_size float,
birth_rate float,
calling_code int,
capital varchar(255),
co2 int,
cpi float,
cpi_change_p varchar(255),
currency varchar(255),
fertility_rate float,
forested_area_p varchar(255),
gasoline_price varchar(7),
gdp varchar(20),
gross_primary_education_enrollment_p varchar(255),
gross_tertiary_education_enrollment_p varchar(255),
infant_mortality float,
largest_city varchar(255),
life_expectancy float,
maternal_mortality int,
minimum_wage varchar(255),
official_language varchar(255),
out_of_pocket_health_expenditure_p varchar(255),
physicians float,
population bigint,
labor_force_participation_p varchar(255),
tax_revenue_p varchar(255),
total_tax_rate_p varchar(255),
unemployment_rate_p varchar(255),
urban_population int,
latitude varchar(255),
longitude varchar(255)
);

--- Tabella university
CREATE TABLE university(
uni_rank varchar(30),
uni_name varchar(255) PRIMARY KEY,
uni_country varchar(30),
n_students int,
students_per_staff float,
international_student_p varchar(10),
female_male varchar(30)
);


--- Tabella peace
CREATE TABLE peace(
peace_country varchar(255),
peace_country_abbr varchar(3),
peace_year int,
peace_overall_score float,
safety_security float,
ongoing_conflict float,
militarian float
);

--- Tabella happyness
CREATE TABLE happiness(
hap_country varchar(30) PRIMARY KEY,
hap_ladder_score float,
st_error_ladder float,
upperwhisker float,
lowerwhisker float,
logged_gdp_per_capita float,
social_support float,
health_life_expectancy float,
freedom_to_make_life_choise float,
generosity float,
perception_of_corruption float,
ladder_score_dystopia float,
explained_logged_gdp_per_capita float,
explained_social_support float,
explained_health_life_expectancy float,
explained_freedom_to_make_life_choise float,
explained_generosity float,
explained_perception_of_corruption float,
dystopia_plus_residual float
);
*/

SELECT * FROM global_var;