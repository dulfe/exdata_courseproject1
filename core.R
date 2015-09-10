# Downloads the data from the remote server if the file does not exists (and uncompress it)
#
# fileName: File name to be created based on the remote payload.
downloadData <- function(fileName) {
    if (!file.exists(fileName)) {
        message("Downloading data...");
        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", fileName);

        message("Uncompressing data...");
        unzip(fileName);
    }
}

# Process the data (Loads, transform, filters and creates a cache file)
#
# fileName: Full Data file name
# cacheFileName: Cache file name
processData <- function (fileName, cacheFileName) {
    message("Loading data...");
    fullData <- read.table(fileName, TRUE, ";", na.strings="?");

    message("Transforming...");
    fullData$DateTime <- strptime(paste(fullData$Date, fullData$Time), "%d/%m/%Y %H:%M:%S")
    fullData$Date = as.Date(fullData$Date, "%d/%m/%Y");

    message("Filtering...");
    data <- subset(fullData, fullData$Date >= as.Date("2007-2-1") & fullData$Date <= as.Date("2007-2-2"));

    message("Cleaning...");
    rm(fullData);

    message("Saving processed data (cache)...");
    write.csv(data, cacheFileName, row.names = FALSE);

    message("Data processed");
    data;
}

# Reads the cache file and applies transformations.
#
# cacheFileName: Cache file name
getCachedData <- function(cacheFileName) {
    data <- read.csv(cacheFileName);

    data$DateTime <- strptime(paste(data$Date, data$Time), "%Y-%m-%d %H:%M:%S")
    data$Date = as.Date(data$Date, "%Y-%m-%d");

    data;
}

# Gets the data either from the remote server or the cache file.
getData <- function () {
    reload = TRUE;
    compressedFileName = "household_power_consumption.zip";
    uncompressFileName = "household_power_consumption.txt";
    cacheFileName = "household_power_consumption_cached.csv";

    # The DataSource is huge and it takes a lot of time to load/transform,
    # so, I added a cache to the program to make it run faster.
    if (file.exists(cacheFileName)) {
        reload = FALSE;
        message(paste("Pre-Processed data file found. If you do not want to use it, please delete:", cacheFileName))
    }

    if (reload) {
        downloadData(compressedFileName);

        if (!file.exists(uncompressFileName)) {
            stop("Data file could not be found be downloaded or uncompressed. Please tray again later.");
        }

        data <- processData(uncompressFileName, cacheFileName);
    }
    else {
        data <- getCachedData(cacheFileName);
    }

    data;
}

# Draws Plot 1 (used on plot1.R)
#
# data: Data to be plotted
drawPlot1 <- function (data) {
    # Add plots to PNG (active device)
    hist(data$Global_active_power,
         main = "Global Active Power",
         xlab = "Global Active Power (kilowatts)",
         col = "Red");
}

# Draws Plot 2 (used on plot2.R and this one)
#
# data: Data to be plotted
drawPlot2 <- function (data, yLabel = "Global Active Power (killowatts)") {
    plot(data$DateTime,                              # X Axys - Column with Date and Time merged
         data$Global_active_power,                   # Y Axys
         type="l",                                   # Line Graph
         ylab = yLabel,                              # Y Axis Label
         xlab="")                                    # X Axis Label (none)
}

# Draws Plot 3 (used on plot3.R and this one)
#
# data: Data to be plotted
drawPlot3 <- function (data, boxType = "o") {
    # Add plot to PNG (active device) - Just the Shell
    plot(data$DateTime, data$Sub_metering_1, type="n", xlab = "", ylab = "Enery sub metering")

    # Add the 1st line
    points(data$DateTime, data$Sub_metering_1, type="l", col="gray50")

    # Add the 2nd line
    points(data$DateTime, data$Sub_metering_2, type="l", col="red")

    # Add the 3rd line
    points(data$DateTime, data$Sub_metering_3, type="l", col="blue")

    # Add the Legend
    legend("topright",                                                # Location
           c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),   # Text
           col = c("gray50", "red", "blue"),                          # Colors
           lwd = 1,                                                   # Line width
           bty = boxType                                              # Box around legend
           );
}

# Draws Plot 4 (used on plot4.R)
#
# data: Data to be plotted
drawPlot4 <- function(data) {
    # Storing current setting
    oldSetting = par("mfcol");

    # Show 2x2 plots
    par(mfcol = c(2,2));

    # Draw Plots
    drawPlot2(data, "Global Active Power");
    drawPlot3(data, "n");
    drawPlot4_TopRight(data);
    drawPlot4_BottomRight(data);

    # Restoring old setting
    par(mfcol = oldSetting);
}

# Draws Top-Right Plot inside Plot 4
#
# data: Data to be plotted
drawPlot4_TopRight <- function (data) {
    plot(data$DateTime,                              # X Axis - Column with Date and Time merged
         data$Voltage,                               # Y Axis
         type = "l",                                 # Line Graph
         ylab = "Voltage",                           # Y Axis Label
         xlab = "datetime")                          # X Axis Label (none)
}

# Draws Bottom-Right Plot inside Plot 4
#
# data: Data to be plotted
drawPlot4_BottomRight <- function (data) {
    plot(data$DateTime,                              # X Axis - Column with Date and Time merged
         data$Global_reactive_power,                 # Y Axis
         type = "l",                                 # Line Graph
         xlab = "datetime")                          # X Axis Label (none)
}

# Helper method to generate PNG using the supplied plotFunc and data
#
# plotFunc : Function that actually draws the plot
# data     : Data to be plotted
# filename : PNG File name to be generated
outputPlot <- function (plotFunc, data, filename) {
    #fun <- match.fun(plotFunc);

    png(filename, 480, 480)

    plotFunc(data);

    dev.off();
}
