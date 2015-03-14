# This script is designed to answer the following question:

# Of the four types of sources indicated by the type (point, nonpoint,
# onroad, nonroad) variable, which of these four sources have seen decreases
# in emissions from 1999–2008 for Baltimore City? Which have seen increases
# in emissions from 1999–2008? Use the ggplot2 plotting system to make a
# plot answer this question.

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

# Prepares and draws plot 3
drawPlot <- function() {

    plotData <- merged[fips == "24510", list(totalEmissions = sum(Emissions)), by = c("year", "type")]

    # plot parameters
    title <- expression("Total " * PM[2.5] * " Emissions in Baltimore By Source Type")
    yLabel <- expression("Total " * PM[2.5] * " Emissions (tons)")
    xLabel <- c("Year")

    # create directory if it does not already exist
    if (!file.exists(plot.basePath)) {
        print("Creating directory for the plots...")
        dir.create(plot.basePath)
    }

    # output plot to the png graphics device
    png(file = paste0(plot.basePath, "plot3.png"), bg = "transparent")

    plot.new()
    g <- ggplot(plotData, aes(year, totalEmissions))
    gPlot = g + geom_line() +
        facet_grid(type ~ .) +
        ggtitle(title) +
        labs(x = xLabel) +
        labs(y = expression("Total " * PM[2.5] * " Emissions (tons)")) +
        scale_x_continuous(breaks = plotData$year)

    print(gPlot)

    dev.off()

    print(paste("Plot 3 has been written to", plot.basePath, sep = " "))
}

# full program
plot3 <- function(){

    downloadData()

    loadData()

    cleanData()

    drawPlot()

}