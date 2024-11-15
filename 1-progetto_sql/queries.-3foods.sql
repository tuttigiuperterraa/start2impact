-- Costruzione del database
CREATE DATABASE progetto_sqldb;


-- Costruzione delle tabelle 

--- Tabella global_var - source : https://www.kaggle.com/datasets/nelgiriyewithana/countries-of-the-world-2023
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
co2 bigint,
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

UPDATE global_var
SET country_name = 'United States of America'
WHERE country_name LIKE 'United States';

--- Tabella andamento co2 - source : https://ourworldindata.org/co2-emissions
CREATE TABLE co2_over_years(
country varchar(255),
country_code varchar(255),
years int,
co2_in_tons float,
PRIMARY KEY (country, years)
);

UPDATE co2_over_years
SET country = 'United States of America'
WHERE country LIKE 'United States';

--- Tabella prodotti alimentari - source: https://www.fao.org/faostat/en/#data/QCL
CREATE TABLE food(
food_domain varchar(255),
area varchar(255),
food_element varchar(255),
item varchar(255),
years int,
food_value float
);

UPDATE food
SET area = 'Russia'
WHERE area LIKE 'Russian Federation';

--- Tabella impatto ambientale prodotti alimentari - source: https://ourworldindata.org/grapher/ghg-per-kg-poore
CREATE TABLE food_co2(
product varchar(20) PRIMARY KEY unique,
code varchar(20),
years int,
kgco2_per_kgproduct float
);


--- Visualizziamo i 5 paesi con maggior produzione di co2
SELECT country_name, population, density, co2 AS co2_tons
FROM global_var
WHERE co2 IS NOT NULL
ORDER BY co2 DESC
LIMIT 5;	-- China
			-- USA
			-- India
			-- Russia
			-- Japan

--- Visualizziamo l'andamento della produzione di co2 di questi 5  paesi negli ultimi 5 anni
SELECT * 
FROM co2_over_years
WHERE country IN(
	SELECT country_name
	FROM global_var
	WHERE co2 IS NOT NULL
	ORDER BY co2 DESC
	LIMIT 5
)
	AND years BETWEEN 2019 AND 2023
ORDER BY co2_in_tons DESC;

-- CHINA
SELECT country, years, co2_in_tons, 
ROUND(CAST(((co2_in_tons - LAG(co2_in_tons) OVER (ORDER BY years)) / LAG(co2_in_tons) OVER (ORDER BY years)) * 100 AS  numeric), 1) AS percent_difference
FROM co2_over_years
WHERE country LIKE 'China'
	AND years BETWEEN 2019 AND 2023
ORDER BY years DESC;

-- USA
SELECT country, years, co2_in_tons, 
ROUND(CAST(((co2_in_tons - LAG(co2_in_tons) OVER (ORDER BY years)) / LAG(co2_in_tons) OVER (ORDER BY years)) * 100 AS  numeric), 1) AS percent_difference
FROM co2_over_years
WHERE country LIKE 'United States of America'
	AND years BETWEEN 2019 AND 2023
ORDER BY years DESC;

-- INDIA
SELECT country, years, co2_in_tons, 
ROUND(CAST(((co2_in_tons - LAG(co2_in_tons) OVER (ORDER BY years)) / LAG(co2_in_tons) OVER (ORDER BY years)) * 100 AS  numeric), 1) AS percent_difference
FROM co2_over_years
WHERE country LIKE 'India'
	AND years BETWEEN 2019 AND 2023
ORDER BY years DESC;

-- RUSSIA
SELECT country, years, co2_in_tons, 
ROUND(CAST(((co2_in_tons - LAG(co2_in_tons) OVER (ORDER BY years)) / LAG(co2_in_tons) OVER (ORDER BY years)) * 100 AS  numeric), 1) AS percent_difference
FROM co2_over_years
WHERE country LIKE 'Russia'
	AND years BETWEEN 2019 AND 2023
ORDER BY years DESC;

-- JAPAN
SELECT country, years, co2_in_tons, 
ROUND(CAST(((co2_in_tons - LAG(co2_in_tons) OVER (ORDER BY years)) / LAG(co2_in_tons) OVER (ORDER BY years)) * 100 AS  numeric), 1) AS percent_difference
FROM co2_over_years
WHERE country LIKE 'Japan'
	AND years BETWEEN 2019 AND 2023
ORDER BY years DESC;

