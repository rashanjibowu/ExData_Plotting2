# This script is designed to answer the following question:

# Across the United States, how have emissions from coal combustion-related
# sources changed from 1999–2008?

# load necessary libraries
library(data.table)
library(ggplot2)
library(lattice)

data.basePath <- c("./data/")
plot.basePath <- c("./plots/")

# data.table handles
nei <- NULL
scc <- NULL
merged <- NULL

# if necessary, downloads and unzips data into a local "data" directory
downloadData <- function() {

    url <- c("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip")

    fileSummary.path <- paste0(data.basePath, c("summarySCC_PM25.rds"))
    fileClassCodes.path <- paste0(data.basePath, c("Source_Classification_Code.rds"))

    if (!file.exists(fileSummary.path) || !file.exists(fileClassCodes.path)) {
        print("Downloading data...")
        dir.create("./data/")
        download.file(url, destfile = "./data/NEIData.zip", method = "curl")
        unzip("./data/NEIData.zip")
        print("Download complete!")
    }

}

# loads data into memory from disk and converts data into data tables
loadData <- function() {

    print("Loading data...")
    NEI <- readRDS(paste0(data.basePath, "summarySCC_PM25.rds"))
    SCC <- readRDS(paste0(data.basePath, "Source_Classification_Code.rds"))

    # convert to data tables
    nei <<- data.table(NEI)
    scc <<- data.table(SCC)

    print("Data fully loaded!")
}

# Cleans and merges data into a single data table
cleanData <- function() {

    print("Cleaning and merging data...")
    setkey(nei, SCC)
    setkey(scc, SCC)
    merged <<- merge(x = nei, y = scc, by = c("SCC"), all.x = TRUE)

    print("Data is cleaned and merged")

    str(merged)
}

# Prepares and draws plot 4
drawPlot <- function() {



    # prepare the data
    coalRelated <- grep("Coal", merged$EI.Sector)
    plotData <- merged[coalRelated, list(totalEmissions = sum(Emissions)), by = c("year")]

    title <- expression("Coal-Related " * PM[2.5] * " Emissions By Year")
    xLabel <- c("Year")
    yLabel <- expression("Total " * PM[2.5] * " Emissions (tons)")

    # create directory if it does not already exist
    if (!file.exists(plot.basePath)) {
        print("Creating directory for the plots...")
        dir.create(plot.basePath)
    }

    # output plot to the png graphics device
    png(file = paste0(plot.basePath, "plot4.png"), bg = "transparent")

    plot(plotData[order(year),],
         main = title,
         type = "b",
         col = "steelblue",
         xaxt = "n",
         xlab = xLabel,
         ylab = yLabel)

    axis(side = 1, at = plotData$year, labels = plotData$year, las = 0)

    dev.off()

    print(paste("Plot 4 has been written to", plot.basePath, sep = " "))
}

# full program
plot4 <- function(){

    downloadData()

    loadData()

    cleanData()

    drawPlot()

}