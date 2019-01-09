# LOAD LISTS

# Specify Working Directory where the other code and lists are
setwd("/home/ignacio/Desktop/Acciones")

# Load NYSE Symbol Data
NYSE <- read.table("NYSE.txt", header = TRUE, sep = "\t", quote = "")
NYSE <- NYSE[-grep("-",NYSE[,1]),]
NYSE <- NYSE[-grep("\\.",NYSE[,1]),]
NYSE <- NYSE[-grep("BGX|^F$|^I$|^T$|SCQ",NYSE[,1]),]
row.names(NYSE) <- 1:nrow(NYSE)

NYSE.names <- as.character(NYSE$Symbol)
NYSE.symbols <- lapply(NYSE.names, function(x) as.name(x))
NYSE.list <- as.data.frame(cbind(NYSE.symbols,NYSE.names))

# Load LSE Symbol Data
LSE <- read.table("LSE.txt", header = TRUE, sep = "\t", quote = "")
LSE <- LSE[-grep("0|1|2|3|4|5|6|7|8|9",LSE[,1]),]
LSE$Symbol <- interaction(LSE$Symbol,".L",sep = "")
LSE <- LSE[-grep("AASDIGEQ.L|ABTU.L|ACDAPR.L|ACDER.L|ACDXUSR.L|ACID.L|
                 ACNAN.L|ACNANCH.L|ACNANEU.L|ACNANUK.L|ACNAN.L|ACXUSS.L|AGAP.L|
                 ASEANAS.L|ASEANEM.L|ASEANSTR.L|ASEANAS.L|ASDV.L",LSE[,1]),]
row.names(LSE) <- 1:nrow(LSE)


LSE.names <- as.character(LSE$Symbol)
LSE.symbols <- lapply(LSE.names, function(x) as.name(x))

#NYSE, AMEX, NASDAQ
require(TTR)
NYSEAMEXNASDAQ <- TTR::stockSymbols()
#Fetching AMEX symbols...
#Fetching NASDAQ symbols...
#Fetching NYSE symbols...
table(NYSEAMEXNASDAQ$Exchange)

# TODO FUCKING YAHOO
# allyahootickers <- read.xlsx("yahootickers.xlsx", rowNames = TRUE)
# allyahootickers <- rownames_to_column(allyahootickers, var = "Symbol")
# allyahootickers <- allyahootickers[-grep("@",allyahootickers[,1]),]
# allyahootickers <- allyahootickers[order(allyahootickers$Symbol),]
# row.names(allyahootickers) <- 1:nrow(allyahootickers)
