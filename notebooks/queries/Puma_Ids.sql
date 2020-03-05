SELECT 
		*
FROM 
	puma_names_2010
WHERE 
	state_name ='Washington'
AND 
	cpuma0010::INT 
		BETWEEN 1044 AND 1046
;
