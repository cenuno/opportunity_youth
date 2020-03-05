SELECT 
	stplcname AS city_Name,
	ctycsubname AS Sub_Name, 
	stschoolname AS School_District_name,
	blklatdd AS latitude,
	blklondd AS longitude 
FROM 
	wa_geo_xwalk
WHERE 
	stusps = 'WA'
	AND 
		ctyname = 'King County, WA'
	AND 
		stplcname LIKE '%Auburn%'
		OR 
			stplcname LIKE '%Burien%'
		OR 
			stplcname LIKE '%Covington%'
		OR 
			stplcname LIKE '%Des Moines%'
		OR 
			stplcname LIKE '%Enumclaw%'
		OR 
			stplcname LIKE '%Federal Way%'
		OR 
			stplcname LIKE '%Kent%'
		OR 
			stplcname LIKE 'Maple Valley%'
		OR 
			stplcname LIKE '%Normandy Park%'
		OR 
			stplcname LIKE '%Renton%'
		OR 
			stplcname LIKE '%Tukwila%'
		OR 
			stplcname LIKE '%SeaTac%'
		OR 
			stplcname LIKE '%White Center%'
		OR 
			stplcname LIKE '%Boulevard Park%'
		OR 
			stplcname LIKE '%Vashon%'
ORDER BY stplcname;


SELECT *
FROM pums_2017
WHERE agep::INT BETWEEN 16 AND 24
AND sch::INT = 1
AND st::INT = 53 
AND esr::INT = 3
;


SELECT puma, agep, esr, sch
FROM pums_2017
WHERE puma::INT = 11610 
OR puma::INT = 11612 
OR puma::INT = 11616 
OR puma::INT = 11615
OR puma::INT = 11614
OR puma::INT = 11613
OR puma::INT = 11611
AND agep::INT BETWEEN 16 AND 24
AND sch::INT = 1
AND st::INT = 53 
AND esr::INT = 3
;


SELECT *
FROM puma_names_2010
WHERE state_name ='Washington'
AND cpuma0010::INT BETWEEN 1044 AND 1046
;
