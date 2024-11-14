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


--- Tabella prodotti alimentari
CREATE TABLE food(
food_domain varchar(255),
area varchar(255),
food_element varchar(255),
item varchar(255),
years int,
food_value float
);


CREATE TABLE continents(
continent varchar(40),
country varchar(40) unique PRIMARY KEY 
);


CREATE TABLE food_co2(
prodotto varchar(20) PRIMARY KEY unique,
code varchar(20),
years int,
kgco2_per_kgprodotto float
);
*/


--- Visualizziamo i 5 paesi con maggior produzione di co2
SELECT country_name, population, density, co2_tons
FROM global_var
WHERE co2_tons IS NOT NULL
ORDER BY co2_tons DESC
LIMIT 5;	-- China
			-- USA
			-- India
			-- Russia
			-- Japan


--- Visualizza i 5 paesi con la popolazione più alta
SELECT country_name, population, density, co2
FROM global_var
WHERE population IS NOT NULL
ORDER BY population DESC
LIMIT 10;


--- Visualizziamo i 5 alimenti che inquinano di più
SELECT prodotto, kgco2_per_kgprodotto AS co2
FROM food_co2
ORDER BY co2 DESC
LIMIT 5;
					-- Beef
				    -- Dark chocolate
					-- Lamb & Mutton
					-- Beef dairy
					-- Coffee


--- CHINA
WITH china_food_co2
AS(
	--%co2 da beef
	SELECT area, 'Beef (beef herd)' AS item, SUM(food_value) AS tons
	FROM food
	WHERE 
	    area LIKE 'China' 
	    AND item ~* 'buffalo'  --rende case-insensitive la ricerca
	    AND item !~* 'milk'
		AND years = 2022
	GROUP BY area

	UNION ALL
	
	--%co2 da chocolate
	SELECT area, 'Dark Chocolate' AS item, SUM(food_value) AS tons
	FROM food
	WHERE 
	    area LIKE 'China' 
	    AND item ~* 'cocoa'  --rende case-insensitive la ricerca
		AND years = 2022
	GROUP BY area

	UNION ALL
	
	--%co2 da lamb
	SELECT area, 'Lamb & Mutton' AS item, SUM(food_value) AS tons
	FROM food
	WHERE 
	    area LIKE 'China' 
	    AND item ~* 'lamb'  --rende case-insensitive la ricerca
		AND years = 2022
	GROUP BY area

	UNION ALL
	
	--%co2 da beef milk
	SELECT area, 'Beef (dairy herd)' AS item, SUM(food_value) AS tons
	FROM food
	WHERE 
	    area LIKE 'China' 
	    AND item ~* 'buffalo'  --rende case-insensitive la ricerca
	    AND item ~* 'milk'
		AND years = 2022
	GROUP BY area

	UNION ALL
	
	--%co2 da coffee
	SELECT area, 'Coffee' AS item, SUM(food_value) AS tons
	FROM food
	WHERE 
	    area LIKE 'China' 
	    AND item ~* 'coffee'  --rende case-insensitive la ricerca
		AND years = 2022
	GROUP BY area
)
SELECT cfc.area, cfc.item, tons, co2_per_kg, (tons * 1000 * co2_per_kg) / 1000 AS co2_tot_tons
FROM china_food_co2 AS cfc
INNER JOIN(
	SELECT prodotto, kgco2_per_kgprodotto AS co2_per_kg
	FROM food_co2
	ORDER BY co2_per_kg DESC
	LIMIT 5
) fc
ON cfc.item = fc.prodotto;


