
library(shiny)
library(plotly)
library(heatmaply)


source("global.R")

ui <- fluidPage(
  titlePanel(title=div(img(src="half_isb_logo.png"), "Immune-related Gene Set Correlation-Heatmaply (MSigDB C7)")),
  helpText(HTML("<strong>Hit submit to call Google BigQuery. In the heatmap, select an area to zoom.<strong>")),
  sidebarLayout(
    sidebarPanel(
      selectInput("var1", "Gene Set 1", getGeneSets(), selected ="GSE40685_NAIVE_CD4_TCELL_VS_TREG_UP"),
      selectInput("var2", "Gene Set 2", getGeneSets(), selected = "GSE40685_NAIVE_CD4_TCELL_VS_TREG_DN"),
      getTCGAProjs(),
      checkboxInput("showlabels", "Show Labels", value=T),
      checkboxInput("clustercols", label = "Cluster Columns", value = T),
      checkboxInput("clusterrows", label = "Cluster Rows", value = T),
      selectInput("seriate", "Gene Ordering Method", c("OLO", "GW", "mean", "none"), selected = "GW"),
      selectInput("hclust_method", "Hclust Method", c("ward.D", "ward.D2", "single",
                                                      "complete", "average", "mcquitty", 
                                                      "median", "centroid"), selected="ward.D2"),
      actionButton(inputId="submit",label = "Submit")
    ),
  
    mainPanel(
      tags$head(
        tags$style(# thanks BigDataScientist @ stackoverflow!
          HTML(".shiny-notification { 
               height: 50;
               width: 400px;
               position:fixed;
               top: calc(50% - 50px);;
               left: calc(50% - 200px);;
               }
               "
            )
          )
        ),
      plotlyOutput("plot", height = "600px")
    )
  ),
  br(),
  helpText("What's going on here? The genes belonging to two immune-related gene sets are used to compute Spearman correlation on RNA-seq data from a given type of cancer. It's a visualization of the relationship between two gene sets."),
  helpText("Heatmaply: Tal Galili, Alan O'Callaghan, Jonathan Sidi, Carson Sievert; heatmaply: an R package for creating interactive cluster heatmaps for online publishing, Bioinformatics, , btx657, https://doi.org/10.1093/bioinformatics/btx657"),
  helpText("Gene sets: Molecular Signatures Database (MSigDB), C7 collection. Subramanian, Tamayo, et al. (2005, PNAS 102, 15545-15550) http://software.broadinstitute.org/gsea/msigdb"),
  helpText("Made in", a("Shiny", href="http://shiny.rstudio.com/"), " using ", a("google bigquery, bigrquery, heatmaply, and plotly"))
)

