warnSetting = options("warn")

options("warn" = -1)

# Loads core functions if required
if (!exists("drawPlot2")) {
    source("core.R");
}

# Draw Plot to PNG file (function drawPlot2 is located in core.R)
outputPlot(drawPlot2, getData(), "plot2.png");

message("plot2.png has been created.")

options("warn" = warnSetting[[1]])
rm(warnSetting)