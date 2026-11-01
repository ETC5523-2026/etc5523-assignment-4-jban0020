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

      .dashboard-tabs > .tabbable > .nav-tabs {
        border-bottom: 2px solid #DCE8F2;
        margin: 4px 0 24px;
        display: flex;
        gap: 8px;
      }

      .dashboard-tabs > .tabbable > .nav-tabs > li > a {
        border: 1px solid #D9E4EE;
        border-radius: 9px 9px 0 0;
        background: #EAF2F8;
        color: #31536E;
        padding: 13px 18px;
        font-weight: 700;
      }

      .dashboard-tabs > .tabbable > .nav-tabs > li.active > a,
      .dashboard-tabs > .tabbable > .nav-tabs > li.active > a:hover,
      .dashboard-tabs > .tabbable > .nav-tabs > li.active > a:focus {
        background: #006DAE;
        color: #FFFFFF;
        border-color: #006DAE;
      }

      .tab-intro {
        padding: 1px 3px 14px;
      }

      .tab-intro h3 {
        color: #005E9C;
        font-size: 20px;
        margin: 0 0 7px;
        font-weight: 700;
      }

      .tab-intro p {
        font-size: 13px;
        color: #52677B;
        margin-bottom: 5px;
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
      p("Choose Race progression to see when runners stopped or Performance comparison to compare nations and classes."),
      p("Each tab has its own nation, competition class and yard controls. Changing one tab does not change the other."),
      p("The progression slider moves in single-yard steps. Click the chart to see who stopped at that yard."),
      p("The performance line chart shows cumulative yards; runner counts are hover/legend labels, not plot positions."),
      p("The statistics table shows five rows by default, with options to choose groups or show all.")
    )
  ),
  
  div(
    class = "dashboard-tabs",
    tabsetPanel(
      id = "dashboard_tab",
      selected = "Race progression",
      tabPanel(
        title = "Race progression",
        value = "Race progression",
        div(
          class = "tab-intro",
          h3("When do runners drop out?"),
          p("Track the selected stopped-runner cohort one yard at a time. Clicking a point or bar selects that yard and updates the stopping details.")
        ),
        sidebarLayout(
          sidebarPanel(
            h3("Progression filters"),
            selectizeInput(
              inputId = "progress_nations",
              label = "Select nations (blank means all)",
              choices = sort(unique(wtc$nation)),
              selected = character(0),
              multiple = TRUE
            ),
            div(
              class = "class-grid",
              checkboxGroupInput(
                inputId = "progress_classes",
                label = "Competition classes",
                choices = sort(unique(wtc$class)),
                selected = sort(unique(wtc$class))
              )
            ),
            sliderInput(
              inputId = "min_yards",
              label = "Current completed yard",
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
              class = "sidebar-tip",
              "These filters only affect Race progression. Your selections in Performance comparison are independent."
            )
          ),
          mainPanel(
            div(
              class = "output-card",
              h3("Lap-by-lap progression"),
              div(
                class = "summary-banner",
                "Follow the selected stopped runners as the completed-yard threshold increases. ",
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
              plotlyOutput("progression_plot", height = "375px"),
              p(
                class = "progress-explainer",
                "Move or play the yard slider, or click the chart. A runner with exactly ",
                "X completed yards is counted at X, then drops out when the threshold reaches X + 1."
              ),
              div(class = "lap-stop-heading", textOutput("lap_stop_title", inline = TRUE)),
              div(class = "table-hint", textOutput("lap_stop_note", inline = TRUE)),
              checkboxInput(
                "all_lap_stops",
                "Show all runners who stopped at this yard (rather than the first 8)",
                value = FALSE
              ),
              div(class = "table-scroll", tableOutput("lap_stop_table"))
            ),
            div(
              class = "app-note",
              h4("How to interpret progression"),
              p("The line is a cumulative count of the selected runners who eventually stopped. ",
                "It does not describe all participants or live race standings."),
              p("Where no runner stopped at a yard, the remaining count stays unchanged ",
                "when you advance to the next completed yard.")
            )
          )
        )
      ),
      tabPanel(
        title = "Performance comparison",
        value = "Performance comparison",
        div(
          class = "tab-intro",
          h3("How do nations and classes compare?"),
          p("Compare accumulated yards and individual runner performance. These filters do not change the Race progression view.")
        ),
        sidebarLayout(
          sidebarPanel(
            h3("Performance filters"),
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
              inputId = "performance_nations",
              label = "Select nations (blank means all)",
              choices = sort(unique(wtc$nation)),
              selected = character(0),
              multiple = TRUE
            ),
            div(
              class = "class-grid",
              checkboxGroupInput(
                inputId = "performance_classes",
                label = "Competition classes",
                choices = sort(unique(wtc$class)),
                selected = sort(unique(wtc$class))
              )
            ),
            sliderInput(
              inputId = "performance_min_yards",
              label = "Minimum completed yards / highlighted yard",
              min = 0,
              max = max(1, max(wtc$yards, na.rm = TRUE)),
              value = 0,
              step = 1,
              sep = "",
              ticks = FALSE
            ),
            div(class = "yard-hint", textOutput("performance_yard_limit", inline = TRUE)),
            div(
              class = "choice-buttons",
              radioButtons(
                inputId = "plot_type",
                label = "Chart view",
                choices = c("Total yards (lines)" = "lines", "Runner distribution" = "distribution"),
                selected = "lines",
                inline = TRUE
              )
            ),
            div(
              class = "choice-buttons",
              radioButtons(
                inputId = "metric",
                label = "Rank statistics by",
                choices = c("Median yards" = "median_yards", "Mean yards" = "mean_yards"),
                selected = "median_yards",
                inline = TRUE
              )
            ),
            conditionalPanel(
              condition = "input.group_by == 'nation'",
              sliderInput(
                inputId = "top_n",
                label = "Nations displayed (top totals)",
                min = 5, max = 25, value = 12
              )
            ),
            div(
              class = "sidebar-tip",
              "The line graph always shows cumulative total yards; the yard slider moves its highlight. ",
              "The slider also sets the minimum for the distribution and statistics."
            )
          ),
          mainPanel(
            div(
              class = "output-card",
              h3("Explore performance"),
              div(class = "summary-banner", textOutput("summary_text")),
              plotlyOutput("performance_plot", height = "585px"),
              p(
                class = "progress-explainer",
                "For the line chart, X is the completed-yard threshold and Y is total ",
                "yards accumulated by each group to that threshold. The dashed line ",
                "shows the selected yard. 'Runners left' appears only in labels and hover ",
                "details; counts do not set the plotted coordinates or marker sizes."
              )
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
              p(strong("Total-yards line chart: "),
                "Lines show cumulative yards for each nation or class. Runner counts ",
                "are contextual labels, not the vertical values."),
              p(strong("Runner distribution: "),
                "Each point represents one stopped runner; the box shows the median and middle 50%."),
              p(strong("Mean versus median: "),
                "The mean is the arithmetic average; the median is the middle value. ",
                "Small groups can produce unstable comparisons."),
              p("Groups with more runners can naturally accumulate more total yards. ",
                "Use the mean or median for typical individual performance.")
            )
          )
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
  
  # Progression tab: filter nation and class independently of performance tab.
  progress_filtered_data <- reactive({
    data <- wtc[wtc$class %in% input$progress_classes, , drop = FALSE]
    if (length(input$progress_nations) > 0) {
      data <- data[data$nation %in% input$progress_nations, , drop = FALSE]
    }
    data
  })
  
  # Performance tab: a different selection, preserved when changing tabs.
  performance_filtered_data <- reactive({
    data <- wtc[wtc$class %in% input$performance_classes, , drop = FALSE]
    if (length(input$performance_nations) > 0) {
      data <- data[data$nation %in% input$performance_nations, , drop = FALSE]
    }
    data
  })
  
  # Each tab's yard slider adapts to the classes/nations in THAT tab.
  available_yards <- reactive({
    values <- progress_filtered_data()$yards
    values <- values[is.finite(values)]
    if (!length(values)) return(0)
    max(values)
  })
  
  observeEvent(available_yards(), {
    limit <- max(1, ceiling(available_yards()))
    current <- input$min_yards
    if (is.null(current) || !is.finite(current)) current <- 0
    updateSliderInput(
      session, "min_yards", min = 0, max = limit,
      value = min(current, limit), step = 1
    )
  })
  
  performance_available_yards <- reactive({
    values <- performance_filtered_data()$yards
    values <- values[is.finite(values)]
    if (!length(values)) return(0)
    max(values)
  })
  
  observeEvent(performance_available_yards(), {
    limit <- max(1, ceiling(performance_available_yards()))
    current <- input$performance_min_yards
    if (is.null(current) || !is.finite(current)) current <- 0
    updateSliderInput(
      session, "performance_min_yards", min = 0, max = limit,
      value = min(current, limit), step = 1
    )
  })
  
  observeEvent(input$yard_back, {
    current <- if (is.null(input$min_yards)) 0 else input$min_yards
    updateSliderInput(session, "min_yards", value = max(0, current - 1))
  })
  
  observeEvent(input$yard_forward, {
    current <- if (is.null(input$min_yards)) 0 else input$min_yards
    updateSliderInput(session, "min_yards",
                      value = min(available_yards(), current + 1))
  })
  
  output$yard_limit <- renderText({
    paste0("Highest available: ", format(available_yards(), trim = TRUE),
           " yards for the progression selection. Step: 1 yard.")
  })
  
  output$performance_yard_limit <- renderText({
    paste0("Highest available: ", format(performance_available_yards(), trim = TRUE),
           " yards for the performance selection. Step: 1 yard.")
  })
  
  # Progression data for the lap-by-lap view.
  cohort <- reactive({
    data <- progress_filtered_data()
    data[is.finite(data$yards) & data$yards >= 0, , drop = FALSE]
  })
  
  # Performance data for the charts and tables; never read progression inputs.
  performance_cohort <- reactive({
    data <- performance_filtered_data()
    data[is.finite(data$yards) & data$yards >= 0, , drop = FALSE]
  })
  
  # Lap-by-lap progression is based on the selected STOPPED runners only.
  # A runner with Y completed yards contributes to every threshold 0,...,Y.
  # Moving from threshold Y to Y+1 removes anyone recorded as stopping at Y.
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
      data = performance_filtered_data(),
      group = input$group_by,
      min_yards = input$performance_min_yards
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
  
  # Cumulative completed yards through each threshold, for the selected cohort.
  # A runner who completed Y yards contributes one yard at each of yards 1,...,Y.
  # The group is chosen using its final total yards, independently of counts
  # and the mean/median table ranking setting.
  performance_lines <- reactive({
    data <- performance_cohort()
    req(input$group_by)
    validate(need(nrow(data) > 0, "Select nations and classes containing runners."))
    
    grouped <- data.frame(
      group = as.character(data[[input$group_by]]),
      yards = as.integer(data$yards),
      stringsAsFactors = FALSE
    )
    totals <- stats::aggregate(yards ~ group, data = grouped, FUN = sum)
    totals <- totals[order(-totals$yards, totals$group), , drop = FALSE]
    groups <- totals$group
    if (input$group_by == "nation") groups <- head(groups, input$top_n)
    
    max_yard <- as.integer(max(grouped$yards))
    yard_axis <- seq.int(0L, max_yard, by = 1L)
    
    series <- lapply(groups, function(group_name) {
      completed <- grouped$yards[grouped$group == group_name]
      stopped <- tabulate(completed + 1L, nbins = length(yard_axis))
      remaining <- rev(cumsum(rev(stopped)))
      # Cumulative yards through yard X = sum(min(runner_yards, X)).
      cumulative <- c(0, cumsum(remaining[-1L]))
      
      data.frame(
        group = group_name,
        yard = yard_axis,
        total_yards = cumulative,
        runners_left = remaining,
        stringsAsFactors = FALSE
      )
    })
    do.call(rbind, series)
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
    
    if (identical(input$plot_type, "lines")) {
      message <- paste0(
        "Each line shows cumulative total yards across completed-yard thresholds ",
        "for a selected ", if (input$group_by == "nation") "nation" else "competition class",
        ". The current slider yard is marked on the chart. ",
        "The legend shows runners left at that yard; counts never set line height. ",
        "The table is ranked by ", metric_label, " completed yards."
      )
    } else {
      message <- paste0(
        sum(results$runners), " stopped runners across ",
        nrow(results), " ", group_label,
        " match your selection. Groups are ranked by ",
        metric_label, " completed yards."
      )
    }
    
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
      runner_data <- performance_filtered_data()
      runner_data <- runner_data[
        !is.na(runner_data$yards) &
          runner_data$yards >= input$performance_min_yards &
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
    
    # Draw genuine line series over yard thresholds, rather than connecting
    # unrelated country/class categories. Vertical positions depend only on
    # cumulative total completed yards, never on the displayed runner counts.
    lines <- performance_lines()
    current <- as.integer(input$performance_min_yards)
    groups <- unique(lines$group)
    line_colours <- c(
      "#006DAE", "#D97A25", "#17846B", "#8E64B0", "#C85B76",
      "#4A86C6", "#B39B31", "#497E62", "#A65A38", "#557A94",
      "#9C5797", "#3197A0", "#705A91", "#9C783F", "#3C7895"
    )
    line_colours <- rep(line_colours, length.out = length(groups))
    
    p <- plotly::plot_ly(source = "performance_yards")
    for (i in seq_along(groups)) {
      group_name <- groups[[i]]
      group_lines <- lines[lines$group == group_name, , drop = FALSE]
      selected <- group_lines[group_lines$yard == current, , drop = FALSE]
      # The legend and tooltips show the runner count, with a fixed marker size.
      legend_name <- paste0(
        group_name, " | Runners left = ", selected$runners_left[[1]]
      )
      group_lines$hover_label <- paste0(
        "<b>", group_name, "</b>",
        "<br>Yard: ", group_lines$yard,
        "<br>Total yards completed through this yard: ",
        format(group_lines$total_yards, big.mark = ",", scientific = FALSE),
        "<br>Runners left = ", group_lines$runners_left
      )
      selected$hover_label <- paste0(
        "<b>", group_name, "</b>",
        "<br>Selected yard: ", current,
        "<br>Total completed yards: ",
        format(selected$total_yards, big.mark = ",", scientific = FALSE),
        "<br>Runners left = ", selected$runners_left
      )
      
      p <- plotly::add_trace(
        p, data = group_lines,
        x = ~yard, y = ~total_yards,
        type = "scatter", mode = "lines",
        name = legend_name, legendgroup = group_name,
        line = list(color = line_colours[[i]], width = 2.4),
        hovertext = ~hover_label, hoverinfo = "text",
        showlegend = TRUE, inherit = FALSE
      )
      p <- plotly::add_trace(
        p, data = selected,
        x = ~yard, y = ~total_yards,
        type = "scatter", mode = "markers",
        name = group_name, legendgroup = group_name,
        marker = list(
          color = line_colours[[i]], size = 10,
          line = list(color = "#FFFFFF", width = 1.5)
        ),
        hovertext = ~hover_label, hoverinfo = "text",
        showlegend = FALSE, inherit = FALSE
      )
    }
    
    plotly::config(
      plotly::layout(
        p,
        title = list(text = "Cumulative yards completed by nation or class", font = list(size = 15)),
        xaxis = list(
          title = "Completed-yard threshold", dtick = 10,
          range = c(0, max(1, max(lines$yard))),
          zeroline = FALSE, gridcolor = "#EAF0F5"
        ),
        yaxis = list(
          title = "Total yards completed through this yard",
          rangemode = "tozero", zeroline = FALSE, gridcolor = "#EAF0F5",
          separatethousands = TRUE
        ),
        shapes = list(list(
          type = "line", x0 = current, x1 = current,
          y0 = 0, y1 = 1, yref = "paper",
          line = list(color = "#ED8A32", width = 2, dash = "dash")
        )),
        legend = list(
          x = 1.02, y = 1, xanchor = "left", yanchor = "top",
          font = list(size = 10), title = list(text = "Groups (at selected yard)")
        ),
        paper_bgcolor = plot_style$paper_bgcolor,
        plot_bgcolor = plot_style$plot_bgcolor,
        font = plot_style$font,
        margin = list(l = 92, r = 240, t = 65, b = 70),
        showlegend = TRUE
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
