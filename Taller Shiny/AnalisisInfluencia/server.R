shinyServer(function(input, output) {
  
  # Generacion de conjuntos aleatorios ----
  set.seed(1523)
  n <- 100
  x1 <- rnorm(n) ; x1<-x1-mean(x1) #center the data
  y1 <- rnorm(n) ; y1<-y1-mean(y1)
  
  # Datos de rectividad ----
  xyCoord<-reactive({
    xy<-c(input$xx,input$yy)
    as.numeric(xy)
  })
  
  # Adicion del punto movil ----
  datxy<-reactive({
    datX<-c(xyCoord()[1],x1)
    datY<-c(xyCoord()[2],y1)
    data.frame(X=datX,Y=datY)
  })
  
  # Grafica de dispersión ----
  output$RegPlot<-renderPlot({
    ggplot(datxy(),aes(x=X,y=Y))+
      geom_point(aes(colour=(X==xyCoord()[1]& Y==xyCoord()[2])),
                 size=3,
                 alpha=0.5
      )+
      geom_smooth(method = "lm", se = FALSE)+
      coord_cartesian(xlim=c(-10,10),
                      ylim=c(-10,10))+
      scale_colour_manual(name = '',
                          values = c('black','red'))+
      guides(colour=F)
  })
  
# Ajuste del modelo Lineal ----
  fitModel<-reactive({
    lm(Y~X, data=datxy())
  })
  
# Resumen del modelo ----
  fitCoef<-reactive({
    data.frame(Coefficient=c("Intercepto",
                             "Pendiente"),
               Value=as.character(c(round(coef(fitModel())[1],5),
                                    round(coef(fitModel())[2],5))
               )
    )
  })
  
# Calculo de las medida de influencia ----
  measures<-reactive({
    #hatvalue for the selected point
    hv1<-reactive({
      hatvalues(fitModel())[1]
    })
    
    resid1<-reactive({
      resid(fitModel())[1]
    })
    
    #dfbeta for the slope
    dfb1<-reactive({
      dfbetas(fitModel())[,1][1] 
    })
    
    #dfbeta for the slope
    dfbx<-reactive({
      dfbetas(fitModel())[,2][1] 
    })
    
    data.frame(
      Measure=c("ValorHat",
                "Residual",
                "dfbeta.1",
                "dfbeta.x"),
      Value=as.character(c(round(hv1(),5),
                           round(resid1(),5),
                           round(dfb1(),5),
                           round(dfbx(),5))
      )
    )
    
  })
  
  output$CoefTitle<-renderText({
    paste("Coeficientes de la regresion lineal")
  })
  
  output$coef<-renderTable({
    fitCoef()
  })
  
  output$measTitle <- renderText({
    paste("Influence measures for the adjustable point")
  })
  
  output$meas<-renderTable({
    measures()
    
  })
})