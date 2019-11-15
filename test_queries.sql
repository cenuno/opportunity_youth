-- SELECT * 
-- FROM puma_names_2010
-- WHERE state_name = 'Washington' AND puma_name LIKE '%' || 'King' || '%';

-- SELECT *
--     FROM pums_2017
--     WHERE (rt = 'P')
--     AND (puma = '11610' OR puma = '11613' OR puma = '11614' OR puma = '11615' OR puma = '11611' OR puma = '11612')
--     AND (agep BETWEEN 16 AND 24)
--     AND (sch = '1')
--     AND (esr = '3' OR esr = '6'); 

-- a query to get total youth:
-- SELECT COUNT(rt) 
-- FROM pums_2017
-- WHERE (rt = 'P')
-- AND (puma = '11610' OR puma = '11613' OR puma = '11614' OR puma = '11615' OR puma = '11611' OR puma = '11612')
-- AND (agep BETWEEN 16 AND 24);

-- -- a query to get to total opp youth
-- SELECT COUNT(rt) 
-- FROM pums_2017
-- WHERE (rt = 'P')
-- AND (puma = '11610' OR puma = '11613' OR puma = '11614' OR puma = '11615' OR puma = '11611' OR puma = '11612')
-- AND (sch = '1')
-- AND (esr = '3' OR esr = '6')
-- AND (agep BETWEEN 16 AND 24); 

-- a query to get the opp youth percent of total 


-- SELECT  *,
--         SUM(pwgtp_sum) OVER() AS total,
--         ROUND((pwgtp_sum / SUM(pwgtp_sum) OVER()) * 100, 2) AS pct
-- FROM ( 
--     SELECT SUM(pwgtp) AS opportunty_youth
--     FROM pums_2017
--     WHERE (rt = 'P')
--     AND (puma = '11610' OR puma = '11613' OR puma = '11614' OR puma = '11615' OR puma = '11611' OR puma = '11612')
--     AND (agep BETWEEN 16 AND 24)
--     AND (sch = '1')
--     AND (esr = '3' OR esr = '6')

-- )AS temp;



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


-- SELECT * FROM ct_puma_xwalk
-- WHERE (puma5ce = '11610')
--  LIMIT 1;

-- SELECT * FROM wa_geo_xwalk 
-- LIMIT 1;

-- #create the table and creat the column cty
-- ALTER TABLE ct_puma_xwalk
-- ADD COLUMN cty VARCHAR ;

-- UPDATE ct_puma_xwalk
-- SET cty = (statefp || countyfp) ;


-- JOIN wa jobs, ct_puma_xwalk, and wa_geo_xwalk
-- SELECT puma5ce, ctyname, c000  
-- FROM ct_puma_xwalk
-- JOIN wa_geo_xwalk x
-- USING (cty)
-- JOIN wa_jobs_2017 j
-- ON x.tabblk2010 = j.w_geocode
-- LIMIT 1;

  
 
-- SELECT  puma5ce, 
--             CASE WHEN (c000 >0) AND (cA01 >0)
--             THEN ((cA01/c000)*100) 
--             WHEN (c000 =0) OR (cA01 = 0) 
--             THEN (cA01 * c000) 
--             END  AS percent
SELECT puma5ce, SUM(c000) total_jobs, SUM(cA01) under_29_jobs, 
FROM wa_jobs_2017 j 
JOIN wa_geo_xwalk x
ON x.tabblk2010 = j.w_geocode 
JOIN ct_puma_xwalk w 
USING (cty)
WHERE puma5ce = '11610' OR puma5ce = '11613' OR puma5ce = '11614' OR puma5ce = '11615' 
    OR puma5ce = '11611' OR puma5ce = '11612' OR puma5ce = '11604' OR puma5ce = '11605'
GROUP BY puma5ce
;
-- JOIN wa_geo_xwalk x 
-- ON x.tabblk2010 = j.w_geocode 
;  

-- SELECT Age,oy_flag, SUM(pwgtp), SUM(SUM(pwgtp)) OVER(PARTITION BY Age) AS total_population, 
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