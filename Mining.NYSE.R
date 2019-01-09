# NYSE MINING

# Specify Working Directory where the other code and lists are
setwd("/home/ignacio/Desktop/Acciones")


# Source functions et alia
source("FUNCIONES.R") #This file contains some data cleaning and formating functions defined for the specific case.
source("LOADLISTS.R") #This file processes lists of stock symbols from NYSE, LSE, and others. They might be outdated.

## LOAD AND PROCESS DATA

# The first bit processes some stocks that sometimes throw error.
getSymbols("F")
clean.data(F,"F")
TODO.NYSE <- F
getSymbols("I")
clean.data(I,"I")
TODO.NYSE <- merge(TODO.NYSE,I,by = "Date", all = TRUE)
getSymbols("T")
clean.data(T,"T")
TODO.NYSE <- merge(TODO.NYSE,T,by = "Date", all = TRUE)
rm(list = c("F","I","T"))
Sys.sleep(5)

# Now that we have a list of all NYSE symbols, we proceed to download the data from all of them and store them in the TODO.NYSE.csv file
# Stocks that throw error are skipped using the tryCatch function.
# This process can take a while.
for (i in 1:length(NYSE.names)){
   tryCatch({getSymbols(NYSE.names[i])
    clean.data(NYSE.symbols[i],NYSE.names[i])
    TODO.NYSE <- merge(TODO.NYSE,get(NYSE.names[i]),by = "Date", all = TRUE)
    rm(list = NYSE.names[i])}
    , error=function(e) NULL)
}

write.csv(TODO.NYSE,"TODO.NYSE.csv")
