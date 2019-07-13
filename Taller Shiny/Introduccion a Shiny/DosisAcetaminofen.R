library(shiny)
ui <-shinyUI(
  pageWithSidebar(
    # Application title
    headerPanel("Cálculo de Dósis Acetaminofén"),
    
    sidebarPanel(
      numericInput('Peso', 'Peso del Paciente en kilos', 80, min = 18, max = 150, step = 1),
                   submitButton('Aplicar')
      ),
                   mainPanel(
                   h3('Resultado de la dosis'),
                   h4('Peso del paciente'),
                   verbatimTextOutput("inputValue"),
                   h4('la dosis recomendada es: '),
                   verbatimTextOutput("prediction")
                   )
    )
    )

dosis <- function(peso) peso * 60

server <- shinyServer(
  function(input, output) {
    output$inputValue <- renderPrint({input$Peso})
    output$prediction <- renderPrint({paste(dosis(input$Peso), "mg")})
  }
)

shinyApp(ui, server)