/* Identifying King County Pumas  */

SELECT count(*)
FROM pums_2017
WHERE RT ='P'
AND puma BETWEEN '11610' AND '11614'
AND SCH = '1'
AND WKL = '2' OR WKL = '3'
LIMIT 5;