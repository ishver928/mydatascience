library(tidyverse)
library(shiny)
library(bslib)
library(tools)
library(broom) # for regression tidying

# Load dataset
data("diamonds")

# Fit regression model once (including categorical vars)
model <- lm(price ~ carat + cut + color + clarity + depth + table + x + y + z, data = diamonds)

# Define custom diamond-themed light theme
my_theme <- bs_theme(
  version = 5,
  primary = "#84d6f4",      
  secondary = "#d0f0ff",    
  success = "#cbeffd",      
  bg = "#f1f7fb",           
  fg = "#002f4b",           
  base_font = font_google("Tektur"),
  heading_font = font_google("Michroma"),
  font_scale = 1
)

# UI
ui <- page_fluid(
  theme = my_theme,  
  titlePanel("Shine Bright Like a Diamond 💎"),
  
  navset_pill(
    
    # --- Introduction Tab with Cards ---
    nav_panel("Introduction",
              layout_columns(
                card(
                  card_header("Instructions"),
                  "This app explores the diamonds dataset using visualizations, 
                   statistics, and interactive features. Use the navigation 
                   tabs to view different sections. Adjust filters in the 
                   Graphics tab to explore how variables influence diamond 
                   prices. Also, while switching graphs or buttons give it a minute
                  it's processing thousands of data points at once! Thank you :)"
                ),
                card(
                  card_header("Introduction"),
                  "💎 Because who doesn’t want their data to shine bright like a diamond? 
                   I chose the diamonds dataset because it’s both sparkling and practical — 
                   diamonds may be glamorous, but the factors behind their pricing are surprisingly complex. 
                   My main goal is to uncover which variable has the greatest impact on the price of a diamond."
                ),
                card(
                  card_header("Variable Glossary"),
                  tags$ul(
                    tags$li(strong("carat:"), " Diamond weight in carats"),
                    tags$li(strong("cut:"), " Quality of cut (Fair → Ideal)"),
                    tags$li(strong("color:"), " Diamond color, from J (worst) to D (best)"),
                    tags$li(strong("clarity:"), " Diamond clarity (Fair → Ideal)"),
                    tags$li(strong("depth:"), " Total depth percentage"),
                    tags$li(strong("table:"), " Width of top of diamond relative to widest point"),
                    tags$li(strong("price:"), " Price in USD"),
                    tags$li(strong("x:"), " Length in mm"),
                    tags$li(strong("y:"), " Width in mm"),
                    tags$li(strong("z:"), " Depth in mm")
                  )
                )
              )
    ), 
    
    # --- Graphics Tab ---
    nav_panel("Graphics",
              layout_sidebar(
                sidebar = sidebar(
                  selectInput("predictor", "Choose a predictor variable for price:",
                              choices = c("carat", "depth", "table", "x", "y", "z"))
                ),
                plotOutput("smooth_plot", height = "500px"),
                actionButton("explain1", "🔍 What does this graph mean?", class = "btn-primary"),
                br(), br(),
                plotOutput("graphics1"),
                actionButton("explain2", "📊 What does this graph mean?", class = "btn-primary"),
                br(), br(),
                plotOutput("graphics2"),
                actionButton("explain3", "💠 What does this graph mean?", class = "btn-primary")
              )
    ),
    
    # --- Statistics Tab with Subtabs ---
    nav_panel("Statistics",
              navset_tab(
                nav_panel("Summary",
                          card(
                            card_header("Summary Table by Cut"),
                            tableOutput("summary_table")
                          ),
                          card(
                            card_header("Average Price by Cut"),
                            plotOutput("summary_plot")
                          )
                ),
                
                nav_panel("Confidence Intervals",
                          card(
                            card_header("95% Confidence Interval for Average Price"),
                            tableOutput("ci_table"),
                            plotOutput("ci_plot"),
                            actionButton("explain_ci", "💎 What does this mean?", class = "btn-info")
                          )
                ),
                
                nav_panel("Hypothesis Tests",
                          card(
                            card_header("Premium vs. Ideal Cuts"),
                            tableOutput("htest_table"),
                            actionButton("explain_htest", "💎 Explain this test", class = "btn-info")
                          )
                ),
                
                nav_panel("Linear Regression",
                          card(
                            card_header("Carat vs. Price"),
                            tableOutput("regression_table"),
                            plotOutput("regression_plot"),
                            actionButton("explain_reg", "💎 What does this mean?", class = "btn-info")
                          )
                )
              )
    ),
    
    # --- Predict Tab ---
    nav_panel("Predict",
              layout_sidebar(
                sidebar = sidebar(
                  selectInput("pred_cut", "Cut:", choices = levels(diamonds$cut)),
                  selectInput("pred_color", "Color:", choices = levels(diamonds$color)),
                  selectInput("pred_clarity", "Clarity:", choices = levels(diamonds$clarity)),
                  numericInput("pred_carat", "Carat:", value = 1, min = 0.1, step = 0.01),
                  numericInput("pred_depth", "Depth %:", value = 61, min = 50, max = 80, step = 0.1),
                  numericInput("pred_table", "Table %:", value = 57, min = 40, max = 80, step = 0.1),
                  numericInput("pred_x", "Length (mm):", value = 5, min = 3, max = 10, step = 0.1),
                  numericInput("pred_y", "Width (mm):", value = 5, min = 3, max = 10, step = 0.1),
                  numericInput("pred_z", "Depth (mm):", value = 3, min = 2, max = 7, step = 0.1),
                  actionButton("predict_btn", "Predict Price", class = "btn-primary")
                ),
                card(
                  card_header("Predicted Diamond Price"),
                  textOutput("predicted_price"),
                  plotOutput("prediction_plot", height = "400px"),
                  actionButton("explain_prediction", "💎 What does this graph mean?", class = "btn-info")
                )
              )
    ),
    
    # --- Full Data Tab ---
    nav_panel("Full Data", 
              dataTableOutput("data")
    ), 
    
    # --- Conclusion Tab ---
    nav_panel("Conclusion", 
              layout_columns(
                col_widths = c(6, 6),  # 2 cards per row
                
                card(
                  card_header("General Insight"),
                  card_body(
                    "This dataset reveals that diamond pricing is shaped by a complex relationship 
        between both quantitative features (like carat and depth) and qualitative 
        characteristics (such as cut, color, and clarity)."
                  )
                ),
                
                card(
                  card_header("Carat Influence"),
                  card_body(
                    "Among all variables explored through the dropdown, carat had the greatest effect on price — 
        showing a clear upward parabolic trend.  
        As carat increases, price tends to rise sharply, reflecting how larger diamonds 
        are significantly more valuable."
                  )
                ),
                
                card(
                  card_header("Carat Anomalies"),
                  card_body(
                    "However, an interesting dip occurs in the graph even as carat increases. 
        This anomaly suggests that carat alone isn't the full story — 
        certain diamonds with higher carat might still be priced lower if their cut, 
        color, or clarity are poor."
                  )
                ),
                
                card(
                  card_header("Cut, Color, and Clarity"),
                  card_body(
                    tags$ul(
                      tags$li("Cut impacts how well the diamond reflects light, which affects its perceived beauty and thus price."),
                      tags$li("Color grades penalize visible yellow tint, especially in higher grades."),
                      tags$li("Clarity reflects the presence of flaws, where more flawless diamonds command premium prices.")
                    )
                  )
                ),
                
                card(
                  card_header("Conclusion"),
                  card_body(
                    "While carat heavily influences diamond pricing, true valuation depends on 
        a multivariate blend of physical size and subjective visual appeal.  
        Future exploration could bring in external diamond market data to further 
        validate the observed patterns and strengthen the model’s predictive power."
                  )
                ),
                
                card(
                  card_body(
                    img(
                      src = "https://i.pinimg.com/736x/2d/00/2f/2d002f41d4d18328ae446a5716af35fa.jpg",
                      width = "75%",
                      style = "border-radius:12px; max-height:250px; object-fit:cover;"
                    )
                  )
                )
              )
    ),
    
    # --- Sources & About Tab ---
    nav_menu( 
      "Sources",
      "Source(s):", 
      nav_item(a("Shiny", href = "https://shiny.posit.co", target = "_blank")),
      "----", 
      "About the Author",
      nav_panel("Ishanvi Verma",
                h1("All About Ishanvi"),
                uiOutput("bio")
      )
    ) 
  ), 
  id = "tab"
)