/*
--- Visualizza i 5 paesi con la popolazione più alta
SELECT country_name, population, density, co2
FROM global_var
WHERE population IS NOT NULL
ORDER BY population DESC
LIMIT 10;
*/

--- Visualizziamo i 5 alimenti che inquinano di più
SELECT product, kgco2_per_kgproduct AS co2
FROM food_co2
ORDER BY co2 DESC
LIMIT 3;
					-- Beef
				    -- Dark chocolate
					-- Lamb & Mutton


--- CHINA
WITH china_food_co2
AS(
	--%co2 da beef
	SELECT area, 'Beef (beef herd)' AS item, food_value AS tons_item
	FROM food
	WHERE 
	    area LIKE 'China' 
	    AND item ~* 'cattle'  --rende case-insensitive la ricerca
	    AND item ~* 'meat'
		AND years = 2022

	UNION ALL
	
	--%co2 da chocolate
	SELECT area, 'Dark Chocolate' AS item, food_value AS tons_item
	FROM food
	WHERE 
	    area LIKE 'China' 
	    AND item ~* 'cocoa'  --rende case-insensitive la ricerca
		AND years = 2022

	UNION ALL
	
	--%co2 da lamb
	SELECT area, 'Lamb & Mutton' AS item, food_value  AS tons_item
	FROM food
	WHERE 
	    area LIKE 'China' 
	    AND item ~* 'sheep'
		AND item ~* 'meat'--rende case-insensitive la ricerca
		AND years = 2022
)
SELECT 
	cfc.area, 
	product, 
	tons_item, 
	fc.co2_per_kg_per_item AS tons_co2_per_tons_of_item,
	tons_item * fc.co2_per_kg_per_item AS tons_co2_by_item,
	co2_china_2022.co2_in_tons,
	(((tons_item * fc.co2_per_kg_per_item) / (co2_china_2022.co2_in_tons)) * 100) AS impact
FROM china_food_co2 AS cfc
RIGHT JOIN(
	SELECT 
		product, 
		kgco2_per_kgproduct AS co2_per_kg_per_item
	FROM food_co2
	ORDER BY co2_per_kg_per_item DESC
	LIMIT 3
) fc
	ON cfc.item = fc.product
LEFT JOIN(
	SELECT country,  co2_in_tons 
	FROM co2_over_years
	WHERE country LIKE 'China' AND years = 2022
) co2_china_2022
	ON cfc.area = co2_china_2022.country
ORDER BY impact DESC;

--- USA
WITH usa_food_co2
AS(
	--%co2 da beef
	SELECT area, 'Beef (beef herd)' AS item, food_value AS tons_item
	FROM food
	WHERE 
	    area LIKE 'United States of America' 
	    AND item ~* 'cattle'  --rende case-insensitive la ricerca
	    AND item ~* 'meat'
		AND years = 2022

	UNION ALL
	
	--%co2 da chocolate
	SELECT area, 'Dark Chocolate' AS item, food_value AS tons_item
	FROM food
	WHERE 
	    area LIKE 'United States of America' 
	    AND item ~* 'cocoa'  --rende case-insensitive la ricerca
		AND years = 2022

	UNION ALL
	
	--%co2 da lamb
	SELECT area, 'Lamb & Mutton' AS item, food_value  AS tons_item
	FROM food
	WHERE 
	    area LIKE 'United States of America' 
	    AND item ~* 'sheep'
		AND item ~* 'meat'--rende case-insensitive la ricerca
		AND years = 2022
)
SELECT 
	ufc.area, 
	product, 
	tons_item, 
	fc.co2_per_kg_per_item AS tons_co2_per_tons_of_item,
	tons_item * fc.co2_per_kg_per_item AS tons_co2_by_item,
	co2_usa_2022.co2_in_tons,
	(((tons_item * fc.co2_per_kg_per_item) / (co2_usa_2022.co2_in_tons)) * 100) AS impact
FROM usa_food_co2 AS ufc
RIGHT JOIN(
	SELECT 
		product, 
		kgco2_per_kgproduct AS co2_per_kg_per_item
	FROM food_co2
	ORDER BY co2_per_kg_per_item DESC
	LIMIT 3
) fc
	ON ufc.item = fc.product
LEFT JOIN(
	SELECT country,  co2_in_tons 
	FROM co2_over_years
	WHERE country LIKE 'United States of America' AND years = 2022
) co2_usa_2022
	ON ufc.area = co2_usa_2022.country
ORDER BY impact DESC;

