-- count how many records per state
SELECT state_name, COUNT(state_name)
from puma_names_2010
GROUP BY state_name
LIMIT 5;