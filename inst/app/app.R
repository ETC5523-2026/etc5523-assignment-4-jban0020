library(shiny)
library(ggplot2)

# Use the dataset installed with the backyardWTC package
wtc <- backyardWTC::wtc_stopped

# Colours and styling shared by both charts
monash_blue <- "#006DAE"

chart_theme <- theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 14, colour = "#17324D"),
    plot.subtitle = element_text(colour = "#5C6B7A", margin = margin(b = 12)),
    axis.title.x = element_text(colour = "#43566A", margin = margin(t = 10)),
    axis.text = element_text(colour = "#35485B"),
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    plot.margin = margin(12, 16, 12, 8)
  )

# User interface
ui <- fluidPage(
  tags$head(
    tags$style(HTML("
      body {
        background: #F4F7FB;
        color: #253647;
        font-family: 'Helvetica Neue', Arial, sans-serif;
        line-height: 1.55;
      }

      .container-fluid {
        max-width: 1380px;
        padding-left: 24px;
        padding-right: 24px;
      }

      .app-hero {
        background: linear-gradient(110deg, #00528A, #006DAE);
        color: white;
        border-radius: 14px;
        padding: 27px 32px;
        margin: 24px 0 22px;
        box-shadow: 0 5px 16px rgba(0, 65, 114, 0.12);
      }

      .hero-kicker {
        display: block;
        font-size: 11px;
        font-weight: 700;
        letter-spacing: 1.7px;
        text-transform: uppercase;
        color: #D5ECFB;
        margin-bottom: 8px;
      }

      .app-hero h1 {
        font-size: 29px;
        font-weight: 700;
        line-height: 1.2;
        color: white;
        margin: 0 0 14px;
      }

      .app-hero p {
        color: #F2F8FD;
        margin: 4px 0;
        font-size: 14px;
      }

      .guide-grid {
        display: grid;
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 16px;
        margin-bottom: 24px;
      }

      .guide-card, .output-card, .app-note {
        background: white;
        border: 1px solid #E1E8EF;
        border-radius: 12px;
        box-shadow: 0 2px 9px rgba(23, 50, 77, 0.04);
      }

      .guide-card {
        padding: 19px 22px;
      }

      .guide-card h4, .app-note h4 {
        font-size: 16px;
        font-weight: 700;
        color: #005E9C;
        margin: 0 0 12px;
      }

      .guide-card p, .app-note p {
        font-size: 13px;
        margin-bottom: 8px;
      }

      .guide-card p:last-child, .app-note p:last-child {
        margin-bottom: 0;
      }

      .well {
        background: white;
        border: 1px solid #E1E8EF;
        border-radius: 12px;
        padding: 21px;
        box-shadow: 0 2px 9px rgba(23, 50, 77, 0.04);
      }

      .well h3 {
        font-size: 18px;
        font-weight: 700;
        color: #005E9C;
        margin: 0 0 20px;
      }

      .control-label {
        font-size: 13px;
        font-weight: 600;
        color: #253647;
      }

      .form-control {
        border-color: #CBD7E2;
        border-radius: 6px;
      }

      .form-control:focus {
        border-color: #006DAE;
        box-shadow: 0 0 0 2px rgba(0, 109, 174, 0.12);
      }

      .well .form-group {
        margin-bottom: 20px;
      }

      .sidebar-tip {
        background: #EEF6FC;
        border-left: 3px solid #006DAE;
        border-radius: 5px;
        padding: 12px;
        font-size: 12px;
        color: #40556B;
      }

      .output-card {
        padding: 22px 25px;
        margin-bottom: 18px;
      }

      .output-card h3 {
        font-size: 19px;
        font-weight: 700;
        color: #005E9C;
        margin: 0 0 15px;
      }

      .summary-banner {
        background: #EEF6FC;
        border-radius: 8px;
        border-left: 4px solid #006DAE;
        padding: 13px 16px;
        margin-bottom: 15px;
        color: #23455E;
        font-size: 13px;
      }

      .summary-banner .shiny-text-output {
        white-space: normal;
      }

      .table-scroll {
        overflow-x: auto;
      }

      .table-scroll table {
        width: 100%;
        font-size: 12px;
      }

      .table-scroll th {
        background: #EEF4F9;
        color: #24425B;
        white-space: nowrap;
      }

      .table-scroll td, .table-scroll th {
        padding: 9px 10px !important;
        border-color: #E3EAF0 !important;
      }

      .app-note {
        padding: 19px 22px;
        margin-bottom: 20px;
        border-left: 4px solid #006DAE;
      }

      .data-limitation {
        font-size: 12px;
        color: #52677B;
      }

      .shiny-output-error-validation {
        color: #8B4518;
        font-size: 13px;
        padding: 10px 0;
      }

      @media (max-width: 767px) {
        .container-fluid {
          padding-left: 14px;
          padding-right: 14px;
        }

        .app-hero {
          padding: 22px;
          margin-top: 14px;
        }

        .app-hero h1 {
          font-size: 24px;
        }

        .guide-grid {
          grid-template-columns: 1fr;
        }

        .output-card {
          padding: 17px;
        }
      }
    "))
  ),
  
  div(
    class = "app-hero",
    span(class = "hero-kicker", "2026 championship | Stopped-runner data"),
    h1("Backyard Ultra World Team Championships"),
    p(
      strong("Intended audience: "),
      "Backyard ultra spectators and performance analysts."
    ),
    p(
      strong("Question: "),
      "How does runner performance vary between nations and competition classes?"
    )
  ),
  
  div(
    class = "guide-grid",
    div(
      class = "guide-card",
      h4("Understanding the fields"),
      p(
        strong("Completed yards: "),
        "The number of race laps completed by a runner. Each lap is called a yard."
      ),
      p(strong("Nation: "), "The country represented by the runner."),
      p(
        strong("Competition class: "),
        "The recorded runner category (Class A, Class AA, Class AAA or Super Six)."
      ),
      p(
        strong("Runners: "),
        "The number of stopped runners included in each group."
      )
    ),
    div(
      class = "guide-card",
      h4("How to explore"),
      p("Choose whether to compare nations or competition classes."),
      p(
        "Select nations to focus on particular countries, or leave the nation ",
        "selection blank to include all nations. Choose one or more classes."
      ),
      p(
        "Use minimum yards to set a performance threshold and mean or median ",
        "to rank the groups. Switch chart views to compare summaries with ",
        "individual-runner distributions."
      ),
      p(
        "When comparing nations, the top-N control limits the chart only. ",
        "The table continues to show every group matching the filters."
      )
    )
  ),
  
  sidebarLayout(
    sidebarPanel(
      h3("Explore the results"),
      
      selectInput(
        inputId = "group_by",
        label = "Compare performance by",
        choices = c("Nation" = "nation", "Competition class" = "class"),
        selected = "nation"
      ),
      
      selectizeInput(
        inputId = "nations",
        label = "Select nations (blank means all)",
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
        choices = c("Median yards" = "median_yards", "Mean yards" = "mean_yards"),
        selected = "median_yards"
      ),
      
      selectInput(
        inputId = "plot_type",
        label = "Chart view",
        choices = c("Performance comparison" = "bars", "Runner distribution" = "distribution"),
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
      
      div(
        class = "sidebar-tip",
        "All charts and statistics update automatically when you change a control."
      )
    ),
    
    mainPanel(
      div(
        class = "output-card",
        h3("Explore performance"),
        div(class = "summary-banner", textOutput("summary_text")),
        plotOutput(outputId = "performance_plot", height = "500px")
      ),
      
      div(
        class = "output-card",
        h3("Summary statistics"),
        div(class = "table-scroll", tableOutput("summary_table"))
      ),
      
      div(
        class = "app-note",
        h4("How to interpret the results"),
        p(
          strong("Bar chart: "),
          "Each bar shows the chosen mean or median completed yards for a group. ",
          "The n label gives the number of runners in that group."
        ),
        p(
          strong("Distribution chart: "),
          "Each dot represents one stopped runner. The middle line of each box ",
          "is the median, and the box covers the middle 50% of completed-yard values."
        ),
        p(
          strong("Mean versus median: "),
          "The mean is the arithmetic average; the median is the middle value. ",
          "Differences between them can suggest uneven performance distributions."
        ),
        p(
          "Compare both typical performance and variation, and interpret ",
          "groups with few runners cautiously. The table includes all selected ",
          "groups even when the nation chart is restricted to the top N."
        )
      )
    )
  ),
  
  div(
    class = "app-note data-limitation",
    strong("Data limitation: "),
    "This is a snapshot of runners recorded as stopped after yard 124. ",
    "It does not contain the complete championship roster or official team standings. ",
    "Comparisons describe the stopped runners in this snapshot, not the final team rankings."
  )
)

# Server
server <- function(input, output, session) {
  
  # Filter classes and nations before applying the yard threshold
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
    
    data <- wtc[wtc$class %in% input$classes, , drop = FALSE]
    
    if (length(input$nations) > 0) {
      data <- data[data$nation %in% input$nations, , drop = FALSE]
    }
    
    data
  })
  
  # Reuse the public summary function supplied by the package
  summary_data <- reactive({
    backyardWTC::summarise_stopped_runners(
      data = filtered_data(),
      group = input$group_by,
      min_yards = input$min_yards
    )
  })
  
  # Describe the active filters and flag small groups
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
    
    metric_label <- if (input$metric == "median_yards") "median" else "mean"
    
    message <- paste0(
      sum(results$runners),
      " stopped runners across ",
      nrow(results),
      " ", group_label,
      " match your selection. Groups are ranked by ",
      metric_label, " completed yards."
    )
    
    small_groups <- sum(results$runners < 5)
    
    if (small_groups > 0) {
      message <- paste0(
        message, " Caution: ", small_groups,
        " group(s) contain fewer than five runners. ",
        "Their summary statistics should be interpreted carefully."
      )
    }
    
    message
  })
  
  # Compare group summaries or individual-runner distributions
  output$performance_plot <- renderPlot({
    results <- summary_data()
    
    validate(
      need(
        nrow(results) > 0,
        paste(
          "No results to plot. Try including more nations or classes,",
          "or lowering the minimum completed yards."
        )
      )
    )
    
    results <- results[
      order(-results[[input$metric]], results$group),
      , drop = FALSE
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
        !is.na(runner_data$yards) &
          runner_data$yards >= input$min_yards &
          runner_data[[input$group_by]] %in% results$group,
        , drop = FALSE
      ]
      
      runner_data$display_group <- factor(
        runner_data[[input$group_by]],
        levels = rev(results$group)
      )
      
      return(
        ggplot(runner_data, aes(x = display_group, y = yards)) +
          geom_boxplot(fill = "#A9D5F0", colour = "#006DAE", outlier.shape = NA) +
          geom_jitter(width = 0.12, alpha = 0.35, size = 1.2, colour = "#244F70") +
          coord_flip() +
          labs(
            title = "Distribution of runner performance",
            subtitle = "Each point represents one stopped runner",
            x = NULL,
            y = "Completed yards"
          ) +
          chart_theme
      )
    }
    
    ggplot(results, aes(x = reorder(group, value), y = value)) +
      geom_col(fill = monash_blue, width = 0.7) +
      geom_text(
        aes(label = paste0("n = ", runners)),
        hjust = -0.15,
        colour = "#43566A",
        size = 3.2
      ) +
      coord_flip() +
      scale_y_continuous(expand = expansion(mult = c(0, 0.25))) +
      labs(
        title = "Runner performance comparison",
        subtitle = paste("Groups ranked by", tolower(metric_label)),
        x = NULL,
        y = metric_label
      ) +
      chart_theme
  })
  
  # Display every matching group, including those outside the top-N chart
  output$summary_table <- renderTable({
    results <- summary_data()
    
    validate(
      need(
        nrow(results) > 0,
        "No summary available for these filters. Try broadening your selection."
      )
    )
    
    results <- results[
      order(-results[[input$metric]], results$group),
      , drop = FALSE
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