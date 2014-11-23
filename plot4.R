library(plyr) 
library(reshape2)
library(ggplot2)

# Set the working directory
setwd("~/Exploratory-Data-Analysis/Project_2")

# Read the EPA's National Emission Inventory - PM2.5 Emissions Data
NEI <- readRDS("summarySCC_PM25.rds")
# Read the Source Classification Code Table
SCC <- readRDS("Source_Classification_Code.rds")

# Select set of Combustion ... Coal sector names
sectors <- unique(SCC[,"EI.Sector"])
coalCombustionSectors <- sectors[grep("Coal", sectors, ignore.case=TRUE)]

# Subset Coal Combustion Sources and Emissions
coalCombustionSources <- SCC[SCC$EI.Sector %in% coalCombustionSectors, ]
coalCombustionEmmisions <- NEI[NEI$SCC %in% coalCombustionSources$SCC,]

# Sum Coal Combustion Emissions by Year
coalCombustionEmmisions <- aggregate(Emissions ~ year, coalCombustionEmmisions, sum)

# Open plot file
png(filename = "plot4.png", width = 640, height = 640, units="px")

# Plot graph of Coal Combustion Emissions
p <- ggplot(data = coalCombustionEmmisions, aes(x = year, y = Emissions)) 
p <- p + geom_line() 
p <- p + geom_point(size = 4, shape = 21, fill ="white") 
p <- p + geom_text(aes(label = round(Emissions, 0)), size = 4, hjust = 0.5, vjust = 2, colour = "blue")
p <- p + xlab("Year") 
p <- p + ylab("Emissions (Tons)") 
p <- p + ggtitle("United States PM2.5 Coal Emissions 1999-2008")

print(p)

#  Conclude drawing on graphic device
dev.off()