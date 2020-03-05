SELECT 
		puma AS South_County_ID, 
		agep AS OY_AGE, 
		esr AS Employement_Status, 
		sch AS School_Status
FROM 
	pums_2017
WHERE 
puma::INT IN (11610, 11611, 11612, 11613, 11614, 11615)
AND 
	agep::INT BETWEEN 16 AND 24
AND 
	sch::INT = 1
AND 
	st::INT = 53 
;
