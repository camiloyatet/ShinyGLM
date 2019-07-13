shinyUI(fluidPage(
  
  titlePanel("Análisis de Influencia"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Esta aplicación demuetra la influencia o apalancamiento de un punto ajustable de un conjunto de datos normalmente distribuidos. Seleccione
                las coordenbadas del punto X y Y con los siguientes sliders con rangos entre [-10,10]. El punto ajustable se muetra en rojo"),
      #X value
      sliderInput("xx", "X",
                  min=-10, max=10, value=0),
      #Y value
      sliderInput("yy", "Y",
                  min=-10, max=10, value=0)
    ),
    
    
    mainPanel(
      plotOutput("RegPlot"),
      h4(htmlOutput("CoefTitle")),
      tableOutput("coef"),
      h4(htmlOutput("measTitle")),
      tableOutput("meas")
    )
  )
))