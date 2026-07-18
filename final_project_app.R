library(tidyverse)
library(shiny)
library(bslib)
library(tools)

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
              textOutput("intro")
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
              tableOutput("stats1"),
              tableOutput("stats2"),
              tableOutput("stats3"),
              tableOutput("stats4")
    ), 
    
    nav_panel("Full Data", 
              dataTableOutput("data")
    ), 
    
    nav_panel("Conclusion", 
              textOutput("conclusions")
    ), 
    
    nav_menu( 
      "Sources",
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

# Server
server <- function(input, output, session) {
  output$smooth_plot <- renderPlot({
    ggplot(diamonds, aes_string(x = input$predictor, y = "price")) +
      geom_smooth(fill = "#9ac5db", color = "#84d6f4") +
      labs(
        title = paste("How", input$predictor, "Affects Diamond Price"),
        x = str_to_title(input$predictor),
        y = "Price ($)"
      ) 
  })
  
  # Intro
  output$intro <- renderText({ 
    "The diamonds dataset contains a combination of numerical and 
    categorical features that influence diamond pricing. These include physical 
    measurements such as carat, depth, and dimensions (x, y, z), as well as 
    qualitative attributes like cut, color, and clarity. While carat has a clear 
    and measurable impact on price, with a generally increasing trend, some dips 
    in the trend suggest the influence of other factors. Categorical
    variables like color and clarity—although opinion-based, still, contribute 
    pricing patterns and highlight how quality affects value. This makes the 
    dataset useful for exploring how both objective and subjective features 
    interact to shape diamond prices. 
    Some unfamiliar variables include table which represents the width of the diamond's top, x (mm) which is the length, y (mm) which is the width, and z (mm) being the height of the diamond."

  })
  
  # Graphics Tab
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
      geom_point() +
      labs(title = "Carat vs. Price Colored by Clarity",
           x = "Carat", y = "Price") +
      scale_color_brewer(palette = "Blues")
  })
  
  # Stats tab
  output$stats1 <- renderTable({
    diamonds |>
      group_by(color) |>
      summarize(`Average Weight (grams)` = mean(carat) * 0.2)
  })
  
  output$stats2 <- renderTable({
    diamonds |>
      group_by(cut) |>
      summarize(`Average Price` = mean(price))
  })
  
  output$stats3 <- renderTable({
    model <- lm(price ~ carat, data = diamonds)
    data.frame(
      Estimate = c(coef(model)[2], coef(model)[1]),
      Parameter = c("Price Increase for each 1 Carat Increase [Slope]", 
                    "Baseline Starting Value ")
    )
  })
  
  output$stats4 <- renderTable({
    mean_price <- mean(diamonds$price)
    sd_price <- sd(diamonds$price)
    n <- nrow(diamonds)
    error_margin <- qnorm(0.975) * (sd_price / sqrt(n))
    lower <- mean_price - error_margin
    upper <- mean_price + error_margin
    data.frame(
      Lower = c(lower),
      Upper = c(upper)
    )
  })
  
  # Full data tab
  output$data <- renderDataTable({
    diamonds 
  })
  
  # Conclusion
  output$conclusions <- renderText({ 
    "This dataset reveals that diamond pricing is shaped by a complex 
    relationship between both quantitative features (like carat and depth) and 
    qualitative characteristics (such as cut, color, and clarity). Among all 
    variables explored through the dropdown, carat had the greatest effect on 
    price — showing a clear upward parabolic trend. As carat increases, price 
    tends to rise sharply, reflecting how larger diamonds are significantly 
    more valuable. However, an interesting dip occurs in the graph even as 
    carat increases. This anomaly suggests that carat alone isn't the full story 
    — certain diamonds with higher carat might still be priced lower if their 
    cut, color, or clarity are poor. This ties directly into the categorical bar 
    graphs, which show that higher-quality diamonds (like those graded “Ideal” 
    in cut, “D” in color, or “IF” in clarity) consistently average higher 
    prices. Conversely, diamonds with similar carat but lower quality grades fall 
    below the curve. Each variable contributes differently: Cut impacts how well 
    the diamond reflects light, which affects its perceived beauty and thus price.
    Color grades penalize visible yellow tint, especially in higher grades.
    Clarity reflects the presence of flaws, where more flawless diamonds command 
    premium prices. Together, these insights emphasize that while carat heavily 
    influences diamond pricing, true valuation depends on a multivariate blend 
    of physical size and subjective visual appeal. Future exploration could 
    bring in external diamond market data to further validate the observed 
    patterns and strengthen the model’s predictive power."
  })
  
  # Author bio
  output$bio <- renderText({ 
    "Hey everyone, my name is Ishanvi Verma and I am a rising senior at 
    Washington High School. I have a strong passion in the STEM field whether 
    it comes to informatics, data analysis, or computer science. 
    I enjoy using technology to solve real-world problems and have experience 
    working on both independent and team-based projects. I'm always eager to 
    learn, innovate, and make a meaningful impact through my work."
  })
  
  # Modal dialogs for graph explanations
  observeEvent(input$explain1, {
    showModal(modalDialog(
      title = "Smooth Curve Graph Explanation",
      "This graph shows how the selected variable (e.g., carat or depth) affects the price of diamonds using a smoothed curve. It helps you see overall trends and patterns rather than individual points.",
      easyClose = TRUE
    ))
  })
  
  observeEvent(input$explain2, {
    showModal(modalDialog(
      title = "Boxplot Explanation",
      "This boxplot shows how diamond prices vary based on the quality of the cut. Each box summarizes the price distribution for one cut type (e.g., Ideal, Premium), letting you compare medians and spread.",
      easyClose = TRUE
    ))
  })
  
  observeEvent(input$explain3, {
    showModal(modalDialog(
      title = "Scatter Plot Explanation",
      "This scatter plot shows the relationship between carat (weight) and price, colored by the clarity of the diamond. It helps you see if clarity influences price along with carat.",
      easyClose = TRUE
    ))
  })
}

# Run app
shinyApp(ui = ui, server = server)