--- INDIA
WITH india_food_co2
AS(
	--%co2 da beef
	SELECT area, 'Beef (beef herd)' AS item, food_value AS tons_item
	FROM food
	WHERE 
	    area LIKE 'India' 
	    AND item ~* 'cattle'  --rende case-insensitive la ricerca
	    AND item ~* 'meat'
		AND years = 2022

	UNION ALL
	
	--%co2 da chocolate
	SELECT area, 'Dark Chocolate' AS item, food_value AS tons_item
	FROM food
	WHERE 
	    area LIKE 'India' 
	    AND item ~* 'cocoa'  --rende case-insensitive la ricerca
		AND years = 2022

	UNION ALL
	
	--%co2 da lamb
	SELECT area, 'Lamb & Mutton' AS item, food_value  AS tons_item
	FROM food
	WHERE 
	    area LIKE 'India' 
	    AND item ~* 'sheep'
		AND item ~* 'meat'--rende case-insensitive la ricerca
		AND years = 2022
)
SELECT 
	cfc.area, 
	product, 
	tons_item, 
	fc.co2_per_kg_per_item AS tons_co2_per_tons_of_item,
	tons_item * fc.co2_per_kg_per_item AS tons_co2_by_item,
	co2_india_2022.co2_in_tons,
	(((tons_item * fc.co2_per_kg_per_item) / (co2_india_2022.co2_in_tons)) * 100) AS impact
FROM india_food_co2 AS cfc
RIGHT JOIN(
	SELECT 
		product, 
		kgco2_per_kgproduct AS co2_per_kg_per_item
	FROM food_co2
	ORDER BY co2_per_kg_per_item DESC
	LIMIT 3
) fc
	ON cfc.item = fc.product
LEFT JOIN(
	SELECT country,  co2_in_tons 
	FROM co2_over_years
	WHERE country LIKE 'India' AND years = 2022
) co2_india_2022
	ON cfc.area = co2_india_2022.country
ORDER BY impact DESC;

-- RUSSIA
WITH russia_food_co2
AS(
	--%co2 da beef
	SELECT area, 'Beef (beef herd)' AS item, food_value AS tons_item
	FROM food
	WHERE 
	    area LIKE 'Russia' 
	    AND item ~* 'cattle'  --rende case-insensitive la ricerca
	    AND item ~* 'meat'
		AND years = 2022

	UNION ALL
	
	--%co2 da chocolate
	SELECT area, 'Dark Chocolate' AS item, food_value AS tons_item
	FROM food
	WHERE 
	    area LIKE 'Russia' 
	    AND item ~* 'cocoa'  --rende case-insensitive la ricerca
		AND years = 2022

	UNION ALL
	
	--%co2 da lamb
	SELECT area, 'Lamb & Mutton' AS item, food_value  AS tons_item
	FROM food
	WHERE 
	    area LIKE 'Russia' 
	    AND item ~* 'sheep'
		AND item ~* 'meat'--rende case-insensitive la ricerca
		AND years = 2022
)
SELECT 
	cfc.area, 
	product, 
	tons_item, 
	fc.co2_per_kg_per_item AS tons_co2_per_tons_of_item,
	tons_item * fc.co2_per_kg_per_item AS tons_co2_by_item,
	co2_russia_2022.co2_in_tons AS tons_co2_tot_russia,
	(((tons_item * fc.co2_per_kg_per_item) / (co2_russia_2022.co2_in_tons)) * 100) AS impact
FROM russia_food_co2 AS cfc
RIGHT JOIN(
	SELECT 
		product, 
		kgco2_per_kgproduct AS co2_per_kg_per_item
	FROM food_co2
	ORDER BY co2_per_kg_per_item DESC
	LIMIT 3
) fc
	ON cfc.item = fc.product
LEFT JOIN(
	SELECT country,  co2_in_tons
	FROM co2_over_years
	WHERE country LIKE 'Russia' AND years = 2022
) co2_russia_2022
	ON cfc.area = co2_russia_2022.country
ORDER BY impact DESC;

