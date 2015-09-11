warnSetting = options("warn")

options("warn" = -1)

# Loads core functions if required
if (!exists("drawPlot3")) {
    source("core.R");
}

# Draw Plot to PNG file (function drawPlot3 is located in core.R)
outputPlot(drawPlot3, getData(), "plot3.png");

message("plot3.png has been created.")

options("warn" = warnSetting[[1]])
rm(warnSetting)