#----
# Code for the Open MetaPipeline Shiny App
# https://nicholas-coles.shinyapps.io/scripts/

# clear R environment
rm(list = ls())

#----
# Load packages
library("shiny")
library("metafor")
library("googlesheets")
library("ggplot2")
library("DT")
library("shinythemes")
library("shinydashboard")
library("weightr")

#----
# Load, prep, and analyze data by calling 'meta.pipeline.analyses.R' script
# Note: results will be saved in a vector called 'results'
source("meta.pipeline.analyses.R")

#----
# Prep funnel plot by calling "meta.pipeline.funnel.R' script
# Note: funnel plot will be saved in an object called 'fun.plot'
# Note: being lazy right now and creating a seperate funnel for the moderator analyses, but the code should be reactive in the future
source("meta.pipeline.funnel.R")
source("meta.pipeline.funnel.mod.R")

#----
# Load list of messages that will appear in app by calling "meta.pipeline.funnel.R' script
source("meta.pipeline.msgs.R")

#----
# Shiny UI
ui <- dashboardPage(
  dashboardHeader(title = "Open MetaPipeline"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem(text = "Home", tabName = "home", icon = icon("home")
               ),
      menuItem(text = "Contributors", tabName = "contributors", icon = icon("user") )
      )
  ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "home",
              
              fluidRow(
                box(title = "Welcome!", status = "primary", width = "12",
                    msg$welcome,
                    uiOutput("link")
                )
              ),
              
              fluidRow(
                box(title = "Funnel plot", status = "warning",
                    plotOutput(outputId = "funnel", click ="plot_click"),
                    actionButton(inputId = "funnel_info", label = "What is a funnel plot?")
                    ),
                
              tabBox(title = "Results", side = "right", selected = "Overall effect",
                       
                       tabPanel(title = "Publication bias", 
                                msg$bias,
                                tags$br(),
                                actionButton(inputId = "bias_info", label = "Show methodological details")
                       ),
                       
                       tabPanel(title = "Moderator analyses", 
                                selectInput(inputId = "mod", label = "Moderator",
                                            choices = c("---", "Type of cognitive test")
                                ),
                                htmlOutput("mod.results"),
                                tags$br(),
                                actionButton(inputId = "mod_info", label = "Show methodological details")
                       ),
                       
                       tabPanel(title = "Overall effect",
                                msg$oval,
                                actionButton("oval_info", "Show methodological details")
                       )
                )
              ),
              
              fluidRow(
                box(title = "Want more details regarding a datapoint in the funnel plot? 
                            Click on the datapoint, and the data will appear here.",
                    status = "warning", width = "12",
                    dataTableOutput(outputId = "table")
                    )
              )
      ),
      
      tabItem(tabName = "contributors",
              
              fluidRow(
                box(title = "Shiny app developers", status = "primary", width = "12",
                    msg$cont.dev
                  ),
                
                box(title = "Contributors to the open meta-analytic database", status = "warning",
                    msg$cont.db
                ),
                
                box(title = "Researchers from articles included in the meta-analysis", status = "warning",
                    msg$cont.auth
                )
              )
              
      )
    )
  )
)
              
#----
# Shiny server
server <- function(input, output) {
  output$funnel <- renderPlot({
    if (input$mod == "Type of cognitive test"){
      fun.plot.mod
    } else {
      fun.plot
    }
  })
  
  observeEvent(input$funnel_info, {
    showModal(modalDialog(title = "Show methodological details",
                          msg$funnel.info)
             )
  })
  
  observeEvent(input$mod_info, {
    showModal(modalDialog(title = "Moderator Analyses", size = "m",
                          msg$mod.info)
             )
  })
  
  observeEvent(input$oval_info, {
    showModal(modalDialog(title = "Meta-Analytic Approach", size = "l",
                          msg$oval.info)
              )
  })
  
  
  observeEvent(input$bias_info, {
    showModal(modalDialog(title = "Meta-Analytic Approach", size = "m",
                          msg$bias.info
                          )
              )
  })
  
  
  output$table <- DT::renderDataTable(nearPoints(DF, input$plot_click),
                                      options = list(sDom = '<"top"><"bottom">'))
  
  output$mod.results <- renderUI({
    if (input$mod == "Type of cognitive test"){
      msg$mod.test
    }
  })
  
  output$link <- renderUI({
    tagList(a("View and add to dataset", 
              href = "https://docs.google.com/spreadsheets/d/1bdFWlMgK9me4LFYxS14cf8MQjVUayG2Iw_HjEQPRxhk/edit?usp=sharing")
            )
    })
}

# Shiny app
shinyApp(ui, server)