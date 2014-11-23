library(plyr) 
library(reshape2)
library(ggplot2)

# Set the working directory
setwd("~/Exploratory-Data-Analysis/Project_2")

# Read the EPA's National Emission Inventory - PM2.5 Emissions Data
NEI <- readRDS("summarySCC_PM25.rds")
# Read the Source Classification Code Table
SCC <- readRDS("Source_Classification_Code.rds")

# Subset Baltimore emissions
BaltimoreEmissions <- subset(NEI, fips == "24510")

# Split the PM2.5 emissions in Baltimore dataset into two column frame year and type, with melt() function
BaltimoreEmissionsByYearAndType <- melt(BaltimoreEmissions, id.vars = c("year","type"), measure.vars="Emissions")
# Sum the PM2.5 emmmissions in Baltimore by year and type variable with dcast() function
BaltimoreEmissionsByYearAndTypeSum <- dcast(BaltimoreEmissionsByYearAndType, year + type ~ variable, fun.aggregate = sum, na.rm = TRUE)

# Open plot file
png(filename = "plot3.png", width = 640, height = 640, units="px")

# Draw the graph of Baltimore PM2.5 emissions by Year and Type
p <- ggplot(data = BaltimoreEmissionsByYearAndTypeSum, aes(x = year, y = Emissions, group = type, color = type)) 
p <- p + geom_line()
p <- p + geom_point(size = 4, shape = 21, fill = "white") 
p <- p + geom_text(aes(label = round(Emissions, 0)), size = 4, hjust = 0.5, vjust = 2, colour = "blue")
p <- p + xlab("Year") 
p <- p + ylab("Emissions (Tons)") 
p <- p + ggtitle("Baltimore PM2.5 Emissions by Year and Type")

print(p)

#  Conclude drawing on graphic device
dev.off()
