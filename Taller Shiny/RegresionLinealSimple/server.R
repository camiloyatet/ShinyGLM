shinyServer(function(input, output) {

### Base de datos reactivas ----  
generar.muestra <- reactive({
    n.obs = 50
    x <- rnorm(n.obs, 0, 2)
    y <- 2 + x + rnorm(n.obs, 0, 1)
    
    resumen <- summary(lm(y ~ x))
    
    return(list(x=x, y=y, model.summary=resumen))
  })
regresion <- reactive({
    
    data.vals <- generar.muestra()
    x <- data.vals$x
    y <- data.vals$y
    a <- input$intercept
    b <- input$slope
    
    if (a == 2 & b == 1) resid.color <- "seagreen" else resid.color <- "firebrick"
    
    yhat <- input$intercept + x * input$slope
    resid <- y - yhat
    
    ss.res <- sum(resid ** 2)
    resid.best <- y - (2 + x)
    ss.res.best <- sum(resid.best ** 2)
    
    r2 <- 1 - (ss.res / sum((y - mean(y)) ** 2))
    
    return(list(x=x, y=y, yhat=yhat, a=a, b=b, r2=r2,
                resid=resid, ss.res=ss.res, ss.res.best=ss.res.best,
                resid.color=resid.color))
    
  })
  
### Diagrama de dispersion ----
output$reg.plot <- renderPlot({         
    
    reg.data <- regresion()
    a <- reg.data$a
    b <- reg.data$b
    x <- reg.data$x
    y <- reg.data$y
    r2 <- reg.data$r2
    resid <- reg.data$resid
    
    mask <- x > -4.5 & x < 4.5 & y > -3 & y < 8
    x <- x[mask]
    y <- y[mask]
    resid <- resid[mask]
    
    plot(c(-4.5, 4.5), c(a + b * -4.5,  a + b * 4.5), type="l", lwd=2,
         bty="n", xlim=c(-5, 5), ylim=c(-3, 8), xlab="x", ylab="y",
         main="Modelo Lineal Y ~ X")
    
    for (i in 1:length(resid)){
      lines(c(x[i], x[i]), c(y[i], y[i] - resid[i]),
            col=reg.data$resid.color, lwd=1.5)
    }
    
    points(x, y,  pch=16, col="#444444")
    
    legend(-5, 8, sprintf("y = %.3g + %.3g * x", a, b), lty=1, lwd=2, bty="n")
    
  })
  
### Suma de cuadrados ----
output$ss.plot <- renderPlot({
    
    reg.data <- regresion()
    ss.res <- reg.data$ss.res
    ss.res.best <- reg.data$ss.res.best
    resid.color <- reg.data$resid.color
    
    plot(ss.res, 1, col=resid.color, cex=2,
         yaxt="n", bty="n", xlim=c(0, 1000),
         ylab="", xlab="", main="Suma de los Cuadrados de los Residuales")
    points(ss.res.best, 1, pch=4, cex=2)
    
  })
  
### Distribucion de residuales ----
  output$resid.plot <- renderPlot({
    
    reg.data <- regresion()
    resid <- reg.data$resid
    resid <- resid[resid > -5 & resid < 5]
    
    hist(resid, seq(-5, 5, .5), prob=TRUE, col="#bbbbbb",
         xlim=c(-5, 5), ylim=c(0, dnorm(0) * 1.5),
         yaxt="n", bty="n", ylab="", xlab="", main="Distribucion de los Residuales")
    rug(resid, lwd=2)
    
    curve(dnorm, col=reg.data$resid.color, lwd=2, add=TRUE)
    
  })
  
### Impresion del Resumen de la regresion ----
  output$summary <- renderPrint({
    
    if (input$summary){
      return(generar.muestra()$model.summary)
    }
    
  })
})