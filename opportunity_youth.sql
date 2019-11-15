DROP TABLE IF EXISTS total_youth;
CREATE TABLE total_youth AS (
    SELECT * 
    FROM pums_2017 
    WHERE (rt = 'P') 
    AND (puma = '11604' OR puma = '11605' OR puma = '11610' OR puma = '11613' OR puma = '11614' OR puma = '11615' OR puma = '11611' OR puma = '11612') 
    AND (agep BETWEEN 16 AND 24) 
);

DROP TABLE IF EXISTS oyyouth_from_pumas;
CREATE TABLE oyyouth_from_pumas AS (
    SELECT * 
    FROM pums_2017 
    WHERE (rt = 'P') 
    AND (puma = '11604' OR puma = '11605' OR puma = '11610' OR puma = '11613' OR puma = '11614' OR puma = '11615' OR puma = '11611' OR puma = '11612') 
    AND (agep BETWEEN 16 AND 24) 
    AND (sch = '1') 
    AND (esr = '3' OR esr = '6')
);

DROP TABLE IF EXISTS oy_age_counts;

CREATE TABLE oy_age_counts AS (
    SELECT age_flag, oy_flag, SUM(pwgtp) as estimate, SUM(SUM(pwgtp)) OVER(PARTITION BY age_flag) AS total, ROUND((SUM(pwgtp) / SUM(SUM(pwgtp)) OVER(PARTITION BY age_flag)) * 100, 2) AS percent
    FROM (
        SELECT CASE WHEN (sch = '1' AND (esr = '3' OR esr = '6')) THEN 'OY' 
                    WHEN (sch = '1' AND (schl::INTEGER < 16) AND (esr = '1' OR esr = '2')) THEN 'Working without diploma'
                    ELSE 'Not OY' 
                    END AS oy_flag,
                CASE WHEN (agep BETWEEN 16 AND 18) THEN 'Age 16-18'
                    WHEN (agep BETWEEN 19 AND 21) THEN 'Age 19-21'
                    ELSE 'Age 22-24'
                    END AS age_flag,
                pwgtp
        FROM pums_2017
        WHERE (rt = 'P')
        AND (puma = '11604' OR puma = '11605' OR puma = '11610' OR puma = '11613' OR puma = '11614' OR puma = '11615' OR puma = '11611' OR puma = '11612') 
        AND (agep BETWEEN 16 AND 24)
        ) AS temp
    GROUP BY age_flag, oy_flag
);

DROP TABLE IF EXISTS oy_age_counts_by_education;

CREATE TABLE oy_age_counts_by_education AS (
    SELECT age_flag, edu_flag, SUM(pwgtp) as estimate, SUM(SUM(pwgtp)) OVER(PARTITION BY age_flag) AS total, ROUND((SUM(pwgtp) / SUM(SUM(pwgtp)) OVER(PARTITION BY age_flag)) * 100, 2) AS percent
    FROM (
        SELECT CASE WHEN (schl::INTEGER <= 15 OR schl = 'bb') THEN 'No Diploma' 
                    WHEN (schl = '16' OR schl = '17') THEN 'HS Diploma or GED'
                    WHEN (schl = '18' OR schl = '19')THEN 'College but no degree'
                    ELSE 'College Degree Holder' 
                    END AS edu_flag,
                CASE WHEN (agep BETWEEN 16 AND 18) THEN 'Age 16-18'
                    WHEN (agep BETWEEN 19 AND 21) THEN 'Age 19-21'
                    ELSE 'Age 22-24'
                    END AS age_flag,
                pwgtp
        FROM pums_2017
        WHERE (rt = 'P')
        AND (puma = '11604' OR puma = '11605' OR puma = '11610' OR puma = '11613' OR puma = '11614' OR puma = '11615' OR puma = '11611' OR puma = '11612') 
        AND (agep BETWEEN 16 AND 24)
        AND (sch = '1')
        AND (esr = '3' OR esr = '6')
        ) AS temp
    GROUP BY age_flag, edu_flag
);

DROP TABLE IF EXISTS oy_age_summary;
CREATE TABLE oy_age_summary AS (
    SELECT oy_flag, SUM(estimate) AS Group_Total, SUM(SUM(estimate)) OVER () AS Total_Population, ROUND(SUM(estimate) / SUM(SUM(estimate)) OVER() * 100, 2) AS percent 
    FROM oy_age_counts
    GROUP BY oy_flag
);

DROP TABLE IF EXISTS oy_education_summary;
CREATE TABLE oy_education_summary AS (
    SELECT edu_flag, SUM(estimate) AS Group_Total, SUM(SUM(estimate)) OVER () AS Total_Population, ROUND(SUM(estimate) / SUM(SUM(estimate)) OVER() * 100, 2) AS percent 
    FROM oy_age_counts_by_education
    GROUP BY edu_flag
);