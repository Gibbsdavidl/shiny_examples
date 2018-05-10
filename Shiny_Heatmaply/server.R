library(shiny)
library(bigrquery)
library(plotly)
library(heatmaply)
library(ggplot2)
library(reshape2)


server <- function(input, output, session) {

  bqdf <- matrix(rnorm(100), nrow=10)
  
  # calling BigQuery
  bq_data <- eventReactive(input$submit, {
    load("data/gene_set_hash.rda")
    geneNames1 <- getGenes(sethash, input$var1)
    geneNames2 <- getGenes(sethash, input$var2)
    cohort <- input$cohortid
    sql <- buildQuery(geneNames1, geneNames2, cohort)
    service_token <- set_service_token("data/isb-cgc-bq-bc83824b46ad.json")
    data <- query_exec(sql, project='isb-cgc-bq', useLegacySql = F)
    data
  })
  
  output$plot <- renderPlotly({
    
    withProgress(message = 'Working...', value = 0, {
      incProgress()
      # first make the bigquery 
      bqdf <- bq_data()
      incProgress()
      
      # then build the correlation matrix
      df <- buildCorMat(bqdf)
      incProgress()
      
      # then get the heatmap options
      cluster_cols <- as.logical(input$clustercols)
      cluster_rows <- as.logical(input$clusterrows)

      # color scheme
      incProgress()
      rwb <- colorRampPalette(colors = c("blue", "white", "red"))
      heatmaply(df, 
              main = 'gene-gene spearman correlations', 
              Colv=cluster_cols, Rowv=cluster_rows,
              colors = rwb, seriate=input$seriate,
              hclust_method = input$hclust_method,
              showticklabels = as.logical(input$showlabels),
              margins = c(150,200,NA,0)) 
    })
  })
  
  output$event <- renderPrint({
    d <- event_data("plotly_hover")
    if (is.null(d)) "Hover on a point!" else d
  })
}


# shiny::runApp(launch.browser = T, port = 6984)
