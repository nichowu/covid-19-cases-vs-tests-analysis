# author: Fatime Selimi, Neel Phaterpekar, Nicholas Wu, Tannmay Sharma
# date: 2020-11-25

"""Filters, cleans and transforms the OWID Covid-19 data (from (https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/owid-covid-data.csv)).
Writes the transformed and summarized data to separate csv files.
Usage: src/preprocess_data.py --input=<input> --out_dir=<out_dir>

Options:
--input=<input>       Path (including filename) to raw data (csv file)
--out_dir=<out_dir>   Path to directory where the processed data should be written
"""

import os
import pandas as pd
from docopt import docopt

opt = docopt(__doc__)

ISO_CODES = {'CANADA': 'CAN', 'USA': 'USA'}
START_DATE = '2020-03-01'
END_DATE = '2020-10-31'
COL_NAMES = ["iso_code", "date", "new_cases", "new_tests"]


def main(input_file, out_dir):
    covid = pd.read_csv(input_file)
    covid = covid[COL_NAMES]

    select_can_usa_query = "iso_code == @ISO_CODES['CANADA'] or iso_code == @ISO_CODES['USA']"
    filter_new_tests_cases_query = "new_tests > 0 and new_cases != 0 and date >= @START_DATE and date <= @END_DATE"

    covid_us_can = covid.query(select_can_usa_query).reset_index(drop=True)
    covid_us_can = covid_us_can.query(filter_new_tests_cases_query).reset_index(drop=True)
    covid_us_can["response_ratio"] = covid_us_can["new_tests"] / covid_us_can["new_cases"]

    try:
        covid_us_can.to_csv(f"{out_dir}/processed_data.csv", index=False)
    except:
        os.makedirs(os.path.dirname(out_dir), exist_ok=True)
        covid_us_can.to_csv(f"{out_dir}/processed_data.csv", index=False)


if __name__ == "__main__":
    main(opt["--input"], opt["--out_dir"])
