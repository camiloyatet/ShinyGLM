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
    h3('Ejemplo de Outputs'),
    h4('Numero Ingresado'),
    verbatimTextOutput("o_id1"),
    h4('Valor Checkbox'),
    verbatimTextOutput("o_id2"),
    h4('Fecha Ingresada'),
    verbatimTextOutput("o_fecha")
  )
))

server <- shinyServer(
  function(input, output) {
    output$o_id1 <- renderPrint({input$id1})
    output$o_id2 <- renderPrint({input$id2})
    output$o_fecha <- renderPrint({input$Fecha})
  }
)

shinyApp(ui, server)