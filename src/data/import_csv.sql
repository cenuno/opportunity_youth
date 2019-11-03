/*
    Author:     Cristian E. Nuno
    Purpose:    Import CSV file into a PSQL table
    Date:       November 2, 2019
*/

-- Create a skeleton table
CREATE TABLE pums_2017 (
    name TEXT,
    power INT
);

-- Copy the csv contents into the skeleton table
COPY pums_2017
FROM :PUMS_PATH
DELIMITER ',' CSV HEADER;
