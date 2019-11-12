/* Identifying King County Pumas  */

-- SELECT puma, count(puma)
-- FROM pums_2017
-- WHERE puma BETWEEN '11610' AND '11614'
-- AND agep BETWEEN '16' AND '24'
-- AND SCH = '1'
-- AND (esr = '3' or esr = '6')
-- GROUP BY puma
-- LIMIT 50;

/* Below is looking at people weights and grouping by them */

-- SELECT  PWGTP, count(PWGTP)
-- FROM pums_2017
-- WHERE puma BETWEEN '11610' AND '11614'
-- AND agep BETWEEN '16' AND '24'
-- AND SCH = '1'
-- AND (esr = '3' or esr = '6')
-- GROUP BY PWGTP
-- LIMIT 500;

-- SELECT agep, puma, sch, esr
-- FROM pums_2017
-- WHERE pwgtp = 130
-- AND puma BETWEEN '11610' AND '11614'
-- LIMIT 50;

-- SELECT  pwgtp, count(*) * pwgtp AS weighted
-- FROM pums_2017
-- WHERE puma BETWEEN '11610' AND '11614'
-- AND agep BETWEEN '16' AND '24'
-- AND SCH = '1'
-- AND (esr = '3' or esr = '6')
-- GROUP BY pwgtp;

