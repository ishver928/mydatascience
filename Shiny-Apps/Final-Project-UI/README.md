# 💎 Shine Bright Like a Diamond - Shiny App UI

## Overview

This file contains the **User Interface (UI) component** of the "Shine Bright Like a Diamond" R Shiny application.

The purpose of this UI is to create an interactive and visually engaging dashboard where users can explore how different diamond characteristics influence pricing. The app uses the built-in `diamonds` dataset from the `ggplot2` package, which contains over 50,000 diamond observations.

The UI is designed with a diamond-inspired theme and organizes the analysis into multiple interactive sections, including visualizations, statistical analysis, price prediction, and project information.

---

# 📂 UI Components

The UI defines the layout, navigation, and interactive elements of the Shiny application.

## 💎 Introduction Tab

Provides users with an overview of the application and explains:

- The purpose of the app
- How to navigate through the different sections
- The diamond dataset features:
  - Carat
  - Cut
  - Color
  - Clarity
  - Depth
  - Table
  - Dimensions (x, y, z)

---

## 📊 Graphics Tab

Creates an interactive visualization section where users can explore relationships between diamond features and price.

Features include:

- Dropdown menu to select predictor variables:
  - Carat
  - Depth
  - Table
  - X, Y, Z dimensions

- Interactive graphs showing:
  - Relationships between diamond characteristics and price
  - Price differences across diamond cuts
  - Carat, price, and clarity relationships

- Explanation buttons that provide additional interpretation of each visualization

---

## 📈 Statistics Tab

Creates a section dedicated to statistical analysis.

Includes:

- Summary statistics tables
- Linear regression analysis
- Confidence interval analysis

This section allows users to understand how statistical methods can explain patterns in diamond pricing.

---

## 🗃 Full Data Tab

Displays the complete diamonds dataset using an interactive data table.

Users can explore the original observations and variables used in the analysis.

---

## 🤖 Logistic Regression / Prediction Tab

Creates an interactive prediction interface.

Users can input:

- Diamond cut
- Color
- Clarity
- Carat
- Depth
- Dimensions

The interface is designed to allow users to estimate diamond prices based on selected characteristics.

---

## 💡 Conclusion Tab

Summarizes major findings from the analysis:

- Carat has a strong relationship with price
- Diamond quality factors such as cut, color, and clarity affect value
- Multiple variables influence pricing decisions

---

## 👤 Sources & About Section

Includes:

- Links to resources used
- Author information
- Background information about the developer

---

# 🎨 Design Features

The UI uses:

- **bslib** for custom Bootstrap styling
- Custom diamond-inspired colors
- Google Fonts:
  - Tektur
  - Michroma

The theme was designed to create a clean, modern, and interactive user experience.

---

# Technologies Used

- R
- Shiny
- bslib
- tidyverse
- ggplot2
- shinyWidgets

---

# Relationship to Server Code

This file represents the **front-end of the Shiny application**.

The UI defines:
- What users see
- Navigation tabs
- Input controls
- Output locations

The server file connects these elements by:
- Creating plots
- Generating tables
- Running statistical models
- Producing predictions

Together, the UI and server components create the complete Shiny application.
