library(dash)
library(dashBootstrapComponents)
library(dashCoreComponents)
library(ggplot2)
library(tidyverse)
library(here)
library(plotly)

# Read in the gapminder data
gap <- read_csv(here("data", "gapminder.csv"))
# Create dictionary for stat labels
labels <- list(
    "life_expectancy" = "Life Expectancy",
    "pop_density" = "Population Density",
    "child_mortality" = "Child Mortality"
)
# Options
metrics <- list(
    list("label" = "Life Expectancy", "value" = "life_expectancy"),
    list("label" = "Child Mortality", "value" = "child_mortality"),
    list("label" = "Population Density", "value" = "pop_density")
)

app <- Dash$new(external_stylesheets = dbcThemes$BOOTSTRAP)

app$layout(
    dbcContainer(
        list(
            dccDropdown(
                id='col-select',
                options = metrics, 
                value='life_expectancy'),
            dccGraph(id='plot-area')
        )
    )
)

app$callback(
    output('plot-area', 'figure'),
    list(input('col-select', 'value')),
    function(ycol) {
        p <- ggplot(gap, aes(x = income_group,
                y = !!sym(ycol),
                color = income_group)) +
            geom_boxplot() +
            labs(title = paste0(labels[[ycol]], " group by Income Group for year 2010"),
                 x = "Income Group", 
                 y = labels[[ycol]], 
                 colour = "Income Group") + 
            ggthemes::scale_color_tableau()
            
        ggplotly(p)
    }
)

app$run_server(host = '0.0.0.0')
