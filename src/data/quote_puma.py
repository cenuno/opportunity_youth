"""
Exports PUMA file with quotes
"""

# load necessary modules ----
import csv
import pandas as pd

# load necessary data ----
df = pd.read_excel("data/raw/CPUMA0010_PUMA2010_components.xls")

# export as csv ----
df.to_csv("data/processed/puma_2010_names.csv",
          index=False,
          quoting=csv.QUOTE_ALL)
