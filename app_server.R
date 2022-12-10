library(shiny)
library(tidyverse)

co2_data <- read.csv("https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv")

choices <- c("co2_per_capita" = "CO2 per capita", 
             "coal_co2_per_capita" = "CO2 from Coal per capita",
             "consumption_co2_per_capita" = "CO2 from Consumption per capita", 
             "gas_co2_per_capita" = "CO2 from Gas per capita",
             "methane_per_capita" = "Methane per capita", 
             "oil_co2_per_capita" = "CO2 from Oil per capita",
             "nitrous_oxide_per_capita" = "Nitrous Oxide per capita")

calculate_summary_info <- function() {
  mean_co2_per_capita <- round(mean(co2_data$co2_per_capita, na.rm = TRUE), 3)
  most_co2_2021 <- co2_data %>% 
    filter(year == 2021) %>% 
    summarize(most = max(co2_per_capita, na.rm = TRUE)) %>% 
    pull(most)
  greatest_ever_co2_country <- co2_data %>% 
    filter(co2_per_capita == max(co2_per_capita, na.rm = TRUE)) %>% 
    pull(country)
  
  return(c(mean_co2_per_capita, most_co2_2021, greatest_ever_co2_country))
}

get_data <- function(df, var, yrange) {
  var <- names(choices)[choices == var]
  new_df <- df %>% 
    filter(year >= yrange[1], year <= yrange[2]) %>%
    group_by(country) %>% 
    summarize(year = year, country = country, var = get(var))
  return(new_df)
}

server <- function(input, output) {
   output$line_chart <- renderPlotly({
     emissions_data <- get_data(co2_data, input$var_to_examine, input$year)
     print(emissions_data)
     ggplot(data = emissions_data, aes(x = year, y = var, group = country,
                                              color = country)) +
       geom_line() +
       xlab("Year") +
       ylab(input$var_to_examine) +
       ggtitle(paste(input$var_to_examine, "from", input$year[1], "to", 
                     input$year[2]))
   })
}
