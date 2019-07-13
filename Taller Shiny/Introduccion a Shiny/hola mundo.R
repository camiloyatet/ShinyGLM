library(shiny)
ui <-shinyUI(pageWithSidebar(
  headerPanel("Inputs en R"),
  sidebarPanel(
    numericInput('id1', 'Input Numérico 1', 0, min = 0, max = 10, step = 1),
    checkboxGroupInput("id2", "Checkbox",
                       c("Valor 1" = "1",
                         "Valor 2" = "2",
                         "Valor 3" = "3")),
    dateInput("Fecha", "Date:")  
  ),
  mainPanel(
    
  )
))

server <- shinyServer(
  function(input, output) {
      }
  )

shinyApp(ui, server)