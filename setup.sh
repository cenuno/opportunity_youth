# install necessary packages
sh src/requirements/install.sh

# download necessary data and place it in a PostgreSQL database
sh src/data/get_data.sh

# create the oy-env conda environment
conda env create -f environment.yml

# activate the oy-env conda environment
conda activate oy-env

# make oy-env available to you as a kernel in jupyter
python -m ipykernel install --user --name oy-env --display-name "oy-env"
