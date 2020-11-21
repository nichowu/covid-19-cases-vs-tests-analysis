Exoloratory Data Analysis of the Covid-19 Data Set
================

## Summary of the data set

The data set used in this project is a collection of the COVID-19 data
maintained by [Our World in
Data](https://ourworldindata.org/coronavirus). It is updated daily and
includes data on confirmed cases, deaths, hospitalizations and testing,
as well as other variable of potential interests. This data has been
collected, aggregated, and documented by Cameron Appel, Diana Beltekian,
Daniel Gavrilov, Charlie Giattino, Joe Hasell, Bobbie Macdonald, Edouard
Mathieu, Esteban Ortiz-Ospina, Hannah Ritchie, Max Roser. It was sourced
from various origin. Confirmed cases, deaths, hospitalizations and other
related information are sourced from the European Centre for Disease
Prevention and Control (ECDC). Testing related information are collected
by the Our World in Data team from offical reports. Other sources
include United Nations, World Bank, Global Burden of Disease. More
information can be found
[here](https://github.com/owid/covid-19-data/blob/master/public/data/owid-covid-codebook.csv).

## EDA Table

Each row in the data set represents COVID-19 related information for a
given country on a given day starting from 2019-12-31. To limit the
scope of our project, we have chosen the data set that includes
information up to 2020-11-18. Within this data set, there are 57,606
observations and 50 variables. We will be primarily looking at the
COVID-19 data on Canada and USA. Since we are interested in both number
of new cases and number of new tests, any row with missing values in
either column is removed from the date set. We also calculated the
response ratio as defined below:

Response Ratio = \# of daily new cases / \# of daily new tests

Below we have shown the number of observations, mean, median and
standard deviation of response ratio.

We can see from the table that the mean response ratio are both higher
than the median, therefore both distribution seem to be right skewed.
Thus, we might choose to use median as the test statistic in our
hypothesis analysis. The standard deviation does not have as large
difference as the mean and median between Canada and USA, so it might be
reasonable to assume equal variance in our analysis.

| iso\_code | sample\_size | mean\_response\_ratio | median\_response\_ratio | standard\_dev |
| :-------- | -----------: | --------------------: | ----------------------: | ------------: |
| CAN       |          230 |             0.0316949 |               0.0193328 |     0.0323084 |
| USA       |          245 |             0.0730009 |               0.0601935 |     0.0462542 |

Table 1. Summary Statistics of Response Ratio

## EDA Plot

To visualize the distribution, we have plotted the distribution of each
country’s response ratio in the histogram below. The histogram further
confirms that the distributions of both response ratio are indeed right
skewed.

There appears to be a high concentration of the response ratio for
Canada between 0.01 and 0.025. The distribution of USA shows a more flat
distribution as the ratio tend to range from 0.025 to 0.075.

![](EDA_analysis_files/figure-gfm/EDA%20Plot-1.png)<!-- -->

Figure 1. Distribution of Response Ratio for Canada and USA
