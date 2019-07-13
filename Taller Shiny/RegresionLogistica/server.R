shinyServer(function(input, output) {
  
  # Construccion del conjunto de datos aleatorio ----
  draw.sample <- reactive({
    # This gets called whenever the app is reloaded
    
  # Construccon de la variable de respuesta
    n.obs = 30
    true.a <- .75
    true.b <- 1.25
    
    x <- runif(n.obs, -5, 5)
    prob.x <- exp(true.a + true.b * x) / (1 + exp(true.a + true.b * x))
    y <- rbinom(n.obs, 1, prob.x)
    prob.data <- dbinom(y, 1, prob.x)
    
    model.summary <- summary(glm(y ~ x, family="binomial"))
    
    return(list(x=x, y=y, prob.x=prob.x, model.summary=model.summary))
    
  })
  
  # Calculo de los parametros del modelo ----
  regression <- reactive({
    
    data.vals <- draw.sample()
    x <- data.vals$x
    prob.x <- data.vals$prob.x
    y <- data.vals$y
    a <- input$intercept
    b <- input$slope
    
    prob.hat <- exp(a + b * x) / (1 + exp(a + b * x))
    prob.data = dbinom(y, 1, prob.hat)
    log.like <- sum(log(prob.data))
    
    if (input$logit){
      y <- log(prob.x / (1 - prob.x))
    }
    
    return(list(x=x, y=y, a=a, b=b,
                prob.data=prob.data,
                log.like=log.like))
    
  })
  
  # Grafico de los Datos ----
  output$reg.plot <- renderPlot({         
    
    reg.data <- regression()
    a <- reg.data$a
    b <- reg.data$b
    x <- reg.data$x
    y <- reg.data$y
    prob.data <- reg.data$prob.data
    
    x.vals <- seq(-5, 5, .01)
    if (input$logit){
      y.vals <- a + b * x.vals
      y.lim <- c(-6, 6)
    }
    else{
      y.vals <- exp(a + b * x.vals) / (1 + exp(a + b * x.vals))
      y.lim <- c(0, 1)
    }
    plot(x.vals, y.vals, type="l", lwd=3, col="dimgray",
         bty="n", xlim=c(-5, 5), ylim=y.lim, xlab="x", ylab="y",
         main="Logistic model Y ~ X")
    
    color.idx <- pmax(floor(prob.data * 10), 1)
    color.bin <- rev(brewer.pal(9, "RdPu"))[color.idx]
    points(x, y,  pch=21, cex=1.5, col="black", bg=color.bin)
    
    dv <- if(input$logit) "y" else "logit(y)"
    yloc <- if(input$logit) -3.6 else .2
    equation = sprintf("%s = %.3g + %.3g * x", dv, a, b)
    legend(1, yloc, equation, lty=1, lwd=2, bty="n")
    
  })
  
  # Grafico de la log-verosimilitud de la regresion ----
  output$like.plot <- renderPlot({
    
    reg.data <- regression()
    log.like <- reg.data$log.like
    
    plot(log.like, 1, cex=2, yaxt="n", bty="n", pch=16, col="#AE017E",
         xlim=c(-50, 0), ylab="", xlab="", main="Log-likelihood of the data")
    
  })
  
# Impresion del resumen del modelo ----
  output$summary <- renderPrint({
    
    if (input$summary){
      return(draw.sample()$model.summary)
    }
    
  })
  
})