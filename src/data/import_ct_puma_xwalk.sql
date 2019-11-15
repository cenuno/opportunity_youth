/*
    Author:     Cristian E. Nuno
    Purpose:    Import census tract to PUMA
    Date:       November 13, 2019
*/

-- Drop any existing tables
DROP TABLE IF EXISTS ct_puma_xwalk;

-- Create a table for the census tract to puma geographic crosswalk data
CREATE TABLE ct_puma_xwalk (
    STATEFP CHARACTER(2),
    COUNTYFP CHARACTER(3),
    TRACTCE CHARACTER(6),
    PUMA5CE CHARACTER(5)
);

-- Copy the csv contents of the census tract to puma geographic crosswalk data into the table
COPY ct_puma_xwalk
FROM :CT_PUMA_XWALK_PATH
DELIMITER ',' CSV HEADER;