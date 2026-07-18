library(tidyverse)
library(shiny)
library(bslib)
library(tools)
library(shinyWidgets)
library(ggplot2)

# Load dataset
data("diamonds")

# Custom diamond-themed light theme
my_theme <- bs_theme(
  version = 5,
  primary = "#84d6f4",
  secondary = "#d0f0ff",
  success = "#cbeffd",
  bg = "#f1f7fb",
  fg = "#002f4b",
  base_font = font_google("Tektur"),
  heading_font = font_google("Michroma")
)

# UI
ui <- page_fluid(
  theme = my_theme,
  titlePanel("Shine Bright Like a Diamond 💎"),
  navset_pill(
    nav_panel("Introduction",
              layout_column_wrap(
                width = 1/3,
                card(h4("How to Use This App"), "Navigate through the tabs to explore how various factors influence diamond pricing. Use dropdowns and buttons for interaction."),
                card(h4("Objective"), "This app aims to help users understand what impacts the cost of diamonds using statistical and machine learning tools."),
                card(h4("Dataset Overview"),
                     "This dataset contains 50,000+ diamonds and records features like carat (weight), cut (quality), color (D-J), clarity (FL-I1), depth (%), table (%), and x, y, z dimensions (in mm).",
                     "\n- Carat: Diamond weight\n- Cut: Ideal > Premium > Good > Fair\n- Color: D (best, colorless) to J (more yellow)\n- Clarity: FL (flawless) to I1 (included)\n- Table: Width of top of diamond\n- x/y/z: Dimensions in mm"
                )
              )
    ),
    
    nav_panel("Graphics",
              layout_sidebar(
                sidebar = sidebar(
                  selectInput("predictor", "Choose a predictor variable for price:",
                              choices = c("carat", "depth", "table", "x", "y", "z"))
                ),
                plotOutput("smooth_plot", height = "500px"),
                actionButton("explain1", "What does this graph mean?", class = "btn-primary"),
                br(), br(),
                plotOutput("graphics1"),
                actionButton("explain2", "What does this graph mean?", class = "btn-primary"),
                br(), br(),
                plotOutput("graphics2"),
                actionButton("explain3", "What does this graph mean?", class = "btn-primary")
              )
    ),
    
    nav_panel("Statistics",
              navs_tab_card(
                nav_panel("Summary Statistics",
                          tableOutput("stats1"),
                          tableOutput("stats2")
                ),
                nav_panel("Linear Model",
                          tableOutput("stats3"),
                          plotOutput("linearPlot"),
                          verbatimTextOutput("linearExplain")
                ),
                nav_panel("Confidence Interval",
                          tableOutput("stats4"),
                          plotOutput("ciPlot"),
                          verbatimTextOutput("ciExplain")
                )
              )
    ),
    
    nav_panel("Full Data",
              dataTableOutput("data")
    ),
    
    nav_panel("Logistic Regression",
              sidebarLayout(
                sidebarPanel(
                  selectInput("cutInput", "Cut:", choices = unique(diamonds$cut)),
                  selectInput("colorInput", "Color:", choices = unique(diamonds$color)),
                  selectInput("clarityInput", "Clarity:", choices = unique(diamonds$clarity)),
                  sliderInput("caratInput", "Carat:", min = 0.2, max = 5, value = 1, step = 0.01),
                  sliderInput("depthInput", "Depth:", min = 50, max = 70, value = 60),
                  sliderInput("xInput", "x:", min = 0, max = 10, value = 5),
                  sliderInput("yInput", "y:", min = 0, max = 10, value = 5),
                  sliderInput("zInput", "z:", min = 0, max = 10, value = 5)
                ),
                mainPanel(
                  textOutput("predictedPrice")
                )
              )
    ),
    
    nav_panel("Conclusion",
              layout_column_wrap(
                width = 1/2,
                card(h4("Key Insights"), "Carat has the strongest effect on price. Larger carat diamonds are worth significantly more."),
                card(h4("Interactions"), "Even high-carat diamonds may be cheap if clarity/cut is poor. Quality matters!"),
                card(h4("Visual Impact"), "Cut affects light reflection, color penalizes yellow tint, and clarity penalizes flaws."),
                card(h4("Future Work"), "Incorporating external diamond market data could improve prediction accuracy.")
              )
    ),
    
    nav_menu("Sources",
             "Source(s):",
             nav_item(a("Shiny", href = "https://shiny.posit.co", target = "_blank")),
             "----",
             "About the Author",
             nav_panel("Ishanvi Verma",
                       h1("All About Me"),
                       textOutput("bio")
             )
    )
  ),
  id = "tab"
)

# (server code continues as-is with modifications to render the new outputs)
# Will update server next.
