warnSetting = options("warn")

options("warn" = -1)

# Loads core functions if required
if (!exists("drawPlot4")) {
    source("core.R");
}

# Draw Plot to PNG file (function drawPlot4 is located in core.R)
outputPlot(drawPlot4, getData(), "plot4.png");

message("plot4.png has been created.")

options("warn" = warnSetting[[1]])
rm(warnSetting)