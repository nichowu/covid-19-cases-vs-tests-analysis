# author: Fatime Selimi, Neel Phaterpekar, Nicholas Wu, Tannmay Sharma
# date: 2020-11-25

"Filters, cleans and transforms the OWID Covid-19 data (from (https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/owid-covid-data.csv)).
Writes the transfromed and summarized data to separate csv files.
Usage: src/process_data.R --input=<input> --out_dir=<out_dir>

Options:
--input=<input>       Path (including filename) to raw data (feather file)
--out_dir=<out_dir>   Path to directory where the processed data should be written
" -> doc


library(tidyverse)
library(docopt)

main <- function(input) {
  raw_data <- read_csv(input)
  
  
  # filter data set to consider only Canada and USA, and select only variables of interest
  # then create a new column called response_ratio which holds the ratio between new_tests and new_cases
  covid_CAN_USA <- raw_data %>%
    filter(iso_code == "CAN" | iso_code == "USA",
           date < "2020-11-01",
           new_cases != 0 & new_tests != 0) %>%
    select("iso_code", "date", "location", "new_tests", "new_cases") %>%
    drop_na(new_tests, new_cases) %>%
    mutate(response_ratio = new_tests / new_cases)
  
  
  # create a summary table for Canada and USA that contains columns such as sample_size, mean_response_ratio, median_response_ratio, and std
  covid_CAN_USA_summary <-  covid_CAN_USA %>%
    group_by(iso_code) %>%
    summarise(
      sample_size = n(),
      mean_response_ratio = mean(response_ratio),
      median_response_ratio = median(response_ratio),
      std = sd(response_ratio),
    )
  
  
  # write scale factor to a file
  try({
    dir.create(out_dir)
  })
  
  # write processed and summary data to csv files
  write_csv(covid_CAN_USA, paste0(out_dir, "/covid_CAN_USA.csv"))
  write_csv(covid_CAN_USA_summary, paste0(out_dir, "/covid_CAN_USA_summary.csv"))
}
