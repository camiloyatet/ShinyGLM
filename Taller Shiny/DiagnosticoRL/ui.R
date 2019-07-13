ui <- pageWithSidebar(
  
  headerPanel("Diagnostico del modelo lineal"),
  
  sidebarPanel(
    
    radioButtons("type", "Seleccione una Tendencia:",
                 list("Lineal Creciente" = "LinealCreciente",
                      "Lineal Decreciente" = "LinealDecreciente",
                      "Curva Ascendente" = "CurvaAscendente",
                      "Curva Descendente" = "CurvaDescendente",
                      "Abanico" = "Abanico")),
    br(),
    checkboxInput("show.resid", "Mostrar Residuales", FALSE),
    br(),
    helpText("Esta aplicacion usa minimos cuadrados ordinarios  con el fin  de verificar los supuestos de la regresion en conjuntos de datos con tendencias marcadas")
    ),
  
  mainPanel(
    plotOutput("scatter"),
    br(),
    br(),
    plotOutput("residuals")
  )
)