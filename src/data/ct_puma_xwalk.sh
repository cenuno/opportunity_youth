#!/bin/bash

echo "Start downloading data"

# bash function used to retrieve the absolute file path of a file as a string
# note: thank you to peterh's answer on SO 
#       https://stackoverflow.com/a/21188136
get_str_abs_filename() {
  # $1 : relative filename
  echo "'$(cd "$(dirname "$1")" && pwd)/$(basename "$1")'"
}

# download the census tract to puma geographic crosswalk data
# note: see here for a data dictionary 
#       (https://www.census.gov/programs-surveys/geography/technical-documentation/records-layout/2010-tract-to-puma-record-layout.html)
wget -P data/raw https://www2.census.gov/geo/docs/maps-data/data/rel/2010_Census_Tract_to_2010_PUMA.txt

# store the absolute file path of the .csv file that stores the census tract to puma geographic crosswalk data
export CT_PUMA_XWALK_PATH=$(get_str_abs_filename "data/raw/2010_Census_Tract_to_2010_PUMA.txt")

# import the csv files into the opportunity_youth database
# note: great tutorial on bash & psql found here
#       https://www.manniwood.com/postgresql_and_bash_stuff/index.html
psql \
    --dbname=opportunity_youth \
    --file=src/data/import_ct_puma_xwalk.sql \
    --set CT_PUMA_XWALK_PATH=$CT_PUMA_XWALK_PATH \
    --echo-all

echo "Finished downloading data"