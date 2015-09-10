# Loads core functions if required
if (!exists("drawPlot1")) {
    source("core.R");
}

# Draw Plot to PNG file (function drawPlot1 is located in core.R)
outputPlot(drawPlot1, getData(), "plot1.png");

message("plot1.png has been created.")