
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(googleAuthR)

ui <- fluidPage(
  
  tags$head(
    tags$style(HTML('
                    #sidebar {
                    background-color: #ffffff;
                    }
                    
                    body, label, input, button, select { 
                    font-family: "Arial";
                    }') )
    ),
  sidebarLayout(
    sidebarPanel(id="sidebar",
                 img(src="half_isb_logo.png")
    ),
    mainPanel(
      h3(""),
      h3(""),
      h3("Kaplan-Meier survival curves based on mutation status"),
      ("This shiny app visualizes the difference in survival times depending on gene mutation status.  The ISB-CGC BigQuery tables queried include isb-cgc.TCGA_hg38_data_v0.Somatic_Mutation and isb-cgc.TCGA_bioclin_v0.Clinical tables.
        The cohorts are defined using project_short_names like TCGA-LAML.  Some gene Symbols to try include TP53, GATA3, BRCA1, PTEN, ERBB2, PIK3CA, RB1.  Mutation status defined as: Variant_Classification != 'Silent' AND Variant_Type = 'SNP' AND IMPACT != 'LOW'.  Please see: http://isb-cancer-genomics-cloud.readthedocs.io/en/latest/sections/QueryOfTheMonthClub.html")
     )
  ),
  sidebarLayout(
    sidebarPanel(
      hr(),
      googleAuthUI("loginButton"),
      hr(),
      textInput("projectid", "Project ID", value = "isb-cgc-xy-abcd", placeholder = "isb-cgc-xy-abcd"),
      
      selectInput("cohortid", label = "Cohort", 
                  choices = list(
                    "TCGA-ACC"="TCGA-ACC",
                    "TCGA-BLCA"="TCGA-BLCA",
                    "TCGA-BRCA"="TCGA-BRCA",
                    "TCGA-CESC"="TCGA-CESC",
                    "TCGA-CHOL"="TCGA-CHOL",
                    "TCGA-COAD"="TCGA-COAD",
                    "TCGA-DLBC"="TCGA-DLBC",
                    "TCGA-ESCA"="TCGA-ESCA",
                    "TCGA-GBM"="TCGA-GBM",
                    "TCGA-HNSC"="TCGA-HNSC",
                    "TCGA-KICH"="TCGA-KICH",
                    "TCGA-KIRC"="TCGA-KIRC",
                    "TCGA-KIRP"="TCGA-KIRP",
                    "TCGA-LAML"="TCGA-LAML",
                    "TCGA-LIHC"="TCGA-LIHC",
                    "TCGA-LGG"="TCGA-LGG",
                    "TCGA-LUAD"="TCGA-LUAD",
                    "TCGA-LUSC"="TCGA-LUSC",
                    "TCGA-MESO"="TCGA-MESO",
                    "TCGA-OV"="TCGA-OV",
                    "TCGA-PAAD"="TCGA-PAAD",
                    "TCGA-PCPG"="TCGA-PCPG",
                    "TCGA-PRAD"="TCGA-PRAD",
                    "TCGA-READ"="TCGA-READ",
                    "TCGA-SARC"="TCGA-SARC",
                    "TCGA-SKCM"="TCGA-SKCM",
                    "TCGA-STAD"="TCGA-STAD",
                    "TCGA-THYM"="TCGA-THYM",
                    "TCGA-THCA"="TCGA-THCA",
                    "TCGA-TGCT"="TCGA-TGCT",
                    "TCGA-UCS"="TCGA-UCS",
                    "TCGA-UCEC"="TCGA-UCEC",
                    "TCGA-UVM"="TCGA-UVM"
                  ),selected = "TCGA-GBM") ,
      
      #textInput("cohortid", "Cohort ID", value = "TCGA-BRCA", placeholder = "TCGA-BRCA"),
      
      textInput("varname",  "Gene Symbol", value = "IDH1", placeholder = "IDH1"),
      actionButton(inputId="submit",label = "Submit")
    ),
    mainPanel(
      plotOutput("plot")
    )
  ), # end sidebar layout
  hr()
    )
