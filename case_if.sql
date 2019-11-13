
-- SELECT  *,
--         SUM(opportunity_youth) OVER() AS total_population,
--         opportunity_youth / SUM(opportunity_youth) OVER() * 100 AS pct
-- FROM ( 
--     SELECT SUM(pwgtp) AS opportunity_youth
--     FROM pums_2017
--     WHERE (rt = 'P')
--     AND (puma = '11610' OR puma = '11613' OR puma = '11614' OR puma = '11615' OR puma = '11611' OR puma = '11612')
--     AND (agep BETWEEN 16 AND 24)
--     AND (sch = '1')
--     AND (esr = '3' OR esr = '6')

-- )AS temp;

-- SELECT oy_flag, COUNT(oy_flag) AS count
-- FROM (
--     SELECT CASE WHEN (sch = '1' AND (esr = '3' OR esr = '6')) 
--                         THEN 'oy' 
--                         WHEN (sch = '1' AND schl::INTEGER <16) AND (esr = '1' OR esr = '2') 
--                         THEN 'working without diploma' 
--                         ELSE 'not oy' END AS oy_flag 
--         FROM pums_2017
--         WHERE (rt = 'P')
--         AND (puma = '11610' OR puma = '11613' OR puma = '11614' OR puma = '11615' OR puma = '11611' OR puma = '11612')
--         AND (agep BETWEEN 16 AND 24)
-- ) AS temp 
-- GROUP BY oy_flag

-- SELECT oy_flag, COUNT(oy_flag), SUM(count(oy_flag)) OVER() AS total_population, 
--         count(oy_flag) / SUM(count(oy_flag)) OVER() * 100 AS pct
-- FROM (
--     SELECT CASE WHEN (sch = '1' AND (esr = '3' OR esr = '6')) 
--                         THEN 'oy' 
--                         WHEN (sch = '1' AND schl::INTEGER <16) AND (esr = '1' OR esr = '2') 
--                         THEN 'working without diploma' 
--                         ELSE 'not oy' END AS oy_flag 
--         FROM pums_2017
--         WHERE (rt = 'P')
--         AND (puma = '11610' OR puma = '11613' OR puma = '11614' OR puma = '11615' OR puma = '11611' OR puma = '11612')
--         AND (agep BETWEEN 16 AND 24)
-- ) AS temp 
-- GROUP BY oy_flag
-- CREATE TABLE total_population AS (
--     SELECT Age,oy_flag, SUM(pwgtp), SUM(SUM(pwgtp)) OVER(PARTITION BY Age) AS total_population, 
--             SUM(pwgtp) / SUM(SUM(pwgtp)) OVER(PARTITION BY Age) * 100 AS pct
--     FROM (
--         SELECT PWGTP, CASE WHEN (sch = '1' AND (esr = '3' OR esr = '6')) 
--                             THEN 'oy' 
--                             WHEN (sch = '1' AND schl::INTEGER <16) AND (esr = '1' OR esr = '2') 
--                             THEN 'working without diploma' 
--                             ELSE 'not oy' END AS oy_flag,
--                             CASE WHEN 
--                                 (agep BETWEEN 16 AND 18) THEN '16 to 18'
--                             WHEN (agep BETWEEN 19 AND 21) THEN '19 to 21'
--                                 WHEN (agep BETWEEN 22 AND 24) THEN '22 to 24' END AS Age  
                            
--             FROM pums_2017
--             WHERE (rt = 'P')
--             AND (puma = '11610' OR puma = '11613' OR puma = '11614' OR puma = '11615' OR puma = '11611' OR puma = '11612')
--             AND (agep BETWEEN 16 AND 24)
--     ) AS temp 
--     GROUP BY oy_flag, Age  
-- ) ;

SELECT oy_flag, SUM(sum) AS group_total, SUM(SUM(sum)) OVER () as Total_population, SUM(sum)/SUM(SUM(sum)) OVER() * 100 AS pct 
    FROM total_population
    GROUP BY oy_flag; 