--- USA
WITH usa_food_co2
AS(
	--%co2 da beef
	SELECT area, 'Beef (beef herd)' AS item, SUM(food_value) AS tons
	FROM food
	WHERE 
	    area LIKE 'United States of America' 
	    AND item ~* 'buffalo'  --rende case-insensitive la ricerca
	    AND item !~* 'milk'
		AND years = 2022
	GROUP BY area

	UNION ALL
	
	--%co2 da chocolate
	SELECT area, 'Dark Chocolate' AS item, SUM(food_value) AS tons
	FROM food
	WHERE 
	    area LIKE 'United States of America' 
	    AND item ~* 'cocoa'  --rende case-insensitive la ricerca
		AND years = 2022
	GROUP BY area

	UNION ALL
	
	--%co2 da lamb
	SELECT area, 'Lamb & Mutton' AS item, SUM(food_value) AS tons
	FROM food
	WHERE 
	    area LIKE 'United States of America' 
	    AND item ~* 'lamb'  --rende case-insensitive la ricerca
		AND years = 2022
	GROUP BY area

	UNION ALL
	
	--%co2 da beef milk
	SELECT area, 'Beef (dairy herd)' AS item, SUM(food_value) AS tons
	FROM food
	WHERE 
	    area LIKE 'United States of America' 
	    AND item ~* 'buffalo'  --rende case-insensitive la ricerca
	    AND item ~* 'milk'
		AND years = 2022
	GROUP BY area

	UNION ALL
	
	--%co2 da coffee
	SELECT area, 'Coffee' AS item, SUM(food_value) AS tons
	FROM food
	WHERE 
	    area LIKE 'United States of America' 
	    AND item ~* 'coffee'  --rende case-insensitive la ricerca
		AND years = 2022
	GROUP BY area
)
SELECT ufc.area, ufc.item, ufc.tons, fc.co2_per_kg, (ufc.tons * 1000 * fc.co2_per_kg) / 1000 AS co2_tot_tons
FROM usa_food_co2 AS ufc
INNER JOIN(
	SELECT prodotto, kgco2_per_kgprodotto AS co2_per_kg
	FROM food_co2
	ORDER BY co2_per_kg DESC
	LIMIT 5
) fc
ON ufc.item = fc.prodotto;


--- INDIA
WITH india_food_co2
AS(
	--%co2 da beef
	SELECT area, 'Beef (beef herd)' AS item, SUM(food_value) AS tons
	FROM food
	WHERE 
	    area LIKE 'India' 
	    AND item ~* 'buffalo'  --rende case-insensitive la ricerca
	    AND item !~* 'milk'
		AND years = 2022
	GROUP BY area

	UNION ALL
	
	--%co2 da chocolate
	SELECT area, 'Dark Chocolate' AS item, SUM(food_value) AS tons
	FROM food
	WHERE 
	    area LIKE 'India' 
	    AND item ~* 'cocoa'  --rende case-insensitive la ricerca
		AND years = 2022
	GROUP BY area

	UNION ALL
	
	--%co2 da lamb
	SELECT area, 'Lamb & Mutton' AS item, SUM(food_value) AS tons
	FROM food
	WHERE 
	    area LIKE 'India' 
	    AND item ~* 'lamb'  --rende case-insensitive la ricerca
		AND years = 2022
	GROUP BY area

	UNION ALL
	
	--%co2 da beef milk
	SELECT area, 'Beef (dairy herd)' AS item, SUM(food_value) AS tons
	FROM food
	WHERE 
	    area LIKE 'India' 
	    AND item ~* 'buffalo'  --rende case-insensitive la ricerca
	    AND item ~* 'milk'
		AND years = 2022
	GROUP BY area

	UNION ALL
	
	--%co2 da coffee
	SELECT area, 'Coffee' AS item, SUM(food_value) AS tons
	FROM food
	WHERE 
	    area LIKE 'India' 
	    AND item ~* 'coffee'  --rende case-insensitive la ricerca
		AND years = 2022
	GROUP BY area
)
SELECT ifc.area, ifc.item, ifc.tons, fc.co2_per_kg, (ifc.tons * 1000 * fc.co2_per_kg) / 1000 AS co2_tot_tons
FROM india_food_co2 AS ifc
INNER JOIN(
	SELECT prodotto, kgco2_per_kgprodotto AS co2_per_kg
	FROM food_co2
	ORDER BY co2_per_kg DESC
	LIMIT 5
) fc
ON ifc.item = fc.prodotto;


