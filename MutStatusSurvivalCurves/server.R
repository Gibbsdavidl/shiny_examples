
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(bigrquery)
library(survival)
library(survminer)
library(googleAuthR)
library(bigQueryR)

options("googleAuthR.scopes.selected" = c("https://www.googleapis.com/auth/bigquery"))
options("googleAuthR.webapp.client_id" = "get_this_from_your_cloud_console_under_Credentials_OAuth 2.0 client IDs.apps.googleusercontent.com")
options("googleAuthR.webapp.client_secret" = "get_from_cloud_console")

server <- function(input, output, session){
  ## Create access token and render login button
  access_token <- callModule(googleAuth, "loginButton", approval_prompt = "force")
  
  outputPlot <- eventReactive(input$submit,{
    ## wrap existing function with_shiny
    ## pass the reactive token in shiny_access_token
    ## pass other named arguments
    project  <- as.character(input$projectid)
    cohort   <- as.character(input$cohortid)
    varname  <- input$varname
    
    if(is.null(access_token())) {
      errorPlot()
    } else {
      with_shiny(f = drawPlot, shiny_access_token = access_token(), project, cohort, varname)
    }
    
  })
  
  output$plot <- renderPlot({outputPlot()}, width=600, height=500) 
}

# shiny::runApp(launch.browser = T, port = 6984)
