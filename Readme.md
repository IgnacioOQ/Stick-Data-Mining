# Downloading all NYSE data

And also have it in a more or less clean state.

## Composition

This is an early project so the code is quite inelegant.
The project has five files. 
Two of them are lists of symbols, one from the New York Stock Exchange (NYSE) and another from the London Stock Exchange (LSE).
The other three are in R. Since this is an early project, they are not R Markdown, but they are helpfully commented.
LOADLISTS.R does exactly what it says, plus some cleaning of the lists.
FUNCIONES.R defines a series of functions that are later used mostly to clean the data series.
Mining.NYSE.R downloads the prices from all of the stock symbols available using quantmod (errors are avoided), and arranges all of them in a single data frame by date. Finally, it saves the data frame in an csv.
