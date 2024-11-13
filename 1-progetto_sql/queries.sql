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
*/