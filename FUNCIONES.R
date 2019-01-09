# FUNCIONES

# Ejecuta libraries
library(quantmod)
library(tibble)
library(plyr)
library(Quandl)

# # Specify Working Directory where the other code and lists are
setwd("/home/ignacio/Desktop/Acciones")

# Get stock function
STOCK <- data.frame()
get.stock <- function(x){
    # Bajar la data pasada
    VAR <- as.data.frame(get(getSymbols(x)))
    VAR <- rownames_to_column(VAR, var = "Date")
    VAR$Date <- as.Date(VAR$Date)
    VAR <- VAR[,c(1,3,4,5,6)]
    VAR$Volat <- (VAR[,2]-VAR[,3])
    VAR$Perc.volat <- (((VAR[,6])*100)/VAR[,4])
    VAR$capital.volume <- VAR[,4]*VAR[,5]
    #agregar dia de la semana
    VAR$day <- weekdays(as.Date(VAR$Date))
    
    # Salvar en el global enviroment
    STOCK <<- VAR
}

# GET FULL METRICS
what_metrics <- yahooQF(c("Dividend/Share",
                          "Earnings/Share",
                          "EPS Estimate Current Year",
                          "EPS Estimate Next Year",
                          "EPS Estimate Next Quarter",
                          "Days Low",
                          "Days High",
                          "52-week Low",
                          "52-week High",
                          "Annualized Gain",
                          "Change From 52-week Low",
                          "Percent Change From 52-week Low",
                          "50-day Moving Average",
                          "Percent Change From 50-day Moving Average",
                          "200-day Moving Average",
                          "Percent Change From 200-day Moving Average",
                          "Price/Sales", 
                          "P/E Ratio",
                          "Price/EPS Estimate Next Year",
                          "Dividend Pay Date",
                          "PEG Ratio",
                          "Dividend Yield", 
                          "Market Capitalization",
                          "Price/EPS Estimate Current Year",
                          "Price/EPS Estimate Next Year",
                          "Short Ratio",
                          "1 yr Target Price",
                          "Dividend Yield"))

# Nota, si tipeas yahooQF() te da una lista de todo lo que podes buscar.

get.full.metrics <- function(x){
    metrics <<- getQuote(x, what=what_metrics)
}


# GET CLEAN METRICS
what_metrics <- yahooQF(c("Dividend/Share",
                          "Earnings/Share",
                          "P/E Ratio",
                          "Market Capitalization"))

# Nota, si tipeas yahooQF() te da una lista de todo lo que podes buscar.

get.clean.metrics <- function(x){
    metrics <<- getQuote(x, what=what_metrics)
    if (grepl("M",metrics[1,5]) == TRUE) {metrics$var[1] <- as.numeric(1000000)
    metrics[1,5] <- sub("M","",metrics[1,5])
    metrics$`Market Capitalization` = as.numeric(metrics$`Market Capitalization`)
    metrics[1,5] <- metrics[1,5]*metrics[1,6]
    metrics$var <- NULL}
    if (grepl("B",metrics[1,5]) == TRUE) {metrics$var[1] <- as.numeric(1000000000)
    metrics[1,5] <- sub("B","",metrics[1,5])
    metrics$`Market Capitalization` = as.numeric(metrics$`Market Capitalization`)
    metrics[1,5] <- metrics[1,5]*metrics[1,6]
    metrics$var <- NULL}
    metrics <<- metrics
}

# GET STOCK VOLATILITY
get.stock.volatility <- function(x,n){
    get.stock(x)
    
    data <- STOCK[(nrow(STOCK)-n):nrow(STOCK),]
    DATA <<- data
    volat.mean <<- mean(DATA[DATA[,5]!=0,7])
    volat.weighted.mean <<- weighted.mean(DATA[,7],DATA[,5])
    capital.volume.mean <<- mean(DATA[DATA[,5]!=0,8])
    volatility.matrix <<- data.frame(Stock = sub("\\.High","",colnames(DATA)[2]), 
                                     weighted.volat = weighted.mean(DATA[,7],DATA[,5]),
                                     volat = mean(DATA[DATA[,5]!=0,7]),
                                     capital.volume = mean(DATA[DATA[,5]!=0,8]))
    
}

# GET STOCK PERCENTAGE CHANGE

get.stock.change <- function(x,n){
    get.stock(x)
    
    data <- STOCK[(nrow(STOCK)-n):nrow(STOCK),]
    DATA <<- data
    #FALTA DEFINIR EL RESTO, TENES QUE VER COMO HACES PARA VER CUANTO CAMBIO LA ACCION
}

# GET DAY OF THE WEEK MEAN
get.dayoftheweek.mean <- function(x){
    get.stock(x)
    TEMPDAT <- STOCK
    dayoftheweekmean.var <- data.frame(Stock = as.character(colnames(TEMPDAT)[4]),
                                       Monday= mean(TEMPDAT[grep("Monday",TEMPDAT$day),4]), 
                                       Tuesday = mean(TEMPDAT[grep("Tuesday",TEMPDAT$day),4]),
                                       Wednesday= mean(TEMPDAT[grep("Wednesday",TEMPDAT$day),4]),
                                       Thursday= mean(TEMPDAT[grep("Thursday",TEMPDAT$day),4]),
                                       Friday= mean(TEMPDAT[grep("Friday",TEMPDAT$day),4]))
    STOCK.DAYWEEK.MEANS <<- dayoftheweekmean.var
}


# CLEAN DATA - SIRVE PARA MINING
clean.data <- function(x,y){
    x <- as.data.frame(x)
    x <- rownames_to_column(x, var = "Date")
    x$Date <- as.Date(x$Date)
    x <- x[,c(1,5)]
    colnames(x)[2] <- sub("\\.Close","",colnames(x)[2])
    assign(y,x,envir=.GlobalEnv)
}