--- JAPAN
WITH japan_food_co2
AS(
	--%co2 da beef
	SELECT area, 'Beef (beef herd)' AS item, food_value AS tons_item
	FROM food
	WHERE 
	    area LIKE 'Japan' 
	    AND item ~* 'cattle'  --rende case-insensitive la ricerca
	    AND item ~* 'meat'
		AND years = 2022

	UNION ALL
	
	--%co2 da chocolate
	SELECT area, 'Dark Chocolate' AS item, food_value AS tons_item
	FROM food
	WHERE 
	    area LIKE 'Japan' 
	    AND item ~* 'cocoa'  --rende case-insensitive la ricerca
		AND years = 2022

	UNION ALL
	
	--%co2 da lamb
	SELECT area, 'Lamb & Mutton' AS item, food_value  AS tons_item
	FROM food
	WHERE 
	    area LIKE 'Japan' 
	    AND item ~* 'sheep'
		AND item ~* 'meat'--rende case-insensitive la ricerca
		AND years = 2022
)
SELECT 
	cfc.area, 
	product 
	tons_item, 
	fc.co2_per_kg_per_item AS tons_co2_per_tons_of_item,
	tons_item * fc.co2_per_kg_per_item AS tons_co2_by_item,
	co2_japan_2022.co2_in_tons,
	(((tons_item * fc.co2_per_kg_per_item) / (co2_japan_2022.co2_in_tons)) * 100) AS impact
FROM japan_food_co2 AS cfc
RIGHT JOIN(
	SELECT 
		product, 
		kgco2_per_kgproduct AS co2_per_kg_per_item
	FROM food_co2
	ORDER BY co2_per_kg_per_item DESC
	LIMIT 3
) fc
	ON cfc.item = fc.product
LEFT JOIN(
	SELECT country,  co2_in_tons 
	FROM co2_over_years
	WHERE country LIKE 'Japan' AND years = 2022
) co2_japan_2022
	ON cfc.area = co2_japan_2022.country
ORDER BY impact DESC;



--- Percentuale di co2 prodotta dal principale alimenti inquinante nei 5 paesi

-- CHINA
-- principale prodotto
SELECT 
		area,
		item,
		food_value AS tons_item
    FROM food
    WHERE 
        area LIKE 'China' 
        AND years = 2022
    ORDER BY food_value DESC
    LIMIT 1;
-- co2 principale prodotto
SELECT  *
FROM food_co2
WHERE product LIKE 'Egg%';
-- impatto principale prodotto
WITH primary_food
AS(
	SELECT 
			area,
			'Eggs' AS product,
			item,
			food_value AS tons_item
	    FROM food
	    WHERE 
	        area LIKE 'China' 
	        AND years = 2022
	    ORDER BY food_value DESC
	    LIMIT 1
)
SELECT 
	area, 
	primary_food.product, 
	item, 
	tons_item, 
	kgco2_per_kgproduct AS tons_co2_per_tons_of_item,
	co2_china_2022.co2_in_tons,
	(((tons_item * kgco2_per_kgproduct) / (co2_china_2022.co2_in_tons)) * 100) AS impact
FROM
	primary_food
INNER JOIN(
	SELECT  *
	FROM food_co2
	WHERE product LIKE 'Egg%'
) egg_table
	ON primary_food.product = egg_table.product
LEFT JOIN(
	SELECT country,  co2_in_tons 
	FROM co2_over_years
	WHERE country LIKE 'China' AND years = 2022
) co2_china_2022
	ON primary_food.area = co2_china_2022.country;

-- USA
-- principale prodotto
SELECT 
		area,
		item,
		food_value AS tons_item
    FROM food
    WHERE 
        area LIKE 'United States of America' 
        AND years = 2022
    ORDER BY food_value DESC
    LIMIT 1;
-- co2 principale prodotto
SELECT  *
FROM food_co2
WHERE product ~* 'maize';
-- impatto principale prodotto
WITH primary_food
AS(
	SELECT 
			area,
			'Maize' AS product,
			item,
			food_value AS tons_item
	    FROM food
	    WHERE 
	        area LIKE 'United States of America' 
	        AND years = 2022
	    ORDER BY food_value DESC
	    LIMIT 1
)
SELECT 
	area, 
	primary_food.product, 
	item, 
	tons_item, 
	kgco2_per_kgproduct AS tons_co2_per_tons_of_item,
	co2_usa_2022.co2_in_tons,
	(((tons_item * kgco2_per_kgproduct) / (co2_usa_2022.co2_in_tons)) * 100) AS impact
FROM
	primary_food
INNER JOIN(
	SELECT  *
	FROM food_co2
	WHERE product ~* 'maize'
) maize_table
	ON primary_food.product = maize_table.product
LEFT JOIN(
	SELECT country,  co2_in_tons
	FROM co2_over_years
	WHERE country LIKE 'United States of America' AND years = 2022
) co2_usa_2022
	ON primary_food.area = co2_usa_2022.country;

