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



SELECT  *,
        SUM(opportunity_youth) OVER() AS total_population,
        opportunity_youth / SUM(opportunity_youth) OVER() * 100 AS pct
FROM ( 
    SELECT SUM(pwgtp) AS opportunity_youth
    FROM pums_2017
    WHERE (rt = 'P')
    AND (puma = '11610' OR puma = '11613' OR puma = '11614' OR puma = '11615' OR puma = '11611' OR puma = '11612')
    AND (agep BETWEEN 16 AND 24)
    AND (sch = '1')
    AND (esr = '3' OR esr = '6')

)AS temp;


