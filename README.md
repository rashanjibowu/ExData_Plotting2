### About this repository

This repository holds code that analyzes data about PM2.5 emissions in the United States. The analysis was performed as part of Coursera's Exploratory Data Analysis course.

#### The Code

The code is broken up into 6 standalone R scripts (```plot1.R```, ```plot2.R```, etc.). Each script is capable of downloading the necessary data (if you don't already have it), crunching some numbers, and generating plots that show the relationship between emissions and time.

**Running the code**  

1. First, fork and clone the repo to your local computer.  
2. Load the source code for one of the scripts into memory using ``` source```.  
3. Run the script using the name of the file (i.e., ```plot1()```). 
4. Wait a few seconds so that the analysis completes and the plot is generated
5. Within your working directory, check for a "plots" directory, which should now have the plot in .png format

Here is an example:

```
## The below code will produce plot 5
source("plot5.R")
plot5()

## Check your "plots" directory within your working directory after a few seconds
```

#### The Analysis

**After running each script, you should be able to see the following plots in a "plots" directory within this repo**

- Plot 1: Total PM2.5 emissions in the `United States` from 1999 to 2008
- Plot 2: Total PM2.5 emissions in `Baltimore, MD` from 1999 to 2008
- Plot 3: Comparison of PM2.5 emissions trends from `4 sources` in `Baltimore, MD` from 1999 to 2008
- Plot 4: `Coal combustion-related` PM2.5 emissions trends in the `United States` from 1999 to 2008
- Plot 5: `Motor vehicle-related` PM2.5 emissions trends in `Baltimore, MD` from 1999-2008
- Plot 6: Comparison of `motor vehicle-related` emissions trends in `Baltimore and Los Angeles` from 1999 to 2008

