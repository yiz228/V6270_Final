library(shiny)
library(bslib)
library(ggplot2)
library(dplyr)
library(readr)

# Load data
wic <- read_csv("Nut_Data.csv", show_col_types = FALSE)

# Clean data
wic_clean <- wic %>%
  filter(
    Question == "Percent of WIC toddlers who have an overweight classification",
    StratificationCategory1 == "Race/Ethnicity",
    !is.na(Data_Value)
  ) %>%
  select(
    YearStart,
    LocationDesc,
    Question,
    StratificationCategory1,
    Stratification1,
    Data_Value
  ) %>%
  mutate(
    Stratification1 = case_when(
      Stratification1 == "American Indian/Alaska Native" ~ "American Indian/\nAlaska Native",
      Stratification1 == "Asian/Pacific Islander" ~ "Asian/\nPacific Islander",
      Stratification1 == "Non-Hispanic Black" ~ "Non-Hispanic\nBlack",
      Stratification1 == "Non-Hispanic White" ~ "Non-Hispanic\nWhite",
      TRUE ~ Stratification1
    )
  )

ui <- page_fluid(
  title = "WIC Toddler Overweight Prevalence Explorer",
  theme = bs_theme(
    bootswatch = "flatly",
    primary = "#6C63FF"
  ),
  
  tags$head(
    tags$style(HTML("
      body {
        font-family: 'Avenir Next', 'SF Pro Display', 'Helvetica Neue', Arial, sans-serif;
        background:
          radial-gradient(circle at top left, rgba(255,230,214,0.85) 0%, rgba(255,230,214,0) 28%),
          radial-gradient(circle at top right, rgba(203,229,255,0.85) 0%, rgba(203,229,255,0) 28%),
          radial-gradient(circle at bottom right, rgba(212,244,235,0.85) 0%, rgba(212,244,235,0) 25%),
          linear-gradient(135deg, #f8f3ee 0%, #eef4fb 52%, #f2f8f3 100%);
        min-height: 100vh;
      }

      .container-fluid {
        padding-left: 20px;
        padding-right: 20px;
      }

      .glass-hero {
        position: relative;
        overflow: hidden;
        margin: 10px 0 26px 0;
        padding: 38px 42px;
        border-radius: 34px;
        background: rgba(255, 255, 255, 0.28);
        border: 1px solid rgba(255, 255, 255, 0.50);
        backdrop-filter: blur(18px);
        -webkit-backdrop-filter: blur(18px);
        box-shadow:
          0 18px 40px rgba(82, 96, 123, 0.18),
          inset 0 1px 0 rgba(255,255,255,0.55);
        min-height: 220px;
      }

      .glass-hero h1 {
        position: relative;
        z-index: 2;
        margin: 0 0 12px 0;
        font-size: 58px;
        line-height: 1.03;
        font-weight: 800;
        color: #1f2430;
        letter-spacing: -1.5px;
      }

      .glass-hero p {
        position: relative;
        z-index: 2;
        margin: 0;
        max-width: 1000px;
        font-size: 23px;
        color: #55606f;
        font-weight: 500;
      }

      .blob {
        position: absolute;
        border-radius: 999px;
        filter: blur(0.2px);
        box-shadow:
          inset 0 1px 0 rgba(255,255,255,0.65),
          0 10px 24px rgba(88, 100, 125, 0.20);
        border: 1px solid rgba(255,255,255,0.45);
        backdrop-filter: blur(10px);
        -webkit-backdrop-filter: blur(10px);
      }

      .blob-1 {
        width: 180px;
        height: 68px;
        top: 34px;
        right: 110px;
        background: linear-gradient(135deg, rgba(170,144,255,0.75), rgba(115,104,255,0.58));
        border-radius: 999px;
      }

      .blob-2 {
        width: 150px;
        height: 58px;
        top: 118px;
        right: 205px;
        background: linear-gradient(135deg, rgba(155,240,223,0.70), rgba(111,215,198,0.55));
        border-radius: 999px;
      }

      .blob-3 {
        width: 130px;
        height: 130px;
        bottom: -18px;
        right: 36px;
        background: linear-gradient(135deg, rgba(255,198,214,0.60), rgba(149,203,255,0.58));
        border-radius: 32px;
      }

      .blob-4 {
        width: 68px;
        height: 68px;
        left: 30px;
        bottom: 28px;
        background: rgba(255,255,255,0.55);
      }

      .blob-5 {
        width: 84px;
        height: 84px;
        left: 135px;
        top: 38px;
        background: linear-gradient(135deg, rgba(255,160,180,0.50), rgba(255,218,130,0.42));
        border-radius: 28px;
        transform: rotate(12deg);
      }

      .glass-badge {
        position: absolute;
        z-index: 2;
        right: 52px;
        top: 44px;
        padding: 12px 18px;
        border-radius: 18px;
        background: rgba(255,255,255,0.30);
        border: 1px solid rgba(255,255,255,0.5);
        backdrop-filter: blur(14px);
        -webkit-backdrop-filter: blur(14px);
        font-size: 15px;
        color: #3f4a5a;
        font-weight: 700;
        box-shadow: 0 8px 20px rgba(0,0,0,0.08);
      }

      .nav-tabs {
        border-bottom: none;
        margin-bottom: 20px;
        gap: 8px;
      }

      .nav-tabs .nav-link {
        border: 1px solid rgba(255,255,255,0.50);
        background: rgba(255,255,255,0.26);
        backdrop-filter: blur(14px);
        -webkit-backdrop-filter: blur(14px);
        border-radius: 16px 16px 0 0;
        font-weight: 700;
        color: #4a5565;
        padding: 12px 18px;
        margin-right: 6px;
      }

      .nav-tabs .nav-link.active {
        color: #1f2430;
        background: rgba(255,255,255,0.55);
        border-color: rgba(255,255,255,0.65);
      }

      .card {
        margin-bottom: 20px;
        border-radius: 28px;
        background: rgba(255,255,255,0.30);
        border: 1px solid rgba(255,255,255,0.50);
        backdrop-filter: blur(16px);
        -webkit-backdrop-filter: blur(16px);
        box-shadow:
          0 14px 28px rgba(82, 96, 123, 0.14),
          inset 0 1px 0 rgba(255,255,255,0.55);
      }

      .card-header {
        background: rgba(255,255,255,0.18);
        border-bottom: 1px solid rgba(255,255,255,0.35);
        font-weight: 800;
        font-size: 20px;
        color: #222a36;
        padding: 18px 24px;
        border-radius: 28px 28px 0 0 !important;
      }

      .card-body, .card > div:not(.card-header) {
        padding: 22px 24px;
      }

      .btn-primary {
        border-radius: 999px;
        padding: 10px 18px;
        font-weight: 700;
        background: linear-gradient(135deg, #7b6dff 0%, #5e60ce 100%);
        border: none;
        box-shadow: 0 10px 18px rgba(94,96,206,0.25);
      }

      .sidebar {
        background: rgba(255,255,255,0.30) !important;
        border: 1px solid rgba(255,255,255,0.50) !important;
        backdrop-filter: blur(18px);
        -webkit-backdrop-filter: blur(18px);
        border-radius: 28px !important;
        box-shadow: 0 14px 28px rgba(82,96,123,0.12);
      }

      .sidebar h4 {
        font-weight: 800;
        color: #202734;
      }

      .form-control, .form-select {
        border-radius: 18px !important;
        border: 1px solid rgba(210,220,235,0.90) !important;
        background: rgba(255,255,255,0.72) !important;
        box-shadow: inset 0 1px 0 rgba(255,255,255,0.65);
      }

      .shiny-options-group label,
      .control-label,
      .form-label {
        font-weight: 700;
        color: #3e4858;
      }

      .summary-box,
      .stat-box,
      .note-box {
        border-radius: 22px;
        padding: 20px 22px;
        background: rgba(255,255,255,0.35);
        border: 1px solid rgba(255,255,255,0.48);
        backdrop-filter: blur(16px);
        -webkit-backdrop-filter: blur(16px);
        box-shadow: 0 10px 22px rgba(82,96,123,0.10);
      }

      .summary-box {
        color: #24303d;
        font-size: 16px;
      }

      .stat-box {
        background: linear-gradient(135deg, rgba(191,219,255,0.35), rgba(255,255,255,0.32));
        margin-bottom: 14px;
      }

      .note-box {
        background: linear-gradient(135deg, rgba(255,244,209,0.46), rgba(255,255,255,0.30));
        margin-top: 10px;
      }

      .plot-glass {
        padding: 16px;
      }

      .about-note {
        color: #4c5566;
        font-size: 16px;
        line-height: 1.7;
      }

      .sticky-author {
        position: relative;
        background: linear-gradient(135deg, rgba(255,244,170,0.92), rgba(255,250,204,0.85));
        border-radius: 12px;
        padding: 26px 28px;
        min-height: 175px;
        box-shadow: 0 14px 26px rgba(0,0,0,0.12);
        transform: rotate(-1.3deg);
        border: 1px solid rgba(0,0,0,0.05);
      }

      .sticky-author h3 {
        margin-top: 0;
        font-weight: 800;
        color: #2c2c2c;
      }

      .sticky-author p {
        font-size: 24px;
        margin-bottom: 0;
        color: #2c2c2c;
      }

      .sticky-pin {
        position: absolute;
        width: 18px;
        height: 18px;
        background: #ef476f;
        border-radius: 50%;
        top: 12px;
        left: 50%;
        transform: translateX(-50%);
        box-shadow: 0 2px 5px rgba(0,0,0,0.20);
      }

      @media (max-width: 900px) {
        .glass-hero h1 {
          font-size: 38px;
        }
        .glass-hero p {
          font-size: 18px;
        }
        .blob {
          opacity: 0.40;
        }
      }
    "))
  ),
  
  div(
    class = "glass-hero",
    div(class = "blob blob-1"),
    div(class = "blob blob-2"),
    div(class = "blob blob-3"),
    div(class = "blob blob-4"),
    div(class = "blob blob-5"),
  
    
    h1("WIC Toddler Overweight Prevalence Explorer"),
    p("Explore racial and ethnic differences in overweight prevalence among children participating in WIC.")
  ),
  
  tabsetPanel(
    tabPanel(
      "About this App",
      
      layout_columns(
        col_widths = c(4, 8),
        
        card(
          card_header("Author"),
          div(
            class = "about-note",
            p("Yi Zhang")
          )
      ),
        
        card(
          card_header("Research Question"),
          div(
            class = "about-note",
            p("Did overweight prevalence differ by race/ethnicity among children participating in WIC?")
          )
        )
      ),
      
      card(
        card_header("App Goal"),
        div(
          class = "about-note",
          p("This Shiny App allows users to explore racial and ethnic differences in overweight prevalence among children participating in WIC. Users can select a year and race/ethnicity groups to compare prevalence patterns.")
        )
      ),
      
      card(
        card_header("Data Source"),
        div(
          class = "about-note",
          p(
            "CDC Data.CDC.gov, ",
            tags$a(
              href = "https://data.cdc.gov/Nutrition-Physical-Activity-and-Obesity/Nutrition-Physical-Activity-and-Obesity-Women-Infa/735e-byxc/data_preview",
              target = "_blank",
              "Nutrition, Physical Activity, and Obesity - Women, Infant, and Child dataset"
            ),
            "."
          )
        )
      ),
      
      card(
        card_header("How to Use This App"),
        div(
          class = "about-note",
          tags$ol(
            tags$li("Go to the Data Visualization tab."),
            tags$li("Select a year."),
            tags$li("Choose a plot type."),
            tags$li("Select race/ethnicity groups."),
            tags$li("Choose whether to view the descriptive summary, statistical analysis, or both.")
          ),
          p("The visualization, descriptive summary, and statistical test results update based on the selected options.")
        )
      ),
      
      layout_columns(
        col_widths = c(6, 6),
        
        card(
          card_header("GitHub Repository"),
          div(
            class = "about-note",
            p("The app code and supporting files are available in the GitHub repository."),
            tags$a(
              href = "https://github.com/yiz228/V6270_Final",
              target = "_blank",
              class = "btn btn-primary",
              "View GitHub Repository"
            )
          )
        ),
        
        card(
          card_header("AI Use Disclosure"),
          div(
            class = "about-note",
            p("ChatGPT was used to assist with organizing the Shiny App structure, generating R code, troubleshooting R code, and improving layout.")
          )
        )
      )
    ),
    
    tabPanel(
      "Data Visualization",
      
      layout_sidebar(
        sidebar = sidebar(
          width = 320,
          h4("User Controls"),
          
          selectInput(
            inputId = "year",
            label = "Select year:",
            choices = sort(unique(wic_clean$YearStart)),
            selected = 2008
          ),
          
          selectInput(
            inputId = "plot_type",
            label = "Select plot type:",
            choices = c("Boxplot", "Bar chart"),
            selected = "Boxplot"
          ),
          
          checkboxGroupInput(
            inputId = "race_groups",
            label = "Select race/ethnicity groups:",
            choices = sort(unique(wic_clean$Stratification1)),
            selected = sort(unique(wic_clean$Stratification1))
          ),
          
          radioButtons(
            inputId = "display_section",
            label = "Select output section:",
            choices = c("Summary", "Statistical Analysis", "Both"),
            selected = "Both"
          )
        ),
        
        card(
          card_header("Data Visualization"),
          div(
            class = "plot-glass",
            plotOutput("prevalence_plot", height = "550px")
          )
        ),
        
        conditionalPanel(
          condition = "input.display_section == 'Summary' || input.display_section == 'Both'",
          card(
            card_header("Summary"),
            div(class = "summary-box", textOutput("summary_text"))
          )
        ),
        
        conditionalPanel(
          condition = "input.display_section == 'Statistical Analysis' || input.display_section == 'Both'",
          card(
            card_header("Statistical Analysis"),
            uiOutput("statistical_analysis")
          )
        )
      )
    )
  )
)

server <- function(input, output) {
  
  filtered_data <- reactive({
    selected_groups <- input$race_groups
    
    if (is.null(selected_groups) || length(selected_groups) == 0) {
      selected_groups <- unique(wic_clean$Stratification1)
    }
    
    wic_clean %>%
      filter(
        YearStart == input$year,
        Stratification1 %in% selected_groups
      )
  })
  
  output$prevalence_plot <- renderPlot({
    data_to_plot <- filtered_data()
    
    validate(
      need(nrow(data_to_plot) > 0, "No data are available for the selected options.")
    )
    
    if (input$plot_type == "Boxplot") {
      ggplot(data_to_plot, aes(x = Stratification1, y = Data_Value)) +
        geom_boxplot(fill = "#b7d7ff", color = "#4b5568", alpha = 0.92) +
        labs(
          title = paste("Overweight Prevalence by Race/Ethnicity in", input$year),
          x = "Race/Ethnicity",
          y = "Overweight prevalence (%)"
        ) +
        theme_minimal(base_size = 14) +
        theme(
          plot.title = element_text(size = 18, face = "bold", color = "#1f2430"),
          axis.text.x = element_text(size = 11, color = "#44505f"),
          axis.text.y = element_text(color = "#44505f"),
          axis.title.x = element_text(margin = margin(t = 15), face = "bold", color = "#334"),
          axis.title.y = element_text(margin = margin(r = 15), face = "bold", color = "#334"),
          panel.grid.minor = element_blank(),
          panel.background = element_rect(fill = "white", color = NA),
          plot.background = element_rect(fill = "white", color = NA)
        )
    } else {
      summary_df <- data_to_plot %>%
        group_by(Stratification1) %>%
        summarise(
          median_prevalence = median(Data_Value, na.rm = TRUE),
          .groups = "drop"
        )
      
      ggplot(summary_df, aes(x = Stratification1, y = median_prevalence)) +
        geom_col(fill = "#9ee2d3", color = "#4b5568", alpha = 0.95) +
        geom_text(
          aes(label = round(median_prevalence, 1)),
          vjust = -0.4,
          size = 4.5,
          color = "#24303d",
          fontface = "bold"
        ) +
        labs(
          title = paste("Median Overweight Prevalence by Race/Ethnicity in", input$year),
          x = "Race/Ethnicity",
          y = "Median overweight prevalence (%)"
        ) +
        theme_minimal(base_size = 14) +
        theme(
          plot.title = element_text(size = 18, face = "bold", color = "#1f2430"),
          axis.text.x = element_text(size = 11, color = "#44505f"),
          axis.text.y = element_text(color = "#44505f"),
          axis.title.x = element_text(margin = margin(t = 15), face = "bold", color = "#334"),
          axis.title.y = element_text(margin = margin(r = 15), face = "bold", color = "#334"),
          panel.grid.minor = element_blank(),
          panel.background = element_rect(fill = "white", color = NA),
          plot.background = element_rect(fill = "white", color = NA)
        )
    }
  })
  
  output$summary_text <- renderText({
    data_to_summarize <- filtered_data()
    
    if (nrow(data_to_summarize) == 0) {
      return("No data are available for the selected options.")
    }
    
    summary_df <- data_to_summarize %>%
      group_by(Stratification1) %>%
      summarise(
        median_prevalence = median(Data_Value, na.rm = TRUE),
        .groups = "drop"
      )
    
    highest_group <- summary_df %>%
      filter(median_prevalence == max(median_prevalence, na.rm = TRUE)) %>%
      slice(1)
    
    lowest_group <- summary_df %>%
      filter(median_prevalence == min(median_prevalence, na.rm = TRUE)) %>%
      slice(1)
    
    paste0(
      "In ", input$year, ", the selected group with the highest median overweight prevalence was ",
      gsub("\n", " ", highest_group$Stratification1), " (",
      round(highest_group$median_prevalence, 1), "%). ",
      "The selected group with the lowest median overweight prevalence was ",
      gsub("\n", " ", lowest_group$Stratification1), " (",
      round(lowest_group$median_prevalence, 1), "%)."
    )
  })
  
  output$statistical_analysis <- renderUI({
    data_to_test <- filtered_data()
    
    if (nrow(data_to_test) == 0) {
      return(div(class = "note-box", "No data are available for the selected options."))
    }
    
    n_groups <- length(unique(data_to_test$Stratification1))
    
    if (n_groups < 2) {
      return(div(class = "note-box", "At least two race/ethnicity groups are needed to run a statistical comparison."))
    }
    
    if (n_groups == 2) {
      wilcox_result <- wilcox.test(
        Data_Value ~ Stratification1,
        data = data_to_test
      )
      
      return(
        tagList(
          div(
            class = "stat-box",
            h4("Formal statistical analysis"),
            p("Because two race/ethnicity groups were selected, a Wilcoxon rank sum test was used to compare overweight prevalence between the selected groups."),
            tags$ul(
              tags$li(tags$strong("Test statistic: "), paste0("W = ", round(as.numeric(wilcox_result$statistic), 3))),
              tags$li(tags$strong("P value: "), signif(wilcox_result$p.value, 3))
            )
          ),
          div(
            class = "note-box",
            p(
              tags$strong("Interpretation: "),
              "This test evaluates whether overweight prevalence differs between the two selected race/ethnicity groups. Results should be interpreted as differences in prevalence estimates, not as evidence of individual-level risk or causation."
            )
          )
        )
      )
    }
    
    kruskal_result <- kruskal.test(
      Data_Value ~ Stratification1,
      data = data_to_test
    )
    
    epsilon_sq <- (
      as.numeric(kruskal_result$statistic) -
        as.numeric(kruskal_result$parameter) + 1
    ) / (
      nrow(data_to_test) -
        as.numeric(kruskal_result$parameter)
    )
    
    tagList(
      div(
        class = "stat-box",
        h4("Formal statistical analysis"),
        p("Because more than two race/ethnicity groups were selected, a Kruskal-Wallis rank sum test was used to compare overweight prevalence across the selected groups."),
        tags$ul(
          tags$li(
            tags$strong("Test statistic: "),
            paste0(
              "chi-squared(",
              as.numeric(kruskal_result$parameter),
              ") = ",
              round(as.numeric(kruskal_result$statistic), 3)
            )
          ),
          tags$li(tags$strong("P value: "), signif(kruskal_result$p.value, 3)),
          tags$li(tags$strong("Epsilon-squared effect size: "), round(epsilon_sq, 2))
        )
      ),
      div(
        class = "note-box",
        p(
          tags$strong("Interpretation: "),
          "This test evaluates whether overweight prevalence differs across the selected race/ethnicity groups. The effect size provides an estimate of how much variability in ranked overweight prevalence is associated with race/ethnicity. These results should be interpreted as differences in state-level prevalence estimates, not as evidence of individual-level risk or causation."
        )
      )
    )
  })
}

shinyApp(ui = ui, server = server)