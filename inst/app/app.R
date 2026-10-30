library(shiny)
library(plotly)

# Use the dataset installed with the backyardWTC package
wtc <- backyardWTC::wtc_stopped

# Chart colours
monash_blue <- "#006DAE"
light_blue <- "#BBDFF4"

# Shared Plotly layout for clean, readable interactive charts
plot_style <- list(
  paper_bgcolor = "#FFFFFF",
  plot_bgcolor = "#FFFFFF",
  font = list(family = "Arial, sans-serif", color = "#35485B", size = 12),
  margin = list(l = 110, r = 160, t = 80, b = 65),
  showlegend = FALSE
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

      /* Two columns of competition-class checkboxes */
      .class-grid .shiny-options-group {
        display: grid;
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 9px;
      }

      .class-grid .checkbox {
        margin: 0;
        min-width: 0;
      }

      .class-grid .checkbox label {
        display: flex;
        align-items: center;
        gap: 8px;
        width: 100%;
        padding: 9px 10px;
        background: #F5F9FC;
        border: 1px solid #DCE6EF;
        border-radius: 7px;
        font-size: 12px;
        font-weight: 500;
      }

      .class-grid .checkbox input[type='checkbox'] {
        position: static;
        margin: 0;
        flex-shrink: 0;
        accent-color: #006DAE;
      }

      /* Button-style radio selectors, with native keyboard accessibility */
      .choice-buttons .shiny-options-group {
        display: flex;
        gap: 5px;
        padding: 5px;
        background: #EEF4F9;
        border-radius: 9px;
      }

      .choice-buttons .radio-inline {
        display: flex;
        flex: 1 1 0;
        justify-content: center;
        align-items: center;
        margin: 0;
        padding: 9px 7px;
        min-width: 0;
        min-height: 42px;
        border-radius: 7px;
        text-align: center;
        font-size: 12px;
        font-weight: 600;
        line-height: 1.3;
        cursor: pointer;
        color: #36546E;
        transition: background 0.15s ease, color 0.15s ease;
      }

      .choice-buttons .radio-inline input[type='radio'] {
        position: absolute;
        width: 1px;
        height: 1px;
        margin: 0;
        opacity: 0;
      }

      .choice-buttons .radio-inline:has(input:checked) {
        background: #006DAE;
        color: #FFFFFF;
        box-shadow: 0 2px 5px rgba(0, 65, 114, 0.15);
      }

      .choice-buttons .radio-inline:focus-within {
        outline: 2px solid #1B76B5;
        outline-offset: 2px;
      }

      .yard-stepper {
        display: flex;
        flex-wrap: wrap;
        gap: 8px;
        margin: -6px 0 16px;
      }

      .yard-stepper .btn {
        flex: 1;
        border: 1px solid #C7D7E5;
        border-radius: 7px;
        background: #FFFFFF;
        color: #005E9C;
        font-size: 12px;
        font-weight: 600;
        padding: 8px 6px;
      }

      .yard-stepper .btn:hover, .yard-stepper .btn:focus {
        background: #E6F3FC;
      }

      .progress-metrics {
        display: grid;
        grid-template-columns: repeat(3, minmax(0, 1fr));
        gap: 12px;
        margin: 6px 0 19px;
      }

      .progress-stat {
        border: 1px solid #DFE9F2;
        background: #F7FAFD;
        border-radius: 9px;
        padding: 13px 15px;
      }

      .progress-stat span {
        display: block;
        color: #576E82;
        font-size: 11px;
        line-height: 1.4;
        margin-bottom: 6px;
      }

      .progress-stat strong {
        display: block;
        color: #005E9C;
        font-size: 24px;
        line-height: 1.2;
      }

      .cohort-progress-label {
        display: flex;
        justify-content: space-between;
        gap: 10px;
        font-size: 12px;
        font-weight: 600;
        color: #3B566C;
        margin-bottom: 7px;
      }

      .cohort-progress-track {
        height: 16px;
        background: #E7F0F7;
        border-radius: 999px;
        overflow: hidden;
        margin-bottom: 19px;
      }

      .cohort-progress-fill {
        height: 100%;
        background: #006DAE;
        border-radius: 999px;
        transition: width 0.15s ease;
      }

      .progress-view {
        max-width: 520px;
        margin: 0 0 6px;
      }

      .progress-explainer {
        color: #607589;
        font-size: 12px;
        margin: 4px 0 18px;
      }

      .lap-stop-heading {
        margin-top: 12px;
        margin-bottom: 5px;
        color: #005E9C;
        font-weight: 700;
        font-size: 15px;
      }

      .yard-hint, .table-hint {
        color: #607589;
        font-size: 12px;
        margin: -12px 0 16px;
      }

      .table-hint {
        margin: 0 0 12px;
      }

      .table-controls {
        max-width: 620px;
        margin-bottom: 14px;
      }

      .table-controls .form-group {
        margin-bottom: 12px;
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

        .guide-grid, .progress-metrics {
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
        strong("Runners left: "),
        "The number of stopped runners remaining after filtering. ",
        "It does not mean runners still competing."
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
        "Move the minimum-yards slider one yard at a time, or use its play ",
        "button to watch the selected stopped-runner cohort progress. ",
        "If nobody stopped at a particular yard, the number remaining stays unchanged."
      ),
      p(
        "Use the progression chart to see when runners stopped; click a yard ",
        "to inspect their names and stopping reasons. Switch the performance ",
        "chart between summaries and runner distributions."
      ),
      p(
        "The statistics table shows the top five groups by default. ",
        "You can choose particular groups or show all."
      )
    )
  ),
  
  sidebarLayout(
    sidebarPanel(
      h3("Explore the results"),
      
      div(
        class = "choice-buttons",
        radioButtons(
          inputId = "group_by",
          label = "Compare performance by",
          choices = c("Nation" = "nation", "Competition class" = "class"),
          selected = "nation",
          inline = TRUE
        )
      ),
      
      selectizeInput(
        inputId = "nations",
        label = "Select nations (blank means all)",
        choices = sort(unique(wtc$nation)),
        selected = character(0),
        multiple = TRUE
      ),
      
      div(
        class = "class-grid",
        checkboxGroupInput(
          inputId = "classes",
          label = "Competition classes",
          choices = sort(unique(wtc$class)),
          selected = sort(unique(wtc$class))
        )
      ),
      
      sliderInput(
        inputId = "min_yards",
        label = "Minimum completed yards",
        min = 0,
        max = max(1, max(wtc$yards, na.rm = TRUE)),
        value = 0,
        step = 1,
        sep = "",
        ticks = FALSE,
        animate = animationOptions(interval = 950, loop = FALSE)
      ),
      div(class = "yard-hint", textOutput("yard_limit", inline = TRUE)),
      div(
        class = "yard-stepper",
        actionButton("yard_back", "← Previous yard"),
        actionButton("yard_forward", "Next yard →")
      ),
      
      div(
        class = "choice-buttons",
        radioButtons(
          inputId = "metric",
          label = "Performance measure",
          choices = c("Median yards" = "median_yards", "Mean yards" = "mean_yards"),
          selected = "median_yards",
          inline = TRUE
        )
      ),
      
      div(
        class = "choice-buttons",
        radioButtons(
          inputId = "plot_type",
          label = "Chart view",
          choices = c("Performance comparison" = "bars", "Runner distribution" = "distribution"),
          selected = "bars",
          inline = TRUE
        )
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
        h3("Lap-by-lap progression"),
        div(
          class = "summary-banner",
          "Follow the selected stopped runners as the minimum completed-yard threshold increases. ",
          "This is not a live count of all runners still racing."
        ),
        uiOutput("progress_metrics"),
        uiOutput("cohort_progress"),
        div(
          class = "progress-view choice-buttons",
          radioButtons(
            inputId = "progress_view",
            label = "Progression chart",
            choices = c(
              "Runners reaching each yard" = "reaching",
              "Stopped at each yard" = "stopped"
            ),
            selected = "reaching",
            inline = TRUE
          )
        ),
        plotlyOutput("progression_plot", height = "365px"),
        p(
          class = "progress-explainer",
          "Move or play the yard slider, or click a point/bar in the chart. ",
          "A runner with exactly X completed yards is counted as reaching X, ",
          "then drops out when the threshold moves to X + 1."
        ),
        div(class = "lap-stop-heading", textOutput("lap_stop_title", inline = TRUE)),
        div(class = "table-hint", textOutput("lap_stop_note", inline = TRUE)),
        checkboxInput(
          "all_lap_stops",
          "Show all runners stopped at this yard (rather than the first 8)",
          value = FALSE
        ),
        div(class = "table-scroll", tableOutput("lap_stop_table"))
      ),
      
      div(
        class = "output-card",
        h3("Explore performance"),
        div(class = "summary-banner", textOutput("summary_text")),
        plotlyOutput(outputId = "performance_plot", height = "570px")
      ),
      
      div(
        class = "output-card",
        h3("Summary statistics"),
        div(
          class = "table-controls",
          div(
            class = "choice-buttons",
            radioButtons(
              inputId = "table_mode",
              label = "Rows to display",
              choices = c("Top 5" = "top5", "Choose groups" = "custom", "All" = "all"),
              selected = "top5",
              inline = TRUE
            )
          ),
          conditionalPanel(
            condition = "input.table_mode == 'custom'",
            selectizeInput(
              inputId = "table_groups",
              label = "Groups to include",
              choices = NULL,
              selected = character(0),
              multiple = TRUE
            )
          )
        ),
        div(class = "table-hint", textOutput("table_display_note", inline = TRUE)),
        div(class = "table-scroll", tableOutput("summary_table"))
      ),
      
      div(
        class = "app-note",
        h4("How to interpret the results"),
        p(
          strong("Bar chart: "),
          "Each bar shows the chosen mean or median completed yards for a group. ",
          "The 'Runners left' label counts stopped runners still included after filtering."
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
          "groups with few runners cautiously. Use the table controls to ",
          "choose which groups to show independently of the chart's top-N limit."
        )
      )
    )
  ),
  
  div(
    class = "app-note data-limitation",
    strong("Data limitation: "),
    "This is a snapshot of runners recorded as stopped after yard 124. ",
    "It does not contain the complete championship roster or official team standings. ",
    "The progression view reconstructs when this recorded stopped-runner cohort ",
    "reached each completed-yard threshold; it is not a live survival curve ",
    "for the full starting field or a final team ranking."
  )
)

