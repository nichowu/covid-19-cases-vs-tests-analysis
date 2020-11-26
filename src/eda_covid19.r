# author: Fatime Selimi, Neel Phaterpekar, Nicholas Wu, Tanmay Sharma
# date: 2020-11-25

"Creates eda table and plots for the response ratio from the COVID-19 data (from https://github.com/owid/covid-19-data/tree/master/public/data).
Saves the plots as a pdf and png file.
Usage: src/eda_covid19.r --input_path=<input_path> --out_dir=<out_dir>
  
Options:
--input_path=<input_path>     Path (including filename) to processed data in csv format
--out_dir=<out_dir>           Path to directory where the plots should be saved
" -> doc

library(tidyverse)
library(knitr)
library(infer)
library(cowplot)
library(docopt)
library(ggthemes)

opt <- docopt(doc)

main <- function(input_path, out_dir) {
  
    #create a table summarizing the key statistics
    covid_CAN_USA <- read_csv(input_path)
    
    covid_CAN_USA_summary <-  covid_CAN_USA %>%
        group_by(iso_code) %>%
        summarise(sample_size = n(),
                  mean_response_ratio = mean(response_ratio),
                  median_response_ratio = median(response_ratio),
                  standard_dev = sd(response_ratio)
        )
    
    #create a directory for processed data if it does not exist
    try({
      dir.create(out_dir)
    })
    
    #save table as a .csv file
    write_csv(covid_CAN_USA_summary, 
              paste0(out_dir, "/covid_CAN_USA_summary.csv"))


    #create the histogram plot
    dist_CAN <- create_distribution_plot(covid_CAN_USA, "CAN", "Canada")

    dist_USA <- create_distribution_plot(covid_CAN_USA, "USA", "USA")

    histo_plot <- plot_grid(dist_USA, dist_CAN, ncol=1)

    #save histogram as a .png file
    ggsave(paste0(out_dir, "/histogram_plot.png"),
           histo_plot,
           width = 8,
           height = 10)
    
    #create a violin plot with mean point
    violin_plot <- covid_CAN_USA %>%
        mutate(across(iso_code, fct_relabel, .fun = str_wrap, width = 30)) %>%
        ggplot(aes(x = response_ratio, y = iso_code)) +
        geom_violin(fill = "yellow",
                    alpha = .1, adjust = .8, trim = FALSE) +
        stat_summary(fun = mean,
                     colour = "red",
                     geom = "point") +
        scale_x_continuous(labels = scales::label_number_si(), 
                           limits = c(0, 100)) +
        labs(title = "COVID-19 Response Ratio - Canada vs USA",
             subtitle = "Means shown in red",
             x = "Mean of Response Ratio in both countries",
             y = "Country")
    
    #save violin plot as a .png file
    ggsave(paste0(out_dir, "/violin_plot.png"),
           violin_plot,
           width = 8,
           height = 10)
    
}

#define a function for creating distribution plot
create_distribution_plot <- function(data, iso_code, country){
  data %>% 
    filter(iso_code == iso_code) %>%
    ggplot(aes(response_ratio)) +
    geom_histogram(bins=50) +
    xlab(paste0("Response Ratio, ", country)) +
    ggtitle(paste0("Sample Distribution of ", country, "'s Response Ratio"))
}
main(opt$input_path, opt$out_dir)

