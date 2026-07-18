# 📂 app.R

The `app.R` file is the main application file that contains both the **front-end user interface (UI)** and the **back-end server logic** of the Shiny application.

## User Interface (UI)
The UI section creates the layout and interactive components of the app, including:

- **Introduction Tab**
  - Explains the purpose of the app
  - Provides a glossary of diamond variables
  - Introduces the dataset

- **Graphics Tab**
  - Allows users to select different predictors (carat, depth, table, x, y, z)
  - Displays interactive visualizations showing relationships between diamond features and price
  - Includes explanations of graphs through interactive buttons

- **Statistics Tab**
  - Displays:
    - Summary statistics by diamond cut
    - Confidence intervals
    - Hypothesis tests comparing diamond cuts
    - Linear regression analysis

- **Predict Tab**
  - Allows users to input diamond characteristics
  - Uses a multiple linear regression model to estimate the diamond's price

- **Full Data Tab**
  - Displays the complete diamonds dataset

- **Conclusion Tab**
  - Summarizes key findings from the analysis

- **Sources/About Tab**
  - Provides project sources and author information

---

## Server Logic
The server section controls how the app processes user input and generates outputs.

Main features include:

### 📊 Data Visualization
- Creates smooth trend plots showing how selected variables affect diamond price
- Generates boxplots comparing prices across cut categories
- Creates scatterplots showing relationships between carat, price, and clarity

### 📈 Statistical Analysis
- Calculates summary statistics
- Creates 95% confidence intervals for average diamond price
- Performs hypothesis testing between Premium and Ideal cut diamonds
- Builds linear regression models analyzing the relationship between carat and price

### 💎 Price Prediction Model
A multiple linear regression model:

`price ~ carat + cut + color + clarity + depth + table + x + y + z`

is used to predict diamond prices based on user-provided diamond characteristics.

---

# Technologies Used

- **R**
- **R Shiny**
- **tidyverse**
- **ggplot2**
- **bslib**
- **broom**

---

# How to Run

1. Install required packages:

```r
install.packages(c("tidyverse", "shiny", "bslib", "broom", "ggplot2"))
