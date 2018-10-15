library(dplyr);
library(ggplot2);
library(readr);
library(stringr);

library(highcharter);
source("R/CleaningAndAnalysis.R");

data_beer <- read_csv("data/raw/Beers.csv");
data_brewery <- read_csv("data/raw/Breweries.csv");

mapdata <- get_data_from_map(download_map_data("countries/us/us-all"))



StateSummary$State <- str_trim(StateSummary$State,side="both")
StateSummary <- StateSummary %>% mutate(`hc-a2`= State);

glimpse(StateSummary);

hcmap("countries/us/us-all",
	  data = StateSummary,
	  value = "medianABV",
      joinBy = "hc-a2",
	  name = "State Summary | Median ABV",
      dataLabels = list(enabled = TRUE, format = '{point.name}'),
      borderColor = "#FAFAFA",
	  borderWidth = 0.1,
      tooltip = list(valueDecimals = 5,valueSuffix = " ABV")
	  ) %>%
	hc_title(text = "This is a title with <i>margin</i> and <b>Strong or bold text</b>",
			 margin = 20, align = "left",
			 style = list(color = "#90ed7d", useHTML = TRUE)) %>%
	hc_colorAxis(minColor = "#FFFFFF", maxColor = "#FF0000") %>%
	hc_mapNavigation(enabled = TRUE)



ggplot(BeerBrew, aes(IBU))+
geom_density(na.rm = TRUE)