-- INDIA
-- principale prodotto
SELECT 
		area,
		item,
		food_value AS tons_item
    FROM food
    WHERE 
        area LIKE 'India' 
        AND years = 2022
    ORDER BY food_value DESC
    LIMIT 1;
-- co2 principale prodotto
SELECT  *
FROM food_co2
WHERE product ~* 'cane';
-- impatto principale prodotto
WITH primary_food
AS(
	SELECT 
			area,
			'Cane Sugar' AS product,
			item,
			food_value AS tons_item
	    FROM food
	    WHERE 
	        area LIKE 'India' 
	        AND years = 2022
	    ORDER BY food_value DESC
	    LIMIT 1
)
SELECT 
	area, 
	primary_food.product, 
	item, 
	tons_item, 
	kgco2_per_kgproduct AS tons_co2_per_tons_of_item,
	co2_india_2022.co2_in_tons,
	(((tons_item * kgco2_per_kgproduct) / (co2_india_2022.co2_in_tons)) * 100) AS impact
FROM
	primary_food
INNER JOIN(
	SELECT  *
	FROM food_co2
	WHERE product ~* 'cane'
) cane_table
	ON primary_food.product = cane_table.product
LEFT JOIN(
	SELECT country,  co2_in_tons
	FROM co2_over_years
	WHERE country LIKE 'India' AND years = 2022
) co2_india_2022
	ON primary_food.area = co2_india_2022.country;

-- RUSSIA
-- principale prodotto
SELECT 
		area,
		item,
		food_value AS tons_item
    FROM food
    WHERE 
        area LIKE 'Russia' 
        AND years = 2022
    ORDER BY food_value DESC
    LIMIT 1;
-- co2 principale prodotto
SELECT  *
FROM food_co2
WHERE product ~* 'wheat';
-- impatto principale prodotto
WITH primary_food
AS(
	SELECT 
			area,
			'Wheat & Rye' AS product,
			item,
			food_value AS tons_item
	    FROM food
	    WHERE 
	        area LIKE 'Russia' 
	        AND years = 2022
	    ORDER BY food_value DESC
	    LIMIT 1
)
SELECT 
	area, 
	primary_food.product, 
	item, 
	tons_item, 
	kgco2_per_kgproduct AS tons_co2_per_tons_of_item,
	co2_russia_2022.co2_in_tons,
	(((tons_item * kgco2_per_kgproduct) / (co2_russia_2022.co2_in_tons)) * 100) AS impact
FROM
	primary_food
INNER JOIN(
	SELECT  *
	FROM food_co2
	WHERE product ~* 'wheat'
) wheat_table
	ON primary_food.product = wheat_table.product
LEFT JOIN(
	SELECT country,  co2_in_tons 
	FROM co2_over_years
	WHERE country LIKE 'Russia' AND years = 2022
) co2_russia_2022
	ON primary_food.area = co2_russia_2022.country;

-- JAPAN
-- principale prodotto
SELECT 
		area,
		item,
		food_value AS tons_item
    FROM food
    WHERE 
        area LIKE 'Japan' 
        AND years = 2022
    ORDER BY food_value DESC
    LIMIT 1;
-- co2 principale prodotto
SELECT  *
FROM food_co2
WHERE product LIKE 'Egg%';
-- impatto principale prodotto
WITH primary_food
AS(
	SELECT 
			area,
			'Eggs' AS product,
			item,
			food_value AS tons_item
	    FROM food
	    WHERE 
	        area LIKE 'Japan' 
	        AND years = 2022
	    ORDER BY food_value DESC
	    LIMIT 1
)
SELECT 
	area, 
	primary_food.product, 
	item, 
	tons_item, 
	kgco2_per_kgproduct AS tons_co2_per_tons_of_item,
	co2_japan_2022.co2_in_tons,
	(((tons_item * kgco2_per_kgproduct) / (co2_japan_2022.co2_in_tons)) * 100) AS impact
FROM
	primary_food
INNER JOIN(
	SELECT  *
	FROM food_co2
	WHERE product LIKE 'Egg%'
) egg_table
	ON primary_food.product = egg_table.product
LEFT JOIN(
	SELECT country,  co2_in_tons 
	FROM co2_over_years
	WHERE country LIKE 'Japan' AND years = 2022
) co2_japan_2022
	ON primary_food.area = co2_japan_2022.country;

--- Andamento produzione di manzo nei 5 paesi nel tempo 
--https://www.fao.org/faostat/en/#data/QCL



