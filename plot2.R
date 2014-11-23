# Set the working directory
setwd("~/Exploratory-Data-Analysis/Project_2")

# Read the EPA's National Emission Inventory - PM2.5 Emissions Data
NEI <- readRDS("summarySCC_PM25.rds")
# Read the Source Classification Code Table
SCC <- readRDS("Source_Classification_Code.rds")

# Subset Baltimore Emissions by Year
BaltimoreEmissions <- NEI[NEI$fips == 24510, ]
BaltimoreEmissionsByYear <- tapply(BaltimoreEmissions$Emissions, BaltimoreEmissions$year, sum)

# Open the plot device (PNG file).
png(filename = "plot2.png", width = 640, height = 640, units = "px", bg = "white")

# Bar plot Baltimore PM2.5 Emissions by Year
plot <- barplot(BaltimoreEmissionsByYear,            
                names.arg = names(BaltimoreEmissionsByYear),
                main = "Total PM2.5 Emissions in Baltimore, 1999 - 2008",
                xlab = "Year",
                ylab = "PM2.5 Emissions (Tons)",        
                sub = "Data Provided by EPA's National Emissions Inventory",
                legend.text = TRUE,        
                args.legend = list(title = "Year", x = "topright", cex = 0.75),
                col = c("red", "blue", "green", "yellow"),
                ylim = c(0, 4000),
                cex.sub = 0.75,
                cex.names = 0.75,
                cex.axis = 0.75)

text(plot, 
     BaltimoreEmissionsByYear, 
     labels = format(BaltimoreEmissionsByYear, 4),
     pos = 3, 
     cex = 1)

lines(plot, 
      BaltimoreEmissionsByYear,
      lw = 3, 
      col = "black", 
      type = "b", 
      lty = 2, 
      cex = 1)

# Shut down graphic device.
dev.off()
