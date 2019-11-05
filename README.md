# South King County Opportunity Youth

This project offers an updated estimate of the number of Opportunity Youth in South King County using the 2017 5-year American Community Survey [(ACS)](https://www.census.gov/programs-surveys/acs/about.html) Public Use Microdata Survey [(PUMS)](https://www.census.gov/programs-surveys/acs/technical-documentation/pums.html).

## Setup Instructions

To download the necessary data, please run the following command:

```bash
# installs necessary requirements and downloads necessary data
# note: this may take anywhere from 10-20 minutes
sh setup.sh
```

### `oy-env` conda environment

This project relies on you using the [`environment.yml`](environment.yml) file to recreate the `oy-env` conda environment. To do so, please run the following commands:

```bash
# create the oy-env conda environment
# note: this make take anywhere from 10-20 minutes
conda env create -f environment.yml

# activate the oy-env conda environment
conda activate oy-env

# make oy-env available to you as a kernel in jupyter
python -m ipykernel install --user --name oy-env --display-name "oy-env"
```
