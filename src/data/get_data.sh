#!/bin/bash

echo "Start downloading data and documentation at $(date)"

# bash function used to retrieve the absolute file path of a file as a string
# note: thank you to peterh's answer on SO 
#       https://stackoverflow.com/a/21188136
get_str_abs_filename() {
  # $1 : relative filename
  echo "'$(cd "$(dirname "$1")" && pwd)/$(basename "$1")'"
}

# download the ACS PUMS file naming convention documentation
wget -P references/ https://www2.census.gov/programs-surveys/acs/data/pums/2017/5-Year/PUMS_file_naming_convention.pdf

# download the 2010 PUMA names data
wget -P data/raw/ https://usa.ipums.org/usa/resources/volii/CPUMA0010_PUMA2010_components.xls

# download the 2010 PUMA shapefile
wget -P data/raw/ https://www2.census.gov/geo/tiger/TIGER2017//PUMA/tl_2017_53_puma10.zip

# download the 2010 PUMA name guidelines
wget -P references/ https://www2.census.gov/geo/docs/reference/puma/PUMA_name_guidelines.txt

# download the 2010 PUMA guidelines (historical context)
wget -P references/ https://www2.census.gov/geo/docs/reference/puma/2010_puma_guidelines.txt

# download 2010 PUMA overview (high level takeaways)
wget -P references/ https://www2.census.gov/geo/docs/reference/puma/puma_tutorial.txt

# download the 2017 ACS PUMS data dictionary
wget -O PUMS_Data_Dictionary_2017.pdf https://www2.census.gov/programs-surveys/acs/tech_docs/pums/data_dict/PUMS_Data_Dictionary_2017.pdf?

# download the 2017 5-year ACS PUMS
# person level records for the state of WA
wget -P data/raw https://www2.census.gov/programs-surveys/acs/data/pums/2017/5-Year/csv_pwa.zip

# download the The LEHD Origin-Destination Employment Statistics data dictionary
wget -P references/ https://lehd.ces.census.gov/data/lodes/LODES7/LODESTechDoc7.4.pdf

# download the 2017 WA jobs data
wget -P data/raw https://lehd.ces.census.gov/data/lodes/LODES7/wa/wac/wa_wac_S000_JT00_2017.csv.gz

# download the WA geographic crosswalk data
wget -P data/raw https://lehd.ces.census.gov/data/lodes/LODES7/wa/wa_xwalk.csv.gz

# download the census tract to puma geographic crosswalk data
# note: see here for a data dictionary 
#       (https://www.census.gov/programs-surveys/geography/technical-documentation/records-layout/2010-tract-to-puma-record-layout.html)
wget -P data/raw https://www2.census.gov/geo/docs/maps-data/data/rel/2010_Census_Tract_to_2010_PUMA.txt

# unpack the .zip files and place contents back into data/raw/ directory
unzip data/raw/csv_pwa.zip -d data/raw/
unzip data/raw/tl_2017_53_puma10.zip -d data/raw
gunzip -c data/raw/wa_xwalk.csv.gz > data/raw/wa_xwalk.csv
gunzip -c data/raw/wa_wac_S000_JT00_2017.csv.gz > data/raw/wa_wac_S000_JT00_2017.csv

# export the .xls PUMA names file to a .csv
python src/data/quote_puma.py 

# store the absolute file path of the .csv file that stores the PUMS data
export PUMS_PATH=$(get_str_abs_filename "data/raw/psam_p53.csv")

# store the absolute file path of the .csv file that stores the PUMA names data
export PUMA_NAMES_PATH=$(get_str_abs_filename "data/processed/puma_2010_names.csv")

# store the absolute file path of the .csv file that stores the 2017 WA jobs data
export WA_JOBS_PATH=$(get_str_abs_filename "data/raw/wa_wac_S000_JT00_2017.csv")

# store the absolute file path of the .csv file that stores the WA geographic crosswalk data
export WA_XWALK_PATH=$(get_str_abs_filename "data/raw/wa_xwalk.csv")

# store the absolute file path of the .csv file that stores the census tract to puma geographic crosswalk data
export CT_PUMA_XWALK_PATH=$(get_str_abs_filename "data/raw/2010_Census_Tract_to_2010_PUMA.txt")

# move the documentation into the appropriate directory
mv data/raw/ACS2013_2017_PUMS_README.pdf references/
mv PUMS_Data_Dictionary_2017.pdf references/

# create a PostgreSQL database
createdb opportunity_youth

# import the csv files into the opportunity_youth database
# note: great tutorial on bash & psql found here
#       https://www.manniwood.com/postgresql_and_bash_stuff/index.html
psql \
    --dbname=opportunity_youth \
    --file=src/data/import_csv.sql \
    --set PUMS_PATH=$PUMS_PATH \
    --set PUMA_NAMES_PATH=$PUMA_NAMES_PATH \
    --set WA_JOBS_PATH=$WA_JOBS_PATH \
    --set WA_XWALK_PATH=$WA_XWALK_PATH \
    --set CT_PUMA_XWALK_PATH=$CT_PUMA_XWALK_PATH \
    --echo-all

echo "Finished downloading data and documentation at $(date)"