# Server
server <- function(input, output, session) {
  
  # Keep yard slider maximum in step with selected nations and classes.
  # A blank nation selection means all nations.
  available_yards <- reactive({
    data <- wtc[wtc$class %in% input$classes, , drop = FALSE]
    
    if (length(input$nations) > 0) {
      data <- data[data$nation %in% input$nations, , drop = FALSE]
    }
    
    values <- data$yards[is.finite(data$yards)]
    if (length(values) == 0) return(0)
    max(values)
  })
  
  observeEvent(available_yards(), {
    limit <- available_yards()
    # A slider needs a positive range even if there are no matching runners.
    slider_max <- max(1, ceiling(limit))
    current <- input$min_yards
    if (is.null(current) || !is.finite(current)) current <- 0
    
    updateSliderInput(
      session, "min_yards",
      min = 0,
      max = slider_max,
      value = min(current, slider_max),
      step = 1
    )
  })
  
  # A consistent one-yard increment is always available, even on touchpads.
  observeEvent(input$yard_back, {
    current <- if (is.null(input$min_yards)) 0 else input$min_yards
    updateSliderInput(session, "min_yards", value = max(0, current - 1))
  })
  
  observeEvent(input$yard_forward, {
    current <- if (is.null(input$min_yards)) 0 else input$min_yards
    updateSliderInput(
      session, "min_yards",
      value = min(available_yards(), current + 1)
    )
  })
  
  output$yard_limit <- renderText({
    paste0(
      "Highest available: ", format(available_yards(), trim = TRUE),
      " yards for the selected nations and classes. Steps are always 1 yard."
    )
  })
  
  # Filter classes and nations before applying the yard threshold
  filtered_data <- reactive({
    validate(
      need(length(input$classes) > 0, "Please select at least one competition class."),
      need(length(input$min_yards) == 1 &&
             is.finite(input$min_yards) && input$min_yards >= 0,
           "Please choose a valid non-negative minimum yard count.")
    )
    
    data <- wtc[wtc$class %in% input$classes, , drop = FALSE]
    
    if (length(input$nations) > 0) {
      data <- data[data$nation %in% input$nations, , drop = FALSE]
    }
    
    data
  })
  
  # Lap-by-lap progression is based on the selected STOPPED runners only.
  # A runner with Y completed yards contributes to every threshold 0,...,Y.
  # Moving from threshold Y to Y+1 removes anyone recorded as stopping at Y.
  cohort <- reactive({
    data <- filtered_data()
    data[is.finite(data$yards) & data$yards >= 0, , drop = FALSE]
  })
  
  lap_progress <- reactive({
    data <- cohort()
    max_yard <- if (nrow(data) == 0) 0L else as.integer(max(data$yards))
    yards <- seq.int(0L, max_yard, by = 1L)
    
    # Every integer yard is represented, including yards with zero departures.
    stops <- tabulate(as.integer(data$yards) + 1L, nbins = length(yards))
    reaching <- rev(cumsum(rev(stops)))
    share <- if (nrow(data) == 0) rep(0, length(yards)) else {
      100 * reaching / nrow(data)
    }
    
    data.frame(
      yard = yards,
      reaching = reaching,
      stops = stops,
      share = share
    )
  })
  
  current_lap <- reactive({
    progress <- lap_progress()
    selected_yard <- as.integer(input$min_yards)
    if (length(selected_yard) != 1L || is.na(selected_yard)) {
      selected_yard <- 0L
    }
    # Avoid a transient out-of-range value while Shiny updates slider limits.
    selected_yard <- max(0L, min(selected_yard, max(progress$yard)))
    progress[progress$yard == selected_yard, , drop = FALSE]
  })
  
  # Summary cards use the full selected cohort, not the top-N chart restriction.
  output$progress_metrics <- renderUI({
    total <- nrow(cohort())
    current <- current_lap()
    
    stat <- function(label, number) {
      div(
        class = "progress-stat",
        span(label),
        tags$strong(format(number, big.mark = ",", trim = TRUE))
      )
    }
    
    div(
      class = "progress-metrics",
      stat("Stopped runners in selected cohort", total),
      stat(paste0("Reached at least yard ", current$yard), current$reaching),
      stat(paste0("Stopped with exactly ", current$yard, " yards"), current$stops)
    )
  })
  
  output$cohort_progress <- renderUI({
    current <- current_lap()
    percentage <- round(current$share, 1)
    div(
      div(
        class = "cohort-progress-label",
        span("Share of selected stopped runners reaching this yard"),
        span(sprintf("%.1f%%", percentage))
      ),
      div(
        class = "cohort-progress-track",
        role = "progressbar",
        `aria-label` = "Share reaching selected yard",
        `aria-valuemin` = "0",
        `aria-valuemax` = "100",
        `aria-valuenow` = sprintf("%.1f", percentage),
        div(
          class = "cohort-progress-fill",
          style = paste0("width: ", sprintf("%.1f", percentage), "%")
        )
      )
    )
  })
  
  output$progression_plot <- renderPlotly({
    progress <- lap_progress()
    validate(need(
      nrow(cohort()) > 0,
      "No runners match these nations and classes. Broaden your selection."
    ))
    
    progress$hover_label <- paste0(
      "<b>Completed yard ", progress$yard, "</b>",
      "<br>Reached at least this yard: ", progress$reaching,
      "<br>Stopped with this many yards: ", progress$stops,
      "<br>Share reaching this yard: ", sprintf("%.1f%%", progress$share)
    )
    
    if (identical(input$progress_view, "stopped")) {
      p <- plotly::plot_ly(
        data = progress, source = "lap_progression",
        x = ~yard, y = ~stops,
        type = "bar",
        marker = list(color = monash_blue),
        hovertext = ~hover_label, hoverinfo = "text", showlegend = FALSE
      )
      y_title <- "Runners stopped at this yard"
      chart_title <- "Recorded stops by completed yard"
    } else {
      p <- plotly::plot_ly(
        data = progress, source = "lap_progression",
        x = ~yard, y = ~reaching,
        type = "scatter", mode = "lines+markers",
        line = list(color = monash_blue, width = 2.5, shape = "hv"),
        marker = list(color = monash_blue, size = 5),
        hovertext = ~hover_label, hoverinfo = "text", showlegend = FALSE
      )
      y_title <- "Selected stopped runners reaching the yard"
      chart_title <- "How the recorded stopped-runner cohort progresses"
    }
    
    selected_yard <- current_lap()$yard
    p <- plotly::layout(
      p,
      title = list(text = chart_title, font = list(size = 15)),
      xaxis = list(
        title = "Completed yards", dtick = 10,
        range = c(-0.5, max(1, max(progress$yard)) + 0.5),
        zeroline = FALSE, gridcolor = "#EAF0F5"
      ),
      yaxis = list(
        title = y_title, rangemode = "tozero", zeroline = FALSE,
        gridcolor = "#EAF0F5"
      ),
      shapes = list(list(
        type = "line", x0 = selected_yard, x1 = selected_yard,
        y0 = 0, y1 = 1, yref = "paper",
        line = list(color = "#ED8A32", width = 2, dash = "dash")
      )),
      paper_bgcolor = plot_style$paper_bgcolor,
      plot_bgcolor = plot_style$plot_bgcolor,
      font = plot_style$font,
      margin = list(l = 82, r = 25, t = 60, b = 68),
      showlegend = FALSE
    )
    
    plotly::config(p, displaylogo = FALSE, responsive = TRUE)
  })
  
  # Clicking a point/bar selects that completed-yard threshold.
  observeEvent(plotly::event_data("plotly_click", source = "lap_progression"), {
    point <- plotly::event_data("plotly_click", source = "lap_progression")
    if (is.null(point) || is.null(point$x) || length(point$x) < 1) return()
    yard <- suppressWarnings(as.integer(round(as.numeric(point$x[[1]]))))
    if (length(yard) != 1 || is.na(yard)) return()
    updateSliderInput(
      session, "min_yards",
      value = max(0L, min(yard, available_yards()))
    )
  })
  
  stopped_at_lap <- reactive({
    data <- cohort()
    yard <- current_lap()$yard
    data <- data[data$yards == yard, , drop = FALSE]
    data[order(data$nation, data$runner), , drop = FALSE]
  })
  
  output$lap_stop_title <- renderText({
    paste0("Who stopped with ", current_lap()$yard, " completed yards?")
  })
  
  output$lap_stop_note <- renderText({
    count <- nrow(stopped_at_lap())
    if (count == 0) {
      return("No runners in the selected stopped-runner cohort are recorded as stopping at this yard.")
    }
    display <- if (isTRUE(input$all_lap_stops)) count else min(count, 8)
    paste0(
      "Showing ", display, " of ", count, " runners who stopped with exactly ",
      current_lap()$yard, " completed yards."
    )
  })
  
  output$lap_stop_table <- renderTable({
    data <- stopped_at_lap()
    if (!isTRUE(input$all_lap_stops)) data <- head(data, 8)
    if (nrow(data) == 0) return(NULL)
    
    data.frame(
      "Runner" = data$runner,
      "Nation" = data$nation,
      "Class" = data$class,
      "Recorded stopping reason" = data$reason,
      check.names = FALSE
    )
  }, striped = TRUE, spacing = "s")
  
  # Continue using the package's original summarising function
  summary_data <- reactive({
    req(input$group_by)
    backyardWTC::summarise_stopped_runners(
      data = filtered_data(),
      group = input$group_by,
      min_yards = input$min_yards
    )
  })
  
  ranked_results <- reactive({
    req(input$metric)
    results <- summary_data()
    results[order(-results[[input$metric]], results$group), , drop = FALSE]
  })
  
  # Populate the optional table picker with the groups under the current filters.
  observeEvent(ranked_results(), {
    groups <- ranked_results()$group
    selected <- intersect(isolate(input$table_groups), groups)
    if (length(selected) == 0) selected <- head(groups, 5)
    
    updateSelectizeInput(
      session, "table_groups",
      choices = groups,
      selected = selected,
      server = TRUE
    )
  })
  
  # Statistics can show the five leaders, all groups, or user-selected groups
  table_results <- reactive({
    results <- ranked_results()
    req(input$table_mode)
    
    if (input$table_mode == "top5") {
      results <- head(results, 5)
    } else if (input$table_mode == "custom") {
      results <- results[results$group %in% input$table_groups, , drop = FALSE]
    }
    results
  })
  
  output$table_display_note <- renderText({
    total <- nrow(ranked_results())
    displayed <- nrow(table_results())
    paste0(
      "Showing ", displayed, " of ", total,
      " groups, ranked by ",
      if (input$metric == "median_yards") "median" else "mean",
      " completed yards."
    )
  })
  
  # Describe active filters and flag small groups
  output$summary_text <- renderText({
    results <- summary_data()
    
    validate(need(
      nrow(results) > 0,
      paste(
        "No runners match your selection.",
        "Try selecting more nations or classes,",
        "or reducing the minimum completed yards."
      )
    ))
    
    group_label <- if (input$group_by == "nation") "nations" else "competition classes"
    metric_label <- if (input$metric == "median_yards") "median" else "mean"
    
    message <- paste0(
      sum(results$runners), " stopped runners across ",
      nrow(results), " ", group_label,
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
  
  # Interactive comparison and distribution charts
  output$performance_plot <- renderPlotly({
    results <- ranked_results()
    
    validate(need(
      nrow(results) > 0,
      paste(
        "No results to plot. Try including more nations or classes,",
        "or lowering the minimum completed yards."
      )
    ))
    
    if (input$group_by == "nation") {
      results <- head(results, input$top_n)
    }
    
    results$value <- results[[input$metric]]
    metric_label <- if (input$metric == "median_yards") {
      "Median completed yards"
    } else {
      "Mean completed yards"
    }
    
    # This box chart shows both group spread and individual stopped runners.
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
      runner_data$hover_label <- paste0(
        "<b>", runner_data$runner, "</b>",
        "<br>Nation: ", runner_data$nation,
        "<br>Class: ", runner_data$class,
        "<br>Completed yards: ", runner_data$yards
      )
      
      p <- plotly::plot_ly(
        data = runner_data,
        x = ~yards,
        y = ~display_group,
        split = ~display_group,
        type = "box",
        orientation = "h",
        boxpoints = "all",
        jitter = 0.28,
        pointpos = 0,
        fillcolor = light_blue,
        line = list(color = monash_blue, width = 1.4),
        marker = list(color = "#3D789D", size = 5, opacity = 0.55),
        text = ~hover_label,
        hoverinfo = "text",
        showlegend = FALSE
      )
      
      return(
        plotly::config(
          plotly::layout(
            p,
            title = list(text = "Distribution of runner performance"),
            xaxis = list(title = "Completed yards", rangemode = "tozero",
                         zeroline = FALSE, gridcolor = "#EAF0F5"),
            yaxis = list(title = "", categoryorder = "array",
                         categoryarray = rev(results$group)),
            paper_bgcolor = plot_style$paper_bgcolor,
            plot_bgcolor = plot_style$plot_bgcolor,
            font = plot_style$font,
            margin = plot_style$margin,
            showlegend = FALSE
          ),
          displaylogo = FALSE,
          responsive = TRUE
        )
      )
    }
    
    # Ranking bars are interactive and label the post-filter runner count.
    results$end_label <- paste0("Runners left = ", results$runners)
    results$hover_label <- paste0(
      "<b>", results$group, "</b>",
      "<br>", metric_label, ": ", round(results$value, 1),
      "<br>Stopped runners after filtering: ", results$runners,
      "<br>Maximum yards: ", results$max_yards
    )
    
    p <- plotly::plot_ly(
      data = results,
      x = ~value,
      y = ~group,
      type = "bar",
      orientation = "h",
      marker = list(color = monash_blue),
      width = 0.7,
      text = ~end_label,
      textposition = "outside",
      textfont = list(color = "#43566A", size = 11),
      hovertext = ~hover_label,
      hoverinfo = "text",
      cliponaxis = FALSE,
      showlegend = FALSE
    )
    
    plotly::config(
      plotly::layout(
        p,
        title = list(text = "Runner performance comparison"),
        xaxis = list(
          title = metric_label,
          range = c(0, max(results$value, na.rm = TRUE) * 1.48 + 1),
          zeroline = FALSE,
          gridcolor = "#EAF0F5"
        ),
        yaxis = list(
          title = "",
          categoryorder = "array",
          categoryarray = rev(results$group)
        ),
        paper_bgcolor = plot_style$paper_bgcolor,
        plot_bgcolor = plot_style$plot_bgcolor,
        font = plot_style$font,
        margin = plot_style$margin,
        showlegend = FALSE
      ),
      displaylogo = FALSE,
      responsive = TRUE
    )
  })
  
  output$summary_table <- renderTable({
    results <- table_results()
    
    validate(need(
      nrow(results) > 0,
      if (identical(input$table_mode, "custom")) {
        "Please select at least one group to show in the table."
      } else {
        "No summary available for these filters. Try broadening your selection."
      }
    ))
    
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
