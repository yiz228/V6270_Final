# V6270 Final Project

## Project Title and Brief Description

This repository contains my final project for VTPEH 6270. The project focuses on overweight classification among WIC toddlers using nutrition surveillance data. The final deliverables include a Shiny app, a written report, the dataset, and reference materials.

## Author and Affiliation

**Author:** Yi(Eve) Zhang  
**Affiliation:** Cornell University, Master of Public Health Program

## Contact Information

For questions about this project, please contact:  
Yi(Eve) Zhang   
Email: yz3493@cornell.edu

## Research Question and Objectives

The written report focuses on the following research question:

**Did the prevalence of overweight classification differ by race/ethnicity among children participating in WIC in the United States in 2008?**

The Shiny app expands on this topic by allowing users to explore overweight classification among WIC toddlers across multiple years, states, and race/ethnicity groups.

The objectives of this project are to:

1. Examine racial/ethnic differences in overweight classification among WIC toddlers in 2008.
2. Create an interactive Shiny app to explore overweight prevalence across available years.
3. Allow users to compare patterns by state and race/ethnicity group.
4. Present the findings and supporting visualizations in a final written report.

   
## Data Source and Description

The dataset used in this project is [`Nut_Data.csv`](Data./Nut_Data.csv) The analysis focuses on records related to the percentage of WIC toddlers who have an overweight classification. The data are filtered by the question category related to WIC toddler overweight classification and by race/ethnicity stratification.

The dataset is stored in the [`Data./`](Data./) folder.

## Repository Structure

- [`Data./`](Data./) Folder
  - Contains the dataset used for this project.
  - [`Nut_Data.csv`](Data./Nut_Data.csv)` is the main data file.

- [`Final_ShinyApp/`](Final_ShinyApp/)  Folder
  - Contains the Shiny app file.
  - [`Final_ShinyApp/Final_app.R`](Final_ShinyApp/Final_app.R)
- Dataset: [`Data./Nut_Data.csv`](Data./Nut_Data.csv) is the main Shiny application script.

- [`Final_Report/`](Final_Report/) Floder
  - Contains the final written report and related files.
  - [`VTPEH 6270 - Final.Rmd`](Final_Report/VTPEH%206270%20-%20Final.Rmd) is the R Markdown file.
  - [`VTPEH-6270---Final.pdf`](Final_Report/VTPEH-6270---Final.pdf) is the final report PDF.
  - [`cp06_references.bib`](Final_Report/cp06_references.bib) contains the references used in the report.

## Links to Reports, Apps, and Other Deliverables

- Final report PDF: [`Final_Report/VTPEH-6270---Final.pdf`](Final_Report/VTPEH-6270---Final.pdf)
- R Markdown report file: [`Final_Report/VTPEH 6270 - Final.Rmd`](Final_Report/VTPEH%206270%20-%20Final.Rmd)
- Shiny app file: [`Final_ShinyApp/Final_app.R`](Final_ShinyApp/Final_app.R)
- Dataset: [`Data./Nut_Data.csv`](Data./Nut_Data.csv)

## Published Shiny app: 
- https://yiz228.shinyapps.io/wic_overweight_app/

## Required R Packages
The following R packages are required to run the Shiny app and reproduce the analysis:
- shiny
- bslib
- ggplot2
- dplyr
- readr
  
To install the required packages, run:
```r
install.packages(c("shiny", "bslib", "ggplot2", "dplyr", "readr"))
```
## How to Use This Repository

This repository contains the final report and Shiny app files for the VTPEH 6270 final project.

### Repository Structure

- [`Final_Report/`](Final_Report/)  

  Contains the final written report, the R Markdown file, the PDF report, the bibliography file, and the dataset needed to reproduce the report.

- [`Final_ShinyApp/Final_app.R`](Final_ShinyApp/Final_app.R)   

  Contains the Shiny app file and the dataset needed to run the interactive app.

### How to View the Final Report

To view the final report, open the PDF file in the [`Final_Report/`](Final_Report/)  folder.

To reproduce the report, open the [`Final_Report/VTPEH 6270 - Final.Rmd`](Final_Report/VTPEH%206270%20-%20Final.Rmd) file in RStudio and knit it to PDF. The required dataset and bibliography file are included in the same folder.
## How to Run the Shiny App

1. Download or clone this repository.
2. Open [`Final_ShinyApp/Final_app.R`](Final_ShinyApp/Final_app.R) in RStudio.
3. Make sure the data file [`Nut_Data.csv`](Final_ShinyApp/Nut_Data.csv) is available in the [`Final_ShinyApp/`](Final_ShinyApp/) folder.

4. Install the required R packages if needed.
4. Install the required R packages if needed.
5. Run the app using:
```r
shiny::runApp("Final_ShinyApp")
```
Alternatively, open [`Final_ShinyApp/Final_app.R`](Final_ShinyApp/Final_app.R) in RStudio and click **Run App**.


## AI Tool Disclosure
ChatGPT was used to support generating R code, organizing the Shiny app structure, and troubleshooting during the development of this project. The final content, analysis, interpretation, and decisions were edited and reviewed by the author.

## References and Citations
References used in the written report are included in:
- [`Final_Report/cp06_references.bib`](Final_Report/cp06_references.bib)