--- RUSSIA
WITH russia_food_co2
AS(
	--%co2 da beef
	SELECT area, 'Beef (beef herd)' AS item, SUM(food_value) AS tons
	FROM food
	WHERE 
	    area LIKE 'Russian Federation' 
	    AND item ~* 'buffalo'  --rende case-insensitive la ricerca
	    AND item !~* 'milk'
		AND years = 2022
	GROUP BY area

	UNION ALL
	
	--%co2 da chocolate
	SELECT area, 'Dark Chocolate' AS item, SUM(food_value) AS tons
	FROM food
	WHERE 
	    area LIKE 'Russian Federation' 
	    AND item ~* 'cocoa'  --rende case-insensitive la ricerca
		AND years = 2022
	GROUP BY area

	UNION ALL
	
	--%co2 da lamb
	SELECT area, 'Lamb & Mutton' AS item, SUM(food_value) AS tons
	FROM food
	WHERE 
	    area LIKE 'Russian Federation' 
	    AND item ~* 'lamb'  --rende case-insensitive la ricerca
		AND years = 2022
	GROUP BY area

	UNION ALL
	
	--%co2 da beef milk
	SELECT area, 'Beef (dairy herd)' AS item, SUM(food_value) AS tons
	FROM food
	WHERE 
	    area LIKE 'Russian Federation' 
	    AND item ~* 'buffalo'  --rende case-insensitive la ricerca
	    AND item ~* 'milk'
		AND years = 2022
	GROUP BY area

	UNION ALL
	
	--%co2 da coffee
	SELECT area, 'Coffee' AS item, SUM(food_value) AS tons
	FROM food
	WHERE 
	    area LIKE 'Russian Federation' 
	    AND item ~* 'coffee'  --rende case-insensitive la ricerca
		AND years = 2022
	GROUP BY area
)
SELECT rfc.area, rfc.item, rfc.tons, fc.co2_per_kg, (rfc.tons * 1000 * fc.co2_per_kg) / 1000 AS co2_tot_tons
FROM russia_food_co2 AS rfc
INNER JOIN(
	SELECT prodotto, kgco2_per_kgprodotto AS co2_per_kg
	FROM food_co2
	ORDER BY co2_per_kg DESC
	LIMIT 5
) fc
ON rfc.item = fc.prodotto;


--- JAPAN
WITH japan_food_co2
AS(
	--%co2 da beef
	SELECT area, 'Beef (beef herd)' AS item, SUM(food_value) AS tons
	FROM food
	WHERE 
	    area LIKE 'Japan' 
	    AND item ~* 'buffalo'  --rende case-insensitive la ricerca
	    AND item !~* 'milk'
		AND years = 2022
	GROUP BY area

	UNION ALL
	
	--%co2 da chocolate
	SELECT area, 'Dark Chocolate' AS item, SUM(food_value) AS tons
	FROM food
	WHERE 
	    area LIKE 'Japan' 
	    AND item ~* 'cocoa'  --rende case-insensitive la ricerca
		AND years = 2022
	GROUP BY area

	UNION ALL
	
	--%co2 da lamb
	SELECT area, 'Lamb & Mutton' AS item, SUM(food_value) AS tons
	FROM food
	WHERE 
	    area LIKE 'Japan' 
	    AND item ~* 'lamb'  --rende case-insensitive la ricerca
		AND years = 2022
	GROUP BY area

	UNION ALL
	
	--%co2 da beef milk
	SELECT area, 'Beef (dairy herd)' AS item, SUM(food_value) AS tons
	FROM food
	WHERE 
	    area LIKE 'Japan' 
	    AND item ~* 'buffalo'  --rende case-insensitive la ricerca
	    AND item ~* 'milk'
		AND years = 2022
	GROUP BY area

	UNION ALL
	
	--%co2 da coffee
	SELECT area, 'Coffee' AS item, SUM(food_value) AS tons
	FROM food
	WHERE 
	    area LIKE 'Japan' 
	    AND item ~* 'coffee'  --rende case-insensitive la ricerca
		AND years = 2022
	GROUP BY area
)
SELECT jfc.area, jfc.item, jfc.tons, fc.co2_per_kg, (jfc.tons * 1000 * fc.co2_per_kg) / 1000 AS co2_tot_tons
FROM japan_food_co2 AS jfc
INNER JOIN(
	SELECT prodotto, kgco2_per_kgprodotto AS co2_per_kg
	FROM food_co2
	ORDER BY co2_per_kg DESC
	LIMIT 5
) fc
ON jfc.item = fc.prodotto;



--- Percentuale di co2 prodotta dal principale alimenti inquinante nei 5 paesi

-- CHINA
-- principale prodotto
SELECT * 
FROM food
WHERE 
    area LIKE 'China' 
	AND years = 2022
ORDER BY food_value DESC
LIMIT 1;
-- %co2 principale prodotto
SELECT * 
FROM food_co2
WHERE prodotto LIKE 'Egg%';



--- Andamento produzione di manzo nei 5 paesi nel tempo 
--https://www.fao.org/faostat/en/#data/QCL




