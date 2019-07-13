server <- function(input, output) {
  
# Datos reactivos ----
  mydata <- reactive({
    draw.data(input$type)
  })
  
  lmResults <- reactive({
    regress.exp <- "y~x"
    lm(regress.exp, data=mydata())
  })
  
# Grafica de dispersion del conjunto de datos ----
  output$scatter <- renderPlot({
    data1 <- mydata()
    x <- data1$x
    y <- data1$y
    
    # For confidence interval
    xcon <- seq(min(x) - 0.1, max(x) + 0.1, 0.025)
    
    predictor <- data.frame(x=xcon)
    
    yhat <- predict(lmResults())    
    yline <- predict(lmResults(), predictor)
    
    par(cex.main=1.5, cex.lab=1.5, cex.axis=1.5, mar = c(4,4,4,1))
    
    r.squared = round(summary(lmResults())$r.squared, 4)
    corr.coef = round(sqrt(r.squared), 4)
    
    plot(c(min(x),max(x)) 
         ,c(min(y,yline),max(y,yline)), 
         type="n",
         xlab="x",
         ylab="y",
         main=paste0("RModelo de Regresion\n","(R = ", corr.coef,", ", "R-cuadrado = ", r.squared,")"))
    
    
    newx <- seq(min(data1$x), max(data1$x), length.out=400)
    confs <- predict(lmResults(), newdata = data.frame(x=newx), 
                     interval = 'confidence')
    preds <- predict(lmResults(), newdata = data.frame(x=newx), 
                     interval = 'predict')
    
    polygon(c(rev(newx), newx), c(rev(preds[ ,3]), preds[ ,2]), col = grey(.95), border = NA)
    polygon(c(rev(newx), newx), c(rev(confs[ ,3]), confs[ ,2]), col = grey(.75), border = NA)
    
    points(x,y,pch=19, col=COL[1,2])
    lines(xcon, yline, lwd=2, col=COL[1])
    
    if (input$show.resid) for (j in 1:length(x)) 
      lines(rep(x[j],2), c(yhat[j],y[j]), col=COL[4])
    
    legend_pos = ifelse(lmResults()$coefficients[1] < 1, "topleft", "topright")
    if(input$type == "linear.down") legend_pos = "topright"
    if(input$type == "fan.shaped") legend_pos = "topleft"   
    legend(legend_pos, inset=.05,
           legend=c("Linea de Regresion", "Intervalo de Confianza", "Intervalo de Prediccion"), 
           fill=c(COL[1],grey(.75),grey(.95)))
    box()
  })
  
  # Graficos de residuales ----
  output$residuals <- renderPlot({
    par(mfrow=c(1,3), cex.main=2, cex.lab=2, cex.axis=2, mar=c(4,5,2,2))
    residuals = summary(lmResults())$residuals
    predicted = predict(lmResults(), newdata = data.frame(x=mydata()$x))
    plot(residuals ~ predicted, 
         main="Residuales vs. Valores Ajustados", xlab="Valores Ajustados", ylab="Residuales", 
         pch=19, col = COL[1,2])
    abline(h = 0, lty = 2)
    d = density(residuals)$y
    h = hist(residuals, plot = FALSE)
    hist(residuals, main="Histograma de Residuales", xlab="Residuales", 
         col=COL[1,2], prob = TRUE, ylim = c(0,max(max(d), max(h$density))))
    lines(density(residuals), col = COL[1], lwd = 2)
    qqnorm(residuals, pch=19, col = COL[1,2], main = "Grafico Q-Q de Residuales")
    qqline(residuals, col = COL[1], lwd = 2)
  }, height=280 )
}