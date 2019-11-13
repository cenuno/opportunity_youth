-- -- CREATE TABLE oy_youths AS (
--     SELECT Age,oy_flag, SUM(pwgtp), SUM(SUM(pwgtp)) OVER(PARTITION BY Age) AS total_population, 
--             count(oy_flag) / SUM(count(oy_flag)) OVER(PARTITION BY Age) * 100 AS pct
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
-- CREATE TABLE oppotunity_youth_education AS (
-- SELECT Age,Education, SUM(pwgtp), SUM(SUM(pwgtp)) OVER(PARTITION BY Age) AS total_population, 
--             SUM(pwgtp) / SUM(SUM(pwgtp)) OVER(PARTITION BY Age) * 100 AS pct
--     FROM(
--             SELECT pwgtp, CASE WHEN (schl::INTEGER <=15) 
--                                         THEN 'No diploma'
--                                         WHEN (schl = '16' OR schl = '17') 
--                                         THEN 'HS Diploma or GED'
--                                         WHEN (schl = '18' OR schl ='19')
--                                         THEN 'Some College, no degree'
--                                         WHEN (schl::INTEGER >= 20)
--                                         THEN 'Degree (Associate or higher)' END AS Education,
--                                     CASE WHEN 
--                                             (agep BETWEEN 16 AND 18) THEN '16 to 18'
--                                         WHEN (agep BETWEEN 19 AND 21) THEN '19 to 21'
--                                             WHEN (agep BETWEEN 22 AND 24) THEN '22 to 24' END AS Age 
--                     FROM pums_2017
--                     WHERE (rt = 'P')
--                     AND (puma = '11610' OR puma = '11613' OR puma = '11614' OR puma = '11615' OR puma = '11611' OR puma = '11612'OR puma = '11604' or puma = '11605')
--                     AND (agep BETWEEN 16 AND 24)
--                     AND (sch = '1')
--                     AND (esr = '3' OR esr = '6')
--     ) AS temp 

--     GROUP BY Education, Age 
-- );

SELECT education, SUM(sum), SUM(SUM(sum)) OVER () as Total_population, SUM(sum)/SUM(SUM(sum)) OVER() * 100 AS pct 
    FROM oppotunity_youth_education
    GROUP BY education; 