# Server
server <- function(input, output, session) {
  # --- Graphics Tab ---
  output$smooth_plot <- renderPlot({
    ggplot(diamonds, aes_string(x = input$predictor, y = "price")) +
      geom_smooth(fill = "#9ac5db", color = "#84d6f4") +
      labs(
        title = paste("How", input$predictor, "Affects Diamond Price"),
        x = str_to_title(input$predictor),
        y = "Price ($)"
      ) 
  })
  
  output$graphics1 <- renderPlot({
    diamonds |>
      ggplot(aes(x = cut, y = price, fill = cut)) +
      geom_boxplot() +
      scale_fill_brewer(palette = "Blues") +
      labs(title = "Price by Cut Quality", x = "Cut", y = "Price") 
  })
  
  output$graphics2 <- renderPlot({
    diamonds |>
      ggplot(aes(x = carat, y = price, color = clarity)) +
      geom_point(alpha = 0.3) +
      scale_color_brewer(palette = "Blues") +
      labs(title = "Carat vs. Price Colored by Clarity", x = "Carat", y = "Price")
  })
  
  # --- Statistics Tab ---
  output$summary_table <- renderTable({
    diamonds |>
      group_by(cut) |>
      summarize(
        Average_Carat = mean(carat),
        Average_Price = mean(price),
        SD_Price = sd(price),
        Count = n()
      )
  })
  
  output$summary_plot <- renderPlot({
    diamonds |>
      group_by(cut) |>
      summarize(Average_Price = mean(price)) |>
      ggplot(aes(x = cut, y = Average_Price, fill = cut)) +
      geom_col() +
      scale_fill_brewer(palette = "Blues") +
      labs(title = "Average Price by Cut", x = "Cut", y = "Average Price ($)")
  })
  
  output$ci_table <- renderTable({
    mean_price <- mean(diamonds$price)
    sd_price <- sd(diamonds$price)
    n <- nrow(diamonds)
    error_margin <- qnorm(0.975) * (sd_price / sqrt(n))
    lower <- mean_price - error_margin
    upper <- mean_price + error_margin
    data.frame(
      Mean = mean_price,
      Lower_95CI = lower,
      Upper_95CI = upper
    )
  })
  
  output$ci_plot <- renderPlot({
    mean_price <- mean(diamonds$price)
    sd_price <- sd(diamonds$price)
    n <- nrow(diamonds)
    error_margin <- qnorm(0.975) * (sd_price / sqrt(n))
    
    ggplot(data.frame(x = 1, y = mean_price), aes(x, y)) +
      geom_point(size = 5, color = "#84d6f4") +
      geom_errorbar(aes(ymin = mean_price - error_margin,
                        ymax = mean_price + error_margin),
                    width = 0.2, color = "#002f4b") +
      labs(title = "95% Confidence Interval for Mean Price",
           x = "", y = "Price ($)") +
      theme(axis.text.x = element_blank(),
            axis.ticks.x = element_blank())
  })
  
  output$htest_table <- renderTable({
    test <- t.test(price ~ cut, data = diamonds %>% filter(cut %in% c("Premium", "Ideal")))
    data.frame(
      Test = "Two-sample t-test (Premium vs Ideal)",
      p_value = test$p.value,
      Mean_Premium = mean(diamonds$price[diamonds$cut == "Premium"]),
      Mean_Ideal = mean(diamonds$price[diamonds$cut == "Ideal"])
    )
  })
  
  output$regression_table <- renderTable({
    model_simple <- lm(price ~ carat, data = diamonds)
    broom::tidy(model_simple)[, c("term", "estimate", "std.error", "p.value")]
  })
  
  output$regression_plot <- renderPlot({
    ggplot(diamonds, aes(x = carat, y = price)) +
      geom_point(alpha = 0.3, color = "#9ac5db") +
      geom_smooth(method = "lm", se = TRUE, color = "#002f4b") +
      labs(title = "Linear Regression: Carat vs. Price",
           x = "Carat", y = "Price ($)")
  })
  
  # --- Explanations ---
  observeEvent(input$explain1, {
    showModal(modalDialog(
      title = "🔍 Understanding the Smooth Plot",
      "💎 This graph shows the relationship between your selected variable and diamond price.
       The smooth blue curve highlights the overall trend, 
       helping us see how changes in the predictor affect the average price.",
      easyClose = TRUE
    ))
  })
  
  observeEvent(input$explain2, {
    showModal(modalDialog(
      title = "📊 Understanding Price by Cut Quality",
      "✨ This boxplot compares diamond prices across different cut qualities.
       The middle line in each box is the median price,
       while the box shows the range where most prices fall.
       Outliers (dots) are unusually high or low prices.",
      easyClose = TRUE
    ))
  })
  
  observeEvent(input$explain3, {
    showModal(modalDialog(
      title = "💠 Understanding Carat vs. Price by Clarity",
      "💠 This scatterplot shows how carat weight relates to price, 
       with points colored by clarity. 
       It helps us see how both size and clarity contribute to a diamond’s value.",
      easyClose = TRUE
    ))
  })
  
  observeEvent(input$explain_ci, {
    showModal(modalDialog(
      title = "💎 Understanding Confidence Intervals",
      "The 95% confidence interval tells us that we are 95% confident the true average 
      price of all diamonds falls within this interval. Since the sample mean 
      lies within it (as expected), it suggests our estimate is reliable.",
      easyClose = TRUE
    ))
  })
  
  observeEvent(input$explain_htest, {
    showModal(modalDialog(
      title = "💎 Understanding the Hypothesis Test",
      "This t-test compares the average prices of Premium and Ideal cut diamonds. 
      A low p-value (< 0.05) means the difference is statistically significant.",
      easyClose = TRUE
    ))
  })
  
  observeEvent(input$explain_reg, {
    showModal(modalDialog(
      title = "💎 Understanding the Regression",
      "This regression shows how carat weight predicts price. 
      The slope tells us how much the price increases for each additional carat.",
      easyClose = TRUE
    ))
  })
  
  # --- Predict Tab ---
  observeEvent(input$predict_btn, {
    new_diamond <- data.frame(
      carat = input$pred_carat,
      cut = input$pred_cut,
      color = input$pred_color,
      clarity = input$pred_clarity,
      depth = input$pred_depth,
      table = input$pred_table,
      x = input$pred_x,
      y = input$pred_y,
      z = input$pred_z
    )
    
    price_pred <- predict(model, newdata = new_diamond)
    
    output$predicted_price <- renderText({
      paste0("Estimated Price: $", round(price_pred, 2))
    })
    
    output$prediction_plot <- renderPlot({
      mean_price <- mean(diamonds$price)
      ggplot(diamonds, aes(x = price)) +
        geom_histogram(binwidth = 700, fill = "#9ac5db", color = "white") +
        geom_vline(xintercept = mean_price, color = "#002f4b", size = 1.2, linetype = "dashed") +
        geom_point(aes(x = price_pred, y = 0), color = "#002f4b", size = 6) +
        labs(title = "Your Diamond Compared to the Market",
             x = "Price ($)", y = "Count") +
        annotate("text", x = price_pred, y = max(table(cut(diamonds$price, breaks = 50)))*0.9,
                 label = paste0("Predicted: $", round(price_pred, 0)), color = "#002f4b", hjust = -0.1)
    })
  })
  
  observeEvent(input$explain_prediction, {
    showModal(modalDialog(
      title = "💎 Understanding Your Diamond's Price",
      "This histogram shows the overall distribution of diamond prices. 
      The dashed blue line marks the average price.  
      The blue dot shows your predicted diamond price.", 
      easyClose = TRUE
    ))
  })
  
  # --- Full Data Tab ---
  output$data <- renderDataTable({
    diamonds
  })
  
  # --- About the Author Tab ---
  output$bio <- renderUI({
    tags$p(
      "Hey everyone, my name is Ishanvi Verma and I am a rising senior at Washington High School. 
    I have a strong passion in the STEM field whether it comes to informatics, data analysis, or computer science. 
    I enjoy using technology to solve real-world problems and have experience working on both independent and team-based projects. 
    I'm always eager to learn, innovate, and make a meaningful impact through my work. 
    Outside of my passion for STEM, some of my hobbies include dancing, hanging out with friends, playing Roblox, and public speaking. 
    I have participated in many dance competitions whether it's at CA State Adventure Disneyland or at NBA's Halftime. 
    Furthermore, I have spoken at many events and on the ethics of AI and rising technology at Ceres's District and Fremont District. 
    That's a little about me — thank you for using this app and supporting my data science journey! 
    If you are interested in how I created this or the code for a specific function, feel free to email ishanvi.verma@gmail.com.",
      
      tags$br(), tags$br(),
      
      tags$img(src = "All About Me Collage.png", style = "max-width:100%; height:auto;")
    )
  })
  
}

# Launch the app
shinyApp(ui = ui, server = server)