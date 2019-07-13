library(shiny)

fig.width <- 600
fig.height <- 450

shinyUI(pageWithSidebar(
  
  headerPanel("Regresión Logísitca Simple"),
  
  sidebarPanel(
    
    div(p("Encuentro los valores de la pendiente y el intercepto que maximice la verosimilitud")),
    div(
      
      sliderInput("intercept",
                  strong("Intercepto"),
                  min=-3, max=3, step=.25,
                  value=sample(seq(-3, 3, .25), 1), ticks=FALSE),
      br(),
      sliderInput("slope", 
                  strong("Pendiente"),
                  min=-3, max=3, step=.25, 
                  value=sample(seq(-2, 2, .25), 1), ticks=FALSE),
      br(),
      checkboxInput("logit",
                    strong("Grafica con Funcion de enlace logit"),
                    value=FALSE),
      br(),
      checkboxInput("summary",
                    strong("Mostrar Resumen (glm(y ~ x))"),
                    value=FALSE)
      
    )
  ),
  
  mainPanel(
    plotOutput("reg.plot", width=fig.width, height=fig.height),
    plotOutput("like.plot", width=fig.width, height=fig.height / 3),
    div(class="span7", conditionalPanel("input.summary == true",
                                        p(strong("GLM Summary")),
                                        verbatimTextOutput("summary")))
  )
  
))
