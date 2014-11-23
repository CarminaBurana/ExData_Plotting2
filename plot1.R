# Set the working directory
setwd("~/Exploratory-Data-Analysis/Project_2")

# Read the EPA's National Emission Inventory - PM2.5 Emissions Data
NEI <- readRDS("summarySCC_PM25.rds")
# Read the Source Classification Code Table
SCC <- readRDS("Source_Classification_Code.rds")

# Sum Total Emissions by Year
TotalEmissionsByYear <- tapply(NEI$Emissions, NEI$year, sum)

# Open the plot device (PNG file).
png(filename = "plot1.png", width = 640, height = 640, units = "px", bg = "white")

# Plot Total PM2.5 Emissions in USA between 1999 and 2008
plot <- barplot(TotalEmissionsByYear,            
        names.arg = names(TotalEmissionsByYear),
        main = "Total PM2.5 Emissions in USA, 1999 - 2008",
        xlab = "Year",
        ylab = "PM2.5 Emissions (Tons)",        
        sub = "Data Provided by EPA's National Emissions Inventory",
        legend.text = TRUE,        
        args.legend = list(title = "Year", x = "topright", cex = 0.75),
        col = c("red", "blue", "green", "yellow"),
        ylim = c(0, 8000000),
        cex.sub = 0.75,
        cex.names = 0.75,
        cex.axis = 0.75)

text(plot, 
     TotalEmissionsByYear, 
     labels = format(TotalEmissionsByYear, 4),
     pos = 3, 
     cex = 1)

lines(plot, 
      TotalEmissionsByYear,
      lw = 3, 
      col = "black", 
      type = "b", 
      lty = 2, 
      cex = 1)

# Shut down graphic device.
dev.off()


