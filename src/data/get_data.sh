#!/bin/bash

# bash function used to retrieve the absolute file path of a file as a string
# note: thank you to peterh's answer on SO 
#       https://stackoverflow.com/a/21188136
get_str_abs_filename() {
  # $1 : relative filename
  echo "'$(cd "$(dirname "$1")" && pwd)/$(basename "$1")'"
}

# download the ACS PUMS file naming convention documentation
wget -P references/ https://www2.census.gov/programs-surveys/acs/data/pums/2017/5-Year/PUMS_file_naming_convention.pdf

# download the 2017 ACS PUMS data dictionary
wget -O PUMS_Data_Dictionary_2017.pdf https://www2.census.gov/programs-surveys/acs/tech_docs/pums/data_dict/PUMS_Data_Dictionary_2017.pdf?

# download the 2017 5-year ACS PUMS
# person level records for the state of WA
wget -P data/raw https://www2.census.gov/programs-surveys/acs/data/pums/2017/5-Year/csv_pwa.zip

# unpack the .zip file and place its contents within the appropriate directory
unzip data/raw/csv_pwa.zip -d data/raw/

# store the absolute file path of the .csv file that stores the PUMS data
export PUMS_PATH=$(get_abs_filename "data/raw/psam_p53.csv")

# move the documentation into the appropriate directory
mv data/raw/ACS2013_2017_PUMS_README.pdf references/
mv PUMS_Data_Dictionary_2017.pdf references/

# create a PostgreSQL database
createdb opportunity_youth

# import the csv file into the opportunity_youth database
# note: great tutorial on bash & psql found here
#       https://www.manniwood.com/postgresql_and_bash_stuff/index.html
psql \
    --dbname=opportunity_youth \
    --file=src/data/import_csv.sql \
    --set PUMS_PATH=$PUMS_PATH \
    --echo-all