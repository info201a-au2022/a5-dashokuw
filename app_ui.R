library(shiny)
library(plotly)
library(shinythemes)

source("./app_server.R")

summary_val <- calculate_summary_info()

intro_page <- tabPanel(
  "Introduction",
  titlePanel("Introduction"),
  img(src = "https://content.fortune.com/wp-content/uploads/2019/04/bra05.19.analytics-coal-emissions.jpg",
      style = "width: 360px; height: 300px;"),
  p("In this data exploration, I examine emissions of various compounds per
    capita across the world. In doing so, I hope to uncover which countries emit
    the most of particular compounds per capita, and gain objective insights to 
    demystify various claims made by adverserial countries on the issues."),
  p("For example, developed nations often claim that developing nations produce
    more emissions. Developing nations, in defense, state that their emissions
    are from industrial activities to expand their economies, and claim that
    developed nations did the same at an earlier time and now have high emissions
    from consumption."),
  p(paste0("Before delving into specifics, it is useful to gain a general sense 
  of the data. The data shows that the average per capita CO2 emissions is ",
    summary_val[1], " tons.")),
  p(paste0("Further, the country that produced the most CO2 per capita in 2021 
          was ", summary_val[2], " tons.")),
  p(paste0("Finally, the country with the greatest CO2 per capita ever is ", 
          summary_val[3], "."))
)

vis_page <- tabPanel(
  "Interactive Visualization",
  titlePanel("Interactive Visualization"),
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "var_to_examine", label = "Choose Variable",
                  choices = c("CO2 per capita", "CO2 from Coal per capita",
                              "CO2 from Consumption per capita", 
                              "CO2 from Gas per capita", "Methane per capita", 
                              "CO2 from Oil per capita", 
                              "Nitrous Oxide per capita")),
      sliderInput(inputId = "year", label = "Choose Years", min = 1850, 
                  max = 2021, value = c(1850, 2021), sep = "")
    ),
    mainPanel(
      plotlyOutput("line_chart")
    )
  ),
  p("I included this line chart as a way to look at historical trends across
    each emission measure. Controlling the year range allows you to see more
    specific recent trends or get a better picture of the data when the data
    is NA for earlier years. While I expected the United States and other
    developed nations to be on top for these metrics, small regions/nations I
    had never heard of before were instead high. In addition, oil-producing
    nations from the Middle East, especially Qatar, were consistently higher
    on these metrics as well. Overall, focusing on per capita data made me
    realize that while developed nations have a high raw emission number, smaller
    nations may have much higher per capita numbers as they may be places that
    wealthy individuals who consume or produce a lot of emissions flock to.")
)

ui <- navbarPage(
  theme = shinytheme("darkly"),
  "CO2 Data Exploration",
  intro_page,
  vis_page
)
