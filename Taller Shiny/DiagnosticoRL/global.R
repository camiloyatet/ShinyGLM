library(shiny)
library(openintro)
library(plotrix)


draw.data <- function(type){
  n <- 250
  if(type=="LinealCreciente"){
    x <- c(runif(n-2, 0, 4), 2, 2.1)
    y <- 2*x + rnorm(n, sd=2)
  }
  if(type=="LinealDecreciente"){
    x <- c(runif(n-2, 0, 4), 2, 2.1)
    y <- -2*x + rnorm(n, sd=2)
  }
  if(type=="CurvaAscendente"){
    x <- c(runif(n-2, 0, 4), 2, 2.1)
    y <- 2*x^4 + rnorm(n, sd=16)
  }
  if(type=="CurvaDescendente"){
    x <- c(runif(n-2, 0, 4), 2, 2.1)
    y <- -2*x^3 + rnorm(n, sd=9)
  }
  if(type=="Abanico"){
    x = seq(0,3.99,4/n)
    y = c(rnorm(n/8,3,1),rnorm(n/8,3.5,2),rnorm(n/8,4,2.5),rnorm(n/8,4.5,3),rnorm(n/4,5,4),rnorm((n/4)+2,6,5))
  }
  data.frame(x=x,y=y)
}