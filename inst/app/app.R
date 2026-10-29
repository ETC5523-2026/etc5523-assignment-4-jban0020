library(shiny)
library(ggplot2)

# Load data included in the package

wtc <- backyardWTC::wtc_stopped

# User interface

ui <- fluidPage(
  
  tags$head(
    tags$style(HTML("
      body {
        background-color: #f7f9fc;
        font-family: Arial, sans-serif;
        color: #222222;
      }

      h2, h3 {
        color: #006DAE;
      }

      .well {
        background-color: white;
        border: 1px solid #dddddd;
        border-radius: 10px;
      }

      .app-intro {
        margin-bottom: 25px;
      }

      .app-note {
        background-color: white;
        padding: 15px;
        margin-top: 20px;
        border-radius: 8px;
        border-left: 4px solid #006DAE;
      }
    "))
  ),
  
  div(
    class = "app-intro",
    h2("2026 Backyard Ultra World Team Championships"),
    
    p(
      strong("Intended audience: "),
      "Backyard ultra spectators and performance analysts."
    ),
    
    p(
      strong("Question: "),
      "How does runner performance vary between nations ",
      "and competition classes?"
    )
  ),
  
  div(
    class = "app-note",
    
    h4("Understanding the data"),
    
    p(
      strong("Completed yards: "),
      "The number of race laps completed by each runner. ",
      "In backyard ultra running, each lap is called a yard."
    ),
    
    p(
      strong("Nation: "),
      "The country represented by the runner."
    ),
    
    p(
      strong("Competition class: "),
      "The category in which the runner competed."
    ),
    
    h4("How to use the dashboard"),
    
    p(
      "Choose whether to compare nations or competition classes. ",
      "Select specific nations, or leave the nation selection ",
      "empty to include everyone in the dataset."
    ),
    
    p(
      "Use the competition class checkboxes and minimum yard ",
      "filter to focus on particular runners. Switch between ",
      "mean and median yards to see how the comparison changes."
    ),
    
    p(
      "When comparing nations, adjust the number displayed ",
      "to focus on the highest-ranked groups. The summary ",
      "table still includes all groups matching your filters."
    )
  ),
  
  sidebarLayout(
    
    sidebarPanel(
      
      h3("Explore the results"),
      
      selectInput(
        inputId = "group_by",
        label = "Compare performance by",
        choices = c(
          "Nation" = "nation",
          "Competition class" = "class"
        ),
        selected = "nation"
      ),
      
      selectizeInput(
        inputId = "nations",
        label = "Select nations (leave blank for all)",
        choices = sort(unique(wtc$nation)),
        selected = character(0),
        multiple = TRUE
      ),
      
      checkboxGroupInput(
        inputId = "classes",
        label = "Competition classes",
        choices = sort(unique(wtc$class)),
        selected = sort(unique(wtc$class))
      ),
      
      numericInput(
        inputId = "min_yards",
        label = "Minimum completed yards",
        value = 0,
        min = 0,
        step = 1
      ),
      
      selectInput(
        inputId = "metric",
        label = "Performance measure",
        choices = c(
          "Median yards" = "median_yards",
          "Mean yards" = "mean_yards"
        ),
        selected = "median_yards"
      ),
      
      selectInput(
        inputId = "plot_type",
        label = "Chart view",
        choices = c(
          "Performance comparison" = "bars",
          "Runner distribution" = "distribution"
        ),
        selected = "bars"
      ),
      
      
      conditionalPanel(
        condition = "input.group_by == 'nation'",
        
        sliderInput(
          inputId = "top_n",
          label = "Number of nations displayed",
          min = 5,
          max = 25,
          value = 12
        )
      ),
      
      helpText(
        "Use the filters to explore performance among ",
        "stopped runners. The chart updates automatically."
      )
    ),
    
    mainPanel(
      
      h3("Performance comparison"),
      
      textOutput("summary_text"),
      
      plotOutput(
        outputId = "performance_plot",
        height = "500px"
      ),
      
      h3("Summary statistics"),
      
      tableOutput("summary_table"),
      
      div(
        class = "app-note",
        
        h4("How to interpret the results"),
        
        p(
          "Use the chart view selector to switch between ",
          "group summaries and individual runner distributions."
        ),
        
        p(
          "In the distribution chart, each dot represents ",
          "one stopped runner. The line inside each box ",
          "shows the median, while the box covers the middle ",
          "50% of performances. Wider boxes indicate more ",
          "variation between runners."
        ),
        
        p(
          "Each bar represents the selected average or median ",
          "number of completed yards for a nation or class. ",
          "Labels show the number of runners in each group."
        ),
        
        p(
          "Median yards describe the middle runner's performance, ",
          "while mean yards describe the arithmetic average. ",
          "Groups with fewer runners should be interpreted cautiously."
        ),
        
        p(
          "The chart displays the highest-ranked nations when ",
          "comparing countries. The table includes every group ",
          "matching the filters."
        )
      )
    )
  ),
  
  div(
    class = "app-note",
    
    strong("Data limitation: "),
    
    "This application uses a snapshot of runners recorded ",
    "as stopped after yard 124. It does not contain the ",
    "complete championship roster or official team standings."
  )
)

# Server

server <- function(input, output, session) {
  
  # Filter the runner data
  
  filtered_data <- reactive({
    
    validate(
      need(
        length(input$classes) > 0,
        "Please select at least one competition class."
      )
    )
    
    validate(
      need(
        length(input$min_yards) == 1 &&
          is.finite(input$min_yards) &&
          input$min_yards >= 0,
        "Please enter a valid non-negative minimum yard count."
      )
    )
    
    data <- wtc[
      wtc$class %in% input$classes,
      ,
      drop = FALSE
    ]
    
    if (length(input$nations) > 0) {
      data <- data[
        data$nation %in% input$nations,
        ,
        drop = FALSE
      ]
    }
    
    return(data)
  })
  
  # Summarise the filtered data
  
  summary_data <- reactive({
    
    backyardWTC::summarise_stopped_runners(
      data = filtered_data(),
      group = input$group_by,
      min_yards = input$min_yards
    )
  })
  
  # Display a short summary
  
  output$summary_text <- renderText({
    
    results <- summary_data()
    
    validate(
      need(
        nrow(results) > 0,
        paste(
          "No runners match your selection.",
          "Try selecting more nations or classes,",
          "or reducing the minimum completed yards."
        )
      )
    )
    
    group_label <- if (input$group_by == "nation") {
      "nations"
    } else {
      "competition classes"
    }
    
    metric_label <- if (input$metric == "median_yards") {
      "median"
    } else {
      "mean"
    }
    
    message <- paste0(
      sum(results$runners),
      " stopped runners across ",
      nrow(results),
      " ",
      group_label,
      " match your selection. ",
      "Groups are ranked by ",
      metric_label,
      " completed yards."
    )
    
    small_groups <- sum(results$runners < 5)
    
    if (small_groups > 0) {
      message <- paste0(
        message,
        " Caution: ",
        small_groups,
        " group(s) contain fewer than five runners. ",
        "Their summary statistics should be interpreted carefully."
      )
    }
    
    message
  })
  
  # Performance chart
  
  output$performance_plot <- renderPlot({
    
    results <- summary_data()
    
    validate(
      need(
        nrow(results) > 0,
        "No results to plot. Try including more nations or classes, or lowering the minimum completed yards."
      )
    )
    
    results <- results[
      order(
        -results[[input$metric]],
        results$group
      ),
      ,
      drop = FALSE
    ]
    
    if (input$group_by == "nation") {
      results <- head(results, input$top_n)
    }
    
    results$value <- results[[input$metric]]
    
    metric_label <- if (input$metric == "median_yards") {
      "Median completed yards"
    } else {
      "Mean completed yards"
    }
    
    if (input$plot_type == "distribution") {
      
      runner_data <- filtered_data()
      
      runner_data <- runner_data[
        runner_data$yards >= input$min_yards &
          runner_data[[input$group_by]] %in% results$group,
        ,
        drop = FALSE
      ]
      
      runner_data$display_group <- factor(
        runner_data[[input$group_by]],
        levels = rev(results$group)
      )
      
      return(
        ggplot(
          runner_data,
          aes(x = display_group, y = yards)
        ) +
          geom_boxplot(
            fill = "#006DAE",
            alpha = 0.3,
            outlier.shape = NA
          ) +
          geom_jitter(
            width = 0.12,
            alpha = 0.3,
            size = 1
          ) +
          coord_flip() +
          labs(
            title = "Distribution of runner performance",
            subtitle = "Each point represents one stopped runner",
            x = NULL,
            y = "Completed yards"
          ) +
          theme_minimal(base_size = 13) +
          theme(
            plot.title = element_text(face = "bold"),
            panel.grid.major.y = element_blank()
          )
      )
    }
    
    ggplot(
      results,
      aes(
        x = reorder(group, value),
        y = value
      )
    ) +
      geom_col(
        fill = "#006DAE",
        width = 0.7
      ) +
      geom_text(
        aes(label = paste0("n = ", runners)),
        hjust = -0.15,
        size = 3.2
      ) +
      coord_flip() +
      scale_y_continuous(
        expand = expansion(mult = c(0, 0.25))
      ) +
      labs(
        title = "Runner performance comparison",
        x = NULL,
        y = metric_label
      ) +
      theme_minimal(base_size = 13) +
      theme(
        plot.title = element_text(face = "bold"),
        panel.grid.major.y = element_blank()
      )
  })
  
  # Summary table
  
  output$summary_table <- renderTable({
    
    results <- summary_data()
    
    validate(
      need(
        nrow(results) > 0,
        "No summary available for these filters. Try broadening your selection."
      )
    )
    
    results <- results[
      order(
        -results[[input$metric]],
        results$group
      ),
      ,
      drop = FALSE
    ]
    
    data.frame(
      "Nation / Class" = results$group,
      "Runners" = results$runners,
      "Mean yards" = round(results$mean_yards, 1),
      "Median yards" = round(results$median_yards, 1),
      "Maximum yards" = results$max_yards,
      "Total yards" = results$total_yards,
      check.names = FALSE
    )
    
  }, striped = TRUE, spacing = "s")
}

# Launch application

shinyApp(ui = ui, server = server)
