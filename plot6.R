# This script is designed to answer the following question:

# Compare emissions from motor vehicle sources in Baltimore City with
# emissions from motor vehicle sources in Los Angeles County, California
# (fips == "06037"). Which city has seen greater changes over time in motor
# vehicle emissions?

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

# Prepares and draws plot 6
drawPlot <- function() {

    ## prepare data

    # filter for motor vehicle sources
    motorVehicleRelatedFilter <- grep("Motor Vehicles|Motorcycle", merged$SCC.Level.Three)
    motorVehicleRelated <- merged[motorVehicleRelatedFilter, ]

    # filter for Baltimore City and Los Angeles County
    plotData <- motorVehicleRelated[fips %in% c("24510", "06037"), list(totalEmissions = sum(Emissions)), by = c("year", "fips")]

    # order by year
    plotData <- plotData[order(year),]

    # create city names
    plotData[,city:= ifelse((fips == "24510"), c("Baltimore"), c("Los Angeles"))]

    # plot parameters
    yLabel <- expression("Total " * PM[2.5] * " Emissions (tons)")
    title <- expression("Motor Vehicle-Related " * PM[2.5] * " Emissions: Baltimore vs. Los Angeles")
    xLabel <- c("Year")

    # output plot to the png graphics device
    trellis.device(device="png", filename = paste0(plot.basePath, "plot6.png"))

    # draw plot
    print(xyplot(totalEmissions ~ year | city,
           data = plotData,
           main = title,
           ylab = yLabel,
           xlab = xLabel,
           type = "b",
           scales = list(x = list(at = plotData$year, labels = plotData$year))))

    dev.off()

    print(paste("Plot 6 has been written to", plot.basePath, sep = " "))
}

plot6 <- function(){

    downloadData()

    loadData()

    cleanData()

    drawPlot()

}